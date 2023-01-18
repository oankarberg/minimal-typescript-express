#!/bin/bash
. ./gcp_input_vars.sh "$@"

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

# For loadbalancing with SSL cert
DOMAIN=yourdomain.com

gcloud compute addresses create $STATIC_IP_NAME \
       --network-tier=PREMIUM \
       --ip-version=IPV4 \
       --global

gcloud compute network-endpoint-groups create $SERVERLESS_NEG_NAME \
       --region=$REGION \
       --network-endpoint-type=serverless \
       --cloud-run-service=$APP_NAME

gcloud compute backend-services create $BACKEND_SERVICE_NAME \
       --load-balancing-scheme=EXTERNAL \
       --global

gcloud compute backend-services add-backend $BACKEND_SERVICE_NAME \
       --global \
       --network-endpoint-group=$SERVERLESS_NEG_NAME \
       --network-endpoint-group-region=$REGION

gcloud compute url-maps create $URL_MAP_NAME \
       --default-service $BACKEND_SERVICE_NAME

# HTTPS parts
# gcloud compute ssl-certificates create $SSL_CERTIFICATE_NAME \
#        --domains $DOMAIN

# gcloud compute target-https-proxies create $TARGET_HTTPS_PROXY_NAME \
#        --ssl-certificates=$SSL_CERTIFICATE_NAME \
#        --url-map=$URL_MAP_NAME

# gcloud compute forwarding-rules create $HTTPS_FORWARDING_RULE_NAME \
#        --load-balancing-scheme=EXTERNAL \
#        --network-tier=PREMIUM \
#        --address=$STATIC_IP_NAME \
#        --target-https-proxy=$TARGET_HTTPS_PROXY_NAME \
#        --global \
#        --ports=443

#HTTP
gcloud compute target-http-proxies create $TARGET_HTTP_PROXY_NAME \
       --url-map=$URL_MAP_NAME
gcloud compute forwarding-rules create $HTTP_FORWARDING_RULE_NAME \
       --load-balancing-scheme=EXTERNAL \
       --network-tier=PREMIUM \
       --address=$STATIC_IP_NAME \
       --target-http-proxy=$TARGET_HTTP_PROXY_NAME \
       --global \
       --ports=80

gcloud compute addresses list
