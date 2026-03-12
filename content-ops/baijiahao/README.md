# 百家号内容管线 (Baijiahao Agents)

> 基于 [ANALYSIS-渠道与流程对齐 OctoFlow](../ANALYSIS-渠道与流程对齐OctoFlow.md) 建议，为**百家号**（百度系）提供与 wechat-article / zhihu 同构的内容管线七件套：热门监控、爆款拆解、二创、写作、自动发布、数据助手、评论管理。读（抓取）采用通用或专用抓取，写（发布）需浏览器或百家号开放平台发布。

## 技能来源区分

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（若有）** | [clawhub.ai/skills?q=baijiahao](https://clawhub.ai/skills?sort=downloads&q=baijiahao) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（取最优）** | [skills.sh/?q=baoyu](https://skills.sh/?q=baoyu) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

## 必须保证的七个环节

1. **热门监控**：每日/按需搜索百家号/百度系行业热点与爆款文章，产出日报或摘要，供爆款拆解与数据助手使用。
2. **爆款拆解**：自动搜索百家号/百度系行业热点与爆款文章，产出结构化拆解框架，供二创与数据助手使用。
3. **二创**：根据拆解框架与主题进行新文案与配图，产出草稿供发布与数据助手使用。
4. **写作**：强调原创；用户主图+热点/爆款做原创内容，产出草稿供发布与数据助手。
5. **自动发布**：将已通过草稿发布到百家号（需浏览器或开放平台），并记录结果供数据助手分析。
6. **数据助手**：解析数据、交叉验证效果，将可执行结论反馈给爆款拆解（形成闭环）。
7. **评论管理**：评论采集、起草回复、情感分析；回复需审批/门禁后发布。

**管线关系：** 热门监控 → 日报/摘要 → 爆款拆解 → 拆解框架 → 二创/写作 → 草稿+配图 → 自动发布 → 发布日志 → 数据助手 + 评论管理 → 反馈至爆款拆解与热门监控。

## 智能体清单

| 序号 | Agent id                    | 展示名           | 目录                         | 职责摘要 |
|------|-----------------------------|------------------|------------------------------|----------|
| 1    | baijiahao-viral-breakdown   | 百家号爆款拆解   | 1-baijiahao-viral-breakdown  | 搜索百家号/百度系热点与爆款，产出拆解框架 |
| 2    | baijiahao-rewrite           | 百家号二创       | 2-baijiahao-rewrite          | 根据拆解框架与主题创作新文案与配图 |
| 3    | baijiahao-publisher         | 百家号自动发布   | 3-baijiahao-publisher        | 将已通过草稿发布到百家号并记录结果 |
| 4    | baijiahao-data-assistant    | 百家号数据助手   | 4-baijiahao-data-assistant   | 解析数据、交叉验证效果、反馈给爆款拆解 |
| 5    | baijiahao-hot-monitor       | 百家号热门监控   | 5-baijiahao-hot-monitor      | 每日/按需搜索百家号/百度系热点与爆款，产出日报或摘要供拆解与数据助手 |
| 6    | baijiahao-write             | 百家号写作       | 6-baijiahao-write            | 强调原创：用户主图+热点/爆款做原创内容，产出草稿供发布与数据助手 |
| 7    | baijiahao-comment-manager   | 百家号评论管理   | 7-baijiahao-comment-manager  | 评论采集、起草回复、情感分析；回复需审批/门禁后发布 |

## 预设技能（示例）

| Agent id                    | 默认技能列表（示例） | 用途说明 |
|-----------------------------|----------------------|----------|
| baijiahao-viral-breakdown   | baoyu-url-to-markdown, baoyu-format-markdown | 抓取成文、规范拆解输出 |
| baijiahao-rewrite           | baoyu-cover-image, baoyu-article-illustrator | 封面与长文配图 |
| baijiahao-publisher         | baoyu-compress-image | 发布前压缩；发布需浏览器或开放平台 |
| baijiahao-data-assistant    | baoyu-format-markdown | 数据报告格式规范 |
| baijiahao-hot-monitor       | baoyu-url-to-markdown, baoyu-format-markdown | 抓取热点链接、规范日报格式 |
| baijiahao-write             | baoyu-cover-image, baoyu-article-illustrator | 原创内容配图与封面 |
| baijiahao-comment-manager   | （按需从 ClawHub/skills.sh 选评论采集与回复技能） | 评论拉取、回复草稿、情感摘要 |

### 安装方式

见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)。百家号发布当前多依赖浏览器自动化或百家号开放平台 API，技能以 baoyu 系列与通用抓取为主。**勿在 TOOLS.md 存凭证。**

## 配置说明

- **Workspace：** `~/.openclaw/workspace-baijiahao-<agentId>`。
- **Config 片段：** `config/openclaw-baijiahao-fragment.json`。
- **路由：** 通过 bindings 将渠道或会话路由到各 agent id。

## 初始化命令示例

```bash
openclaw agents add baijiahao-viral-breakdown   --workspace ~/.openclaw/workspace-baijiahao-viral-breakdown;
openclaw agents add baijiahao-rewrite           --workspace ~/.openclaw/workspace-baijiahao-rewrite;
openclaw agents add baijiahao-publisher         --workspace ~/.openclaw/workspace-baijiahao-publisher;
openclaw agents add baijiahao-data-assistant    --workspace ~/.openclaw/workspace-baijiahao-data-assistant;
openclaw agents add baijiahao-hot-monitor       --workspace ~/.openclaw/workspace-baijiahao-hot-monitor;
openclaw agents add baijiahao-write             --workspace ~/.openclaw/workspace-baijiahao-write;
openclaw agents add baijiahao-comment-manager   --workspace ~/.openclaw/workspace-baijiahao-comment-manager;
```

## 文件结构（每智能体）

与 zhihu、wechat-article 一致：`AGENTS.md`、`zh-CN/AGENTS.md`、`SOUL.md`、`IDENTITY.md`、`TOOLS.md`、`BOOTSTRAP.md`、`HEARTBEAT.md`、`USER.md` 及 zh-CN 对应文件。
