#
# Sub-make file to bring some sanity to the litany of tools and switches
# for installing Prometheus and Istio. This file adds a set of monitoring and
# observability tool including: Prometheus, Grafana and Kiali by way of installing
# them using Helm. Note the Helm repo is up-to-date as of mid-Nov 2020. 
#
# Prometheus, Grafana and Kiali are installed into the same namespace (istio-system)
# to make them work out-of-the-box (install). It may be possible to separate each of
# them out into their own namespace but I didn't have time to validate/explore this.
#
# The intended approach to working with this makefile is to update select
# elements (body, id, IP, port, etc) as you progress through your workflow.
# Where possible, stodout outputs are tee into .out files for later review.
#

HELM=helm

# Keep all the logs out of main directory
LOG_DIR=logs

# these might need to change
APP_NS=c756ns
ISTIO_NS=istio-system
KIALI_OP_NS=kiali-operator
KIALI_VER=1.45.0

RELEASE=c756

# This might also change in step with Prometheus' evolution
PROMETHEUSPOD=prometheus-$(RELEASE)-kube-p-prometheus-0

all: install-prom install-kiali


# add the latest active repo for Prometheus
# Only needs to be done once for any user but is idempotent
init-helm:
	$(HELM) repo add prometheus-community https://prometheus-community.github.io/helm-charts
	$(HELM) repo update

# note that the name $(RELEASE) is discretionary; it is used to reference the install 
# Grafana is included within this Prometheus package
install-prom:
	$(HELM) install $(RELEASE) -f cluster/supplemental/helm-kube-stack-values.yaml --namespace $(ISTIO_NS) prometheus-community/kube-prometheus-stack | tee -a $(LOG_DIR)/obs-install-prometheus.log
	kubectl apply -n $(ISTIO_NS) -f cluster/supplemental/monitoring--svcs.yaml | tee -a $(LOG_DIR)/obs-install-prometheus.log
	kubectl -n $(ISTIO_NS) create configmap c756-dashboard --from-file=cluster/supplemental/k8s-dashboard.json || true
#   Sidecar loads all ConfigMaps with the label grafana_dashboard
	kubectl -n $(ISTIO_NS) label configmap c756-dashboard --overwrite=true grafana_dashboard=1


uninstall-prom:
	$(HELM) uninstall $(RELEASE) --namespace $(ISTIO_NS) | tee -a $(LOG_DIR)/obs-uninstall-prometheus.log
	kubectl -n $(ISTIO_NS) delete configmap c756-dashboard 

install-kiali:
	# This will fail every time after the first---the "|| true" suffix keeps Make running despite error
	kubectl create namespace $(KIALI_OP_NS) || true  | tee -a $(LOG_DIR)/obs-kiali.log
	$(HELM) install --set cr.create=true --set cr.namespace=$(ISTIO_NS) --namespace $(KIALI_OP_NS) \
		--repo https://kiali.org/helm-charts --version $(KIALI_VER) kiali-operator kiali-operator | tee -a $(LOG_DIR)/obs-kiali.log
	kubectl apply -n $(ISTIO_NS) -f cluster/supplemental/kiali--cr.yaml | tee -a $(LOG_DIR)/obs-kiali.log
	
update-kiali:
	kubectl apply -n $(ISTIO_NS) -f cluster/supplemental/kiali--cr.yaml | tee -a $(LOG_DIR)/obs-kiali.log

uninstall-kiali:
	$(HELM) uninstall kiali-operator --namespace $(KIALI_OP_NS) | tee -a $(LOG_DIR)/obs-uninstall-kiali.log

status-kiali:
	kubectl get -n $(ISTIO_NS) pod -l 'app=kiali'

promport:
	kubectl describe pods $(PROMETHEUSPOD) -n $(ISTIO_NS)
