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
#

IMAGENAME := serviced-isvcs
VERSION   := v51-dev
TAG       := zenoss/$(IMAGENAME):$(VERSION)

REGISTRY_VERSION := 2.3.0
REGISTRY_TARBALL := build/registry/registry-$(REGISTRY_VERSION).tar.gz

OPENTSDB_VERSION := 2.2.0
HBASE_VERSION := 0.94.16
OPENTSDB_HBASE_TARBALL := build/opentsdb/opentsdb-$(OPENTSDB_VERSION)_hbase-$(HBASE_VERSION).tar.gz

ES_LOGSTASH_VERSION := 2.3.3
ES_LOGSTASH_TARBALL := build/elasticsearch-logstash/elasticsearch-logstash-$(ES_LOGSTASH_VERSION).tar.gz


$(REGISTRY_TARBALL):
	cd build/registry;make VERSION=$(REGISTRY_VERSION)

build-registry: $(REGISTRY_TARBALL)

clean-registry:
	cd build/registry;make VERSION=$(REGISTRY_VERSION) clean

$(OPENTSDB_HBASE_TARBALL):
	cd build/opentsdb;make OPENTSDB_VERSION=$(OPENTSDB_VERSION) HBASE_VERSION=$(HBASE_VERSION)

build-opentsdb-hbase: $(OPENTSDB_HBASE_TARBALL)

clean-opentsdb-hbase:
	cd build/opentsdb;make OPENTSDB_VERSION=$(OPENTSDB_VERSION) HBASE_VERSION=$(HBASE_VERSION) clean

$(ES_LOGSTASH_TARBALL):
	cd build/elasticsearch-logstash;make VERSION=$(ES_LOGSTASH_VERSION)

build-elasticsearch-logstash: $(ES_LOGSTASH_TARBALL)

clean-elasticsearch-logstash:
	cd build/elasticsearch-logstash;make VERSION=$(ES_LOGSTASH_VERSION) clean

.PHONY: default build clean
default: build

build: build-registry build-opentsdb-hbase build-elasticsearch-logstash
	cp $(REGISTRY_TARBALL) ./
	cp $(OPENTSDB_HBASE_TARBALL) ./
	cp $(ES_LOGSTASH_TARBALL) ./
	sed -e 's/%REGISTRY_VERSION%/$(REGISTRY_VERSION)/g; s/%OPENTSDB_VERSION%/$(OPENTSDB_VERSION)/g; s/%HBASE_VERSION%/$(HBASE_VERSION)/g; s/%ES_LOGSTASH_VERSION%/$(ES_LOGSTASH_VERSION)/g' Dockerfile.in > ./Dockerfile
	docker build -t $(TAG) .

# Don't generate an error if the image does not exist
clean: clean-registry clean-opentsdb-hbase clean-elasticsearch-logstash
	rm -f ./Dockerfile
	rm -f ./*.tar.gz
	[ -z $$(docker images -q $(TAG)) ] || docker rmi $(TAG)

push:
	docker push $(TAG)

# Generate a make failure if the VERSION string contains "-<some letters>"
verifyVersion:
	@./verifyVersion.sh $(VERSION)

# Generate a make failure if the image(s) already exist
verifyImage:
	@./verifyImage.sh zenoss/$(IMAGENAME) $(VERSION)

# Do not release if the image version is invalid
# This target is intended for use when trying to build/publish images from the master branch
release: verifyVersion verifyImage clean build push
