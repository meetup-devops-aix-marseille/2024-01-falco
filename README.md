# meetup devops aix-marseille - falco

## requirements

- a k8s cluster
- argocd installed
- Register a webhook endpoint at https://webhook.site/ and edit `apps/wave-2/1_falco_app.yaml` (the created endpoints are only valid a few hours)
- pv for demo-magic to work (`brew install pv`)

## bootstrap

```sh
./scripts/bootstrap.sh
```

- note the ingress controller public IP and replace it in the manifests in case you don't want to mess with DNS
- replace the webhook.site endpoint in the manifests

## usage

```sh
./scripts/meet-up.sh
```

## cleaning

```sh
./scripts/meet-down.sh
```
