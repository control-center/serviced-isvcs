serviced-isvcs
==============

Builds and packages isvcs docker image for use with serviced

Releasing Images for Support (v27.x)
1. Update and release isvcs constituent parts -- celery, consumer, es_logstash, es_serviced, logstash, opentsdb, query, zk, etc...
2. Bump version number in `control-center/serviced-isvcs/[updated package]/makefile` where `updated package` is any dependency you updated as part of step 1
3. Bump serviced version number in `control-center/serviced-isvc/makefile` and `control-center/serviced/isvcs/isvcs.go`
4. Pull the previous suport image and manually patch it
5. Test locally
6. Commit the patched image and push to docker hub
7. Push changes to this respot and `control-center/serviced`

Manual release process:

1. Update and release isvcs constituent parts -- celery, consumer, es_logstash, es_serviced, logstash, opentsdb, query, zk, etc...
2. Bump version number in `control-center/serviced-isvcs/[updated package]/makefile` where `updated package` is any dependency you updated as part of step 1
2. Bump serviced version number in `control-center/serviced-isvc/makefile` and `control-center/serviced/isvcs/isvcs.go`
3. If this is the first time building this image, you may need to run `make repo`. This may take a while.
4. Build package: `make pkg`
4. Test new package
5. Push new image (replace v? with new version number): `docker push zenoss/serviced-isvcs:v?`
6. Push changes to serviced-isvcs and serviced repos -- Follow the teams code review/pull request process...

Build the serviced-isvcs image locally:
```
$ make repo
```

Package the image:
```
$ make pkg
```
