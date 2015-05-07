serviced-isvcs
==============

Builds and packages isvcs docker image for use with serviced


Manual release process:

1. Update and release isvcs constituent parts -- celery, consumer, es_logstash, es_serviced, logstash, opentsdb, query, zk, etc...

   **NOTE:** Some constituent parts are pulled from an archive maintained on S3 (e.g. central-query and metric-consumer). Those
   artifacts are created by the Zenoss Jenkins build and mirrored to S3 from zenpip.zendev.org by a cronjob that runs hourly.
   So if you have updated a version of one of those constituents, you may have to wait up to hour before the corresponding
   artifact is available on S3.

1. Bump version number in `control-center/serviced-isvcs/[updated package]/makefile` where `updated package` is any dependency you updated as part of step 1
1. Bump serviced version number in `control-center/serviced-isvc/makefile` and `control-center/serviced/isvcs/isvcs.go`
1. If this is the first time building this image, you may need to run `make repo`. This may take a while.
1. Build package: `make pkg`
1. Test new package
1. Push new image (replace v? with new version number): `docker push zenoss/serviced-isvcs:v?`

   **HINT:** You can manually run the Jenkins [serviced-isvcs](http://jenkins.zendev.org/view/Control%20Center/job/serviced-isvcs/) job to build and push a new image to dockerhub.
1. Push changes to serviced-isvcs and serviced repos -- Follow the teams code review/pull request process...

Build the serviced-isvcs image locally:
```
$ make repo
```

Package the image:
```
$ make pkg
```
