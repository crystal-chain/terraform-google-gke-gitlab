# Set current project
gcloud config set project terrakube

# Set default region and default zone
# Replace us-central1 by europe-west1
# Replace us-central1-a by europe-west1-b
gcloud compute project-info add-metadata \
    --metadata google-compute-default-region=europe-west4,google-compute-default-zone=europe-west4-b

# Enable APIs
gcloud services enable container.googleapis.com \
       servicenetworking.googleapis.com \
       cloudresourcemanager.googleapis.com \
       sqladmin.googleapis.com \
       redis.googleapis.com

# Configure Cloud IAM
export PROJECT_ID=$(gcloud config get-value project)
gcloud iam service-accounts create terrakube \
    --display-name "Terraform Kubernetes"
gcloud iam service-accounts keys create --iam-account \
    terrakube@${PROJECT_ID}.iam.gserviceaccount.com credentials.json
gcloud projects add-iam-policy-binding --role roles/owner ${PROJECT_ID} \
    --member=serviceAccount:terrakube@${PROJECT_ID}.iam.gserviceaccount.com

gsutil mb gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate
