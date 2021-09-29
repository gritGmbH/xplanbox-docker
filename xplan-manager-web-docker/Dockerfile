ARG BUILD_TAG

FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps /target/root \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-manager-web /dist/xplan-manager-web.war \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-root-default.war \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-betriebshandbuch-html.zip \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-benutzerhandbuch-html.zip \
	&& unzip -d /target/root/ /dist/xplan-transform-cli.zip \
	&& unzip -d /target/root/ /dist/xplan-update-database.zip \
	&& unzip -d /target/root/ /dist/xplan-manager-cli.zip \
	&& unzip -d /target/ /hale-cli.zip \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan-manager-web/WEB-INF/lib /target/root/xplan-*/repo \
	&& sed -ri "s/^(log4j\.rootLogger)=([^\n]*)$/\1=INFO, stdout/" /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j.properties \
	&& sed -ri "s/^(log4j\.appender\.stdout\.Threshold)=([^\n]*)$/\1=WARN/" /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j.properties \
	&& echo "Done"

# NOTE: See used variant in xplan-base-tomcat
ARG BUILD_TAG

FROM xplan-base-tomcat:${BUILD_TAG}

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

ENV JAVA_OPTS="-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-manager-config/"

COPY --from=builder /target /
