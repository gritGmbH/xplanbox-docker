FROM tomcat:9.0-jdk8-openjdk-slim AS tomcat
FROM buildpack-deps:stable AS builder

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-releases/content
ARG XPLANBOX_VERSION

COPY linker.sh /linker.sh
    
RUN echo "Downloading files from repo" \
    && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-validator-web.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-web/${XPLANBOX_VERSION}/xplan-validator-web-${XPLANBOX_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-validator-wms.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-wms/${XPLANBOX_VERSION}/xplan-validator-wms-${XPLANBOX_VERSION}.war" \
	&& echo "Done"

COPY patches /patches
COPY conf /target/usr/local/tomcat/conf
COPY --from=tomcat /usr/local/tomcat/conf/web.xml /target/usr/local/tomcat/conf/web.xml

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-validator-web /xplan-validator-web.war \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-validator-wms /xplan-validator-wms.war \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan*/WEB-INF/lib \
    && patch -d /target -p1  </patches/web.xml.patch \
	&& sed -ri "s/^(log4j\.rootLogger)=([^\n]*)$/\1=INFO, stdout/" /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j.properties \
	&& sed -ri "s/^(log4j\.appender\.stdout\.Threshold)=([^\n]*)$/\1=WARN/" /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j.properties \
	&& echo "Done"

# NOTE: OpenJDK variant required for gdal-2.4 dependency
FROM tomcat:9.0-jdk8-openjdk-slim

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

LABEL	maintainer="graphische Informationstechnik - Beratungsgesellschaft mbH <info@grit.de>" \
	org.opencontainers.image.title="deegree-core WMS/WFS mit Security" \
	org.opencontainers.image.description="deegree Enterprise Edition - xPlanBox - XPlanValidator" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV JAVA_OPTS=-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-validator-config/

RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /target /
