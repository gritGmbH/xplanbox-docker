FROM tomcat:9.0-jdk11-temurin-focal AS tomcat
FROM buildpack-deps:stable-curl

COPY --from=tomcat /usr/local/tomcat/conf/server.xml /target/usr/local/tomcat/conf/server.xml

# prepare tomcat/server.xml
# - remove ajp connector
# - disable access log
# - create http connector for secure connections

RUN	set -eux \
    && apt-get update \
    && apt-get install -y xmlstarlet jq git bzip2 file patch unzip xz-utils \
    && xmlstarlet ed -L -d "/Server/Service/Connector[@protocol='AJP/1.3']" /target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L \
		-i "/Server/Service/Connector[@port='8080']" -t 'attr' -n 'secure' -v 'false' \
		-i "/Server/Service/Connector[@port='8080']" -t 'attr' -n 'scheme' -v 'http' \
		/target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L -a "/Server/Service/Connector[@protocol='HTTP/1.1']" -t 'elem' -n 'Connector' -v '' \
		-i "/Server/Service/Connector[not(@port)]" -t 'attr' -n 'port' -v '8443' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'protocol' -v 'HTTP/1.1' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'connectionTimeout' -v '20000' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'redirectPort' -v '8443' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'secure' -v 'true' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'scheme' -v 'https' \
		/target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L -d "/Server/Service/Engine/Host/Valve[@className='org.apache.catalina.valves.AccessLogValve']" /target/usr/local/tomcat/conf/server.xml

ARG HALE_CLI_URL=https://github.com/halestudio/hale-cli/releases/download/v3.4.0/hale-cli-3.4.0.zip
ARG HALE_CLI_SHA256=84a4d6bd47d666b9b3b1e0863f05c264df969a7bc273effaecc9c7eb844ddfd1

# YQ is not available in distribution
ARG YQ_CLI_URL=https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64
ARG YQ_CLI_SHA256=042f7462ec8378f8b0d3bac85d1b1a063b63beef5d8e3826bb2377294116ae90

RUN echo "Downloading exernal components" \
	&& wget --progress=dot:giga -O /hale-cli.zip "${HALE_CLI_URL}" \
	&& echo "${HALE_CLI_SHA256} */hale-cli.zip" | sha256sum --strict --check \
	&& wget --progress=dot:giga -O /yq "${YQ_CLI_URL}" \
	&& echo "${YQ_CLI_SHA256} */yq" | sha256sum --strict --check \
	&& chmod a+x /yq \
	&& echo "Done"

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
#ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-distribution-releases/content
#ARG DEE_REPO_URL=http://maven.werne.grit.de/artifactory/ext-release-local
ARG DEE_REPO_URL=http://maven.werne.grit.de/artifactory/xplanbox-repos
ARG XPLANBOX_VERSION

RUN echo "Downloading files from repo and extract it" \
	&& mkdir -p /dist \
	&& FILE_VERSION=${XPLANBOX_VERSION} \
	&& bash -c '[[ "${XPLANBOX_VERSION}" == *-SNAPSHOT ]]' && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS -O /tmp/maven-metadata.xml "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-api-manager/${XPLANBOX_VERSION}/maven-metadata.xml" || echo "NO-SNAPSHOT" \
	&& bash -c '[[ "${XPLANBOX_VERSION}" == *-SNAPSHOT ]]' && FILE_VERSION=$(xmlstarlet sel -t -m "metadata/versioning/snapshotVersions" -c "./snapshotVersion[1]/value/text()" /tmp/maven-metadata.xml ) || echo "NO-SNAPSHOT" \
	# Documetation \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-benutzerhandbuch-html.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${FILE_VERSION}-html.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-benutzerhandbuch-pdf.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${FILE_VERSION}-pdf.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-betriebshandbuch-html.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-betriebshandbuch/${XPLANBOX_VERSION}/xplan-betriebshandbuch-${FILE_VERSION}-html.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-betriebshandbuch-pdf.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-betriebshandbuch/${XPLANBOX_VERSION}/xplan-betriebshandbuch-${FILE_VERSION}-pdf.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-benutzerhandbuch-validator-html.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${FILE_VERSION}-validator-html.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-benutzerhandbuch-validator-pdf.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${FILE_VERSION}-validator-pdf.zip" \
	# CLI \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-manager-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-cli/${XPLANBOX_VERSION}/xplan-manager-cli-${FILE_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-transform-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-transform-cli/${XPLANBOX_VERSION}/xplan-transform-cli-${FILE_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-validator-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-cli/${XPLANBOX_VERSION}/xplan-validator-cli-${FILE_VERSION}.zip" \
	# CLI new in 6.x \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-update-data-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-update-data-cli/${XPLANBOX_VERSION}/xplan-update-data-cli-${FILE_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-validatedb-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validatedb-cli/${XPLANBOX_VERSION}/xplan-validatedb-cli-${FILE_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-evaluation-schema-synchronize-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-evaluation-schema-synchronize-cli/${XPLANBOX_VERSION}/xplan-evaluation-schema-synchronize-cli-${FILE_VERSION}.zip" \
	# API
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-api-manager.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-api-manager/${XPLANBOX_VERSION}/xplan-api-manager-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-api-validator.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-api-validator/${XPLANBOX_VERSION}/xplan-api-validator-${FILE_VERSION}.war" \
	# Webapp \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-inspireplu.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-inspireplu/${XPLANBOX_VERSION}/xplan-inspireplu-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-manager-web.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-web/${XPLANBOX_VERSION}/xplan-manager-web-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-root-default.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-root/${XPLANBOX_VERSION}/xplan-root-${FILE_VERSION}-default.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-validator-web.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-web/${XPLANBOX_VERSION}/xplan-validator-web-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-validator-wms.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-wms/${XPLANBOX_VERSION}/xplan-validator-wms-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-wfs.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-wfs/${XPLANBOX_VERSION}/xplan-wfs-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-wms.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-wms/${XPLANBOX_VERSION}/xplan-wms-${FILE_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplansyn-wfs.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplansyn-wfs/${XPLANBOX_VERSION}/xplansyn-wfs-${FILE_VERSION}.war" \
	# Config \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-manager-config-default.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-config/${XPLANBOX_VERSION}/xplan-manager-config-${FILE_VERSION}-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-validator-config.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-config/${XPLANBOX_VERSION}/xplan-validator-config-${FILE_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplan-inspireplu-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplan-inspireplu-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplan-manager-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplan-manager-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplan-wfs-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplan-wfs-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplansyn-wfs-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplansyn-wfs-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplansyn-wms-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplansyn-wms-workspace.zip" \
	# removed in 6.x  xplan-workspaces-xplan-validator-wms-workspace.zip \
	# Config new in 6.x \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplan-validator-wms-sql-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplan-validator-wms-sql-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-workspaces-xplan-validator-wms-memory-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${FILE_VERSION}-xplan-validator-wms-memory-workspace.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /dist/xplan-mapserver-config.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-mapserver-config/${XPLANBOX_VERSION}/xplan-mapserver-config-${FILE_VERSION}.zip" \
	# nach 5.0.3 wurde xplan-update-database-cli entfernt \
	&& echo "Done"

COPY linker.sh /linker.sh
COPY update-logging.sh /update-logging.sh
