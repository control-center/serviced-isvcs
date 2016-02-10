serviced-isvcs
==============

Builds and packages Docker images that run Control Center's internal services.

To build the images:

    $ make

To push the images (don't do it until you have all changes to this repository reviewed):

    $ make push


To release isvcs:

* [optional] Release the new version of the package you will be adding to isvs
* Checkout and pull the latest develop branch: `git checkout develop && git pull`
* Create a new branch based on develop, named the new version of isvcs: `git checkout -b release/v40`
* Edit `serviced-isvcs/Dockerfile` to point to the new version of the package
* [optional] If you are releasing a new zookeeper, also edit the package version in `isvcs-zookeeper/Dockerfile`
* Remove the `-dev` suffix from `ISVCS_VERSION` and `ZOOKEEPER_VERSION` in `makefile`
* Run `make` to build the new isvcs image
* Update serviced to use the new isvcs image (look for `IMAGE_TAG` in `isvcs/isvc.go`, and `ZK_IMAGE_TAG` if you're updating zookeeper)
* `make` serviced, test it, run it, poke at it, taunt it, etc
* Push the changes up: `git push -u origin release/v40`
* Find someone who has permission to `docker push` to the zenoss repository and kindly ask them to pull your branch, `make`, then `make push`.
* After the new isvcs image has been pushed to dockerhub, create a PR in the serviced repo to point to the new isvcs version
* Almost done! You're doing super well btw. Thanks a lot.
* Bump the isvcs version number and add `-dev` suffix. NOTE: if you did not release a new zookeeper, that version number can remain unchanged, but do add the `-dev` suffix back.
