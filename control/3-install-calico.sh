#On the control plane node, install Calico Networking:
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#Check status of the control plane node:
kubectl get nodes
sleep 120
kubectl get nodes
