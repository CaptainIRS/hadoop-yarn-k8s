#!/bin/bash

export SPARK_NO_DAEMONIZE=1

until $SPARK_HOME/sbin/start-history-server.sh;
do
  echo "Spark history server failed. Retrying in 5 seconds..."
  sleep 5
done
