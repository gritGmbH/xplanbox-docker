# NOTE: Ubuntu Focal 20.04 LTS required for gdal 3.0 dependency
FROM tomcat:9.0-jdk11-temurin-focal

ENV LD_LIBRARY_PATH=/usr/lib/jni

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libgdal-java proj-bin fontconfig \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& sed -z -i 's|<Valve [^>]*/>||g' /usr/local/tomcat/conf/server.xml \
	&& echo "handlers = java.util.logging.ConsoleHandler\n\
.handlers =  java.util.logging.ConsoleHandler\n\
\n\
java.util.logging.ConsoleHandler.level = FINE\n\
java.util.logging.ConsoleHandler.formatter = org.apache.juli.OneLineFormatter\n\
java.util.logging.ConsoleHandler.encoding = UTF-8\n" >/usr/local/tomcat/conf/logging.properties \
	&& echo "Done"

# -DXPLANBOX_CONFIG=/home/xplanbox/.deegree/xplan-manager-config
# -DDEEGREE_WORKSPACE_ROOT=/pfad/zu/den/workspaces
#
ENV TZ=Europe/Berlin
ENV CATALINA_OPTS="-Djts.overlay=ng -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"

