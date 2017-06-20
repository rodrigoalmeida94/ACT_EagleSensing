#!/usr/bin/env bash

FMASKREPO=https://bitbucket.org/chchrsc/python-fmask/downloads/
FMASKFILE=$(wget -q -O - ${FMASKREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]].tar.gz' | head -n 1 | cut -d \" -f 2)
wget -O ${dldir}/fmask.tar.gz $FMASKREPO$FMASKVERSION


cd python-fmask-0.4.4
python setup.py build