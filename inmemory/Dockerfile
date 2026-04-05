ARG REDIS_BASE_IMAGE=redis:8.6.2-alpine3.23@sha256:81b6f81d6a6c5b9019231a2e8eb10085e3a139a34f833dcc965a8a959b040b72

FROM ${REDIS_BASE_IMAGE} AS local

COPY ./conf/redis.conf /etc/redis/redis.conf

CMD [ "redis-server", "/etc/redis/redis.conf" ]