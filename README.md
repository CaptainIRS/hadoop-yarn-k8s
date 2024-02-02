# Hadoop-YARN-k8s Sandbox

This is a sandbox for running a Hadoop YARN cluster on Kubernetes (using Minikube).

The sandbox can be started with a single command and will bring up a Hadoop YARN cluster with 2 datanodes, 1 namenode and 1 resource manager.

The various web interfaces for the cluster are proxied and exposed on the host machine automatically and can be accessed via the URLs listed below.

> **Warning**
>
> The sandbox is intended to be used for testing and development purposes only.

---

### Prerequisites
* Minikube
* GNU Make
* Docker [`buildx` CLI plugin](https://github.com/docker/buildx?tab=readme-ov-file#installing)

### System Requirements
* Minikube should have at least 8GB of memory and 4 CPUs for the sandbox to run properly (This can be changed in the `Makefile`).

---

### Running
* Run `make deploy` to deploy the system.
* Run `make clean` to bring down the system (All data will be lost!)

#### Running spark jobs
* Run `make spark_exec` to exec into the spark pod.
* The `work` directory is mounted as `/work` in the spark pod. You can copy your spark job to this directory and run it using `spark-submit`. (Use `--master yarn` to run the job on the YARN cluster.)

---

### Important URLs
* Datanodes:
    * datanode-0: http://datanode-0.datanode.hadoop.svc.localho.st:9864
    * datanode-1: http://datanode-1.datanode.hadoop.svc.localho.st:9864
* Node Managers:
    * datanode-0: http://datanode-0.datanode.hadoop.svc.localho.st:8042
    * datanode-1: http://datanode-1.datanode.hadoop.svc.localho.st:8042
* Namenode: http://namenode-0.namenode.hadoop.svc.localho.st:9870
* Resource Manager: http://resourcemanager-0.resourcemanager.hadoop.svc.localho.st:8089
* Spark History Server: http://spark.hadoop.svc.localho.st:18080

---

### Screenshots

| ![DataNode](https://i.imgur.com/PcLl4f4.png) | ![NameNode](https://i.imgur.com/RSJHLyp.png) |
|:--:|:--:|
| Hadoop Data Node | Hadoop Name Node |
| ![NodeManager](https://i.imgur.com/gR65OSv.png) | ![ResourceManager](https://i.imgur.com/CJ4LXjY.png) |
| YARN Node Manager | YARN Resource Manager |
| ![Spark History Server](https://i.imgur.com/JTQwd0d.png) | ![Spark UI](https://i.imgur.com/PaB6Jze.png) |
| Spark History Server | Spark UI |

---

### Roadmap
- [ ] Add support for running HDFS commands using `dfsadmin`
