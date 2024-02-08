#!/bin/bash

until $HADOOP_HOME/bin/hdfs dfs -ls hdfs:///logs;
do
  echo "HDFS not ready. Retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/hdfs dfs -mkdir hdfs:///logs
done

until $HADOOP_HOME/bin/mapred --daemon status historyserver
do
  echo "Historyserver failed, retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/mapred --loglevel INFO --daemon start historyserver
done

until $HADOOP_HOME/bin/yarn --daemon status timelineserver
do
  echo "Timelineserver failed, retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/yarn --loglevel INFO --daemon start timelineserver
done

until $HADOOP_HOME/bin/yarn --daemon status resourcemanager
do
  echo "Resourcemanager failed, retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/yarn --loglevel INFO --daemon start resourcemanager
done

tail -f $HADOOP_HOME/logs/*.log
