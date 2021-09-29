#!/bin/bash
test -f ".env" && . ".env"
test -z "$user" && echo "Please specify user in .env"
test -z "$password" && echo "Please specify password in .env"
test -z "$user" && exit 5
test -z "$password" && exit 5

DEST_DIR=./repo
REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-distribution-releases/content

#XPLANBOX_VERSION=4.0.1
#FILES="/de/latlon/product/xplanbox/xplan-distribution/${XPLANBOX_VERSION}/xplan-distribution-${XPLANBOX_VERSION}.zip
#    /de/latlon/product/xplanbox/xplan-distribution/${XPLANBOX_VERSION}/xplan-distribution-${XPLANBOX_VERSION}.pom"

XPLANBOX_VERSION=4.2
FILES="/de/latlon/product/xplanbox/xplan-distribution/${XPLANBOX_VERSION}/xplan-distribution-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-distribution/${XPLANBOX_VERSION}/xplan-distribution-${XPLANBOX_VERSION}.pom"

echo "Starting to load files"
echo ""
export WGETRC=$PWD/.env
for ARTEFACT in $FILES
do
    DIRNAME=$(dirname "$ARTEFACT")
    FILENAME=$(basename "$ARTEFACT")
    TARGET="${DEST_DIR}${ARTEFACT}"
    test -d "${DEST_DIR}/${DIRNAME}" || mkdir -v -p "${DEST_DIR}${DIRNAME}"
    test -f "${TARGET}" || echo "Loading $FILENAME"
    test -f "${TARGET}" || wget --progress=dot:giga "${REPO_URL}${ARTEFACT}" -O "${DEST_DIR}${ARTEFACT}"
done

echo ""
echo "Complete"