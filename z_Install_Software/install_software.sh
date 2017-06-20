#!/usr/bin/env bash

echo -n "
This bash script will install Anaconda, SEN2COR and SNAP.
Existing user settings will be overwritten.
Are you sure you want to install  these programs? [yes|no]
>>> "
read ans
while [[ (${ans} != "yes") && (${ans} != "Yes") && (${ans} != "YES") && (${ans} != "no") && (${ans} != "No") && (${ans} != "NO") ]]
do
echo -n "Please answer 'yes' or 'no':
>>> "
read ans
done
if [[ (${ans} != "yes") && (${ans} != "Yes") && (${ans} != "YES") ]]
then
echo "The install agreement wasn't approved, aborting installation."
exit 2
fi

# 0. DEFINE DIRECTORY VARIABLES
defdir=$HOME
mkdir ${defdir}/DL_temp
dldir=${defdir}/DL_temp

#1. Call anaconda installer
. ./anaconda_install.sh

#2. Call sen2cor install

. ./sen2cor_install.sh

#3. Call sen2three install

. ./sen2three_install.sh

#4. Call snap install

. ./sen2three_install.sh
