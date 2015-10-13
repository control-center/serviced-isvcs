#!/bin/sh
#
# This script modifies the configuration.yaml file for the isvc implementation
# of metric consumer.
#
# USAGE: modifyConfigFile.sh /opt/zenoss/etc/metric-consumer-app/configuration.yaml
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

# Remove the HTTP poster config
sed -i -e '/- {posterType: http/d' ${CONFIG_FILE}

# Add a default metric tag named 'controlplane_service_id' with the value '$env[CONTROLPLANE_SERVICE_ID]'
#   serviced will inject the environment variable CONTROLPLANE_SERVICE_ID when the container is created.
sed -i 's/\(.*\)metricReporters:/\1defaultMetricTags:\n\1  controlplane_service_id\: \"\$env\[CONTROLPLANE_SERVICE_ID\]\"\n\n\1metricReporters:/g' ${CONFIG_FILE}
echo "" >> ${CONFIG_FILE}

#
# Include any tags from HTTP parameters which begin with "controlplane"
echo "httpParameterTags:" >> ${CONFIG_FILE}
echo "  - controlplane" >> ${CONFIG_FILE}
echo "" >> ${CONFIG_FILE}

#
# Only tag metrics with the specific tags we support (can not be more than 8 total)
echo "tagWhiteList:" >> ${CONFIG_FILE}
echo "  - controlplane_service_id" >> ${CONFIG_FILE}
echo "  - controlplane_tenant_id" >> ${CONFIG_FILE}
echo "  - controlplane_host_id" >> ${CONFIG_FILE}
echo "  - controlplane_instance_id" >> ${CONFIG_FILE}
echo "  - daemon" >> ${CONFIG_FILE}
echo "  - internal" >> ${CONFIG_FILE}
echo "" >> ${CONFIG_FILE}

#
# Add a white list prefix
echo "tagWhiteListPrefixes:" >> ${CONFIG_FILE}
echo "  - controlplane_" >> ${CONFIG_FILE}

