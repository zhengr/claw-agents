#!/usr/bin/env python3
"""
Apply long BOOTSTRAP and IDENTITY templates to any agent doc with < 50 lines.
Excludes docs/template-agent. Uses docs/BOOTSTRAP-long-template.md and
docs/IDENTITY-long-template.md (and zh-CN versions under zh-CN/).
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXCLUDE = "docs/template-agent"
BOOTSTRAP_EN = ROOT / "docs" / "BOOTSTRAP-long-template.md"
BOOTSTRAP_ZH = ROOT / "docs" / "zh-CN" / "BOOTSTRAP-long-template.md"
IDENTITY_EN = ROOT / "docs" / "IDENTITY-long-template.md"
IDENTITY_ZH = ROOT / "docs" / "zh-CN" / "IDENTITY-long-template.md"
SOUL_EN = ROOT / "docs" / "SOUL-long-template.md"
SOUL_ZH = ROOT / "docs" / "zh-CN" / "SOUL-long-template.md"

# Generic appendix to extend short AGENTS.md to >= 100 lines (append only)
AGENTS_APPEND = """

## Session Startup (checklist)

Before doing substantive work: read SOUL.md and IDENTITY.md for identity and boundaries; read USER.md if present; read memory/YYYY-MM-DD.md for today and yesterday when available; in main session read MEMORY.md if present. Then proceed without asking permission for routine work.

## Memory

Each session you start fresh. Record decisions, agreements, and feedback in `memory/` and `MEMORY.md` as configured. If you want to remember it, write it down. When someone says "remember this", update memory or MEMORY.md; when you learn a format or scope agreement, update TOOLS.md.

## Red Lines

Do not leak private or internal data. Do not run destructive commands without confirmation. When in doubt, ask. Do not ask the user how to address you; your identity is fixed in IDENTITY/SOUL. Stay within your defined role and agreed scope.

## External vs Internal

Only perform actions within your defined role and agreed scope. Ask before doing anything that could affect external systems or shared resources beyond your workspace. Use TOOLS.md for paths and conventions; do not store credentials in the workspace.

## Group Chats

In group chats participate only when it helps your role; do not make decisions for others. Reply when @'d or clearly asked; quality over quantity.

## Tools

Skills and local notes (paths, conventions) are documented in TOOLS.md. Follow TOOLS.md and skill docs for inputs and outputs.

## Heartbeats

If HEARTBEAT.md exists, follow it; otherwise reply HEARTBEAT_OK when applicable.

## Make It Yours

This document is the starting point. Add your own conventions as you go. When agreements or scope change, update TOOLS.md and memory as appropriate. Keep output format and fields stable for downstream when your role feeds other agents or processes.
"""


def main() -> None:
    for name, template_en, template_zh in [
        ("BOOTSTRAP.md", BOOTSTRAP_EN, BOOTSTRAP_ZH),
        ("IDENTITY.md", IDENTITY_EN, IDENTITY_ZH),
        ("SOUL.md", SOUL_EN, SOUL_ZH),
    ]:
        if not template_en.is_file():
            continue
        content_zh = template_zh.read_text(encoding="utf-8") if template_zh.is_file() else None
        for f in ROOT.rglob(name):
            if EXCLUDE in str(f):
                continue
            try:
                lines = len(f.read_text(encoding="utf-8").splitlines())
            except Exception:
                continue
            if lines >= 50:
                continue
            if "zh-CN" in str(f) and content_zh is not None:
                f.write_text(content_zh, encoding="utf-8")
            else:
                f.write_text(template_en.read_text(encoding="utf-8"), encoding="utf-8")
            print(f"Applied long {name}: {f.relative_to(ROOT)}")

    # Extend short AGENTS.md to >= 100 lines by appending generic sections
    for f in ROOT.rglob("AGENTS.md"):
        if EXCLUDE in str(f):
            continue
        try:
            content = f.read_text(encoding="utf-8")
            lines = len(content.splitlines())
        except Exception:
            continue
        if lines >= 100:
            continue
        while len(content.splitlines()) < 100:
            content = content.rstrip() + AGENTS_APPEND
        f.write_text(content, encoding="utf-8")
        print(f"Extended AGENTS.md to >= 100 lines: {f.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
