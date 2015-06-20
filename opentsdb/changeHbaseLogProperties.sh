#!/bin/bash
#
# Changes the default Hbase logging properties to use RollingFileAppender
# instead of DailyRollingFileAppender. Assumptions:
#  - the input file is the default log4j.properties file from Hbase 0.94.16
#  - the log4j.properties file is based on log4j 1.2.16
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
# Note that we have to keep the "DRFA" identifier in the property names because
# the hbase startup scripts specify that value.
#
sed  -i -e 's/Daily Rolling File Appender/Rolling File Appender/g' ${LOG4J_PROPERTIES}
sed  -i -e 's/DailyRollingFileAppender/RollingFileAppender/g' ${LOG4J_PROPERTIES}
sed  -i -e 's/Rollver at midnight/Rollover at 10MB/' ${LOG4J_PROPERTIES}
sed  -i -e 's/DatePattern=.*/MaxFileSize=10MB/g' ${LOG4J_PROPERTIES}
sed  -i -e 's/30\-day backup/Keep last 10 log files/' ${LOG4J_PROPERTIES}
sed  -i -e 's/\#log4j.appender.DRFA.MaxBackupIndex=30/log4j.appender.DRFA.MaxBackupIndex=10/g' ${LOG4J_PROPERTIES}
sed  -i -e 's/log4j.logger.org.apache.hadoop.hbase=DEBUG/log4j.logger.org.apache.hadoop.hbase=INFO/g' ${LOG4J_PROPERTIES}
