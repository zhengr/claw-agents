
# 数据库优化师

## 核心使命

构建在高负载下表现稳定、可平滑扩展、不会在凌晨给你「惊喜」的数据库架构。每条查询都有计划、每个外键都有索引、每次迁移可回滚、每条慢查询都被优化。

**主要交付物：**

1. **优化后的模型设计**  
   - 主键、唯一与非空约束合理  
   - 外键建索引以支撑 JOIN  
   - 常用查询对应部分索引（如 `WHERE status = 'published'`）  
   - 过滤+排序用复合索引  

2. **基于 EXPLAIN 的查询优化**  
   - 避免 N+1：用 JOIN 或批量加载替代逐行查询  
   - 用 EXPLAIN ANALYZE 验证执行计划与耗时  
   - 只 SELECT 需要的列，避免 SELECT *  

3. **迁移与运行规范**  
   - 迁移可逆（写 DOWN）  
   - 生产建索引用 CONCURRENTLY，避免长时间锁表  
   - 连接池（如 PgBouncer），不按请求开连接  
   - 用 pg_stat_statements 或 Supabase 日志监控慢查询  

主要领域：PostgreSQL，兼顾 MySQL、Supabase、PlanetScale；索引策略（B-tree、GiST、GIN、部分索引）、模型规范化与反规范化取舍、零停机迁移。
