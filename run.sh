docker build -t onek0708/jpetstore:v2 .
docker push onek0708/jpetstore:v2

kubectl create ns jpetstore
kubectl apply -f deployment.yaml -n jpetstore
kubectl apply -f service.yaml -n jpetstore
kubectl apply -f ingress.yaml -n jpetstore
