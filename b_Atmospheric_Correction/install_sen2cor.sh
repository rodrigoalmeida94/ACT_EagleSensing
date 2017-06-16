#!/usr/bin/env bash
# Go to home directory
cd $HOME

# PRELIMINARIES
# Setup download folder, assuming data folder is inside user
mkdir $HOME/DL_temp

## 1. DOWNLOAD AND INSTALL LATEST ANACONDA (PYTHON 2.7)
CONTREPO=https://repo.continuum.io/archive/
ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
wget -O $HOME/DL_temp/anaconda.sh $CONTREPO$ANACONDAURL
bash $HOME/DL_temp/anaconda.sh

## 2. CHECK PYTHON DIRECTORY
conda search "^python$" #version checker
conda info --envs #environment checker
which python # directory checker

## 3. DOWNLOAD AND INSTALL SEN2COR
SEN2REPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - $SEN2REPO | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2SITE=$SEN2REPO$SEN2VERSION
SEN2URL=$(wget -q -O - $SEN2SITE | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ~/Downloads/sen2cor.tar.gz $SEN2SITE$SEN2URL
bash mkdir /home/user/SEN2COR
bash tar -xzvf ~/Downloads/sen2cor.tar.gz -C $HOME
python setup.py install -C /home/user/sen2cor-2.3.1

# Set environment variables
bash sudo nano /etc/bash.bashrc_profile

add the following lines at the end of the doc , save and quit

export SEN2COR_HOME=/home/user/sen2cor
export SEN2COR_BIN=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor
export GDAL_DATA=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/gdal_data

## DOWNLOAD AND INSTALL LATEST SNAP
SNAPREPO=http://step.esa.int/downloads/
SNAPVERSION=$(wget -q -O - $SNAPREPO| grep "$(date +%Y)" | grep -v ".txt" | tail -n 1 | cut -d \" -f 8)
SNAPINSTALLDIR=$(wget -q -O - $SNAPREPO$SNAPVERSION | grep "installers" | tail -n 1 | cut -d \" -f 8)
SNAPFILE=$(wget -q -O - $SNAPREPO$SNAPVERSION$SNAPINSTALLDIR | grep "all" | grep "unix" |  tail -n 1 | cut -d \" -f 8)
wget -O ~/Downloads/snap.sh $SNAPREPO$SNAPVERSION$SNAPINSTALLDIR$SNAPFILE



