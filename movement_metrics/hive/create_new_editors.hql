-- Usage
--   hive -f create_new_editors.hql --database wmf_product

CREATE EXTERNAL TABLE IF NOT EXISTS `new_editors` (
    `user_name`        STRING  COMMENT 'User id of the editor',
    `wiki`             STRING  COMMENT 'Wiki project the editors worked in',
    `user_id`          BIGINT  COMMENT 'User id of the editor',
    `1st_month_edits`  BIGINT  COMMENT 'Number of edits made by the user in the first 30 days of registration',
    `2nd_month_edits`  BIGINT  COMMENT 'Number of edits made by the user between 31 to 60 days of registration'
)
PARTITIONED BY (`cohort` STRING)
STORED AS PARQUET
