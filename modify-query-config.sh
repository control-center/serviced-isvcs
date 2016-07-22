#!/bin/sh
#
# This script modifies the configuration.yaml file for the isvc implementation
# of central query service.
#
# USAGE: modifyConfigFile.sh /opt/zenoss/etc/central-query/configuration.yaml
#
if [ $# -ne 1 ];then
	echo "Missing required file name argument"
	exit 1
fi

CONFIG_FILE=$1
if [ ! -f ${CONFIG_FILE} ]; then
	echo "The input file '${CONFIG_FILE}'' does not exist"
	exit 1
elif [ ! -r ${CONFIG_FILE} ]; then
	echo "The input file '${CONFIG_FILE}'' is not readable"
	exit 1
elif [ ! -w ${CONFIG_FILE} ]; then
	echo "The input file '${CONFIG_FILE}'' is not writable"
	exit 1
fi

# Disable authentication
sed -i 's/\(authEnabled:.*\)true/\1false/' ${CONFIG_FILE}

# Remove the HTTP poster w/CC login credentials
sed -i -e '/CONTROLPLANE_CONSUMER_USERNAME/d' ${CONFIG_FILE}

# Change the default port to the one used in isvcs
sed -i -e 's/\(localhost,.*port:.*\)8080/\18443/' ${CONFIG_FILE}

# Remove unnecessary credential props
sed -i -e 's/ username\: \"\$zcreds\[\]\", password\: \"\$zcreds\[\]\",//g' ${CONFIG_FILE}

# Add a default metric tag named 'controlplane_service_id' with the value '$env[CONTROLPLANE_SERVICE_ID]'
#   serviced will inject the environment variable CONTROLPLANE_SERVICE_ID when the container is created.
sed -i 's/\(.*\)metricReporters:/\1defaultMetricTags:\n\1  controlplane_service_id\: \"\$env\[CONTROLPLANE_SERVICE_ID\]\"\n\n\1metricReporters:/g' ${CONFIG_FILE}
