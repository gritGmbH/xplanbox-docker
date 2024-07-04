#!/bin/sh
set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

cd /xplan-db-sql && "${psql[@]}" -f create.sql