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

TARGET := $(shell pwd)
BUILD := $(TARGET)/build
HBASE_VERSION := 0.94.16
OPENTSDB_VERSION := 2.1.1

HBASE_INSTALL := https://archive.apache.org/dist/hbase/hbase-$(HBASE_VERSION)/hbase-$(HBASE_VERSION).tar.gz
OPENTSDB_INSTALL := https://github.com/OpenTSDB/opentsdb/archive/$(OPENTSDB_VERSION).tar.gz

.PHONY: default clean build

default: clean build

build:
	mkdir -p $(BUILD)/opt
	wget -qO- $(HBASE_INSTALL) | tar -C $(BUILD)/opt -xz --exclude src --exclude docs --exclude '*-tests.jar'
	wget -qO- $(OPENTSDB_INSTALL) | tar -C $(BUILD)/opt -xz
	cd $(BUILD)/opt/opentsdb-$(OPENTSDB_VERSION) && COMPRESSION=NONE HBASE_HOME=$(BUILD)/opt/hbase-$(HBASE_VERSION) ./build.sh
	cp hbase-site.xml $(BUILD)/opt/hbase-$(HBASE_VERSION)/conf/hbase-site.xml
	cp start-opentsdb.sh $(BUILD)/opt/opentsdb-$(OPENTSDB_VERSION)/build/start-opentsdb.sh && chmod a+x $(BUILD)/opt/opentsdb-$(OPENTSDB_VERSION)/build/start-opentsdb.sh
	cd $(BUILD)/opt/hbase-$(HBASE_VERSION) && patch -p0 < $(TARGET)/hbase-daemon.sh.patch
	cd $(BUILD)/opt/hbase-$(HBASE_VERSION) && patch -p0 < $(TARGET)/start-hbase.sh.patch
	./changeHbaseLogProperties.sh $(BUILD)/opt/hbase-$(HBASE_VERSION)/conf/log4j.properties
	echo "export HBASE_MANAGES_ZK=true" >> $(BUILD)/opt/hbase-$(HBASE_VERSION)/conf/hbase-env.sh
	mkdir -p $(BUILD)/opt/zenoss/etc/supervisor
	cp opentsdb_supervisor.conf $(BUILD)/opt/zenoss/etc/supervisor/opentsdb_supervisor.conf
	cp hbase_supervisor.conf $(BUILD)/opt/zenoss/etc/supervisor/hbase_supervisor.conf
	tar -C $(BUILD) -czf $(TARGET)/opentsdb-$(OPENTSDB_VERSION)_hbase-$(HBASE_VERSION).tar.gz opt

clean:
	rm -rf $(BUILD)
	rm -f opentsdb-$(OPENTSDB_VERSION)_hbase-$(HBASE_VERSION).tar.gz
