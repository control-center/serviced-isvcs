# serviced-isvcs
serviced-isvcs is the docker image containing the majority of the Internal Services
used by [Control Center](https://github.com/control-center/serviced).

# Building
To buid a dev image for testing locally, use
  * `git checkout develop`
  * `git pull origin develop`
  * `make clean build`

The result should be a `vN-dev` image in your local docker repo (e.g. `v44-dev`).   If you need to make changes, create
a feature branch like you would for any other kind of change, modify the image definition as necessary, use `make clean build` to
build an image and then test it as necessary.   Once you have finished your local testing, commit your changes, push them,
and create a pull-request as you would normally. A Jenkins PR build will be started to verify that your changes will build in
a Jenkins environment.

*NOTE:* To test changes of this image with Control Center, you will have to update a
GO language constant in the serviced source code to reference the new image tag; e.g.
[`IMAGE_TAG`](https://github.com/control-center/serviced/blob/1.1.6/isvcs/isvc.go#L27)

# Releasing

Use git flow to release a new version to the `master` branch.

The image version is defined in the [makefile](./makefile).

For Zenoss employees, the details on using git-flow to release a version is documented 
on the Zenoss Engineering 
[web site](https://sites.google.com/a/zenoss.com/engineering/home/faq/developer-patterns/using-git-flow).
After the git flow process is complete, a jenkins job can be triggered manually to build and 
publish the image to docker hub. 
