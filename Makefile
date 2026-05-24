.PHONY: plan up down kubeconfig

plan:
	terraform plan -out=clusterplan

up:
	terraform apply clusterplan

down:
	terraform destroy

kubeconfig:
	scp azureuser@$(shell terraform output -raw master_public_ip):/home/azureuser/.kube/config ~/.kube/config
	sed -i 's/$(shell terraform output -raw master_private_ip)/$(shell terraform output -raw master_public_ip)/g' ~/.kube/config
