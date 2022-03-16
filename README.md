[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7229864&assignment_repo_type=AssignmentRepo)
# tprj
Term Project repo

## Execution environemt comments
This repository is desinged and develop to run on the EKS (Elastic Kubernetes Service) of AWS.

---
## Creating the cluster

~~~
$ make -f eks.mak start
~~~

## Provision the cluster
Creating namespace and set it as the defualt.
~~~
$ kubectl create ns c756ns
$ kubectl config set-context --current --namespace=c756ns
~~~
Provision the Kubernetes
~~~
$ make -f k8s.mak provision
~~~

