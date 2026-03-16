# TOOLS.md - 本地备注

技能定义工具的行为；本文件记录你的具体配置。

## 可写内容

- 输入路径（如草稿、日志、报告的读取位置）
- 输出路径（如草稿、日志、反馈的写入位置）
- 行业或领域相关关键词与列表
- 与下游的交接路径与格式约定
- 报告或产出物格式（字段、列等）

## 技能（ClawHub / skills.sh）

### 自我发现工作流

作为 SEO 专家，你应该主动搜索并安装相关技能以增强你的能力：

**1. 主要搜索关键词**（在 ClawHub.ai 上使用）：
- `seo` - Search Engine Optimization（搜索引擎优化）
- `keyword-research` - Keyword research tools（关键词研究工具）
- `serp` - SERP analysis（搜索引擎结果页分析）
- `analytics` - Web analytics（网站分析）
- `audit` - Site audit tools（网站审计工具）
- `backlink` - Link building analysis（链接建设分析）
- `technical-seo` - Technical SEO tools（技术 SEO 工具）
- `content-optimization` - Content SEO（内容优化）
- `sitemap` - Sitemap generators（网站地图生成）
- `robots-txt` - Robots.txt management（爬虫规则管理）
- `schema` - Schema markup（结构化数据标记）
- `core-web-vitals` - CWV optimization（核心网页指标优化）
- `page-speed` - Performance optimization（页面性能优化）

**2. 安装示例**：
```bash
# 搜索 SEO 技能
npx skills search seo

# 安装特定技能到全局目录
npx skills add some-owner/seo-audit --skill seo-audit --workdir ~/.openclaw
npx skills add some-owner/keyword-research --skill keyword-research --workdir ~/.openclaw

# 或使用 clawhub 指定全局目录
clawhub install seo-audit --workdir ~/.openclaw
clawhub install backlink-checker --workdir ~/.openclaw
```

**3. 推荐技能类别**：
- **审计技能**：网站爬取、技术分析、死链检测
- **分析技能**：关键词研究、竞争对手分析、排名跟踪
- **内容技能**：内容优化、元标签生成、可读性评分
- **报告技能**：SEO 报告生成、仪表板创建、数据可视化

### ClawHub 搜索策略

在 ClawHub.ai 上搜索技能时：
1. 从广泛术语开始（`seo`、`audit`、`analytics`）
2. 用特定用例细化（`technical-seo`、`local-seo`、`ecommerce-seo`）
3. 检查技能描述是否与你的技术栈兼容
4. 安装与你的核心使命一致的技能："通过技术 SEO 和内容策略推动可持续的自然流量增长"

### 优先考虑的技能

基于你的核心使命，优先考虑以下领域的技能：
- **技术 SEO 卓越**：爬取、索引、网站速度、移动端优化
- **内容策略与优化**：主题集群、内容缺口、优化框架
- **链接权威建设**：外链分析、推广工具、域名权威
- **SERP 功能优化**：结构化数据标记、富摘要、精选摘要
- **搜索分析与报告**：数据可视化、ROI 跟踪、性能监控

### 技能维护

定期（每周或每月）重新搜索新技能，保持工具链的最新状态。
搜索新兴的 SEO 工具和技术：
- AI 驱动的 SEO 工具
- 语音搜索优化
- 视频 SEO 能力
- 电商 SEO 增强
- 国际 SEO 工具

勿在此存储凭证。
