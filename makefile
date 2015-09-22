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

ISVCS_VERSION     := 33
ZOOKEEPER_VERSION := 1

ISVCS_NAME := serviced-isvcs
ZOOKEEPER_NAME := isvcs-zookeeper

ISVCS_TARBALL := serviced-isvcs-v$(ISVCS_VERSION).tar.gz
ZOOKEEPER_TARBALL := isvcs-zookeeper-v$(ZOOKEEPER_VERSION).tar.gz

.PHONY: all
all: isvcs zookeeper

.PHONY: tarballs
tarballs: $(ISVCS_TARBALL) $(ZOOKEEPER_TARBALL)

.PHONY: isvcs
isvcs: ISVCS-image

.PHONY: zookeeper
zookeeper: ZOOKEEPER-image

%-image:
	docker build -t zenoss/$($*_NAME):v$($*_VERSION) $($*_NAME)

$(ISVCS_TARBALL): isvcs
	docker save zenoss/$(ISVCS_NAME):v$(ISVCS_VERSION) | gzip -9 > $@

$(ZOOKEEPER_TARBALL): zookeeper
	docker save zenoss/$(ZOOKEEPER_NAME):v$(ZOOKEEPER_VERSION) | gzip -9 > $@
