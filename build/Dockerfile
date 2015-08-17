FROM ubuntu:trusty
MAINTAINER Zenoss <dev@zenoss.com>

RUN mkdir /usr/local/serviced/resources -p # this is mounted in to every isvcs container
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y -q openjdk-7-jre-headless gnuplot-nox supervisor make \
    redis-server git-core build-essential python-dev \
    libevent1-dev python-openssl liblzma-dev wget; \
    apt-get clean; \
    cd /tmp; \
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py; \
    python ez_setup.py; \
    easy_install pip; \
    rm -rf /var/lib/apt/lists/*_* /tmp/*
RUN pip install backports.lzma==0.0.2
RUN pip install elasticsearch-curator==3.0.3
ADD supervisor.conf /opt/zenoss/etc/supervisor.conf
ADD registry.tar.gz /
ADD consumer.tar.gz /
ADD opentsdb.tar.gz /
ADD query.tar.gz /
ADD es_serviced.tar.gz /
ADD es_logstash.tar.gz /
ADD zk.tar.gz /
ADD logstash.tar.gz /
ADD celery.tar.gz /
