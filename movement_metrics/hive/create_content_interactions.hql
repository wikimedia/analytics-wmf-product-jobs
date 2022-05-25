-- Usage
--   hive -f create_content_interactions.hql --database wmf_product

CREATE TABLE IF NOT EXISTS content_interactions (
    `month`           TIMESTAMP,
    `project`         STRING  COMMENT 'Project name from requests hostname, e.g. azwikiquote, bgwikibooks',
    `project_family`  STRING  COMMENT 'Family of the wiki project, e.g. wikipedia, wikiquote',
    `agent_type`      STRING  COMMENT 'Agent accessing the pages: spider, user or automated',
    `market`          STRING  COMMENT 'Economic region as defined in canonical dataset',
    `access_method`   STRING  COMMENT 'Method used to access the pages: desktop, mobile web, or mobile app',
    `interactions`    BIGINT  COMMENT 'Number of content interactions (sum of pageviews and page previews)'
)
STORED AS PARQUET
