.DEFAULT_GOAL := init

init:
	# Creating the cluster
	make -f eks.mak start

	# Provisioning the cluster
	# Creating namespace and set it as the defualt
	kubectl create ns c756ns
	kubectl config set-context --current --namespace=c756ns

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

moitoring-tools-url:
	make -f k8s.mak grafana-url
	echo "User: admin Password: prom-operator"
	make -f k8s.mak kiali-url

url:
	# Fetching the required external IP address
	kubectl -n istio-system get service istio-ingressgateway | cut -c -140

stop:
	make -f eks.mak stop
