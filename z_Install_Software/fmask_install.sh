#!/usr/bin/env bash
defdir=$HOME
dldir=${defdir}/DL_temp

FMASKREPO=https://bitbucket.org/chchrsc/python-fmask/downloads/
FMASKFILE=$(wget -q -O - ${FMASKREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]].tar.gz' | head -n 1 | cut -d \" -f 2)
wget -O ${dldir}/fmask.tar.gz https://bitbucket.org$FMASKFILE
sudo t

cd python-fmask-0.4.4
python setup.py build