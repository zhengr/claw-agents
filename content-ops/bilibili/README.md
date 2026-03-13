# B站 (bilibili) 内容管线 (Bilibili Agents)

> 基于 [ClawHub bilibili 技能](https://clawhub.ai/skills?sort=downloads&q=bilibili) 与 [skills.sh bilibili](https://skills.sh/?q=bilibili)（**ClawHub 为主、skills.sh 取最优**），为 **B站（bilibili）** 提供内容管线七件套：热门监控、爆款拆解、内容创作助手、视频发布、数据助手、写作、评论管理。与 openclaw-agents 其他领域（xiaohongshu / wechat-article / discord 等）并列，单独目录便于按渠道绑定与扩展。

## 技能来源

| 来源 | 搜索链接 | 技能一览文档 | 安装命令 |
|------|----------|--------------|----------|
| **ClawHub（为主）** | [clawhub.ai/skills?q=bilibili](https://clawhub.ai/skills?sort=downloads&q=bilibili) | [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) | `clawhub install <slug>` |
| **skills.sh（取最优）** | [skills.sh/?q=bilibili](https://skills.sh/?q=bilibili) | [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md) | `npx skills add <owner/repo> --skill <名>` |

## 技能评估结论（摘录）

> 完整评估见 [SKILLS-EVALUATION.md](./SKILLS-EVALUATION.md)。原则：**ClawHub 为主、skills.sh 取最优；同能力只保留一个最优技能。**

| 能力 | 首选 | 备选/不重复装 |
|------|------|----------------|
| B站热门/日报 | bilibili-hot-monitor（ClawHub） | — |
| UP 更新检查 | bilibili-update-viewer（ClawHub） | — |
| 标题/标签/字幕 | bilibili-helper, bilibili-subtitle-download-skill | — |
| 视频发布/投稿 | bilibili-video-publish, bilibili-upload | 同质选一 |
| 数据分析/统计 | bilibili-analytics | — |
| 报告/拆解格式 | baoyu-format-markdown | — |
| 封面/配图 | baoyu-cover-image, baoyu-article-illustrator | — |

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

## 智能工作执行链路

B 站七件套按以下链路协同执行（与图文平台顺序略有不同：先监控与内容生产，再拆解与写作补充）。

| 步骤 | 环节 | 智能体 | 输入 | 输出 | 说明 |
|------|------|--------|------|------|------|
| 1 | 热门监控 | bilibili-hot-monitor | 分区/关键词/时间范围 | 日报或按需摘要（热门视频、UP 更新） | 入口；可为定时或人工触发 |
| 2 | 内容创作助手 | bilibili-content-helper | 日报/选题 + 已有草稿 | 标题/标签/简介优化、字幕总结、脚本辅助 | 消费监控产出，产出草稿供发布 |
| 3 | 视频发布 | bilibili-video-publisher | 已审核草稿 | 发布结果日志（链接、时间、状态） | 创作者平台或 CLI 投稿；仅发布已通过内容 |
| 4 | 数据助手 | bilibili-data-assistant | 发布日志 + 播放/互动数据 | 可执行反馈（热门趋势、优化方向） | 交叉验证效果，反馈至热门监控与内容助手 |
| 5 | 爆款拆解 | bilibili-viral-breakdown | 监控/调研得到的热门视频 | 拆解框架（标题、钩子、结构、主题） | 供内容助手与写作参考 |
| 6 | 写作 | bilibili-write | 用户选题 + 热点/爆款洞察 | 原创视频脚本与配图方向、草稿 | 独立于内容助手的原创生产 |
| 7 | 评论管理 | bilibili-comment-manager | 视频/账号评论与弹幕 | 回复草稿 + 情感/弹幕摘要 | 回复须审批/门禁后发布 |

**闭环：** 数据助手的反馈驱动热门监控与内容创作助手调整范围与策略，爆款拆解为内容助手与写作提供可复用框架，形成「监控 → 内容/发布 → 数据 → 拆解/写作 → 内容」闭环。

**并行与触发：** 爆款拆解与写作可与内容助手并行消费监控产出；评论管理可与数据助手并行。执行顺序建议 1 → 2 → 3 → 4，5/6 可并行或按需触发，7 可持续或按周期执行。

## 预设技能（按评估结论，去重取最优）

以下为 [SKILLS-EVALUATION.md](./SKILLS-EVALUATION.md) 最终推荐；同能力只选一个来源。

| 步骤 | Agent id                  | 推荐技能 | 来源 | 说明 |
|------|---------------------------|----------|------|------|
| 1 | bilibili-hot-monitor      | bilibili-hot-monitor, bilibili-update-viewer | ClawHub | 热门日报、UP 更新检查 |
| 2 | bilibili-content-helper   | bilibili-helper, bilibili-subtitle-download-skill | ClawHub | 标题/标签/简介、字幕总结 |
| 3 | bilibili-video-publisher  | bilibili-video-publish, bilibili-upload | ClawHub | 创作者平台发布、CLI 投稿 |
| 4 | bilibili-data-assistant   | bilibili-analytics | ClawHub | 搜索与数据分析、统计报告 |
| 5 | bilibili-viral-breakdown  | baoyu-format-markdown | skills.sh | 爆款拆解、框架输出 |
| 6 | bilibili-write            | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 原创脚本与配图方向 |
| 7 | bilibili-comment-manager  | （按需选评论/弹幕采集与回复技能） | ClawHub/skills.sh | 评论/弹幕拉取、回复草稿 |

### 安装命令（按来源与链路顺序）

安装后目录名需与 config 中 `skills` 一致。**投稿/发布类技能**通常需浏览器登录或 B 站凭证，勿在 TOOLS.md 或工作区存储凭证。

**第一步：安装 SkillHub CLI**

```bash
curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

**第二步：安装技能**

**ClawHub**

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

**skills.sh（Baoyu，用于 viral-breakdown、write）**

```bash
npx skills add jimliu/baoyu-skills --skill baoyu-format-markdown -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-cover-image -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-article-illustrator -y -g;
```

## 配置说明

- **Workspace**：各智能体 workspace 指向本目录下对应子目录（如 `<REPO_ROOT>/openclaw-agents/bilibili/1-bilibili-hot-monitor`），或部署时复制/链接到 `~/.openclaw/workspace-bilibili-hot-monitor` 等。
- **Config 片段**：见仓库 `config/openclaw-bilibili-fragment.json`，可合并进主 openclaw 配置；将 `<REPO_ROOT>` 替换为实际路径。
- **路由**：按渠道或用户身份将会话绑定到对应 agent id。

## 初始化命令（按执行链路顺序）

### 添加七件套

```bash
openclaw agents add bilibili-hot-monitor        --workspace ~/.openclaw/workspace-bilibili-hot-monitor;
openclaw agents add bilibili-content-helper     --workspace ~/.openclaw/workspace-bilibili-content-helper;
openclaw agents add bilibili-video-publisher    --workspace ~/.openclaw/workspace-bilibili-video-publisher;
openclaw agents add bilibili-data-assistant     --workspace ~/.openclaw/workspace-bilibili-data-assistant;
openclaw agents add bilibili-viral-breakdown    --workspace ~/.openclaw/workspace-bilibili-viral-breakdown;
openclaw agents add bilibili-write              --workspace ~/.openclaw/workspace-bilibili-write;
openclaw agents add bilibili-comment-manager    --workspace ~/.openclaw/workspace-bilibili-comment-manager;
```

### 按渠道绑定（示例：wecom）

```bash
openclaw agents bind --agent bilibili-hot-monitor        --bind wecom:bilibili-hot-monitor;
openclaw agents bind --agent bilibili-content-helper     --bind wecom:bilibili-content-helper;
openclaw agents bind --agent bilibili-video-publisher     --bind wecom:bilibili-video-publisher;
openclaw agents bind --agent bilibili-data-assistant      --bind wecom:bilibili-data-assistant;
openclaw agents bind --agent bilibili-viral-breakdown     --bind wecom:bilibili-viral-breakdown;
openclaw agents bind --agent bilibili-write               --bind wecom:bilibili-write;
openclaw agents bind --agent bilibili-comment-manager     --bind wecom:bilibili-comment-manager;
```

### 删除七件套（需先解除绑定）

```bash
openclaw agents remove bilibili-hot-monitor;
openclaw agents remove bilibili-content-helper;
openclaw agents remove bilibili-video-publisher;
openclaw agents remove bilibili-data-assistant;
openclaw agents remove bilibili-viral-breakdown;
openclaw agents remove bilibili-write;
openclaw agents remove bilibili-comment-manager;
```

## 文件结构（每智能体）

与 company、xiaohongshu、wechat-article 一致：`AGENTS.md`、`zh-CN/AGENTS.md`、`SOUL.md`、`zh-CN/SOUL.md`、`IDENTITY.md`、`zh-CN/IDENTITY.md`、`TOOLS.md`、`zh-CN/TOOLS.md`、`BOOTSTRAP.md`、`zh-CN/BOOTSTRAP.md`、`USER.md`、`HEARTBEAT.md`、`zh-CN/HEARTBEAT.md`。
