 ARG BUILD_TAG
FROM xplan-base-tomcat:${BUILD_TAG} AS tomcat

ARG BUILD_TAG
FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

COPY patches /patches
COPY conf /target/usr/local/tomcat/conf
COPY --from=tomcat /usr/local/tomcat/conf/web.xml /target/usr/local/tomcat/conf/web.xml

ARG FIX_BATIK_URL=https://maven.werne.grit.de/artifactory/repo1-cache/org/apache/xmlgraphics/batik-codec/1.14/batik-codec-1.14.jar
ARG FIX_BATIK_SHA=f63ed1f18412cead069fa97b677fdbda43b6a1af

RUN echo "Loading batik-codec fix" \
	&& mkdir /batik-fix \
	&& wget --progress=dot:giga -O /batik-fix/batik-codec-1.14.jar "${FIX_BATIK_URL}" \
	&& ( echo -n "${FIX_BATIK_SHA}  /batik-fix/batik-codec-1.14.jar\n" > /batik-fix/batik-codec-1.14.sha ) \
	&& sha1sum -c /batik-fix/batik-codec-1.14.sha \
	&& echo "Extract" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-inspireplu /dist/xplan-inspireplu.war \
	&& echo "Apply batik-codec fix" \
	&& cp -v /batik-fix/batik-codec-1.14.jar  /target/usr/local/tomcat/webapps/xplan-inspireplu/WEB-INF/lib/ \
	&& echo "Cleanup" \
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
