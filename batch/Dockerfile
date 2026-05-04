ARG GO_BASE_IMAGE=golang:1.25.8-alpine3.23@sha256:8e02eb337d9e0ea459e041f1ee5eece41cbb61f1d83e7d883a3e2fb4862063fa
ARG PROD_BASE_IMAGE=alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
 
FROM ${GO_BASE_IMAGE} AS local
 
ENV GOOS=linux GOARCH=amd64
WORKDIR /app
 
RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*
 
RUN cp -r /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk del tzdata
 
RUN go install github.com/air-verse/air@v1.61.7
RUN go install github.com/google/wire/cmd/wire@v0.7.0
RUN go install go.uber.org/mock/mockgen@v0.6.0
RUN go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.11.4

ENTRYPOINT [ "tail", "-f", "/dev/null" ]
 
 
FROM ${GO_BASE_IMAGE} AS build
 
ARG BUILD_TARGET
ENV GOOS=linux GOARCH=amd64
WORKDIR /src/${BUILD_TARGET}
 
COPY ./src/${BUILD_TARGET}/go.mod ./
COPY ./src/${BUILD_TARGET}/go.sum ./
 
RUN go mod download
 
COPY ./src/${BUILD_TARGET}/* ./
 
RUN go build -a -o ./main
 
 
FROM ${PROD_BASE_IMAGE} AS prod
 
ARG BUILD_TARGET
WORKDIR /app
 
RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*
 
RUN cp -r /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk del tzdata
 
COPY --from=build /src/${BUILD_TARGET}/main ./
 
RUN chmod +x ./main
RUN adduser -D appuser
RUN chown -R appuser:appuser /app
 
USER appuser
 
ENTRYPOINT [ "./main" ]