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

### 📁 Files  
- `k8s/postgres/postgres-pv-pvc.yaml`

### 🧱 Resources Created  
- **PersistentVolume** `postgres-pv`  
  - Storage: 1Gi  
  - Path: `/data/postgres` on the Minikube host (via `hostPath`)  
  - Access Mode: `ReadWriteOnce`  
- **PersistentVolumeClaim** `postgres-pvc`  
  - Requests 1Gi of storage  
  - Binds to the above PV

> Note: The PVC explicitly sets `storageClassName: ""` to prevent binding to the default dynamic storage class provided by Minikube.

### ✅ Apply Manifests  
```bash
kubectl apply -f k8s/postgres/postgres-pv-pvc.yaml
```

### 🔍 Verify Status  
```bash
kubectl get pv
kubectl get pvc
```  
The PVC should show `STATUS: Bound` and reference the `postgres-pv` volume.

---

## 🔐 PostgreSQL Credentials via Kubernetes Secret  
PostgreSQL credentials are managed securely using a Kubernetes `Secret` resource. This prevents hardcoding sensitive data directly in deployment manifests or version control.

### 📁 File  
- `k8s/postgres/postgres-secret.yaml`

### 🧾 Secret Contents  
The secret contains the following key-value pairs:
- `POSTGRES_USER`: the PostgreSQL username (e.g., `keycloak`)
- `POSTGRES_PASSWORD`: the database password (e.g., `supersecret`)
- `POSTGRES_DB`: the name of the database to create on container init (e.g., `keycloakdb`)  
These values are automatically mounted into the PostgreSQL container using the `envFrom` directive.

### ✅ Apply Secret    
```bash
kubectl apply -f k8s/postgres/postgres-secret.yaml
```

### 🔍 Verify Status    
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

### 📁 File  
- `k8s/postgres/postgres-deployment.yaml`

### 📦 Features  
- **Environment variables** (DB name, user, password) are injected securely via a Kubernetes Secret (`postgres-secret`)
- **Persistent data storage** using a `PersistentVolumeClaim` (`postgres-pvc`) mounted at `/var/lib/postgresql/data`
- **Internal accessibility** via a `ClusterIP` service (`postgres`) on port `5432`

### ✅ Apply Manifests  
```bash
kubectl apply -f k8s/postgres/postgres-deployment.yaml
```

### 🔍 Verify Status  
```bash
kubectl get pods
kubectl get svc
kubectl describe pod <postgres-pod-name>
```  
When correctly deployed, the pod should be `Running`, and the service should expose port `5432` internally to other components (e.g., Keycloak).

### 🐞 View Logs  
To check PostgreSQL startup logs or debug issues:
```bash
kubectl logs <postgres-pod-name>
```  
> 💡 **Tip**: If you're using a terminal with `kubectl` shell completion enabled (e.g., in WSL2 with Bash or Zsh), you can press `Tab` after typing `postgres-` to auto-complete the pod name.

---

## 🧩 Keycloak Deployment  
Keycloak is deployed using the official [Bitnami Helm chart](https://artifacthub.io/packages/helm/bitnami/keycloak). It connects to the PostgreSQL instance (deployed separately) and uses a custom `keycloak-values.yaml` file to configure external database access, resource limits, probes, and admin credentials.

### 📁 Files  
- [`k8s/keycloak/keycloak-values.yaml`](k8s/keycloak/keycloak-values.yaml)  

### 🛠️ Prerequisites  
#### 🔧 Install Helm (if not already installed)  
```bash
sudo snap install helm --classic
helm version
```

#### 📦 Add Bitnami Chart Repository  
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### ⚙️ Custom Configuration Highlights  
- **External PostgreSQL** used (embedded DB disabled)
- **Admin credentials** are passed directly in `values.yaml`
- **NodePort exposure** (HTTP: `32080`, HTTPS: `32443`)
- **Resource requests and limits** defined
- **Liveness and readiness probes** enabled and tested

### 🚀 Deploy Keycloak  
```bash
helm install keycloak bitnami/keycloak -n keycloak -f k8s/keycloak/keycloak-values.yaml
```
> 💡 If reinstalling, clean up any existing release with:  
> `helm uninstall keycloak -n keycloak`

### 🔍 Verify Deployment  
```bash
kubectl get pods -n keycloak
kubectl get svc -n keycloak
```  
You should see a pod named `keycloak-0` in the `Running` state and a service exposing the configured NodePort.

### 🔬 Probe Verification  
To verify that **liveness and readiness probes** are working:
1. Get the dynamic NodePort URL:
   ```bash
   minikube service keycloak -n keycloak --url
   ```
2. Test **readiness probe** endpoint using:
   ```bash
   curl -I $(minikube service keycloak -n keycloak --url)/realms/master
   ```
   You should receive an `HTTP/1.1 200 OK` response with realm metadata — confirming readiness.

3. **Liveness probe** is a TCP socket check on the same dynamic port. You can simulate it using:
   ```bash
   nc -zv 127.0.0.1 <dynamic-port>
   ```
   Replace `<dynamic-port>` with the port shown in the `minikube service` output (e.g. `33335`).
> Both probes have been confirmed functional during this deployment.

---

## 🌐 Ingress Configuration
To make services accessible via browser-friendly hostnames, two Ingress resources were created:
- `keycloak.local` for the Keycloak admin console
- `dashboard.local` for the Kubernetes Dashboard

### ✅ Requirements
- The [NGINX Ingress controller](https://minikube.sigs.k8s.io/docs/handbook/ingress/) is enabled via Minikube:
  ```bash
  minikube addons enable ingress
  ```
Ingress manifests are located in:
- [`k8s/keycloak/keycloak-ingress.yaml`](k8s/keycloak/keycloak-ingress.yaml)
- [`k8s/dashboard/dashboard-ingress.yaml`](k8s/dashboard/dashboard-ingress.yaml)

### 🧭 Access in Browser
To use these hostnames in your browser:
1. **Run the Ingress tunnel:**
   ```bash
   minikube tunnel
   ```
   > Keep this terminal open while accessing services. It forwards HTTP/HTTPS traffic to the Ingress controller.
2. **Edit Windows hosts file**  
   Location: `C:\Windows\System32\drivers\etc\hosts`  
   Add the following line:
   ```
   127.0.0.1 keycloak.local dashboard.local
   ```
3. **Open URLs:**
   - http://keycloak.local
   - http://dashboard.local

### 🔐 Authentication Methods
- **Keycloak:** Admin credentials are set via a Kubernetes Secret and passed through Helm values.
- **Kubernetes Dashboard:** Logged in using a ServiceAccount token generated via:
  ```bash
  kubectl -n kubernetes-dashboard create token admin-user
  ```

---

## 🛠️ Quick Start with [`deploy.sh`](deploy.sh)
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
> 🧠 Note: This script is optimized for **WSL2 + Docker Desktop**. If you're using native Linux or macOS, you may need to modify the Minikube driver flag (e.g., `--driver=virtualbox`).

### 🧭 What’s Covered by the Script
This script automates the deployment of the Kubernetes cluster and PostgreSQL database, including persistent storage and secrets. Keycloak and Kubernetes Dashboard are deployed separately using Helm and custom configuration.

---

## 🧾 Extras  
### 🔹 Kubernetes Minikube Cheat Sheet  
A quick-reference guide for working with Minikube and applying manifests. 📄 [View cheat sheet](notes/k8s-minikube-cheatsheet.md)  

### 🔹 Keycloak Admin Access Helper (Pre-Ingress)
Quickly access Keycloak via NodePort in early development.
📄 [keycloak-env-setup.txt](k8s/keycloak/keycloak-env-setup.txt)

---

## 🔒 Optional Hardening & Future Enhancements
- [ ] Helm `upgrade` instead of `install` for re-runs
- [ ] Admin credential rotation policy
- [ ] Backup strategy for PostgreSQL