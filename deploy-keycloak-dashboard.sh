#!/bin/bash

set -e

echo "🚀  Deploying Keycloak with custom Helm values..."

# 0. Uninstall if needed
helm uninstall keycloak -n keycloak || true

# 1. Add and update Bitnami repo
helm repo add bitnami https://charts.bitnami.com/bitnami || true
helm repo update

# 2. Install Keycloak
helm install keycloak bitnami/keycloak \
  -n keycloak \
  -f k8s/keycloak/keycloak-values.yaml

# 3. Wait for Keycloak pod readiness
echo "⌛  Waiting for Keycloak pod to become ready (max 10 minutes)..."

SECONDS=0
TIMEOUT=600  # 10 minutes
HALFWAY=300  # 5 minutes

while [[ $SECONDS -lt $TIMEOUT ]]; do
  STATUS=$(kubectl get pods -n keycloak -l app.kubernetes.io/name=keycloak -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null)

  if [[ "$STATUS" == "true" ]]; then
    echo "✅  Keycloak pod is ready!"
    break
  fi

  if [[ $SECONDS -ge $HALFWAY && $SECONDS -lt $((HALFWAY + 5)) ]]; then
    echo "⏳  Still waiting... continuing for another 5 minutes"
  fi

  sleep 5
done

if [[ "$STATUS" != "true" ]]; then
  echo "❌  Timeout: Keycloak pod did not become ready after 10 minutes."
  exit 1
fi

# 4. Deploy Kubernetes Dashboard (official only)
echo "🖥️  Deploying Kubernetes Dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# 5. Apply Dashboard admin config
kubectl apply -f k8s/dashboard/dashboard-admin.yaml

# 6. Apply Ingress for Keycloak and Dashboard
echo "🌐  Applying Ingress rules..."
kubectl apply -f k8s/keycloak/keycloak-ingress.yaml
kubectl apply -f k8s/dashboard/dashboard-ingress.yaml

# 7. Final reminder
echo "✅  All components deployed."
echo "🔑  To access:"
echo "-   http://keycloak.local  → admin / adminpassword"
echo "-   http://dashboard.local → login with token:"
echo ""
echo "kubectl -n kubernetes-dashboard create token admin-user"
