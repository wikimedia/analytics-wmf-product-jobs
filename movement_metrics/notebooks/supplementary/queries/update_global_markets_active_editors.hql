WITH global_market_editors AS (
  SELECT
    economic_region AS market,
    sum(edit_count) AS edit_count,
    sum(namespace_zero_edit_count) AS namespace_zero_edit_count,
    max(size(user_is_bot_by) > 0) AS bot
  FROM wmf.editors_daily gd
  LEFT JOIN canonical_data.countries cdc ON gd.country_code = cdc.iso_code
  WHERE MONTH = '{month}'
    AND economic_region IN ("Global South" , "Global North")
    AND NOT user_is_anonymous
    AND gd.action_type = 0
  GROUP BY economic_region, user_fingerprint_or_name
)

INSERT INTO wmf_product.active_editors
SELECT
  CONCAT('{month}', '-01 00:00:00.0') AS MONTH,
  "All" AS project,
  "All" AS project_family,
  market,
  sum(cast(namespace_zero_edit_count >= 5 AND NOT bot AS int)) AS active_editors,
  0 AS new_active_editors,
  0 AS returning_active_editors
FROM global_market_editors
GROUP BY market
