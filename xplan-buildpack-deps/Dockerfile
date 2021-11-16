FROM tomcat:9.0-jdk8-temurin-focal AS tomcat
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

RUN echo "Downloading exernal components" \
	&& wget --progress=dot:giga -O /hale-cli.zip "${HALE_CLI_URL}" \
	&& echo "${HALE_CLI_SHA256} */hale-cli.zip" | sha256sum --strict --check \
	&& echo "Done"

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
#ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-distribution-releases/content
ARG DEE_REPO_URL=http://maven.werne.grit.de/artifactory/ext-release-local
ARG XPLANBOX_VERSION

RUN echo "Downloading files from repo and extract it" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-distribution.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-distribution/${XPLANBOX_VERSION}/xplan-distribution-${XPLANBOX_VERSION}.zip" \
	&& mkdir -p /dist \
	&& unzip -d /dist /xplan-distribution.zip \
	&& rm -v /xplan-distribution.zip \
	&& echo "Done"

COPY linker.sh /linker.sh

