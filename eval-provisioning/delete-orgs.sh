#!/bin/bash

# CONSIDER an option to accept the uuid of a single user to only remove a single problemlatic user account.
# Wait to see if we have problematic accounts before extending this script to accomodate.

#Please enter your SE credentials with (preferably) command-line options or hard-coded here.
CONTRAST_SE_API_KEY=""
CONTRAST_SE_AUTH_HEADER=""
CONTRAST_URL="https://eval.contrastsecurity.com/Contrast"

INPUT_FILE="orgs-created.csv"

usage() {
  cat <<HELPDOC
This script will delete organisations within the Contrast eval environment.

Usage: $0 <options>
Command options:
      [-a "CONTRAST AUTH_HEADER"]
      [-k "CONTRAST API_KEY"]
      [-p "default password"]
      [-u CONTRAST URL] defaults to eval
      [-i input file]
HELPDOC
}

exit_error() {
  usage
  exit 1
}

exit_good() {
  exit 0
}

while getopts "ha:i:k:p:u:" options; do
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
    u)
      CONTRAST_URL=${OPTARG}
      ;;
    p)
      ADMIN_PASSWORD=${OPTARG}
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

#Alert the user if we don't have creds
if [[ $CONTRAST_SE_API_KEY = "" ]]
then
    printf "Please populate the variables at the top of the script file with your SE credentials\n"
    exit_error
fi

#List the users we are going to create
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit; }
while read uuid
do
    echo $uuid
done < $INPUT_FILE

#Prompt the user - continue?
while true; do
    read -p "Do you wish to delete these organisations (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

#Call the API to create the orgs
echo "Calling the API"
IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit; }
while read uuid
do
    output=$(curl -s --location --request DELETE "$CONTRAST_URL/api/ng/superadmin/organizations/$uuid" \
        --header "API-Key: $CONTRAST_SE_API_KEY" \
        --header "Accept: application/json" \
        --header "Authorization: $CONTRAST_SE_AUTH_HEADER" \
        --header "Content-Type: application/json")

    #Check if we were successful
    result=$(echo "$output" | jq '.success')
    if [[ $result = "true" ]]
    then 
        echo "Organisation $uuid deleted successfully"
    else 
        error=$(echo "$output" | jq '.messages[0]')
        echo "Could not delete organisation $uuid, error: $error"
    fi

done < $INPUT_FILE

#Prompt the user - continue?
while true; do
    read -p "Would you like to delete the orgs-created.csv file (y/n)? " yn
    case $yn in
        [Yy]* ) rm orgs-created.csv && break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done