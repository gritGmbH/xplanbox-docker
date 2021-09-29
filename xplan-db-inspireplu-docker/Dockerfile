ARG BUILD_TAG

FROM xplan-init:${BUILD_TAG} AS builder

RUN echo "Extract files from template" \
    && mkdir /xplan-workspaces \
    && tar -xvzf /tpl/srv-ws.tgz -C /xplan-workspaces

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

ENV POSTGRES_INITDB_ARGS=--encoding=UTF8
ENV POSTGRES_DB=inspireplu

COPY --from=builder /xplan-workspaces/xplan-manager-workspace/sql /xplan-db-sql
RUN ln -s /xplan-db-sql/inspireplu/04_create_inspireplu_schema.sql /docker-entrypoint-initdb.d/14_create_inspireplu_schema.sql \
	&& ln -s /xplan-db-sql/inspireplu/05_create_inspireplu_view.sql /docker-entrypoint-initdb.d/15_create_inspireplu_view.sql