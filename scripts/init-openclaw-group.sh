#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT_AGENT_SCRIPT="$SCRIPT_DIR/init-openclaw-agent.sh"
# shellcheck source=./openclaw-bootstrap-lib.sh
source "$SCRIPT_DIR/openclaw-bootstrap-lib.sh"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/init-openclaw-group.sh \
    --fragment <config-fragment.json> \
    --source-root <dir> \
    [--source-root <dir> ...] \
    [--agent-id <id> ...] \
    [--workspace-root <dir>] \
    [--state-dir <dir>] \
    [--config-path <file>] \
    [--workspace-pattern <pattern>] \
    [--agent-dir-pattern <pattern>] \
    [--copy-mode mirror|copy] \
    [--include-bindings] \
    [--merge-global-tools] \
    [--dry-run]

Examples:
  ./scripts/init-openclaw-group.sh \
    --fragment config/openclaw-xiaohongshu-fragment.json \
    --source-root '3、Content Ops/xiaohongshu'
EOF
}

oc_require_commands openclaw jq rsync realpath

fragment_path=""
workspace_root="$(oc_default_workspace_root)"
state_dir=""
config_path=""
workspace_pattern=""
agent_dir_pattern=""
copy_mode="mirror"
include_bindings=0
merge_global_tools=0
dry_run=0
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
    --copy-mode)
      copy_mode="${2:-}"
      shift 2
      ;;
    --include-bindings)
      include_bindings=1
      shift
      ;;
    --merge-global-tools)
      merge_global_tools=1
      shift
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

[[ -n "$fragment_path" ]] || oc_die "--fragment is required"
[[ "${#source_roots[@]}" -gt 0 ]] || oc_die "At least one --source-root is required"
[[ "$copy_mode" == "mirror" || "$copy_mode" == "copy" ]] || oc_die "--copy-mode must be mirror or copy"

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

[[ "${#agent_ids[@]}" -gt 0 ]] || oc_die "No agents selected from fragment"

for agent_id in "${agent_ids[@]}"; do
  source_dir="$(oc_resolve_source_dir "$agent_id" "${source_roots[@]}")"
  cmd=(
    "$INIT_AGENT_SCRIPT"
    --agent-id "$agent_id"
    --source-dir "$source_dir"
    --fragment "$fragment_path"
    --workspace-root "$workspace_root"
    --state-dir "$state_dir"
    --config-path "$config_path"
    --workspace-pattern "$workspace_pattern"
    --agent-dir-pattern "$agent_dir_pattern"
    --copy-mode "$copy_mode"
  )
  if [[ "$dry_run" -eq 1 ]]; then
    cmd+=(--dry-run)
  fi
  "${cmd[@]}"
done

if [[ "$dry_run" -eq 1 ]]; then
  exit 0
fi

if [[ "$merge_global_tools" -eq 1 ]]; then
  tools_json="$(jq -c '.tools // {}' "$fragment_path")"
  oc_log "Merging global tools from fragment"
  oc_merge_tools_into_config "$config_path" "$tools_json"
fi

if [[ "$include_bindings" -eq 1 ]]; then
  bindings_json="$(jq -c '.bindings // []' "$fragment_path")"
  oc_log "Merging bindings from fragment"
  oc_merge_bindings_into_config "$config_path" "$bindings_json"
fi

oc_log "Group bootstrap complete"
oc_log "  fragment   : $fragment_path"
oc_log "  config     : $config_path"
