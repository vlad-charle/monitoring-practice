#!/bin/bash

kubectl create ns my-app
kubectl apply -f k8s/secret.yaml -n my-app
helm upgrade --install mysql-release mysql --repo https://charts.bitnami.com/bitnami -f helm/mysql/values-mysql-bitnami.yaml --namespace my-app --create-namespace
kubectl apply -f k8s/configmap.yaml -n my-app
kubectl apply -f k8s/my-app.yaml -n my-app
kubectl create secret docker-registry docker-hub --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD -n my-app
kubectl create secret generic gmail --from-literal=password=$GMAIL_PASSWORD -n monitoring
kubectl create secret generic slack --from-literal=api-url=$SLACK_API_URL -n monitoring
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx -f helm/nginx/values-nginx-ingress-controller.yaml --namespace ingress-nginx --create-namespace
helm upgrade --install monitoring kube-prometheus-stack --repo https://prometheus-community.github.io/helm-charts -f helm/prometheus/values-prometheus.yaml --namespace monitoring --create-namespace
kubectl apply -f k8s/servicemonitor.yaml -n my-app
kubectl apply -f k8s/alerts.yaml -n monitoring
envsubst < k8s/notifications.yaml | kubectl apply -n monitoring -f -