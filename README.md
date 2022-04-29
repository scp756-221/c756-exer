# SFU CMPT 756 main project directory

This is the course repo for CMPT 756 (Spring 2023)

You will find resources for your assignments and term project here.


### 1. Instantiate the template files

#### Fill in the required values in the template variable file

Copy the file `cluster/tpl-vars-blank.txt` to `cluster/tpl-vars.txt`
and fill in all the required values in `tpl-vars.txt`.  These include
things like your AWS keys, your GitHub signon, and other identifying
information.  See the comments in that file for details. 

#### Instantiate the templates

Once you have filled in all the details, run:


~~~
$ ./1init.sh
~~~

or more directly:

~~~
$ make -f Makefile-tpl templates
~~~

This will check that all the programs you will need have been
installed and are in the search path.  If any program is missing,
install it before proceeding.

The script will then generate makefiles personalized to the data that
you entered in `clusters/tpl-vars.txt`.

**Note:** This is the *only* time you will call `Makefile-tpl`
directly. This creates all the non-templated files, such as
`Makefile`.  You will use the non-templated makefiles in all the
remaining steps.

### 2. Ensure AWS DynamoDB is accessible/running

Regardless of where your cluster will run, it uses AWS DynamoDB
for its backend database. Check that you have the necessary tables
installed by running

~~~
$ aws dynamodb list-tables
~~~

The resulting output should include tables `User-YourGitHubID` and `Music-YourGitHubID`.

----


### Reference

**Here is an annotated guide to the tree for this repo.**

NB: All files with a `-tpl` suffix are template and not useable without instantiation. Refer to `cluster/tpl-vars-blank.txt` for instruction on creating a `cluster/tpl-vars.txt`. Then use `1init.sh`  to generate a working `Makefile`.
```
├── ./1init.sh
├── ./Makefile-tpl
├── ./README.md
```

The CI material at `ci` and `.github/workflows` are presently designed for Assignment 7 and the course's operation. They're not fully realized. If you are ambitious or familiar with GitHub action, the one flow that may be _illustrative_ is `ci-to-dockerhub.yaml`.
```
├── ./.github
│   └── ./.github/workflows
│       ├── ./.github/workflows/ci-a1.yaml
│       ├── ./.github/workflows/ci-a2.yaml
│       ├── ./.github/workflows/ci-a3.yaml
│       ├── ./.github/workflows/ci-mk-test.yaml
│       ├── ./.github/workflows/ci-system-v1.1.yaml
│       ├── ./.github/workflows/ci-system-v1.yaml
│       └── ./.github/workflows/ci-to-dockerhub.yaml
├── ./ci
│   ├── ./ci/README.md
│   ├── ./ci/clear-ci-images.sh
│   ├── ./ci/create-local-tables-tpl.sh
│   ├── ./ci/create-local-tables.sh
│   ├── ./ci/quick-test.sh
│   ├── ./ci/runci-local.sh
│   ├── ./ci/runci.sh
│   ├── ./ci/v1
│   │   ├── ./ci/v1/Dockerfile
...
│   │   └── ./ci/v1/requirements.txt
│   └── ./ci/v1.1
│       ├── ./ci/v1.1/Dockerfile
...
│       └── ./ci/v1.1/test_music.py
`

The bulk of the material for working with our application is inside `cluster`.
``` 
├── ./cluster
│   ├── ./cluster/Kiali-sample-graph.png
│   ├── ./cluster/awscred--secret-tpl.yaml
│   ├── ./cluster/db--deploy-sa-svc-etc-tpl.yaml
│   ├── ./cluster/db--sm.yaml
│   ├── ./cluster/db--vs.yaml
│   ├── ./cluster/dyndb--se-vs-tpl.yaml
│   ├── ./cluster/loader--job-tpl.yaml
│   ├── ./cluster/s1--deploy-sa-svc-tpl.yaml
│   ├── ./cluster/s1--sm.yaml
│   ├── ./cluster/s1--vs.yaml
│   ├── ./cluster/s2--deploy_v1-tpl.yaml
│   ├── ./cluster/s2--sa-svc.yaml
│   ├── ./cluster/s2--sm.yaml
│   ├── ./cluster/s2--vs-dr.yaml
│   ├── ./cluster/service--gw.yaml
│   └── ./cluster/tpl-vars-blank.txt
```

Also inside `cluster` is a set of manifest for scenarios presented in the assignments.
``` 
│   ├── ./cluster/scenarios
│   │   ├── ./cluster/scenarios/db--vs_delay-500ms.yaml
│   │   ├── ./cluster/scenarios/db--vs_fault-10p.yaml
│   │   ├── ./cluster/scenarios/s1--dr_breaker-5s.yaml
│   │   ├── ./cluster/scenarios/s1--dr_direct.yaml
│   │   ├── ./cluster/scenarios/s2--deploy_v2-tpl.yaml
│   │   ├── ./cluster/scenarios/s2--deploy_v2.yaml
│   │   ├── ./cluster/scenarios/s2--dr_breaker.yaml
│   │   └── ./cluster/scenarios/s2--vs-dr_canary.yaml
```

The core of the microservices. 
```
├── ./db
│   ├── ./db/Dockerfile
│   ├── ./db/LICENSE
│   ├── ./db/README.md
│   ├── ./db/app-tpl.py
│   ├── ./db/app.py
│   └── ./db/requirements.txt
├── ./s1
│   ├── ./s1/Dockerfile
│   ├── ./s1/LICENSE
│   ├── ./s1/README.md
│   ├── ./s1/app.py
│   └── ./s1/requirements.txt
├── ./s2
│   ├── ./s2/LICENSE
│   ├── ./s2/README.md
│   ├── ./s2/v1
│   │   ├── ./s2/v1/Dockerfile
│   │   ├── ./s2/v1/app.py
│   │   ├── ./s2/v1/requirements.txt
│   │   ├── ./s2/v1/unique_code-tpl.py
│   │   └── ./s2/v1/unique_code.py
```

The variants of `s2`: `s2/v1.1`, `s2/v2`, and `s2/standalone` are for use with various Assignments. If you are deriving a new service for your term project, work with and/or derive from `s1` preferentially unless you are exploring multiple versions.
```
│   ├── ./s2/standalone
│   │   ├── ./s2/standalone/Dockerfile
│   │   ├── ./s2/standalone/Makefile
│   │   ├── ./s2/standalone/README-tpl.md
│   │   ├── ./s2/standalone/README.md
│   │   ├── ./s2/standalone/app-a1.py
│   │   ├── ./s2/standalone/app-a2.py
│   │   ├── ./s2/standalone/app-a3.py
│   │   ├── ./s2/standalone/builda1.sh
│   │   ├── ./s2/standalone/builda2.sh
│   │   ├── ./s2/standalone/builda3.sh
│   │   ├── ./s2/standalone/ec2-dockerignore
│   │   ├── ./s2/standalone/gen-random-bytes.sh
│   │   ├── ./s2/standalone/music.csv
│   │   ├── ./s2/standalone/odd
│   │   │   └── ./s2/standalone/odd/music.csv
│   │   ├── ./s2/standalone/requirements.txt
│   │   ├── ./s2/standalone/runa1.sh
│   │   ├── ./s2/standalone/runa2.sh
│   │   ├── ./s2/standalone/runa3.sh
│   │   ├── ./s2/standalone/s2-1-file-Dockerfile
│   │   ├── ./s2/standalone/s2-2-files-Dockerfile
│   │   ├── ./s2/standalone/self-Dockerfile
│   │   ├── ./s2/standalone/signon.sh
│   │   ├── ./s2/standalone/transfer-for-run.sh
│   │   ├── ./s2/standalone/transfer.sh
│   │   ├── ./s2/standalone/unique_code-tpl.py
│   │   └── ./s2/standalone/unique_code.py
│   ├── ./s2/test
│   │   ├── ./s2/test/Dockerfile
│   │   ├── ./s2/test/Makefile
│   │   ├── ./s2/test/music_test.py
│   │   └── ./s2/test/requirements.txt
│   ├── ./s2/v1.1
│   │   ├── ./s2/v1.1/Dockerfile
│   │   ├── ./s2/v1.1/README.md
│   │   ├── ./s2/v1.1/a7_app.py
│   │   ├── ./s2/v1.1/a7_other_dev_app.py
│   │   ├── ./s2/v1.1/app.py
│   │   └── ./s2/v1.1/requirements.txt
│   └── ./s2/v2
│       ├── ./s2/v2/Dockerfile
│       ├── ./s2/v2/app.py
│       └── ./s2/v2/requirements.txt
```

`etc` houses a motley collection of material.

To begin with, we have a Makefile for each cloud supported: AWS EKS, Azure AKS, Google GKE. Minikube is also provided here for completeness though it is limited.
```
├── ./etc
│   ├── ./etc/allclouds-tpl.mak
│   ├── ./etc/az-tpl.mak
│   ├── ./etc/eks-tpl.mak
│   ├── ./etc/gcp-tpl.mak
│   ├── ./etc/mk-tpl.mak
```

There is a sub-makefile for driving the API directly using `curl`, managing the `istio` service mesh and the observability components (Prometheus, Grafana & Kiali)
```
│   ├── ./etc/api-tpl.mak
│   ├── ./etc/mesh.mak
│   ├── ./etc/obs.mak
```

Sundry resources here. Notable items include  the CloudFormation definition for the DynamoDB table (`cf-dyndb.json`) and the Grafana dashboard (`k8s-dashboard.json`).
```
│   ├── ./etc/config
│   │   ├── ./etc/config/cf-dyndb-tpl.json
│   │   ├── ./etc/config/eks-admin-service-account.yaml
│   │   ├── ./etc/config/helm-kube-stack-values.yaml
│   │   ├── ./etc/config/k8s-dashboard.json
│   │   ├── ./etc/config/kiali--cr.yaml
│   │   ├── ./etc/config/monitoring--svcs.yaml
│   │   ├── ./etc/config/monitoring--vs.yaml
│   │   └── ./etc/config/networking.md
```

Some material for those familiar with Postman already to build on:
```
│   ├── ./etc/postman
│   │   ├── ./etc/postman/DB.postman_coll.json
│   │   ├── ./etc/postman/S1-user.postman_coll.json
│   │   └── ./etc/postman/S2-music.postman_coll.json
```

Experimental (or otherwise not center stage) bits and bobs as described internally:
```
│   ├── ./etc/csil-build
│   │   ├── ./etc/csil-build/README.md
│   │   ├── ./etc/csil-build/cleanup-csil-756.sh
│   │   ├── ./etc/csil-build/send-file-to-csil.sh
│   │   └── ./etc/csil-build/send-to-csil.sh
│   ├── ./etc/gcloud
│   │   ├── ./etc/gcloud/Dockerfile
│   │   ├── ./etc/gcloud/README.md
│   │   ├── ./etc/gcloud/gcloud-build-tpl.sh
│   │   ├── ./etc/gcloud/gcloud-build.sh
│   │   ├── ./etc/gcloud/shell-tpl.sh
│   │   └── ./etc/gcloud/shell.sh
│   ├── ./etc/gcp-setup.md
│   ├── ./etc/install-notes
│   │   ├── ./etc/install-notes/README.md
│   │   ├── ./etc/install-notes/istio-profile-default-reference.yaml
│   │   ├── ./etc/install-notes/istio-profile-demo-reference.yaml
│   │   ├── ./etc/install-notes/kube-prometheus-stack-values-reference.yaml
│   │   └── ./etc/install-notes/prometheus-rules-reference.yaml
│   └── ./etc/profiles
│       ├── ./etc/profiles/README-aws.md
│       ├── ./etc/profiles/README.md
│       ├── ./etc/profiles/aws-a
│       ├── ./etc/profiles/bash_aliases
│       ├── ./etc/profiles/ec2.mak
│       └── ./etc/profiles/gitconfig
```

The course uses Gatling to generate load of the system. The pre-defined simuluations are included here. 
```
├── ./gatling
│   ├── ./gatling/resources
│   │   ├── ./gatling/resources/music.csv
│   │   └── ./gatling/resources/users.csv
│   └── ./gatling/simulations
│       └── ./gatling/simulations/proj756
│           ├── ./gatling/simulations/proj756/BasicSimulation.scala
│           └── ./gatling/simulations/proj756/ReadTables.scala
```

The loader inserts the fixtures from `gatling/resources` into DynamoDB.
```
├── ./loader
│   ├── ./loader/Dockerfile
│   ├── ./loader/LICENSE
│   ├── ./loader/README.md
│   ├── ./loader/app.py
│   └── ./loader/requirements.txt
```

Assignment 4's CLI for the Music service. It's non-core to the Music microservices. At present, it is only useable for the Intel architecture. If you are working from an M1 Mac, you will not be able to build/use this. The workaround is to build/run from an (Intel) EC2 instance.
```
├── ./mcli
│   ├── ./mcli/Dockerfile
│   ├── ./mcli/Makefile
│   ├── ./mcli/mcli.py
│   └── ./mcli/requirements.txt
```

Most commands save their outputs here for your review. You should purge this periodically.
```
├── ./logs
```

Internal tools & scripts:
```
└── ./tools
    ├── ./tools/aws-cred.sh
    ├── ./tools/aws-rotate-cred.sh
    ├── ./tools/call-sed.sh
    ├── ./tools/enum-gatling.sh
    ├── ./tools/find-canonical-owner.sh
    ├── ./tools/findstring.sh
    ├── ./tools/gatling.sh
    ├── ./tools/getip.sh
    ├── ./tools/kill-gatling.sh
    ├── ./tools/list-gatling.sh
    ├── ./tools/make.sh
    ├── ./tools/prep-csil.sh
    ├── ./tools/process-templates.sh
    ├── ./tools/profiles.sh
    ├── ./tools/run-if-cmd-exists.sh
    ├── ./tools/s2ver.sh
    ├── ./tools/shell.sh
    ├── ./tools/waiteq.sh
    └── ./tools/waitne.sh
```
