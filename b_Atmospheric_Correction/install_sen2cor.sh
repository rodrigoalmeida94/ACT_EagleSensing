#!/usr/bin/env bash
# Go to home directory
cd ~


# PRELIMINARIES
# Setup download folder, assuming data folder is inside user
mkdir /home/user/DL_temp

## 1. INSTALL ANACONDA

# You can change what anaconda version you want at
# https://repo.continuum.io/archive/
wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh
bash Anaconda2-4.2.0-Linux-x86_64.sh -b -p ~/anaconda
rm Anaconda2-4.2.0-Linux-x86_64.sh
echo 'export PATH="~/anaconda2/bin:$PATH"' >> ~/.bashrc

# Updating to latest
conda update conda


# Alternate script
CONTREPO=https://repo.continuum.io/archive/
# Stepwise filtering of the html at $CONTREPO
# Get the topmost line that matches our requirements, extract the file name.
ANACONDAURL=$(wget -q -O - $CONTREPO index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
wget -O ~/DL_temp/anaconda.sh $CONTREPO$ANACONDAURL
bash ~/DL_temp/anaconda.sh


## 2. CHECK PYTHON DIRECTORY
conda search "^python$" #version checker
conda info --envs #environment checker
which python # directory checker

## 3. INSTALL SEN2COR

# Download from source


SEN2URL=$(wget -q -O - $SEN2SITE | grep "tar.gz" | head -n 1 | cut -d \" -f 8)
wget -O ~/DL_temp/sen2cor.tar.gz $SEN2SITE$SEN2URL
bash ~/DL_temp/sen2cor.tar.gz


SEN2SITE=http://step.esa.int/thirdparties/sen2cor/2.3.1/
wget -O ~/DL_temp/sen2cor.tar.gz $SEN2SITE
bash ~/DL_temp/sen2cor.sh

# Install
python setup.py install

# Set environment variables

bash sudo nano /etc/bash.bashrc_profile

add the following lines at the end of the doc , save and quit

export SEN2COR_HOME=/home/user/sen2cor
export SEN2COR_BIN=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor
export GDAL_DATA=/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/gdal_data





## Change Underlying lines to install in correct directories (also fix most current versions)
mkdir /home/user/SNAP
cd /home/user/SNAP
wget http://step.esa.int/downloads/5.0/installers/esa-snap_all_unix_5_0.sh
sudo sh esa-snap_all_unix_5_0.sh -c

python path: /home/user/anaconda2/bin/python


----------------------------------------

mkdir /home/user/SEN2COR
cd /home/user/SEN2COR
cd /home/user/SEN2COR
wget http://step.esa.int/thirdparties/sen2cor/2.3.1/sen2cor-2.3.1.tar.gz
tar xvzf sen2cor-2.3.1.tar.gz
cd sen2cor-2.3.1

python setup.py install

----------------------------------------


