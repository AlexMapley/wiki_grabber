#!/bin/sh

# Helper script to apply all our k8s manifests.
# We'll create our persistent volume via our pvc,
# and reference that pvc in our cronjob spec.
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f cronjob.yaml
kubectl apply -f sts.yaml

# Display objects afterwards
kubectl get all,pvc,pv