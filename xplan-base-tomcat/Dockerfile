# NOTE: OpenJDK variant required for gdal-2.4 dependency
FROM tomcat:9.0-jdk8-openjdk

ENV LD_LIBRARY_PATH=/usr/lib/jni

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libgdal-java proj-bin \
	&& rm -rf /var/lib/apt/lists/*