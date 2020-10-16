SET citus.replication_model TO 'streaming'; -- 设置流复制

select start_metadata_sync_to_node('citus_work_1',5432);-- 将元数据拷贝至指定worker节点

create table tb2(id int primary key, c1 int); -- 建表
set citus.shard_count=8; -- 调整分片数量，所谓分片，就是子表，存储了整个表的一部分，citus会对一个查询中涉及到的所有分片进行并行查询，分片越多，并行的数量就越大，那么最终耗时就越少。在citus该设置是：“citus.shard_count”，默认32，我们可以适当调大，但也不是没有限制，每个查询都会建立一个连接来执行，不能超过PostgreSQL的最大连接数。
select create_distributed_table('tb1','id','hash'); -- 表分片  distributed table：分片表，rows会分布在 worker节点中。主要用于大量数据的事实表。reference table：广播表，每个 worker 节点都保存一模一样的数据。主要用于维度表。
select create_reference_table('tb2')

SELECT master_create_worker_shards('tb1', 2, 2); -- 设定分片个数及每个分片副本数

select * from pg_dist_node; -- 查看worker节点

SELECT  *  FROM  master_get_active_worker_nodes(); -- 查看节点名称  端口

insert into tb1 select id,random()*1000 from generate_series(1,100)id;

select * from tb1