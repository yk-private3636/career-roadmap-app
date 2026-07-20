ARG TERRAFORM_BASE_IMAGE=hashicorp/terraform:1.14.8@sha256:42ecfb253183ec823646dd7859c5652039669409b44daa72abf57112e622849a
ARG KUSTOMIZE_BASE_IMAGE=registry.k8s.io/kustomize/kustomize:v5.0.0@sha256:cb63324de6709a018b4e3f0a45611e37752b04f56f403cc29a277c325ac3f602

FROM ${KUSTOMIZE_BASE_IMAGE} AS kustomize


FROM ${TERRAFORM_BASE_IMAGE} AS local

WORKDIR /home/infra/src/envs

RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*

RUN cp -r /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk del tzdata

COPY --from=kustomize /app/kustomize /usr/local/bin/kustomize
RUN chmod +x /usr/local/bin/kustomize

RUN adduser -u 1000 -s /bin/sh --disabled-password --gecos "" infra
USER infra

ENTRYPOINT [ "tail", "-f", "/dev/null" ]