.PHONY: minikube_start
BLUE := $(shell tput setaf 6)
CLEAR := $(shell tput sgr0)

deploy: build_images mount_work deploy_hadoop_namespace deploy_hadoop_conf_configmap deploy_spark_conf_configmap deploy_datanode_statefulset deploy_namenode_statefulset deploy_resourcemanager_statefulset deploy_proxy_pod deploy_spark_pod

clean:
	minikube kubectl -- delete all --all || true
	minikube kubectl -- delete all --all -n hadoop || true
	minikube kubectl -- delete pvc --all -n hadoop || true
	minikube kubectl -- delete configmap --all || true
	minikube kubectl -- delete configmap --all -n hadoop || true
	minikube kubectl -- delete namespace hadoop || true
	rm -rf .deployment

spark_exec:
	@echo "$(BLUE)Exec into Spark Pod...$(CLEAR)"
	minikube kubectl -- exec -it spark --namespace hadoop -c spark -- /bin/bash

deploy_datanode_statefulset:
	@echo "$(BLUE)Deploying Datanodes...$(CLEAR)"
	minikube kubectl -- apply -f manifest/datanode-statefulset.yaml --namespace=hadoop

deploy_namenode_statefulset:
	@echo "$(BLUE)Deploying Namenode...$(CLEAR)"
	minikube kubectl -- apply -f manifest/namenode-statefulset.yaml --namespace=hadoop

deploy_resourcemanager_statefulset:
	@echo "$(BLUE)Deploying ResourceManager...$(CLEAR)"
	minikube kubectl -- apply -f manifest/resourcemanager-statefulset.yaml --namespace=hadoop

deploy_proxy_pod:
	@echo "$(BLUE)Deploying Proxy Pod...$(CLEAR)"
	minikube kubectl -- apply -f manifest/proxy-pod.yaml --namespace=hadoop

deploy_spark_pod: mount_work
	@echo "$(BLUE)Deploying Spark Pod...$(CLEAR)"
	minikube kubectl -- apply -f manifest/spark-pod.yaml --namespace=hadoop

rollout_namenode: build_images
	@echo "$(BLUE)Rolling out Namenode...$(CLEAR)"
	minikube kubectl -- rollout restart statefulset/namenode --namespace hadoop

rollout_datanode:build_images
	@echo "$(BLUE)Rolling out Datanode...$(CLEAR)"
	minikube kubectl -- rollout restart statefulset/datanode --namespace hadoop

rollout_resourcemanager: build_images
	@echo "$(BLUE)Rolling out ResourceManager...$(CLEAR)"
	minikube kubectl -- rollout restart statefulset/resourcemanager --namespace hadoop

refresh_spark: build_images
	@echo "$(BLUE)Rolling out Spark Pod...$(CLEAR)"
	minikube kubectl -- delete pod/spark --namespace hadoop
	minikube kubectl -- apply -f manifest/spark-pod.yaml --namespace hadoop

refresh_proxy: build_images
	@echo "$(BLUE)Rolling out Proxy Pod...$(CLEAR)"
	minikube kubectl -- delete pod/proxy --namespace hadoop
	minikube kubectl -- apply -f manifest/proxy-pod.yaml --namespace hadoop

deploy_hadoop_conf_configmap:
	@echo "$(BLUE)Deploying Hadoop ConfigMap...$(CLEAR)"
	minikube kubectl -- apply -f manifest/hadoop-conf-configmap.yaml --namespace=hadoop

deploy_spark_conf_configmap:
	@echo "$(BLUE)Deploying Spark ConfigMap...$(CLEAR)"
	minikube kubectl -- apply -f manifest/spark-conf-configmap.yaml --namespace=hadoop

deploy_hadoop_namespace:
	@echo "$(BLUE)Deploying Namespace...$(CLEAR)"
	minikube kubectl -- apply -f manifest/hadoop-namespace.yaml

build_images: .deployment/minikube_start
	@echo "$(BLUE)Building images...$(CLEAR)"
	cd ./images; ./build.sh
	@echo "$(BLUE)Building images...done$(CLEAR)"

mount_work:
	@echo "$(BLUE)Mounting work directory...$(CLEAR)"
	minikube mount $(shell pwd)/work:/work &
	@echo "$(BLUE)Mounting work directory...done$(CLEAR)"

.deployment/minikube_start: .deployment/check_deps
	mkdir -p .deployment
	@echo "$(BLUE)Starting minikube...$(CLEAR)"
	minikube start --driver docker --extra-config=apiserver.service-node-port-range=1-65535 --dns-domain localho.st  --ports 127.0.0.1:9864:9864,127.0.0.1:9870:9870,127.0.0.1:8020:8020,127.0.0.1:8042:8042,127.0.0.1:8089:8089,127.0.0.1:18080:18080,127.0.0.1:4040-4050:4040-4050 --cpus 4 --memory 8192
	@echo "$(BLUE)Starting minikube...done$(CLEAR)"
	touch .deployment/minikube_start

.deployment/check_deps:
	mkdir -p .deployment
	@echo "$(BLUE)Checking dependencies...$(CLEAR)"
	minikube version
	kubectl version --client=true
	docker --version
	@echo "$(BLUE)Checking dependencies...done$(CLEAR)"
	touch .deployment/check_deps