#!/bin/bash
#
# Changes the default Elasticsearch logging properties to use RollingFileAppender
# instead of DailyRollingFileAppender. Assumptions:
#  - the input file is the default logging.yml file from ES 0.90.9-1.3.1
#

# stop on the first error
set -e

if [ $# -ne 1 ]; then
	echo "ERROR: missing required file name argument"
	echo "USAGE: $0 <log4jConfigFile>"
	exit 1
fi

LOG4J_PROPERTIES=$1
if [ ! -f ${LOG4J_PROPERTIES} ]; then
	echo "ERROR: file '${LOG4J_PROPERTIES} does not exist"
	exit 1
elif [ ! -r ${LOG4J_PROPERTIES} ]; then
	echo "ERROR: file '${LOG4J_PROPERTIES} is not readable"
	exit 1
elif [ ! -w ${LOG4J_PROPERTIES} ]; then
	echo "ERROR: file '${LOG4J_PROPERTIES} is not writable"
	exit 1
fi

#
# Replace  DailyRollingFileAppender with RollingFileAppender, and configure
# RollingFileAppender to keep a maximum of 10 log files, each no larger than 10MB
# (a typical configuration for other zenoss containers).
#
sed  -i -e 's/type: dailyRollingFile/type: rollingFile/g' ${LOG4J_PROPERTIES}
sed  -i -e 's/datePattern.*/maxFileSize: 10MB\n    maxBackupIndex: 10/g' ${LOG4J_PROPERTIES}
