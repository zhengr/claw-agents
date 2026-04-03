# Claw Agents

面向 `OctoClaw / OpenClaw` 生态的智能体工作区仓库，提供可直接复用的角色定义、领域编排方案、渠道运营管线和技能选型文档。

当前仓库已经不是旧版“根目录平铺多个垂直领域”的结构，而是演进为三大分组：

- `1、IM Channels`：面向 Telegram、Discord、Feishu 等 IM 渠道的接入与运营智能体
- `2、Digital Workforce`：面向企业业务与交付流程的数字员工、专家角色与编排团队
- `3、Content Ops`：面向各内容平台的内容生产与发布管线

> `OctoClaw` 强调零信任、流式执行、边说边执行与企业级安全；本仓库中的智能体定义与技能文档可直接作为 `OctoClaw` 的业务工作区内容，也兼容 OpenClaw 式工作区组织方式。  
> 参考：`../octoclaw/README.md`、`../octoclaw/README_CN.md`

---

## 目录

1. [仓库现状总览](#1-仓库现状总览)
2. [推荐安装方式](#2-推荐安装方式)
3. [快速接入一个智能体组](#3-快速接入一个智能体组)
4. [三大分组与代表性智能体](#4-三大分组与代表性智能体)
5. [技能体系与安装策略](#5-技能体系与安装策略)
6. [智能体文档规范](#6-智能体文档规范)
7. [配置与部署建议](#7-配置与部署建议)
8. [常见落地场景](#8-常见落地场景)
9. [文档入口](#9-文档入口)

---

## 1. 仓库现状总览

### 顶层结构

```text
claw-agents/
├── 1、IM Channels/
├── 2、Digital Workforce/
├── 3、Content Ops/
├── config/
├── docs/
└── scripts/
```

### 这三个分组分别解决什么问题

| 分组 | 目标 | 典型产物 |
|------|------|----------|
| `1、IM Channels` | 搭建消息入口、群管理、社区运营、支持响应 | Telegram/Discord/Feishu 智能体组 |
| `2、Digital Workforce` | 搭建企业内部/外部数字员工与专家网络 | 技术总监团队、Web3 研究团队、客服、教育、销售等 |
| `3、Content Ops` | 搭建内容运营“七件套”流水线 | 热门监控、爆款拆解、原创/二创、发布、数据复盘、评论管理 |

### 与旧文档相比的关键变化

- 根目录已不再以 `it/`、`web3/`、`education/` 等直接平铺。
- `Software & Delivery`、`Web3`、`Education` 等能力现在归入 `2、Digital Workforce`。
- 多个内容平台已经形成“渠道 README + 技能索引 + 技能评估”的稳定结构。
- `IM Channels` 目录实际已有多个渠道树，旧版根文档对其描述明显不完整。

---

## 2. 推荐安装方式

### 2.1 运行时安装

本仓库推荐优先面向 `OctoClaw` 使用；若你当前仍运行 `OpenClaw` 风格工作区，也可以沿用相同的工作区组织方式。

**OctoClaw（推荐，适合企业级流式执行）**

```bash
git clone https://github.com/octoclaw-labs/octoclaw.git
cd octoclaw
cargo build --release
cargo run -p octoclaw-cli -- chat
```

**配置目录**

- OctoClaw：`~/.octoclaw/config.toml`
- OpenClaw 兼容式工作区：通常仍会使用 `~/.openclaw/...` 的 workspace / agentDir 组织

OctoClaw 的能力与定位见 `../octoclaw/README_CN.md`。

### 2.2 技能安装 CLI

本仓库默认采用“双来源”技能策略：

1. `ClawHub / SkillHub` 优先
2. `skills.sh` 后补

国内环境推荐先装 SkillHub CLI：

```bash
curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

安装完成后可使用：

```bash
skillhub install <slug>
```

如果你直接使用 ClawHub：

```bash
clawhub install <slug> --workdir ~/.openclaw;
```

如果你使用 skills.sh：

```bash
npx skills add <owner/repo> --skill <skill-name> -y -g;
```

### 2.3 技能目录要点

技能安装目录必须与你的运行时加载目录一致：

| 类型 | 典型路径 |
|------|----------|
| 全局技能 | `~/.openclaw/skills/` |
| 工作区技能 | `<workspace>/.openclaw/skills/` |

`npx skills add` 默认安装位置与 OpenClaw/OctoClaw 工作区未必一致，因此：

- 能用 `clawhub install` / `skillhub install` 时，优先用它们
- 若用 `npx skills add`，需将技能复制或软链到实际技能目录

更完整说明见 `docs/SKILLS-MASTER.md`。

---

## 3. 快速接入一个智能体组

### 方式一：直接复用仓库目录作为工作区模板

1. 选择一个目录，例如：
   - `2、Digital Workforce/9、Software & Delivery`
   - `2、Digital Workforce/10、Web3`
   - `3、Content Ops/xiaohongshu`
2. 将目标角色目录复制或软链到实际运行时工作区
3. 在运行时配置中注册 `agentId`、`workspace`、`agentDir`
4. 按需启用绑定与 agent-to-agent 委派

### 方式二：以本仓库为“定义源”，由运行时生成 agent 再覆盖工作区

如果你已有现成 agent 管理命令，可先创建 agent，再用本仓库内容覆盖工作区目录：

```bash
mkdir -p ~/.openclaw/workspace-technical-director
mkdir -p ~/.openclaw/agents/technical-director/agent
mkdir -p ~/.openclaw/agents/technical-director/sessions
```

然后把仓库中的角色定义复制进去：

```bash
cp -R "/path/to/claw-agents/2、Digital Workforce/9、Software & Delivery/1-technical-director/"* \
  ~/.openclaw/workspace-technical-director/
```

### 最小配置示例

```json5
{
  "agents": {
    "list": [
      {
        "id": "technical-director",
        "default": true,
        "workspace": "~/.openclaw/workspace-technical-director",
        "agentDir": "~/.openclaw/agents/technical-director/agent"
      }
    ]
  }
}
```

### 验证建议

```bash
openclaw agents list --bindings
openclaw channels status --probe
openclaw doctor
```

如果你使用 OctoClaw，则按其 CLI / config 模型完成等价注册，核心原则不变：

- 每个 agent 独立工作区
- 每个 agent 独立状态目录
- 技能目录与运行时加载目录一致
- 高风险发布/写操作默认加人工确认

---

## 4. 三大分组与代表性智能体

### 4.1 IM Channels

目录：`1、IM Channels`

当前可见的主要渠道：

- `telegram`
- `discord`
- `feishu`

代表性目录示例：

- `1、IM Channels/telegram/1-telegram-bot-developer`
- `1、IM Channels/telegram/2-telegram-community`
- `1、IM Channels/telegram/3-telegram-support`
- `1、IM Channels/discord/1-discord-mod`
- `1、IM Channels/discord/2-discord-community`
- `1、IM Channels/discord/3-discord-support`

适合场景：

- 社区维护
- 群管理与风控
- 用户支持
- Bot 开发与自动化运营

### 4.2 Digital Workforce

目录：`2、Digital Workforce`

当前已形成多个企业能力域，例如：

- `1、Company Manger`
- `2、Sales`
- `3、Finance & Ops`
- `4、Game & Media`
- `5、XR & Spatial`
- `6、Compliance & Risk`
- `7、Ad & Creative`
- `8、Research & Strategy`
- `9、Software & Delivery`
- `10、Web3`
- `11、Customer Service`
- `12、Education`

其中最典型的两个子域：

**Software & Delivery**

- `1-technical-director`
- `2-project-manager`
- `3-product-manager`
- `10-frontend-engineer`
- `13-ops-engineer`
- `backend-architect`
- `code-reviewer`

这说明仓库已经从“固定 13 角色”扩展为：

- 主干交付团队
- 补充专家角色
- 可组合的委派网络

**Web3**

- `0-main`
- `chain-analyst`
- `defi-scout`

适合研究、监控、组合分析与专题侦察型场景。

### 4.3 Content Ops

目录：`3、Content Ops`

当前可见的渠道已经明显扩展，至少包括：

- `baidu`
- `baijiahao`
- `bilibili`
- `douyin`
- `growth`
- `instagram`
- `juejin`
- `kuaishou`
- `linkedin`
- `podcast`
- `reddit`
- `tiktok`
- `toutiao`
- `twitter`
- `wechat-article`
- `wechat-video`
- `weibo`
- `xiaohongshu`
- `zhihu`

多数内容平台采用“七件套”或近似流水线结构，例如：

- 热门监控
- 爆款拆解
- 二创
- 原创
- 发布
- 数据助手
- 评论管理

代表性目录示例：

- `3、Content Ops/douyin/1-douyin-specialist`
- `3、Content Ops/douyin/2-douyin-hot-monitor`
- `3、Content Ops/douyin/5-douyin-publisher`
- `3、Content Ops/douyin/douyin-strategist`
- `3、Content Ops/linkedin/linkedin-content-creator`

---

## 5. 技能体系与安装策略

### 5.1 仓库里的技能文档分层

**根级总览**

- `docs/SKILLS-MASTER.md`：全仓库总技能索引、安装目录说明、Baoyu 技能总表

**分组级 README**

- `1、IM Channels/README.md`
- `2、Digital Workforce/README.md`
- `3、Content Ops/README.md`

**渠道/领域级技能文档**

多数成熟子域都包含以下文件：

- `README.md`
- `CLAWHUB-SKILLS.md`
- `SKILLS-SH-SKILLS.md`
- `SKILLS-EVALUATION.md`

例如：

- `3、Content Ops/xiaohongshu/README.md`
- `3、Content Ops/xiaohongshu/CLAWHUB-SKILLS.md`
- `3、Content Ops/xiaohongshu/SKILLS-SH-SKILLS.md`
- `3、Content Ops/xiaohongshu/SKILLS-EVALUATION.md`

软件交付子域则有单独口径：

- `2、Digital Workforce/9、Software & Delivery/README.md`
- `2、Digital Workforce/9、Software & Delivery/IT-SKILLS.md`
- `2、Digital Workforce/9、Software & Delivery/SKILLS-EVALUATION-IT.md`

### 5.2 统一选型原则

本仓库推荐的统一规则是：

1. 先看 `ClawHub / SkillHub` 是否已有高质量平台专用技能
2. 再用 `skills.sh` 和 `Baoyu` 技能补齐格式化、抓取、配图、压缩、发布等通用能力
3. 同能力优先只保留一个最优技能，避免重复安装

### 5.3 Content Ops 的标准技能心智模型

以内容平台为例，一个完整渠道通常会用到这些技能类型：

| 能力层 | 常见用途 | 典型来源 |
|--------|----------|----------|
| 平台连接 | 搜索、发布、评论、账号操作 | ClawHub / SkillHub |
| 抓取转换 | URL 转 Markdown、正文提取 | skills.sh / Baoyu |
| 格式输出 | 日报、拆解报告、结构化 Markdown | skills.sh / Baoyu |
| 配图生成 | 封面、插图、信息图、漫画 | skills.sh / Baoyu |
| 发布前处理 | 图片压缩、HTML 转换 | skills.sh / Baoyu |
| 数据复盘 | 报告生成、趋势周报 | 平台技能 + Markdown 格式技能 |

### 5.4 常用 Baoyu 技能

根文档无需逐条展开所有安装命令，但你应优先知道这些是跨渠道高频基础设施：

- `baoyu-url-to-markdown`
- `baoyu-format-markdown`
- `baoyu-cover-image`
- `baoyu-article-illustrator`
- `baoyu-xhs-images`
- `baoyu-compress-image`
- `baoyu-markdown-to-html`
- `baoyu-post-to-wechat`
- `baoyu-post-to-x`
- `baoyu-translate`

完整表与安装说明见 `docs/SKILLS-MASTER.md`。

---

## 6. 智能体文档规范

本仓库当前以“七文件 + `zh-CN` 镜像”作为主规范。

### 标准文件集

```text
<agent-dir>/
├── AGENTS.md
├── BOOTSTRAP.md
├── HEARTBEAT.md
├── IDENTITY.md
├── SOUL.md
├── TOOLS.md
├── USER.md
└── zh-CN/
    ├── AGENTS.md
    ├── BOOTSTRAP.md
    ├── HEARTBEAT.md
    ├── IDENTITY.md
    ├── SOUL.md
    ├── TOOLS.md
    └── USER.md
```

### 各文件职责

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | 角色定义、边界、行为准则、委派关系 |
| `SOUL.md` | 个性、语气、价值观、沟通风格 |
| `IDENTITY.md` | 身份卡、自我介绍、适用场景 |
| `TOOLS.md` | 本角色可调用的工具、交付物、工作流 |
| `USER.md` | 目标用户与服务对象信息 |
| `BOOTSTRAP.md` | 首次启动说明、初始化任务 |
| `HEARTBEAT.md` | 周期性任务、巡检与主动动作 |

### 中英文约定

- 英文文件用于运行时注入或作为主定义
- `zh-CN/` 用于团队阅读、业务交付和本地运营维护
- 新建或补齐智能体时，建议保持中英双份同步

---

## 7. 配置与部署建议

### 工作区映射原则

无论使用 OctoClaw 还是 OpenClaw 式工作区，都建议遵循：

- 每个 agent 一个独立 workspace
- 每个 agent 一个独立 `agentDir`
- 会话目录独立
- 技能目录与实际加载路径一致

### 多智能体部署建议

如果你要部署一个“团队”而不是单个角色：

- 为入口角色配置 `default: true`
- 通过 `bindings` 将渠道入口路由给入口角色
- 通过 `agent-to-agent` 仅开放必要的子角色
- 对发布、外呼、评论回复等写操作增加审批门禁

### 端口与隔离

如果你在一台机器上部署多组智能体：

- 配置文件隔离
- 状态目录隔离
- 工作区隔离
- 端口隔离
- 浏览器 / CDP / Canvas 派生端口避免重叠

这一点与旧版 OpenClaw 多网关原则一致，在 OctoClaw 场景下同样成立。

---

## 8. 常见落地场景

### 软件研发团队

推荐从 `2、Digital Workforce/9、Software & Delivery` 开始，使用：

- `technical-director` 作为入口编排者
- 项目、产品、架构、前后端、测试、运维为执行角色
- `code-reviewer`、`backend-architect` 等作为增强专家

### 内容运营团队

推荐从 `3、Content Ops/<channel>` 开始，按渠道部署七件套：

- 先部署监控、拆解、原创/二创、发布
- 再加数据助手与评论管理
- 技能先从该渠道 `README.md` 与 `SKILLS-EVALUATION.md` 中选型

### 社群与 IM 运营

推荐从 `1、IM Channels/<channel>` 开始，按 Bot 开发、社区运营、支持响应拆分角色。

---

## 9. 文档入口

### 推荐阅读顺序

1. `docs/README.md`
2. `docs/SKILLS-MASTER.md`
3. 分组 README
4. 具体子域 `README.md`
5. `CLAWHUB-SKILLS.md` / `SKILLS-SH-SKILLS.md` / `SKILLS-EVALUATION*.md`

### 快速入口

- 总技能索引：`docs/SKILLS-MASTER.md`
- IM 渠道总览：`1、IM Channels/README.md`
- 数字员工总览：`2、Digital Workforce/README.md`
- 内容运营总览：`3、Content Ops/README.md`
- 小红书完整样板：`3、Content Ops/xiaohongshu/README.md`

---

**最后更新**：2026-04-01
