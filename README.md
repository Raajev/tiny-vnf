# Tiny-vnf Helm Chart

* Installs a small vnf with web services.

## Get Repo Info

```console
helm repo add tiny-vnf https://raajev.github.io/tiny-vnf
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release raajev/tiny-vnf
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing Release to a new major version

To upgrade the my-release deployment:

```console
helm update my-release raajev/tiny-vnf
```
## Provides Following functions
* PVC based volume
* Configmap based volume
* Secret based volume
* Secondary Network
* Role & Role-binding
* Statefulset & Deployment
* Service & Headless Service
