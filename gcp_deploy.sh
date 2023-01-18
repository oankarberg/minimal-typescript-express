#!/bin/bash
. ./gcp_input_vars.sh "$@"

INGRESS=all # Change to this for non public cloud run, only for load balancing: internal-and-cloud-load-balancing
#gcloud auth login

gcloud config set project $PROJECT_ID

docker build --platform=linux/amd64 -t $APP_NAME .
docker tag $APP_NAME $DOCKER_IMAGE
docker push $DOCKER_IMAGE

gcloud run deploy $APP_NAME --image $DOCKER_IMAGE \
       --platform managed \
       --ingress $INGRESS \
       --region $REGION \
       --allow-unauthenticated \
       --update-env-vars ENV=production
