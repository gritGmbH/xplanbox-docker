FROM buildpack-deps:stable AS builder

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-releases/content
ARG XPLANBOX_VERSION

ARG HALE_CLI_URL=https://github.com/halestudio/hale-cli/releases/download/v3.4.0/hale-cli-3.4.0.zip
ARG HALE_CLI_SHA256=84a4d6bd47d666b9b3b1e0863f05c264df969a7bc273effaecc9c7eb844ddfd1

RUN echo "Downloading exernal components" \
	&& wget --progress=dot:giga -O /hale-cli.zip "${HALE_CLI_URL}" \
	&& echo "${HALE_CLI_SHA256} */hale-cli.zip" | sha256sum --strict --check \
	&& echo "Done"

COPY linker.sh /linker.sh

RUN echo "Downloading files from repo" \
    && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-manager-web.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-web/${XPLANBOX_VERSION}/xplan-manager-web-${XPLANBOX_VERSION}.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-benutzerhandbuch.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-benutzerhandbuch/${XPLANBOX_VERSION}/xplan-benutzerhandbuch-${XPLANBOX_VERSION}-html.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-betriebshandbuch.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-betriebshandbuch/${XPLANBOX_VERSION}/xplan-betriebshandbuch-${XPLANBOX_VERSION}-html.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-root.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-root/${XPLANBOX_VERSION}/xplan-root-${XPLANBOX_VERSION}-default.war" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-transform-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-transform-cli/${XPLANBOX_VERSION}/xplan-transform-cli-${XPLANBOX_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-update-database.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-update-database/${XPLANBOX_VERSION}/xplan-update-database-${XPLANBOX_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-manager-cli.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-cli/${XPLANBOX_VERSION}/xplan-manager-cli-${XPLANBOX_VERSION}.zip" \
	&& echo "Done"

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps /target/root \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-manager-web /xplan-manager-web.zip \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /xplan-root.zip \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /xplan-benutzerhandbuch.zip \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /xplan-betriebshandbuch.zip \
	&& unzip -d /target/root/ /xplan-transform-cli.zip \
	&& unzip -d /target/root/ /xplan-update-database.zip \
	&& unzip -d /target/root/ /xplan-manager-cli.zip \
	&& unzip -d /target/ /hale-cli.zip \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan-manager-web/WEB-INF/lib /target/root/xplan-*/repo \
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
	org.opencontainers.image.description="deegree Enterprise Edition - xPlanBox - XPlanManagerWeb" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV LD_LIBRARY_PATH=/usr/lib/jni
ENV JAVA_OPTS="-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-manager-config/"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libgdal-java proj-bin curl \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /target /
