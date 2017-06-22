#!/usr/bin/env bash
defdir=$HOME
mkdir ${defdir}/DL_temp -p
dldir=${defdir}/DL_temp
pardir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
profilenondebian=$HOME/.bashrc
cd $HOME

## 1. DOWNLOAD AND INSTALL ANACONDA (FOR PYTHON 2.7)
#CONTREPO=https://repo.continuum.io/archive/
#ANACONDAURL=$(wget -q -O - ${CONTREPO} index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | grep "2.4.2" | head -n 1 | cut -d \" -f 2)
ANACONDAURL=$(wget -q -O - ${CONTREPO} index.html | grep "Anaconda2-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
LATEST ANACONDA VERSION DOES NOT WORK WITH LATEST SEN2COR (YET)
wget -O ${dldir}/anaconda.sh ${CONTREPO}${ANACONDAURL}
cd ${dldir}
bash anaconda.sh -b

echo "" >> ${profilenondebian}
profilenondebian=$HOME/.bashrc
defdir=$HOME
echo "export PATH=\"${defdir}/anaconda2/bin:\$PATH\"" >> ${profilenondebian}

cd $pardir