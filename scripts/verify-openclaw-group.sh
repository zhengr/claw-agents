#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./openclaw-bootstrap-lib.sh
source "$SCRIPT_DIR/openclaw-bootstrap-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/verify-openclaw-group.sh \
    --fragment <config-fragment.json> \
    --source-root <dir> \
    [--source-root <dir> ...] \
    [--agent-id <id> ...] \
    [--workspace-root <dir>] \
    [--state-dir <dir>] \
    [--config-path <file>] \
    [--workspace-pattern <pattern>] \
    [--agent-dir-pattern <pattern>] \
    [--smoke-agent <id>] \
    [--smoke-prompt <text>] \
    [--require-smoke-turn]
EOF
}

oc_require_commands openclaw jq rsync realpath

fragment_path=""
workspace_root="$(oc_default_workspace_root)"
state_dir=""
config_path=""
workspace_pattern=""
agent_dir_pattern=""
smoke_agent=""
smoke_prompt="Who are you? Answer in one sentence."
require_smoke_turn=0
declare -a source_roots=()
declare -a selected_agents=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fragment)
      fragment_path="${2:-}"
      shift 2
      ;;
    --source-root)
      source_roots+=("${2:-}")
      shift 2
      ;;
    --agent-id)
      selected_agents+=("${2:-}")
      shift 2
      ;;
    --workspace-root)
      workspace_root="${2:-}"
      shift 2
      ;;
    --state-dir)
      state_dir="${2:-}"
      shift 2
      ;;
    --config-path)
      config_path="${2:-}"
      shift 2
      ;;
    --workspace-pattern)
      workspace_pattern="${2:-}"
      shift 2
      ;;
    --agent-dir-pattern)
      agent_dir_pattern="${2:-}"
      shift 2
      ;;
    --smoke-agent)
      smoke_agent="${2:-}"
      shift 2
      ;;
    --smoke-prompt)
      smoke_prompt="${2:-}"
      shift 2
      ;;
    --require-smoke-turn)
      require_smoke_turn=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      oc_die "Unknown argument: $1"
      ;;
  esac
done

[[ -n "$fragment_path" ]] || oc_die "--fragment is required"
[[ "${#source_roots[@]}" -gt 0 ]] || oc_die "At least one --source-root is required"

fragment_path="$(oc_abs "$fragment_path")"
[[ -f "$fragment_path" ]] || oc_die "Fragment does not exist: $fragment_path"

workspace_root="$(oc_abs "$workspace_root")"
state_dir="$(oc_abs "${state_dir:-$(oc_default_state_dir "$workspace_root")}")"
config_path="$(oc_abs "${config_path:-$(oc_default_config_path "$workspace_root")}")"
if [[ -z "$workspace_pattern" ]]; then
  workspace_pattern="$workspace_root/workspace-{id}"
fi
if [[ -z "$agent_dir_pattern" ]]; then
  agent_dir_pattern="$state_dir/agents/{id}/agent"
fi

for index in "${!source_roots[@]}"; do
  source_roots[$index]="$(oc_abs "${source_roots[$index]}")"
done

declare -a agent_ids=()
if [[ "${#selected_agents[@]}" -gt 0 ]]; then
  agent_ids=("${selected_agents[@]}")
else
  while IFS= read -r agent_id; do
    [[ -n "$agent_id" ]] && agent_ids+=("$agent_id")
  done < <(oc_fragment_agent_ids "$fragment_path")
fi

[[ -f "$config_path" ]] || oc_die "Config file does not exist: $config_path"

failures=0

for agent_id in "${agent_ids[@]}"; do
  source_dir="$(oc_resolve_source_dir "$agent_id" "${source_roots[@]}")"
  expected_workspace="$(oc_apply_pattern "$workspace_pattern" "$agent_id")"
  expected_agent_dir="$(oc_apply_pattern "$agent_dir_pattern" "$agent_id")"
  expected_agent_json="$(oc_finalize_agent_json "$fragment_path" "$agent_id" "$expected_workspace" "$expected_agent_dir")"

  if ! oc_agent_exists "$config_path" "$agent_id"; then
    oc_warn "Missing config entry for $agent_id"
    failures=$((failures + 1))
    continue
  fi

  actual_agent_json="$(oc_config_agent_json "$config_path" "$agent_id")"
  actual_workspace="$(jq -r '.workspace // ""' <<<"$actual_agent_json")"
  actual_agent_dir="$(jq -r '.agentDir // ""' <<<"$actual_agent_json")"

  if [[ "$actual_workspace" != "$expected_workspace" ]]; then
    oc_warn "Workspace mismatch for $agent_id: expected $expected_workspace, got $actual_workspace"
    failures=$((failures + 1))
  fi

  if [[ "$actual_agent_dir" != "$expected_agent_dir" ]]; then
    oc_warn "agentDir mismatch for $agent_id: expected $expected_agent_dir, got $actual_agent_dir"
    failures=$((failures + 1))
  fi

  expected_compare="$(oc_agent_compare_subset <<<"$expected_agent_json")"
  actual_compare="$(oc_agent_compare_subset <<<"$actual_agent_json")"
  if [[ "$expected_compare" != "$actual_compare" ]]; then
    oc_warn "Config payload mismatch for $agent_id"
    oc_warn "  expected: $expected_compare"
    oc_warn "  actual  : $actual_compare"
    failures=$((failures + 1))
  fi

  if [[ ! -d "$expected_workspace" ]]; then
    oc_warn "Workspace directory missing for $agent_id: $expected_workspace"
    failures=$((failures + 1))
    continue
  fi

  diff_output="$(oc_workspace_diff "$source_dir" "$expected_workspace" || true)"
  if [[ -n "$diff_output" ]]; then
    oc_warn "Workspace content drift detected for $agent_id"
    printf '%s\n' "$diff_output" >&2
    failures=$((failures + 1))
  else
    oc_log "Workspace verified for $agent_id"
  fi
done

if [[ -n "$smoke_agent" ]]; then
  oc_log "Running local smoke turn for $smoke_agent"
  if ! OPENCLAW_CONFIG_PATH="$config_path" OPENCLAW_STATE_DIR="$state_dir" \
    openclaw agent --local --agent "$smoke_agent" --message "$smoke_prompt" --json --thinking minimal --timeout 90 >/tmp/openclaw-smoke-output.json 2>/tmp/openclaw-smoke-error.log; then
    oc_warn "Local smoke turn failed for $smoke_agent"
    if [[ -s /tmp/openclaw-smoke-error.log ]]; then
      sed -n '1,40p' /tmp/openclaw-smoke-error.log >&2
    fi
    if [[ "$require_smoke_turn" -eq 1 ]]; then
      failures=$((failures + 1))
    fi
  else
    oc_log "Local smoke turn succeeded for $smoke_agent"
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  oc_die "Verification failed with $failures issue(s)"
fi

oc_log "Verification passed"
