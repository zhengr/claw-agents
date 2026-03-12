#!/usr/bin/env bash
# Check agent doc minimum line counts: AGENTS.md >= 100, BOOTSTRAP/SOUL/IDENTITY >= 50.
# Excludes docs/template-agent/.
# Usage: from repo root, ./scripts/check_agent_doc_min_lines.sh

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXCLUDE="docs/template-agent"
FAIL=0

while IFS= read -r f; do
  [[ ! -f "$f" ]] && continue
  if [[ "$f" == *"$EXCLUDE"* ]]; then continue; fi
  lines=$(wc -l < "$f" | tr -d ' ')
  if [[ "$f" == *AGENTS.md ]]; then
    if [[ "$lines" -lt 100 ]]; then echo "SHORT AGENTS.md ($lines < 100): $f"; FAIL=1; fi
  else
    if [[ "$lines" -lt 50 ]]; then echo "SHORT ($lines < 50): $f"; FAIL=1; fi
  fi
done < <(find "$ROOT" -type f \( -name 'AGENTS.md' -o -name 'BOOTSTRAP.md' -o -name 'SOUL.md' -o -name 'IDENTITY.md' \) 2>/dev/null)

if [[ $FAIL -eq 1 ]]; then exit 1; fi
echo "All checked files meet minimum line counts."
exit 0
