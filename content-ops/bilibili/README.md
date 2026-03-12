# B站 (bilibili) 内容管线 (Bilibili Agents)

> 基于 [ClawHub bilibili 技能](https://clawhub.ai/skills?sort=downloads&q=bilibili) 与 [skills.sh bilibili](https://skills.sh/?q=bilibili)（**ClawHub 为主、skills.sh 取最优**），为 **B站（bilibili）** 提供内容管线七件套：热门监控、爆款拆解、内容创作助手、视频发布、数据助手、写作、评论管理。与 openclaw-agents 其他领域（xiaohongshu / wechat-article / discord 等）并列，单独目录便于按渠道绑定与扩展。

## 技能来源

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（为主）** | [clawhub.ai/skills?q=bilibili](https://clawhub.ai/skills?sort=downloads&q=bilibili) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（取最优）** | [skills.sh/?q=bilibili](https://skills.sh/?q=bilibili) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

## 智能体清单

| 序号 | Agent id                  | 展示名           | 目录                           | 职责摘要 |
|------|---------------------------|------------------|--------------------------------|----------|
| 1    | bilibili-hot-monitor      | B站热门监控      | 1-bilibili-hot-monitor         | 监控热门视频、UP 主更新，产出日报或结构化摘要，供内容与数据助手使用 |
| 2    | bilibili-content-helper   | B站内容创作助手  | 2-bilibili-content-helper      | 标题/标签/简介优化、投稿策略、字幕总结与脚本辅助，产出草稿供发布 |
| 3    | bilibili-video-publisher  | B站视频发布      | 3-bilibili-video-publisher     | 将已通过草稿在 B 站创作者平台发布，记录发布结果供数据助手分析 |
| 4    | bilibili-data-assistant   | B站数据助手      | 4-bilibili-data-assistant      | 解析播放/互动数据、热门趋势，交叉验证后产出反馈给热门监控与内容助手 |
| 5    | bilibili-viral-breakdown  | B站爆款拆解      | 5-bilibili-viral-breakdown     | 对监控/调研得到的热门视频做拆解（标题、钩子、结构、主题），产出拆解框架供内容助手与写作 |
| 6    | bilibili-write            | B站写作          | 6-bilibili-write               | 强调原创：用户主图/选题+热点做原创视频脚本与配图方向，产出草稿供发布与数据助手 |
| 7    | bilibili-comment-manager  | B站评论管理      | 7-bilibili-comment-manager     | 评论采集、起草回复、情感/弹幕分析；回复需审批/门禁后发布 |

**管线关系：** 热门监控 → 日报/摘要 → 爆款拆解 → 拆解框架 → 内容助手/写作 → 草稿 → 视频发布 → 发布日志 → 数据助手 + 评论管理 → 反馈至热门监控与爆款拆解。

## 预设技能（ClawHub 为主，skills.sh 取最优）

**ClawHub 技能一览**见 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)，**skills.sh 技能一览**见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)。各智能体在配置片段中已绑定推荐技能。合并 `config/openclaw-bilibili-fragment.json` 后，OpenClaw 按 `agents.list[].skills` 加载；需先将技能安装到 OpenClaw 可加载的 skills 目录，**安装后目录名与 config 中 `skills` 一致**。

| Agent id                  | 默认技能列表（ClawHub） | 用途说明 |
|---------------------------|-------------------------|----------|
| bilibili-hot-monitor      | bilibili-hot-monitor, bilibili-update-viewer | 热门日报、UP 主更新检查 |
| bilibili-content-helper   | bilibili-helper, bilibili-subtitle-download-skill | 标题/标签/简介、字幕总结 |
| bilibili-video-publisher  | bilibili-video-publish, bilibili-upload | 创作者平台发布、CLI 投稿 |
| bilibili-data-assistant   | bilibili-analytics | 搜索与数据分析、统计报告 |
| bilibili-viral-breakdown  | （ClawHub bilibili 或 baoyu-format-markdown） | 爆款视频拆解、框架输出 |
| bilibili-write            | baoyu-cover-image, baoyu-article-illustrator（或 bilibili-helper） | 原创脚本与配图方向 |
| bilibili-comment-manager  | （按需从 ClawHub/skills.sh 选评论采集与回复技能） | 评论/弹幕拉取、回复草稿、情感摘要 |

### 安装方式（按来源区分）

**来源：ClawHub（为主）** — 安装后目录名与 config 中 `skills` 一致。

```bash
clawhub search bilibili
clawhub install bilibili-hot-monitor
clawhub install bilibili-update-viewer
clawhub install bilibili-helper
clawhub install bilibili-subtitle-download-skill
clawhub install bilibili-video-publish
clawhub install bilibili-upload
clawhub install bilibili-analytics
```

**来源：skills.sh（取最优）** — 完整列表见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)。可选 Baoyu 技能（配图/排版/多平台发帖等）见该文档中 Baoyu 系列。

```bash
npx skills add hamsterider-m/bilibili-subtitle --skill bilibili-subtitle
npx skills add aidotnet/moyucode --skill bilibili-analyzer
npx skills add 958877748/skills --skill bilibili-downloader
npx skills add davincievans/bilibili-subtitle-download-skill --skill bilibili-subtitle-downloader
```

若使用 `npx skillsadd`（无空格），格式以 skills.sh 文档为准。安装后技能目录名需与 config 中 `skills` 数组一致。**投稿/发布类技能**通常需浏览器登录或 B 站凭证，勿在 TOOLS.md 或工作区存储凭证。

## 配置说明

- **Workspace**：各智能体 workspace 指向本目录下对应子目录（如 `<REPO_ROOT>/openclaw-agents/bilibili/1-bilibili-hot-monitor`），或部署时复制/链接到 `~/.openclaw/workspace-bilibili-hot-monitor` 等。
- **Config 片段**：见仓库 `config/openclaw-bilibili-fragment.json`，可合并进主 openclaw 配置；将 `<REPO_ROOT>` 替换为实际路径。
- **路由**：按渠道或用户身份将会话绑定到对应 agent id。

## 初始化命令示例

```bash
openclaw agents add bilibili-hot-monitor        --workspace ~/.openclaw/workspace-bilibili-hot-monitor;
openclaw agents add bilibili-content-helper     --workspace ~/.openclaw/workspace-bilibili-content-helper;
openclaw agents add bilibili-video-publisher    --workspace ~/.openclaw/workspace-bilibili-video-publisher;
openclaw agents add bilibili-data-assistant     --workspace ~/.openclaw/workspace-bilibili-data-assistant;
openclaw agents add bilibili-viral-breakdown    --workspace ~/.openclaw/workspace-bilibili-viral-breakdown;
openclaw agents add bilibili-write              --workspace ~/.openclaw/workspace-bilibili-write;
openclaw agents add bilibili-comment-manager    --workspace ~/.openclaw/workspace-bilibili-comment-manager;

openclaw agents bind --agent bilibili-hot-monitor        --bind wecom:bilibili-hot-monitor;
openclaw agents bind --agent bilibili-content-helper     --bind wecom:bilibili-content-helper;
openclaw agents bind --agent bilibili-video-publisher    --bind wecom:bilibili-video-publisher;
openclaw agents bind --agent bilibili-data-assistant     --bind wecom:bilibili-data-assistant;
openclaw agents bind --agent bilibili-viral-breakdown    --bind wecom:bilibili-viral-breakdown;
openclaw agents bind --agent bilibili-write              --bind wecom:bilibili-write;
openclaw agents bind --agent bilibili-comment-manager    --bind wecom:bilibili-comment-manager;
```

## 文件结构（每智能体）

与 company、xiaohongshu、wechat-article 一致：`AGENTS.md`、`zh-CN/AGENTS.md`、`SOUL.md`、`zh-CN/SOUL.md`、`IDENTITY.md`、`zh-CN/IDENTITY.md`、`TOOLS.md`、`zh-CN/TOOLS.md`、`BOOTSTRAP.md`、`zh-CN/BOOTSTRAP.md`、`USER.md`、`HEARTBEAT.md`、`zh-CN/HEARTBEAT.md`。
