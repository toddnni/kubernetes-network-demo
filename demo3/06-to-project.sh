echo "# Ensure that namespace1 is closed"
kubectl apply -f closed-ingress-policy.yml
echo "# We are not able to access the app in another project"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 echoserver.namespace1.svc.cluster.local
echo "# Lazy open all egress"
kubectl apply -f open-egress-policy.yml
echo "# Try, does not work yet"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 echoserver.namespace1.svc.cluster.local
echo "# Open only this one app"
kubectl apply -f demo-ingress-policy.yml
echo "# Try again, now is able to access"
kubectl exec -it -n namespace2 deployment/shell2 -- curl -m 2 echoserver.namespace1.svc.cluster.local
