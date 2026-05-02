#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

echo "🚀 Setting up career-roadmap-app environment..."

envSetup() {
    cp --update=none ${1}/.env.example ${1}/.env
}

infraSetup() {
    cp --update=none ${1}/.env.example ${1}/.env
    for dir in $(ls -d ${1}/src/envs/*/); do
        cp --update=none ${1}/terraform.tfvars.example ${dir}/terraform.tfvars
    done
}

readonly SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly API_DIR=${SCRIPT_DIR}/api
readonly JOB_DIR=${SCRIPT_DIR}/job
readonly BATCH_DIR=${SCRIPT_DIR}/batch
readonly OBSERVABILITY_DIR=${SCRIPT_DIR}/observability
readonly INFRA_DIR=${SCRIPT_DIR}/infra

for dir in "${API_DIR}" "${JOB_DIR}" "${BATCH_DIR}" "${OBSERVABILITY_DIR}"; do
    envSetup "${dir}"
done
infraSetup "${INFRA_DIR}"

echo "✅ career-roadmap-app environment setup complete."
exit 0
