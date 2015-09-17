FROM zenoss/centos-base:1.0.1
MAINTAINER Zenoss <dev@zenoss.com>

ENV ZK_VERSION 3.4.5
ENV ZK_URL http://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz
ENV ZK_PATH /opt/zookeeper-${ZK_VERSION}
ENV EXHIBITOR_URL http://central.maven.org/maven2/com/netflix/exhibitor/exhibitor-standalone/1.5.5/exhibitor-standalone-1.5.5.jar

# Install java
RUN yum -y --setopt=tsflags="nodocs" install java-1.7.0-openjdk-headless \
    && /sbin/scrub.sh

# Install ZooKeeper
RUN mkdir -p /opt && \
    wget -qO- ${ZK_URL} | tar -C /opt -xz --exclude contrib --exclude src --exclude docs --exclude dist-maven --exclude recipes && \
    rm -f ${ZK_PATH}/build.xml ${ZK_PATH}/CHANGES.txt && \
    mv ${ZK_PATH}/conf/zoo_sample.cfg ${ZK_PATH}/conf/zoo.cfg && \
    echo maxClientCnxns=0 >> ${ZK_PATH}/conf/zoo.cfg && \
    echo autopurge.snapRetainCount=3 >> ${ZK_PATH}/conf/zoo.cfg && \
    echo autopurge.purgeInterval=1 >> ${ZK_PATH}/conf/zoo.cfg

# Install exhibitor
RUN mkdir -p /opt/exhibitor && \
    wget -q -O /opt/exhibitor/exhibitor-standalone-1.5.5.jar ${EXHIBITOR_URL} && \
    sed -i 's|start-foreground)|start-foreground)\n /usr/bin/java -jar /opt/exhibitor/exhibitor-standalone-1.5.5.jar -c file --port 12181 \&|g' ${ZK_PATH}/bin/zkServer.sh