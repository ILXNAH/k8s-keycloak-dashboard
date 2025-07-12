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

echo "📦  Creating 'keycloak' namespace if it doesn't exist..."
kubectl get namespace keycloak &>/dev/null || kubectl create namespace keycloak

echo "📦  Applying PostgreSQL manifests into 'keycloak' namespace..."
kubectl apply -f k8s/postgres/postgres-pv-pvc.yaml -n keycloak
kubectl apply -f k8s/postgres/postgres-secret.yaml -n keycloak
kubectl apply -f k8s/postgres/postgres-deployment.yaml -n keycloak

echo "✅  PostgreSQL should now be deploying..."

echo "⏳  Waiting for PostgreSQL pod to be ready..."
if kubectl wait --for=condition=Ready pod \
  --selector=app=postgres \
  --timeout=90s \
  -n keycloak
then
  echo "✅  PostgreSQL pod is ready!"
else
  echo "⚠️  PostgreSQL pod not ready after 90s — continuing anyway."
fi

echo "📦  PVC status:"
kubectl get pvc -n keycloak

echo "📦  PV status:"
kubectl get pv  # PVs are cluster-wide, no -n needed

echo "🌐  Service status:"
kubectl get svc -n keycloak

echo "💡  Next steps: Deploy Keycloak, Ingress rules, and Dashboard."

echo "✅  Done (for now)."
