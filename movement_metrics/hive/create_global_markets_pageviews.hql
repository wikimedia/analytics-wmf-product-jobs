-- Usage
--   hive -f create_global_markets_pageviews.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `global_markets_pageviews` (
    `date`     string,
    region     string  COMMENT 'Economic region as defined in canonical dataset',
    pageviews  bigint  COMMENT 'Total number of pageviews per region'
)
PARTITIONED BY (
    `year`   int,
    `month`  int,
    `day`    int
)
STORED AS PARQUET
;
