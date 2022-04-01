
.PHONY: db s1 s2

# set the number of node in the cluster
nodes:
	eksctl scale nodegroup --name=worker-nodes --cluster=aws756 --nodes=$(nodes) --nodes-min=$(nodes-min) --nodes-max=$(nodes-max)

# set the number of replica for db microservice
db:
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756db

# set the number of replica for s1 microservice
s1:
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756s1

# set the number of replica for s2 microservice
s2:
	kubectl scale --current-replicas=$(c_r) --replicas=$(r) deployment/cmpt756s2-v1


