FROM zenoss/centos-base:1.0.2-java
MAINTAINER Zenoss <dev@zenoss.com>

# Create mount point for isvcs resources
RUN mkdir -p /usr/local/serviced/resources

# Install Java
RUN yum -y install java-1.7.0-openjdk-headless \
    && /sbin/scrub.sh

# Install Celery
ADD redis.conf /opt/celery/etc/redis.conf
ADD celery-supervisor.conf /opt/celery/etc/supervisor.conf
RUN mkdir -p /opt/celery/var/log /opt/celery/var/redis /opt/celery/etc
RUN ln -s /usr/local/serviced/resources/cpcelery.py /usr/lib/python2.7/site-packages/cpcelery.py
RUN yum -y install epel-release \
    && yum install -y redis \
    && pip install --no-cache-dir celery[redis] pyes python-dateutil socketIO-client \
    && yum -y erase epel-release \
    && /sbin/scrub.sh

# Install serviced's Elastic
ENV ES_SERVICED_VERSION 0.90.9
ADD elasticsearch-addendum.yaml /var/elasticsearch-addendum.yaml
ADD changeESLogProperties.sh /var/changeESLogProperties.sh
RUN wget -qO- https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_SERVICED_VERSION}.tar.gz | tar -C /opt -xz \
    && /opt/elasticsearch-${ES_SERVICED_VERSION}/bin/plugin -install mobz/elasticsearch-head \
    && sed -i -e 's/^.*cluster.name.*$/cluster.name: elasticsearch_serviced/' /opt/elasticsearch-${ES_SERVICED_VERSION}/config/elasticsearch.yml \
    && cat /var/elasticsearch-addendum.yaml >> /opt/elasticsearch-${ES_SERVICED_VERSION}/config/elasticsearch.yml \
    && /var/changeESLogProperties.sh /opt/elasticsearch-${ES_SERVICED_VERSION}/config/logging.yml \
    && /sbin/scrub.sh


# Install logstash's Elastic
ENV ES_LOGSTASH_VERSION 1.3.1
RUN wget -qO- https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_LOGSTASH_VERSION}.tar.gz | tar -C /opt -xz \
    && /opt/elasticsearch-${ES_LOGSTASH_VERSION}/bin/plugin -install mobz/elasticsearch-head \
    && sed -i -e 's/^.*http.port.*$/http.port: 9100/' /opt/elasticsearch-${ES_LOGSTASH_VERSION}/config/elasticsearch.yml \
    && sed -i -e 's/^.*cluster.name.*$/cluster.name: elasticsearch_logstash/' /opt/elasticsearch-${ES_LOGSTASH_VERSION}/config/elasticsearch.yml \
    && cat /var/elasticsearch-addendum.yaml >> /opt/elasticsearch-${ES_LOGSTASH_VERSION}/config/elasticsearch.yml \
    && /var/changeESLogProperties.sh /opt/elasticsearch-${ES_LOGSTASH_VERSION}/config/logging.yml \
    && pip install --no-cache-dir elasticsearch-curator==3.0.3 \
    && /sbin/scrub.sh

# Install metric consumer
ENV CONSUMER_VERSION 0.1.3
ADD modify-consumer-config.sh /var/modify-consumer-config.sh
RUN mkdir -p /opt/zenoss/log /opt/zenoss/etc/supervisor /opt/zenoss/var
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/metric-consumer-app-${CONSUMER_VERSION}-zapp.tar.gz | tar -C /opt/zenoss -xz \
    && chmod a+x /opt/zenoss/bin/metric-consumer-app.sh \
    && ln -s /opt/zenoss/etc/metric-consumer-app/metric-consumer-app_supervisor.conf /opt/zenoss/etc/supervisor \
    && /var/modify-consumer-config.sh /opt/zenoss/etc/metric-consumer-app/configuration.yaml \
    && /sbin/scrub.sh

# Install query service
ENV QUERY_VERSION 0.1.10-1
ADD modify-query-config.sh /var/modify-query-config.sh
RUN mkdir -p /opt/zenoss/log /opt/zenoss/etc/supervisor /opt/zenoss/var
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/central-query-${QUERY_VERSION}-zapp.tar.gz | tar -C /opt/zenoss -xz \
    && chmod a+x /opt/zenoss/bin/central-query.sh \
    && ln -s /opt/zenoss/etc/central-query/central-query_supervisor.conf /opt/zenoss/etc/supervisor \
    && /var/modify-query-config.sh /opt/zenoss/etc/central-query/configuration.yaml \
    && /sbin/scrub.sh

# Install Logstash
ENV LOGSTASH_VERSION 1.4.2
RUN wget -qO- https://download.elasticsearch.org/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz | tar -C /opt -xz

# Install Docker registry
ENV REGISTRY_VERSION 2.0.1
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/registry-${REGISTRY_VERSION}.tar.gz | tar -C / -xz

# Install hbase and opentsdb
ENV OPENTSDB_VERSION 2.2.0
ENV HBASE_VERSION 0.94.16
ADD set-opentsdb-table-ttl.sh /var/set-opentsdb-table-ttl.sh
RUN wget -qO- https://zenoss-pip.s3.amazonaws.com/packages/opentsdb-${OPENTSDB_VERSION}_hbase-${HBASE_VERSION}-0.tar.gz | tar -C / -xz
RUN yum -y install      \
        gnuplot-minimal \
        make            \
        snappy          \
        lzo             \
    && /sbin/scrub.sh

# Add supervisord config
ADD supervisor.conf /opt/zenoss/etc/supervisor.conf

