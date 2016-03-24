serviced-isvcs
==============

Builds and packages Docker images that run Control Center's internal services.

This repo manages two Docker images: `serviced-isvcs` and `isvcs-zookeeper`. The 
workflow for updating and releasing these two images in conjunction with 
necessary `serviced` changes should progress thus:

1. In the makefile, bump the version number of the images you're updating. If 
you're only updating `serviced-isvcs`, you will bump `ISVCS_VERSION` such that 
it is changed from `v(N)-dev` to `v(N+1)-dev`. For example, if the 
`ISVCS_VERSION` is `v43-dev`, change it to `v44-dev`. Follow a similar pattern 
for `ZOOKEEPER-VERSION`.
2. Make your changes.
3. Build the image. To build both images, simply run `make`. To build only one
of them, run `make isvcs` or `make zookeeper` as appropriate.
4. Tag your image(s). You will tag the image with the version number you bumped 
_from_, and without the `dev` tag. For example, if the new version is `44-dev` 
for `serviced-isvcs` you would tag your new image so: 
`docker tag zenoss/serviced-isvcs:v44-dev zenoss/serviced-isvcs:v43`.
5. Make any necessary changes to `serviced`. This should at least include 
bumping the relevant version numbers in the `isvcs` package of `serviced`.
6. Test your changes. `serviced` should now use your new image.
7. Once you're satisfied with your changes, create a PR for this repo and get it 
merged. This would probably be a good time to get a preliminary review for your 
changes to `serviced`. If it looks like they won't be accepted, then you might 
not want your changes to this repo to be merged. Note that if you make a PR for 
your `serviced` changes at this point, the tests will fail because the new 
images are not yet on Docker Hub.
8. Once your PR is merged, push your images. To continue with the example above: 
`docker push zenoss/serviced-isvcs:v43`. Only push the images you've changed.
9. Create a PR for your `serviced` changes and get it reviewed & merged. See 
step seven for a note about getting a preliminary review of this change before 
pushing your images.
