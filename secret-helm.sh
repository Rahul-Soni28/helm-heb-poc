#!/bin/bash

SECRET_PATH=tmp/secrets
FILES=$(ls $SECRET_PATH | grep -e ".js")
ENVS=$(ls $SECRET_PATH | grep -e ".conf")
VALUES_FILE=heb-poc/values.yaml
EXTENDS=extended-values.yaml


if [[ $FILES != "" || $ENVS != "" ]]; then
  sed -i "s@externalSecrets:.*\$@externalSecrets: true@g" $VALUES_FILE
else
  sed -i "s@externalSecrets:.*\$@externalSecrets: false@g" $VALUES_FILE
fi

if [[ $FILES != "" ]]; then
  echo "secretsFileExternal:" >> $EXTENDS
  for i in $FILES; do
  FILE_NAME=$i
  FILE_ENCODED_CONTENT=$(cat $SECRET_PATH/$FILE_NAME|base64|tr -d "\n")
  echo -e "- name: $FILE_NAME\n  data:\n    $FILE_NAME: $FILE_ENCODED_CONTENT\n" >> $EXTENDS
  done
  echo >> $VALUES_FILE
  cat $EXTENDS >> $VALUES_FILE
  rm $EXTENDS
fi


if [[ $ENVS != "" ]]; then
  echo "secretsKeyValueExternal:" >> $EXTENDS
  for i in $ENVS; do
  sed -i "s@=@\ @1" $SECRET_PATH/$i
  echo "- name: $i" >> $EXTENDS
  echo "  data:" >> $EXTENDS
  while IFS='' read -r line; do
  KEY=$(echo $line|awk '{print $1}')
  VALUE=$(echo $line|awk '{print $2}')
  echo "    $KEY: $VALUE" >> $EXTENDS
  done < $SECRET_PATH/$i
  done
  echo >> $VALUES_FILE
  cat $EXTENDS >> $VALUES_FILE
  rm $EXTENDS
fi
