FROM buildpack-deps:stable AS builder

ARG DEE_REPO_USER
ARG DEE_REPO_PASS
ARG DEE_REPO_URL=http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-releases/content
ARG XPLANBOX_VERSION

# dp
# DEE_REPO_URL=http://192.168.100.206:8088
# XPLANBOX_VERSION=4.0.1

RUN echo "Downloading files from repo" \
    && wget --user=$DEE_REPO_USER --password=$DEE_REPO_PASS --progress=dot:giga -O /xplan-workspaces.zip "${DEE_REPO_URL}/de/latlon/product/xplanbox/xplan-workspaces/${XPLANBOX_VERSION}/xplan-workspaces-${XPLANBOX_VERSION}-xplan-manager-workspace-default.zip" \
	&& unzip -d /xplan-workspaces /xplan-workspaces.zip

FROM postgis/postgis:12-2.5-alpine

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

LABEL	maintainer="graphische Informationstechnik - Beratungsgesellschaft mbH <info@grit.de>" \
	org.opencontainers.image.title="deegree-core WMS/WFS mit Security" \
	org.opencontainers.image.description="deegree Enterprise Edition - xPlanBox - XPlanDB" \
	org.opencontainers.image.vendor="graphische Informationstechnik - Beratungsgesellschaft mbH" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://www.deegree-enterprise.de/" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV POSTGRES_DB=xplanbox

COPY --from=builder /xplan-workspaces/sql /xplan-db-sql
COPY 99_init_xplandb.sh /docker-entrypoint-initdb.d/99_init_xplandb.sh