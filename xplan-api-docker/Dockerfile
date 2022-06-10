ARG BUILD_TAG

FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-api-manager /dist/xplan-api-manager.war \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-api-validator /dist/xplan-api-validator.war \
	&& unzip -d /target/ /hale-cli.zip \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan*/WEB-INF/lib \
	&& bash /update-logging.sh \
	&& echo "Done"

# NOTE: See used variant in xplan-base-tomcat
ARG BUILD_TAG

FROM xplan-base-tomcat:${BUILD_TAG}

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
