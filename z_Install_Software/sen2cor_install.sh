#!/usr/bin/env bash
cd ${defdir}

## Create the necessary environment
yes yes | conda create --name atmosphere pip
source activate atmosphere

## 3. DOWNLOAD AND INSTALL LATEST SEN2COR
SEN2CREPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - ${SEN2CREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | tail -n 1 | cut -d \" -f 8)
SEN2SITE=${SEN2CREPO}${SEN2VERSION}
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
echo "export SEN2COR_BIN=\"${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor\"" >> ${profilenondebian}
echo "export GDAL_DATA=\"${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/cfg/gdal_data\"" >> ${profilenondebian}
source $HOME/.bashrc

## Close the conda environment.
source deactivate
