[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7229864&assignment_repo_type=AssignmentRepo)
# SFU CMPT 756 Term Project

This is the repository for Team Cloudriven - CMPT 756 (Spring 2022) term project.

## The current architecture of our microservices
<!-- ![microserviced-based app diagram]() -->
<img src="https://user-images.githubusercontent.com/44685975/159101267-cfe1dabf-2752-41cd-a1b4-b075f8656edb.jpg" width="490" height="400">

---
## Table of contents

- [What's included](#whats-included)
- [Instantiate the template files](#instantiate-the-template-files)
- [Quick start](#quick-start)
- [Useful commands](#useful-commands)
- [Monitoring](#monitoring)
- [Manual scaling](#manual-scaling)
- [Gatling workload tests](#gatling-workload-tests)


## What's included

Be careful to only commit files without any secrets (AWS keys). 
```
├── ./cluster
```

The core of the microservices.
```
├── ./db
├── ./s1
├── ./s2
│   ├── ./s2/test
│   ├── ./s2/v1
│   └── ./s2/v2
├── ./s3
```

`results` and `target` need to be created but they are ephemeral and do not need to be saved/committed.
```
├── ./gatling
│   ├── ./gatling/resources
│   ├── ./gatling/results
│   ├── ./gatling/simulations
│   └── ./gatling/target
```

A small job for loading DynamoDB with some fixtures.
```
├── ./loader
```

Logs files are saved here to reduce clutter.
```
├── ./logs
```

CLI for the Music service. At present, it is only useable for the Intel architecture.
```
├── ./mcli
```

Deprecated material for operating the API via Postman.
```
├── ./postman
```

AWS macros for the tool container. 
```
├── ./profiles
```

Reference material for istio and Prometheus.
```
├── ./reference
```

Assorted scripts that you can pick and choose from:
```
└── ./tools
```


## Instantiate the template files

Fill in the required values in the template variable file. These include things like your AWS keys, your GitHub signon, and other identifying information. See the comments in that file for details. Note that you will need to have installed Gatling (https://gatling.io/open-source/start-testing/) first, because you will be entering its path in `tpl-vars.txt`.

Once you have filled in all the details, run
~~~
$ make -f k8s-tpl.mak templates
~~~

:loudspeaker: **Note:**  The script will then generate makefiles personalized to the data that you entered in `clusters/tpl-vars.txt`.

:loudspeaker: **Note:** In order for the EKS cluster to pull container images from ghcr, You must have your github access token registered in "c756-exer/cluster/ghcr.io-token.txt".


## Quick start

To start the container, first run `tools/shell.sh`

- Start the cluster by running: 
~~~
/home/k8s# make init.mak
~~~

- Stop the cluster by running:
~~~
/home/k8s# make -f init.mak stop
~~~


## Useful commands

Build and push the docker images after making any updates to the services
~~~
/home/k8s# make -f init.mak docker
~~~

Rollout new deployments of all microservices
~~~
/home/k8s# make -f init.mak rollout
~~~

Fetch the external IP address
~~~
/home/k8s# make -f init.mak url
~~~

List the stack on the cloudformation
~~~
/home/k8s# make -f init.mak list-stack
~~~

Check that you have the necessary tables installed by running
~~~
$ aws dynamodb list-tables
~~~

Scan your AWS DynamoDB table and see the results
~~~
$ aws dynamodb scan --table-name <tablename>
~~~


## Monitoring

Retrieve the URL for Grafana
~~~
$ make -f k8s.mak grafana-url
User: admin
Password: prom-operator
~~~

Retrieve the URL for Prometheus
~~~
$ make -f k8s.mak prometheus-url
~~~

Retrieve the URL for Kiali
~~~
$ make -f k8s.mak kiali-url
~~~

You can also use:
~~~
/home/k8s# make -f init.mak monitoring-url
~~~


## Manual scaling

#### Change the number of nodes in the cluster
- Example of changing the number of nodes to 3, the minimum number of nodes to 2, and the maximum number of nodes to 4:
~~~
$ make -f scale.mak nodes nodes=3 nodes-min=2 nodes-max=4
~~~

- Example of setting the number of replicas for the db microservice from 1 to 3:
~~~
$ make -f scale.mak db c_r=1 r=3
~~~

Please use the help command to get more information about other functions:
~~~
$ make -f scale.mak help
~~~


## Gatling workload tests

The workload.mak is built to create automation for analyzing the workload for the user and music services. And the workload defines by the number_user.

- Example of creating a workload for user (s1) service:
~~~
make -f workload.mak user number_user=5
~~~
- Example of creating a workload for music (s2) service:
~~~
make -f workload.mak music number_user=5
~~~
- Example of creating a workload for Playlist (s3) service:
~~~
make -f workload.mak playlist number_user=5
~~~

The command to kill all the Gatling workload
~~~
make -f workload.mak stop
~~~