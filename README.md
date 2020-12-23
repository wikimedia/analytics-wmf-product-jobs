# Introduction
This repo stores different recurring jobs  [Product Analytics](https://www.mediawiki.org/wiki/Product_Analytics) team's [Oozie](Analytics/Systems/Cluster/Oozie) workflows and scripts/queries/jobs.

# Deployment
## Oozie jobs
In order to deploy an Oozie job, you should follow the following procedure:
1. If you're deploying a new version of an existing Oozie job, you should first kill the existing job using the `oozie` command line client or the [Hue web interface](hue.wikimedia.org).
1. Write two different coordinator files, one for production (`production.properties`) and one with testing overrides (`test.properties`). Test jobs should be run under your own user, use your own HDFS/Hive database, and send alerts to your own email address. Production jobs should be run as `analytics_product`, use the `wmf_product` HDFS/Hive databse, and send alerts to `product-analytics+alerts@wikimedia.org`. Note that any properties not found in `test.properties` will be picked up from `production.properties`, so `test.properties` only needs to contain the properties you want to override during testing.
1. Sync the version of the jobs repo you want to use to an [analytics client host](https://wikitech.wikimedia.org/wiki/Analytics/Systems/Clients). If your changes are already in the master branch, you could clone the repo onto the machine. If you are developing on your local machine, you can use a command like `rsync --archive --delete jobs stat1004.eqiad.wmnet:~/analytics_wmf_product_jobs`.
1. On the analytics client, use the script included in this repo to put your job files into [the Data Lake](https://wikitech.wikimedia.org/wiki/Analytics/Data_Lake) and then submit it to Oozie. The script is used as follows: `./deploy-oozie-job --config={{path to config}} {{job name}}`. The job name determines the folder where the script looks for your job files. The `user` property in your config file determines which user the job is run under.
1. You can then track the submitted job using the `oozie` command line client or the [Hue web interface](hue.wikimedia.org).

# See also

- [analytics/wmf-product](https://gerrit.wikimedia.org/g/analytics/wmf-product) for more of Product Analytics repositories
- [analytics/refinery](https://gerrit.wikimedia.org/g/analytics/refinery) for Analytics Engineering's software infrastructure used on the analytics cluster
