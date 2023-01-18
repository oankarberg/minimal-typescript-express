# minimal-typescript-express

Starter repo for [Node.js](https://nodejs.org/) (with typescript) applications with [Express](https://expressjs.com/).
This template repo can also be used to accelerate deployment of PoC to GCP.

```sh
yarn
```

```sh
yarn run dev
```

# Dockerize

```sh
docker build --platform=linux/amd64 -t minimal-typescript-express .
```

```sh
docker run -p 3000:3000 minimal-typescript-express
```

# Deploy to GCP Cloud Run

1. ##### Install <a href="https://cloud.google.com/sdk/docs/install-sdk#mac" target="_blank">Google Cloud CLI</a>
2. ##### Setup Artifact Registry for docker images in GCP

```sh
./gcp_setup_docker_repo.sh --name minimal-typescript-express --project_id your-gcp-project-id
```

3. ##### Deploy to GCP Cloud Run. Creates an accessible instance.

```sh
./gcp_deploy.sh --name minimal-typescript-express --project_id your-gcp-project-id
```

4. ##### Setup Load balancing and Static IP

```sh
./gcp_setup_loadbalancing.sh --name minimal-typescript-express --project_id your-gcp-project-id
```

5. ##### Create A records for your domain www.example.com and example.com
   List your created Static IP. You should be able to access Cloud Run service on the IP address within 10 minutes.

```sh
gcloud compute addresses list
```

and setup A records on your domain registrar

```
www                   A        30.90.80.100
@                     A        30.90.80.100
```

4. ##### Cleaning up

Delete all created resources

```sh
./gcp_cleanup.sh --name minimal-typescript-express --project_id your-gcp-project-id
```

### Manual deploy

1. Auth to gcp

```sh
gcloud auth login
```

2. Set active gcp project

```sh
PROJECT_ID=my_gcp_project_id
gcloud config set project $PROJECT_ID
```

3. Tag docker image and push to gcp repo.

```sh
docker tag $APP_NAME eu.gcr.io/$PROJECT_ID/minimal-typescript-express
docker push eu.gcr.io/$PROJECT_ID/minimal-typescript-express
```

4. Deploy to Cloud Run

```sh
gcloud run deploy minimal-typescript-express --image eu.gcr.io/$PROJECT_ID/minimal-typescript-express \
        --platform managed \
        --region europe-north1 \
        --allow-unauthenticated
```

```sh
gcloud run services list
```

Deleting cloud run service

```sh
gcloud run services delete minimal-typescript-express
```

