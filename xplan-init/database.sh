#!/bin/bash
set -e 
set -o pipefail

WS=/work/srv-ws
PLUSRV=/work/plu-ws

DB_USER=${DB_USER:-postgres}
DB_PASS=${DB_PASS:-postgres}
DB_HOST=${DB_HOST:-xplan-db}
DB_PORT=${DB_PORT:-5432}
DB_DATABASE=${DB_DATABASE:-xplanbox}
DB_EXTRA=${DB_EXTRA:-}
DB_CON_INIT=${DB_CON_INIT:-1}
DB_CON_IDLE=${DB_CON_IDLE:-1}
DB_CON_MAX=${DB_CON_MAX:-10}

PLUDB_USER=${PLUDB_USER:-postgres}
PLUDB_PASS=${PLUDB_PASS:-postgres}
PLUDB_HOST=${PLUDB_HOST:-xplan-plu-db}
PLUDB_PORT=${PLUDB_PORT:-5432}
PLUDB_DATABASE=${PLUDB_DATABASE:-xplanbox}
PLUDB_EXTRA=${PLUDB_EXTRA:-}
PLUDB_CON_INIT=${PLUDB_CON_INIT:-1}
PLUDB_CON_IDLE=${PLUDB_CON_IDLE:-1}
PLUDB_CON_MAX=${PLUDB_CON_MAX:-10}

# service connection
for i in $WS/*/jdbc/xplan*.xml $WS/*/jdbc/vfdb.xml
do
    test -e "$i" || continue
    echo "modify $i"
    xmlstarlet ed -L \
        -u "//*[local-name()='Property' and @name='url']/@value" -v "jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_DATABASE}${DB_EXTRA}" \
        -u "//*[local-name()='Property' and @name='username']/@value" -v "${DB_USER}" \
        -u "//*[local-name()='Property' and @name='password']/@value" -v "${DB_PASS}" \
        -u "//*[local-name()='Property' and @name='initialSize']/@value" -v "${DB_CON_INIT}" \
        -u "//*[local-name()='Property' and @name='maxIdle']/@value" -v "${DB_CON_IDLE}" \
        -u "//*[local-name()='Property' and @name='maxActive']/@value" -v "${DB_CON_MAX}" \
        "$i"
done

# plu connection
for i in $PLUSRV/*/jdbc/*.xml  $WS/*/jdbc/inspireplu*.xml
do
    test -e "$i" || continue
    echo "modify $i"
    xmlstarlet ed -L \
        -u "//*[local-name()='Property' and @name='url']/@value" -v "jdbc:postgresql://${PLUDB_HOST}:${PLUDB_PORT}/${PLUDB_DATABASE}${PLUDB_EXTRA}" \
        -u "//*[local-name()='Property' and @name='username']/@value" -v "${PLUDB_USER}" \
        -u "//*[local-name()='Property' and @name='password']/@value" -v "${PLUDB_PASS}" \
        -u "//*[local-name()='Property' and @name='initialSize']/@value" -v "${PLUDB_CON_INIT}" \
        -u "//*[local-name()='Property' and @name='maxIdle']/@value" -v "${PLUDB_CON_IDLE}" \
        -u "//*[local-name()='Property' and @name='maxActive']/@value" -v "${PLUDB_CON_MAX}" \
        "$i"
done

# EoF