#!/usr/bin/env bash
#
# migrate-digital-workforce.sh — 将 2、Digital Workforce 根目录下的智能体按映射表迁移到对应编号子目录。
# 若目标子目录下已存在同名 slug，则跳过（保留现有），不覆盖。
#
# 依赖：scripts/digital-workforce-classification.conf（格式：slug<TAB>子目录名）
# 用法：在 openclaw-agents 根目录执行：./scripts/migrate-digital-workforce.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$(cd "$SCRIPT_DIR/.." && pwd)"
DIR_2="$BASE/2、Digital Workforce"
CONF="$SCRIPT_DIR/digital-workforce-classification.conf"

if [[ ! -f "$CONF" ]]; then
  echo "Missing $CONF. Create slug -> subdir mapping first." >&2
  exit 1
fi

if [[ ! -d "$DIR_2" ]]; then
  echo "Missing $DIR_2." >&2
  exit 1
fi

moved=0
skipped=0
nomap=0

while IFS= read -r line; do
  line="${line%%#*}"
  line="$(printf '%s' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$line" ]] && continue

  slug="${line%%$'\t'*}"
  subdir="${line#*$'\t'}"
  if [[ "$subdir" == "$line" ]]; then
    subdir="${line#* }"
  fi
  subdir="$(printf '%s' "$subdir" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$slug" || -z "$subdir" ]] && continue

  src="$DIR_2/$slug"
  dest_dir="$DIR_2/$subdir"
  dest="$dest_dir/$slug"

  if [[ ! -d "$src" ]]; then
    continue
  fi

  if [[ "$src" == "$DIR_2/README.md" ]] || [[ "$slug" == "README.md" ]]; then
    continue
  fi

  if [[ -d "$dest" ]]; then
    echo "  Skip (exists): $subdir/$slug — remove root duplicate"
    rm -rf "$src"
    (( skipped++ )) || true
    continue
  fi

  if [[ ! -d "$dest_dir" ]]; then
    echo "  Warn: target dir missing, skip: $subdir" >&2
    (( nomap++ )) || true
    continue
  fi

  echo "  Move: $slug -> $subdir/"
  mv "$src" "$dest"
  (( moved++ )) || true
done < "$CONF"

echo ""
echo "Summary: moved $moved, skipped (already exists) $skipped, no-target $nomap."
