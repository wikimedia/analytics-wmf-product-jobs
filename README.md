# Introduction
This repo stores different recurring jobs owned by the [Product Analytics](https://www.mediawiki.org/wiki/Product_Analytics) team.

# Deployment
## Oozie jobs
In order to deploy an [Oozie](https://wikitech.wikimedia.org/wiki/Analytics/Systems/Cluster/Oozie) job, follow these steps:
1. If you're deploying a new version of an existing job, kill the existing job first (easiest with the [Hue web interface](https://hue.wikimedia.org)).
1. Make sure you have a production config file (`production.properties`) that refects the final job you want to run. Particularly:
    * Use the `analytics_product` user account
    * Use the `wmf_product` Hive database
    * Use `product-analytics+alerts@wikimedia.org` for alerts.
    * Set the right start time. What is the earliest time period you want to produce data for?
    * Set the right the end time. Normally, we want jobs to run indefinitely, so we use `3000-01-01T00:00Z`.
1. Make sure you have a test config file (`test.properties`) that overrides the production properties where necessary for appropriate testing. Particularly: 
    * Use your own user account
    * Use your own Hive database
    * Use your own email for alerts
    * Set the start and end time close together, so the test job only runs on a small sample of data. An hour or a day should be plenty.
1. Upload the version of this repo with your changes to an [analytics client host](https://wikitech.wikimedia.org/wiki/Analytics/Systems/Clients). If you are developing on your local machine, you can use a command like `rsync --archive --delete jobs stat1004.eqiad.wmnet:~/analytics_wmf_product_jobs`.
1. On the analytics client, deploy and run your job in test mode using script from this repo: `./deploy-oozie-job {{job name}} --test`.
1. Check that the job succeeds and produces the right output. If it doesn't, change the code as necessary, reupload, and retest.
1. Once your job runs perfectly in test mode, deploy and run it in production mode: `./deploy-oozie-job {{job name}} --production`.
1. Monitor the production job to make sure it's running successfully and check the output to ensure that it's correct.
1. If everything is good, post a celebratory meme to the team chat channel! 

# See also
- [analytics/wmf-product](https://gerrit.wikimedia.org/g/analytics/wmf-product) for more of Product Analytics repositories
- [analytics/refinery](https://gerrit.wikimedia.org/g/analytics/refinery) for Analytics Engineering's software infrastructure used on the analytics cluster
