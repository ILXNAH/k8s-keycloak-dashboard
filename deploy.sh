#!/bin/bash
set -e  # Exit immediately if a command fails

# Check if running under WSL2
if ! grep -qi "microsoft" /proc/version; then
  echo "⚠️  This script is optimized for WSL2 with Docker Desktop."
  echo "    You may need to modify the driver if you're not using WSL2."
  echo "    e.g. use --driver=virtualbox or --driver=none"
  echo
fi

echo "🔧  Deploying k8s-keycloak-dashboard environment..."

echo "🚀  Starting Minikube cluster using Docker driver..."
minikube start --driver=docker

echo "✅  Enabling Ingress addon..."
minikube addons enable ingress

echo "⏳  Waiting for Ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "📦  Applying PostgreSQL manifests..."
kubectl apply -f k8s/postgres/postgres-pv-pvc.yaml
kubectl apply -f k8s/postgres/postgres-secret.yaml
kubectl apply -f k8s/postgres/postgres-deployment.yaml

echo "✅  PostgreSQL should now be deploying..."

echo "⏳  Waiting for PostgreSQL pod to be ready..."

kubectl wait --for=condition=Ready pod \
  --selector=app=postgres \
  --timeout=90s

echo "✅  PostgreSQL pod is ready!"

echo "💡  Next steps: Deploy Keycloak, Ingress rules, and Dashboard."

echo "✅  Done (for now)."
