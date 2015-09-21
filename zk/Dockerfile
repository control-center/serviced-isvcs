FROM zenoss/centos-base:1.0.1
MAINTAINER Zenoss <dev@zenoss.com>

ENV ZK_VERSION 3.4.5
ENV ZK_URL http://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz
ENV ZK_PATH /opt/zookeeper-${ZK_VERSION}
ENV ZK_DATA /var/zookeeper
ENV EXHIBITOR_VERSION 1.5.5
ENV EXHIBITOR_URL http://central.maven.org/maven2/com/netflix/exhibitor/exhibitor-standalone/${EXHIBITOR_VERSION}/exhibitor-standalone-${EXHIBITOR_VERSION}.jar

# Install java
RUN yum -y --setopt=tsflags="nodocs" install java-1.7.0-openjdk-headless \
    && /sbin/scrub.sh

# Install ZooKeeper
RUN mkdir -p /opt ${ZK_DATA} && \
    wget -qO- ${ZK_URL} | tar -C /opt -xz --exclude contrib --exclude src --exclude docs --exclude dist-maven --exclude recipes && \
    rm -f ${ZK_PATH}/build.xml ${ZK_PATH}/CHANGES.txt
ADD zoo.cfg ${ZK_PATH}/conf/zoo.cfg
ADD start-zookeeper /bin/start-zookeeper

# Install exhibitor
RUN mkdir /opt/exhibitor && \
    wget -q -O /opt/exhibitor/exhibitor-standalone-${EXHIBITOR_VERSION}.jar \
        http://zenpip.zendev.org/packages/exhibitor-standalone-${EXHIBITOR_VERSION}.jar && \
    sed -i 's|start-foreground)|start-foreground)\n /usr/bin/java -jar /opt/exhibitor/exhibitor-standalone-${EXHIBITOR_VERSION}.jar -c file --port 12181 \&|g' ${ZK_PATH}/bin/zkServer.sh