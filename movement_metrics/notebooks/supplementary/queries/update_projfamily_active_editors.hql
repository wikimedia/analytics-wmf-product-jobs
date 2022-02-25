WITH global_edits AS (
  SELECT
    database_group,
    cast(MONTH AS date) AS MONTH,
    user_name,
    sum(content_edits) AS content_edits,
    max(bot_by_group) AS bot_by_group,
    cast(trunc(min(user_registration), "MONTH") AS date) AS registration_month
  FROM wmf_product.editor_month
  INNER JOIN canonical_data.wikis ON wiki = database_code
  WHERE MONTH = CONCAT('{month}', '-01')
    AND user_id != 0
    AND database_group in (
      "commons",
      "incubator",
      "mediawiki",
      "meta",
      "species",
      "wikibooks",
      "wikidata",
      "wikinews",
      "wikipedia",
      "wikiquote",
      "wikisource",
      "wikiversity",
      "wikivoyage",
      "wiktionary")
  GROUP BY
    database_group,
    MONTH,
    user_name
)

INSERT INTO wmf_product.active_editors
SELECT
  CONCAT('{month}', '-01 00:00:00.0') AS MONTH,
  'All' AS project,
  database_group AS project_family,
  'All' AS market,
  count(1) AS active_editors,
  sum(cast(registration_month = MONTH AS int)) AS new_active_editors,
  count(1) - sum(cast(registration_month = MONTH AS int)) AS returning_active_editors
FROM global_edits
WHERE content_edits >= 5
  AND NOT bot_by_group
  AND user_name NOT regexp "bot\\b"
GROUP BY
  MONTH,
  database_group
