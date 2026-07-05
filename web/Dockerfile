ARG BUN_BASE_IMAGE=oven/bun:1.3.11-alpine@sha256:7ed9f74c326d1c260abe247ac423ccbf5ac92af62bb442d515d1f92f21e8ea9b

FROM ${BUN_BASE_IMAGE} AS local

EXPOSE 3000
WORKDIR /var/www/html

COPY ./src/package.json ./src/bun.lock ./
RUN bun install --frozen-lockfile

CMD [ "bun", "run", "dev" ]
