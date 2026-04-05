ARG TERRAFORM_BASE_IMAGE=hashicorp/terraform:1.14.8@sha256:42ecfb253183ec823646dd7859c5652039669409b44daa72abf57112e622849a

FROM ${TERRAFORM_BASE_IMAGE} AS local

WORKDIR /home/infra/src/envs

RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*

RUN cp -r /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk del tzdata

RUN adduser -D infra

# USER infra

ENTRYPOINT [ "tail", "-f", "/dev/null" ]