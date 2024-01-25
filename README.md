# meetup devops aix-marseille - falco

## requirements

- a k8s cluster
- argocd installed

## usage

### apply manifests

- Register a webhook endpoint at https://webhook.site/ and edit `apps/wave-2/1_falco_app.yaml` (the created endpoints are only valid a few hours)

### test it

```sh
kubectl -n default run debug --image nginx
kubectl exec -it debug -- bash
mknod /dev/rien c 1 3
exit
kubectl -n default delete pod debug
```

```sh
apt update; apt install -yqq cowsay; /usr/games/cowsay meuuuhhhhhhh
```

Alerts will go:

- in the falco-sidekick-ui dashboard (http://localhost:8080/ui/#/)
- grafana (http://localhost:8081/)
- in http://webook.site (under you registred endpoint)

## falco-talon

```yaml
data:
  rules.yaml: |
    - action: Terminate Pod
      actionner: kubernetes:terminate
      parameters:
        ignore_daemonsets: true
        ignore_statefulsets: true
        grace_period_seconds: 10

    - action: Disable outbound connections
      actionner: kubernetes:networkpolicy
      parameters:
        allow:
          - "192.168.1.0/24"
          - "172.17.0.0/16"
          - "10.0.0.0/32"

    - action: Labelize Pod as Suspicious
      actionner: kubernetes:labelize
      parameters:
        labels:
          suspicious: true

    #### rules #######
    - rule: zarb-01
      match:
        rules:
          - Terminal shell in container
      actions:
        - action: Labelize Pod as Suspicious

    - rule: zarb-02
      match:
        rules:
          - Try to use cowsay in a container
        output_fields:
          - k8s.ns.name!=kube-system, k8s.ns.name!=falco
      actions:
        - action: Labelize Pod as Suspicious
        - action: Disable outbound connections
        - action: Terminate Pod
```
