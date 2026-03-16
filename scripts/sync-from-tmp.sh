#!/usr/bin/env bash
#
# sync-from-tmp.sh — 对比 tmp/openclaw 与 1/2/3，删除同名后按规则分类移动到 1 或 2。
# 依赖：已执行 convert.sh --tool openclaw --out .../tmp，存在 openclaw-agents/tmp/openclaw/<slug>/。
#
# 用法：在 openclaw-agents 根目录执行：./scripts/sync-from-tmp.sh
# 或：bash /path/to/openclaw-agents/scripts/sync-from-tmp.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_OPENCLAW="$BASE/tmp/openclaw"
DIR_1="$BASE/1、IM Channels"
DIR_2="$BASE/2、Digital Workforce"
DIR_3="$BASE/3、Content Ops"

# IM 关键词（name/description 匹配其一则归入 1、IM Channels）
IM_KEYWORDS='Feishu|飞书|Discord|Telegram|Slack|IM\b|channel\b|群聊|即时通讯|Lark'

if [[ ! -d "$TMP_OPENCLAW" ]]; then
  echo "Missing $TMP_OPENCLAW. Run convert.sh --tool openclaw --out $BASE/tmp first." >&2
  exit 1
fi

# --- 1) 收集 tmp 的 slug 列表
tmp_slugs=()
while IFS= read -r -d '' d; do
  tmp_slugs+=("$(basename "$d")")
done < <(find "$TMP_OPENCLAW" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
echo "[1] Tmp slugs: ${#tmp_slugs[@]}"

# --- 2) 收集 1 下的一级目录名（同名即 slug 在 1 中出现）
names_in_1=()
for d in "$DIR_1"/*; do
  [[ -d "$d" ]] && names_in_1+=("$(basename "$d")")
done

# --- 3) 收集 2 下所有子目录的「规范化 slug」及对应绝对路径（同一 slug 可能有多条路径）
# 规范化：若目录名为 N-<slug> 则取 <slug>，否则取目录名（兼容 macOS bash 3.x，不用 declare -A）
same_in_2_paths=()
while IFS= read -r -d '' d; do
  b="$(basename "$d")"
  if [[ "$b" =~ ^[0-9]+-(.+)$ ]]; then
    slug="${BASH_REMATCH[1]}"
  else
    slug="$b"
  fi
  for s in "${tmp_slugs[@]}"; do
    if [[ "$s" == "$slug" ]]; then
      same_in_2_paths+=("$d")
      break
    fi
  done
done < <(find "$DIR_2" -type d -mindepth 2 -print0)

# --- 4) 求同名 in 1
same_in_1=()
for slug in "${tmp_slugs[@]}"; do
  for n in "${names_in_1[@]}"; do
    if [[ "$n" == "$slug" ]]; then
      same_in_1+=("$slug")
      break
    fi
  done
done

echo "[2] Dirs in 1: ${#names_in_1[@]}, paths in 2 to remove (same slug as tmp): ${#same_in_2_paths[@]}"
echo "[3] Same-name in 1: ${#same_in_1[@]} (${same_in_1[*]:-none})"

# --- 5) 删除 1 与 2 下同名
for slug in ${same_in_1[@]+"${same_in_1[@]}"}; do
  [[ -z "$slug" ]] && continue
  p="$DIR_1/$slug"
  if [[ -d "$p" ]]; then
    echo "  Remove (1): $p"
    rm -rf "$p"
  fi
done
for p in ${same_in_2_paths[@]+"${same_in_2_paths[@]}"}; do
  [[ -z "$p" ]] && continue
  if [[ -d "$p" ]]; then
    echo "  Remove (2): $p"
    rm -rf "$p"
  fi
done

# --- 6) 分类并移动：每个 tmp slug 读 IDENTITY.md 或 SOUL.md，匹配 IM 关键词 -> 1，否则 -> 2（方案 A：2 下直接 <slug>）
to_1=()
to_2=()
for slug in "${tmp_slugs[@]}"; do
  src="$TMP_OPENCLAW/$slug"
  [[ -d "$src" ]] || continue
  text=""
  for f in "$src/IDENTITY.md" "$src/SOUL.md"; do
    if [[ -f "$f" ]]; then
      text+=" $(head -n 5 "$f" 2>/dev/null)"
    fi
  done
  if [[ "$text" =~ $IM_KEYWORDS ]]; then
    to_1+=("$slug")
  else
    to_2+=("$slug")
  fi
done

echo "[5] Classified to 1 (IM): ${#to_1[@]}, to 2 (Digital): ${#to_2[@]}"

for slug in "${to_1[@]}"; do
  src="$TMP_OPENCLAW/$slug"
  dst="$DIR_1/$slug"
  if [[ -d "$src" ]]; then
    echo "  Move to 1: $slug"
    mv "$src" "$dst"
  fi
done
for slug in "${to_2[@]}"; do
  src="$TMP_OPENCLAW/$slug"
  dst="$DIR_2/$slug"
  if [[ -d "$src" ]]; then
    echo "  Move to 2: $slug"
    mv "$src" "$dst"
  fi
done

# --- 7) 清理空目录
if [[ -d "$TMP_OPENCLAW" ]]; then
  rmdir "$TMP_OPENCLAW" 2>/dev/null || true
fi
if [[ -d "$BASE/tmp" ]]; then
  rmdir "$BASE/tmp" 2>/dev/null || true
fi
echo "[6] Done. Emptied tmp if possible."
echo "Summary: moved ${#to_1[@]} to 1、IM Channels, ${#to_2[@]} to 2、Digital Workforce."
