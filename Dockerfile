FROM debian:jessie
MAINTAINER Dave Pirotte "dpirotte@gmail.com"

RUN apt-get -qq update
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get -yqq install wget ca-certificates
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get -qq update
RUN apt-get -yqq install make gcc postgresql-9.6 postgresql-server-dev-9.6


RUN echo \
  "wal_level = logical\n" \
  "max_wal_senders = 5\n" \
  "max_replication_slots = 5\n" \
  >> /etc/postgresql/9.6/main/postgresql.conf

RUN pg_ctlcluster 9.6 main start && \
  su postgres -c "createuser -d -r -s root" && \
  pg_ctlcluster 9.6 main stop --force

ADD . /usr/local/src/wal2json

WORKDIR /usr/local/src/wal2json

CMD pg_ctlcluster 9.6 main start && \
  /usr/bin/make install && \
  /usr/bin/make installcheck
