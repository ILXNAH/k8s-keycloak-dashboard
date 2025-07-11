## 🏗️ Cluster Setup  
To set up the Kubernetes cluster used in this project, follow the instructions in  
👉 [setup/cluster-setup.md](setup/cluster-setup.md)

---

## 🧪 Tested Environment  
The project was built and tested on the following environment:

```
OS: Ubuntu 24.04.2 LTS (WSL2)  
Client Version: v1.32.2  
Kustomize Version: v5.5.0  
Server Version: v1.32.0  

Kubernetes control plane is running at https://127.0.0.1:50512  
CoreDNS is running at https://127.0.0.1:50512/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

Minikube was used with the Docker driver inside WSL2.  
Ingress addon and Kubernetes Dashboard were both enabled and verified.

---

## 📦 PostgreSQL Persistent Storage Setup  
To ensure PostgreSQL data persists across pod restarts and cluster reboots, a `PersistentVolume` (PV) and `PersistentVolumeClaim` (PVC) were defined manually.

### 📁 Files:  
- `k8s/postgres/postgres-pv-pvc.yaml`

### 🧱 Resources Created:  
- **PersistentVolume** `postgres-pv`  
  - Storage: 1Gi  
  - Path: `/data/postgres` on the Minikube host (via `hostPath`)  
  - Access Mode: `ReadWriteOnce`  
- **PersistentVolumeClaim** `postgres-pvc`  
  - Requests 1Gi of storage  
  - Binds to the above PV

> Note: The PVC explicitly sets `storageClassName: ""` to prevent binding to the default dynamic storage class provided by Minikube.

### ✅ Apply Manifests:  
```bash
kubectl apply -f k8s/postgres/postgres-pv-pvc.yaml
```

### 🔍 Verify Status:  
```bash
kubectl get pv
kubectl get pvc
```

The PVC should show `STATUS: Bound` and reference the `postgres-pv` volume.

---

## 🔐 PostgreSQL Credentials via Kubernetes Secret  
PostgreSQL credentials are managed securely using a Kubernetes `Secret` resource. This prevents hardcoding sensitive data directly in deployment manifests or version control.

### 📁 File:  
- `k8s/postgres/postgres-secret.yaml`

### 🧾 Secret Contents:  
The secret contains the following key-value pairs:
- `POSTGRES_USER`: the PostgreSQL username (e.g., `keycloak`)
- `POSTGRES_PASSWORD`: the database password (e.g., `supersecret`)
- `POSTGRES_DB`: the name of the database to create on container init (e.g., `keycloakdb`)

These values are automatically mounted into the PostgreSQL container using the `envFrom` directive.

### ✅ Apply Secret:  
```bash
kubectl apply -f k8s/postgres/postgres-secret.yaml
```

### 🔍 Verify Status:  
```bash
kubectl get secret postgres-secret -o yaml
```

You should see base64-encoded values for `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.

### 📌 Why Use a Secret?  
- Keeps credentials **separate from pod definitions**
- Prevents secrets from being exposed in Git repositories
- Allows for **easier rotation of credentials** without editing the Deployment
- Supports **centralized credential control**: Secrets can be updated or patched independently

> Note: Secrets are base64-encoded in Kubernetes. In production environments, it is recommended to encrypt secrets at rest and restrict access via RBAC.

---

## 🐘 PostgreSQL Deployment  
PostgreSQL was deployed as a standalone pod using the official `postgres:16` image. It runs on the Kubernetes cluster with persistent storage and secure credentials.

### 📁 File:  
- `k8s/postgres/postgres-deployment.yaml`

### 📦 Features:  
- **Environment variables** (DB name, user, password) are injected securely via a Kubernetes Secret (`postgres-secret`)
- **Persistent data storage** using a `PersistentVolumeClaim` (`postgres-pvc`) mounted at `/var/lib/postgresql/data`
- **Internal accessibility** via a `ClusterIP` service (`postgres`) on port `5432`

### ✅ Apply Manifests:  
```bash
kubectl apply -f k8s/postgres/postgres-deployment.yaml
```

### 🔍 Verify Status:  
```bash
kubectl get pods
kubectl get svc
kubectl describe pod <postgres-pod-name>
```

When correctly deployed, the pod should be `Running`, and the service should expose port `5432` internally to other components (e.g., Keycloak).

### 🪵 View Logs (Optional)
To check PostgreSQL startup logs or debug issues:
```bash
kubectl logs <postgres-pod-name>
```

You can auto-complete the pod name with `Tab` after typing `postgres-`.

---

## 🛠️ Quick Start with `deploy.sh`  
This project includes a deployment script to automate the cluster setup and PostgreSQL installation.

### 🚀 How to Use
After installing Docker, Minikube, and kubectl, you can launch the stack with:

```bash
./deploy.sh
```

This script:
- Starts a Minikube cluster with the Docker driver
- Enables the NGINX Ingress controller
- Applies all PostgreSQL manifests:
  - PersistentVolume and PersistentVolumeClaim
  - Secret with DB credentials
  - Deployment and ClusterIP service

> 🧠 Note: This script is optimized for **WSL2 + Docker Desktop**.  
> If you're using native Linux or macOS, you may need to modify the Minikube driver flag (e.g., `--driver=virtualbox`).

### 📦 What’s Next?  
The script sets up everything needed for Keycloak and Kubernetes Dashboard to be deployed next.

---

## 🧾 Extras  
### 🔹 Kubernetes Minikube Cheat Sheet  
A quick-reference guide for working with Minikube and applying manifests.

📄 [View cheat sheet](notes/k8s-minikube-cheatsheet.md)  