# 🚀 Minikube + NGINX Deployment Guide

**Deploying & Exposing NGINX on Local Kubernetes (Minikube Lab)**

This document provides a structured, step-by-step guide to deploy an **NGINX application** on a local Kubernetes cluster using Minikube and expose it through a Kubernetes Service.

---

# 🧰 1️⃣ Prerequisites

Ensure the following tools are installed and running:

* ✅ **Docker Desktop** (running in background)
* ✅ **Minikube**
* ✅ **kubectl**
* ✅ Stable Internet connection
* ✅ Basic understanding of Kubernetes YAML files

Verify installations:

```bash
minikube version
kubectl version --client
docker --version
```

---

# 🏁 2️⃣ Start Minikube Cluster

Start your local Kubernetes cluster:

```bash
minikube start
minikube status
```

Verify cluster node:

```bash
kubectl get nodes
```

Expected Output:

```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   ...
```

---

# ⚙️ 3️⃣ (Optional) Enable Useful Addons

List available addons:

```bash
minikube addons list
```

Enable Metrics Server (for monitoring):

```bash
minikube addons enable metrics-server
```

Open Kubernetes Dashboard:

```bash
minikube dashboard
```

---

# 📁 4️⃣ Create Project Directory

```bash
mkdir minikube-nginx
cd minikube-nginx
```

---

# 📝 5️⃣ Create Deployment YAML

Create file:

```bash
touch deployment.yaml
```

### 📄 `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: access-app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Apply Deployment

```bash
kubectl apply -f deployment.yaml
```

Verify:

```bash
kubectl get deployments
kubectl get pods
```

---

# 🌐 6️⃣ Create Service YAML (Expose Application)

Create file:

```bash
touch service.yaml
```

### 📄 `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: access-app-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

### Apply Service

```bash
kubectl apply -f service.yaml
```

Verify:

```bash
kubectl get services
```

---

# 🌍 7️⃣ Access Application

### Option 1: Using Minikube Service (Recommended)

```bash
minikube service access-app-service
```

This will automatically open the NGINX application in your browser.

---

### Option 2: If Service Type is LoadBalancer

For LoadBalancer support in Minikube:

```bash
minikube tunnel
```

Keep this running in a separate terminal.

---

# 📈 8️⃣ Scaling the Application

Update replicas in `deployment.yaml`:

```yaml
replicas: 5
```

Apply changes:

```bash
kubectl apply -f deployment.yaml
```

Verify:

```bash
kubectl get pods
```

You should now see 5 running pods.

---

# 📊 9️⃣ Monitoring & Resource Usage

After enabling metrics-server:

```bash
kubectl top nodes
kubectl top pods
```

---

# 🔄 1️⃣0️⃣ Common kubectl Commands

```bash
kubectl get all
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

---

# ☁️ Deploying on Azure Kubernetes Service (AKS)

On AKS, expose deployment using LoadBalancer:

```bash
kubectl expose deployment access-app-deployment \
  --name=access-app-service \
  --type=LoadBalancer \
  --port=80 \
  --target-port=80
```

Then check external IP:

```bash
kubectl get services
```

---

# 🧪 Lab Validation Checklist

✔ Minikube started
✔ Deployment created
✔ Pods running
✔ Service exposed
✔ Application accessible in browser
✔ Scaling verified
✔ Monitoring enabled

---

# 📌 Summary

This lab demonstrated:

* Kubernetes Deployment creation
* Replica management
* Service exposure (NodePort / LoadBalancer)
* Local cluster management with Minikube
* Basic monitoring using metrics-server

