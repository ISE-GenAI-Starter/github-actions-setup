# run-setup.sh

**Note:** This only needs to be run once per `my-ai-shoe-starter` repo. ***Make sure the person running the code has Owners permission on the GCP project in IAM.***

Fill in the bash variables at the top of `run-setup.sh` (also listed below), then run `./run-setup.sh`.

```shell
PROJECT_ID=
PROJECT_NUMBER=
SERVICE_NAME=
GITHUB_ORG=
GITHUB_REPO=
```

# manual-deploy.sh

**Prerequisite:** Make sure you have ***Owners*** permission on the GCP project in IAM.

Use this script to manually deploy to your GCP project. Please just fill in the GCP project ID and the service name in the top of the file.

```shell
PROJECT_ID=
SERVICE_NAME=
```
