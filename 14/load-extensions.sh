#!/bin/bash

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the template db
psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'template_db'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE template_db IS_TEMPLATE true"

# Load zhparser into both template_db and $POSTGRES_DB
for DB in template_db "$POSTGRES_DB"; do
	echo "Loading zhparser extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
	    CREATE EXTENSION IF NOT EXISTS pg_trgm;
	    CREATE EXTENSION IF NOT EXISTS zhparser;
	    DO
      $$BEGIN
         CREATE TEXT SEARCH CONFIGURATION chn (PARSER = zhparser);
	       ALTER  TEXT SEARCH CONFIGURATION chn ADD MAPPING FOR n,v,a,i,e,l,t WITH simple;
      EXCEPTION
         WHEN unique_violation THEN
            NULL;  -- ignore error
      END;$$;
EOSQL
done
