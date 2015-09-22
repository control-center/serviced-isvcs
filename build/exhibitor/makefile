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

EXHIBITOR_VERSION := 1.5.5
EXHIBITOR_POM :=  https://raw.githubusercontent.com/Netflix/exhibitor/v$(EXHIBITOR_VERSION)/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml

.PHONY: default clean build

default: clean build

build:
	mkdir -p $(BUILD)/opt/exhibitor
	wget -q -O $(BUILD)/opt/exhibitor/pom.xml $(EXHIBITOR_POM) && \
		cd $(BUILD)/opt/exhibitor && \
		mvn clean package
	cp $(BUILD)/opt/exhibitor/target/exhibitor-1.0.jar $(TARGET)/exhibitor-standalone-$(EXHIBITOR_VERSION).jar

clean: 
	rm -rf $(BUILD)
	rm -f $(TARGET)/exhibitor-standalone-$(EXHIBITOR_VERSION).jar