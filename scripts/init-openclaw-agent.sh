#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./openclaw-bootstrap-lib.sh
source "$SCRIPT_DIR/openclaw-bootstrap-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/init-openclaw-agent.sh \
    --agent-id <id> \
    --source-dir <workspace-template> \
    [--fragment <config-fragment.json>] \
    [--workspace-root <dir>] \
    [--state-dir <dir>] \
    [--config-path <file>] \
    [--workspace-pattern <pattern>] \
    [--agent-dir-pattern <pattern>] \
    [--copy-mode mirror|copy] \
    [--bind <channel[:accountId]>]... \
    [--name <display-name>] \
    [--dry-run]

Notes:
  - Default workspace pattern: <workspace-root>/workspace-{id}
  - Default agentDir pattern: <state-dir>/agents/{id}/agent
  - When --fragment is present, name/skills/tools/subagents/default come from the fragment entry.
  - Model is intentionally not managed by these bootstrap scripts; set it later in the user's own OpenClaw config if needed.
  - This script always uses `openclaw agents add` for first-time creation, then overlays the repo workspace files.
EOF
}

oc_require_commands openclaw jq rsync realpath

agent_id=""
source_dir=""
fragment_path=""
workspace_root="$(oc_default_workspace_root)"
state_dir=""
config_path=""
workspace_pattern=""
agent_dir_pattern=""
copy_mode="mirror"
agent_name=""
dry_run=0
declare -a binds=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent-id)
      agent_id="${2:-}"
      shift 2
      ;;
    --source-dir)
      source_dir="${2:-}"
      shift 2
      ;;
    --fragment)
      fragment_path="${2:-}"
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
    --copy-mode)
      copy_mode="${2:-}"
      shift 2
      ;;
    --bind)
      binds+=("${2:-}")
      shift 2
      ;;
    --name)
      agent_name="${2:-}"
      shift 2
      ;;
    --dry-run)
      dry_run=1
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

[[ -n "$agent_id" ]] || oc_die "--agent-id is required"
[[ -n "$source_dir" ]] || oc_die "--source-dir is required"
[[ "$copy_mode" == "mirror" || "$copy_mode" == "copy" ]] || oc_die "--copy-mode must be mirror or copy"

source_dir="$(oc_abs "$source_dir")"
[[ -d "$source_dir" ]] || oc_die "Source workspace does not exist: $source_dir"

workspace_root="$(oc_abs "$workspace_root")"
state_dir="$(oc_abs "${state_dir:-$(oc_default_state_dir "$workspace_root")}")"
config_path="$(oc_abs "${config_path:-$(oc_default_config_path "$workspace_root")}")"
if [[ -z "$workspace_pattern" ]]; then
  workspace_pattern="$workspace_root/workspace-{id}"
fi
if [[ -z "$agent_dir_pattern" ]]; then
  agent_dir_pattern="$state_dir/agents/{id}/agent"
fi

if [[ -n "$fragment_path" ]]; then
  fragment_path="$(oc_abs "$fragment_path")"
  [[ -f "$fragment_path" ]] || oc_die "Fragment does not exist: $fragment_path"
  agent_json="$(oc_finalize_agent_json "$fragment_path" "$agent_id" "$(oc_apply_pattern "$workspace_pattern" "$agent_id")" "$(oc_apply_pattern "$agent_dir_pattern" "$agent_id")")"
else
  [[ -n "$agent_name" ]] || agent_name="$agent_id"
  agent_json="$(jq -nc \
    --arg id "$agent_id" \
    --arg name "$agent_name" \
    --arg workspace "$(oc_apply_pattern "$workspace_pattern" "$agent_id")" \
    --arg agent_dir "$(oc_apply_pattern "$agent_dir_pattern" "$agent_id")" \
    '{id: $id, name: $name, workspace: $workspace, agentDir: $agent_dir}')"
fi

workspace_dir="$(jq -r '.workspace' <<<"$agent_json")"
agent_dir="$(jq -r '.agentDir' <<<"$agent_json")"
agent_root="$(dirname "$agent_dir")"

if [[ "$dry_run" -eq 1 ]]; then
  oc_log "Dry run for $agent_id"
  oc_log "  source     : $source_dir"
  oc_log "  workspace  : $workspace_dir"
  oc_log "  agentDir   : $agent_dir"
  oc_log "  config     : $config_path"
  printf '%s\n' "$agent_json"
  exit 0
fi

mkdir -p "$workspace_root" "$state_dir"

if oc_agent_exists "$config_path" "$agent_id"; then
  oc_log "Agent '$agent_id' already exists in config; refreshing workspace and config overlay"
  mkdir -p "$workspace_dir" "$agent_dir" "$agent_root/sessions"
else
  oc_log "Creating agent '$agent_id' via openclaw agents add"
  add_cmd=(
    openclaw
    agents
    add
    "$agent_id"
    --workspace "$workspace_dir"
    --agent-dir "$agent_dir"
    --non-interactive
  )
  if [[ "${#binds[@]}" -gt 0 ]]; then
    local_bind=""
    for local_bind in "${binds[@]}"; do
      add_cmd+=(--bind "$local_bind")
    done
  fi
  OPENCLAW_CONFIG_PATH="$config_path" OPENCLAW_STATE_DIR="$state_dir" "${add_cmd[@]}" >/dev/null
fi

oc_log "Syncing workspace files into $workspace_dir"
oc_sync_workspace "$source_dir" "$workspace_dir" "$copy_mode"

oc_log "Overlaying config entry for '$agent_id'"
oc_merge_agent_into_config "$config_path" "$agent_json"

oc_log "Done: $agent_id"
oc_log "  workspace  : $workspace_dir"
oc_log "  agentDir   : $agent_dir"
oc_log "  config     : $config_path"
