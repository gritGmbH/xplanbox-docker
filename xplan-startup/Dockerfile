# build with:
#  docker build --build-arg DEE_VERSION=YYYY.N --build-arg DEE_BUILD=TIMESTAMP .
#   or
#  docker build --build-arg DEE_VERSION --build-arg DEE_BUILD
#
FROM amazoncorretto:8

LABEL	maintainer="Stephan Reichhelm <reichhelm@grit.de>" \
	org.opencontainers.image.title="Utilities - Startup" \
	org.opencontainers.image.description="deegree Enterprise Edition - Startup Handling" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${DEE_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${DEE_VERSION}"

ADD app.tar.gz /

ENTRYPOINT [ ]
CMD [ "/app/wait-for-time.sh", "-s", "5", "--" ]