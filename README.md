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
## 1. Instantiate the template files

Fill in the required values in the template variable file
Copy the file `cluster/tpl-vars-blank.txt` to `cluster/tpl-vars.txt` and fill in all the required values in `tpl-vars.txt`. These include things like your AWS keys, your GitHub signon, and other identifying information. See the comments in that file for details. Note that you will need to have installed Gatling (https://gatling.io/open-source/start-testing/) first, because you will be entering its path in `tpl-vars.txt`.

Once you have filled in all the details, run
~~~
$ make -f k8s-tpl.mak templates
~~~
This will check that all the programs you will need have been installed and are in the search path. If any program is missing, install it before proceeding.

The script will then generate makefiles personalized to the data that you entered in `clusters/tpl-vars.txt`.

:loudspeaker: **Note:** This is the only time you will call `k8s-tpl.mak` directly. This creates all the non-templated files, such as `k8s.mak`. You will use the non-templated makefiles in all the remaining steps.


## Creating the cluster
~~~
make -f eks.mak start
~~~



## Provisioning the cluster
Creating namespace and set it as the defualt.
~~~
$ kubectl create ns c756ns
$ kubectl config set-context --current --namespace=c756ns
~~~
Provisioning the Kubernetes
~~~
$ make -f k8s.mak provision
~~~
