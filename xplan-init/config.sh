#!/bin/bash
set -e 
set -o pipefail

WS=/work/srv-ws
MNGR=/work/mng-cfg
PLUSRV=/work/plu-ws
VALCFG=/work/val-cfg

mv "$WS/xplansyn-wms-workspace/gdal.ignore" "$WS/xplansyn-wms-workspace/gdal.xml"

# validatorConfiguration.properties
sed -ri "s/^(validatorWmsEndpoint)=([^\n]*)$/\1=\/xplan-validator-wms\/services\/wms/" "$MNGR/validatorConfiguration.properties"
sed -ri "s/^(validatorWmsEndpoint)=([^\n]*)$/\1=\/xplan-validator-wms\/services\/wms/" "$VALCFG/validatorConfiguration.properties"
sed -ri "s/^(apiUrl)=([^\n]*)$/\1=\/xplan-api-validator/" "$MNGR/validatorApiConfiguration.properties"
sed -ri "s/^(apiUrl)=([^\n]*)$/\1=\/xplan-api-validator/" "$VALCFG/validatorApiConfiguration.properties"

# managerApiConfiguration.properties
sed -ri "s/^(wmsUrl)=([^\n]*)$/\1=\/xplan-wms\/services/" "$MNGR/managerApiConfiguration.properties"
sed -ri "s/^(apiUrl)=([^\n]*)$/\1=\/xplan-api-manager/" "$MNGR/managerApiConfiguration.properties"

# managerWebConfiguration.properties
sed -ri "s/^(activatePublishingInspirePlu)=([^\n]*)$/\1=true/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(wmsUrl)=([^\n]*)$/\1=\/xplan-wms\/services/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(basemapUrl)=([^\n]*)$/\1=http:\/\/sgx.geodatenzentrum.de\/wms_topplus_open\?/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(basemapLayer)=([^\n]*)$/\1=web_grau/" "$MNGR/managerWebConfiguration.properties"

# managerConfiguration.properties
sed -ri "s/^(rasterConfigurationType)=([^\n]*)$/\1=gdal/" "$MNGR/managerConfiguration.properties"

sed -i 's/workspaceReloadUrls=/workspaceReloadUrls=http:\/\/xplan-services:8080\/xplan-wms\//' "$MNGR/managerConfiguration.properties"
sed -i 's/workspaceReloadUser=/workspaceReloadUser=deegree/' "$MNGR/managerConfiguration.properties"
sed -i 's/workspaceReloadPassword=/workspaceReloadPassword=deegree/' "$MNGR/managerConfiguration.properties"

sed -i 's/pathToHaleCli=/pathToHaleCli=\/hale\/bin\/hale/' "$MNGR/managerConfiguration.properties"

# inspire schema imports
for i in  /work/*-ws/*/appschemas/inspireplu/PlannedLandUse.xsd
do
    sed -ri 's/(schemaLocation=")http:(\/\/inspire.ec.europa.eu)/\1https:\2/' $i
done

# services
for i in $WS/*/jdbc/*.xml
do
    echo "modify $i"
    sed -i 's/localhost:5432\/xplanbox/xplan-db:5432\/xplanbox/' "$i"
    sed -i 's/localhost:5432\/inspireplu/xplan-plu-db:5432\/inspireplu/' "$i"
    sed -i 's/username".*value="xplanbox"/username" value="postgres"/' "$i"
    sed -i 's/password".*value="xplanbox"/password" value="postgres"/' "$i"

    sed -i 's/url".*value=""/url" value="jdbc:postgresql:\/\/xplan-db:5432\/xplanbox"/' "$i"
    sed -i 's/username".*value=""/username" value="postgres"/' "$i"
    sed -i 's/password".*value=""/password" value="postgres"/' "$i"
done

# reduce min idle / prepared connections
for i in $WS/*/jdbc/*.xml
do
    echo "modify $i"
    sed -i 's/"initialSize" value="10"/"initialSize" value="0"/' "$i"
    sed -i 's/"maxIdle" value="10"/"maxIdle" value="0"/' "$i"
done

for i in $PLUSRV/*/jdbc/*.xml
do
    echo "modify $i"
    sed -i 's/localhost:5432/xplan-plu-db:5432/' "$i"
    sed -i 's/username".*value="xplanbox"/username" value="postgres"/' "$i"
    sed -i 's/password".*value="xplanbox"/password" value="postgres"/' "$i"
done

# reduce min idle / prepared connections
for i in $PLUSRV/*/jdbc/*.xml
do
    echo "modify $i"
    sed -i 's/"initialSize" value="10"/"initialSize" value="1"/' "$i"
    sed -i 's/"maxIdle" value="10"/"maxIdle" value="1"/' "$i"
done
