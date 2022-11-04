#!/bin/bash

set -e

# Create the template db
psql -U $POSTGRES_USER -tc "SELECT 1 FROM pg_database WHERE datname = 'template_db'" | grep -q 1 || psql -U $POSTGRES_USER -c "CREATE DATABASE template_db IS_TEMPLATE true"

# Load zhparser into both template_db and $POSTGRES_DB
for DB in template_db "$POSTGRES_DB"; do
echo "Loading zhparser extensions into $DB"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS zhparser;
    DO
    \$\$BEGIN
      CREATE TEXT SEARCH CONFIGURATION chn (PARSER = zhparser);
      ALTER  TEXT SEARCH CONFIGURATION chn ADD MAPPING FOR n,v,a,i,e,l,t WITH simple;
    EXCEPTION
    WHEN unique_violation THEN
    NULL;  -- ignore error
    END;\$\$;
    SELECT extname,extversion FROM pg_extension;
EOSQL
done
