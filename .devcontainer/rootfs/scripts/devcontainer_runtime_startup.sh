#!/bin/bash

make ensure_pre_commit

# Check if terraform is already deployed through tfenv
terraform version > /dev/null 2>&1

if [[ $? -eq 0 ]]; then
    echo "Terraform is already deployed through tfenv."
    terraform version
else
    tfenv use 1.7.5
fi
