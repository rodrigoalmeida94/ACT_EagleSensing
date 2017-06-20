#!/usr/bin/env bash

## 1. DOWNLOAD AND INSTALL ANACONDA (FOR PYTHON 2.7)
CONTREPO=https://repo.continuum.io/archive/
ANACONDAURL=$(wget -q -O - ${CONTREPO} index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | grep "2.4.2" | head -n 1 | cut -d \" -f 2)
#ANACONDAURL=$(wget -q -O - ${CONTREPO} index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
#LATEST ANACONDA VERSION DOES NOT WORK WITH LATEST SEN2COR (YET)
wget -O ${dldir}/anaconda.sh ${CONTREPO}${ANACONDAURL}
bash ${dldir}/anaconda.sh -b #uses the default settings
echo export PATH=${defdir}/anaconda2/bin/:$PATH >> $HOME/.bashrc
source $HOME/.bashrc

## 2. CONDA UPDATE + INSTALL SOME DEPENDENCIES
conda update conda
conda updata anaconda
apt-get install -y python-setuptools
apt-get install expect