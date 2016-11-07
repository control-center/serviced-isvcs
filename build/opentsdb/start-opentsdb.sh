#!/bin/bash

mkdir -p /tmp/tsd

export COMPRESSION=NONE
export HBASE_HOME=/opt/hbase
export JAVA_HOME=/usr/lib/jvm/jre

# Overwrite the default open tsdb config if available
true ${OPENTSDB_RESOURCE:=/usr/local/serviced/resources/opentsdb}
if [ -e "$OPENTSDB_RESOURCE/opentsdb.conf" ]; then
    cp $OPENTSDB_RESOURCE/opentsdb.conf /opt/opentsdb/opentsdb.conf
fi

while [[ `/opt/opentsdb/src/create_table.sh` != *"ERROR: Table already exists: tsdb"* ]]; do
    echo `date` ": Waiting for HBase to be ready..."
    sleep 2
done

echo "Starting opentsdb..."
exec /opt/opentsdb/build/tsdb tsd --port=4242 --staticroot=/opt/opentsdb/build/staticroot --cachedir=/tmp/tsd --auto-metric --zkquorum=localhost:22181
