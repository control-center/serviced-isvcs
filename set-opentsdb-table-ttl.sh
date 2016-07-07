#!/bin/bash

#!/bin/sh
# this script sets the TTL(in seconds) value on the tsdb column family in HBase.

TTL=$1
if ! [[ $TTL =~ ^[1-9][0-9]*$ ]] ; then
  echo "Invalid TTL value (expecting a postive integer)" 1>&2
  exit 1
fi


# set TSDB_TABLE name if not already set in ENV
TSDB_TABLE=${TSDB_TABLE-'tsdb'}

export JAVA_HOME=/usr/lib/jvm/jre

hbh=/opt/hbase
exec "$hbh/bin/hbase" shell <<EOF
  disable '$TSDB_TABLE';
  alter '$TSDB_TABLE', {NAME=>'t', TTL=>'$TTL'};
  enable '$TSDB_TABLE';
  describe '$TSDB_TABLE'
EOF


