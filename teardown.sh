#!/bin/sh
#
# Helper script to easily delete all our k8s objects
kubectl delete cronjob.batch/wiki-grabber
kubectl delete statefulset.apps/volume-inspector
kubectl delete pvc/wiki-grabber-claim
kubectl delete pv/wiki-grabber

