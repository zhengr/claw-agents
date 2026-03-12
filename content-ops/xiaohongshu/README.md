# 小红书内容管线 (Rednode / Xiaohongshu Agents)

> 基于 [ClawHub xiaohongshu 技能](https://clawhub.ai/skills?sort=downloads&q=xiaohongshu)（优先）与 [skills.sh baoyu / xiaohongshu](https://skills.sh/?q=baoyu)（后补），为**小红书**提供内容管线七件套：热门监控、爆款拆解、二创、原创、自动发布、数据助手、评论管理。本目录为独立 xiaohongshu 管线，可单独部署。

## 技能选型（ClawHub 优先，skills.sh 后补）

**技能来源区分：**

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（优先）** | [clawhub.ai/skills?q=xiaohongshu](https://clawhub.ai/skills?sort=downloads&q=xiaohongshu) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（后补）** | [skills.sh/?q=xiaohongshu](https://skills.sh/?q=xiaohongshu)、[skills.sh/?q=baoyu](https://skills.sh/?q=baoyu) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

- **ClawHub**：优先在 ClawHub 选用小红书相关技能并写在各智能体 TOOLS.md 中；完整列表见 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)。
- **skills.sh**：ClawHub 未覆盖时从 skills.sh 补充；小红书专项见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)，Baoyu 系列（baoyu-xhs-images、baoyu-cover-image、baoyu-article-illustrator、baoyu-url-to-markdown、baoyu-format-markdown、baoyu-compress-image）见 [jimliu/baoyu-skills](https://skills.sh/?q=baoyu)。
- **全仓库技能总览与 Baoyu 归类**见 [docs/SKILLS-MASTER.md](../../docs/SKILLS-MASTER.md)。

## 智能体清单

| 序号 | Agent id                      | 展示名           | 目录                               | 职责摘要 |
|------|-------------------------------|------------------|------------------------------------|----------|
| 1    | xiaohongshu-viral-breakdown   | 小红书爆款拆解   | 1-xiaohongshu-viral-breakdown      | 自动搜索平台行业热点与爆款，产出结构化拆解框架 |
| 2    | xiaohongshu-rewrite           | 小红书二创       | 2-xiaohongshu-rewrite              | 根据拆解框架与主题创作新文案与配图方向 |
| 3    | xiaohongshu-publisher         | 小红书自动发布   | 3-xiaohongshu-publisher            | 将已通过草稿发布到小红书并记录结果 |
| 4    | xiaohongshu-data-assistant    | 小红书数据助手   | 4-xiaohongshu-data-assistant       | 解析数据、交叉验证效果、反馈爆款拆解 |
| 5    | xiaohongshu-hot-monitor       | 小红书热门监控   | 5-xiaohongshu-hot-monitor          | 每日/按需搜索行业热点与爆款，产出日报或摘要供拆解与数据助手 |
| 6    | xiaohongshu-write             | 小红书原创       | 6-xiaohongshu-write                | 强调原创：用户主图+热点/爆款做原创内容，产出草稿供发布与数据助手 |
| 7    | xiaohongshu-comment-manager   | 小红书评论管理   | 7-xiaohongshu-comment-manager      | 评论采集、起草回复、情感分析；回复需审批/门禁后发布 |

**管线关系：** 热门监控 → 日报/摘要 → 爆款拆解 → 拆解框架 → 二创/原创 → 草稿+配图 → 自动发布 → 发布日志 → 数据助手 + 评论管理 → 反馈至爆款拆解与热门监控。

## 预设技能（ClawHub 优先，skills.sh 后补）

各 agent 的 `skills` 可在 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) 与 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) 中按职责选用。以下为 **skills.sh 后补** 默认方案（Baoyu 系列）：

| Agent id                      | 默认技能列表（skills.sh 后补） | 用途说明 |
|-------------------------------|--------------------------------|----------|
| xiaohongshu-viral-breakdown   | baoyu-url-to-markdown, baoyu-format-markdown | 抓取 URL 成文、规范拆解输出 |
| xiaohongshu-rewrite           | baoyu-xhs-images, baoyu-cover-image, baoyu-article-illustrator | 小红书配图与封面 |
| xiaohongshu-publisher         | baoyu-compress-image | 发布前图片压缩 |
| xiaohongshu-data-assistant    | baoyu-format-markdown | 数据小结/报告格式 |
| xiaohongshu-hot-monitor       | baoyu-url-to-markdown, baoyu-format-markdown | 抓取热点链接、规范日报格式 |
| xiaohongshu-write             | baoyu-xhs-images, baoyu-cover-image, baoyu-article-illustrator | 原创内容配图与封面 |
| xiaohongshu-comment-manager   | （按需从 ClawHub/skills.sh 选评论采集与回复技能） | 评论拉取、回复草稿、情感摘要 |

### 安装方式（按来源区分）

**来源：ClawHub** — 安装后目录名与 config 中 `skills` 一致。

```bash
clawhub search xiaohongshu
clawhub install <slug>
```

**来源：skills.sh** — 小红书专项见 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)；Baoyu 后补示例：

```bash
npx skills add jimliu/baoyu-skills --skill baoyu-url-to-markdown
npx skills add jimliu/baoyu-skills --skill baoyu-format-markdown
npx skills add jimliu/baoyu-skills --skill baoyu-xhs-images
npx skills add jimliu/baoyu-skills --skill baoyu-cover-image
npx skills add jimliu/baoyu-skills --skill baoyu-article-illustrator
npx skills add jimliu/baoyu-skills --skill baoyu-compress-image
```

若使用 `npx skillsadd`（无空格），格式以 skills.sh 文档为准。安装后技能目录名需与配置中 `skills` 数组一致。

## 配置说明

- **Workspace**：各智能体 workspace 指向本目录下对应子目录（如 `<REPO_ROOT>/openclaw-agents/content-ops/xiaohongshu/1-xiaohongshu-viral-breakdown`），或部署时复制/链接到 `~/.openclaw/workspace-xiaohongshu-viral-breakdown` 等。
- **Config 片段**：见仓库根目录 `config/openclaw-xiaohongshu-fragment.json`，可合并进主 openclaw 配置；使用前将 `<REPO_ROOT>` 替换为 openclaw-agents 实际路径。
- **路由**：按渠道或用户身份将会话绑定到对应 agent id（见上方智能体清单）。

## 初始化命令

以下命令在 OpenClaw 配置已就绪的前提下执行；`--workspace` 使用本地路径（如 `~/.openclaw/workspace-<agent-id>`），需先将本仓库 `content-ops/xiaohongshu/1-...`～`content-ops/xiaohongshu/7-...` 复制或链接到对应 workspace 目录。

### 1. 查看当前智能体列表

```bash
openclaw agents list
```

### 2. 添加小红书七件套（7 个）

```bash
openclaw agents add xiaohongshu-viral-breakdown   --workspace ~/.openclaw/workspace-xiaohongshu-viral-breakdown;
openclaw agents add xiaohongshu-rewrite           --workspace ~/.openclaw/workspace-xiaohongshu-rewrite;
openclaw agents add xiaohongshu-publisher         --workspace ~/.openclaw/workspace-xiaohongshu-publisher;
openclaw agents add xiaohongshu-data-assistant    --workspace ~/.openclaw/workspace-xiaohongshu-data-assistant;
openclaw agents add xiaohongshu-hot-monitor       --workspace ~/.openclaw/workspace-xiaohongshu-hot-monitor;
openclaw agents add xiaohongshu-write             --workspace ~/.openclaw/workspace-xiaohongshu-write;
openclaw agents add xiaohongshu-comment-manager   --workspace ~/.openclaw/workspace-xiaohongshu-comment-manager;
```

### 3. 查看当前绑定

```bash
openclaw agents bindings
```

### 4. 按渠道绑定智能体（示例：企微 wecom）

将渠道会话路由到对应 agent；其他渠道将 `wecom` 替换为 `feishu`、`telegram`、`webchat` 等即可。

```bash
openclaw agents bind --agent xiaohongshu-viral-breakdown   --bind wecom:xiaohongshu-viral-breakdown;
openclaw agents bind --agent xiaohongshu-rewrite           --bind wecom:xiaohongshu-rewrite;
openclaw agents bind --agent xiaohongshu-publisher        --bind wecom:xiaohongshu-publisher;
openclaw agents bind --agent xiaohongshu-data-assistant    --bind wecom:xiaohongshu-data-assistant;
openclaw agents bind --agent xiaohongshu-hot-monitor       --bind wecom:xiaohongshu-hot-monitor;
openclaw agents bind --agent xiaohongshu-write             --bind wecom:xiaohongshu-write;
openclaw agents bind --agent xiaohongshu-comment-manager   --bind wecom:xiaohongshu-comment-manager;
```

### 5. 删除小红书七件套（7 个）

从 OpenClaw 中移除上述 7 个 agent（需先解除各 agent 的渠道绑定，若有）。

```bash
openclaw agents remove xiaohongshu-viral-breakdown;
openclaw agents remove xiaohongshu-rewrite;
openclaw agents remove xiaohongshu-publisher;
openclaw agents remove xiaohongshu-data-assistant;
openclaw agents remove xiaohongshu-hot-monitor;
openclaw agents remove xiaohongshu-write;
openclaw agents remove xiaohongshu-comment-manager;
```

## 文件结构（每智能体）

每智能体目录包含以下文件：

- **AGENTS.md** — 英文，角色定义、职责、边界、Session Startup、Memory、Red Lines、Tools、Heartbeats；供 OpenClaw 系统提示词注入
- **zh-CN/AGENTS.md** — 中文，与 AGENTS.md 内容等价，供团队阅读
- **SOUL.md** — 人格与风格、底线（建议在 zh-CN/ 下提供中文版）
- **IDENTITY.md** / **zh-CN/IDENTITY.md** — Who Am I?（英文）与「我是谁？」（中文），模板见 [docs/IDENTITY-template.md](../../docs/IDENTITY-template.md) 及 [docs/zh-CN/IDENTITY-template.md](../../docs/zh-CN/IDENTITY-template.md)
- **TOOLS.md** — 本地/环境备注；含「技能（ClawHub 优先，skills.sh 后补）」及安装命令
- **USER.md** — 所服务对象信息（随使用更新）
- **BOOTSTRAP.md** — 首次运行引导，完成后可删除
- **HEARTBEAT.md** / **zh-CN/HEARTBEAT.md** — 心跳任务说明，见 [docs/HEARTBEAT-template.md](../../docs/HEARTBEAT-template.md)

**中英文约定**：英文文件在智能体根目录，中文版集中在 `zh-CN/` 子目录，文件名与英文一致，便于将 `zh-CN/` 整目录拷贝到业务使用。
