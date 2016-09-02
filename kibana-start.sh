#!/bin/bash

ELASTIC=elasticsearch:9100
KIBANA_VERSION=4.5.2
DEFAULT_INDEX=logstash-*

echo Setting default index to ${DEFAULT_INDEX}

result="$(curl -sS -XPUT ${ELASTIC}/kibana-int/config/${KIBANA_VERSION} -d '{"defaultIndex" : "'${DEFAULT_INDEX}'"}')"
fail_regex='"failed":[1-9]'

if [[ $result =~ $fail_regex ]]; then
    echo Warning: failed to set default index in elastic search at ${ELASTIC}
fi

/opt/kibana/bin/kibana
