#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

exec "$SCRIPT_DIR/init-openclaw-group.sh" \
  --fragment "$REPO_ROOT/config/openclaw-xiaohongshu-ops-delegation-example.json" \
  --source-root "$REPO_ROOT/3、Content Ops/xiaohongshu" \
  --source-root "$REPO_ROOT/2、Digital Workforce/1、Company Manger/6-content-ops-assistant" \
  "$@"
