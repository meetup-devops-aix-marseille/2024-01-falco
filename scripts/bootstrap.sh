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

# up the cluster
pe "kubectl config get-contexts"
pe "kubectl get nodes"
wait
pe "kubectl create ns argocd || true"
pe "kubectl apply --wait -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
pe "kubectl wait --for=condition=available --timeout=600s -n argocd deployment/argocd-server"

# deploy waves
pe "kubectl apply --wait -f ./apps/wave-0"
p "You have to edit the urls of the ingress for grafana / falco-sidekick / falco-talon"
pe "kubectl get -n ingress-nginx svc ingress-nginx-controller"

pe "kubectl apply --wait -f ./apps/wave-1"
