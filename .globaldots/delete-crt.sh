#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m' # No Color

clear
echo "************  Type your new domain name  ************"
echo "                  "
echo "                  "
read -p "Please type the domain name: "
echo "$REPLY" > /workdir/script/domain-list.txt

echo "                  "
echo "                  "
echo -e "Thank you ${RED} $REPLY ${NC} is a great domain :) We are working on to delete the Certificate"
echo "                  "
echo "                  "

File="/workdir/script/domain-list.txt"
while IFS= read -r line
do
   akamai cps retrieve-enrollment --cn $line --section default
   akamai cps delete --cn $line --force --section default

echo "domain: $line"
done < "$File"

read -p "Press any key to return to menu ..."

sh menu.sh
