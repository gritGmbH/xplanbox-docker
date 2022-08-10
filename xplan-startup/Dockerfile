# build with:
#  docker build --build-arg DEE_VERSION=YYYY.N --build-arg DEE_BUILD=TIMESTAMP .
#   or
#  docker build --build-arg DEE_VERSION --build-arg DEE_BUILD
#
FROM eclipse-temurin:11-jdk-focal

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION

# Label not set:
# maintainer="..."
# org.opencontainers.image.vendor="..."
LABEL	org.opencontainers.image.title="Utilities - Startup" \
	org.opencontainers.image.description="Startup Handling" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}"

ADD app.tar.gz /

ENTRYPOINT [ ]
CMD [ "/app/wait-for-time.sh", "-s", "5", "--" ]