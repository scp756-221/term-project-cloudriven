[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7229864&assignment_repo_type=AssignmentRepo)
# SFU CMPT 756 Term Project

This is the repo for CMPT 756 (Spring 2022) term project.

<!-- 
## Execution environemt comments
This repository is desinged and develop to run on the EKS (Elastic Kubernetes Service) of AWS.
--- -->

## The current architecture of our microservices
![microserviced-based app diagram](https://user-images.githubusercontent.com/44685975/159101267-cfe1dabf-2752-41cd-a1b4-b075f8656edb.jpg)

---
## Instantiate the template files

Fill in the required values in the template variable file. These include things like your AWS keys, your GitHub signon, and other identifying information. See the comments in that file for details. Note that you will need to have installed Gatling (https://gatling.io/open-source/start-testing/) first, because you will be entering its path in `tpl-vars.txt`.

Once you have filled in all the details, run
~~~
$ make -f k8s-tpl.mak templates
~~~

:loudspeaker: **Note:**  The script will then generate makefiles personalized to the data that you entered in `clusters/tpl-vars.txt`.

## Ensure AWS DynamoDB is accessible/running

Check that you have the necessary tables installed by running
~~~
$ aws dynamodb list-tables
~~~

## Ensure AWS DynamoDB is accessible/running

Check that you have the necessary tables installed by running
~~~
$ aws dynamodb list-tables
~~~

## Prepare the cluster environment

To start the container, first run `tools/shell.sh` and then instantiate makefile for setup of an a AWS EKS cluster
~~~
/home/k8s# make init.mak
~~~

The command above includes the following:

#### Creating the cluster
~~~
/home/k8s# make -f eks.mak start
~~~

#### Provisioning the cluster
Creating namespace and set it as the defualt.
~~~
/home/k8s# kubectl create ns c756ns
/home/k8s# kubectl config set-context --current --namespace=c756ns
~~~
Provisioning the Kubernetes
~~~
/home/k8s# make -f k8s.mak provision
~~~
starting kiali
~~~
/home/k8s# make -f k8s.mak kiali
~~~

## Delete your AWS EKS cluster

The following command will delete the EKS cluster
~~~
/home/k8s# make -f init.mak stop
~~~

#### Some other useful commands are:
Listing all EKS clusters and their node groups:
~~~
make -f eks.mak ls 
~~~
Check on the status of your EKS cluster:
~~~
make -f eks.mak status
~~~

## Gatling workload tests
The workload.mak is built to create automation for analyzing the workload for the user and music services.  
Example of creating a workload for user service:
~~~
make -f workload.mak user number_user=5
~~~
Example of creating a workload for music service:
~~~
make -f workload.mak music number_user=5
~~~
The workload defines by the number_user.

The command to kill all the gatling workload
~~~
make -f workload.mak stop
~~~
## Common URLs 
#### retrieve the URL for Grafana
~~~
$ make -f k8s.mak grafana-url
~~~
User: admin
Password: prom-operator

#### retrieve the URL for Prometheus
~~~
$ make -f k8s.mak prometheus-url
~~~

#### retrieve the URL for Kiali
~~~
$ make -f k8s.mak kiali-url
~~~

