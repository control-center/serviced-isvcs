# serviced-isvcs
serviced-isvcs is the docker image containing the majority of the Internal Services
used by [Control Center](https://github.com/control-center/serviced).

# Building
To buid a dev image for testing locally, use
  * `git checkout develop`
  * `git pull origin develop`
  * `make clean build`

The result should be a `vN-dev` image in your local docker repo (e.g. `v73-dev`).   If you need to make changes, create
a feature branch like you would for any other kind of change, modify the image definition as necessary, use `make clean build` to
build an image and then test it as necessary.   Once you have finished your local testing, commit your changes, push them,
and create a pull-request as you would normally. A Jenkins PR build will be started to verify that your changes will build in
a Jenkins environment.

*NOTE:* To test changes of this image with Control Center, you will have to update a
GO language constant in the serviced source code to reference the new image tag; e.g.
[`IMAGE_TAG`](https://github.com/control-center/serviced/blob/1.10.0/isvcs/isvc.go#L38)

# Updating a component
The following is a general procedure for updating a local build of the isvc image to verfiy that a new component version works as expected with Control Center. Note that you should NOT need to change the isvc version at this time. The `vN-dev` value of the image on the develop branch should always be the *next* available version. For instance, if the latest serviced code is using the published image `v58`, then the value on the `develop` branch of this repo should be `v59-dev`, and that is the version you should use for local testing.

* If you have not done so already, publish a new release of the component(s) you are updating; e.g. query, opentsdb, etc
* Change the makefile or Docker file for serviced-isvcs to use the new component release
* `make clean build` in serviced-isvcs to build a local, `vN-dev` copy of the isvc image.
* In the serviced repo, change the constant `IMAGE_TAG` in `isvcs/isvcs.go` to use the `vN-dev` image you just built
* Rebuild serviced and test locally to verify that the updated components works like you want it to with CC
* When you are satisfied that the component update is working correctly, create a PR for serviced-isvcs to use the new component. At this point in time, the makefile for serviced-isvcs should still have the `vN-dev` version.
* After PR is merged, use the instructions in the next section to publish a release version of the image.

# Releasing

Use git flow to release a new version to the `master` branch.

The image version is defined in the [makefile](./makefile).

For Zenoss employees, the details on using git-flow to release a version is documented 
on the Zenoss Engineering 
[web site](https://sites.google.com/a/zenoss.com/engineering/home/faq/developer-patterns/using-git-flow).
After the git flow process is complete, a jenkins job can be triggered manually to build and 
publish the image to docker hub. See http://platform-jenkins.zenoss.eng/job/images/job/serviced-isvcs/job/serviced-isvcs-master/

Note that once the git flow release process is done, the makefile on develop should specify the next `vN-dev` value. For instance, if image tag is `v74-dev` when you start the release process, then you will release `v74` to master, and the next version on develop at  the end of process should be `v75-dev`.

After the version is published to docker hub:
* Change isvcs/isvcs.go in serviced repo to use the new published image version
* Open a PR for the serviced change
