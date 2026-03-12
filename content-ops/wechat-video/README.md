# 视频号内容管线 (Wechat Video Agents)

> 基于 [ANALYSIS-渠道与流程对齐 OctoFlow](../../ANALYSIS-渠道与流程对齐OctoFlow.md) §2.1 建议，为**视频号**（微信生态短视频）提供与 xiaohongshu / wechat-article 同构的内容管线七件套：热门监控、爆款拆解、二创、自动发布、数据助手、写作、评论管理。读（抓取）可用通用抓取或第三方数据，写（发布）依赖视频号开放能力或浏览器自动化。

## 技能来源区分

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（若有）** | [clawhub.ai/skills?q=weixin](https://clawhub.ai/skills?sort=downloads&q=weixin) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（取最优）** | [skills.sh/?q=baoyu](https://skills.sh/?q=baoyu) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

## 必须保证的七个环节

1. **热门监控**：每日/按需搜索视频号/微信生态热点与爆款短视频，产出日报或摘要。
2. **爆款拆解**：对爆款短视频做拆解（标题、钩子、结构、主题），产出拆解框架供二创与数据助手使用。
3. **二创**：根据拆解框架与主题进行新文案与配图/封面，产出草稿供发布与数据助手使用。
4. **自动发布**：将已通过草稿发布到视频号（需视频号开放能力或浏览器），并记录结果。
5. **数据助手**：解析数据、交叉验证效果，反馈给爆款拆解（形成闭环）。
6. **写作**：强调原创；用户主图/选题+热点做原创短视频脚本与封面，产出草稿。
7. **评论管理**：评论采集、起草回复、情感分析；回复需审批/门禁后发布。

**管线关系：** 热门监控 → 日报/摘要 → 爆款拆解 → 拆解框架 → 二创/写作 → 草稿+配图 → 自动发布 → 发布日志 → 数据助手 + 评论管理 → 反馈至爆款拆解与热门监控。

## 智能体清单

| 序号 | Agent id                     | 展示名           | 目录                               | 职责摘要 |
|------|------------------------------|------------------|------------------------------------|----------|
| 1    | wechat-video-hot-monitor     | 视频号热门监控   | 1-wechat-video-hot-monitor         | 每日/按需搜索视频号热点与爆款，产出日报或摘要 |
| 2    | wechat-video-viral-breakdown | 视频号爆款拆解   | 2-wechat-video-viral-breakdown     | 对爆款短视频做拆解，产出结构化拆解框架 |
| 3    | wechat-video-rewrite         | 视频号二创       | 3-wechat-video-rewrite             | 根据拆解框架与主题创作新文案与配图/封面 |
| 4    | wechat-video-publisher       | 视频号自动发布   | 4-wechat-video-publisher           | 将已通过草稿发布到视频号并记录结果（需开放能力/浏览器） |
| 5    | wechat-video-data-assistant  | 视频号数据助手   | 5-wechat-video-data-assistant      | 解析数据、交叉验证效果、反馈给爆款拆解 |
| 6    | wechat-video-write           | 视频号写作       | 6-wechat-video-write               | 强调原创：用户主图/选题+热点做原创短视频内容，产出草稿 |
| 7    | wechat-video-comment-manager | 视频号评论管理   | 7-wechat-video-comment-manager     | 评论采集、起草回复、情感分析；回复需审批/门禁后发布 |

## 预设技能（示例）

| Agent id                     | 默认技能列表（示例） | 用途说明 |
|------------------------------|----------------------|----------|
| wechat-video-hot-monitor     | baoyu-url-to-markdown, baoyu-format-markdown | 抓取热点、规范日报格式 |
| wechat-video-viral-breakdown | baoyu-url-to-markdown, baoyu-format-markdown | 抓取成文、规范拆解输出 |
| wechat-video-rewrite         | baoyu-cover-image, baoyu-article-illustrator | 封面与配图 |
| wechat-video-publisher       | baoyu-compress-image | 发布前压缩；发布需视频号开放能力/浏览器 |
| wechat-video-data-assistant  | baoyu-format-markdown | 数据报告格式规范 |
| wechat-video-write           | baoyu-cover-image, baoyu-article-illustrator | 原创内容配图与封面 |
| wechat-video-comment-manager | （按需选评论采集与回复技能） | 评论拉取、回复草稿、情感摘要 |

### 安装方式

见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)、[CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)。**勿在 TOOLS.md 存凭证。**

## 配置说明

- **Workspace：** `~/.openclaw/workspace-wechat-video-<agentId>`。
- **Config 片段：** `config/openclaw-wechat-video-fragment.json`。
- **路由：** 通过 bindings 将渠道或会话路由到各 agent id。

## 初始化命令示例

```bash
openclaw agents add wechat-video-hot-monitor       --workspace ~/.openclaw/workspace-wechat-video-hot-monitor;
openclaw agents add wechat-video-viral-breakdown   --workspace ~/.openclaw/workspace-wechat-video-viral-breakdown;
openclaw agents add wechat-video-rewrite           --workspace ~/.openclaw/workspace-wechat-video-rewrite;
openclaw agents add wechat-video-publisher         --workspace ~/.openclaw/workspace-wechat-video-publisher;
openclaw agents add wechat-video-data-assistant    --workspace ~/.openclaw/workspace-wechat-video-data-assistant;
openclaw agents add wechat-video-write             --workspace ~/.openclaw/workspace-wechat-video-write;
openclaw agents add wechat-video-comment-manager   --workspace ~/.openclaw/workspace-wechat-video-comment-manager;
```

## 文件结构（每智能体）

与 zhihu、weibo 一致：`AGENTS.md`、`zh-CN/AGENTS.md`、`SOUL.md`、`IDENTITY.md`、`TOOLS.md`、`BOOTSTRAP.md`、`HEARTBEAT.md`、`USER.md` 及 zh-CN 对应文件。
