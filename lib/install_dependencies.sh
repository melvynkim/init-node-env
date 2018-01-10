#!/bin/bash

if hash yarn 2>/dev/null; then
  echo 'info: installing husky'
  yarn install --dev husky
elif hash npm 2>/dev/null; then
  echo 'info: installing husky'
  npm install --dev husky
else
  echo 'error: yarn or npm not found.'
  exit 2
fi