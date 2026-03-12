# 抖音内容管线 (Douyin Agents)

> 基于 [ANALYSIS-渠道与流程对齐 OctoFlow](../../ANALYSIS-渠道与流程对齐OctoFlow.md) §2.1 建议，为**抖音**（短视频）提供与 xiaohongshu / wechat-article 同构的内容管线七件套：热门监控、爆款拆解、二创、自动发布、数据助手、写作、评论管理。读（抓取）优先官方 API，无 API 时可用 yt-dlp 类；写（发布）需抖音开放平台 API 或浏览器自动化。**合规与平台 ToS 需严格遵守。**

## 技能来源区分

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（若有）** | [clawhub.ai/skills?q=douyin](https://clawhub.ai/skills?sort=downloads&q=douyin) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（取最优）** | [skills.sh/?q=douyin](https://skills.sh/?q=douyin)、[skills.sh/?q=baoyu](https://skills.sh/?q=baoyu) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

## 必须保证的七个环节

1. **热门监控**：每日/按需搜索抖音热点与爆款短视频，产出日报或摘要，供爆款拆解与数据助手使用。
2. **爆款拆解**：对监控/调研得到的爆款短视频做拆解（标题、钩子、结构、主题），产出拆解框架供二创与数据助手使用。
3. **二创**：根据拆解框架与主题进行新文案与封面/脚本，产出草稿供发布与数据助手使用。
4. **自动发布**：将已通过草稿发布到抖音（需开放平台 API 或浏览器），并记录结果供数据助手分析。
5. **数据助手**：解析数据、交叉验证效果，将可执行结论反馈给爆款拆解（形成闭环）。
6. **写作**：强调原创；用户选题+热点/爆款做原创短视频脚本与封面，产出草稿供发布与数据助手。
7. **评论管理**：评论采集、起草回复、情感分析；回复需审批/门禁后发布。

**管线关系：** 热门监控 → 日报/摘要 → 爆款拆解 → 拆解框架 → 二创/写作 → 草稿+配图 → 自动发布 → 发布日志 → 数据助手 + 评论管理 → 反馈至爆款拆解与热门监控。

## 智能体清单

| 序号 | Agent id                | 展示名         | 目录                           | 职责摘要 |
|------|-------------------------|----------------|--------------------------------|----------|
| 1    | douyin-hot-monitor      | 抖音热门监控   | 1-douyin-hot-monitor          | 每日/按需搜索抖音热点与爆款短视频，产出日报或摘要 |
| 2    | douyin-viral-breakdown  | 抖音爆款拆解   | 2-douyin-viral-breakdown      | 对爆款短视频做拆解，产出结构化拆解框架 |
| 3    | douyin-rewrite          | 抖音二创       | 3-douyin-rewrite               | 根据拆解框架与主题创作新文案与封面/脚本 |
| 4    | douyin-publisher        | 抖音自动发布   | 4-douyin-publisher             | 将已通过草稿发布到抖音并记录结果（需开放平台/浏览器） |
| 5    | douyin-data-assistant   | 抖音数据助手   | 5-douyin-data-assistant        | 解析数据、交叉验证效果、反馈给爆款拆解 |
| 6    | douyin-write            | 抖音写作       | 6-douyin-write                 | 强调原创：用户选题+热点/爆款做原创短视频内容，产出草稿 |
| 7    | douyin-comment-manager  | 抖音评论管理   | 7-douyin-comment-manager      | 评论采集、起草回复、情感分析；回复需审批/门禁后发布 |

## 预设技能（示例）

| Agent id                | 默认技能列表（示例） | 用途说明 |
|-------------------------|----------------------|----------|
| douyin-hot-monitor      | baoyu-url-to-markdown, baoyu-format-markdown | 抓取热点链接、规范日报格式 |
| douyin-viral-breakdown  | baoyu-url-to-markdown, baoyu-format-markdown | 抓取成文、规范拆解输出 |
| douyin-rewrite          | baoyu-cover-image, baoyu-article-illustrator | 封面与配图 |
| douyin-publisher        | baoyu-compress-image | 发布前压缩；发布需开放平台 API 或浏览器，合规与 ToS |
| douyin-data-assistant   | baoyu-format-markdown | 数据报告格式规范 |
| douyin-write            | baoyu-cover-image, baoyu-article-illustrator | 原创内容配图与封面 |
| douyin-comment-manager  | （按需从 ClawHub/skills.sh 选评论采集与回复技能） | 评论拉取、回复草稿、情感摘要 |

### 安装方式

见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)、[CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)。**勿在 TOOLS.md 存凭证。** 发布与抓取须遵守抖音开放平台与平台 ToS。

## 配置说明

- **Workspace：** `~/.openclaw/workspace-douyin-<agentId>`。
- **Config 片段：** `config/openclaw-douyin-fragment.json`。
- **路由：** 通过 bindings 将渠道或会话路由到各 agent id。

## 初始化命令示例

```bash
openclaw agents add douyin-hot-monitor       --workspace ~/.openclaw/workspace-douyin-hot-monitor;
openclaw agents add douyin-viral-breakdown   --workspace ~/.openclaw/workspace-douyin-viral-breakdown;
openclaw agents add douyin-rewrite           --workspace ~/.openclaw/workspace-douyin-rewrite;
openclaw agents add douyin-publisher         --workspace ~/.openclaw/workspace-douyin-publisher;
openclaw agents add douyin-data-assistant    --workspace ~/.openclaw/workspace-douyin-data-assistant;
openclaw agents add douyin-write             --workspace ~/.openclaw/workspace-douyin-write;
openclaw agents add douyin-comment-manager   --workspace ~/.openclaw/workspace-douyin-comment-manager;
```

## 文件结构（每智能体）

与 zhihu、weibo 一致：`AGENTS.md`、`zh-CN/AGENTS.md`、`SOUL.md`、`IDENTITY.md`、`TOOLS.md`、`BOOTSTRAP.md`、`HEARTBEAT.md`、`USER.md` 及 zh-CN 对应文件。
