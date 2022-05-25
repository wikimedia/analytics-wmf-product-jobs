WITH pageviews AS (
  SELECT
    CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-01 00:00:00.0') AS MONTH,
    'pageviews' AS TYPE,
    project,
    canonical.database_group AS project_family,
    agent_type,
    countries.economic_region AS market,
    access_method,
    SUM(view_count) AS interactions
  FROM wmf.pageview_hourly pv
  LEFT JOIN canonical_data.countries AS countries ON pv.country_code = countries.iso_code
  LEFT JOIN canonical_data.wikis AS canonical ON CONCAT(pv.project, '.org') = canonical.domain_name
  WHERE (YEAR = {YEAR}
    AND MONTH = {MONTH})
    AND agent_type != 'spider'
    AND NOT (country_code IN ('PK','IR','AF')
      AND user_agent_map['browser_family'] = 'IE')
  GROUP BY CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-01 00:00:00.0'),
    canonical.database_group,
    project,
    agent_type,
    access_method,
    countries.economic_region

), previews AS (
  SELECT
    CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-01 00:00:00.0') AS MONTH,
    'previews' AS TYPE,
    project,
    canonical.database_group AS project_family,
    agent_type,
    countries.economic_region AS market,
    access_method,
    SUM(view_count) AS interactions
  FROM wmf.virtualpageview_hourly pv
  LEFT JOIN canonical_data.countries AS countries ON pv.country_code = countries.iso_code
  LEFT JOIN canonical_data.wikis AS canonical ON CONCAT(pv.project, '.org') = canonical.domain_name
  WHERE (YEAR = {YEAR}
    AND MONTH = {MONTH})
    AND agent_type != 'spider'
  GROUP BY CONCAT(YEAR, '-', LPAD(MONTH, 2, '0'), '-01 00:00:00.0'),
    canonical.database_group,
    project,
    agent_type,
    access_method,
    countries.economic_region

), content_interactions AS (
  SELECT * FROM pageviews
  UNION ALL
  SELECT * FROM previews
)

INSERT INTO wmf_product.content_interactions
  SELECT
    month,
    project,
    project_family,
    agent_type,
    market,
    access_method,
    sum(interactions) AS interactions
  FROM content_interactions
  GROUP BY MONTH,
    project,
    project_family,
    agent_type,
    market,
    access_method