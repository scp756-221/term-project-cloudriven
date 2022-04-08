
.PHONY: db s1 s2

NGROUP=worker-nodes
REGION=us-west-2
NS=c756ns
CLUSTER_NAME=aws756
KVER=1.21

help:
	@echo ""
	@echo "ESK worker nodes automation functions:"
	@echo "	add-newType-nodes => Example: make -f scale.mak node-type=t3.large nodes=2 nodes-min=4 nodes-max=6"
	@echo "	add-nodes         => Example: make -f scale.mak add-nodes nodes=2 nodes-min=4 nodes-max=6"
	@echo ""
	@echo "k8s automation functions:"
	@echo "	db                => Example: make -f scale.mak db c_r=1 r=2"
	@echo "	s1                => Example: make -f scale.mak s1 c_r=1 r=2"
	@echo "	s2                => Example: make -f scale.mak s2 c_r=1 r=2"
	@echo "	s3                => Example: make -f scale.mak s3 c_r=1 r=2"
	@echo ""
	@echo "DynamoDB autimation functions:"
	@echo "	db-create-tables  		=> Example: make -f scale.mak db-create-tables"
	@echo "	db-delete-tables  		=> Example: make -f scale.mak db-delete-tables"
	@echo "	db-list-table     		=> Example: make -f scale.mak db-list-table"
	@echo "	db-describe-table 		=> Example: make -f scale.mak db-describe-table table-name=Music-bagherireza"
	@echo "	db-set-table-throughput		=> Example: make -f scale.mak db-set-table-throughput table-name=Music-bagherireza ReadCapacityUnits=10 WriteCapacityUnits=10"
####################################################################################################################
########################################### ESK worker nodes automation ############################################
####################################################################################################################

# adding new type of node in cluster, type of machien in each name-group should be homogenouse therefore when we need to add new type of machine we need to create the new name-group
check-add-newType-nodes:
	@if test "$(node-type)" = "" ; then \
		echo "node-type not set"; \
		@echo "Example: make -f scale.mak add-newType-nodes node-type=t3.large nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi
	@if test "$(nodes)" = "" ; then \
		echo "nodes not set"; \
		@echo "Example: make -f scale.mak add-newType-nodes node-type=t3.large nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi
	@if test "$(nodes-min)" = "" ; then \
		echo "nodes-min not set"; \
		@echo "Example: make -f scale.mak add-newType-nodes node-type=t3.large nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi
	@if test "$(nodes-max)" = "" ; then \
		echo "nodes-max not set"; \
		@echo "Example: make -f scale.mak add-newType-nodes node-type=t3.large nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi

add-newType-nodes:check-add-newType-nodes
	eksctl create cluster --name aws756 --version 1.21 --region us-west-2 --nodegroup-name worker-nodes-new --node-type $(node-type) --nodes=$(nodes) --nodes-min=$(nodes-min) --nodes-max=$(nodes-max) --managed | tee logs/eks-start.log

# set the number of node in the cluster
check-add-nodes:
	
	@if test "$(nodes)" = "" ; then \
		echo "nodes not set"; \
		@echo "Example: make -f scale.mak add-nodes nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi
	@if test "$(nodes-min)" = "" ; then \
		echo "nodes-min not set"; \
		@echo "Example: make -f scale.mak add-nodes nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi
	@if test "$(nodes-max)" = "" ; then \
		echo "nodes-max not set"; \
		@echo "Example: make -f scale.mak add-nodes nodes=2 nodes-min=4 nodes-max=6";\
		@exit 1;\
	fi

add-nodes:check-add-nodes
	eksctl scale nodegroup --name=worker-nodes --cluster=aws756 --nodes=$(nodes) --nodes-min=$(nodes-min) --nodes-max=$(nodes-max)


####################################################################################################################
################################################# k8s automation ###################################################
####################################################################################################################


# set the number of replica for db microservice
check-db-replicas-parameters:
	
	@if test "$(c_r)" = "" ; then \
		echo "c_r not set"; \
		@echo "Example: make -f scale.mak db c_r=1 r=2";\
		@exit 1;\
	fi
	@if test "$(r)" = "" ; then \
		echo "r not set"; \
		@echo "Example: make -f scale.mak db c_r=1 r=2";\
		@exit 1;\
db:check-db-replicas-parameters
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756db

# set the number of replica for s1 microservice
check-s1-replicas-parameters:
	
	@if test "$(c_r)" = "" ; then \
		echo "c_r not set"; \
		@echo "Example: make -f scale.mak s1 c_r=1 r=2";\
		@exit 1;\
	fi
	@if test "$(r)" = "" ; then \
		echo "r not set"; \
		@echo "Example: make -f scale.mak s1 c_r=1 r=2";\
		@exit 1;\
s1:check-s1-replicas-parameters
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756s1

# set the number of replica for s2 microservice
check-s2-replicas-parameters:
	
	@if test "$(c_r)" = "" ; then \
		echo "c_r not set"; \
		@echo "Example: make -f scale.mak s2 c_r=1 r=2";\
		@exit 1;\
	fi
	@if test "$(r)" = "" ; then \
		echo "r not set"; \
		@echo "Example: make -f scale.mak s2 c_r=1 r=2";\
		@exit 1;\
s2:check-s2-replicas-parameters
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756s2-v1


# set the number of replica for s3 microservice
check-s3-replicas-parameters:
	
	@if test "$(c_r)" = "" ; then \
		echo "c_r not set"; \
		@echo "Example: make -f scale.mak s3 c_r=1 r=2";\
		@exit 1;\
	fi
	@if test "$(r)" = "" ; then \
		echo "r not set"; \
		@echo "Example: make -f scale.mak s3 c_r=1 r=2";\
		@exit 1;\
s3:check-s3-replicas-parameters
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756s3


####################################################################################################################
############################################### DynamoDB Autimation ################################################
####################################################################################################################

# list all the tables in dynamodb defined in the "cluster/cloudformationdynamodb.json"
db-create-tables:
	@aws cloudformation create-stack --stack-name aws756-createUserMusicTable --template-body file://cluster/cloudformationdynamodb.json 

# delete all the tables in dynamodb defined in the "cluster/cloudformationdynamodb.json"
db-delete-tables:
	@aws cloudformation delete-stack --stack-name aws756-createUserMusicTable

# list all table exist in dynamodb
db-list-table:
	@aws dynamodb list-tables

# describe the ReadCapacityUnits and WriteCapacityUnits of a specific table
check-db-describe-table:
	@echo "Example: make -f scale.mak db-describe-table table-name=Music-bagherireza"
	@if test "$(table-name)" = "" ; then \
		echo "table-name not set"; \
		@exit 1;\
	fi
	
	
db-describe-table:check-db-describe-table
	@aws dynamodb describe-table --table-name  $(table-name) --query "Table.[ProvisionedThroughput]"

# Set the capacity of the read and write from specific table

check-set-table-throughput:
	@echo "Example: make -f scale.mak db-set-setThroughput-table table-name=Music-bagherireza ReadCapacityUnits=10 WriteCapacityUnits=10"
	@if test "$(table-name)" = "" ; then \
		echo "table-name not set"; \
		@exit 1;\
	fi
	@if test "$(ReadCapacityUnits)" = "" ; then \
		echo "ReadCapacityUnits not set"; \
		@exit 1;\
	fi
	@if test "$(WriteCapacityUnits)" = "" ; then \
		echo "WriteCapacityUnits not set"; \
		@exit 1;\
	fi

db-set-table-throughput:check-set-table-throughput
	@aws dynamodb update-table --table-name $(table-name) --provisioned-throughput ReadCapacityUnits=$(ReadCapacityUnits),WriteCapacityUnits=$(WriteCapacityUnits)