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
echo -e "Thank you ${RED} $REPLY ${NC} is a great domain :) Please wait, We working on adding the Certificate and the Hostname"
echo "                  "
echo "                  "

File="domain-list.txt"
while IFS= read -r line
do
  cat sample.yml | sed 's/foo.com/'$line'/g' > $workdir/crt/$line.yml
  akamai cps create --file $workdir/crt/$line.yml --contract-id $contractId --force --section default
  echo "domain: $line"
done < "$File"

# Done CRT added
# Start add Hostname

#Get the update from Akamai - This will overwrite the local files for the property
cd /workdir/
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
cd /workdir/script/
#File="domain-list.txt"
while IFS= read -r line
do
  cp $workdir/hostnames.json $workdir/hostnames.json.tmp
  sed 's/foo.com/'$line'/g' $workdir/hostnames.json.tmp > $workdir/hostnames.json
  rm -f $workdir/hostnames.json.tmp
done < "$File"

cd /workdir/
akamai property-manager merge -n -p $property_name
akamai property-manager save  -p $property_name
akamai property-manager -p $property_name activate -n STAGING
akamai property-manager -p $property_name activate -n PROD

read -p "Press any key to return to menu ..."
cd /
cd workdir/script/
