#!/usr/bin/env bash

FMASKREPO=https://bitbucket.org/chchrsc/python-fmask/downloads/
FMASKVERSION=$(wget -q -O - ${FMASKREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]].tar.gz' | head -n 1 | cut -d \" -f 2)


SEN2URL=$(wget -q -O - ${SEN2SITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2cor.tar.gz ${SEN2SITE}${SEN2URL}

