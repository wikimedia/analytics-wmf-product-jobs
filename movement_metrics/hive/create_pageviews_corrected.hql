-- Usage
--   hive -f create_pageviews_corrected.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `pageviews_corrected` (
    `date`       string,
    `apps`       bigint  COMMENT 'Pageviews with access_method = \'mobile app\'',
    `desktop`    bigint  COMMENT 'Pageviews with access_method = \'desktop\'',
    `mobileweb`  bigint  COMMENT 'Pageviews with access_method = \'mobile web\'',
    `total`      bigint  COMMENT 'Total pageviews across all access methods'
)
PARTITIONED BY (
    `year`   int,
    `month`  int,
    `day`    int
)
STORED AS PARQUET
;
