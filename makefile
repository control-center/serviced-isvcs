# Copyright 2014 The Serviced Authors.
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

COMPONENT_NAMES    := es_serviced es_logstash zk opentsdb logstash query consumer celery
HERE               := $(shell pwd)
UID                := $(shell id -u)
BUILD_DIR          := build
BUILD_REPO         := zenoss/isvcs_build
REPO               := zenoss/serviced-isvcs
TAG                := v14
REPO_DIR           := images
EXPORTED_FILE      := $(REPO_DIR)/$(REPO)/$(TAG).tar.gz
COMPONENT_ARCHIVES := $(foreach cname, $(COMPONENT_NAMES), $(BUILD_DIR)/$(cname).tar.gz)
EXPORT_CONTAINER_ID:= .isvcs_export_container_id
GZIP               := $(shell which pigz || which gzip)

export: $(REPO_DIR)/$(REPO)/$(TAG).tar.gz

$(REPO_DIR)/$(REPO)/$(TAG).tar.gz: repo
	mkdir -p $(REPO_DIR)/$(REPO)
	rm -f $(EXPORT_CONTAINER_ID)
	docker run --cidfile=$(EXPORT_CONTAINER_ID) -d $(REPO):$(TAG) echo ""
	docker export `cat $(EXPORT_CONTAINER_ID)` | $(GZIP) > $(EXPORTED_FILE)
	rm -f $(EXPORT_CONTAINER_ID)

# build the repo locally
.PHONY: repo
repo: $(COMPONENT_ARCHIVES)
	docker build -t $(REPO):$(TAG) $(BUILD_DIR);

$(BUILD_DIR)/%.tar.gz:
	@[ -n "$$(docker images -q $(BUILD_REPO) 2>/dev/null)" ] \
		|| docker pull $(BUILD_REPO) \
		|| docker build -t $(BUILD_REPO) build_img
	docker run --rm -v $(HERE)/$(*):/tmp/in -v $(HERE)/$(BUILD_DIR):/tmp/out -w /tmp/in $(BUILD_REPO) \
		bash -c "make TARGET=/tmp/out; chown -R $(UID):$(UID) /tmp/out/$(notdir $(@))"

clean:
	rm -rf $(BUILD_DIR)/*.tar.gz
	rm -rf $(REPO_DIR)
	docker rmi $(REPO):$(TAG) >/dev/null 2>&1 || exit 0

mrclean: clean
	docker rmi $(BUILD_REPO) >/dev/null 2>&1 || exit 0
