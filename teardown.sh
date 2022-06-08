#!/bin/sh

# Helper script to easily delete all our k8s objects
kubectl delete pvc/wiki-grabber-claim
kubectl delete pv/wiki-grabber
kubectl delete cronjob.batch/wiki-grabber