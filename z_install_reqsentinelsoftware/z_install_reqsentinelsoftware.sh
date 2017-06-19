#!/usr/bin/env bash

echo -n "
This bash script will install Anaconda, SEN2COR and SNAP.
Existing user settings will be overwritten.
Are you sure you want to install  this script? [yes|no]
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
cd ${defdir}
mkdir ${defdir}/DL_temp
dldir=${defdir}/DL_temp

## 1. DOWNLOAD AND INSTALL LATEST ANACONDA (FOR PYTHON 2.7)
CONTREPO=https://repo.continuum.io/archive/
ANACONDAURL=$(wget -q -O - ${CONTREPO} index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
wget -O ${dldir}/anaconda.sh ${CONTREPO}${ANACONDAURL}
bash ${dldir}/anaconda.sh -b #uses the default settings

## 2. CHECK PYTHON DIRECTORY
conda search "^python$" #version checker
conda info --envs #environment checker
which python # directory checker

## 3. DOWNLOAD AND INSTALL LATEST SEN2COR
SEN2CREPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - ${SEN2CREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2SITE=${SEN2CREPO}${SEN2VERSION}
SEN2URL=$(wget -q -O - ${SEN2SITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2cor.tar.gz ${SEN2SITE}${SEN2URL}
mkdir ${defdir}/SEN2COR -p
tar -xzvf ${dldir}/sen2cor.tar.gz -C ${defdir}/SEN2COR/
cd ${defdir}/SEN2COR/sen2cor-${SEN2VERSION}
yes yes | python setup.py install
cp -rf ${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/ ${dldir}

# Set environment variables
sudo nano /etc/bash.bashrc_profile
## add the following lines at the end of the doc , save and quit
export SEN2COR_HOME=/home/user/sen2cor
export SEN2COR_BIN=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor
export GDAL_DATA=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/gdal_data

## 4. DOWNLOAD AND INSTALL SEN2THREE
SEN2TREPO=http://step.esa.int/thirdparties/sen2three/
SEN2TVERSION=$(wget -q -O - ${SEN2TREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2TSITE=${SEN2TREPO}${SEN2TVERSION}
SEN2TURL=$(wget -q -O - ${SEN2TSITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2three.tar.gz ${SEN2TSITE}${SEN2TURL}
mkdir ${defdir}/SEN2THREE -p
tar -xzvf ${dldir}/sen2three.tar.gz -C ${defdir}/SEN2THREE/
cd ${defdir}/SEN2THREE/sen2three-${SEN2TVERSION}
apt-get install -y python-setuptools
yes yes | python setup.py install



## 5. DOWNLOAD AND INSTALL LATEST SNAP
SNAPREPO=http://step.esa.int/downloads/
SNAPVERSION=$(wget -q -O - ${SNAPREPO} | egrep '[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | grep -v ".txt" | tail -n 1 | cut -d \" -f 8)
SNAPINSTALLDIR=$(wget -q -O - ${SNAPREPO}${SNAPVERSION} | grep "installers" | tail -n 1 | cut -d \" -f 8)
SNAPFILE=$(wget -q -O - ${SNAPREPO}${SNAPVERSION}${SNAPINSTALLDIR} | grep "all" | grep "unix" |  tail -n 1 | cut -d \" -f 8)
wget -O ${dldir}/snap.sh ${SNAPREPO}${SNAPVERSION}${SNAPINSTALLDIR}${SNAPFILE}
sudo sh esa-snap_all_unix_5_0.sh -c
