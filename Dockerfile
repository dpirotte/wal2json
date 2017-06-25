FROM postgres:9.6
MAINTAINER Dave Pirotte "dpirotte@gmail.com"

RUN apt-get -qq update
RUN apt-get -yqq install build-essential postgresql-server-dev-9.6

RUN pg_createcluster 9.6 wal2json -- -k

RUN echo \
  "wal_level = logical\n" \
  "max_wal_senders = 5\n" \
  "max_replication_slots = 5\n" \
  >> /etc/postgresql/9.6/wal2json/postgresql.conf

RUN pg_ctlcluster 9.6 wal2json start && \
  su postgres -c "createuser -d -r -s root" && \
  pg_ctlcluster 9.6 wal2json stop --force

ADD . /usr/local/src/wal2json

WORKDIR /usr/local/src/wal2json

CMD pg_ctlcluster 9.6 wal2json start && \
  /usr/bin/make install && \
  /usr/bin/make installcheck
