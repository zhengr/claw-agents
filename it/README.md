# IT 软件开发团队智能体 (IT Team Agents)

技术总监为编排者（orchestrator），可经 agent-to-agent 委派 12 个子角色。使用 `config/openclaw-it-fragment.json` 合并 `agents`、`bindings`、`tools.agentToAgent`。

## 初始化命令（与 company 同规则）

以下命令在 OpenClaw 配置已就绪的前提下执行；`--workspace` 使用无编号路径（与 agent id 一致），需先将本仓库 `it/<N-xxx>/` 复制或链接到 `~/.openclaw/workspace-it/<agent-id>`。

### 1. 查看当前智能体列表

```bash
openclaw agents list
```

### 2. 添加 IT 团队智能体（14 个）

```bash
openclaw agents add technical-director  --workspace ~/.openclaw/workspace-it/technical-director
openclaw agents add project-manager    --workspace ~/.openclaw/workspace-it/project-manager
openclaw agents add product-manager    --workspace ~/.openclaw/workspace-it/product-manager
openclaw agents add system-architect   --workspace ~/.openclaw/workspace-it/system-architect
openclaw agents add domain-expert      --workspace ~/.openclaw/workspace-it/domain-expert
openclaw agents add ux-designer       --workspace ~/.openclaw/workspace-it/ux-designer
openclaw agents add ui-designer       --workspace ~/.openclaw/workspace-it/ui-designer
openclaw agents add backend-engineer   --workspace ~/.openclaw/workspace-it/backend-engineer
openclaw agents add database-engineer  --workspace ~/.openclaw/workspace-it/database-engineer
openclaw agents add frontend-engineer  --workspace ~/.openclaw/workspace-it/frontend-engineer
openclaw agents add mobile-engineer    --workspace ~/.openclaw/workspace-it/mobile-engineer
openclaw agents add qa-engineer        --workspace ~/.openclaw/workspace-it/qa-engineer
openclaw agents add ops-engineer       --workspace ~/.openclaw/workspace-it/ops-engineer
openclaw agents add data-analyst       --workspace ~/.openclaw/workspace-it/data-analyst
```

### 3. 查看当前绑定

```bash
openclaw agents bindings
```

### 4. 按渠道绑定智能体（示例）

片段默认将 telegram、discord 路由到 technical-director；若需用 CLI 显式绑定或增加企微等：

```bash
openclaw agents bind --agent technical-director --bind telegram:technical-director
openclaw agents bind --agent technical-director --bind discord:technical-director
openclaw agents bind --agent technical-director --bind wecom:technical-director
```

合并 `config/openclaw-it-fragment.json` 后，其 `bindings` 与 `tools.agentToAgent` 会一并生效；须设置 `tools.agentToAgent.enabled: true` 并将上述 14 个 id 列入 `allow`，编排者方可委派子角色。
