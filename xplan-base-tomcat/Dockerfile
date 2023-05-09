# NOTE: Ubuntu Focal 20.04 LTS required for gdal 3.0 dependency
FROM tomcat:9.0-jdk11-temurin-focal

ENV LD_LIBRARY_PATH=/usr/lib/jni

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libgdal-java proj-bin fontconfig \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

# -DXPLANBOX_CONFIG=/home/xplanbox/.deegree/xplan-manager-config
# -DDEEGREE_WORKSPACE_ROOT=/pfad/zu/den/workspaces
#
ENV TZ=Europe/Berlin
ENV CATALINA_OPTS="-Djts.overlay=ng -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"

