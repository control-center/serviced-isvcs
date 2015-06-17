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
DOCKER := /root/go/src/github.com/docker
DISTRO := $(DOCKER)/distribution

.PHONY: default tarball

default: tarball

tarball:
	mkdir -p $(DOCKER)
	git clone https://github.com/docker/distribution.git $(DISTRO)
	cd $(DISTRO) && git checkout tags/v2.0.1
	cd $(DISTRO) && GOPATH=$(DISTRO)/Godeps/_workspace:$$GOPATH make clean binaries
	mkdir -p /opt/registry
	cp $(DISTRO)/bin/registry /opt/registry
	cp registry-config.yml /opt/registry
	tar czf $(TARGET)/registry.tar.gz /opt/registry
