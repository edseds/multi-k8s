docker build -t edgarsc/multi-client:latest -t edgarsc/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t edgarsc/multi-server:latest -t edgarsc/multi-server:$SHA  -f ./server/Dockerfile ./server
docker build -t edgarsc/multi-worker:latest -t edgarsc/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push edgarsc/multi-client:latest
docker push edgarsc/multi-server:latest
docker push edgarsc/multi-worker:latest

docker push edgarsc/multi-client:$SHA
docker push edgarsc/multi-server:$SHA
docker push edgarsc/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=edgarsc/multi-server:$SHA
kubectl set image deployments/client-deployment client=edgarsc/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=edgarsc/multi-worker:$SHA

kubectl apply -f k8s/postgres-deployment.yaml --force