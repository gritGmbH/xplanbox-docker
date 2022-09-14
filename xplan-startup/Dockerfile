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

ARG JDBC_TESTER_URL=http://maven.werne.grit.de/artifactory/libs-release-local/de/grit/jdbc-tester/1.1/jdbc-tester-1.1-run.jar
ARG JDBC_TESTER_SHA256=54cace05169d4b5bdfaa92cbfc5b53d85d6a8272ae87fb434894cab5e90a190b

RUN echo "Downloading exernal components" \
	&& wget --progress=dot:giga -O /app/jdbc-tester-run.jar "${JDBC_TESTER_URL}" \
	&& echo "${JDBC_TESTER_SHA256} */app/jdbc-tester-run.jar" | sha256sum --strict --check \
	&& echo "Done"

ENTRYPOINT [ ]
CMD [ "/app/wait-for-time.sh", "-s", "5", "--" ]