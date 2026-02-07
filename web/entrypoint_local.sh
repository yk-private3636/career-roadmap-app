#!/bin/sh

readonly APP_DIR='/var/www/html'
readonly PACKAGE_LIST_FILE_NAME="bun.lock"
readonly PACKAGE_LIST_HASH_FILE_NAME="bun.lock.sha256"

if [ ! -f ${APP_DIR}/${PACKAGE_LIST_HASH_FILE_NAME} ]; then
    echo > ${APP_DIR}/${PACKAGE_LIST_HASH_FILE_NAME}
fi

hash=$(cat ${APP_DIR}/${PACKAGE_LIST_FILE_NAME} | sha256sum | awk '{print $1}')

diff <(echo `cat ${APP_DIR}/${PACKAGE_LIST_HASH_FILE_NAME}`) <(echo ${hash})

if [ $? != 0 ]; then
    bun install --cwd ${APP_DIR}
    echo ${hash} | tr -d '\n' > ${APP_DIR}/${PACKAGE_LIST_HASH_FILE_NAME}
fi

docker-entrypoint.sh "$@"