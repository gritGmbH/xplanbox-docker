ARG BUILD_TAG

FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

COPY patches /patches
COPY conf /target/usr/local/tomcat/conf
COPY --from=tomcat /usr/local/tomcat/conf/web.xml /target/usr/local/tomcat/conf/web.xml

RUN echo "Extract and Cleanup" \
	&& mkdir -p /target/usr/local/tomcat/webapps \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-validator-web /dist/xplan-validator-web.war \
	&& unzip -d /target/usr/local/tomcat/webapps/xplan-validator-wms /dist/xplan-validator-wms.war \
	&& bash /linker.sh /target/usr/local/tomcat/webapps/xplan*/WEB-INF/lib \
    && patch -d /target -p1  </patches/web.xml.patch \
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
	org.opencontainers.image.description="deegree Enterprise Edition - xPlanBox - XPlanValidator" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV JAVA_OPTS="-Xmx8192m -DXPLANBOX_CONFIG=/root/xplan-validator-config/"

COPY --from=builder /target /
