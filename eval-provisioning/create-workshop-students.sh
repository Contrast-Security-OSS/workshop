#!/bin/bash

# This script has a dependency on jq, and curl.

# Given an org, create students for the org to be part of a workshop.
# Please enter your SE credentials with (preferably) command-line options or hard-coded here.
CONTRAST_SE_API_KEY=""
CONTRAST_SE_AUTH_HEADER=""
CONTRAST_URL="https://eval.contrastsecurity.com/Contrast"

#Make sure this is complex enough for TeamServer!
ADMIN_PASSWORD="contrast-FTW!2020"
OUTPUT_FILE="workshop-students.output.csv"
INPUT_FILE="workshop-students.input.csv"

usage() {
  cat <<HELPDOC
Run this script to create students as users in an org.

Usage: $0 <options>
Command options:
      [-a "CONTRAST AUTH_HEADER"]
      [-i input file] student names in csv format"
      [-k "CONTRAST API_KEY"]
      [-o "ORG_UUID"]
      [-p "student password"]
      [-u CONTRAST URL] defaults to eval
HELPDOC
}

exit_error() {
  usage
  exit 1
}

exit_good() {
  exit 0
}

while getopts "ha:k:p:u:i:o:" options; do
  case "${options}" in
    h)
      usage
      exit_good
      ;;
    a)
      CONTRAST_SE_AUTH_HEADER=${OPTARG}
      ;;
    i)
      INPUT_FILE=${OPTARG}
      ;;
    k)
      CONTRAST_SE_API_KEY=${OPTARG}
      ;;
    o)
      ORG_UUID=${OPTARG}
      ;;
    p)
      DEFAULT_PASSWORD=${OPTARG}
      ;;
    u)
      CONTRAST_URL=${OPTARG}
      ;;
    :)
      echo "ERROR: -${OPTARG} requires an argument"
      exit_error
      ;;
    *)
      exit_error
      ;;
  esac
done

if ! command -v jq &> /dev/null
then
    echo "Please install jq before starting using `brew install jq`"
    exit_error
fi

#Alert the user if we don't have creds
if [[ $CONTRAST_SE_API_KEY = "" ]]
then
    printf "Please populate the variables at the top of the script file with your SE credentials\n"
    exit_error
fi

#List the users we are going to create
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit; }
while read first last email
do
[[ "$first" != "first" ]] && echo "$first $last ($email)"
done < $INPUT_FILE

#Prompt the user - continue?
while true; do
    read -p "Do you wish to create these users (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

#Delete the previous results
rm $OUTPUT_FILE
touch $OUTPUT_FILE

#Call the API to create the orgs
echo "Calling the API"
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit; }
while read first last email
do
    if [[ "$first" != "first" ]]
    then
        # HEREDOCS use tabs for indentation, and chances are your editor may replace tabs with spaces.  To be safe, make the next part with no indentation.
        json=$(cat<<-JSON
{
  "activation":false,
  "date_format":"MM/dd/yyyy",
  "enabled":true,
  "first_name":"$first",
  "groups":[39],
  "last_name":"$last",
  "org_management":true,
  "organization_uuid":"$ORG_UUID",
  "password":"$DEFAULT_PASSWORD",
  "protect":true,
  "role":2,
  "time_format":"hh:mm a",
  "time_zone":"EST",
  "username":"$email"
}
JSON
        )
        echo "JSON body is $json"

        output=$(curl -s --location --request POST "$CONTRAST_URL/api/ng/superadmin/users" \
            --header "API-Key: $CONTRAST_SE_API_KEY" \
            --header "Accept: application/json" \
            --header "Authorization: $CONTRAST_SE_AUTH_HEADER" \
            --header "Content-Type: application/json" \
            --data-raw "$json")

        echo $output
        echo $output >> $OUTPUT_FILE
        #Check if we were successful
        result=$(echo "$output" | jq '.success')
        if [[ $result = "true" ]]
        then
            echo "User created successfully for $email"
        else
            error=$(echo "$output" | jq '.messages[0]')
            echo "Could not create user $email, error: $error"
        fi
    fi
done < $INPUT_FILE
