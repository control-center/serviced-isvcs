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

VERSION := v44-dev

REGISTRY_VERSION := 2.3.0
REGISTRY_TARBALL := build/registry/registry-$(REGISTRY_VERSION).tar.gz

$(REGISTRY_TARBALL):
	cd build/registry;make VERSION=$(REGISTRY_VERSION)

build-registry: $(REGISTRY_TARBALL)

clean-registry:
	cd build/registry;make VERSION=$(REGISTRY_VERSION) clean

.PHONY: build
build: build-registry
	cp $(REGISTRY_TARBALL) ./
	sed -e 's/%REGISTRY_VERSION%/$(REGISTRY_VERSION)/g' Dockerfile.in > ./Dockerfile
	docker build -t zenoss/serviced-isvcs:$(VERSION) .

clean: clean-registry
	rm -f ./Dockerfile
