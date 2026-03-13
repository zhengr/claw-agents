# 抖音七件套技能评估报告

> 基于 [SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)（skills.sh）与 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)（ClawHub），结合七件套 Agent 实际需求做分组、同质对比与最终推荐。原则：**ClawHub 为主、skills.sh 取最优；同能力只保留一个最优技能。**

## 一、七件套所需能力与技能映射

| Agent | 所需能力 | 推荐技能 | 来源 |
|-------|----------|----------|------|
| douyin-hot-monitor | 热点/热榜、日报格式 | douyin-hot-trend；baoyu-url-to-markdown, baoyu-format-markdown | ClawHub + skills.sh |
| douyin-viral-breakdown | 视频抓取/下载、拆解格式 | douyin-downloader 或 douyin-video-fetch；baoyu-format-markdown | ClawHub + skills.sh |
| douyin-rewrite / douyin-write | 封面与配图 | baoyu-cover-image, baoyu-article-illustrator | skills.sh |
| douyin-publisher | 发布、发布前压缩 | douyin-publish 或 douyin-video-publish；baoyu-compress-image | ClawHub + skills.sh |
| douyin-data-assistant | 报告格式 | baoyu-format-markdown | skills.sh |
| douyin-comment-manager | 回复建议；评论采集 | 按需 ClawHub/skills.sh | — |

## 二、同质技能「谁更好」一览

| 能力 | 首选 | 备选/不重复装 |
|------|------|----------------|
| 链接→Markdown / 日报格式 | baoyu-url-to-markdown, baoyu-format-markdown | — |
| 抖音热榜/热搜 | douyin-hot-trend（ClawHub 2.9k） | — |
| 抖音视频下载 | douyin-downloader（1.9k）或 douyin-video-fetch（1.7k） | douyin-download, douyin-video-downloader 等同质只装一处 |
| 报告/拆解格式 | baoyu-format-markdown | — |
| 封面/配图 | baoyu-cover-image, baoyu-article-illustrator | — |
| 发布到抖音 | douyin-publish（2.3k）或 douyin-video-publish | douyin-upload-skill, fast-douyin-publish 等按需选一 |
| 图片压缩 | baoyu-compress-image | — |

## 三、最终推荐：按 Agent 的技能清单

| 步骤 | Agent id | 推荐技能 | 来源 | 说明 |
|------|----------|----------|------|------|
| 1 | douyin-hot-monitor | douyin-hot-trend, baoyu-url-to-markdown, baoyu-format-markdown | ClawHub + skills.sh | 热榜+抓取+日报格式 |
| 2 | douyin-viral-breakdown | douyin-downloader 或 douyin-video-fetch, baoyu-format-markdown | ClawHub + skills.sh | 视频下载+拆解格式 |
| 3a | douyin-rewrite | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 封面与配图 |
| 3b | douyin-write | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 同 rewrite |
| 4 | douyin-publisher | douyin-publish, baoyu-compress-image | ClawHub + skills.sh | 发布+压缩；须遵守平台 ToS |
| 5 | douyin-data-assistant | baoyu-format-markdown | skills.sh | 报告格式 |
| 6 | douyin-comment-manager | （按需选评论采集与回复技能） | ClawHub/skills.sh | 评论拉取、回复草稿 |

## 四、安装命令

**第一步：安装 SkillHub CLI**

```bash
curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

**第二步：安装技能**

**ClawHub**

```bash
clawhub search douyin
clawhub install douyin-hot-trend
clawhub install douyin-downloader
clawhub install douyin-publish
```

**skills.sh（Baoyu）**

```bash
npx skills add jimliu/baoyu-skills --skill baoyu-url-to-markdown -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-format-markdown -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-cover-image -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-article-illustrator -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-compress-image -y -g;
```

安装后目录名需与 config 中 `skills` 一致。发布与抓取须遵守抖音开放平台与平台 ToS。**勿在 TOOLS.md 存凭证。**

---

*完整技能表见 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)、[SKILLS-SH-SKILLS.md](./SKILLS-SH-SKILLS.md)。*
