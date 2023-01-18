#!/bin/bash
. ./gcp_input_vars.sh "$@"
# WARNING: this will delete all resources created from the other gcp scripts, including pushed docker containers

STATIC_IP_NAME=$APP_NAME-ip
URL_MAP_NAME=$APP_NAME-url-map
SERVERLESS_NEG_NAME=$APP_NAME-neg
BACKEND_SERVICE_NAME=$APP_NAME-backend
# HTTPS
TARGET_HTTPS_PROXY_NAME=$APP_NAME-https-proxy
SSL_CERTIFICATE_NAME=$APP_NAME-ssl-cert
HTTPS_FORWARDING_RULE_NAME=$APP_NAME-https-forwarding-rule
# HTTP
HTTP_FORWARDING_RULE_NAME=$APP_NAME-http-forwarding-rule
TARGET_HTTP_PROXY_NAME=$APP_NAME-http-proxy

# gcloud run services delete $APP_NAME

gcloud compute backend-services delete $BACKEND_SERVICE_NAME

gcloud compute backend-services remove-backend $BACKEND_SERVICE_NAME \
    --network-endpoint-group=$SERVERLESS_NEG_NAME \
    --network-endpoint-group-region=$REGION \
    --global


gcloud compute network-endpoint-groups delete $SERVERLESS_NEG_NAME \
    --region=$REGION

gcloud compute forwarding-rules delete $HTTPS_FORWARDING_RULE_NAME --global
gcloud compute forwarding-rules delete $HTTP_FORWARDING_RULE_NAME --global

gcloud compute addresses delete $STATIC_IP_NAME --global

gcloud compute target-https-proxies delete $TARGET_HTTPS_PROXY_NAME
gcloud compute target-http-proxies delete $TARGET_HTTP_PROXY_NAME

gcloud compute ssl-certificates delete $SSL_CERTIFICATE_NAME
gcloud compute url-maps delete $URL_MAP_NAME



# delete artifactory
#gcloud artifacts repositories delete $DOCKER_REPO_NAME --location=$REGION
