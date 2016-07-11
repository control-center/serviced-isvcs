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

TARGET   := $(shell pwd)
BUILD := $(TARGET)/build
MYGOPATH := $(BUILD)/gopath
DOCKER := $(MYGOPATH)/src/github.com/docker
DISTRO := $(DOCKER)/distribution

.PHONY: all build clean
all: clean build

build:
	mkdir -p $(DOCKER)
	git clone https://github.com/docker/distribution.git $(DISTRO)
	cd $(DISTRO) && git checkout v$(VERSION)
	cd $(DISTRO) && GOPATH=$(DISTRO)/Godeps/_workspace:$(MYGOPATH) make binaries
	mkdir -p $(BUILD)/opt/registry
	cp $(DISTRO)/bin/registry $(BUILD)/opt/registry
	cp registry-config.yml $(BUILD)/opt/registry
	tar -C $(BUILD) -czf $(TARGET)/registry-$(VERSION).tar.gz opt/registry

clean:
	rm -rf $(BUILD)
	rm -f registry-$(VERSION).tar.gz
