serviced-isvcs
==============

Builds and packages isvcs docker image for use with serviced


Manual release process:

1. Update and release isvcs constituent parts -- celery, consumer, es_logstash, es_serviced, logstash, opentsdb, query, zk, etc...
2. Bump version number in control-center/serviced-isvc/makefile and control-center/serviced/isvcs/isvcs.go
3. Build package -- make pkg
4. Test new package
5. Push new image (replace v? with new version number) -- docker push zenoss/serviced-isvcs:v?
6. Push changes to serviced-isvcs and serviced repos -- Follow the teams code review/pull request process...

Build the serviced-isvcs image locally:
```
$ make repo
```

Package the image:
```
$ make pkg
```
