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

pei "kubectl delete --wait -n argocd application falco || true"
pei "kubectl delete --wait -n argocd application falco-talon || true"
pei "kubectl delete --wait ns falco || true"
