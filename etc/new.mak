
# configure your enviroment

AWS=aws --profile default
HELM=helm
IC=istioctl
KC=kubectl


# config

# step 1:
# step 2:
# 


# adjust these with care
APP_NS=c756ns
KIALI_VER=
PROM...
STACKNAME=db-overcoil

# ==============================

.phony=provision cluster platform-config app-config monitoring \
	deploy restart scratch clean clean-all \
	setup-dynamodb clean-dynamodb \
	istio-gateway install-istio \
	kiali-url install-kiali uninstall-kiali prom-url install-prom uninstall-prom 

# ==============================

# Bring everything up in one shot
provision: prereq cluster platform-config app-config monitoring deploy


# check for prereq tools
prereq:
	echo Checking for prerequisites...
	$(AWS) sts get-caller-identity
	$(HELM) version
	$(IC) version
	$(KC) version
	echo Please rectify any errors above before proceeding.

# bring up the cluster
# be sure to set up _cluster.mak to the appropriate Kubernetes platform
cluster:
	make -f _cluster.mak up


# install dependencies
platform-config: install-istio install-prom install-kiali setup-dynamodb


# install ConfigMap & Secrets for our app
app-config: misc/awscred.yaml misc/users.json misc/music.json 
	$(KC) create namespace $(APP_NS)
	$(KC) label blah blah
	$(KC) apply -f misc/awscred.yaml
	$(KC) create configmap -f misc/user.json
	$(KC) create configmap -f misc/user.json


# install Prometheus, servicemonitors etc
monitoring: monitoring/*.yaml 
	$(KC) apply -f monitoring/*.yaml


# install our app
# (this is laid out explicitly for ease of reading)
deploy: main/*.yaml mesh/*.yaml
	$(KC) apply -f main/s1-sa-svc-deploy.yaml 
	$(KC) apply -f main/s2-sa-svc.yaml 
	$(KC) apply -f main/s2-deploy--v1.yaml 
	$(KC) apply -f main/db-sa-svc-deploy.yaml 
	$(KC) apply -f mesh/s1-vs.yaml
	$(KC) apply -f mesh/s2-vs.yaml
	$(KC) apply -f mesh/db-vs.yaml
	$(KC) apply -f mesh/app-gw.yaml


a5-action1: 
	$(KC) apply -f experiments/s2-deploy--v2.yaml

a5-action2: 
	$(KC) apply -f main/s2-deploy--v1.yaml


a7-action1:
	$(KC) apply -f experiments/s2-vs-dr--canary.yaml

a7-action2:
	$(KC) apply -f mesh/s2-vs.yaml



# bounce everything
restart:
	$(KC) rollout restart -f main/*.yaml
	$(KC) rollout restart -f main/*.yaml


# bring it all down
scratch:
	$(KC) delete -f main/*.yaml
	$(KC) delete -f mesh/*.yaml


# Note that this does not delete your DynamoDB tables so as to preserve your data during the course.
# See clean-all and clean-dynamodb. 
clean: scratch
	$(KC) delete -f misc/awscred.yaml
	$(KC) delete -f configmap/user
	$(KC) delete -f configmap/music


# End of term clean
clean-all: clean clean-dynamodb


# ==============================
#

# TODO: replace the "|| true" to make this idempotent/smart
setup-dynamodb: misc/cf-dynamodb.json
	$(AWS) create-stack --stack-name $(STACKNAME) blah misc/cf-dynamodb.json || true


clean-dynamodb: misc/cf-dynamodb.json
	$(AWS) delete-stack blah misc/cf-dynamodb.json


status-dynamodb:


# ==============================
# Istio

istio-gateway:
	$(KC) -n $(ISTIO_NS) get svc istio-ingressgateway


install-istio:


status-istio:


# ==============================
#
# Grafana

grafana-url:


# ==============================
# 
# Kiali

kiali-url:

install-kiali:

update-kiali:

uninstall-kiali:


# ==============================
# Prometheus

prom-url:

install-prom: init-helm


init-helm:


uninstall-prom:



# ==============================
a1-action1:

a2-action2:

a7-action1:
	$(KC) apply -f experiments/s2-deploy



