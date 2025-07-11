## 🏗️ Cluster Setup
To set up the Kubernetes cluster used in this project, follow the instructions in  
👉 [setup/cluster-setup.md](setup/cluster-setup.md)

---

## 🧪 Tested Environment
The project was built and tested on the following environment:

```
Client Version: v1.32.2  
Kustomize Version: v5.5.0  
Server Version: v1.32.0  

Kubernetes control plane is running at https://127.0.0.1:50512  
CoreDNS is running at https://127.0.0.1:50512/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

Minikube was used with the Docker driver on Ubuntu 24.04 running under WSL2.  
Ingress addon and Kubernetes Dashboard were both enabled and verified.

---

## 🧾 Extras
### 🔹 Kubernetes Minikube Cheat Sheet
A quick-reference guide for working with Minikube and applying manifests.

📄 [View cheat sheet](notes/k8s-minikube-cheatsheet.md)
