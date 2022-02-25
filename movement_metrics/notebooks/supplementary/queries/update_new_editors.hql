WITH 1st_month AS (
  SELECT
    event_user_text AS user_name,
    wiki_db AS wiki,
    event_user_id AS user_id,
    substr(event_user_creation_timestamp, 0, 7) AS cohort,
    count(1) AS edits
  FROM wmf.mediawiki_history
  WHERE SNAPSHOT = "{snapshot}"
    AND event_entity = "revision"
    AND event_type = "create"
    AND NOT event_user_is_created_by_system
    AND event_user_creation_timestamp BETWEEN "{start}" and "{end}"
    AND unix_timestamp(event_timestamp, "yyyy-MM-dd HH:mm:ss.0") < (unix_timestamp(event_user_creation_timestamp, "yyyy-MM-dd HH:mm:ss.0") + (30*24*60*60))
  GROUP BY
    event_user_text,
    event_user_id,
    event_user_creation_timestamp,
    wiki_db
), 2nd_month AS (
  SELECT
    event_user_text AS user_name,
    wiki_db AS wiki,
    event_user_id AS user_id,
    substr(event_user_creation_timestamp, 0, 7) AS cohort,
    count(1) AS edits
  FROM wmf.mediawiki_history
  WHERE SNAPSHOT = "{snapshot}"
    AND event_entity = "revision"
    AND event_type = "create"
    AND NOT event_user_is_created_by_system
    AND event_user_creation_timestamp BETWEEN "{start}" and "{end}"
    AND unix_timestamp(event_timestamp, "yyyy-MM-dd HH:mm:ss.0") >= (unix_timestamp(event_user_creation_timestamp, "yyyy-MM-dd HH:mm:ss.0") + (30*24*60*60))
    AND unix_timestamp(event_timestamp, "yyyy-MM-dd HH:mm:ss.0") < (unix_timestamp(event_user_creation_timestamp, "yyyy-MM-dd HH:mm:ss.0") + (60*24*60*60))
  GROUP BY
    event_user_text,
    event_user_id,
    event_user_creation_timestamp,
    wiki_db
)

INSERT OVERWRITE TABLE wmf_product.new_editors
PARTITION(cohort= "{start}")
    
SELECT
  1st_month.user_name AS user_name,
  1st_month.wiki AS wiki,
  1st_month.user_id AS user_id,
  1st_month.edits AS 1st_month_edits,
  coalesce(2nd_month.edits, 0) AS 2nd_month_edits
FROM 1st_month
LEFT JOIN 2nd_month ON (
  1st_month.user_name = 2nd_month.user_name
  AND 1st_month.wiki = 2nd_month.wiki
  AND 1st_month.cohort = 2nd_month.cohort
 )
