# Movement Metrics

Once a month all notebooks in the "notebooks" sub-directory are executed using [Anaconda base environment](https://wikitech.wikimedia.org/wiki/Analytics/Systems/Anaconda#Anaconda_base_environment) via [statistics::product_analytics](https://gerrit.wikimedia.org/r/plugins/gitiles/operations/puppet/+/refs/heads/production/modules/statistics/manifests/product_analytics.pp) Puppet module as part of [misc_jobs](https://gerrit.wikimedia.org/r/plugins/gitiles/operations/puppet/+/refs/heads/production/modules/profile/manifests/statistics/explorer/misc_jobs.pp) profile. These miscellaneous jobs are executed on stat1007 -- found in [explorer.yaml](https://gerrit.wikimedia.org/r/plugins/gitiles/operations/puppet/+/refs/heads/production/hieradata/role/common/statistics/explorer.yaml) under `misc_jobs::hosts_with_jobs`. There is an outstanding task ([T333225](https://phabricator.wikimedia.org/T333225)) to migrate these ETLs to Airflow.

The team is alerted by email if there are any of the notebooks fails execution (refer to [T295381](https://phabricator.wikimedia.org/T295381) for more information). The errors are logged in /srv/product_analytics/logs/product-analytics-movement-metrics/monthly_movement_metrics.log on stat1007.eqiad.wmnet.

To add a new notebook-based ETL job, add the .ipynb file to the "notebooks" sub-directory and ensure that any calls to [wmfdata](https://github.com/wikimedia/wmfdata-python)'s `load_csv()` use the "wmf_product" database (via the `db_name` parameter). No changes to main.sh are required.

## Creating tables

Hive table creation queries should use .hql extension and should be stored in "hive" sub-directory. Refer to the following example for creating a table:

```bash
sudo -u analytics-product hive -f hive/create_test_table.hql --database wmf_product
```

To verify:

```bash
hdfs dfs -ls /user/hive/warehouse/wmf_product.db/
```

The created table should be owned by the "analytics-product" user and "analytics-privatedata-users" group.

## Notes

- Notebooks are executed via main.sh in an alphanumeric order as analytics-product system user (and analytics-privatedata-users group). You can run `ls -l notebooks/` to preview the order.
- Please note changes such as addition of new notebooks and removal/modification of existing notebooks in CHANGES.md, including the relevant Phabricator task whenever possible.

## Manual usage

**WARNING**: Only do these steps if you know what you're doing. Some of the tables aren't partitioned ([T308077](https://phabricator.wikimedia.org/T308077)) and the queries _append_ data to the tables ([T314541](https://phabricator.wikimedia.org/T314541)), so if you accidentally run an ETL which has successfully run before (for the same time period), you will end up with duplicate data in the table.

To execute the jobs manually (if there are any issues with the scheduled run), `ssh` to stat1007.eqiad.wmnet and run:

```bash
sudo -u analytics-product kerberos-run-command analytics-product hdfs dfs -ls /

sudo -u analytics-product -g analytics-privatedata-users /srv/product_analytics/jobs/movement_metrics/main.sh
```

To manually execute specific notebooks (for example `reading_01_pageviews.ipynb`) run:

```bash
# cd /srv/product_analytics/jobs/movement_metrics/notebooks

sudo -u analytics-product -g analytics-privatedata-users /opt/conda-analytics/bin/python \
  -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook \
  --execute reading_01_pageviews.ipynb
```

## Maintainers

- [Mikhail Popov](https://meta.wikimedia.org/wiki/User:MPopov_(WMF)), Product Analytics
- [Maya Kampurath](https://www.mediawiki.org/wiki/User:Mayakp.wiki), Movement Insights
