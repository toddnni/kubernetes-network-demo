echo "# Block ingress to namespace1"
kubectl apply -f closed-ingress-policy.yml
echo "# The ingress doesn't work anymore"
curl -m 2 -v -H Host:hello.example.com http://172.22.101.111
