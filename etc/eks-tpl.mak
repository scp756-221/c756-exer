#
# eks.mak: rudimentary makefile for bringing up a Kubernetes cluster in AWS EKS
#
# The main Makefile relies on only two targets: start and stop.
#


# these might need to change
CLUSTER_NAME=aws756
EKS_CTX=aws756
APP_NS=c756ns

# Keep all the logs out of main directory
LOG_DIR=logs

# the following are only used with the start target; the startalt target uses a YAML with inlined values.
REGION=ZZ-AWS-REGION
KVER=1.21
# t3.medium = 2 vCPU
# t3.2xlarge = 8 vCPU
# Details: https://aws.amazon.com/ec2/instance-types/t3/
NTYPE=t3.medium
NGROUP=worker-nodes


EKR=eksctl --region $(REGION)

# --- start: create a cluster with a single node group as specified
start: 
	$(EKR) create cluster --version $(KVER) --name $(CLUSTER_NAME) \
		--nodegroup-name $(NGROUP) --node-type $(NTYPE) \
		--nodes 2 --nodes-min 2 --nodes-max 5 --managed | tee $(LOG_DIR)/eks-start.log
	# Use back-ticks for subshell because $(...) notation is used by make
	kubectl config rename-context `kubectl config current-context` $(EKS_CTX) | tee -a $(LOG_DIR)/eks-start.log


# --- startalt: create a cluster using YAML files to provide finer control of nodegroup(s)
#               Note cluster.yaml is not supplied here. Refer to 
#               ref: https://eksctl.io/usage/creating-and-managing-clusters/
startalt: cluster.yaml
	eksctl create cluster -f cluster.yaml | tee $(LOG_DIR)/eks-startalt.log
	# you may wish to rename your context


# --- stop: stop your cluster
stop:
	$(EKR) delete cluster --name $(CLUSTER_NAME) | tee $(LOG_DIR)/eks-stop.log
	kubectl config delete-context $(EKS_CTX) | tee -a $(LOG_DIR)/eks-stop.log


# --- up: create an EKS node group; this may/need or may/need not be synchronized with the above
up:
	$(EKR) create nodegroup --cluster $(CLUSTER_NAME) \
		--name $(NGROUP) --node-type $(NTYPE) \
		--nodes 2 --nodes-min 2 --nodes-max 5 --managed | tee $(LOG_DIR)/eks-up.log


# --- down: delete an EKS node group; this may/need or may/need not be synchronized with the above
down:
	$(EKR) delete nodegroup --cluster=$(CLUSTER_NAME) --name=$(NGROUP) | tee $(LOG_DIR)/eks-down.log


# --- ls: Show all AWS clusters
ls:
	$(EKR) get cluster -v 0


# --- lsl: Show the AWS cluster's node group(s)
lsl: 
	$(EKR) get nodegroup --cluster $(CLUSTER_NAME)


