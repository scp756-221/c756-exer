#
# mesh.mak:
# 
# Sub-make file to organize the details of istio
#

# Keep all the logs out of main directory
LOG_DIR=logs

# this is the default name; do not change this lightly!
ISTIO_NS=istio-system

all: install-istio 

# --- install-istio: install using the default profile and into the default namespace
install-istio:
	istioctl install -y --set profile=demo --set hub=gcr.io/istio-release | tee $(LOG_DIR)/install-istio.log

# --- uninstall-istio: remove istio from the cluster, leaving your application retouched.
#                      ref: https://istio.io/latest/docs/setup/getting-started/#uninstall
uninstall-install:
	kubectl delete -f samples/addons
	istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
	istioctl tag remove default
	kubectl delete namespace $(ISTIO_NS)
	kubectl label namespace default istio-injection-
