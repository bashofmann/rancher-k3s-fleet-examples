# Code examples for Talk about Multi-Cluster Kubernetes Management with Rancher, K3S and Fleet

## Installation steps

1. Setup infrastructure

Fill out `terraform-setup/terraform.tfvars` with aws and digital ocean credentials.

```
make step_01
```

2. Create 3 Node HA Cluster for Rancher

```
make step_02
```

3. Install cert-manager and Rancher

```
make step_03
```

4. Create 3 single-node downstream k3s clusters

```
make step_04
```

## Cleanup

To remove everyting

```
make destroy
```