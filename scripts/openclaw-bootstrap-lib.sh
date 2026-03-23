#!/usr/bin/env bash

set -euo pipefail

oc_log() {
  printf '[openclaw-bootstrap] %s\n' "$*" >&2
}

oc_warn() {
  printf '[openclaw-bootstrap][warn] %s\n' "$*" >&2
}

oc_die() {
  printf '[openclaw-bootstrap][error] %s\n' "$*" >&2
  exit 1
}

oc_require_commands() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || oc_die "Missing required command: $cmd"
  done
}

oc_abs() {
  local target="$1"
  local parent_dir
  local base_name

  if [[ "$target" == "~"* ]]; then
    target="${HOME}${target#\~}"
  fi

  if [[ -e "$target" ]]; then
    realpath "$target"
    return
  fi

  parent_dir="$(dirname "$target")"
  base_name="$(basename "$target")"

  if [[ "$parent_dir" == "$target" ]]; then
    printf '%s\n' "$target"
    return
  fi

  printf '%s/%s\n' "$(oc_abs "$parent_dir")" "$base_name"
}

oc_default_workspace_root() {
  if [[ -n "${OPENCLAW_HOME:-}" ]]; then
    printf '%s\n' "${OPENCLAW_HOME}"
    return
  fi
  printf '%s/.openclaw\n' "${HOME}"
}

oc_default_state_dir() {
  if [[ -n "${OPENCLAW_STATE_DIR:-}" ]]; then
    printf '%s\n' "${OPENCLAW_STATE_DIR}"
    return
  fi
  printf '%s\n' "$1"
}

oc_default_config_path() {
  if [[ -n "${OPENCLAW_CONFIG_PATH:-}" ]]; then
    printf '%s\n' "${OPENCLAW_CONFIG_PATH}"
    return
  fi
  printf '%s/openclaw.json\n' "$1"
}

oc_apply_pattern() {
  local pattern="$1"
  local agent_id="$2"
  printf '%s\n' "$pattern" | sed "s/{id}/$agent_id/g"
}

oc_fragment_agent_ids() {
  local fragment_path="$1"
  jq -r '.agents.list[]?.id' "$fragment_path"
}

oc_fragment_agent_json() {
  local fragment_path="$1"
  local agent_id="$2"
  jq -ce --arg id "$agent_id" '.agents.list[] | select(.id == $id)' "$fragment_path"
}

oc_finalize_agent_json() {
  local fragment_path="$1"
  local agent_id="$2"
  local workspace_dir="$3"
  local agent_dir="$4"
  jq -ce \
    --arg id "$agent_id" \
    --arg workspace "$workspace_dir" \
    --arg agent_dir "$agent_dir" \
    '.agents.list[] | select(.id == $id) | del(.model) | .workspace = $workspace | .agentDir = $agent_dir' \
    "$fragment_path"
}

oc_ensure_parent_dir() {
  local target_path="$1"
  mkdir -p "$(dirname "$target_path")"
}

oc_ensure_json_file() {
  local target_path="$1"
  if [[ -f "$target_path" ]]; then
    return
  fi
  oc_ensure_parent_dir "$target_path"
  printf '{}\n' >"$target_path"
}

oc_agent_exists() {
  local config_path="$1"
  local agent_id="$2"
  [[ -f "$config_path" ]] || return 1
  jq -e --arg id "$agent_id" '((.agents.list // []) | map(select(.id == $id)) | length) > 0' "$config_path" >/dev/null
}

oc_config_agent_json() {
  local config_path="$1"
  local agent_id="$2"
  [[ -f "$config_path" ]] || return 1
  jq -ce --arg id "$agent_id" '((.agents.list // []) | map(select(.id == $id)) | .[0])' "$config_path"
}

oc_agent_compare_subset() {
  jq -c 'with_entries(select(.key == "name" or .key == "skills" or .key == "tools" or .key == "subagents" or .key == "default"))'
}

oc_merge_agent_into_config() {
  local config_path="$1"
  local agent_json="$2"
  local tmp_file

  oc_ensure_json_file "$config_path"
  tmp_file="$(mktemp)"
  jq \
    --argjson agent "$agent_json" \
    '
      .agents = (.agents // {}) |
      .agents.list = (
        (.agents.list // []) as $existing |
        if ([ $existing[]? | select(.id == $agent.id) ] | length) > 0
        then [ $existing[] | if .id == $agent.id then (. + $agent) else . end ]
        else $existing + [$agent]
        end
      )
    ' \
    "$config_path" >"$tmp_file"
  mv "$tmp_file" "$config_path"
}

oc_merge_bindings_into_config() {
  local config_path="$1"
  local bindings_json="$2"
  local tmp_file

  [[ "$(jq -r 'length' <<<"$bindings_json")" -gt 0 ]] || return 0
  oc_ensure_json_file "$config_path"
  tmp_file="$(mktemp)"
  jq \
    --argjson incoming "$bindings_json" \
    '
      .bindings = (
        (.bindings // []) as $existing |
        reduce $incoming[] as $binding ($existing;
          if ([ .[] | select(
            (.type // "") == ($binding.type // "") and
            (.agentId // "") == ($binding.agentId // "") and
            ((.match // {}) | tojson) == (($binding.match // {}) | tojson)
          ) ] | length) > 0
          then .
          else . + [$binding]
          end
        )
      )
    ' \
    "$config_path" >"$tmp_file"
  mv "$tmp_file" "$config_path"
}

oc_merge_tools_into_config() {
  local config_path="$1"
  local tools_json="$2"
  local tmp_file

  [[ "$(jq -r 'type' <<<"$tools_json")" == "object" ]] || oc_die "tools payload must be a JSON object"
  [[ "$(jq -r 'length' <<<"$tools_json")" -gt 0 ]] || return 0

  oc_ensure_json_file "$config_path"
  tmp_file="$(mktemp)"
  jq \
    --argjson incoming "$tools_json" \
    '.tools = ((.tools // {}) * $incoming)' \
    "$config_path" >"$tmp_file"
  mv "$tmp_file" "$config_path"
}

oc_sync_workspace() {
  local source_dir="$1"
  local workspace_dir="$2"
  local copy_mode="$3"
  local -a rsync_cmd

  mkdir -p "$workspace_dir"
  rsync_cmd=(rsync -a --exclude '.git' --exclude '.openclaw')
  if [[ "$copy_mode" == "mirror" ]]; then
    rsync_cmd+=(--delete)
  fi
  rsync_cmd+=("$source_dir"/ "$workspace_dir"/)
  "${rsync_cmd[@]}"
}

oc_workspace_diff() {
  local source_dir="$1"
  local workspace_dir="$2"
  rsync -ani --delete --exclude '.git' --exclude '.openclaw' "$source_dir"/ "$workspace_dir"/
}

oc_resolve_source_dir() {
  local agent_id="$1"
  shift

  local root
  local candidate
  local -a matches=()
  local -a unique_matches=()

  for root in "$@"; do
    [[ -d "$root" ]] || continue
    while IFS= read -r -d '' candidate; do
      matches+=("$(realpath "$candidate")")
    done < <(
      find "$root" -mindepth 1 -maxdepth 2 -type d \( -name "$agent_id" -o -name "*-$agent_id" \) -print0
    )
  done

  if [[ "${#matches[@]}" -eq 0 ]]; then
    oc_die "No source workspace found for agent '$agent_id'"
  fi

  while IFS= read -r candidate; do
    [[ -n "$candidate" ]] && unique_matches+=("$candidate")
  done < <(printf '%s\n' "${matches[@]}" | awk '!seen[$0]++')

  if [[ "${#unique_matches[@]}" -ne 1 ]]; then
    printf '[openclaw-bootstrap][error] Multiple source workspaces found for %s:\n' "$agent_id" >&2
    printf '  - %s\n' "${unique_matches[@]}" >&2
    exit 1
  fi

  printf '%s\n' "${unique_matches[0]}"
}
