This was built from the instructions here:
https://ibm.github.io/kubernetes-operators/lab3

How to use

Install the `operator-sdk` project as described in the above link

Create a `workdir` directory in the repo directory 

Change into this directory

Update the run.sh variables to reflect your deployment. 
 - `DOCKER_USERNAME`: org name for uploading to the container registry... hardcoded to podman at the moment
 - `OPERATOR_NAME`: name of the operator container to be uploaded to the registry
 - `OPERATOR_PROJECT`: namespace/project name to deploy management assets 
 - `OPERATOR_VERSION`: version of operator project to be pushed to the registry
 - `DEPLOY_PROJECT`: project the operator deploys into 
 - `CHART_FOLDER`: directory containing the Helm Chart. Should include a Chart.yaml at least
 - `IMAGE`: generated image tag used to push to the registry 

Create the management resources
 - login to podman
 - login to the OpenShift cluster you will be installing to 
 - Docker must be running on your machine 
 - from the `workdir` folder, run `../run.sh first` 
   - This will build the image from the helm chart, and push it to the image registry
 - wait for the operator containers to be running

Deploy the Operator
 - from the `workdir` folder run `../run.sh second`
 - This prints the status of the deployment as it progresses after the deployment has been started. 
