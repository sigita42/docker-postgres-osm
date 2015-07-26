# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM postgres:9.4.4
MAINTAINER James Badger <james@jamesbadger.ca>

ENV DEBIAN_FRONTEND noninteractive
ENV PG_MAJOR 9.4

RUN apt-get update && \
    apt-get install -y -q postgresql-${PG_MAJOR}-postgis-2.1 \
                          postgresql-contrib \
                          postgresql-server-dev-${PG_MAJOR} && \
    rm -rf /var/lib/apt/lists/*

ENV OSM_USER osm
ENV OSM_DB gis

RUN mkdir -p /docker-entrypoint-initdb.d
ADD ./postgres-entry.sh /docker-entrypoint-initdb.d/postgres-entry.sh
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
