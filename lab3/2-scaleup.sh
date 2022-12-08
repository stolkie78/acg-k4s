kubectl edit deployment mongodb -n robot-shop
#Under spec:, look for the line that says replicas: 1 and change it to replicas: 2.
kubectl get deployment mongodb -n robot-shop
