#!/bin/bash

PATH_TO_GITIGNORE="$1/.gitignore"

# check with prerequsites
if [ -z "${PATH_TO_GITIGNORE}" ]; then
  echo 'error: PATH_TO_GITIGNORE is not defined.'
  exit 1
fi

# add .env.*.decrypted to .gitignore
grep '^.env.*.decrypted$' $PATH_TO_GITIGNORE 2>&1 1>/dev/null
if [ $? = 1 ]; then
  echo -n "\

# dotenv files
# @see https://github.com/melvynkim/init-node-env
.env.*.decrypted" >> ${PATH_TO_GITIGNORE}
else
  echo 'info: .env.*.decrypted already exists in your .gitignore'
fi

# add .env to .gitignore
grep '^.env$' $PATH_TO_GITIGNORE 2>&1 1>/dev/null
if [ $? = 1 ]; then
  echo "\

.env" >> ${PATH_TO_GITIGNORE}
else
  echo 'info: .env already exists in your .gitignore'
fi