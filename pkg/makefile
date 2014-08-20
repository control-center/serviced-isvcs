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

THIS_MAKEFILE := $(notdir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

#
# RPM and DEB builder for service definitions.
#

# NAME is typically overridden from the toplevel make:
#    e.g. make -f servicedef.mk NAME=zenoss-core
#
NAME          = serviced-isvcs
VERSION       = 0.$(MINOR_VERSION)
RELEASE_PHASE = 
MAINTAINER    ="Zenoss CM <cm@zenoss.com>"
PKGROOT       = pkgroot_$(NAME)
# https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/#license-specification
DEB_LICENSE   = Apache-2
# https://fedoraproject.org/wiki/Licensing:Main?rd=Licensing
RPM_LICENSE   = "ASL 2.0"
VENDOR        = "Zenoss, Inc."
URL           = http://controlcenter.io/
DEB_PRIORITY  = extra
CATEGORY      = admin

ifeq "$(BUILD_NUMBER)" ""
PKG_VERSION = $(VERSION)$(RELEASE_PHASE)
else
PKG_VERSION = $(VERSION)$(RELEASE_PHASE)-$(BUILD_NUMBER)
endif

ifeq "$(FROMVERSION)" ""
DEB_PKG_VERSION=$(PKG_VERSION)
else
DEB_PKG_VERSION = $(FROMVERSION)+$(PKG_VERSION)
endif

define DESCRIPTION
Packaged image for Zenoss Control Center internal services.
This packaged Docker image provides for installation of the serviced-isvcs image
without internet access to Docker Hub.
endef
export DESCRIPTION

.PHONY: all clean deb rpm
.SILENT: desc

all: desc

desc:
	echo "Usage: make deb or make rpm. Both options package $(NAME)-$(PKG_VERSION)."

.PHONY: clean_files
clean_files:
	@for pkg in $(NAME)*.deb $(NAME)*.rpm ;\
	do \
		if [ -f "$${pkg}" ];then \
			echo "rm -f $${pkg}" ;\
			if ! rm -f $${pkg} ;then \
				echo "sudo rm -f $${pkg}" ;\
				if ! sudo rm -f $${pkg} ; then \
					echo "Warning: Unable to remove $${pkg}" ;\
					exit 1 ;\
				fi ;\
			fi ;\
		fi ;\
	done

.PHONY: clean_dirs
clean_dirs = $(PKGROOT)
clean_dirs: 
	@for dir in $(clean_dirs) ;\
	do \
		if [ -d "$${dir}" ];then \
			echo "rm -rf $${dir}" ;\
			if ! rm -rf $${dir} ;then \
				echo "sudo rm -rf $${dir}" ;\
				if ! sudo rm -rf $${dir} ; then \
					echo "Warning: Unable to remove $${dir}" ;\
					exit 1 ;\
				fi ;\
			fi ;\
		fi ;\
	done

# Clean staged files and produced packages
.PHONY: clean
clean: clean_files clean_dirs

.PHONY: mrclean
mrclean: clean

# Make root dir for packaging
$(PKGROOT):
	mkdir -p $@

stage_deb: 
	$(MAKE) -f $(THIS_MAKEFILE) clean_dirs clean_dirs=$(PKGROOT)
	cd ../ && $(MAKE) install DESTDIR=$(abspath $(PKGROOT)) PKG=deb

stage_rpm:
	$(MAKE) -f $(THIS_MAKEFILE) clean_dirs clean_dirs=$(PKGROOT)
	cd ../ && $(MAKE) install DESTDIR=$(abspath $(PKGROOT)) PKG=rpm

# Make a DEB
deb: stage_deb
	fpm \
		-n $(NAME) \
		-v $(DEB_PKG_VERSION) \
		-s dir \
		-d serviced \
		-t deb \
		-a noarch \
		-C $(PKGROOT) \
		-m $(MAINTAINER) \
		--description "$$DESCRIPTION" \
		--deb-user root \
		--deb-group root \
		--license $(DEB_LICENSE) \
		--vendor $(VENDOR) \
		--url $(URL) \
		--category $(CATEGORY) \
		--deb-priority $(DEB_PRIORITY) \
		.

# Make an RPM
rpm: stage_rpm
	fpm \
		-n $(NAME) \
		-v $(PKG_VERSION) \
		-s dir \
		-d serviced \
		-t rpm \
		-a noarch \
		-C $(PKGROOT) \
		-m $(MAINTAINER) \
		--description "$$DESCRIPTION" \
		--rpm-user root \
		--rpm-group root \
		--license $(RPM_LICENSE) \
		--vendor $(VENDOR) \
		--url $(URL) \
		--category $(CATEGORY) \
		.
