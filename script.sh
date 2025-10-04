#!/bin/bash

echo "My Repo: $REPO"
echo "Environment Name: $ENV_NAME"

ENV_VARS=$(gh variable list --json name,value -R $REPO -e $ENV_NAME) 
echo "$ENV_VARS" >> env_var.json

var_count=$(cat env_var.json | jq 'length')

if [ -n "$var_count" ] && [ "$var_count" -gt 0 ]; then
    echo "Number of variables retrieved: $var_count"
    echo "$ENV_VARS" | jq -r '.[]|"\(.name)=\(.value)"' >> $GITHUB_ENV  

    if [ $FILE_TYPE == "env" ]; then
        echo "$ENV_VARS" | jq -r '.[]|"\(.name)=\(.value)"' > .env
        echo ".env file is created"
    fi
else
    echo "Zero variables retrieved."
fi
