
init:
	# Creating the cluster
	make -f eks.mak start

	# Provisioning the cluster
	# Creating namespace and set it as the defualt
	kubectl create ns c756ns
	kubectl config set-context --current --namespace=c756ns

	# Provisioning the Kubernetes
	make -f k8s.mak provision
	
	# Executing Kiali
	make -f k8s.mak kiali


