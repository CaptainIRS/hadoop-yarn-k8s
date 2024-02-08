#!/bin/bash

until $HADOOP_HOME/bin/hdfs --daemon status namenode;
do
  echo "Namenode failed. Retrying in 5 seconds..."
  sleep 5
  $HADOOP_HOME/bin/hdfs --loglevel INFO --daemon start namenode
done

tail -f $HADOOP_HOME/logs/*.log
