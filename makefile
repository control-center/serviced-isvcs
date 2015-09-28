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

BUILD_NUMBER       ?= $(shell date +%y%m%d)
COMPONENT_NAMES    := es_serviced es_logstash zk opentsdb logstash query consumer celery
HERE               := $(shell pwd)
UID                := $(shell id -u)
GID                := $(shell id -g)
BUILD_DIR          := build
REPO               := zenoss/serviced-isvcs
VERSION            := 27.2
TAG                := v$(VERSION)
BUILD_REPO         := zenoss/isvcs_build
BUILD_REPO_TAG     := v1
REPO_DIR           := images
EXPORTED_FILE      := $(REPO_DIR)/$(REPO)/$(TAG).tar.gz
COMPONENT_ARCHIVES := $(foreach cname, $(COMPONENT_NAMES), $(BUILD_DIR)/$(cname).tar.gz)
EXPORT_CONTAINER_ID:= .isvcs_export_container_id
GZIP               := $(shell which pigz || which gzip)

prefix = /opt/serviced/images

ensure_build_image = \
	docker images $(BUILD_REPO) 2>/dev/null | awk '$$2~/$(BUILD_REPO_TAG)/{found=1}END{exit!found}' \
	|| docker pull $(BUILD_REPO):$(BUILD_REPO_TAG) \
	|| docker build -t $(BUILD_REPO):$(BUILD_REPO_TAG) build_img

# Normalize DESTDIR so we can use this idiom in our install targets:
# $(_DESTDIR)$(prefix)
# and not end up with double slashes.
ifneq "$(DESTDIR)" ""
    PREFIX_HAS_LEADING_SLASH = $(patsubst /%,/,$(prefix))
    ifeq "$(PREFIX_HAS_LEADING_SLASH)" "/"
        _DESTDIR := $(shell echo $(DESTDIR) | sed -e "s|\/$$||g")
    else
        _DESTDIR := $(shell echo $(DESTDIR) | sed -e "s|\/$$||g" -e "s|$$|\/|g")
    endif
endif

export: $(EXPORTED_FILE)

.PHONY: pkg
pkg: docker_isvcs_src = /serviced-isvcs
pkg: $(EXPORTED_FILE)
	eval $(ensure_build_image)
	docker run --rm \
		-v $(HERE):$(docker_isvcs_src) \
		-w $(docker_isvcs_src)/pkg \
		$(BUILD_REPO):$(BUILD_REPO_TAG) \
		bash -c "make MINOR_VERSION=$(VERSION) BUILD_NUMBER=$(BUILD_NUMBER) clean deb rpm; chown -R $(UID):$(GID) ."

install: dest = $(_DESTDIR)$(prefix)/$(REPO)
install:
	mkdir -p $(dest)
	cp $(EXPORTED_FILE) $(dest)

$(EXPORTED_FILE):
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
	eval $(ensure_build_image)
	docker run --rm \
		-v $(HERE)/$(*):/tmp/in \
		-v $(HERE)/$(BUILD_DIR):/tmp/out \
		-w /tmp/in $(BUILD_REPO):$(BUILD_REPO_TAG) \
		bash -c "make TARGET=/tmp/out; chown -R $(UID):$(GID) /tmp/out/$(notdir $(@))"

clean:
	rm -rf $(BUILD_DIR)/*.tar.gz
	rm -rf $(REPO_DIR)
	cd pkg && make clean
	docker rmi $(REPO):$(TAG) >/dev/null 2>&1 || exit 0
	rm -rf .isvcs_export_container_id

mrclean: clean
	docker rmi $(BUILD_REPO):$(BUILD_REPO_TAG) >/dev/null 2>&1 || exit 0
