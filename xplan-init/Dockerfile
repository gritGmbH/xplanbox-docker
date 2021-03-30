FROM buildpack-deps:stable AS builder

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-releases/content
ARG XPLANBOX_VERSION

RUN echo "Downloading files from repo" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-inspireplu-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-inspireplu-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-manager-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-manager-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-validator-wms-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-validator-wms-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-wfs-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-wfs-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplansyn-wfs-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplansyn-wfs-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplansyn-wms-workspace.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplansyn-wms-workspace-default.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-validator-config.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-validator-config/${XPLANBOX_VERSION}/xplan-validator-config-${XPLANBOX_VERSION}.zip" \
	&& wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-manager-config.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-manager-config/${XPLANBOX_VERSION}/xplan-manager-config-${XPLANBOX_VERSION}-default.zip" \
	&& echo "Done"

COPY template /work
COPY config.sh /config.sh
COPY copy.sh /tpl/copy.sh

RUN echo "Extract and Cleanup" \
	&& mkdir -p /work/srv-ws  \
	&& unzip -d /work/srv-ws/xplan-wfs-workspace /xplan-wfs-workspace.zip \
	&& unzip -d /work/srv-ws/xplansyn-wfs-workspace /xplansyn-wfs-workspace.zip \
	&& unzip -d /work/srv-ws/xplansyn-wms-workspace /xplansyn-wms-workspace.zip \
	&& unzip -d /work/srv-ws/xplan-manager-workspace /xplan-manager-workspace.zip \
	&& mkdir -p /work/mng-cfg  \
	&& unzip -d /work/mng-cfg /xplan-manager-config.zip \
	&& mkdir -p /work/val-cfg  \
	&& unzip -d /work/val-cfg /xplan-validator-config.zip \
	&& mkdir -p /work/val-ws  \
	&& unzip -d /work/val-ws/xplan-validator-wms-workspace /xplan-validator-wms-workspace.zip \
	&& mkdir -p /work/plu-ws  \
	&& unzip -d /work/plu-ws/xplan-inspireplu-workspace /xplan-inspireplu-workspace.zip \
	&& bash /config.sh \
	&& cd /work/srv-ws && tar -cvzf /tpl/srv-ws.tgz . \
	&& cd /work/mng-cfg && tar -cvzf /tpl/mng-cfg.tgz . \
	&& cd /work/val-cfg && tar -cvzf /tpl/val-cfg.tgz . \
	&& cd /work/val-ws && tar -cvzf /tpl/val-ws.tgz . \
	&& cd /work/plu-ws && tar -cvzf /tpl/plu-ws.tgz . \
	&& echo "Done"

FROM bash:5.1

LABEL	maintainer="graphische Informationstechnik - Beratungsgesellschaft mbH <info@grit.de>" \
	org.opencontainers.image.title="deegree-core WMS/WFS mit Security" \
	org.opencontainers.image.description="deegree Enterprise Edition - Init Empty Config" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

COPY --from=builder /tpl /tpl

CMD [ "/usr/local/bin/bash", "/tpl/copy.sh" ]