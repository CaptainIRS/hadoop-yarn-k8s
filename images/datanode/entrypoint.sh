#!/bin/bash

until $HADOOP_HOME/bin/hdfs --daemon status datanode;
do
  echo "Datanode failed, retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/hdfs --loglevel INFO --daemon start datanode
done

until $HADOOP_HOME/bin/yarn --daemon status nodemanager;
do
  echo "Nodemanager failed, retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/yarn --loglevel INFO --daemon start nodemanager
done

tail -f $HADOOP_HOME/logs/*.log
