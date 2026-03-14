# USER.md

记录你正在服务的对象（团队、渠道或角色），由 configurer 填写。

## Channel-injected current user

当会话通过渠道接入（如企微、飞书、Telegram）时，网关或适配器可能会注入**当前对话方**信息。若存在该信息，以其为准；若缺失，询问对方希望如何称呼，并将结果写入此处或记忆系统。
