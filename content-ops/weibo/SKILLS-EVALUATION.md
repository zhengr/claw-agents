# 微博七件套技能评估报告

> 基于 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md) 与 [skills.sh weibo/baoyu](https://skills.sh/?q=weibo)，结合七件套 Agent 实际需求做分组与最终推荐。原则：**ClawHub 为主、skills.sh 取最优；同能力只保留一个最优技能。** 微博 ClawHub 技能待补充，当前以 skills.sh Baoyu 为主；发布可选用 baoyu-post-to-weibo 或 social-push。

## 一、七件套所需能力与技能映射

| Agent | 所需能力 | 推荐技能 | 来源 |
|-------|----------|----------|------|
| weibo-hot-monitor | 链接抓取、日报格式 | baoyu-url-to-markdown, baoyu-format-markdown | skills.sh |
| weibo-viral-breakdown | 抓取成文、拆解格式 | baoyu-url-to-markdown, baoyu-format-markdown | skills.sh |
| weibo-rewrite / weibo-write | 封面与配图 | baoyu-cover-image, baoyu-article-illustrator | skills.sh |
| weibo-publisher | 发布前压缩；发布 | baoyu-compress-image；baoyu-post-to-weibo 或 social-push | skills.sh |
| weibo-data-assistant | 报告格式 | baoyu-format-markdown | skills.sh |
| weibo-comment-manager | 回复建议；评论采集 | 按需 ClawHub/skills.sh | — |

## 二、同质技能「谁更好」一览

| 能力 | 首选 | 备选/不重复装 |
|------|------|----------------|
| 链接→Markdown | baoyu-url-to-markdown | — |
| 报告/拆解格式 | baoyu-format-markdown | — |
| 封面/长文配图 | baoyu-cover-image, baoyu-article-illustrator | — |
| 发布到微博 | baoyu-post-to-weibo 或 social-push | 按需选一 |
| 图片压缩 | baoyu-compress-image | — |

## 三、最终推荐：按 Agent 的技能清单

| 步骤 | Agent id | 推荐技能 | 来源 | 说明 |
|------|----------|----------|------|------|
| 1 | weibo-hot-monitor | baoyu-url-to-markdown, baoyu-format-markdown | skills.sh | 抓取+日报格式 |
| 2 | weibo-viral-breakdown | baoyu-url-to-markdown, baoyu-format-markdown | skills.sh | 抓取成文+拆解格式 |
| 3a | weibo-rewrite | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 封面与配图 |
| 3b | weibo-write | baoyu-cover-image, baoyu-article-illustrator | skills.sh | 同 rewrite |
| 4 | weibo-publisher | baoyu-compress-image；可选 baoyu-post-to-weibo / social-push | skills.sh | 压缩+发布 |
| 5 | weibo-data-assistant | baoyu-format-markdown | skills.sh | 报告格式 |
| 6 | weibo-comment-manager | （按需选评论采集与回复技能） | ClawHub/skills.sh | 评论拉取、回复草稿 |

## 四、安装命令

**第一步：安装 SkillHub CLI**

```bash
curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

**第二步：安装技能**

**ClawHub** — `clawhub search weibo` 后按需 `clawhub install <slug>`（当前微博技能待补充）。

**skills.sh（Baoyu）**

```bash
npx skills add jimliu/baoyu-skills --skill baoyu-url-to-markdown -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-format-markdown -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-cover-image -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-article-illustrator -y -g;
npx skills add jimliu/baoyu-skills --skill baoyu-compress-image -y -g;
# 可选：微博发布
# npx skills add jimliu/baoyu-skills --skill baoyu-post-to-weibo -y -g;
```

安装后目录名需与 config 中 `skills` 一致。**勿在 TOOLS.md 存凭证。**

---

*完整技能表见 [CLAWHUB-SKILLS.md](./CLAWHUB-SKILLS.md)、本目录 README 下方技能表。*
