# 📅 Day 1 Recap – Kubernetes Cluster & PostgreSQL Setup
This summary documents the work planned and completed for **Day 1** of the Kubernetes DevOps case study.

---

## ✅ Cluster Setup Strategy
### Chosen Method: **Minikube**
Minikube was selected for its simplicity, reproducibility, and fast local setup — ideal for a public GitHub project.

### Justification:
- Runs on a local Linux VM (compliant with the task)
- Supports all required features (Ingress, persistent volumes, Helm)
- Beginner-friendly and easy to reset
- Does not violate any case study restrictions

---

## 🔧 Kubernetes Cluster Setup (Minikube)
Tasks:
- [x] Decide on Minikube as the runtime
- [x] Install Minikube on local Ubuntu
- [x] Start cluster with recommended settings (optimized for WSL2 + Docker Desktop):
  ```bash
  minikube start --driver=docker
  ```
- [x] Enable Ingress addon:
  ```bash
  minikube addons enable ingress
  ```
- [x] Test cluster health:
  ```bash
  kubectl get nodes
  kubectl get pods -A
  ```

---

## 📦 PostgreSQL Setup (Planned for Later Today)
To be done after confirming Minikube setup:

- [x] Write PersistentVolumeClaim (PVC)
- [x] Create PostgreSQL Deployment using official image
- [x] Set credentials and DB name via Secret or env vars
- [x] Expose PostgreSQL via ClusterIP service
- [x] Verify pod and volume status

---

## ⏳ Time Estimate (Today)
| Task                    | Time        |
|-------------------------|-------------|
| Minikube setup          | ~1.5–2 hrs  |
| PostgreSQL manifests    | ~1.5–2 hrs  |
| **Total for Day 1** | **~3–4 hrs** |

---

## 🗒️ Notes
- Kubeadm was evaluated but deemed too complex for a portable demo project
- All decisions align with the case study requirements
- Setup steps will be documented in detail in [setup/cluster-setup.md](setup/cluster-setup.md)