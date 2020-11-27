echo "# Block egress from namespace2"
kubectl apply -f closed-egress-policy.yml
echo "# Try the reach out"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 172.22.101.101:8080/shell2
