# 📅 Day 2 Plan – Keycloak via Helm  
This checklist outlines the work planned for **Day 2** of the Kubernetes DevOps case study.

---

## 🧩 Keycloak Deployment Strategy  
### Method: **Helm (Bitnami Chart)**  
The official Bitnami Helm chart will be used to deploy Keycloak.  
PostgreSQL will **not** be bundled — it will connect to the existing standalone DB deployed on Day 1.

### Justification:  
- Meets the requirement to deploy Keycloak independently
- Avoids H2 (uses external Postgres)
- Helm is reusable and customizable
- Allows to inject secrets and config via `values.yaml`

---

## 🔧 Keycloak Setup Tasks (Planned)  
To be done using Helm:  
- [x] Add Bitnami Helm repo
- [x] Create `keycloak-values.yaml`
- [ ] Set external DB config (host, user, password, db name)
- [ ] Set admin user credentials via secret
- [ ] Configure resource limits and probes
- [ ] Install chart with custom values
- [ ] Verify Keycloak pod is running
- [ ] Access admin console via NodePort (temporary check)

---

## ⏳ Time Estimate (Today)  
| Task                          | Time       |
|-------------------------------|------------|
| Add Helm repo + values.yaml   | ~1 hr      |
| External DB + secret config   | ~1 hr      |
| Deploy Keycloak via Helm      | ~1 hr      |
| Test + document everything    | ~1 hr      |
| **Total for Day 2**           | **~4 hrs** |

---

## 🗒️ Notes  
- Chart used: [bitnami/keycloak](https://artifacthub.io/packages/helm/bitnami/keycloak)
- Database section in `values.yaml` will disable the embedded PostgreSQL and link to the external ClusterIP service
- Setup will be extended later with Ingress and TLS (planned for Day 3)  