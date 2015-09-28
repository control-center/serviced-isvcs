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

ISVCS_NAME := serviced-isvcs
ISVCS_VERSION     := 35-dev

ZOOKEEPER_NAME := isvcs-zookeeper
ZOOKEEPER_VERSION := 2-dev

.PHONY: all
all: isvcs zookeeper

.PHONY: isvcs
isvcs: ISVCS-image

.PHONY: zookeeper
zookeeper: ZOOKEEPER-image

.PHONY: push
push: ISVCS-push ZOOKEEPER-push

%-image:
	docker build -t zenoss/$($*_NAME):v$($*_VERSION) $($*_NAME)

%-push: isvcs zookeeper
	docker push zenoss/$($*_NAME):v$($*_VERSION)
