# 🏗️ Cluster Setup Guide (Minikube on Ubuntu)

This guide explains how to set up a **single-node Kubernetes cluster** using **Minikube** on a Linux machine (Ubuntu 22.04+).  
This setup is intended for local testing of this DevOps case study.

---

## 📋 Prerequisites

Make sure you are running this inside a Linux-based environment with sudo access (e.g., local Ubuntu VM).

### Recommended system resources:

- 🧠 **RAM**: 6 GB
- 🖥️ **CPUs**: 4
- 💾 **Disk**: 20+ GB free space

---

## 🧰 Step 1 – Install Dependencies

Make sure the following tools are installed and working:

- ✅ [Docker](https://www.docker.com/) – used as the container runtime
- ✅ [`kubectl`](https://kubernetes.io/docs/tasks/tools/) – Kubernetes CLI
- ✅ [`minikube`](https://minikube.sigs.k8s.io/docs/start/) – for running a local single-node cluster

---

## 🚀 Step 2 – Start the Cluster

Start a local Kubernetes cluster using Minikube with the Docker driver.

```bash
minikube start --driver=docker
```

> ✅ This setup uses the Docker driver, which is well-suited for local development.  
> ⚠️ If you're on **WSL2**, ensure Docker Desktop is running before starting Minikube.

---

## 🌐 Step 3 – Enable Ingress

Enable the built-in NGINX Ingress controller in Minikube:

```bash
minikube addons enable ingress
```

> ✅ This will deploy the Ingress controller into the `ingress-nginx` namespace.  
> It may take a few moments before all related pods are up and running.

You can check the deployment status with:

```bash
kubectl get pods -n ingress-nginx
```

---

## 🔍 Step 4 – Verify Cluster is Running

After starting the cluster and enabling Ingress, confirm that everything is healthy:

```bash
kubectl get nodes
```

You should see output similar to:

```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   5m    v1.32.0
```

Check all running pods across namespaces:

```bash
kubectl get pods -A
```

Look for:
- `READY` = all containers should be `1/1` (or `Completed`)
- Ingress controller running in `ingress-nginx` namespace
- System pods in `kube-system` namespace

> ✅ If everything is running or completed, your cluster is good to go!

---

### 📋 (Optional) Cluster Metadata

You can also collect some version and environment details for documentation:

```bash
kubectl version
kubectl cluster-info

---

## 🧪 Step 5 – Test Dashboard (Optional)

To open the Kubernetes dashboard in your browser:

```bash
minikube dashboard
```

> ⚠️ If you're using WSL and encounter an error opening the dashboard in your browser,  
> you can fix this by setting a custom browser script. Example fix:
>
> ```bash
> export BROWSER="/home/your-user/scripts/open-chrome.sh"
> ```
>
> Add the line above to your `~/.bashrc` (and optionally to root’s) to make it persistent.  
> Below is the content of the script used in this project:
>
> ```bash
> #!/bin/bash
> /mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe --profile-directory="Profile 1" "$@"
> ```

---

## 🧹 Cleanup

To stop and remove the cluster:

```bash
minikube delete
```

---

## ✅ What's Next?

Once your cluster is ready, continue with deploying the application components from the [k8s/](../k8s/) directory.
