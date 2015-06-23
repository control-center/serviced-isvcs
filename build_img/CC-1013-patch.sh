#!/bin/bash

set -e

echo "PatchedBy: CC-1013-24" >> /var/zenoss-build.txt

cd /mnt/patch
pwd
ls

ES_VERSION="1.3.1"
es_logstash/changeESLogProperties.sh /opt/elasticsearch-${ES_VERSION}/config/logging.yml

ES_VERSION="0.90.9"
es_serviced/changeESLogProperties.sh /opt/elasticsearch-${ES_VERSION}/config/logging.yml

HBASE_VERSION="0.94.16"
opentsdb/changeHbaseLogProperties.sh /opt/hbase-${HBASE_VERSION}/conf/log4j.properties

