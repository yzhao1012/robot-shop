#!/bin/bash

# Script to build and redeploy the whole robot-shop demo application.

echo "Uninstalling the existing robot-shop deployment ..."
helm uninstall robot-shop -n robot-shop

echo "Remove load generator ..."
kubectl delete -f K8s/load-deployment.yaml -n robot-shop

echo "Build and push docker images ..."
cat .env
docker-compose build && docker-compose push

echo "Waiting for cleaning up all deployed objects ..."
# Namespace robot-shop also 3 objects for load generator: pod, deployment, and replicaset.
# So the robot-shop app is only removed until only load generator objects are left.
# Otherwise, the next helm install might fail to launch certain objects.
while (( $(expr $(kubectl get all -n robot-shop --no-headers | wc -l)) > 0 )); do
  kubectl get all -n robot-shop --no-headers
  echo
  echo
  sleep 2
done

echo "Deploying robot-shop application ..."
helm install robot-shop -n robot-shop K8s/helm

echo "Deploying load generator ..."
kubectl apply -f K8s/load-deployment.yaml -n robot-shop
