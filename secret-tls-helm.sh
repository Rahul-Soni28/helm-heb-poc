# CMS_CLIENT_CERT="cms-client-cert-dev"
# NGINX_SERVER_CERT="nginx-server-cert-dev"
# NGINX_CLIENT_CERT="nginx-client-cert-dev"
# BACKEND_SERVER_CERT="backend-server-cert-dev"

CERT_PATH=tmp/certs

# cp $NGINX_SERVER_CERT $NGINX_CLIENT_CERT $BACKEND_SERVER_CERT $CERT_PATH/

# # extract certs filenames from absolute path
# NGINX_SERVER_CERT_NAME=$(echo $NGINX_SERVER_CERT| rev | cut -d/ -f1 | rev)
# NGINX_CLIENT_CERT_NAME=$(echo $NGINX_CLIENT_CERT| rev | cut -d/ -f1 | rev)
# BACKEND_CERT_NAME=$(echo $BACKEND_SERVER_CERT| rev | cut -d/ -f1 | rev)

# mv $CERT_PATH/$BACKEND_CERT_NAME tmp/secrets/promo_planning_server_cert.p12  # secret from file
# echo -e "$CMS_CLIENT_CERT" > tmp/secrets/hebCertRootCAv3.cer  # secret from file

# # convert certs from .pfx to .pem
# openssl pkcs12 -in $CERT_PATH/$NGINX_SERVER_CERT_NAME  -nodes -password \'pass:\' -out $CERT_PATH/server_bundle.pem
# openssl pkcs12 -in $CERT_PATH/$NGINX_CLIENT_CERT_NAME  -nodes -password \'pass:\' -out $CERT_PATH/client_bundle.pem
# # extract certs and private keys from bundles
# openssl pkey -in $CERT_PATH/server_bundle.pem -out $CERT_PATH/server.pem -passin \'pass:\'
# openssl x509 -in $CERT_PATH/server_bundle.pem -outform PEM -out $CERT_PATH/server.crt
# openssl pkey -in $CERT_PATH/client_bundle.pem -out $CERT_PATH/client.pem -passin \'pass:\'
# openssl x509 -in $CERT_PATH/client_bundle.pem -outform PEM -out $CERT_PATH/client.crt


SERVER=$(ls $CERT_PATH )
VALUES_FILE=heb-poc/values.yaml
# VALUES_FILE=values.yaml
EXTENDS=extended-values.yaml


if [[ $SERVER != "" ]]; then
  sed -i "s@externalSecrets:.*\$@externalSecrets: true@g" $VALUES_FILE
  
  echo "secretsTLSExternal:" >> $EXTENDS
  for pem_key in $(ls $CERT_PATH | grep -e ".pem"); do
  TLS_KEY=$(cat $CERT_PATH/$pem_key | base64 | tr -d "\n")
  CERTFILE="$(echo $pem_key|cut -d. -f1).crt"
  TLS_CERT=$(cat $CERT_PATH/$CERTFILE | base64 | tr -d "\n")
  SECRET_NAME=$(echo $pem_key|cut -d. -f1)
  echo "  - name: nginx${SECRET_NAME}certificates" >> $EXTENDS
  echo "    data:" >> $EXTENDS
  echo "      tls.crt: $TLS_CERT" >> $EXTENDS
  echo "      tls.key: $TLS_KEY" >> $EXTENDS
  echo "" >> $EXTENDS
  done
  echo >> $VALUES_FILE
  cat $EXTENDS >> $VALUES_FILE
  rm $EXTENDS
else
  sed -i "s@externalSecrets:.*\$@externalSecrets: false@g" $VALUES_FILE
fi

