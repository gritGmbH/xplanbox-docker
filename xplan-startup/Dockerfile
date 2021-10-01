# build with:
#  docker build --build-arg DEE_VERSION=YYYY.N --build-arg DEE_BUILD=TIMESTAMP .
#   or
#  docker build --build-arg DEE_VERSION --build-arg DEE_BUILD
#
FROM eclipse-temurin:8-jdk-focal

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION

LABEL	maintainer="Stephan Reichhelm <reichhelm@grit.de>" \
	org.opencontainers.image.title="Utilities - Startup" \
	org.opencontainers.image.description="deegree Enterprise Edition - Startup Handling" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}"

ADD app.tar.gz /

ENTRYPOINT [ ]
CMD [ "/app/wait-for-time.sh", "-s", "5", "--" ]