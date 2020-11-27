echo "# Allow egress to server-01"
kubectl apply -f demo-egress-policy.yml
echo "# Try the reach again, and now works"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 172.22.101.101:8080/shell2
echo "# This will time out, should be rejected if not blocked"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 172.22.101.101:8081/shell2
echo "# Even ping times out"
kubectl exec -it -n namespace2 deployment/shell2 -- ping -c 2 172.22.101.101
