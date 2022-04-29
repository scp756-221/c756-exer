#
#

# this Makefile relies on the default namespace to be set (externally)
# $(NS) is only used only for istio
KC=kubectl


# --------------------------------
# Kubernetes-platform-specific settings
# --------------------------------
K8S_CTX=aws756-a6

# data science image 
# ref: https://hub.docker.com/r/civisanalytics/datascience-python
DS_IMG=civisanalytics/datascience-python:6.5.1

# use this to test config values
#DRY_RUN=--dry-run
DRY_RUN=

PROFILE=default
REGION=us-west-2

AWS=aws --profile $(PROFILE) --region $(REGION) $(DRY_RUN)
EC=AWS_PROFILE=$(PROFILE) eksctl --region $(REGION) $(DRY_RUN)
ECF=AWS_PROFILE=$(PROFILE) eksctl $(DRY_RUN)

CLUSTER_NAME=c756-a6-dgk-eg

# AWS/EKS var2: values inlined into YAML
EKSYAML=a6-eks.yaml

# ----------------------------
.phony=eksup ekssync eksdown schedule-any schedule-dual-core schedule-gpu
# =====================================================

eksup: $(EKSYAML)
# var 2: use a yaml to specify all parameters; take care to
#        stay in sync with $(CLUSTER_NAME) here!!
	ls -l $(EKSYAML)
	$(ECF) create cluster -f $(EKSYAML)
	# do a version check cuz the -f option above has option to specify KVER
	$(AWS) eks describe-cluster --name $(CLUSTER_NAME) --output json | jq -r '.cluster.version'

    # Use back-ticks for subshell because $(...) notation is used by make
	$(KC) config rename-context `$(KC) config current-context` $(K8S_CTX) 

# use update-kubeconfig if your ~/.kube/config is in the wrong state
ekssync:
	$(AWS) eks update-kubeconfig --name $(CLUSTER_NAME) --alias $(K8S_CTX)

# you can also delete just the nodegroup
eksdown:
	$(EC) delete cluster --name $(CLUSTER_NAME)

any-session:
	$(KC) run whatever --rm -i --tty --labels="run=whatever" --image=$(DS_IMG)  \
		-- bash

dual-session:
	$(KC) run cpu-session --rm -i --tty --labels="run=cpu-session" --image=$(DS_IMG)  \
		--overrides='{"apiVersion":"v1","spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"equipment","operator":"In","values":["x86"]}]}]}}}}}' \
		-- bash

# ref: https://stackoverflow.com/questions/51161647/kubectl-run-set-nodeselector
gpu-session:
	$(KC) run gpu-session --rm -i --tty --labels="run=gpu-session" --image=$(DS_IMG)  \
		--overrides='{"apiVersion":"v1","spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"equipment","operator":"In","values":["gpu"]}]}]}}}}}' \
		-- bash
