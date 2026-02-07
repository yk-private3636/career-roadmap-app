#!/bin/sh

rm -f ./tmp/build-errors.log

go mod tidy && \
go mod download

exec sh -c "$@"