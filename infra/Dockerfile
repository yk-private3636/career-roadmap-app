ARG BASE_IMAGE=hashicorp/terraform:1.14.4

FROM ${BASE_IMAGE} AS local

WORKDIR /home/infra/src/envs

RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/* && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    ls -1 /usr/share/zoneinfo/ | grep -vx Asia | xargs -I {} rm -r /usr/share/zoneinfo/{}

RUN adduser -D infra
RUN chown -R infra:infra /home/infra

USER infra

ENTRYPOINT [ "tail", "-f", "/dev/null" ]