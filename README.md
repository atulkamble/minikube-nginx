# Minikube Kubernetes Practice Lab

## 1. Objective

Install and configure **Minikube**, run a local Kubernetes cluster, deploy NGINX, expose it through a Service, and verify application access.

**Minikube** is primarily for local learning, development, and testing. It is not a production Kubernetes platform.

**Architecture:** Windows/Linux/macOS → Docker (driver) → Minikube node → Kubernetes Deployment → Pods → Service → NGINX

## 2. Prerequisites (Windows)

1. Enable CPU virtualization (**Intel VT-x / AMD-V**) in BIOS/UEFI if it is disabled.
2. Install **Docker Desktop**, select the **WSL 2 backend** (recommended), and ensure Docker Desktop is running.
3. Enable **Virtual Machine Platform** and **Windows Subsystem for Linux** as needed for WSL 2. Windows Hypervisor Platform / Hyper-V may be required for alternative virtualization configurations, but are **not mandatory for the Docker driver**.
4. Restart Windows after changing virtualization or Windows features.
5. Use **PowerShell as Administrator** for installation steps.

Check virtualization in **Task Manager → Performance → CPU → Virtualization**.

For WSL 2 setup (Admin PowerShell):

```powershell
wsl --install
wsl --update
wsl --status
```

Restart if prompted. Install and start Docker Desktop separately.

## 3. Install tools (Windows)

Install Chocolatey first from its official instructions: https://chocolatey.org/install

```powershell
choco install minikube kubernetes-cli -y
```

Install Docker Desktop from https://www.docker.com/products/docker-desktop/ if it is not already installed. Restart the terminal and verify:

```powershell
minikube version
kubectl version --client
docker version
```

## 4. Start and verify Minikube

Run in a regular PowerShell terminal with Docker Desktop running:

```powershell
minikube start --driver=docker
minikube status
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

> The default Minikube configuration commonly creates a single-node cluster. For training, it can simulate a small local environment; do not treat it as production staging.

## 5. Minikube lifecycle commands

| Command | Purpose |
|---|---|
| `minikube start` | Start an existing/default cluster |
| `minikube start --driver=docker` | Start using Docker driver |
| `minikube status` | Check cluster status |
| `minikube stop` | Stop cluster without deleting it |
| `minikube delete` | Delete the cluster |
| `minikube ip` | Show Minikube node IP |
| `minikube ssh` | Open a shell on the Minikube node |
| `kubectl cluster-info` | Show Kubernetes control-plane information |
| `kubectl get nodes -o wide` | Inspect cluster nodes |

## 6. Enable add-ons and dashboard

```powershell
minikube addons list
minikube addons enable metrics-server
minikube addons enable ingress
minikube dashboard
```

`minikube dashboard` launches the Kubernetes dashboard (and may keep the terminal occupied). Open a second terminal for other commands.

Check resource metrics after the metrics-server is ready:

```powershell
kubectl top nodes
kubectl top pods
```

## 7. Create NGINX Deployment

Create **deployment.yaml**:

```yamlapiVersion: apps/v1
kind: Deployment
metadata:
  name: mydeployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: mycontainer
        image: nginx:latest
```

## 8. Create LoadBalancer Service

Create **service.yaml**:

```yaml

apiVersion: v1
kind: Service
metadata:
  name: myservice
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30007
```

The Service selector must match the Pod label `app: myapp`.

## 9. Deploy and verify

Run from the directory containing both YAML files:

```powershell
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get deployments
kubectl get pods -o wide
kubectl get svc
kubectl get endpoints myservice
kubectl get endpointslices -l kubernetes.io/service-name=myservice
kubectl rollout status deployment/mydeployment
```

## 10. Access the application

**Option A — Recommended simple access (Docker driver):**

```powershell
minikube service myservice
```

This opens the application in a browser or prints a reachable URL. Keep the command running if it starts a tunnel.

**Option B — LoadBalancer tunnel:**

In a separate terminal, run:

```powershell
minikube tunnel
```

Keep it running. It may request elevated permissions. In another terminal:

```powershell
kubectl get svc myservice
```

Use the assigned `EXTERNAL-IP` and Service port when reachable from your host. On some host/driver combinations, use `minikube service myservice --url` instead of assuming the LoadBalancer IP is directly reachable.

**Option C — Port forwarding:**

```powershell
kubectl port-forward service/myservice 8080:80
```

```
docker buildx build --platform linux/amd64,linux/arm64 -t docker.io/atuljkamble/nginxapp --push .
docker.io/atuljkamble/nginxapp:latest

```
Open **http://localhost:8080** in a browser. Keep the terminal open while testing.

> On Linux, `sudo minikube tunnel` is sometimes used, but it is not a universal requirement. On Windows, run `minikube tunnel` in PowerShell and approve elevation if requested.

## 11. Troubleshooting

| Problem | Check / fix |
|---|---|
| Docker driver fails | Start Docker Desktop; verify `docker version` |
| Virtualization unavailable | Enable VT-x/AMD-V; confirm WSL 2 configuration |
| No Pods | `kubectl get pods -A` and confirm namespace/context |
| Pods not ready | `kubectl describe pods` and `kubectl logs deployment/mydeployment` |
| Service has no endpoints | Check Pod readiness and `app: myapp` selector |
| `EXTERNAL-IP` shows `<pending>` | Start `minikube tunnel` or use `minikube service myservice` |
| Browser cannot connect | Use `kubectl port-forward service/myservice 8080:80` |
| Metrics unavailable | Wait for metrics-server readiness; inspect its Pods |

Useful commands:

```powershell
kubectl config current-context
kubectl get all
kubectl describe deployment mydeployment
kubectl describe svc myservice
kubectl logs deployment/mydeployment
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 12. Cleanup

```powershell
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
minikube stop
```

To remove the entire local cluster:

```powershell
minikube delete
```

## 13. Linux and macOS notes

Minikube also supports Ubuntu, RHEL-compatible Linux, and macOS. Install Minikube, kubectl, and a supported driver using their platform-specific installation instructions. With Docker installed and running, the Kubernetes lab commands remain the same:

```bash
minikube start --driver=docker
kubectl get nodes
minikube addons enable metrics-server
minikube addons enable ingress
minikube dashboard
```

Official documentation: https://minikube.sigs.k8s.io/docs/start/
