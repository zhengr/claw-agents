# TOOLS.md - Local Notes

Skills 定义“工具如何工作”；本文件记录“你在本智能体中的本地约定”。

## What Goes Here

- 异常数据输入路径：如 `NEEDS_AI` 队列、待修复分区表、抽样文件目录
- 修复结果输出路径：如 staging 表、隔离区队列、人工复核看板数据源
- 审计记录约定：`Row_ID / Old_Value / New_Value / Lambda / Confidence / Model_Version / Timestamp`
- 安全校验约定：lambda 白名单/黑名单规则、最小置信度阈值、升级告警条件

## Skills

- 保持“AI 只生成修复逻辑，不直接改写原始数据”的边界。
- 保持“Source = Success + Quarantine”的对账校验为强制门禁。

不要在此文件存储任何凭证信息。
