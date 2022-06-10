# NOTE: Ubuntu Focal 20.04 LTS required for gdal 3.0 dependency
FROM tomcat:9.0-jdk11-temurin-focal

ENV LD_LIBRARY_PATH=/usr/lib/jni

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libgdal-java proj-bin \
	&& rm -rf /var/lib/apt/lists/*