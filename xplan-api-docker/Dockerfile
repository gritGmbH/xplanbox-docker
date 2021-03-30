ARG GIT_COMMIT
FROM xplan-buildpack-deps:${GIT_COMMIT} AS builder

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

RUN echo "Downloading files from repo" \
    && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-api-manager.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-api-manager/${XPLANBOX_VERSION}/xplan-api-manager-${XPLANBOX_VERSION}.war" \
    && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-api-validator.war "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-api-validator/${XPLANBOX_VERSION}/xplan-api-validator-${XPLANBOX_VERSION}.war" \
	&& echo "Done"

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-api-manager /xplan-api-manager.war \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-api-validator /xplan-api-validator.war \
	&& unzip -d /target/ /hale-cli.zip \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan*/WEB-INF/lib \
	&& sed -ri "s/^(log4j\.rootLogger)=([^\n]*)$/\1=INFO, stdout/" /target/usr/local/tomcat/webapps/xplan-api-manager/WEB-INF/classes/log4j.properties \
	&& sed -ri "s/^(log4j\.appender\.stdout\.Threshold)=([^\n]*)$/\1=INFO/" /target/usr/local/tomcat/webapps/xplan-api-manager/WEB-INF/classes/log4j.properties \
	&& sed -ri "s/^(log4j\.rootLogger)=([^\n]*)$/\1=INFO, stdout/" /target/usr/local/tomcat/webapps/xplan-api-validator/WEB-INF/classes/log4j.properties \
	&& sed -ri "s/^(log4j\.appender\.stdout\.Threshold)=([^\n]*)$/\1=WARN/" /target/usr/local/tomcat/webapps/xplan-api-validator/WEB-INF/classes/log4j.properties \
	&& echo "Done"

# NOTE: OpenJDK variant required for gdal-2.4 dependency
ARG GIT_COMMIT
FROM xplan-base-tomcat:${GIT_COMMIT}

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

LABEL	maintainer="graphische Informationstechnik - Beratungsgesellschaft mbH <info@grit.de>" \
	org.opencontainers.image.title="deegree-core WMS/WFS mit Security" \
	org.opencontainers.image.description="deegree Enterprise Edition - xPlanBox - XPlanManagerAPI, XPlanValidatorAPI" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV JAVA_OPTS="-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-manager-config/"

COPY --from=builder /target /
