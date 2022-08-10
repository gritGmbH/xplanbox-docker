ARG BUILD_TAG

FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps /target/root \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-manager-web /dist/xplan-manager-web.war \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-root-default.war \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-betriebshandbuch-html.zip \
	&& unzip -d /target/usr/local/tomcat/webapps/ROOT /dist/xplan-benutzerhandbuch-html.zip \
	&& unzip -d /target/root/ /dist/xplan-transform-cli.zip \
	&& unzip -d /target/root/ /dist/xplan-update-database-cli.zip \
	&& unzip -d /target/root/ /dist/xplan-manager-cli.zip \
	&& unzip -d /target/ /hale-cli.zip \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan-manager-web/WEB-INF/lib /target/root/xplan-*/repo \
	&& bash /update-logging.sh \
	&& echo "Done"

# NOTE: See used variant in xplan-base-tomcat
ARG BUILD_TAG

FROM xplan-base-tomcat:${BUILD_TAG}

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

# Label not set:
# maintainer="..."
# org.opencontainers.image.vendor="..."
LABEL	org.opencontainers.image.title="xPlanBox Manager" \
	org.opencontainers.image.description="xPlanBox - XPlanManagerWeb" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV JAVA_OPTS="-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-manager-config/"

COPY --from=builder /target /
