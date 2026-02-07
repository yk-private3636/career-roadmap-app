ARG BASE_IMAGE=golang:1.25.6-alpine

FROM ${BASE_IMAGE} AS local

EXPOSE 8080
WORKDIR /src

RUN go install github.com/air-verse/air@v1.61.7
RUN go install github.com/parvez3019/go-swagger3@latest
RUN go install github.com/google/wire/cmd/wire@latest
RUN go install go.uber.org/mock/mockgen@latest
RUN apk update && \
apk add apache2-utils

COPY ./entrypoint_local.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "air" ]