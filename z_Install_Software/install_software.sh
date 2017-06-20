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
pardir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir ${defdir}/DL_temp -p
dldir=${defdir}/DL_temp

#1. Call anaconda installer
cd $pardir
source ./anaconda_install.sh

#2. Call sen2cor install
cd $pardir
source ./sen2cor_install.sh

#3. Call sen2three install
cd $pardir
source ./sen2three_install.sh

#4. Call snap install
cd $pardir
source ./sen2three_install.sh
