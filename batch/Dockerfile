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


FROM ${BASE_IMAGE} AS build

ENV GOOS=linux
ENV GOARCH=amd64
WORKDIR /src

COPY ./src /src/

RUN go mod tidy

RUN go build -o main main.go


FROM alpine:3.23.3 AS prod

WORKDIR /src

COPY --from=build /src/main /src/main

RUN adduser -D batchuser && \
    chown -R batchuser:batchuser /src

RUN chmod +x /src/main

USER batchuser

ENTRYPOINT [ "./main" ]