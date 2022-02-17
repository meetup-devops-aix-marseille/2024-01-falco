# Falco

## usage

### create a scaleway labs cluster

```sh
./up.sh
```

**NOTE**: as the time of writting there is an issue open for missing latest falco kernel modules for Ubuntu version used by Scaleway. So i switched back to digital ocean for the lab but i'm sure it's a matter of days.

### apply manifests

- Register a webhook endpoint at https://webhook.site/ and edit `3_falco_app.yaml` (the created endpoints are only valid a few hours)

```sh
cd apps
./setup.sh
```

### grafana / prometheus configuration

```sh
kubectl port-forward -n monitoring svc/grafana 8081:80 >/dev/null 2>&1 &
kubectl -n monitoring get secrets grafana -o json | jq -r '.data."admin-password"' | base64 -d
open "http://localhost:8081/"
```

- Configure a new prometheus datasource to http://prometheus-k8s:9090/
- Grfana dashboard for falco is here : https://grafana.com/grafana/dashboards/11914

### test it

```sh
kubectl port-forward -n falco svc/falco-falcosidekick-ui 8080:2802 >/dev/null 2>&1 &
open "http://localhost:8080/ui/#/"
kubectl -n default run debug --image nginx
kubectl exec -it debug -- bash
mknod /dev/rien c 1 3
exit
kubectl -n default delete pod debug
```

```sh
apt update
apt install cowsay
echo 'Salut !' | /usr/games/cowsay
```

Alerts will go:

- in the falco-sidekick-ui dashboard (http://localhost:8080/ui/#/)
- grafana (http://localhost:8081/)
- in http://webook.site (under you registred endpoint)

# clean everything

```sh
./down.sh
```
