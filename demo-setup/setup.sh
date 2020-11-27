cd $(dirname $0)

sudo apt-get install -y curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl
sudo install kubectl /usr/local/bin/

kubectl label node node-01 zone=A
kubectl label node node-02 zone=B

kubectl apply -f namespace1.yml
kubectl apply -f namespace2.yml
kubectl apply -f app.yml
kubectl apply -f shell1.yml
kubectl apply -f shell2.yml

