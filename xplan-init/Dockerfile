ARG BUILD_TAG

FROM xplan-buildpack-deps:${BUILD_TAG} AS builder

COPY template /work
COPY config.sh /config.sh
COPY database.sh /tpl/database.sh
COPY copy.sh /tpl/copy.sh

RUN echo "Extract and Cleanup" \
	&& mkdir -p /work/srv-ws  \
	&& unzip -d /work/srv-ws/xplan-services-wfs-workspace /dist/xplan-services-wfs-workspace.zip \
	&& unzip -d /work/srv-ws/xplan-services-wfs-syn-workspace /dist/xplan-services-wfs-syn-workspace.zip \
	&& unzip -d /work/srv-ws/xplan-services-wms-workspace /dist/xplan-services-wms-workspace.zip \
	&& unzip -d /work/srv-ws/xplan-manager-workspace /dist/xplan-manager-workspace.zip \
	&& mkdir -p /work/mng-cfg  \
	&& unzip -d /work/mng-cfg /dist/xplan-manager-config-default.zip \
	&& mkdir -p /work/val-cfg  \
	&& unzip -d /work/val-cfg /dist/xplan-validator-config.zip \
	&& mkdir -p /work/val-ws  \
	&& unzip -d /work/val-ws/xplan-webservices-validator-wms-sql-workspace /dist/xplan-webservices-validator-wms-sql-workspace.zip \
	&& unzip -d /work/val-ws/xplan-webservices-validator-wms-memory-workspace /dist/xplan-webservices-validator-wms-memory-workspace.zip \
	&& mkdir -p /work/plu-ws  \
	&& unzip -d /work/plu-ws/xplan-webservices-inspireplu-workspace /dist/xplan-webservices-inspireplu-workspace.zip \
	&& bash /config.sh \
	&& bash /tpl/database.sh \
	&& cd /work/srv-ws && tar -cvzf /tpl/srv-ws.tgz . \
	&& cd /work/mng-cfg && tar -cvzf /tpl/mng-cfg.tgz . \
	&& cd /work/val-cfg && tar -cvzf /tpl/val-cfg.tgz . \
	&& cd /work/val-ws && tar -cvzf /tpl/val-ws.tgz . \
	&& cd /work/plu-ws && tar -cvzf /tpl/plu-ws.tgz . \
	&& echo "Done"

FROM buildpack-deps:stable-curl

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

# Label not set:
# maintainer="..."
# org.opencontainers.image.vendor="..."
LABEL	org.opencontainers.image.title="Utilities - Configuration" \
	org.opencontainers.image.description="Container to initialize Configuration" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

COPY --from=builder /tpl /tpl

RUN set -eux \
    && apt-get update \
    && apt-get install -y xmlstarlet jq git bzip2 file patch unzip xz-utils \
    && rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash", "/tpl/copy.sh" ]