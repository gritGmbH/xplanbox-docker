ARG BUILD_TAG

FROM xplan-init:${BUILD_TAG} AS builder

RUN echo "Extract files from template" \
    && mkdir /xplan-workspaces \
    && tar -xvzf /tpl/srv-ws.tgz -C /xplan-workspaces

FROM postgis/postgis:12-3.2-alpine

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

# Label not set:
# maintainer="..."
# org.opencontainers.image.vendor="..."
LABEL	org.opencontainers.image.title="xPlanBox Database" \
	org.opencontainers.image.description="xPlanBox - XPlanDB" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV POSTGRES_DB=xplanbox

COPY --from=builder /xplan-workspaces/xplan-manager-workspace/sql /xplan-db-sql
COPY 99_init_xplandb.sh /docker-entrypoint-initdb.d/99_init_xplandb.sh