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

# # falco + falcosidekick
pe "kubectl apply --wait -f ./apps/wave-2"
pe "kubectl apply --wait -f ./apps/wave-3"
pe "open https://$(kubectl -n falco get ing falcosidekick-ui -o jsonpath='{.spec.rules[0].host}')"
pe "kubectl run -n default test-01 --rm -it --image=debian:bullseye-slim --restart=Never -- bash"
p "You should see alerts in sideckick UI"

# falco + prometheus + grafana
p "You are using prometheus + grafana ?"
pe "open https://$(kubectl -n monitoring get ing prometheus-grafana -o jsonpath='{.spec.rules[0].host}')"

# falco + falco-talon
p "But wait ... what about remediation ?"
p "Here comes falco-talon !"
pe "kubectl apply --wait -f ./apps/wave-4"
p "Let's put some custom config for remediation"
pe "kubectl replace -n falco -f ./apps/falco-talon-custom-rules.yaml"
pe "kubectl rollout restart -n falco deployment falco-talon"
p "look carefully at the default namespace"
pe "kubectl run -n default test-02 --rm -it --image=debian:bullseye-slim --restart=Never -- bash"

# finish
p "!!! That's all folks !!!"
