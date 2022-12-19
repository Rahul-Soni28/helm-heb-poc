#!/bin/bash

CONFIG_PATH=tmp/config
FILES=$(ls $CONFIG_PATH | grep -e ".js")
ENVS=$(ls $CONFIG_PATH | grep -e ".conf")
VALUES_FILE=heb-poc/values.yaml
EXTENDS=extended-values.yaml

if [[ $FILES != "" || $ENVS != "" ]]; then
  sed -i "s@externalConfigMaps:.*\$@externalConfigMaps: true@g" $VALUES_FILE
  echo "configMapsExternal:" >> $EXTENDS
else
  sed -i "s@externalConfigMaps:.*\$@externalConfigMaps: false@g" $VALUES_FILE
fi

if [[ $FILES != "" ]]; then
  for i in $FILES; do
  FILE_NAME=$i
  echo >> $CONFIG_PATH/$i
  echo "- name: $FILE_NAME" >> $EXTENDS
  echo "  data:" >> $EXTENDS
  echo "    $FILE_NAME: |-" >> $EXTENDS

  while IFS='' read -r line; do
  echo "      $line" >> $EXTENDS
  done < $CONFIG_PATH/$FILE_NAME

  echo "" >> $EXTENDS
  done
  echo >> $VALUES_FILE
  cat $EXTENDS >> $VALUES_FILE
  rm $EXTENDS
fi

if [[ $ENVS != "" ]]; then
  for i in $ENVS; do
  sed -i "s@=@\ @1" $CONFIG_PATH/$i
  echo "- name: $i" >> $EXTENDS
  echo "  data:" >> $EXTENDS
  while IFS='' read -r line; do
  KEY=$(echo $line|awk '{print $1}')
  VALUE=$(echo $line|awk '{print $2}')
  echo "    $KEY: $VALUE" >> $EXTENDS
  done < $CONFIG_PATH/$i
  done
  echo >> $VALUES_FILE
  cat $EXTENDS >> $VALUES_FILE
  rm $EXTENDS
fi

