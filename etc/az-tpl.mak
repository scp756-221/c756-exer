#
# Front-end to bring some sanity to the litany of tools and switches
# in setting up, tearing down and validating your Azure cluster.
#
# There is an intentional parallel between this makefile
# and the corresponding file for Minikube or EKS. This makefile makes extensive
# use of pseudo-target to automate the error-prone and tedious command-line
# needed to get your environment up. There are some deviations between the
# two due to irreconcilable differences between a private single-node
# cluster (Minikube) and a public cloud-based multi-node cluster (EKS).
#
# The intended approach to working with this makefile is to update select
# elements (body, id, IP, port, etc) as you progress through your workflow.
# Where possible, stodout outputs are tee into .out files for later review.
#


AKS=az aks
KC=kubectl


# Keep all the logs out of main directory
# (This is relative to where this makefile is launch)
LOG_DIR=logs

# these might need to change
GRP=c756group
CLUSTER_NAME=az756
AZ_CTX=az756


# Standard_A2_v2: 2 vCore & 4 GiB RAM
NTYPE=Standard_A2_v2
NUM_NODES=2

# NB: The subtlety of Azure resource group is that it can hold resources from multiple locations.
#     For simplicity, this makefile keeps the two together in the one location specified below.
LOC=canadacentral

# This version is supported for canadacentral; see kver below 
KVER=1.21.9




# --- start: create a cluster with a single node pool as specified
#
# Note that get-credentials fetches the access credentials for the managed Kubernetes cluster and inserts it
# into your kubeconfig (~/.kube/config)
#
# It might be a good idea to lock this down if the cluster is long-lived.
# Ref: https://docs.microsoft.com/en-us/azure/aks/control-kubeconfig-access
#
# Virtual nodes look like a great idea to save cost:
# Ref: https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli
# But they're not available in the canadacentral region as of Oct 2020
#
start: 
	date | tee  $(LOG_DIR)/az-start.log
	az group create -o table --location $(LOC) --name $(GRP)  | tee -a $(LOG_DIR)/az-start.log
	$(AKS) create --resource-group $(GRP) -o table \
		--kubernetes-version $(KVER) --name $(CLUSTER_NAME) \
		--node-count $(NUM_NODES) --node-vm-size $(NTYPE) --generate-ssh-keys | tee -a $(LOG_DIR)/az-start.log
	$(AKS) get-credentials --resource-group $(GRP) --name $(CLUSTER_NAME) \
		--context $(AZ_CTX) --overwrite-existing | tee -a $(LOG_DIR)/az-start.log
	date | tee -a $(LOG_DIR)/az-start.log


# --- stop: stop your cluster
stop:
	$(AKS) delete --resource-group $(GRP) --name $(CLUSTER_NAME) -y | tee $(LOG_DIR)/az-stop.log


# --- up: create an Azure node pool
#         ref: https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools
up:
	@echo "NOT YET IMPLEMENTED"
	exit 1


# --- down: delete an AKS node pool
#           ref: https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools
down:
	@echo "NOT YET IMPLEMENTED"
	exit 1	


# --- ls: Show all AKS clusters
ls: 
	$(AKS) list --resource-group $(GRP) -o table || true


# --- lsl: Show the AKS cluster's node pool(s)
lsl: 
	$(AKS) nodepool list --resource-group $(GRP) --cluster-name $(CLUSTER_NAME)


# --- subscription: List your Azure subscriptions
subscription:
	az account list


# --- kver: Look up available Kubernetes version in your location
kver:
	$(AKS) get-versions --location $(LOC)
