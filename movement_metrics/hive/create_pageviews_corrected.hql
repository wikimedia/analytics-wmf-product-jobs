-- Usage
--   hive -f create_pageviews_corrected.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `pageviews_corrected` (
    `date`       STRING,
    `apps`       BIGINT  COMMENT 'Pageviews with access_method = \'mobile app\'',
    `desktop`    BIGINT  COMMENT 'Pageviews with access_method = \'desktop\'',
    `mobileweb`  BIGINT  COMMENT 'Pageviews with access_method = \'mobile web\'',
    `total`      BIGINT  COMMENT 'Total pageviews across all access methods'
)
PARTITIONED BY (
    `year`   INT,
    `month`  INT,
    `day`    INT
)
STORED AS PARQUET
