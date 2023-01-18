#!/bin/bash
. ./gcp_input_vars.sh "$@"



gcloud services enable artifactregistry.googleapis.com

gcloud artifacts repositories create "${APP_NAME}-repo" --repository-format=docker \
    --location=$REGION --description="Docker repository for ${APP_NAME}"

# Auth docker against gcloud artifactory docker registry
gcloud auth configure-docker "${REGION}-docker.pkg.dev"
