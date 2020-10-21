# Testing commands

## Sync all files form local to the current user's home dir on stat1008

rsync -rva --delete ./wikipediapreview_stats/ stat1008.eqiad.wmnet:~/oozie

## Put all files in a temp oozie dir on HDFS

hdfs dfs -rm -r /tmp/oozie-sbisson ; hdfs dfs -mkdir -p /tmp/oozie-sbisson/wikipediapreview_stats; hdfs dfs -put oozie/* /tmp/oozie-sbisson/wikipediapreview_stats

## Create a coordinator for a limited time window
oozie job -run -Duser=sbisson -Darchive_database=sbisson -Darchive_directory=hdfs://analytics-hadoop/tmp/sbisson -Doozie_directory=/tmp/oozie-sbisson -config ./oozie/coordinator.properties  -Dstart_time=2020-10-20T00:00Z -Dstop_time=2020-10-21T00:00Z -Dsend_error_email_workflow_file='blah' -Drefinery_directory=hdfs://analytics-hadoop$(hdfs dfs -ls -d /wmf/refinery/$(date +%Y)* | tail -n 1 | awk '{print $NF}')

# Production commands

## Put all files in the official oozie dir on HDFS
hdfs dfs -rm -r /user/analytics-product/oozie/wikipediapreview_stats ; hdfs dfs -mkdir -p /user/analytics-product/oozie/wikipediapreview_stats; hdfs dfs -put oozie/* /user/analytics-product/oozie/wikipediapreview_stats

## Create the coordinator that will run the job until the end of time
oozie job -config ./oozie/coordinator.properties -Drefinery_directory=hdfs://analytics-hadoop$(hdfs dfs -ls -d /wmf/refinery/$(date +%Y)* | tail -n 1 | awk '{print $NF}') -run
