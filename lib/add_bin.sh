#!/bin/bash

PATH_TO_PROJECT_ROOT=$1
PATH_TO_BIN=$2/bin

# check with prerequsites
if [ -z "${PATH_TO_PROJECT_ROOT}" ]; then
  echo 'error: "${PATH_TO_PROJECT_ROOT}/bin is not defined.'
  exit 1
fi

cp -r ${PATH_TO_BIN} ${PATH_TO_PROJECT_ROOT}