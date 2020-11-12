#! /bin/bash
## delete if any dashboard related stuff present
kubectl delete namespaces kubernetes-dashboard
kubectl delete clusterrolebinding dashboard-admin-sa
kubectl delete serviceaccount dashboard-admin-sa
secret=`kubectl get secrets | grep dash | awk '{print $1}'`
kubectl delete secret $secret
## create new dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
name=`kubectl get secrets| grep dash | awk '{print $1}'`
kubectl describe secret $name
echo "============ USE THIS TOKEN FOR DASHBOARD ================="

echo "Dashboard URL:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

