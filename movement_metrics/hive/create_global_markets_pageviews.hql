-- Usage
--   hive -f create_global_markets_pageviews.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `global_markets_pageviews` (
    `date`     STRING,
    region     STRING  COMMENT 'Economic region as defined in canonical dataset',
    pageviews  BIGINT  COMMENT 'Total number of pageviews per region'
)
PARTITIONED BY (
    `year`   INT,
    `month`  INT,
    `day`    INT
)
STORED AS PARQUET
