.DEFAULT_GOAL := init

init: 
	# Initalizing the template files
	make -f k8s.mak templates

	# Creating the cluster
	make -f eks.mak start

	# Creating namespace and set it as the defualt
	kubectl create ns c756ns
	kubectl config set-context --current --namespace=c756ns

	# Setting context to latest EKS cluster
	# make -f eks.mak cd

	# Provisioning the Kubernetes
	make -f k8s.mak provision

	# Loading the database
	make -f k8s.mak loader

docker:
	# Building and pushing the docker images after making any updates
	make -f k8s.mak cri

rollout: 
	# Rollout new deployments of all microservices
	make -f k8s.mak rollout

monitor:
	# Executing Kiali
	make -f k8s.mak kiali

url:
	# Fetching the required external IP address
	kubectl -n istio-system get service istio-ingressgateway | cut -c -140

	# Fetching the urls for monitoring services
	make -f k8s.mak kiali-url

stop:
	# Cleaning up the DB tables
	make -f k8s.mak dynamodb-clean

	# Cleaning up the microservices and everything else in application NS
	make -f k8s.mak scratch

	# Deleting the EKS cluster
	make -f eks.mak stop
