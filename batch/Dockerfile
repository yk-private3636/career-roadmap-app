ARG GO_BASE_IMAGE=golang:1.25.8-alpine3.23@sha256:8e02eb337d9e0ea459e041f1ee5eece41cbb61f1d83e7d883a3e2fb4862063fa
ARG PROD_BASE_IMAGE=alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

FROM ${GO_BASE_IMAGE} AS local

WORKDIR /src

RUN go install github.com/air-verse/air@v1.61.7
RUN go install github.com/google/wire/cmd/wire@v0.7.0
RUN go install go.uber.org/mock/mockgen@v0.6.0
RUN go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.11.4

COPY ./entrypoint_local.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "air" ]


FROM ${GO_BASE_IMAGE} AS build

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0
WORKDIR /src

COPY ./src/go.mod /src/go.mod
COPY ./src/go.sum /src/go.sum

RUN go mod download

COPY ./src /src/

RUN go build -o main main.go


FROM ${PROD_BASE_IMAGE} AS prod

WORKDIR /src

COPY --from=build /src/main /src/main

RUN adduser -D batchuser && \
    chown -R batchuser:batchuser /src

RUN chmod +x /src/main

USER batchuser

ENTRYPOINT [ "./main" ]