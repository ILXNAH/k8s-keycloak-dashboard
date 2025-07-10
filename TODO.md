# ✅ DevOps Case Study – To-Do List

This checklist is based on the official task description for the Kubernetes deployment case study.

---

## ⏳ Time Plan (Full Scope – All Bonuses Included)

This plan reflects the full feature set including all "bonus" tasks as **required work**.  
Time estimates are beginner-friendly and organized to help meet the Sunday deadline.

### 🕒 Estimated Total: **~18–22 hours**

| Section                        | Est. Time        | Notes |
|-------------------------------|------------------|-------|
| Kubernetes cluster setup      | 2.5–3 hours      | Learn/setup kubeadm or Minikube |
| PostgreSQL deployment         | 2–2.5 hours      | Includes probes + resource limits |
| Keycloak via Helm             | 3–3.5 hours      | Includes learning Helm, configuring secrets, probes, resources |
| Kubernetes Dashboard          | 1.5–2 hours      | Includes RBAC, token setup, Ingress, probes |
| Ingress (NGINX + rules)       | 2–2.5 hours      | Covers full HTTP config and testing |
| Documentation & diagram       | 2.5–3 hours      | README + optional architecture diagram |
| Automation script             | 0.5–1 hour       | Bash script (e.g. `deploy.sh`) |
| TLS + improvement planning    | 1.5–2 hours      | cert-manager, and write future ideas |
| Final testing + GitHub polish | 1–1.5 hours      | End-to-end test + push final version |

---

### 📆 4-Day Plan to Finish by Sunday (All Bonuses Included)

| Day       | Focus Areas                                                    | Est. Time |
|-----------|----------------------------------------------------------------|-----------|
| **Wed**   | Cluster setup, PostgreSQL (PVC, probes, resources)              | ~3–4 hrs |
| **Thu**   | Helm + Keycloak (external DB, secrets, probes, limits)         | ~4–5 hrs |
| **Fri**   | Dashboard, Ingress, TLS (cert-manager), token login            | ~4–5 hrs |
| **Sat**   | Automation script, full README, architecture diagram, polish   | ~5–6 hrs |
| **Sun**   | Final walkthrough, testing, GitHub cleanup                     | ~1 hr    |

---

## 🧱 Objective

Deploy a complete environment on a **self-managed Kubernetes cluster** consisting of:

- [ ] PostgreSQL (with persistent storage)
- [ ] Keycloak (backed by PostgreSQL, not H2)
- [ ] Kubernetes Dashboard
- [ ] Ingress to expose Keycloak & Dashboard over HTTP (HTTPS = bonus)

---

## 🔧 Kubernetes Cluster Setup

- [ ] Create a **single-node Kubernetes cluster** on Linux (Ubuntu preferred)
- [ ] Can be installed in a local VM
- [ ] Any installation method allowed (e.g. `kubeadm`, Minikube with care, etc.)

---

## 📦 PostgreSQL

- [ ] Deploy PostgreSQL with:
  - [ ] PersistentVolumeClaim for storage (stay available after restarts)
  - [ ] Standalone container (no bundling with Keycloak)
  - [ ] Exposed via internal K8s service

---

## 🧩 Keycloak

- [ ] Deploy standalone Keycloak container
- [ ] Use PostgreSQL as its backend (no embedded H2 database)
- [ ] Expose Keycloak admin console via web (web browser accessible)
- [ ] Store admin credentials securely (e.g., secret/env)

---

## 🖥️ Kubernetes Dashboard

- [ ] Deploy official Kubernetes Dashboard
- [ ] Web-accessible via Ingress
- [ ] Token-based login (or other method, must be described)

---

## 🌐 Ingress Setup

- [ ] Install and configure Ingress Controller (e.g. NGINX)
- [ ] Create Ingress rules for:
  - [ ] Keycloak (e.g. `keycloak.local`)
  - [ ] Kubernetes Dashboard (e.g. `dashboard.local`)
- [ ] HTTPS support via cert-manager

---

## 📚 Documentation (README content)

- [ ] Describe tested environment (OS, K8s version, etc.)
- [ ] How to deploy each component
- [ ] Ingress routes (hostnames, ports) & `/etc/hosts` setup
- [ ] Login instructions for Keycloak admin console and Kubernetes Dashboard
- [ ] Explain how components work together:
  - [ ] Role of Ingress
  - [ ] Keycloak → PostgreSQL link
- [ ] Add architecture diagram

---

## 🔧 Advanced Configuration Features

- [ ] Automation script (e.g. in bash, `deploy.sh`)
- [ ] Use liveness and readiness probes
- [ ] Set resource requests and limits
- [ ] Mention future improvements:
  - [ ] TLS support
  - [ ] HA/scaling
  - [ ] Monitoring
  - [ ] Backup strategy

---

## 📤 Final Output

- [ ] All manifests in GitHub repo
- [ ] Clean, readable YAML
- [ ] Helm chart(s) for at least one component (e.g. Keycloak via Bitnami chart with embedded DB disabled and customized values.yaml, with PostgreSQL and Ingress configured manually)
- [ ] Well-structured README
- [ ] Helpful comments or inline notes