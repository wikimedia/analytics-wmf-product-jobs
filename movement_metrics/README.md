# Movement Metrics

Once a month all notebooks in the "notebooks" sub-directory are executed using [Anaconda base environment](https://wikitech.wikimedia.org/wiki/Analytics/Systems/Anaconda#Anaconda_base_environment).

To add a new notebook-based ETL job, add the .ipynb file to the "notebooks" sub-directory and ensure that any calls to [wmfdata](https://github.com/wikimedia/wmfdata-python)'s `load_csv()` use the "wmf_product" database (via the `db_name` parameter). No changes to main.sh are required.

## Creating Tables

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

- They are executed via main.sh in an alphanumeric order as analytics-product system user (and analytics-privatedata-users group). You can run `ls -l notebooks/` to preview the order.
- Please note changes such as addition of new notebooks and removal/modification of existing notebooks in CHANGES.md, including the relevant Phabricator task whenever possible.

## Maintainers

- [Mikhail Popov](https://meta.wikimedia.org/wiki/User:MPopov_(WMF))
- [Maya Kampurath](https://www.mediawiki.org/wiki/User:Mayakp.wiki)
- [Irene Florez](https://meta.wikimedia.org/wiki/User:IFlorez_(WMF))
