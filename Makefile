SHELL := /bin/bash

K3S_TOKEN="VA87qPxet2SB8BDuLPWfU2xnPUSoETYF"

export KUBECONFIG=kubeconfig

destroy:
	cd terraform-setup && terraform destroy -auto-approve && rm terraform.tfstate terraform.tfstate.backup

all: step_01 step_02 step_03 step_04

step_01:
	echo "Creating infrastructure"
	cd terraform-setup && terraform init && terraform apply -auto-approve

step_02:
	echo "Creating k3s cluster on x86 vms 0,1,2"
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP0} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_KUBECONFIG_MODE=644 K3S_CLUSTER_INIT=1 sh -"
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP1} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_URL=https://$${IP0}:6443 sh - "
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP2} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_URL=https://$${IP0}:6443 sh - "
	source get_env.sh && scp -o StrictHostKeyChecking=no ec2-user@$${IP0}:/etc/rancher/k3s/k3s.yaml kubeconfig
	source get_env.sh && sed -i "s/127.0.0.1/$${IP0}/g" kubeconfig

print_step_02:
	echo "Creating k3s cluster on x86 vms 0,1,2"
	source get_env.sh && echo "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_KUBECONFIG_MODE=644 K3S_CLUSTER_INIT=1 sh -"
	source get_env.sh && echo "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_URL=https://$${IP0}:6443 sh - "
	source get_env.sh && echo "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 INSTALL_K3S_EXEC='server' K3S_TOKEN=$(K3S_TOKEN) K3S_URL=https://$${IP0}:6443 sh - "

kubeconfigs:
	source get_env.sh && scp -o StrictHostKeyChecking=no ec2-user@$${IP0}:/etc/rancher/k3s/k3s.yaml kubeconfig
	source get_env.sh && sed -i "s/127.0.0.1/$${IP0}/g" kubeconfig
	touch kubeconfig_cluster_one
	touch kubeconfig_cluster_two
	touch kubeconfig_cluster_three

step_03:
	echo "Installing cert-manager and Rancher"
	helm repo update
	helm upgrade --install \
		  cert-manager jetstack/cert-manager \
		  --namespace cert-manager \
		  --version v1.7.1 --create-namespace --set installCRDs=true
	kubectl rollout status deployment -n cert-manager cert-manager
	kubectl rollout status deployment -n cert-manager cert-manager-webhook
	helm upgrade --install rancher rancher-latest/rancher \
	  --namespace cattle-system \
	  --version 2.6.4 \
	  --set hostname=rancher-demo.plgrnd.be --create-namespace
	kubectl rollout status deployment -n cattle-system rancher
	kubectl -n cattle-system wait --for=condition=ready certificate/tls-rancher-ingress

step_04:
	source get_env.sh
	echo "Creating downstream k3s clusters"
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP3} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 K3S_KUBECONFIG_MODE=644 sh -"
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP4} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 K3S_KUBECONFIG_MODE=644 sh -"
	source get_env.sh && ssh -o StrictHostKeyChecking=no ec2-user@$${IP5} "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21 K3S_KUBECONFIG_MODE=644 sh -"
	touch kubeconfig_cluster_one
	touch kubeconfig_cluster_two
	touch kubeconfig_cluster_three