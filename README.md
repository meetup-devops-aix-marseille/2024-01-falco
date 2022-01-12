# falco

## usage

### create a scaleway labs cluster

```sh
./up.sh
```

### apply manifests

#### Prometheus

```sh
cd apps/1_prometheus
./setup.sh
cd -
```

#### Other apps

```sh
kubectl apply -f apps
```
