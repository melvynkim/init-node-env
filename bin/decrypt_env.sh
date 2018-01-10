#!/bin/sh
# Standard build script to build multi environment dotenv files
# for node projects. The derived products include the encrypted
# dotenv file

PATH_TO_ENCRYPTED=.env.${NODE_ENV}.encrypted
PATH_TO_DECRYPTED=.env.${NODE_ENV}.decrypted

# check with prerequsites
if [ -z "${NODE_ENV}" ]; then
  echo 'info: NODE_ENV is not set. To skip this prompt, execute your script with NODE_ENV'
  read -p "Enter password to encrypt your env file: " node_env
  if [ -z "${node_env}" ]; then
    echo 'error: password cannot be an empty string.'
    exit 1
  else
    NODE_ENV="${node_env}"
  fi
fi

# check with prerequsites
if [ -z "${ENV_PASSWORD}" ]; then
  echo 'info: ENV_PASSWORD is not set. To skip this prompt, execute your script with ENV_PASSWORD'
  read -p "Enter password to encrypt your env file: " password
  if [ -z "${password}" ]; then
    echo 'error: password cannot be an empty string.'
    exit 1
  else
    ENV_PASSWORD="${password}"
  fi
fi

# main
openssl enc -d -aes-256-cbc -in ${PATH_TO_ENCRYPTED} -out ${PATH_TO_DECRYPTED} -a -salt -k ${ENV_PASSWORD}