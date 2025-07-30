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
echo -e "Thank you ${RED} $DOMAIN ${NC} is a great domain :) Please wait, We working on adding the Certificate and the Hostname"
echo "                  "
echo "                  "

while IFS= read -r line; do
  cat /workdir/conf/sample.yml | sed 's/foo.com/'$line'/g' >$workdir/$line.yml
  akamai cps create --file $workdir/$line.yml --contract-id $contractId --force --section default
done <"$CONF_PATH"
# Done CRT added
# Start add Hostname

#Get the update from Akamai - This will overwrite the local files for the property
akamai property-manager update-local -p $property_name --section default --force-update

#remove the last line from the file
cp $workdir/hostnames.json $workdir/hostnames.json.tmp
sed '$d' $workdir/hostnames.json.tmp > $workdir/hostnames.json
rm -f $workdir/hostnames.json.tmp

##add new text to file
filename=$workdir/hostnames.json
newtext=',\n{\n"cnameType": "EDGE_HOSTNAME",\n"edgeHostnameId":'$edgeHostnameId',\n"cnameFrom": "foo.com",\n"cnameTo": "'$property_name'.edgesuite.net",\n"certProvisioningType": "CPS_MANAGED"\n}\n]'
## Check the new text is empty or not
if [ "$newtext" != "" ]; then
      echo -e $newtext >> $filename
fi
##replase the foo.com with the domain cnameTo
cd /workdir/scripts/
File="domain-list.txt"
while IFS= read -r line
do
  cp $workdir/hostnames.json $workdir/hostnames.json.tmp
  sed 's/foo.com/'$line'/g' $workdir/hostnames.json.tmp > $workdir/hostnames.json
  rm -f $workdir/hostnames.json.tmp
done < "$CONF_PATH"

cd /workdir/
akamai property-manager merge -n -p $property_name
akamai property-manager save -p $property_name
akamai property-manager -p $property_name activate -n STAGING
akamai property-manager -p $property_name activate -n PROD
