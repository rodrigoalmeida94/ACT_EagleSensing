#!/usr/bin/env bash
cd ${defdir}

## 3. DOWNLOAD AND INSTALL LATEST SEN2COR
SEN2CREPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - ${SEN2CREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | tail -n 1 | cut -d \" -f 8)
SEN2SITE=${SEN2CREPO}${SEN2VERSION}
SEN2URL=$(wget -q -O - ${SEN2SITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
sudo wget -O ${dldir}/sen2cor.tar.gz ${SEN2SITE}${SEN2URL}
mkdir ${defdir}/SEN2COR -p
tar -xzvf ${dldir}/sen2cor.tar.gz -C ${defdir}/SEN2COR/
cd ${defdir}/SEN2COR/sen2cor-${SEN2VERSION}
yes yes | python setup.py install
#cp -rf ${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/ ${dldir}

SEN2VERSION=${SEN2VERSION%?}
echo "" >> ${profilenondebian}
echo "export SEN2COR_HOME=\"${defdir}/.config/sen2cor\"" >> ${profilenondebian}
echo "export SEN2COR_BIN=\"${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor\"" >> ${profilenondebian}
echo "export GDAL_DATA=\"${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/cfg/gdal_data\"" >> ${profilenondebian}

source $HOME/.bashrc