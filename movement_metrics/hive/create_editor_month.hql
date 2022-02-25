-- Usage
--   hive -f create_editor_month.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `editor_month` (
  `month`                TIMESTAMP, -- Hive 1.1 does not support the DATE type
  `wiki`                 STRING   COMMENT 'Wiki project the editors worked in',
  `user_id`              BIGINT   COMMENT 'User id of the editor',
  `user_name`            STRING   COMMENT 'User name of the editor',
  `edits`                BIGINT   COMMENT 'Number of all edits made by the editor',
  `content_edits`        BIGINT   COMMENT 'Number of content (article, ns 0) edits made by the editor',
  `mobile_web_edits`     BIGINT   COMMENT 'Number of mobile edits made by the editor',
  `mobile_app_edits`     BIGINT   COMMENT 'Number of app edits made by the editor',
  `visual_edits`         BIGINT   COMMENT 'Number of edits made by the editor using visual editor interface',
  `2017_wikitext_edits`  BIGINT   COMMENT 'Number of edits made by the editor using wikitext editor interface',
  `bot_by_group`         BOOLEAN  COMMENT 'Identifies if the editor is a bot or not',
  -- NOTE: bot_by_group should just be `bot` since this field is based on both group and name
  `user_registration`    TIMESTAMP
)
STORED AS PARQUET
