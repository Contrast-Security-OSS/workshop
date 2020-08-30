#!/bin/bash

# This script has a dependency on jq, and curl.

# This script sets up the instructor for a new workshop as a self-contained org.  We'll use that org to setup users separately.
# Please enter your SE credentials with (preferably) command-line options or hard-coded here.
CONTRAST_SE_API_KEY=""
CONTRAST_SE_AUTH_HEADER=""
CONTRAST_URL="https://eval.contrastsecurity.com/Contrast"

#Make sure this is complex enough for TeamServer!
ADMIN_PASSWORD="contrast-1999Y2K!"
OUTPUT_FILE=""
INPUT_FILE=""

usage() {
  cat <<HELPDOC
Run this script to create an organization plus workshop instructor.

Usage: $0 <options>
Command options:
      [-a "CONTRAST AUTH_HEADER"]
      [-i input file] instructor details input file
      [-k "CONTRAST API_KEY"]
      [-o organization name]
      [-p "instructor password"]
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
      ORGANIZATION_NAME=${OPTARG}
      OUTPUT_FILE=""${OPTARG}-instructor.output.txt""
      ;;
    p)
      ADMIN_PASSWORD=${OPTARG}
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
    read -p "Do you wish to create these organisations (y/n)? " yn
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
        json="{
            \"name\": \"$ORGANIZATION_NAME workshop\",
            \"use_existing_user\": false,
            \"adminEmail\": \"$email\",
            \"adminFirstName\": \"$first\",
            \"adminLastName\": \"$last\",
            \"adminPassword\": \"$ADMIN_PASSWORD\",
            \"requireActivation\": false,
            \"timezone\": \"EST\",
            \"date_format\": \"MM/dd/yyyy\",
            \"time_format\": \"hh:mm a\",
            \"ossFeature\": true,
            \"ossInventoryModeFeature\": true,
            \"vulnerability_duplicate_notification_enabled\": false,
            \"vulnerability_auto_verification_enabled\": false,
            \"beta_languages_enabled\": false,
            \"disa_stig_enabled\": false,
            \"app_library_status_enabled\": false,
            \"telemetry_enabled\": true,
            \"protection_enabled\": true
        }"

        output=$(curl -s --location --request POST "$CONTRAST_URL/api/ng/superadmin/organizations/rasp?expand=skip_links" \
            --header "API-Key: $CONTRAST_SE_API_KEY" \
            --header "Accept: application/json" \
            --header "Authorization: $CONTRAST_SE_AUTH_HEADER" \
            --header "Content-Type: application/json" \
            --data-raw "$json")

        #Check if we were successful
        echo $output
        result=$(echo "$output" | jq '.success')
        if [[ $result = "true" ]]
        then
            name=$(echo "$output" | jq '.organization.name')
            # Consider adding both the email and uuid to the output.  It will make the parsing a little more complex in the
            # delete-orgs script, but the idea is to more easily correlate the email+uuid in the file so we know who we're referencing (just in case)
            uuid=$(echo "$output" | jq '.organization.organization_uuid'| tr -d \")
            echo $uuid >> $OUTPUT_FILE
            echo "Organisation $name created successfully for $email with organization_uuid=$uuid"
        else
            error=$(echo "$output" | jq '.messages[0]')
            echo "Could not create organisation for user $email, error: $error"
        fi
    fi
done < $INPUT_FILE