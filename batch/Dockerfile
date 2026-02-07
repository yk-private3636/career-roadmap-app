ARG BASE_IMAGE=golang:1.25.6-alpine

FROM ${BASE_IMAGE} AS local

WORKDIR /src

RUN go install github.com/air-verse/air@v1.61.7
RUN go install github.com/google/wire/cmd/wire@latest
RUN go install go.uber.org/mock/mockgen@latest

COPY ./entrypoint_local.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "air" ]