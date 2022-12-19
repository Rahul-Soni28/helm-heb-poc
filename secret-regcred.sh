#!/bin/bash

VALUES_FILE=heb-poc/values.yaml
EXTENDS=extended-values.yaml

# usage(){
#   echo -e "[Error] Fetching secrets from vault. \nMissing environment variables $1"
# }

# if [[ $CONTAINER_REGISTRY == null || $CONTAINER_REGISTRY == "" ]]; then
# usage CONTAINER_REGISTRY
# exit 1
# elif [[ $ACR_USERNAME == null || $ACR_USERNAME == "" ]];then
# usage ACR_USERNAME
# exit 1
# elif [[ $ACR_PASSWORD == null || $ACR_PASSWORD == "" ]];then
# usage ACR_USERNAME
# exit 1
# fi

# docker login $CONTAINER_REGISTRY -u $ACR_USERNAME -p $ACR_PASSWORD
DOCKER_SECRET=$(cat ~/.docker/config.json|jq -c|base64|tr -d "\n")
echo -e "dockerRegistryCredentials: $DOCKER_SECRET\n" >> $EXTENDS

echo >> $VALUES_FILE
cat $EXTENDS >> $VALUES_FILE
rm $EXTENDS