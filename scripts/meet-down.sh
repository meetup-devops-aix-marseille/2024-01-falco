#!/bin/bash

set -eu -o pipefail

SCRIPTDIR="$(realpath $(dirname $0))"
ROOTDIR="$(realpath "${SCRIPTDIR}/..")"
export DIRENV_LOG_FORMAT=""

cd "${ROOTDIR}"
# shellcheck disable=SC1091
source ./scripts/demo-magic.sh

clear
direnv allow .envrc
eval "$(direnv export bash)"

#### start the magic ####


pe "kubectl delete --wait -f ./apps/wave-2"
