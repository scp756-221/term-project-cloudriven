.DEFAULT_GOAL := init

init:
	# Creating the cluster
	make -f eks.mak start

	# Provisioning the cluster
	# Creating namespace and set it as the defualt
	kubectl create ns c756ns
	kubectl config set-context --current --namespace=c756ns

	# Setting context to latest EKS cluster
	make -f eks.mak cd

	# Provisioning the Kubernetes
	make -f k8s.mak provision

	# Loading the database
	make -f k8s.mak loader

docker:
	# Building the docker images after making any updates
	make -f k8s.mak cri

monitor:
	# Executing Kiali
	make -f k8s.mak kiali

url:
	# Fetching the required external IP address
	kubectl -n istio-system get service istio-ingressgateway | cut -c -140

stop:
	# Cleaning up the DB tables
	make -f k8s.mak dynamodb-clean
	# Deleting the EKS cluster
	make -f eks.mak stop
