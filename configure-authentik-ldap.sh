#!/bin/bash -
#===============================================================================
#
#          FILE: configure-authentik-ldap.sh
#
#         USAGE: ./configure-authentik-ldap.sh
#
#   DESCRIPTION: Configures the authentik proxy to connect to an authentik backend
#
#        AUTHOR: Andrew Tyler (assimilat@gmail.com), 
#       CREATED: 01/07/2022 03:38:02 PM
#      REVISION:  1
#===============================================================================

if [ -f "/etc/conf.d/authentik-proxy" ];
then
  source /etc/conf.d/authentik-proxy;
fi
if [ -n "${AUTHENTIK_HOST}" ];
then
  DEFAULT_AUTHENTIK_HOST="${AUTHENTIK_HOST}";
else
  DEFAULT_AUTHENTIK_HOST="127.0.0.1";
fi
if [ -n "${AUTHENTIK_TOKEN}" ];
then
  DEFAULT_AUTHENTIK_TOKEN="${AUTHENTIK_TOKEN}";
else
  DEFAULT_AUTHENTIK_TOKEN="";
fi
if [ -n "${AUTHENTIK_INSECURE}" ];
then
  DEFAULT_AUTHENTIK_INSECURE="${AUTHENTIK_INSECURE}";
else
  DEFAULT_AUTHENTIK_INSECURE="false";
fi
AUTHENTIK_HOST="";
AUTHENTIK_TOKEN="";
AUTHENTIK_INSECURE="";
while [ -z "${AUTHENTIK_HOST}" ];
do
  echo -ne "Please enter the address of the Authentik backend [${DEFAULT_AUTHENTIK_HOST}]:"
  read AUTHENTIK_HOST
  if [ -z "${AUTHENTIK_HOST}" ];
  then
    echo "Please enter the a value for the Authentik backend.";
  fi
done
echo -ne "Please enter the Authentik Token issued by the Authentik backend[${DEFAULT_AUTHENTIK_TOKEN}]:"
read AUTHENTIK_TOKEN
while [ -z "${AUTHENTIK_INSECURE}" ];
do
  echo -ne "Would you like to disable SSL for communication between the proxy and the backend?["${DEFAULT_AUTHENTIK_INSECURE}"]:"
  read AUTHENTIK_INSECURE_TMP
  if [ -z "${AUTHENTIK_INSECURE_TMP}" ];
  then
    AUTHENTIK_INSECURE="false";
  else
    if [ -z "$(echo "${AUTHENTIK_INSECURE}" | grep -i "true\|false")" ];
    then
      echo "Value must be 'true' or 'false'";
      AUTHENTIK_INSECURE="";
    fi
  fi
done
cat <<EOF > /etc/conf.d/authentik-ldap
AUTHENTIK_HOST="${AUTHENTIK_HOST}"
AUTHENTIK_TOKEN="${AUTHENTIK_TOKEN}"
AUTHENTIK_INSECURE="${AUTHENTIK_INSECURE}"
EOF
