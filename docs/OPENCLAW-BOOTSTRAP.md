# OpenClaw Bootstrap Flow

这份文档只解决一件事：把仓库里的 agent workspace，稳定地装配成 OpenClaw 可运行的 agent/group。

## 标准脚本

- `scripts/init-openclaw-agent.sh`
  - 初始化单个 agent。
  - 先调用 `openclaw agents add` 创建隔离 agent，再把仓库里的 workspace 内容同步过去，最后补齐 config 里的 `name`、`skills`、`tools`、`subagents` 等字段。
  - 不写死模型；模型由用户在自己的 OpenClaw 配置里后置调整。
- `scripts/init-openclaw-group.sh`
  - 按一个 config fragment 批量初始化一组 agent。
  - 适合内容运营七件套、软件交付岗位组、数字员工岗位组。
- `scripts/verify-openclaw-group.sh`
  - 校验 config、workspace 路径、workspace 内容是否和仓库源目录一致。
  - 可选追加一次 `openclaw agent --local` 烟雾测试。

## 小红书一键命令

- `scripts/bootstrap-xiaohongshu-pipeline.sh`
  - 使用 `config/openclaw-xiaohongshu-ops-delegation-example.json`
  - 源目录：
    - `3、Content Ops/xiaohongshu`
    - `2、Digital Workforce/1、Company Manger/6-content-ops-assistant`
- `scripts/verify-xiaohongshu-pipeline.sh`
  - 校验上面的整条小红书链路。
- `scripts/smoke-test-xiaohongshu.sh`
  - 在隔离的 `/tmp` OpenClaw 环境中自举并验证整条小红书链路。

## 推荐用法

### 1. 先在隔离环境里自测

```bash
cd /Users/wandl/workspaces/workspace-partme-ai/openclaw-agents
./scripts/smoke-test-xiaohongshu.sh
```

如果你已经在自己的 OpenClaw 配置里准备好了可用默认模型，再加：

```bash
./scripts/smoke-test-xiaohongshu.sh --with-local-turn
```

### 2. 真正安装到你的 OpenClaw

```bash
cd /Users/wandl/workspaces/workspace-partme-ai/openclaw-agents
./scripts/bootstrap-xiaohongshu-pipeline.sh \
  --workspace-root "$HOME/.openclaw" \
  --state-dir "$HOME/.openclaw" \
  --config-path "$HOME/.openclaw/openclaw.json"
```

### 3. 安装后回归校验

```bash
cd /Users/wandl/workspaces/workspace-partme-ai/openclaw-agents
./scripts/verify-xiaohongshu-pipeline.sh \
  --workspace-root "$HOME/.openclaw" \
  --state-dir "$HOME/.openclaw" \
  --config-path "$HOME/.openclaw/openclaw.json"
```

## 设计原则

- 真实源目录以仓库当前落地结构为准，不再假设旧文档里的 `content-ops/`、`company/` 英文目录已经存在。
- `openclaw agents add` 负责创建隔离 agent。
- 仓库 workspace 负责角色定义与中文/英文提示词。
- config fragment 负责 `skills`、`subagents.allowAgents`、能力限制等治理字段。
- config fragment 不携带 `model`；模型选择属于用户本地运行策略，不属于岗位模板真相源。
- bootstrap 与 verify 都支持反复执行，便于反复回归。
