
.PHONY: db s1 s2

# set the number of node in the cluster
nodes:
	eksctl scale nodegroup --name=worker-nodes --cluster=aws756 --nodes=$(nodes) --nodes-min=$(nodes-min) --nodes-max=$(nodes-max)

# set the number of replica for db microservice
db:
	kubectl scale --current-replicas=$(c_r_s2) --replicas=$(r_s2) deployment/cmpt756db

# set the number of replica for s1 microservice
s1:
	kubectl scale --current-replicas=$(c_r_s2) --replicas=$(r_s2) deployment/cmpt756s1

# set the number of replica for s2 microservice
s2:
	kubectl scale --current-replicas=$(c_r_s2) --replicas=$(r_s2) deployment/cmpt756s2-v1

#list all the nodes in AWS
get-nodes:
	#show the nodes in the cluster
	kubectl get nodes -o wide

# this command show all the details information about node by givinng node name, node name can get by get-nodes command
node-describe:
	kubectl describe node/$(node_name)

# list the all the deployments
get-deployment:
	kubectl get deployment