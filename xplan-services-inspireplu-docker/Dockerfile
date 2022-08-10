 ARG BUILD_TAG
FROM xplan-base-tomcat:${BUILD_TAG} AS tomcat

ARG BUILD_TAG
FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

COPY patches /patches
COPY conf /target/usr/local/tomcat/conf
COPY --from=tomcat /usr/local/tomcat/conf/web.xml /target/usr/local/tomcat/conf/web.xml

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-inspireplu /dist/xplan-inspireplu.war \
    && patch -d /target -p1  </patches/web.xml.patch \
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
LABEL	org.opencontainers.image.title="xPlanBox PLU Services" \
	org.opencontainers.image.description="xPlanBox - XPlanInspirePluWMS, XPlanInspirePluWFS" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV JAVA_OPTS=-Xmx8192m

COPY --from=builder /target /
