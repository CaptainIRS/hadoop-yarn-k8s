FROM debian:bullseye-slim

ENV HADOOP_VERSION 3.3.6

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        openjdk-11-jre-headless \
        ssh \
        wget \
        pdsh && \
    wget --progress=dot:giga https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /usr/local && \
    rm -f /tmp/hadoop.tar.gz && \
    apt-get remove -y --purge wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HADOOP_HOME /usr/local/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH

RUN useradd -m -s /bin/bash hadoop

RUN mkdir -p /data/hdfs && \
    chown -R hadoop:hadoop /data/hdfs && \
    chmod -R 755 /data/hdfs && \
    mkdir ${HADOOP_HOME}/logs && \
    chown -R hadoop:hadoop ${HADOOP_HOME}/logs ${HADOOP_HOME}/etc && \
    ln -s ${HADOOP_HOME}/etc/hadoop /etc/hadoop && \
    ln -s ${HADOOP_HOME}/bin/hdfs /usr/bin/hdfs

USER hadoop
ENV USER hadoop

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys
