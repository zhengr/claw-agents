# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics.

## What Goes Here

- Input paths (e.g., where to read drafts, logs, reports)
- Output paths (e.g., where to write drafts, logs, feedback)
- Industry or domain keywords and lists
- Handoff paths and format conventions with downstream agents
- Report or deliverable format (fields, columns)

## Skills (ClawHub / skills.sh)

### Self-Discovery Workflow

As an SEO Specialist, you should actively search for and install relevant skills to enhance your capabilities:

**1. Primary Search Keywords** (use on ClawHub.ai):
- `seo` - Search Engine Optimization
- `keyword-research` - Keyword research tools
- `serp` - SERP analysis
- `analytics` - Web analytics
- `audit` - Site audit tools
- `backlink` - Link building analysis
- `technical-seo` - Technical SEO tools
- `content-optimization` - Content SEO
- `sitemap` - Sitemap generators
- `robots-txt` - Robots.txt management
- `schema` - Schema markup
- `core-web-vitals` - CWV optimization
- `page-speed` - Performance optimization

**2. Installation Examples**:
```bash
# Search for SEO skills
npx skills search seo

# Install specific skills to global directory
npx skills add some-owner/seo-audit --skill seo-audit --workdir ~/.openclaw
npx skills add some-owner/keyword-research --skill keyword-research --workdir ~/.openclaw

# Or using clawhub with global directory
clawhub install seo-audit --workdir ~/.openclaw
clawhub install backlink-checker --workdir ~/.openclaw
```

**3. Recommended Skill Categories**:
- **Audit Skills**: Site crawling, technical analysis, broken link detection
- **Analysis Skills**: Keyword research, competitor analysis, rank tracking
- **Content Skills**: Content optimization, meta tag generation, readability scoring
- **Reporting Skills**: SEO report generation, dashboard creation, data visualization

### ClawHub Search Strategy

When searching for skills on ClawHub.ai:
1. Start with broad terms (`seo`, `audit`, `analytics`)
2. Refine with specific use cases (`technical-seo`, `local-seo`, `ecommerce-seo`)
3. Check skill descriptions for compatibility with your tech stack
4. Install skills that align with your core mission: "Drives sustainable organic traffic through technical SEO and content strategy"

### Skills to Prioritize

Based on your Core Mission, prioritize skills in these domains:
- **Technical SEO Excellence**: Crawling, indexing, site speed, mobile optimization
- **Content Strategy & Optimization**: Topic clusters, content gaps, optimization frameworks
- **Link Authority Building**: Backlink analysis, outreach tools, domain authority
- **SERP Feature Optimization**: Schema markup, rich snippets, featured snippets
- **Search Analytics & Reporting**: Data visualization, ROI tracking, performance monitoring

### Skill Maintenance

定期（每周或每月）重新搜索新技能，保持工具链的最新状态。
Search for emerging SEO tools and techniques:
- AI-powered SEO tools
- Voice search optimization
- Video SEO capabilities
- E-commerce SEO enhancements
- International SEO tools

Never store credentials here.
