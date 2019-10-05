#!/bin/bash

# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

kubectl run hostnames --image=k8s.gcr.io/serve_hostname \
                        --labels=app=hostnames \
                        --port=9376 \
                        --replicas=2
kubectl get pods -l app=hostnames

kubectl expose deployment hostnames --port=80 --target-port=9376
kubectl get svc hostnames

#echo "http://$(kubectl get svc hostnames -o jsonpath="{.spec.clusterIP}"):$(kubectl get svc hostnames -o jsonpath="{.spec.ports[0].port}")"
#for ip in $(kubectl get endpoints hostnames -o jsonpath="{.subsets[0].addresses[*].ip}"); do
#    echo "http://${ip}:$(kubectl get endpoints hostnames -o jsonpath="{.subsets[0].ports[0].port}")"
#done

curl "http://$(kubectl get svc hostnames -o jsonpath="{.spec.clusterIP}"):$(kubectl get svc hostnames -o jsonpath="{.spec.ports[0].port}")"

for ip in $(kubectl get endpoints hostnames -o jsonpath="{.subsets[0].addresses[*].ip}"); do
    kubectl run -it --rm --restart=Never alpine --image=alpine -- wget -qO- "http://${ip}:$(kubectl get endpoints hostnames -o jsonpath="{.subsets[0].ports[0].port}")"
done

