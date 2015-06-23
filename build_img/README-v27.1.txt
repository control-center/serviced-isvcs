########## save files for later comparision from v27 image

~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: TICKET=CC-1013
~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: VERSION=v27
# plu@plu-9: docker run -v /tmp/$TICKET/$VERSION:/mnt/patch -it zenoss/serviced-isvcs:v27 bash -c 'for file in $(find /opt -path "*/elastic*/logging.yml" -o -path "*/hbase*/conf/log4j.properties"); do mkdir -p /mnt/patch/$(dirname $file); cp -p $file /mnt/patch/$(dirname $file); done'
~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: tree /tmp/$TICKET
/tmp/CC-1013
└── v27
    └── opt
        ├── elasticsearch-0.90.9
        │   └── config
        │       └── logging.yml
        ├── elasticsearch-1.3.1
        │   └── config
        │       └── logging.yml
        └── hbase-0.94.16
            └── conf
                └── log4j.properties

8 directories, 3 files

########## patch the v27 image into v27.1

~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: cat build_img/CC-1013-patch.sh
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

~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: docker run --name $TICKET -v $(pwd):/mnt/patch -it zenoss/serviced-isvcs:v27 /mnt/patch/build_img/CC-1013-patch.sh
/mnt/patch
README.md  build  build_img  celery  consumer  es_logstash  es_serviced  images  logstash  makefile  opentsdb  pkg  query  zk
~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: VERSION=v27.1



# plu@plu-9: docker commit -m "patched with $TICKET pull/24.diff" $TICKET zenoss/serviced-isvcs:$VERSION
12bdd5aa072adf5e7ab453318640fdd2d7a54c3f9a8dbe4f7283926e7d688ed4
# plu@plu-9: docker history zenoss/serviced-isvcs:$VERSION
IMAGE               CREATED              CREATED BY                                      SIZE
12bdd5aa072a        45 seconds ago       /mnt/patch/build_img/CC-1013-patch.sh           5.78 kB
930c170bfff1        10 weeks ago         /bin/sh -c #(nop) ADD file:6da50920d72d59338e   24.77 MB
d5f70ad59e0f        10 weeks ago         /bin/sh -c #(nop) ADD file:0c0327c31377e04e02   141.6 MB
3c964d3f23ea        10 weeks ago         /bin/sh -c #(nop) ADD file:88f774b315c7edfb8d   56.23 MB
90870a8c197b        10 weeks ago         /bin/sh -c #(nop) ADD file:75bc8426851998d3bd   35.83 MB
cfba0287194b        10 weeks ago         /bin/sh -c #(nop) ADD file:36155a65f106b97355   25.19 MB
9333b82cf638        10 weeks ago         /bin/sh -c #(nop) ADD file:a5e9b8bd018737ea22   14.1 MB
a6142a08f6cd        10 weeks ago         /bin/sh -c #(nop) ADD file:1863e1cc9d334cf15a   371.7 MB
c34bd5a63d92        10 weeks ago         /bin/sh -c #(nop) ADD file:f1dda133db7fd587ee   14.06 MB
8259444ec569        10 weeks ago         /bin/sh -c #(nop) ADD file:d64267e3ec3bdc9380   346 B
30c1eaf02d4c        10 weeks ago         /bin/sh -c echo "AFTER (we think)"              0 B
f9b6ea737b01        10 weeks ago         /bin/sh -c pip install elasticsearch-curator    1.728 MB
16acca8fbd77        10 weeks ago         /bin/sh -c echo "BEFORE (we think)"             0 B
8a791022e93d        10 weeks ago         /bin/sh -c git clone --branch 0.7.3 --depth 1   38.91 MB
c7069a967f9e        10 weeks ago         /bin/sh -c pip install backports.lzma==0.0.2    164.8 kB
e70eb18820f9        10 weeks ago         /bin/sh -c echo "deb http://archive.ubuntu.co   409.9 MB
98bc891a3645        10 weeks ago         /bin/sh -c mkdir /usr/local/serviced/resource   0 B
a7e2d4da3d23        10 weeks ago         /bin/sh -c #(nop) MAINTAINER Zenoss <dev@zeno   0 B
d0955f21bf24        3 months ago         /bin/sh -c #(nop) CMD [/bin/bash]               0 B
9fec74352904        3 months ago         /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/   1.895 kB
a1a958a24818        3 months ago         /bin/sh -c echo '#!/bin/sh' > /usr/sbin/polic   194.5 kB
f3c84ac3a053        3 months ago         /bin/sh -c #(nop) ADD file:777fad733fc954c0c1   188.1 MB
511136ea3c5a        2.025063 years ago                                                   0 B


########## retrieve the files patched from new v27.1 image and compare against v27

~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: docker run -v /tmp/$TICKET/$VERSION:/mnt/patch -it zenoss/serviced-isvcs:$VERSION bash -c 'for file in $(find /opt -path "*/elastic*/logging.yml" -o -path "*/hbase*/conf/log4j.properties"); do mkdir -p /mnt/patch/$(dirname $file); cp -p $file /mnt/patch/$(dirname $file); done'
~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: tree /tmp/$TICKET
/tmp/CC-1013
├── v27
│   └── opt
│       ├── elasticsearch-0.90.9
│       │   └── config
│       │       └── logging.yml
│       ├── elasticsearch-1.3.1
│       │   └── config
│       │       └── logging.yml
│       └── hbase-0.94.16
│           └── conf
│               └── log4j.properties
└── v27.1
    └── opt
        ├── elasticsearch-0.90.9
        │   └── config
        │       └── logging.yml
        ├── elasticsearch-1.3.1
        │   └── config
        │       └── logging.yml
        └── hbase-0.94.16
            └── conf
                └── log4j.properties

16 directories, 6 files
~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: diff -Nurp /tmp/CC-1013/v27 /tmp/CC-1013/v27.1
diff -Nurp /tmp/CC-1013/v27/opt/elasticsearch-0.90.9/config/logging.yml /tmp/CC-1013/v27.1/opt/elasticsearch-0.90.9/config/logging.yml
--- /tmp/CC-1013/v27/opt/elasticsearch-0.90.9/config/logging.yml    2013-12-22 11:20:59.000000000 -0600
+++ /tmp/CC-1013/v27.1/opt/elasticsearch-0.90.9/config/logging.yml  2015-06-22 19:33:03.000000000 -0500
@@ -32,25 +32,28 @@ appender:
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   index_search_slow_log_file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}_index_search_slowlog.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   index_indexing_slow_log_file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}_index_indexing_slowlog.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
diff -Nurp /tmp/CC-1013/v27/opt/elasticsearch-1.3.1/config/logging.yml /tmp/CC-1013/v27.1/opt/elasticsearch-1.3.1/config/logging.yml
--- /tmp/CC-1013/v27/opt/elasticsearch-1.3.1/config/logging.yml 2014-06-03 09:23:18.000000000 -0500
+++ /tmp/CC-1013/v27.1/opt/elasticsearch-1.3.1/config/logging.yml   2015-06-22 19:33:03.000000000 -0500
@@ -32,25 +32,28 @@ appender:
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   index_search_slow_log_file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}_index_search_slowlog.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
 
   index_indexing_slow_log_file:
-    type: dailyRollingFile
+    type: rollingFile
     file: ${path.logs}/${cluster.name}_index_indexing_slowlog.log
-    datePattern: "'.'yyyy-MM-dd"
+    maxFileSize: 10MB
+    maxBackupIndex: 10
     layout:
       type: pattern
       conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
diff -Nurp /tmp/CC-1013/v27/opt/hbase-0.94.16/conf/log4j.properties /tmp/CC-1013/v27.1/opt/hbase-0.94.16/conf/log4j.properties
--- /tmp/CC-1013/v27/opt/hbase-0.94.16/conf/log4j.properties    2014-01-10 15:37:35.000000000 -0600
+++ /tmp/CC-1013/v27.1/opt/hbase-0.94.16/conf/log4j.properties  2015-06-22 19:33:03.000000000 -0500
@@ -11,16 +11,16 @@ log4j.rootLogger=${hbase.root.logger}
 log4j.threshold=ALL
 
 #
-# Daily Rolling File Appender
+# Rolling File Appender
 #
-log4j.appender.DRFA=org.apache.log4j.DailyRollingFileAppender
+log4j.appender.DRFA=org.apache.log4j.RollingFileAppender
 log4j.appender.DRFA.File=${hbase.log.dir}/${hbase.log.file}
 
-# Rollver at midnight
-log4j.appender.DRFA.DatePattern=.yyyy-MM-dd
+# Rollover at 10MB
+log4j.appender.DRFA.MaxFileSize=10MB
 
-# 30-day backup
-#log4j.appender.DRFA.MaxBackupIndex=30
+# Keep last 10 log files
+log4j.appender.DRFA.MaxBackupIndex=10
 log4j.appender.DRFA.layout=org.apache.log4j.PatternLayout
 
 # Pattern format: Date LogLevel LoggerName LogMessage
@@ -33,7 +33,7 @@ log4j.appender.DRFA.layout.ConversionPat
 # Security audit appender
 #
 hbase.security.log.file=SecurityAuth.audit
-log4j.appender.DRFAS=org.apache.log4j.DailyRollingFileAppender 
+log4j.appender.DRFAS=org.apache.log4j.RollingFileAppender 
 log4j.appender.DRFAS.File=${hbase.log.dir}/${hbase.security.log.file}
 log4j.appender.DRFAS.layout=org.apache.log4j.PatternLayout
 log4j.appender.DRFAS.layout.ConversionPattern=%d{ISO8601} %p %c: %m%n
@@ -59,7 +59,7 @@ log4j.appender.console.layout.Conversion
 
 log4j.logger.org.apache.zookeeper=INFO
 #log4j.logger.org.apache.hadoop.fs.FSNamesystem=DEBUG
-log4j.logger.org.apache.hadoop.hbase=DEBUG
+log4j.logger.org.apache.hadoop.hbase=INFO
 # Make these two classes INFO-level. Make them DEBUG to see more zk debug.
 log4j.logger.org.apache.hadoop.hbase.zookeeper.ZKUtil=INFO
 log4j.logger.org.apache.hadoop.hbase.zookeeper.ZooKeeperWatcher=INFO




########## push the image

~/src/europa/src/golang/src/github.com/control-center/serviced-isvcs
# plu@plu-9: docker push zenoss/serviced-isvcs:$VERSION
The push refers to a repository [zenoss/serviced-isvcs] (len: 1)
Sending image list
Pushing repository zenoss/serviced-isvcs (1 tags)
511136ea3c5a: Image already pushed, skipping 
f3c84ac3a053: Image already pushed, skipping 
a1a958a24818: Image already pushed, skipping 
9fec74352904: Image already pushed, skipping 
d0955f21bf24: Image already pushed, skipping 
a7e2d4da3d23: Image already pushed, skipping 
98bc891a3645: Image already pushed, skipping 
e70eb18820f9: Image already pushed, skipping 
c7069a967f9e: Image already pushed, skipping 
8a791022e93d: Image already pushed, skipping 
16acca8fbd77: Image already pushed, skipping 
f9b6ea737b01: Image already pushed, skipping 
30c1eaf02d4c: Image already pushed, skipping 
8259444ec569: Image already pushed, skipping 
c34bd5a63d92: Image already pushed, skipping 
a6142a08f6cd: Image already pushed, skipping 
9333b82cf638: Image already pushed, skipping 
cfba0287194b: Image already pushed, skipping 
90870a8c197b: Image already pushed, skipping 
3c964d3f23ea: Image 