#!/usr/bin/env bash
source pram.sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "************  Type your new domain name ************"
echo "                  "
echo "                  "
read -p "Please type the domain name: "
echo "$REPLY" > /workdir/script/domain-list.txt
echo "                  "
echo "                  "
echo -e "Thank you ${RED} $REPLY ${NC} is a great domain :) Please wait, We working on adding the Certificate"
echo "                  "
echo "                  "

File="domain-list.txt"
while IFS= read -r line
do
  cat sample.yml | sed 's/foo.com/'$line'/g' > $workdir/crt/$line.yml
  akamai cps create --file $workdir/crt/$line.yml --contract-id $contractId --force --section default
  echo "domain: $line"
done < "$File"

read -p "Press any key to return to menu ..."

sh menu.sh
