# B站七件套技能评估报告

> 基于 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) 与 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)，结合 B 站七件套 Agent 实际需求做分组与最终推荐。原则：**ClawHub 为主、skills.sh 取最优；同能力只保留一个最优技能。** B 站链路为：热门监控 → 内容创作助手 → 视频发布 → 数据助手 → 爆款拆解 → 写作 → 评论管理。

## 一、七件套所需能力与技能映射

| Agent | 所需能力 | 推荐技能 | 来源 |
|-------|----------|----------|------|
| bilibili-hot-monitor | 热门日报、UP 更新 | bilibili-hot-monitor, bilibili-update-viewer | ClawHub |
| bilibili-content-helper | 标题/标签/简介、字幕总结 | bilibili-helper, bilibili-subtitle-download-skill | ClawHub |
| bilibili-video-publisher | 创作者平台发布、投稿 | bilibili-video-publish, bilibili-upload | ClawHub |
| bilibili-data-assistant | 搜索与数据分析、统计报告 | bilibili-analytics | ClawHub |
| bilibili-viral-breakdown | 爆款视频拆解、框架输出 | baoyu-format-markdown；可选 bilibili 相关 | skills.sh + ClawHub |
| bilibili-write | 原创脚本与配图方向 | baoyu-cover-image, baoyu-article-illustrator | skills.sh |
| bilibili-comment-manager | 评论/弹幕拉取、回复草稿 | 按需 ClawHub/skills.sh | — |

## 二、同质技能「谁更好」一览

| 能力 | 首选 | 备选/不重复装 |
|------|------|----------------|
| B站热门/日报 | bilibili-hot-monitor（ClawHub 4.4k） | — |
| UP 主更新检查 | bilibili-update-viewer（ClawHub） | — |
| 标题/标签/简介/字幕 | bilibili-helper, bilibili-subtitle-download-skill | — |
| 视频发布/投稿 | bilibili-video-publish, bilibili-upload | biliup-skills 等选一 |
| 数据分析/统计 | bilibili-analytics | — |
| 报告/拆解格式 | baoyu-format-markdown | — |
| 封面/配图 | baoyu-cover-image, baoyu-article-illustrator | — |

## 三、最终推荐：按 Agent 的技能清单（按执行链路顺序）

| 步骤 | Agent id | 推荐技能 | 来源 | 说明 |
|------|----------|----------|------|------|
| 1 | bilibili-hot-monitor | bilibili-hot-monitor, bilibili-update-viewer | ClawHub | 热门日报、UP 更新检查 |
| 2 | bilibili-content-helper | bilibili-helper, bilibili-subtitle-download-skill | ClawHub | 标题/标签/简介、字幕总结 |
| 3 | bilibili-video-publisher | bilibili-video-publish, bilibili-upload | ClawHub | 创作者平台发布、CLI 投稿 |
| 4 | bilibili-data-assistant | bilibili-analytics | ClawHub | 搜索与数据分析、统计报告 |
| 5 | bilibili-viral-breakdown | baoyu-format-markdown | skills.sh | 爆款拆解、框架输出 |
| 6 | bilibili-write | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 原创脚本与配图方向 |
| 7 | bilibili-comment-manager | （按需选评论/弹幕采集与回复技能） | ClawHub/skills.sh | 评论/弹幕拉取、回复草稿 |

## 四、安装命令

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

安装后目录名需与 config 中 `skills` 一致。投稿/发布类技能通常需浏览器登录或 B 站凭证，**勿在 TOOLS.md 存凭证。**

---

*完整技能表见 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)、[SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)。*
