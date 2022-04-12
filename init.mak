.DEFAULT_GOAL := init

init: 
	# Initalizing the template files
	make -f k8s.mak templates

	# Creating the cluster
	make -f eks.mak start

	# Setting context to latest EKS cluster
	# make -f eks.mak cd

	# Creating namespace and set it as the defualt
	kubectl create ns c756ns
	kubectl config set-context --current --namespace=c756ns

	# Provisioning the Kubernetes
	make -f k8s.mak provision

	# Loading the database
	make -f k8s.mak loader

docker:
	# Building and pushing the docker images after making any updates
	make -f k8s.mak cri

rollout: 
	# Rolling out new deployments of all microservices
	make -f k8s.mak rollout
	make -f api.mak ls

kiali:
	# Executing Kiali
	make -f k8s.mak kiali

monitoring-url:
	echo "Grafana url:"
	@make -f k8s.mak grafana-url
	@echo "User: admin Password: prom-operator"
	@echo ""
	@echo "Kiali url:"
	@make -f k8s.mak kiali-url

url:
	# Fetching the required external IP address
	kubectl -n istio-system get service istio-ingressgateway | cut -c -140

stop:
	# Cleaning up the DB tables
	make -f k8s.mak dynamodb-clean

	# Cleaning up the microservices and everything else in application NS
	make -f k8s.mak scratch

	# Deleting the EKS cluster
	make -f eks.mak stop

###############################################################################
################################  Troubleshooting  ############################
###############################################################################

# with help of this command we can list the all stack on the cloudformation
list-stack:
	@aws cloudformation list-stacks

# all the status are listed in below link:
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-describing-stacks.html

#list-stack-filter:
#	@aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE

#deleting the stack manually
check-delete-stack:
	
	@if test "$(stack-name)" = "" ; then \
		echo "stack-name not set"; \
		@exit 1;\
	fi
delete-stack:check-delete-stack
	@aws cloudformation delete-stack --stack-name $(stack-name)

