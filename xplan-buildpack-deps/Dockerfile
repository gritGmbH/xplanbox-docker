FROM tomcat:9.0-jdk8-openjdk AS tomcat
FROM buildpack-deps:stable

ARG HALE_CLI_URL=https://github.com/halestudio/hale-cli/releases/download/v3.4.0/hale-cli-3.4.0.zip
ARG HALE_CLI_SHA256=84a4d6bd47d666b9b3b1e0863f05c264df969a7bc273effaecc9c7eb844ddfd1

RUN echo "Downloading exernal components" \
	&& wget --progress=dot:giga -O /hale-cli.zip "${HALE_CLI_URL}" \
	&& echo "${HALE_CLI_SHA256} */hale-cli.zip" | sha256sum --strict --check \
	&& echo "Done"

COPY --from=tomcat /usr/local/tomcat/conf/server.xml /target/usr/local/tomcat/conf/server.xml

# prepare tomcat/server.xml
# - remove ajp connector
# - disable access log
# - create http connector for secure connections

RUN	set -eux \
    && apt-get update \
    && apt-get install -y xmlstarlet \
    && xmlstarlet ed -L -d "/Server/Service/Connector[@protocol='AJP/1.3']" /target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L \
		-i "/Server/Service/Connector[@port='8080']" -t 'attr' -n 'secure' -v 'false' \
		-i "/Server/Service/Connector[@port='8080']" -t 'attr' -n 'scheme' -v 'http' \
		/target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L -a "/Server/Service/Connector[@protocol='HTTP/1.1']" -t 'elem' -n 'Connector' -v '' \
		-i "/Server/Service/Connector[not(@port)]" -t 'attr' -n 'port' -v '8443' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'protocol' -v 'HTTP/1.1' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'connectionTimeout' -v '20000' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'redirectPort' -v '8443' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'secure' -v 'true' \
		-i "/Server/Service/Connector[@port='8443']" -t 'attr' -n 'scheme' -v 'https' \
		/target/usr/local/tomcat/conf/server.xml \
	&& xmlstarlet ed -L -d "/Server/Service/Engine/Host/Valve[@className='org.apache.catalina.valves.AccessLogValve']" /target/usr/local/tomcat/conf/server.xml

COPY linker.sh /linker.sh

