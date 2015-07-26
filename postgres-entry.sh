#!/bin/bash
set -e

echo "CREATE USER '$OSM_USER';"
gosu postgres psql <<-EOL
  CREATE USER "$OSM_USER";
EOL

echo "CREATE DATABASE '$OSM_DB';"
gosu postgres psql <<-EOL
  CREATE DATABASE "$OSM_DB";
EOL

echo "GRANT ALL ON DATABASE '$OSM_DB' TO '$OSM_USER';"
gosu postgres psql <<-EOL
  GRANT ALL ON DATABASE "$OSM_DB" TO "$OSM_USER";
EOL

# Postgis extension cannot be created in single user mode.
# So we will do it the kludge way by starting the server,
# updating the DB, then shutting down the server so the
# rest of the docker-postgres init scripts can finish.

# echo "Starting postrges ..."
# gosu postgres pg_ctl -w start

echo "CREATE EXTENSION postgis, hstore + ALTER TABLEs"
gosu postgres psql "$OSM_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  ALTER TABLE geometry_columns OWNER TO "$OSM_USER";
  ALTER TABLE spatial_ref_sys OWNER TO "$OSM_USER";
EOL

# echo "Stopping postgres ..."
# gosu postgres pg_ctl stop
