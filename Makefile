MODULES = wal2json
PG_VERSION ?= 9.6
PGPORT ?= 5436

REGRESS = cmdline insert1 update1 update2 update3 update4 delete1 delete2 \
		  delete3 delete4 savepoint specialvalue toast bytea

PG_CONFIG ?= pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

dockerbuild:
	docker run --rm -i -v $(PWD):/build -w /build -t dpirotte/postgres-dev:jessie bash -c "pg_ctlcluster ${PG_VERSION} main start ; make; make install ; make installcheck PGPORT=${PGPORT}"

# make installcheck
#
# It can be run but you need to add the following parameters to
# postgresql.conf:
#
# wal_level = logical
# max_replication_slots = 4
#
# Also, you should start the server before executing it.
