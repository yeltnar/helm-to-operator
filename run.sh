# Built from https://ibm.github.io/kubernetes-operators/lab3/#6-cleanup-the-deployment

export DOCKER_USERNAME="brantley_us"

export OPERATOR_NAME='mvie-op'
export OPERATOR_PROJECT='mvie-op'
export OPERATOR_VERSION='v0.0.2'

export DEPLOY_PROJECT='mvi-edge' # this is hard-coded into the heml files, and therefore the operator 

export CHART_FOLDER="/Users/Drew/client_engineering/charter-pt2/zip/oscharts/charts/singlepod/"
export IMAGE="quay.io/${DOCKER_USERNAME}/${OPERATOR_NAME}:${OPERATOR_VERSION}" 

first(){
    echo "using ${DEPLOY_PROJECT} for DEPLOY_PROJECT"

    mkdir -p "${OPERATOR_PROJECT}" # TODO make sure you're in this dir for second too 
    cd "${OPERATOR_PROJECT}"

    operator-sdk init --plugins=helm # --domain mvie.test.ibm.com

    operator-sdk create api --helm-chart "$CHART_FOLDER" 

    # echo "enter quay.io password" 
    # docker login quay.io -u $DOCKER_USERNAME

    docker rmi -f ${IMAGE}

    make docker-build docker-push IMG=${IMAGE}

    docker images | grep "$IMAGE"

    echo sleep; sleep 5

    make install

    oc describe CustomResourceDefinition "$(cat config/crd/bases/*.yaml | yq e .metadata.name)"

    make deploy IMG=${IMAGE}

    oc get all -n ${OPERATOR_PROJECT}-system

    # wait for this to finish before moving on
    exit
}

second(){
    cd "${OPERATOR_PROJECT}"

    oc new-project "$DEPLOY_PROJECT" 

    oc apply -f config/samples/charts_v1alpha1_*.yaml

    # cat config/samples/chart*.yaml

    oc get all -n "$DEPLOY_PROJECT" 

    watch "oc get all -n $DEPLOY_PROJECT"

}

remove(){
    oc delete project $OPERATOR_PROJECT-system
    oc delete project $DEPLOY_PROJECT

    watch "../r.sh waitForDelete"
}

waitForDelete(){
    oc get project $OPERATOR_PROJECT-system
    oc get project $DEPLOY_PROJECT
}

if [ "" != "$1" ]; then
    echo "function is provided"
    $1
else
    echo "no function provided"
fi
