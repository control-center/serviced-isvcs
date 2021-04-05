#!/bin/bash

ES_DATA=/opt/elasticsearch-logstash/data
NODE_NAME=$1
CLUSTER_NAME=$2

# If the cluster is being initialized, pre-populate the data
if [ ! -d $ES_DATA/nodes ]; then
    echo "Initializing kibana indices for serviced"
    mkdir -p $ES_DATA
    tar -xzf /elasticsearch-logstash-$ELK_VERSION.tar.gz -C $ES_DATA
    chown elastic:elastic -R /opt/elasticsearch-logstash/*
fi

export JAVA_HOME=/usr/lib/jvm/jre-11; su elastic -c 'exec /opt/elasticsearch-logstash/bin/elasticsearch -Enode.name='"${NODE_NAME}"' -Ecluster.name='"${CLUSTER_NAME}"
