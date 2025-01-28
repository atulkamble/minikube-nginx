# minikube-nginx
Minikube Project runnning nginx container

# Minikube-NGINX Setup

This guide will walk you through running an NGINX app on a Minikube cluster. Follow the instructions below to set up the necessary Kubernetes configurations and deploy your NGINX app.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/) installed and running
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
- Basic knowledge of Kubernetes and YAML configuration files

## Steps

### 1. Start Minikube

First, start your Minikube cluster. This command will initiate a local Kubernetes cluster using Minikube.

```bash
minikube start
```

### 2. Create a Project Directory

Create a new directory for your project and navigate into it.

```bash
mkdir Project
cd ./Project/
```

### 3. Create Deployment File

Now, create a `deployment.yaml` file using the following command. You will edit this file to define the Kubernetes Deployment for NGINX.

```bash
New-Item deployment.yml
New-Item deployment.yaml
rm ./deployment.yml
notepad deployment.yaml
```

Edit the `deployment.yaml` file to define the NGINX deployment. Example content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

### 4. Apply the Deployment

Once the `deployment.yaml` file is ready, apply the deployment configuration to the Minikube cluster.

```bash
kubectl apply -f deployment.yaml
```

### 5. Create Service File

Next, create a `service.yaml` file to expose your NGINX app as a service.

```bash
New-Item service.yaml
notepad service.yaml
```

Edit the `service.yaml` file with the following content:

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

### 6. Apply the Service Configuration

After editing the `service.yaml` file, apply the service configuration.

```bash
kubectl apply -f service.yaml
```

### 7. Verify Kubernetes Resources

Check the nodes and services to ensure that the deployment and service are running.

```bash
kubectl get nodes
kubectl get services
```

### 8. Access the Service

To access your NGINX app, use the following command to open the service in your default browser.

```bash
minikube service access-app-service
```

This will expose your NGINX app on a Minikube local IP.

## Conclusion

Now you have successfully deployed an NGINX application on Minikube and exposed it through a Kubernetes service. You can modify the deployment and service configurations as needed.

For more information, check the [Minikube documentation](https://minikube.sigs.k8s.io/docs/) and the [Kubernetes documentation](https://kubernetes.io/docs/).


