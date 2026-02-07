ARG BASE_IMAGE=oven/bun:1.3.8-alpine

FROM $BASE_IMAGE AS local

EXPOSE 3000
WORKDIR /var/www/html

COPY ./entrypoint_local.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "bun", "run", "dev" ]
