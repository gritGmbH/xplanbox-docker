#!/bin/bash
test -f ".env" && . ".env"
test -z "$user" && echo "Please specify user in .env"
test -z "$password" && echo "Please specify password in .env"
test -z "$user" && exit 5
test -z "$password" && exit 5

DEST_DIR=./repo
REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-releases/content

XPLANBOX_VERSION=4.0.1
#FILES="/de/latlon/product/xplanbox/xplan-api-manager/${XPLANBOX_VERSION}/xplan-api-manager-${XPLANBOX_VERSION}.war"
FILES="/de/latlon/product/xplanbox/xplan-api-manager/${XPLANBOX_VERSION}/xplan-api-manager-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-api-validator/${XPLANBOX_VERSION}/xplan-api-validator-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${XPLANBOX_VERSION}-html.zip
    /de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${XPLANBOX_VERSION}-pdf.zip
    /de/latlon/product/xplanbox/xplan-betriebshandbuch/${XPLANBOX_VERSION}/xplan-betriebshandbuch-${XPLANBOX_VERSION}-html.zip
    /de/latlon/product/xplanbox/xplan-betriebshandbuch/${XPLANBOX_VERSION}/xplan-betriebshandbuch-${XPLANBOX_VERSION}-pdf.zip
    /de/latlon/product/xplanbox/xplan-inspireplu/${XPLANBOX_VERSION}/xplan-inspireplu-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-manager-cli/${XPLANBOX_VERSION}/xplan-manager-cli-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-manager-config/${XPLANBOX_VERSION}/xplan-manager-config-${XPLANBOX_VERSION}-default.zip
    /de/latlon/product/xplanbox/xplan-manager-web/${XPLANBOX_VERSION}/xplan-manager-web-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-root/${XPLANBOX_VERSION}/xplan-root-${XPLANBOX_VERSION}-default.war
    /de/latlon/product/xplanbox/xplan-transform-cli/${XPLANBOX_VERSION}/xplan-transform-cli-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-update-database/${XPLANBOX_VERSION}/xplan-update-database-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-validator-cli/${XPLANBOX_VERSION}/xplan-validator-cli-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-validator-config/${XPLANBOX_VERSION}/xplan-validator-config-${XPLANBOX_VERSION}.zip
    /de/latlon/product/xplanbox/xplan-validator-web/${XPLANBOX_VERSION}/xplan-validator-web-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-validator-wms/${XPLANBOX_VERSION}/xplan-validator-wms-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-wfs/${XPLANBOX_VERSION}/xplan-wfs-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-wms/${XPLANBOX_VERSION}/xplan-wms-${XPLANBOX_VERSION}.war
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-inspireplu-workspace-default.zip
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-manager-workspace-default.zip
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-validator-wms-workspace-default.zip
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-wfs-workspace-default.zip
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplansyn-wfs-workspace-default.zip
    /de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplansyn-wms-workspace-default.zip
    /de/latlon/product/xplanbox/xplansyn-wfs/${XPLANBOX_VERSION}/xplansyn-wfs-${XPLANBOX_VERSION}.war"

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