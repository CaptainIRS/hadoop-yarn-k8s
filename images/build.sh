#!/bin/bash

eval $(minikube docker-env)

docker buildx build -t hadoop-base base
docker buildx build -t hadoop-namenode namenode
docker buildx build -t hadoop-datanode datanode
docker buildx build -t hadoop-resourcemanager resourcemanager
docker buildx build -t hadoop-dfsadmin dfsadmin

docker buildx build -t spark spark
