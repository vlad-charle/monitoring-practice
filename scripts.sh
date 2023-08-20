#!/bin/bash

kubectl create ns my-app
kubectl apply -f k8s/secret.yaml -n my-app
helm upgrade --install mysql-release mysql --repo https://charts.bitnami.com/bitnami -f helm/mysql/values-mysql-bitnami.yaml --namespace my-app --create-namespace
kubectl apply -f k8s/configmap.yaml -n my-app
kubectl apply -f k8s/my-app.yaml -n my-app
kubectl create secret docker-registry docker-hub --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD -n my-app
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx -f helm/nginx/values-nginx-ingress-controller.yaml --namespace ingress-nginx --create-namespace
helm upgrade --install monitoring kube-prometheus-stack --repo https://prometheus-community.github.io/helm-charts -f helm/prometheus/values-prometheus.yaml --namespace monitoring --create-namespace
