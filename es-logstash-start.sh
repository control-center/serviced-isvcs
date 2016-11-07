#!/bin/bash

ES_DATA=/opt/elasticsearch-logstash/data
NODE_NAME=$1
CLUSTER_NAME=$2

# If the cluster is being initialized, pre-populate the data
if [ ! -d $ES_DATA/$CLUSTER_NAME ]; then
    echo "Initializing kibana indices for serviced"
    mkdir -p $ES_DATA/$CLUSTER_NAME
    tar -xzf /elasticsearch-logstash-$ES_LOGSTASH_VERSION.tar.gz -C $ES_DATA/$CLUSTER_NAME
fi

exec /opt/elasticsearch-logstash/bin/elasticsearch -Des.insecure.allow.root=true -Des.node.name=$NODE_NAME -Des.cluster.name=$CLUSTER_NAME

