#!/bin/bash

clear
echo "************  Welcome to Akamai CLI API ************"
echo "                  "
echo "                  "
echo "                  "
echo -e "Please select one from the options below"
echo "                  "
echo "                  "

echo "  1) Add New CRT + Hostname + Activate"
echo "  2) Add New CRT + Hostname"
echo "  3) Add new CRT"
echo "  4) Delete CRT"
echo "  5) Get CRT Status"
echo "  6) Add Hostname"
echo "  7) Activate Staging and Production"
echo "  8) Exit"
echo "                  "
echo "                  "
echo "************  Welcome to Akamai CLI API ************"

read n
case $n in
  1)  sh add-crt-host-activate.sh;;
  2)  sh add-crt-host.sh;;
  3)  sh add-crt.sh;;
  4)  sh delete-crt.sh;;
  5)  sh get-status.sh;;
  6)  sh add-hostname.sh;;
  7)  sh activate.sh;;
  8)  exit;;
esac
