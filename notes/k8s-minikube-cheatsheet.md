# 🧾 Kubernetes Minikube – Cheat Sheet

Optional quick-reference for running apps on Minikube. Useful during testing and verification phases.

---

## ▶️ Start Minikube

```bash
minikube start
minikube stop
minikube delete
minikube start --driver=docker
kubectl get nodes
```

## 🛠️ Build or Pull Docker Image

```bash
eval $(minikube docker-env)
eval $(minikube docker-env -u)
docker build -t express-k8s-app:latest .
docker tag express-k8s-app ilouckov/express-k8s-app
docker push ilouckov/express-k8s-app
```

## 📦 Apply Kubernetes Manifests

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl delete -f k8s/
kubectl apply -f k8s/
```

> ℹ️ Rolling updates are triggered automatically when deployments change.

## 📊 Check Resources

```bash
kubectl get all
```

## 🌐 Access the App via Tunnel (Preferred for Docker driver)

```bash
minikube service express-service --url

curl http://127.0.0.1:<dynamic-port>/
curl http://127.0.0.1:<dynamic-port>/check-api
curl http://127.0.0.1:<dynamic-port>/healthz
curl http://127.0.0.1:<dynamic-port>/ready
```

## 🌍 Access via NodePort (May not work on Docker driver)

```bash
minikube ip
kubectl get svc express-service

curl http://<minikube-ip>:<NodePort>/ready
```

## 🧪 Check Pod Env Variables

```bash
kubectl exec deploy/express-deployment -- printenv | grep API_KEY
```

## 🐛 Debugging & Troubleshooting

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```
