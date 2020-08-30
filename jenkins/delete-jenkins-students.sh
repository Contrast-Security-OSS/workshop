#!/bin/bash

# This script has a dependency on curl.

# Given a list of students, create logins on a jenkins server for them.
JENKINS_ADMIN_USERNAME=""
JENKINS_ADMIN_PASSWORD=""
JENKINS_ADMIN_URL="http://jenkins"
INPUT_FILE="jenkins-students.output.csv"

usage() {
  cat <<HELPDOC
Run this script to create students as users in an org.

Usage: $0 <options>
Command options:
      [-n JENKINS_ADMIN_USERNAME]
      [-p JENKINS_ADMIN_PASSWORD]
      [-u JENKINS_ADMIN_URL]
      [-i input file] student names in csv format"
HELPDOC
}

exit_error() {
  usage
  exit 1
}

exit_good() {
  exit 0
}

while getopts "hn:p:u:i:" options; do
  case "${options}" in
  h)
    usage
    exit_good
    ;;
  n)
    JENKINS_ADMIN_USERNAME=${OPTARG}
    ;;
  p)
    JENKINS_ADMIN_PASSWORD=${OPTARG}
    ;;
  u)
    JENKINS_ADMIN_URL=${OPTARG}
    ;;
  i)
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

#Alert the user if we don't have creds
if [[ $JENKINS_ADMIN_PASSWORD == "" ]]; then
  printf "Please supply a password to access the Jenkins server\n"
  exit_error
fi

#List the users we are going to create
IFS=','
[ ! -f $INPUT_FILE ] && {
  echo "$INPUT_FILE file not found"
  exit
}
while read first last email; do
  [[ "$first" != "first" ]] && echo "$first $last ($email)"
done <$INPUT_FILE

#Prompt the user - continue?
while true; do
  read -p "Do you wish to delete these users (y/n)? " yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer Y or N." ;;
  esac
done

#Call the API to create the orgs
echo "Calling the API"
IFS=','
[ ! -f $INPUT_FILE ] && {
  echo "$INPUT_FILE file not found"
  exit
}
while read first last email; do
  if [[ "$first" != "first" ]]; then
    groovy=$(
      cat <<-GROOVY
import hudson.model.User
User u = User.get('$email')
u.delete()
GROOVY
    )
    echo $groovy | java -jar jenkins-cli.jar -auth $JENKINS_ADMIN_USERNAME:$JENKINS_ADMIN_PASSWORD -s $JENKINS_ADMIN_URL groovy =
  fi
done <$INPUT_FILE
