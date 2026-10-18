// minikube 

// Prerequisites 
BIOS - VTX Support ON (Virtulization)

WINDOWS Features - ON/OFF
Hypervisor
Virtual Platform
WSL

>> Restart

local single node k8s cluster - minikube 

Windows machine/Local/Ubuntu/RHEL

- staging 

- virtulization tool (vmware, vbox) - Docker Desktop 

powershell >> run as admin >> 

choco install minikube 
minikube start 
kubectl get nodes 

minikube status
minikube stop 
minikube delete

kubectl cluster-info

minikube addons enabvle metrics-server
minikube addons enable ingress
minikube addons list 

minikube dashboard 

minikube start --driver=docker

// minikube dashboard 

// sudo minikube tunnel 

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

kubectl get pods
kubectl get svc

kubectl get endpoints myservice



