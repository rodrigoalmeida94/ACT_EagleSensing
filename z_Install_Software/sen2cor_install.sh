#!/usr/bin/env bash
cd ${defdir}

## GRAB THE REQUIRED ANACONDA VERSION THAT LATEST SEN2COR NEEDS
SEN2CREPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - ${SEN2CREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | tail -n 1 | cut -d \" -f 8)
SEN2SITE=${SEN2CREPO}${SEN2VERSION}
SEN2SRN=$(wget -q -O - ${SEN2SITE} | grep "SRN" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2corSRN.pdf ${SEN2SITE}${SEN2SRN}
pdftotext ${dldir}/sen2corSRN.pdf
REQANAVERSION=$(egrep 'Anaconda [[:alnum:]]\.[[:alnum:]]\.[[:alnum:]] \(64-bit\)' ${dldir}/sen2corSRN.txt | head -n 1 | cut -d \| -f 2 | egrep -o '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]')

# CREATE THE NECESSARY ENVIRONMENT
yes yes | conda create -n atmosphere anaconda=${REQANAVERSION} python=2.7
source activate atmosphere

## 3. DOWNLOAD AND INSTALL LATEST SEN2COR
SEN2URL=$(wget -q -O - ${SEN2SITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2cor.tar.gz ${SEN2SITE}${SEN2URL}
tar -xzvf ${dldir}/sen2cor.tar.gz -C ${dldir}
cd ${dldir}/sen2cor-${SEN2VERSION}
yes yes | python setup.py install

# Drop the / at the end
SEN2VERSION=${SEN2VERSION%?}

## Add path variables to bashrc for use of sen2cor through terminal.
echo "" >> ${profilenondebian}
echo "export SEN2COR_HOME=\"${defdir}/.config/sen2cor\"" >> ${profilenondebian}
echo "export SEN2COR_BIN=\"${defdir}/anaconda2/envs/atmosphere/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor\"" >> ${profilenondebian}
echo "export GDAL_DATA=\"${defdir}/anaconda2/envs/atmosphere/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/cfg/gdal_data\"" >> ${profilenondebian}
source $HOME/.bashrc

## Install additional packages
yes yes | conda install -c conda-forge fire

pip install parmap
pip install lxml

## Close the conda environment.
source deactivate
