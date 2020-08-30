#!/bin/bash

yamlfile=""

usage() {
  cat <<HELPDOC
Run this script to setup files for your kubernetes instances.
This only generates yaml files and simple invocation commands you can cut-and-paste to run the real deal.

Usage: $0 <options>
Command options:
    [-Y path-to-contrast_security.yaml file] this option reads these values from your file and not your environment
      [-k CONTRAST__API__KEY]
      [-s CONTRAST__API__SERVICE_KEY]
      [-u CONTRAST__API__URL]
      [-n CONTRAST__API__USER_NAME]

    [-U username] - name of the user.  This will also be the output directory

    [-c CONTRAST__DEMO__COUNTER] OR [-C] use builtin demo counter
    [-p CONTRAST__DEMO__CUSTOMER] OR [-P] use "Demo"
    [-i CONTRAST__DEMO__INITIALS] OR [-I] use "CS"
HELPDOC
}

exit_error() {
  usage
  exit 1
}

exit_good() {
  exit 0
}

process_yaml() {
  ## This is an elementary parsing.  We're NOT using yq because we want portability, and the contrast_security.yaml file is fairly simple.
  echo "processing $yamlfile"
  cat $yamlfile
  # read yaml file
  eval $(parse_yaml $yamlfile "yaml_")

  if [ -z ${yaml_api_url+UNDEFINED} ]
  then
    echo "yaml parse did not find api:url:"
  else
    CONTRAST__API__URL=$yaml_api_url
  fi

  if [ -z ${yaml_api_api_key+UNDEFINED} ]
  then
    echo "yaml parse did not find api:api_key:"
  else
    CONTRAST__API__KEY=$yaml_api_api_key
  fi

  if [ -z ${yaml_api_service_key+UNDEFINED} ]
  then
    echo "yaml parse did not find api:service_key:"
  else
    CONTRAST__API__SERVICE_KEY=$yaml_api_service_key
  fi

  if [ -z ${yaml_api_user_name+UNDEFINED} ]
  then
    echo "yaml parse did not find api:user_name:"
  else
    CONTRAST__API__USER_NAME=$yaml_api_user_name
  fi

}

parse_yaml() {
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_\-]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
        vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
        printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
  }'
}

while getopts "hY:U:k:s:u:n:Cc:Pp:Ii:" options; do
  case "${options}" in
    h)
      usage
      exit_good
      ;;
    Y)
      yamlfile=${OPTARG}
      process_yaml
      ;;

    U)
      username=${OPTARG}
      ;;
    # Process command-line options in case yaml file does not contain values.
    k)
      C_CONTRAST__API__KEY=${OPTARG}
      ;;
    s)
      C_CONTRAST__API__SERVICE_KEY=${OPTARG}
      ;;
    u)
      C_CONTRAST__API__URL=${OPTARG}
      ;;
    n)
      C_CCONTRAST__API__USER_NAME=${OPTARG}
      ;;

    p)
      echo "Using ${OPTARG} for customer"
      CONTRAST__DEMO__CUSTOMER=${OPTARG}
      ;;
    P)
      CONTRAST__DEMO__CUSTOMER="DEMO"
      echo "Using DEFAULT customer ${CONTRAST__DEMO__CUSTOMER}"
      ;;
    c)
      echo "Using ${OPTARG} for counter"
      CONTRAST__DEMO__COUNTER=${OPTARG}
      ;;
    C)
      # Maybe just  unset the envvar here and let the defaulting logic below do the right thing.
      CONTRAST__DEMO__COUNTER=$(date +%m%d-%H%M)
      echo "Using DEFAULT counter ${CONTRAST__DEMO__COUNTER}"
      ;;
    i)
      echo "Using ${OPTARG} for initials"
      CONTRAST__DEMO__INITIALS=${OPTARG}
      ;;
    I)
      CONTRAST__DEMO__INITIALS="cs"
      echo "Using DEFAULT initials ${CONTRAST__DEMO__INITIALS}"
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

if [ -z "$CONTRAST__DEMO__COUNTER" ];
then
  CONTRAST__DEMO__COUNTER=$(date +%m%d-%H%M)
  echo "\$CONTRAST__DEMO__COUNTER not set, setting to $CONTRAST__DEMO__COUNTER"
fi

if [ -z "$CONTRAST__DEMO__CUSTOMER" ];
then
  CONTRAST__DEMO__CUSTOMER="Demo"
fi

# Process API values as they are set

if [ -z "$CONTRAST__API__KEY" ];
then
  if [ -z "$C_CONTRAST__API__KEY" ]
  then
    echo "\$CONTRAST__API__KEY is not defined"
    exit_error
  else
    CONTRAST__API__KEY = C_CONTRAST__API__KEY
  fi
fi

if [ -z "$CONTRAST__API__SERVICE_KEY" ];
then
  if [ -z "$C_CONTRAST__API__SERVICE_KEY"]
  then
    echo "\$CONTRAST__API__SERVICE_KEY is not defined"
    exit_error
  else
    CONTRAST__API__SERVICE_KEY = C_CONTRAST__API__SERVICE_KEY
  fi
fi

if [ -z "$CONTRAST__API__URL" ];
then
  if [ -z "$CONTRAST__API__URL" ]
  then
    echo "\$CONTRAST__API__URL is not defined"
    exit_error
  else
    CONTRAST__API__URL = C_CONTRAST__API__URL
  fi
fi

if [ -z "$CONTRAST__API__USER_NAME" ];
then
  if [ -z "$CONTRAST__API__USER_NAME" ]
  then
    echo "\$CONTRAST__API__USER_NAME is not defined"
    exit_error
  else
    CONTRAST__API__USER_NAME = C_CONTRAST__API__USER_NAME
  fi
fi

## Search and replace over a list of files.

mkdir -p $CONTRAST__DEMO__CUSTOMER/$username
for f in *.template.yaml
do
  newfile="${f%.template.yaml}"
  echo "Processing $f as $username/$newfile"
  sed -e "s/<<CONTRAST__DEMO__CUSTOMER>>/$CONTRAST__DEMO__CUSTOMER/" \
  -e "s/<<CONTRAST__DEMO__INITIALS>>/$CONTRAST__DEMO__INITIALS/" \
  -e "s~<<CONTRAST__API__URL>>~$CONTRAST__API__URL~" \
  -e "s/<<CONTRAST__API__KEY>>/$CONTRAST__API__KEY/" \
  -e "s/<<CONTRAST__API__SERVICE_KEY>>/$CONTRAST__API__SERVICE_KEY/" \
  -e "s/<<CONTRAST__API__USER_NAME>>/$CONTRAST__API__USER_NAME/" < $f > "$CONTRAST__DEMO__CUSTOMER/$username/$newfile.yaml"
done

cat <<STARTUP > $CONTRAST__DEMO__CUSTOMER/startup-$username.sh
#!/bin/bash

date --utc +%FT%TZ
kubectl apply -f $username/configmap-demoapps.yaml
#kubectl apply -f $username/java-webgoat.yaml -f $username/java-spring-petclinic.yaml -f $username/nodejs-juice-shop.yaml -f $username/python-djangoat.yaml
kubectl apply -f $username/java-webgoat.yaml -f $username/java-spring-petclinic.yaml
STARTUP

cat <<WAITONSERVICE > $CONTRAST__DEMO__CUSTOMER/waitonservice-$username.sh
#!/bin/bash

date --utc +%FT%TZ
external_ip=""
while [ -z \$external_ip ]; do
  echo "Waiting for end point $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-spring-petclinic-svc"
  external_ip=\$(kubectl get svc $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-spring-petclinic-svc --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "\$external_ip" ] && sleep 10
done

port=\$(kubectl get service $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-spring-petclinic-svc --template="{{range.spec.ports}}{{if .port}}{{.port}}{{end}}{{end}}")
echo "$CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-spring-petclinic-svc End point ready- http://\$external_ip:\$port"

date --utc +%FT%TZ
external_ip=""
while [ -z \$external_ip ]; do
  echo "Waiting for end point $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-webgoat-svc"
  external_ip=\$(kubectl get svc $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-webgoat-svc --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "\$external_ip" ] && sleep 10
done
port=\$(kubectl get service $CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-webgoat-svc --template="{{range.spec.ports}}{{if .port}}{{.port}}{{end}}{{end}}")
echo "$CONTRAST__DEMO__CUSTOMER$CONTRAST__DEMO__INITIALS-java-webgoat-svc End point ready - http://\$external_ip:\$port/WebGoat"

WAITONSERVICE

cat <<SHUTDOWN > $CONTRAST__DEMO__CUSTOMER/shutdown-$username.sh
#!/bin/bash

date --utc +%FT%TZ
#kubectl delete -f $username/java-webgoat.yaml -f $username/java-spring-petclinic.yaml -f $username/nodejs-juice-shop.yaml -f $username/python-djangoat.yaml -f $username/configmap-demoapps.yaml
kubectl delete -f $username/java-webgoat.yaml -f $username/java-spring-petclinic.yaml -f $username/configmap-demoapps.yaml
SHUTDOWN

chmod +x $CONTRAST__DEMO__CUSTOMER/startup-$username.sh
chmod +x $CONTRAST__DEMO__CUSTOMER/waitonservice-$username.sh
chmod +x $CONTRAST__DEMO__CUSTOMER/shutdown-$username.sh

echo "./startup-$username.sh" >> $CONTRAST__DEMO__CUSTOMER/all-startup.sh

echo "./waitonservice-$username.sh" >> $CONTRAST__DEMO__CUSTOMER/all-waitonservice.sh

echo "./shutdown-$username.sh" >> $CONTRAST__DEMO__CUSTOMER/all-shutdown.sh

chmod +x $CONTRAST__DEMO__CUSTOMER/all-startup.sh
chmod +x $CONTRAST__DEMO__CUSTOMER/all-waitonservice.sh
chmod +x $CONTRAST__DEMO__CUSTOMER/all-shutdown.sh
