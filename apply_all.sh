#!/bin/sh

# Helper script to apply all our k8s manifests.
# We'll first create our persistent volume,
# then our persistent volume claim,
# and then reference that pvc in our cronjob spec.
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f cronjob.yaml

# We create a stateful-set which mounts our persistent volume as well,
# just for demoing purposes.
kubectl apply -f sts.yaml

# Display objects afterwards
kubectl get all,pvc,pv