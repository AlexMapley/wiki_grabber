#!/bin/sh

# Helpful script to tunnel into the volume-inspector
# stateful-set and take a look at our persistent volume contents.
kubectl exec -ti pod/volume-inspector-0 -c volume-inspector -- /bin/sh