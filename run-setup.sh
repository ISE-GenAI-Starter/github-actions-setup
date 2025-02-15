### VARIABLES TO CHANGE - START
PROJECT_ID=
PROJECT_NUMBER=
SERVICE_NAME=
GITHUB_ORG=
GITHUB_REPO=
### VARIABLES TO CHANGE - END

# ----------- Set Up GCP Project ----------- #
gcloud config set project ${PROJECT_ID}

gcloud services enable run.googleapis.com \
    cloudbuild.googleapis.com

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --role=roles/run.builder

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --role=roles/cloudbuild.builds.builder

# ---- Configure GCP for GitHub Actions ---- #
OIDC_NAME=project-repo-test
WORKLOAD_IDENTITY_POOL_NAME=github-test
WORKLOAD_IDENTITY_POOL_ID="projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${WORKLOAD_IDENTITY_POOL_NAME}"
WORKLOAD_IDENTITY_PROVIDER="projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${WORKLOAD_IDENTITY_POOL_NAME}/providers/${OIDC_NAME}"

gcloud iam workload-identity-pools create "${WORKLOAD_IDENTITY_POOL_NAME}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --display-name="GitHub Actions Pool"

gcloud iam workload-identity-pools providers create-oidc "${OIDC_NAME}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="${WORKLOAD_IDENTITY_POOL_NAME}" \
    --display-name="My GitHub repo Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
    --attribute-condition="assertion.repository_owner == '${GITHUB_ORG}'" \
    --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITHUB_ORG}/${GITHUB_REPO_NAME}"

# ------- Output info for cloud.yml -------- #
echo "
GitHub Actions setup complete! Please put the following into cloud-run.yml:

"
echo "PROJECT_ID: '${PROJECT_ID}'"
echo "SERVICE_NAME: '${SERVICE_NAME}'"
echo "SERVICE_REGION: 'us-central1'"
echo "SERVICE_ACCOUNT: '${PROJECT_NUMBER}-compute@developer.gserviceaccount.com'"
echo "WORKLOAD_IDENTITY_PROVIDER: '${WORKLOAD_IDENTITY_PROVIDER}'"
