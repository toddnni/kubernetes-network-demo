echo "# Block ingress to namespace1"
kubectl apply -f closed-ingress-policy.yml
echo "# This still works, because of the host networking"
curl -m 2 -v -H Host:hello.example.com http://172.22.101.111
