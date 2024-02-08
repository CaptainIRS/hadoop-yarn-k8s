#!/bin/bash

while true; do
  echo "Running hdfs dfsadmin -report"
  hdfs dfsadmin -report
  sleep 10
done
