#!/bin/bash
# Transform long options to short ones
for arg in "$@"; do
   shift
   case "$arg" in
   '--name') set -- "$@" '-n' ;;
   '--project_id') set -- "$@" '-p' ;;
   *) set -- "$@" "$arg" ;;
   esac
done

helpFunction() {
   echo ""
   echo "Usage: $0 -name minimal-typescript-express --project_id gcp_project_id"
   echo -e "\t--name name of the gcloud app"
   echo -e "\t--project_id GCP PROJECT_ID"
   exit 1 # Exit script after printing help
}

while getopts "n:p:" opt; do
   case "$opt" in
   n) app_name="$OPTARG" ;;
   p) project_id="$OPTARG" ;;
   ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$app_name" ] || [ -z "$project_id" ]; then
   echo "Some or all of the parameters are empty"
   helpFunction
fi

echo "$app_name"
echo "$project_id"

PROJECT_ID=$project_id
APP_NAME=$app_name
REGION=europe-north1
# Artifactory registry in gcloud
DOCKER_REPO_NAME=${APP_NAME}-repo
DOCKER_REGISTRY=$REGION-docker.pkg.dev/$PROJECT_ID/$DOCKER_REPO_NAME
DOCKER_IMAGE=$DOCKER_REGISTRY/$APP_NAME:latest

