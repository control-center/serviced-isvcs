# Copyright 2015 The Serviced Authors.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

HBASE_VERSION    := 0.94.16
OPENTSDB_VERSION := 2.1.1
REVISION := 1
TARBALL          := opentsdb-$(OPENTSDB_VERSION)_hbase-$(HBASE_VERSION)-$(REVISION).tar.gz
HBASE_INSTALL    := https://archive.apache.org/dist/hbase/hbase-$(HBASE_VERSION)/hbase-$(HBASE_VERSION).tar.gz
OPENTSDB_INSTALL := https://github.com/OpenTSDB/opentsdb/archive/$(OPENTSDB_VERSION).tar.gz
TARGET           := /mnt/pwd

.PHONY: default
default: $(TARBALL)

$(TARBALL): 
	docker run --rm -v $(PWD):$(TARGET) -w $(TARGET) maven:3.3.3-jdk-7 \
		/bin/bash -c "apt-get update && apt-get -y install make autoconf patch && make build"

.PHONY: build
build:
	mkdir -p /opt
	wget -qO- $(HBASE_INSTALL) | tar -C /opt -xz --exclude src --exclude docs --exclude '*-tests.jar'
	ln -s /opt/hbase-$(HBASE_VERSION) /opt/hbase
	wget -qO- $(OPENTSDB_INSTALL) | tar -C /opt -xz
	ln -s /opt/opentsdb-$(OPENTSDB_VERSION) /opt/opentsdb
	cd /opt/opentsdb-$(OPENTSDB_VERSION) && COMPRESSION=NONE HBASE_HOME=/opt/hbase-$(HBASE_VERSION) ./build.sh
	rm -rf /opt/opentsdb-$(OPENTSDB_VERSION)/build/gwt-unitCache /opt/opentsdb-$(OPENTSDB_VERSION)/build/third_party/gwt/gwt-dev-*.jar
	cd /opt/opentsdb-$(OPENTSDB_VERSION)/src/ && patch -p0 < $(TARGET)/create_table.sh.patch
	cp $(TARGET)/hbase-site.xml /opt/hbase-$(HBASE_VERSION)/conf/hbase-site.xml
	cp $(TARGET)/start-opentsdb.sh /opt/opentsdb-$(OPENTSDB_VERSION)/build/start-opentsdb.sh && chmod a+x /opt/opentsdb-$(OPENTSDB_VERSION)/build/start-opentsdb.sh
	cd /opt/hbase-$(HBASE_VERSION) && patch -p0 < $(TARGET)/hbase-daemon.sh.patch
	cd /opt/hbase-$(HBASE_VERSION) && patch -p0 < $(TARGET)/start-hbase.sh.patch
	$(TARGET)/changeHbaseLogProperties.sh /opt/hbase-$(HBASE_VERSION)/conf/log4j.properties
	echo "export HBASE_MANAGES_ZK=true" >> /opt/hbase-$(HBASE_VERSION)/conf/hbase-env.sh
	mkdir -p /opt/zenoss/etc/supervisor
	cp $(TARGET)/opentsdb_supervisor.conf /opt/zenoss/etc/supervisor/opentsdb_supervisor.conf
	cp $(TARGET)/hbase_supervisor.conf /opt/zenoss/etc/supervisor/hbase_supervisor.conf
	tar -czf $(TARGET)/$(TARBALL) /opt

clean:
	rm -rf $(TARBALL)
