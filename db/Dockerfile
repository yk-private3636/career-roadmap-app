ARG POSTGRES_BASE_IMAGE=postgres:18.3@sha256:a9abf4275f9e99bff8e6aed712b3b7dfec9cac1341bba01c1ffdfce9ff9fc34a

FROM ${POSTGRES_BASE_IMAGE} AS local

ENV TZ=Asia/Tokyo

COPY ./init/test_schema_setup.sql /docker-entrypoint-initdb.d