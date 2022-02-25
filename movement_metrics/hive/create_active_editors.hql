-- Usage
--   hive -f create_active_editors.hql --database wmf_product

CREATE TABLE IF NOT EXISTS `active_editors` (
  `month`                     TIMESTAMP,
  `project`                   STRING  COMMENT 'Wiki project the editors worked in, for example: enwiki, azwikiquote, bgwikibooks etc.',
  `project_family`            STRING  COMMENT 'Family of the wiki project the editors worked in, for example: wikipedia, wikiquote, wiktionary, wikisource etc.',
  `market`                    STRING  COMMENT 'Economic region of the editors country',
  `active_editors`            BIGINT  COMMENT 'Number of editors who had 5 or more content edits',
  `new_active_editors`        BIGINT  COMMENT 'Number of active editors who registered in the current month',
  `returning_active_editors`  BIGINT  COMMENT 'Number of active editors who edited in the current month but registered in prior months'
)
STORED AS PARQUET
