# ✅ DevOps Case Study – To-Do List
This checklist is based on the official task description for the Kubernetes deployment case study.

---

## ⏳ Time Plan (Full Scope – All Bonuses Included)  
This plan reflects the full feature set including all "bonus" tasks as **required work**.  
Time estimates are beginner-friendly and organized to help meet the Sunday deadline.

### 🕒 Estimated Total: **~18–22 hours**  
| Section                        | Est. Time        | Notes |
|-------------------------------|------------------|-------|
| Kubernetes cluster setup      | 2.5–3 hours      | Learn/setup Minikube with Ingress |
| PostgreSQL deployment         | 2–2.5 hours      | Includes PVC, probes, resources |
| Keycloak via Helm             | 3–3.5 hours      | Includes Helm basics, secrets, limits |
| Kubernetes Dashboard          | 1.5–2 hours      | Includes RBAC, Ingress, token login |
| Ingress (NGINX + rules)       | 2–2.5 hours      | Full HTTP config and testing |
| Documentation & diagram       | 3–3.5 hours      | README + Lucidchart architecture |
| Automation script             | 0.5–1 hour       | Bash-based (e.g. `deploy.sh`) |
| TLS + improvement planning    | 1.5–2 hours      | cert-manager + future ideas |
| Final testing + GitHub polish | 1–1.5 hours      | End-to-end test + push |

---

### 📆 Updated 4-Day Plan (Started on Thursday)  
| Day       | Focus Areas                                                    | Est. Time |
|-----------|----------------------------------------------------------------|-----------|
| **Thu**   | ✅ Cluster setup (complete) <br> ✅ PostgreSQL (complete)     | ~3–4 hrs |
| **Fri**   | Keycloak via Helm (external DB, secrets, probes, limits)       | ~4–5 hrs |
| **Sat**   | Dashboard, Ingress, TLS (cert-manager), token login            | ~4–5 hrs |
| **Sun**   | Diagram (Lucidchart), automation script, README polish <br> Final testing & GitHub cleanup | ~6–7 hrs |

---

## 🧱 Objective  
Deploy a complete environment on a **self-managed Kubernetes cluster** consisting of:

- [x] Kubernetes cluster (Minikube with Ingress)
- [x] PostgreSQL (with persistent storage)
- [ ] Keycloak (backed by PostgreSQL, not H2)
- [ ] Kubernetes Dashboard
- [ ] Ingress to expose Keycloak & Dashboard over HTTP (HTTPS = bonus)

---

## 🔧 Kubernetes Cluster Setup  
- [x] Create a **single-node Kubernetes cluster** on Linux (WSL2 Ubuntu 24.04.2 LTS)
- [x] Can be installed in a local VM
- [x] Any installation method allowed (Minikube)

---

## 📦 PostgreSQL  
- [x] Deploy PostgreSQL with:
  - [x] PersistentVolumeClaim for storage (stay available after restarts)
  - [x] Standalone container (no bundling with Keycloak)
  - [x] Exposed via internal K8s service

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
- [ ] Add architecture diagram using **Lucidchart**:
  - Show interaction between components:
    - External user
    - Ingress Controller
    - Keycloak
    - PostgreSQL
    - Kubernetes Dashboard
  - Include arrows to represent traffic flow (HTTP/Ingress, internal service links)
  - Export diagram as PNG and save to `notes/architecture.png`
  - Embed in README with:
    ```md
    ![Architecture Diagram](notes/architecture.png)
    ```

---

## 🔧 Advanced Configuration Features
- [x] Automation script (e.g. in bash, `deploy.sh`)
- [ ] Cross-platform testing & optimization for `deploy.sh`  
  - Verify on native Linux, macOS, and non-Docker environments  
  - Improve driver detection or provide CLI flags  
  - Add fallback messages or better portability where needed
- [ ] Optional automation script for Keycloak (`deploy-keycloak.sh`)
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