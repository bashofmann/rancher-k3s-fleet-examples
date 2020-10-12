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

### Configure Rancher

Go to https://rancher-demo.plgrnd.be/login and set up admin password and server url.

### Add 3 downstream clusters to Rancher

"Add Cluster" -> "Register an existing Kubernetes cluster" => "Other Cluster"

Add "group" label with values "amd" and "arm".

To register every cluster run

```
./run_on.sh [3-5] kubectl apply ....
```

Wait until all clusters are read.

### Configure Fleet

Go to "Cluster Explorer" of local cluster -> "Continuous Delivery"

Add arm and amd Cluster Groups matching the cluster labels from above in "fleet-default".

## Use fleet

Get Download Kubeconfig from all clusters.

Commands to watch clusters

```
watch kubectl --kubeconfig kubeconfig_cluster_one --insecure-skip-tls-verify get nodes,pods -A
watch kubectl --kubeconfig kubeconfig_cluster_two --insecure-skip-tls-verify get nodes,pods -A
watch kubectl --kubeconfig kubeconfig_cluster_three --insecure-skip-tls-verify get nodes,pods -A
```

### Upgrade all clusters

Add Git repo to deploy system-upgrade-controller
Repo: https://github.com/rancher/system-upgrade-controller
Path: manifests
All clusters.

Add Git Repo to deploy upgrade Plan
Repo: https://github.com/bashofmann/rancher-k3s-fleet-examples
Path: fleet-upgrades
Only amd clusters

* Deploy upgrade plan

Add Git Repo to deploy rest
Repo: https://github.com/bashofmann/rancher-k3s-fleet-examples
Path: fleet-examples
All clusters

### Deploy applications

* Add hello-world example
* Open webapp on nodeports
* Update hello-world example with overlays
* Show that on arm cluster the color changed
* Deploy netdata
* Change gitrepo cluster selector

## Cleanup

To remove everything

```
make destroy
```