#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CONF_PATH="/workdir/conf/domain-list.txt"

# Prompt for domain if not passed as argument
if [ -z "$1" ]; then
  echo -e "${RED}No domain name argument supplied${NC}"
  echo "************  Type your domain name  ************"
  echo "                  "
  echo "                  "
  read -p "Please type the domain name: "
  DOMAIN="$REPLY"
  echo "$DOMAIN" > "$CONF_PATH"
else
  DOMAIN="$1"
  echo "$DOMAIN" > "$CONF_PATH"
fi

echo "                  "
echo "                  "
echo -e "Thank you ${GREEN}$DOMAIN${NC} is a great domain :) Please wait, we're working on deleting the Certificate"
echo "                  "
echo "                  "

has_error=0  # track failure

# Process each domain in the file
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue  # skip empty lines

  echo "Checking enrollment for domain: $line"

  # Optional: check if the enrollment exists
  akamai cps retrieve-enrollment --cn "$line" --section default > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo -e "${YELLOW}Warning${NC}: Enrollment for ${RED}$line${NC} not found or inaccessible. Skipping delete."
    has_error=1
    continue
  fi

  # Attempt to delete the enrollment
  echo "Attempting to delete enrollment for $line"
  output=$(akamai cps delete --cn "$line" --force --section default 2>&1)
  exit_code=$?
  
  if [[ $output == *"Enrollment not found"* ]]; then
    exit_code=1
  fi

  if [[ $exit_code -eq 0 ]]; then
    echo -e "${GREEN}Success${NC}: Enrollment for ${line} deleted successfully. Details: $output"
  else
    echo -e "${RED}Error${NC}: Failed to delete enrollment for ${line}"
    echo -e "${YELLOW}Details:${NC} $output"
    has_error=1
  fi

  echo
done < "$CONF_PATH"

if [[ $has_error -ne 0 ]]; then
  echo -e "${RED}Script completed with errors.${NC}"
  exit 1
else
  echo -e "${GREEN}All enrollments deleted successfully.${NC}"
  exit 0
fi
