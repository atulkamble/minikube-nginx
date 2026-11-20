# Minikube Kubernetes Practice Lab

A hands-on lab for running a local Kubernetes cluster with Minikube, deploying the repository's custom NGINX image, exposing it with a LoadBalancer Service, and practicing common kubectl operations.

Minikube is intended for local learning, development, and testing. It is not a production Kubernetes platform.

**Architecture:** Windows/Linux/macOS → Docker driver → Minikube node → Kubernetes Deployment → Pods → Service → NGINX

## 1. Prerequisites (Windows)

1. Enable CPU virtualization (**Intel VT-x / AMD-V**) in BIOS/UEFI if it is disabled.
2. Install **Docker Desktop**, select the **WSL 2 backend** (recommended), and ensure Docker Desktop is running.
3. Enable **Virtual Machine Platform** and **Windows Subsystem for Linux** as needed for WSL 2. Windows Hypervisor Platform / Hyper-V may be required for alternative virtualization configurations, but are not mandatory for the Docker driver.
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

## 2. Install tools (Windows)

Install Chocolatey first from its official instructions: https://chocolatey.org/install

```powershell
choco install minikube kubernetes-cli -y
```

Install Docker Desktop from https://www.docker.com/products/docker-desktop/ if needed. Restart the terminal and verify:

```powershell
minikube version
kubectl version --client
docker version
```

## 3. Start and inspect Minikube

Run in a regular PowerShell terminal with Docker Desktop running:

```powershell
minikube start --driver=docker
minikube status
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

The default Minikube configuration commonly creates a single-node cluster. This is useful for learning but does not represent production staging.

### Useful Minikube commands

| Command | Purpose |
|---|---|
| `minikube start` | Start an existing/default cluster |
| `minikube start --driver=docker` | Start using the Docker driver |
| `minikube status` | Check cluster status |
| `minikube ip` | Show the Minikube node IP |
| `minikube ssh` | Open a shell on the Minikube node |
| `minikube stop` | Stop the cluster without deleting it |
| `minikube delete` | Delete the local cluster |

## 4. Add-ons, metrics, and dashboard

List available add-ons, enable the metrics server, and launch the dashboard:

```powershell
minikube addons list
minikube addons enable metrics-server
minikube dashboard
```

The dashboard command may keep its terminal occupied. Open a second terminal for other commands. Check metrics after the metrics-server is ready:

```powershell
kubectl top nodes
kubectl top pods
```

## 5. Get the project and inspect its manifests

Clone this repository and change into its directory:

```bash
git clone https://github.com/atulkamble/minikube-nginx.git
cd minikube-nginx
```

The repository includes:

- `Dockerfile` and `index.html`: build a custom NGINX image with the project web page.
- `deployment.yaml`: runs three replicas of `docker.io/atuljkamble/nginxapp:latest`.
- `service.yaml`: exposes the Pods using a LoadBalancer Service on port 80.

The Deployment selects Pods labelled `app: myapp`; the Service uses the same selector to route traffic to those Pods.

## 6. Deploy and verify

Apply the repository files from the project directory:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl rollout status deployment/mydeployment
kubectl get deployments
kubectl get pods -o wide
kubectl get services
kubectl get endpoints myservice
kubectl get endpointslices -l kubernetes.io/service-name=myservice
```

The Deployment should become available with three Pods. The Service endpoints should point to ready Pods.

### Check the NGINX page

Option A: use Minikube's service helper (often simplest with the Docker driver):

```bash
minikube service myservice
```

This opens the app in a browser or prints a URL. If it starts a tunnel, keep the command running.

Option B: use port-forwarding. Run this in a terminal and leave it open:

```bash
kubectl port-forward service/myservice 8080:80
```

Open **http://localhost:8080** in a browser. To check the response from another terminal:

```bash
curl http://localhost:8080
```

The page should include **“Welcome to my website!”**.

### LoadBalancer tunnel

Use a tunnel when you want Minikube to provide an external address for a LoadBalancer Service. In a separate terminal:

```bash
minikube tunnel
```

Keep it running; it may request elevated permissions. In another terminal, inspect the Service:

```bash
kubectl get svc myservice
```

Use its `EXTERNAL-IP` and port if reachable from your host. With some host and driver combinations, `minikube service myservice` or port-forwarding is more convenient. On Linux, `sudo minikube tunnel` is sometimes used, but is not universally required.

## 7. Scale the Deployment

Scale the NGINX Deployment to five replicas and watch the Pods:

```bash
kubectl scale deployment/mydeployment --replicas=5
kubectl get deployment mydeployment
kubectl get pods -w
```

Stop watching with **Ctrl+C**, then scale back to three:

```bash
kubectl scale deployment/mydeployment --replicas=3
kubectl get pods
```

## 8. Practice a rollout and rollback

Update the Deployment's container image to a versioned NGINX image:

```bash
kubectl set image deployment/mydeployment mycontainer=nginx:1.27-alpine
kubectl rollout status deployment/mydeployment
kubectl rollout history deployment/mydeployment
```

To undo the image change and restore the image configured in the repository manifest:

```bash
kubectl rollout undo deployment/mydeployment
kubectl rollout status deployment/mydeployment
kubectl describe deployment mydeployment
```

To reapply the repository's desired configuration later:

```bash
kubectl apply -f deployment.yaml
```

## 9. Namespaces and kubectl context

Kubernetes creates a `default` namespace for namespaced resources. A plain `kubectl get pods` lists Pods in the current namespace; `-A` lists Pods across all namespaces.

```bash
kubectl config current-context
kubectl config get-contexts
kubectl get namespaces
kubectl get pods -n default
kubectl get pods -A
kubectl get all -n default
```

To use Minikube's context if several clusters are configured:

```bash
kubectl config use-context minikube
```

## 10. Quick command reference

```bash
minikube status
minikube addons list
minikube addons enable metrics-server
minikube dashboard
minikube tunnel
minikube ip

kubectl get nodes
kubectl get pods -A
kubectl get pods
kubectl get services
kubectl get svc
kubectl get ns
```

`kubectl get services` and `kubectl get svc` are equivalent. The dashboard and tunnel commands are long-running; run them in separate terminals and leave them open while using them.

## 11. Troubleshooting

| Problem | Check / fix |
|---|---|
| Docker driver fails | Start Docker Desktop; verify `docker version` |
| Virtualization unavailable | Enable VT-x/AMD-V; confirm WSL 2 configuration |
| No Pods | Check `kubectl get pods -A`, current context, and namespace |
| Pods not ready | Use `kubectl describe pod <pod-name>` and `kubectl logs <pod-name>` |
| Service has no endpoints | Check Pod readiness and the matching `app: myapp` selector |
| `EXTERNAL-IP` shows `<pending>` | Start `minikube tunnel` or use `minikube service myservice` |
| Browser cannot connect | Try `kubectl port-forward service/myservice 8080:80` |
| Metrics unavailable | Wait for metrics-server readiness; inspect its Pods |

Useful diagnostic commands:

```bash
kubectl config current-context
kubectl get all
kubectl describe deployment mydeployment
kubectl describe svc myservice
kubectl logs deployment/mydeployment
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 12. Cleanup

Remove the Service and Deployment, then confirm they are gone:

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl get services
kubectl get deployments
kubectl get pods
```

Stop Minikube but keep the cluster configuration:

```bash
minikube stop
```

To remove the entire local cluster and its configuration:

```bash
minikube delete
```

## 13. Linux and macOS notes

Install Minikube, kubectl, and a supported driver using the platform-specific instructions. With Docker installed and running, the main cluster commands are the same:

```bash
minikube start --driver=docker
kubectl get nodes
minikube addons enable metrics-server
minikube addons enable ingress
minikube dashboard
```

Official documentation: https://minikube.sigs.k8s.io/docs/start/
