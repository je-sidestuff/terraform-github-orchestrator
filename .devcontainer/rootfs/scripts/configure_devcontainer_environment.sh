#!/bin/bash

findStringInFile() {
  local search_string=$2
  local file_path=$1

  if [[ -z $search_string || -z $file_path ]]; then
    echo "Usage: findStringInFile <search_string> <file_path>"
    return 1
  fi

  if [[ ! -f $file_path ]]; then
    echo "File '$file_path' does not exist or is not a regular file."
    return 1
  fi

  if ! grep -q "$search_string" "$file_path"; then
    echo "String '$search_string' not found in '$file_path'."
  else
    echo "String '$search_string' found in '$file_path'."
  fi
}

# AWS Creds via Okta
function awsuse() {
  if [ -z "$1" ]; then
    echo "No environment supplied"
  else
    if findStringInFile ~/.aws/config $1; then
      export AWS_PROFILE=${1}
      echo "AWS command line environment set to [${1}]"
      aws sso logout
      aws sso login
    else
      echo "AWS profile [${1}] not found."
      echo "Please choose from an existing profile:"
      grep "\[profile" ~/.aws/config
      echo "Or create a new one."
    fi
  fi
}

export PATH="/apps/.tfenv/bin:$PATH"
