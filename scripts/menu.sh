#!/usr/bin/env bash

export MODE="status"

help() {
  # `cat << EOF` This means that cat should stop reading when EOF is detected
  cat <<EOF
Usage: ./menu.sh --target=foo.com [ --delete-certificate ] [ --status ] [ --help ]

Run Akamai Cli in the automation or manual mode

    -h, --help                  Display help

    -a, --activate              Create certificate, hostname and activate property for the domain

    -d, --delete                Delete certificate for the domain

    -s, --status                Get certificate status for the domain (default mode)

    -t, --target                The domain name to run the script for

EOF
}

for i in "$@"; do
  case $i in
  -h | --help=*)
    help
    ;;

  -a | --activate)
    export MODE="activate"
    ;;

  -d | --delete)
    #    export DELETE="${i#*=}"
    export MODE="delete"
    ;;

  -s | --status)
    #    export STATUS="${i#*=}"
    export MODE="status"
    ;;

  -t | --target=*)
    export TARGET="${i#*=}"
    ;;

  *)
    help
    exit
    ;;
  esac
done

if [ -z "$TARGET" ]; then
  echo "The --target option is required"
  echo ""
  help && exit 1
fi

# Download of CPS enrollments and common names for faster local retrieval
export $(grep -v '^#' .env | xargs)
akamai cps setup --section default

case $MODE in
status)
  echo "Checking status for the [ $TARGET ] domain"
  bash scripts/get-status.sh "$TARGET"
  ;;
activate)
  echo "Creating certificate, hostname and activate property for the [ $TARGET ] domain"
  bash scripts/add-crt-host-activate.sh $TARGET
  ;;
delete)
  echo "Deleting certificate for the [ $TARGET ] domain"
  bash scripts/delete-crt.sh $TARGET
  ;;
*)
  help && exit
  ;;
esac

exit 0