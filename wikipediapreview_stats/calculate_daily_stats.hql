-- Generates Wikipedia Preview daily stats
--
-- This job is responsible for filtering pageview data from the ${source_table},
-- and then aggregating it into interesting dimensions.
-- Those values are finally concatenated to previously computed data available in
-- ${archive_table}.
-- This dataset is inserted in a temporary external table which format is TSV
-- The end of the oozie job then moves this file to the archive table directory,
-- overwriting the exisiting file.
--
-- Parameters:
--     source_table      -- table containing source data
--     archive_table     -- Fully qualified table name where
--                          to find archived data.
--     temporary_directory
--                       -- Temporary directory to store computed data
--     year              -- year of the to-be-generated
--     month             -- month of the to-be-generated
--     day               -- day of the to-be-generated
--
--
-- Usage:
--     hive -f calculate_daily_stats.hql
--         -d source_table=wmf.webrequest
--         -d archive_table=wmf_product.wikipediapreview_stats
--         -d archive_directory=/user/wmf_product/wikipediapreview_stats/daily
--         -d temporary_directory=/tmp/analytics-product_wikipediapreview_stats
--         -d year=2020
--         -d month=10
--         -d day=20
--

-- Set compression codec to gzip to provide asked format
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress.codec=org.apache.hadoop.io.compress.GzipCodec;

-- Create archive table if it doesn't already exist
CREATE EXTERNAL TABLE IF NOT EXISTS ${archive_table} (
    `pageviews`      bigint  COMMENT 'Number of pageviews shown as a result of a clickthrough from a Wikipedia Preview preview',
    `previews`       bigint  COMMENT 'Number of API requests for article preview content made by Wikipedia Preview clients',
    `year`           int     COMMENT 'Unpadded year of request',
    `month`          int     COMMENT 'Unpadded month of request',
    `day`            int     COMMENT 'Unpadded day of request',
    `access_method`  string  COMMENT 'Method used to accessing the site (mobile web|desktop)',
    `referer_host`   string  COMMENT 'Host from referer parsing',
    `continent`      string  COMMENT 'Continent of the accessing agents (maxmind GeoIP database)',
    `country_code`   string  COMMENT 'Country iso code of the accessing agents (maxmind GeoIP database)',
    `country`        string  COMMENT 'Country (text) of the accessing agents (maxmind GeoIP database)'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '${archive_directory}'
;

-- Create a temporary table, then compute the new unique count
-- and concatenate it to archived data.
DROP TABLE IF EXISTS tmp_wikipediapreview_stats_${year}_${month}_${day};
CREATE EXTERNAL TABLE tmp_wikipediapreview_stats_${year}_${month}_${day} (
    `pageviews`      bigint  COMMENT 'Number of pageviews shown as a result of a clickthrough from a Wikipedia Preview preview',
    `previews`       bigint  COMMENT 'Number of API requests for article preview content made by Wikipedia Preview clients',
    `year`           int     COMMENT 'Unpadded year of request',
    `month`          int     COMMENT 'Unpadded month of request',
    `day`            int     COMMENT 'Unpadded day of request',
    `access_method`  string  COMMENT 'Method used to accessing the site (mobile web|desktop)',
    `referer_host`   string  COMMENT 'Host from referer parsing',
    `continent`      string  COMMENT 'Continent of the accessing agents (maxmind GeoIP database)',
    `country_code`   string  COMMENT 'Country iso code of the accessing agents (maxmind GeoIP database)',
    `country`        string  COMMENT 'Country (text) of the accessing agents (maxmind GeoIP database)'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '${temporary_directory}'
;

WITH wikipediapreview_stats_${year}_${month}_${day} AS
(
    SELECT
        SUM(CAST(is_pageview AS INT)) AS pageviews,
        SUM(CAST(NOT is_pageview AS INT)) AS previews,
        year,
        month,
        day,
        access_method,
        parse_url(referer, 'HOST') AS referer_host,
        geocoded_data['continent'] AS continent,
        geocoded_data['country_code'] AS country_code,
        geocoded_data['country'] AS country
    FROM ${source_table}
    WHERE uri_query LIKE '%wprov=wppw1%'
        AND webrequest_source = 'text'
        AND year=${year}
        AND month=${month}
        AND day=${day}
    GROUP BY
        year, month, day,
        access_method,
        parse_url(referer, 'HOST'),
        geocoded_data['continent'],
        geocoded_data['country_code'],
        geocoded_data['country']
)
INSERT OVERWRITE TABLE tmp_wikipediapreview_stats_${year}_${month}_${day}
SELECT *
FROM
    (
        SELECT *
        FROM
            ${archive_table}
        WHERE NOT ((year = ${year})
            AND (month = ${month})
            AND (day = ${day}))

        UNION ALL

        SELECT *
        FROM
            wikipediapreview_stats_${year}_${month}_${day}
    ) old_union_new_wikipediapreview_stats
;

-- Drop temporary table (not needed anymore with hive 0.14)
DROP TABLE IF EXISTS tmp_wikipediapreview_stats_${year}_${month}_${day};