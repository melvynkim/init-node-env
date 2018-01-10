#!/bin/bash

JQ=./node_modules/node-jq/bin/jq
PATH_TO_PACKAGE_JSON="$1/package.json"
PATH_TO_PACKAGE_JSON_TEMP="$1/package.json.temp"

function _does_field_exist() {
  _array=($@)
  _len=${#_array[@]}
  QUERY_FIELD_KEY=${1}[\"${2}\"]
  QUERY_FIELD_VALUE=${_array[@]:2:$_len}

  # jq ".${QUERY_FIELD_KEY} | contains(\"${QUERY_FIELD_VALUE}\")" "${PATH_TO_PACKAGE_JSON}" 2>&1 1>/dev/null
  cat "${PATH_TO_PACKAGE_JSON}" | jq  ".${QUERY_FIELD_KEY} | contains(\"${QUERY_FIELD_VALUE}\")?" 2>&1 1>/dev/null
  # cat "${PATH_TO_PACKAGE_JSON}" | jq -n ".${QUERY_FIELD_KEY}"
  return $?
}

function _create_key_with_value() {
  _array=($@)
  _len=${#_array[@]}
  QUERY_FIELD_KEY=${1}[\"${2}\"]
  QUERY_FIELD_VALUE=${_array[@]:2:$_len}

  JQ \
    --ascii-output \
    --sort-keys \
    ".${QUERY_FIELD_KEY} = \"${QUERY_FIELD_VALUE}\"" \
    ${PATH_TO_PACKAGE_JSON} > ${PATH_TO_PACKAGE_JSON_TEMP} &&
    mv ${PATH_TO_PACKAGE_JSON_TEMP} ${PATH_TO_PACKAGE_JSON}
}

function _add_value_to_key() {
  _array=($@)
  _len=${#_array[@]}
  QUERY_FIELD_KEY=${1}[\"${2}\"]
  QUERY_FIELD_VALUE=${_array[@]:2:$_len}
  DELIMITER=" && "

  JQ \
    --ascii-output \
    --sort-keys \
    ".${QUERY_FIELD_KEY} = \"${QUERY_FIELD_VALUE} && \" + .${QUERY_FIELD_KEY}" \
    ${PATH_TO_PACKAGE_JSON} > ${PATH_TO_PACKAGE_JSON_TEMP} &&
    mv ${PATH_TO_PACKAGE_JSON_TEMP} ${PATH_TO_PACKAGE_JSON}
}

function add_to_scripts() {
  _does_field_exist $1 $2 $3 &&
    _add_value_to_key $1 $2 $3 ||
    _create_key_with_value $1 $2 $3
}

# check with prerequsites
if [ -z "${PATH_TO_PACKAGE_JSON}" ]; then
  echo 'error: PATH_TO_PACKAGE_JSON is not defined.'
  exit 1
fi

# create "build"
add_to_scripts 'scripts' 'build' 'npm run dotenv:decrypt'

# create "build:develop"
add_to_scripts 'scripts' 'build:develop' 'NODE_ENV=develop npm run build'

# create "build:master"
add_to_scripts 'scripts' 'build:master' 'NODE_ENV=master npm run build'

# create "build:production"
add_to_scripts 'scripts' 'build:production' 'NODE_ENV=production npm run build'

# create "pre-commit"
add_to_scripts 'scripts' 'precommit' 'npm run dotenv:encrypt'

# create "env:(en|de)crypt"
add_to_scripts 'scripts' 'dotenv:decrypt' './bin/decrypt_env.sh'
add_to_scripts 'scripts' 'dotenv:encrypt' './bin/encrypt_env.sh'