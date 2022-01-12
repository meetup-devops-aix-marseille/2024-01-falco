#!/bin/bash

set -eu -o pipefail
set -x

echo "+ creating cluster"
scw --profile labs \
  k8s cluster create \
  name=labs version=1.22.3 cni=calico \
  pools.0.size=1 pools.0.node-type=DEV1_L pools.0.min-size=0 pools.0.max-size=3 \
  pools.0.autohealing=true pools.0.autoscaling=true pools.0.name=workers

sleep 120

echo "+ get cluster_id"
cluster_id=$(scw k8s cluster list --profile=labs -o json | jq -r '.[] |select(.name=="labs") |.id')

if [ -n "$cluster_id" ]; then
  echo "+ get kubeconfig"
  scw k8s kubeconfig get "${cluster_id}" --profile=labs > labs.kubeconfig
fi

echo "+ installing argocd"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml

exit 0
