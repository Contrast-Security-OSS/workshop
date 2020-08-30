#!/bin/bash

# CONSIDER using both the first+last name as the organization name.
# In the current model, the organization is named after the user's first name.  If two users have the same first name, we'll have the same org.

#Please enter your SE credentials with (preferably) command-line options or hard-coded here.
CONTRAST_SE_API_KEY=""
CONTRAST_SE_AUTH_HEADER=""
CONTRAST_URL="https://eval.contrastsecurity.com/Contrast"

#Make sure this is complex enough for TeamServer!
ADMIN_PASSWORD="contrast-1999Y2K!"

OUTPUT_FILE="orgs-created.csv"
INPUT_FILE="users.csv"

usage() {
  cat <<HELPDOC
Run this script to create organizations for a list of users supplied in a CSV.

Usage: $0 <options>
Command options:
      [-a "CONTRAST AUTH_HEADER"]
      [-k "CONTRAST API_KEY"]
      [-p "default password"]
      [-u CONTRAST URL] defaults to eval
      [-c csv-file] defaults to "users.csv"
HELPDOC
}

exit_error() {
  usage
  exit 1
}

exit_good() {
  exit 0
}

while getopts "ha:k:p:u:c:" options; do
  case "${options}" in
    h)
      usage
      exit_good
      ;;
    a)
      CONTRAST_SE_AUTH_HEADER=${OPTARG}
      ;;
    k)
      CONTRAST_SE_API_KEY=${OPTARG}
      ;;
    p)
      ADMIN_PASSWORD=${OPTARG}
      ;;
    u)
      CONTRAST_URL=${OPTARG}
      ;;
    c)
      INPUT_FILE=${OPTARG}
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

PS3='Please enter your choice: '
options=("Create numbered users" "Create named users from $INPUT_FILE" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create numbered users")
            #Prompt for the number of users
            echo -n "Enter number of user accounts: "
            read x

            #Limit the users to 50, we don't want to DOS eval
            while [[ $x -lt 0 || $x -gt 50 ]]; do
                echo "Please enter a value between 1 and 50"
                read x
            done
            
            #Write the users to csv file
            echo "Generating $x user accounts in csv file"

            if test -f $INPUT_FILE ; then
              rm $INPUT_FILE
            fi
            touch $INPUT_FILE
            echo "first,last,email" >> $INPUT_FILE
            counter=1
            while [ $counter -le $x ]
            do
                echo "User$counter,User$counter,user$counter@user$counter.com" >> $INPUT_FILE
                ((counter++))
            done

            break
            ;;
        "Create named users from $INPUT_FILE")
            echo "Creating users from CSV file"

            break
            ;;
        "Quit")
            exit
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

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
            \"name\": \"$first's Workshop Org\",
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
            echo "Organisation $name created successfully for $email"

            # Consider adding both the email and uuid to the output.  It will make the parsing a little more complex in the
            # delete-orgs script, but the idea is to more easily correlate the email+uuid in the file so we know who we're referencing (just in case)
            uuid=$(echo "$output" | jq '.organization.organization_uuid'| tr -d \")
            echo $uuid >> $OUTPUT_FILE
        else
            error=$(echo "$output" | jq '.messages[0]')
            echo "Could not create organisation for user $email, error: $error"
        fi
    fi
done < $INPUT_FILE