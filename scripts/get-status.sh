#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m' # No Color

CONF_PATH="/workdir/conf/domain-list.txt"

if [ -z "$1" ]; then
  echo -e "${RED}No domain name argument supplied${NC}"
  echo "************  Type your domain name  ************"
  echo "                  "
  echo "                  "
  read -p "Please type the domain name: "
  DOMAIN="$REPLY"
  echo "$DOMAIN" >$CONF_PATH
else
  DOMAIN="$1"
  echo "$DOMAIN" >$CONF_PATH
fi

echo "                  "
echo "                  "
echo -e "Thank you ${RED} $DOMAIN ${NC} is a great domain :) Please wait few sec to get the domain status"
echo "                  "
echo "                  "

while IFS= read -r line; do
  akamai cps status --cn $line --section default
  echo "domain: $line"
done <"$CONF_PATH"

echo "End script"
