#!/usr/bin/env bash
defdir=$HOME
dldir=${defdir}/DL_temp

FMASKREPO=https://bitbucket.org/chchrsc/python-fmask/downloads/
FMASKFILE=$(wget -q -O - ${FMASKREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]].tar.gz' | head -n 1 | cut -d \" -f 2)
FMASKVERSION=$(echo ${FMASKFILE} | egrep -o '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]')
wget -O ${dldir}/fmask.tar.gz https://bitbucket.org$FMASKFILE
mkdir ${defdir}/FMASK
sudo tar -xzvf ${dldir}/fmask.tar.gz -C ${defdir}/FMASK/

cd ${defdir}/FMASK/python-fmask-$FMASKVERSION
python setup.py build