#!/usr/bin/env python3
"""
Sync long-form AGENTS.md and SOUL.md from content-ops/juejin to other platforms
with platform/role name replacement. Excludes docs/template-agent.
"""
from pathlib import Path
import re

BASE = Path(__file__).resolve().parent.parent / "content-ops"
JUEJIN = BASE / "juejin"

# (platform_key, display_name_en, display_name_zh)
PLATFORMS = [
    ("douyin", "Douyin", "抖音"),
    ("toutiao", "Toutiao", "头条"),
    ("weibo", "Weibo", "微博"),
    ("wechat-video", "WeChat Video", "微信视频号"),
    ("kuaishou", "Kuaishou", "快手"),
    ("zhihu", "Zhihu", "知乎"),
    ("xiaohongshu", "Xiaohongshu", "小红书"),
    ("wechat-article", "WeChat Article", "微信公众号"),
    ("baijiahao", "Baijiahao", "百家号"),
    ("bilibili", "Bilibili", "B站"),
]

# Juejin role dir names (order 1-7)
JUEJIN_ROLES = [
    "1-juejin-hot-monitor",
    "2-juejin-viral-breakdown",
    "3-juejin-rewrite",
    "4-juejin-publisher",
    "5-juejin-data-assistant",
    "6-juejin-write",
    "7-juejin-comment-manager",
]

# For each platform: list of (juejin_role_index 0-based, target_dir_suffix)
# Default: 1:1 same order
def get_platform_role_mapping(platform_key: str) -> list[tuple[int, str]]:
    # 1-viral, 2-rewrite, 3-publisher, 4-data, 5-hot, 6-write, 7-comment (xiaohongshu/zhihu/wechat-article/baijiahao)
    xiaohongshu_style = [
        (4, f"5-{platform_key}-hot-monitor"),
        (0, f"1-{platform_key}-viral-breakdown"),
        (1, f"2-{platform_key}-rewrite"),
        (2, f"3-{platform_key}-publisher"),
        (3, f"4-{platform_key}-data-assistant"),
        (5, f"6-{platform_key}-write"),
        (6, f"7-{platform_key}-comment-manager"),
    ]
    if platform_key in ("xiaohongshu", "zhihu", "wechat-article", "baijiahao"):
        return xiaohongshu_style
    if platform_key == "bilibili":
        # 1-hot, 2-content-helper, 3-video-publisher, 4-data, 5-viral, 6-write, 7-comment
        return [
            (0, "1-bilibili-hot-monitor"),
            (2, "2-bilibili-content-helper"),   # rewrite -> content-helper
            (3, "3-bilibili-video-publisher"),  # publisher -> video-publisher
            (4, "4-bilibili-data-assistant"),
            (1, "5-bilibili-viral-breakdown"),
            (5, "6-bilibili-write"),
            (6, "7-bilibili-comment-manager"),
        ]
    # Standard: same order
    return [
        (0, f"1-{platform_key}-hot-monitor"),
        (1, f"2-{platform_key}-viral-breakdown"),
        (2, f"3-{platform_key}-rewrite"),
        (3, f"4-{platform_key}-publisher"),
        (4, f"5-{platform_key}-data-assistant"),
        (5, f"6-{platform_key}-write"),
        (6, f"7-{platform_key}-comment-manager"),
    ]


def replace_platform(text: str, name_en: str, name_zh: str, role_replacements: dict | None = None) -> str:
    """Replace Juejin/掘金 with platform names. Optional role_replacements for role-specific strings."""
    out = text
    out = re.sub(r"\bJuejin\b", name_en, out, flags=re.IGNORECASE)
    out = out.replace("掘金", name_zh)
    if role_replacements:
        for old, new in role_replacements.items():
            out = out.replace(old, new)
    return out


def main() -> None:
    for platform_key, name_en, name_zh in PLATFORMS:
        platform_dir = BASE / platform_key
        if not platform_dir.is_dir():
            continue
        mapping = get_platform_role_mapping(platform_key)
        for juejin_idx, target_dir_name in mapping:
            src_dir = JUEJIN / JUEJIN_ROLES[juejin_idx]
            dst_dir = platform_dir / target_dir_name
            if not src_dir.is_dir() or not dst_dir.is_dir():
                continue
            role_replacements = None
            if platform_key == "bilibili":
                if "content-helper" in target_dir_name:
                    role_replacements = {"Bilibili Rewrite": "Bilibili Content Helper"}
                elif "video-publisher" in target_dir_name:
                    role_replacements = {"Bilibili Publisher": "Bilibili Video Publisher", "自动发布": "视频发布"}
            for fname in ("AGENTS.md", "SOUL.md"):
                src_file = src_dir / fname
                dst_file = dst_dir / fname
                if not src_file.is_file():
                    continue
                content = src_file.read_text(encoding="utf-8")
                content = replace_platform(content, name_en, name_zh, role_replacements)
                dst_file.write_text(content, encoding="utf-8")
                print(f"Wrote {dst_file.relative_to(BASE.parent)}")
            # zh-CN: copy from juejin zh-CN with 掘金 -> name_zh
            src_zh = src_dir / "zh-CN"
            dst_zh = dst_dir / "zh-CN"
            if src_zh.is_dir() and dst_zh.is_dir():
                for fname in ("AGENTS.md", "SOUL.md"):
                    src_file = src_zh / fname
                    dst_file = dst_zh / fname
                    if not src_file.is_file():
                        continue
                    content = src_file.read_text(encoding="utf-8")
                    content = content.replace("掘金", name_zh)
                    if platform_key == "bilibili" and "video-publisher" in target_dir_name:
                        content = content.replace("B站自动发布", "B站视频发布")
                    dst_file.write_text(content, encoding="utf-8")
                    print(f"Wrote {dst_file.relative_to(BASE.parent)}")


if __name__ == "__main__":
    main()
