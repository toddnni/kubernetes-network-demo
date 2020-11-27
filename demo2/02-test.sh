kubectl exec -it -n namespace1 deployment/shell1 -- curl -m 1 172.22.101.101:8080/shell1
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 1 172.22.101.101:8080/shell2
