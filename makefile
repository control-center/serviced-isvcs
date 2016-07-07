IMAGENAME  = serviced-isvcs
VERSION   ?= v44-dev
TAG = zenoss/$(IMAGENAME):$(VERSION)

.PHONY: build build-base build-java push clean

build:
	@echo Building Serviced ISVCS image
	docker build -t $(TAG) .

push:
	docker push $(TAG)

# Don't generate an error if the image does not exist
clean:
	-docker rmi $(TAG)

# Generate a make failure if the VERSION string contains "-<some letters>"
verifyVersion:
	@./verifyVersion.sh $(VERSION)

# Generate a make failure if the image(s) already exist
verifyImage:
	@./verifyImage.sh zenoss/$(IMAGENAME) $(VERSION)

# Do not release if the image version is invalid
# This target is intended for use when trying to build/publish images from the master branch
release: verifyVersion verifyImage clean build push
