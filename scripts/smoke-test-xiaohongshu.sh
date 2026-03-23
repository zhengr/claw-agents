#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp_root="$(mktemp -d /tmp/openclaw-xiaohongshu-smoke.XXXXXX)"
workspace_root="$tmp_root/openclaw-home"
state_dir="$tmp_root/openclaw-state"
config_path="$workspace_root/openclaw.json"
run_local_turn=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-local-turn)
      run_local_turn=1
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage:
  ./scripts/smoke-test-xiaohongshu.sh [--with-local-turn]

This creates an isolated /tmp OpenClaw environment, bootstraps the full
Xiaohongshu pipeline, and runs structural verification. The temp directory is
left in place for inspection.
EOF
      exit 0
      ;;
    *)
      printf '[smoke-test-xiaohongshu][error] Unknown argument: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

printf '[smoke-test-xiaohongshu] temp root: %s\n' "$tmp_root"

"$SCRIPT_DIR/bootstrap-xiaohongshu-pipeline.sh" \
  --workspace-root "$workspace_root" \
  --state-dir "$state_dir" \
  --config-path "$config_path"

verify_args=(
  --workspace-root "$workspace_root"
  --state-dir "$state_dir"
  --config-path "$config_path"
)

if [[ "$run_local_turn" -eq 1 ]]; then
  verify_args+=(--smoke-agent xiaohongshu-ops-assistant --smoke-prompt "Who are you? Answer in one sentence.")
fi

"$SCRIPT_DIR/verify-xiaohongshu-pipeline.sh" "${verify_args[@]}"

printf '[smoke-test-xiaohongshu] success\n'
printf '[smoke-test-xiaohongshu] inspect config: %s\n' "$config_path"
