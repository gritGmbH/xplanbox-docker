#!/bin/bash
set -e 
set -o pipefail

WS=/work/srv-ws
MNGR=/work/mng-cfg
PLUSRV=/work/plu-ws
VALCFG=/work/val-cfg

# Use of Mapserver no gdal used
#mv "$WS/xplan-services-wms-workspace/gdal.ignore" "$WS/xplan-services-wms-workspace/gdal.xml"

# validatorConfiguration.properties
sed -ri "s/^(validatorWmsEndpoint)=([^\n]*)$/\1=\/xplan-webservices-validator-wms\/services\/wms/" "$VALCFG/validatorConfiguration.properties"
sed -ri "s/^(apiUrl)=([^\n]*)$/\1=/" "$VALCFG/validatorApiConfiguration.properties"

# managerApiConfiguration.properties
sed -ri "s/^(wmsUrl)=([^\n]*)$/\1=\/xplan-services-wms\/services/" "$MNGR/managerApiConfiguration.properties"
sed -ri "s/^(apiUrl)=([^\n]*)$/\1=\/xplan-manager-api/" "$MNGR/managerApiConfiguration.properties"

# managerWebConfiguration.properties
sed -ri "s/^(activatePublishingInspirePlu)=([^\n]*)$/\1=true/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(wmsUrl)=([^\n]*)$/\1=\/xplan-services-wms\/services/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(basemapUrl)=([^\n]*)$/\1=http:\/\/sgx.geodatenzentrum.de\/wms_topplus_open\?/" "$MNGR/managerWebConfiguration.properties"
sed -ri "s/^(basemapLayer)=([^\n]*)$/\1=web_grau/" "$MNGR/managerWebConfiguration.properties"

# managerConfiguration.properties
#sed -ri "s/^(rasterConfigurationType)=([^\n]*)$/\1=gdal/" "$MNGR/managerConfiguration.properties"

sed -i 's/workspaceReloadUrls=/workspaceReloadUrls=http:\/\/xplan-services:8080\/xplan-services-wms\//' "$MNGR/managerConfiguration.properties"
sed -i 's/workspaceReloadUser=/workspaceReloadUser=deegree/' "$MNGR/managerConfiguration.properties"
sed -i 's/workspaceReloadPassword=/workspaceReloadPassword=deegree/' "$MNGR/managerConfiguration.properties"

sed -i 's/pathToHaleCli=/pathToHaleCli=\/hale\/bin\/hale/' "$MNGR/managerConfiguration.properties"

# inspire schema imports
for i in  /work/*-ws/*/appschemas/inspireplu/PlannedLandUse.xsd $MNGR/appschemas/inspireplu/PlannedLandUse-AdaptedGml.*sd
do
    sed -ri 's/(schemaLocation=")http:(\/\/inspire.ec.europa.eu)/\1https:\2/' $i
done

# mapserver
sed -ri "s/^(rasterConfigurationType)=([^\n]*)$/\1=mapserver/" "$MNGR/managerConfiguration.properties"

mv $WS/xplan-services-wms-workspace/layers/mapserver.ignore $WS/xplan-services-wms-workspace/layers/mapserver.xml
mv $WS/xplan-services-wms-workspace/datasources/remoteows/mapserver.ignore $WS/xplan-services-wms-workspace/datasources/remoteows/mapserver.xml

sed -i 's/http:\/\/localhost:8080\/mapserver/http:\/\/mapserver:8080\/services/' $WS/xplan-services-wms-workspace/datasources/remoteows/mapserver.*

# enable mapserver references
for i in  $WS/*/themes/*raster.xml
do
    # enable store reference for mapserver
    sed -i 's/<!--\s*\(<[^>]*>mapserver<[^>]*>\)\s*-->/\1/' $i
    # enalbe layer references
    sed -i 's/<!--\s*\(<[^"]*"mapserver"\s*>[^>]*>\)\s*-->/\1/' $i
done

# 7.1.3 fix missing schema files
#for i in $PLUSRV/xplan-inspireplu-workspace/appschemas/inspireplu/*/
#do
#    test -d "$WS/xplan-manager-workspace/appschemas/inspireplu/$(basename $i)" || cp -r $i "$WS/xplan-manager-workspace/appschemas/inspireplu/"
#done
# EoF