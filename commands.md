Here’s an extended list of Kubernetes operations and tasks you can perform as part of your project, along with the respective commands. These tasks can enhance your project and provide a deeper understanding of Kubernetes concepts.

---

## 1. **View Cluster Information**

### Commands:
```bash
kubectl cluster-info
kubectl get nodes
kubectl describe nodes
```

---

## 2. **Inspect Resources**

### Commands:
```bash
kubectl get pods
kubectl get deployments
kubectl get services
kubectl describe pod <pod-name>
kubectl describe deployment <deployment-name>
kubectl describe service <service-name>
```

---

## 3. **Scale the Deployment**

Increase or decrease the number of replicas for the NGINX deployment.

### Commands:
```bash
kubectl scale deployment nginx-deployment --replicas=5
kubectl get pods
```

---

## 4. **Update the Deployment**

Update the NGINX version in the deployment to a new version.

### Commands:
1. Edit the deployment:
   ```bash
   kubectl edit deployment nginx-deployment
   ```
   Change the `image: nginx:latest` to `image: nginx:<new-version>`.

2. Roll out the update:
   ```bash
   kubectl rollout status deployment nginx-deployment
   ```

---

## 5. **Rollback to a Previous Version**

If the updated version causes issues, rollback to a previous working version.

### Commands:
```bash
kubectl rollout undo deployment nginx-deployment
kubectl rollout history deployment nginx-deployment
```

---

## 6. **View Logs**

Inspect logs for a specific pod to debug or monitor the application.

### Commands:
```bash
kubectl get pods
kubectl logs <pod-name>
```

---

## 7. **Execute Commands Inside a Pod**

Run commands inside the NGINX pod for troubleshooting or testing.

### Commands:
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

---

## 8. **Expose Deployment as a Service**

If not already exposed, expose the deployment as a LoadBalancer or ClusterIP service.

### Commands:
1. Expose the deployment:
   ```bash
   kubectl expose deployment nginx-deployment --type=NodePort --port=80
   ```

2. View the service:
   ```bash
   kubectl get services
   ```

---

## 9. **Port Forwarding**

Access the NGINX application directly using port forwarding.

### Commands:
```bash
kubectl port-forward <pod-name> 8080:80
```
Now access it locally at `http://localhost:8080`.

---

## 10. **Delete Resources**

Clean up resources when no longer needed.

### Commands:
```bash
kubectl delete deployment nginx-deployment
kubectl delete service access-app-service
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

---

## 11. **Create ConfigMaps**

Use ConfigMaps to manage configuration files or environment variables.

### Commands:
1. Create a ConfigMap:
   ```bash
   kubectl create configmap nginx-config --from-literal=env=production
   ```

2. Use the ConfigMap in the deployment:
   Update the deployment YAML to include:
   ```yaml
   env:
   - name: ENV
     valueFrom:
       configMapKeyRef:
         name: nginx-config
         key: env
   ```

3. Apply changes:
   ```bash
   kubectl apply -f deployment.yaml
   ```

---

## 12. **Create Secrets**

Store sensitive information such as credentials using Kubernetes Secrets.

### Commands:
1. Create a Secret:
   ```bash
   kubectl create secret generic nginx-secret --from-literal=username=admin --from-literal=password=secret123
   ```

2. Use the Secret in the deployment:
   Update the deployment YAML to include:
   ```yaml
   env:
   - name: USERNAME
     valueFrom:
       secretKeyRef:
         name: nginx-secret
         key: username
   - name: PASSWORD
     valueFrom:
       secretKeyRef:
         name: nginx-secret
         key: password
   ```

3. Apply changes:
   ```bash
   kubectl apply -f deployment.yaml
   ```

---

## 13. **Resource Limits**

Set resource limits for the NGINX container to prevent resource overuse.

### Deployment YAML Example:
```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

### Commands:
```bash
kubectl apply -f deployment.yaml
```

---

## 14. **Monitor Resource Usage**

Use `kubectl top` to monitor resource consumption.

### Commands:
```bash
kubectl top nodes
kubectl top pods
```

---

## 15. **Run Jobs or CronJobs**

Run one-off tasks or scheduled jobs using Kubernetes Jobs or CronJobs.

### Job YAML Example:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: nginx-job
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:latest
      restartPolicy: OnFailure
```

### Commands:
```bash
kubectl apply -f job.yaml
kubectl get jobs
```

---

## 16. **Auto-healing with Readiness and Liveness Probes**

Add readiness and liveness probes to ensure that pods are healthy.

### Deployment YAML Example:
```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 10
```

### Commands:
```bash
kubectl apply -f deployment.yaml
```

---

## 17. **Enable Dashboard**

Access the Kubernetes Dashboard for a graphical interface.

### Commands:
```bash
minikube dashboard
```

---

## 18. **Use Helm Charts**

Deploy NGINX using a Helm chart for more flexibility.

### Commands:
```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm install nginx-app nginx-stable/nginx-ingress
```

---

## 19. **Inspect Events**

View cluster events for insights into resource activities.

### Commands:
```bash
kubectl get events
```

---

## 20. **Test Network Policies**

Set up network policies to control traffic flow.

### Example YAML:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-nginx
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
```

### Commands:
```bash
kubectl apply -f network-policy.yaml
```

---

These tasks cover a wide range of Kubernetes operations, from basic resource management to advanced configurations. Let me know if you'd like to expand on any of these topics!
