ARG BUILD_TAG

FROM xplan-init:${BUILD_TAG} AS builder

RUN echo "Extract files from template" \
    && mkdir /xplan-workspaces \
    && tar -xvzf /tpl/srv-ws.tgz -C /xplan-workspaces

FROM postgis/postgis:14-3.4

ARG XPLANBOX_BUILD
ARG XPLANBOX_VERSION
ARG GIT_COMMIT=0

# Label not set:
# maintainer="..."
# org.opencontainers.image.vendor="..."
LABEL	org.opencontainers.image.title="xPlanBox PLU Database" \
	org.opencontainers.image.description="xPlanBox - XPlanInspirePluDB" \
	org.opencontainers.image.created="${XPLANBOX_BUILD}" \
	org.opencontainers.image.url="https://gitlab.opencode.de/diplanung/ozgxplanung" \
	org.opencontainers.image.version="${XPLANBOX_VERSION}" \
	org.opencontainers.image.revision="${GIT_COMMIT}"

ENV POSTGRES_INITDB_ARGS=--encoding=UTF8
ENV POSTGRES_DB=inspireplu

COPY --from=builder /xplan-workspaces/xplan-manager-workspace/sql /xplan-db-sql
RUN ln -s /xplan-db-sql/inspireplu/01_create_inspireplu_schema.sql /docker-entrypoint-initdb.d/14_create_inspireplu_schema.sql \
	&& ln -s /xplan-db-sql/inspireplu/02_create_inspireplu_view.sql /docker-entrypoint-initdb.d/15_create_inspireplu_view.sql