# create a pod named frontend using image nginx
kubectl run frontend --image nginx

# create a pod named backend using image nginx
kubectl run backend --image nginx

# create a service from the frontend pod on port 80
kubectl expose po frontend --port 80

# create a service form the backend pod on port 80
kubectl expose po backend --port 80

# list all services and pods in the default namespace
kubectl get svc,po

# run a curl command inside the frontend container to access the backend service by IP address
kubectl exec frontend -- curl 10.102.36.75

# run a curl command inside the backend container to access the frontend service by the service IP address
kubectl exec backend -- curl 10.111.252.117

# create the YAML that will deny all network traffic in the cluster
vim deny-all.yml

# copy in the contents from deny-all.yml

# create the deny all network policy via YAML
kubectl create -f deny-all.yml

# try again to access the backend from the frontend, and you will be denied
kubectl exec frontend -- curl --connect-timeout 2 10.102.36.75

# try again to access the frontend from the backend and you will be denied
kubectl exec backend -- curl --connect-timeout 2 10.111.252.117

# to allow access from frontend to backend, create a file named frontend.yml
vim frontend.yml

# paste in the yml from frontend-network-policy.yml

# create the network policy
kubectl create -f frontend.yml

# this still will not allow traffic until the backend pods have the ingress rule (has to work both ways)
vim backend.yml

# paste in the contents from backend-network-policy.yml

# create the network policy
kubectl create -f backend.yml

# now you can connect to the backend pod from the frontend pod via it's service IP address
kubectl exec frontend -- curl 10.102.36.75

