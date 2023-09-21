INSERT INTO wmf_product.editor_month
SELECT
  trunc(event_timestamp, "MONTH") AS MONTH,
  wiki_db AS wiki,
  event_user_id AS user_id,
  max(event_user_text) AS user_name, -- Some rows incorrectly have a null `event_user_text` (T218463)
  count(1) AS edits,
  coalesce(sum(ns_map.namespace_is_content), 0) AS content_edits,
  NULL AS mobile_web_edits,
  NULL AS mobile_app_edits,
  NULL AS visual_edits,
  NULL AS `2017_wikitext_edits`,
  max(size(event_user_is_bot_by) > 0 OR size(event_user_is_bot_by_historical) > 0) AS bot_by_group,
  min(event_user_creation_timestamp) AS user_registration
FROM wmf.mediawiki_history mwh
INNER JOIN canonical_data.wikis ON wiki_db = database_code
  AND database_group IN (
    "commons",
    "incubator",
    "foundation",
    "mediawiki",
    "meta",
    "sources",
    "species",
    "wikibooks",
    "wikidata",
    "wikifunctions",
    "wikinews",
    "wikipedia",
    "wikiquote",
    "wikisource",
    "wikiversity",
    "wikivoyage",
    "wiktionary"
  )
LEFT JOIN wmf_raw.mediawiki_project_namespace_map ns_map -- Avoid `page_namespace_is_content` to work around T221338
  ON wiki_db = dbname
 AND coalesce(page_namespace_historical, page_namespace) = namespace
 AND ns_map.snapshot = "{mwh_snapshot}"
 AND mwh.snapshot = "{mwh_snapshot}"
WHERE event_timestamp BETWEEN "{start}" AND "{end}"
  AND event_entity = "revision"
  AND event_type = "create"
  AND mwh.snapshot = "{mwh_snapshot}"
GROUP BY
  trunc(event_timestamp, "MONTH"),
  wiki_db,
  event_user_id
