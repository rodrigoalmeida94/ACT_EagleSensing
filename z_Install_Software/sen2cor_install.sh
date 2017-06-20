#!/usr/bin/env bash
cd ${defdir}

## 3. DOWNLOAD AND INSTALL LATEST SEN2COR
SEN2CREPO=http://step.esa.int/thirdparties/sen2cor/
SEN2VERSION=$(wget -q -O - ${SEN2CREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2SITE=${SEN2CREPO}${SEN2VERSION}
SEN2URL=$(wget -q -O - ${SEN2SITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2cor.tar.gz ${SEN2SITE}${SEN2URL}
sudo mkdir ${defdir}/SEN2COR -p
tar -xzvf ${dldir}/sen2cor.tar.gz -C ${defdir}/SEN2COR/
cd ${defdir}/SEN2COR/sen2cor-${SEN2VERSION}
yes yes | python setup.py install
#cp -rf ${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/ ${dldir}

# Set environment variables
profilefile=/etc/bash.bashrc
profilenondebian=$HOME/.bashrc

 if grep -q export SEN2COR_HOME=${defdir}/.config/sen2cor "${profilefile}"; then
   exit
   else sudo cat <<EOF >> ${profilefile}
export SEN2COR_HOME=${defdir}/.config/sen2cor
export SEN2COR_BIN=${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor
export GDAL_DATA=${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/cfg/gdal_data
EOF
 fi

 if grep -q export SEN2COR_HOME=${defdir}/sen2cor "${profilenondebian}"; then
   exit
   else sudo cat <<EOF >> ${profilenondebian}
export SEN2COR_HOME=${defdir}/.config/sen2cor
export SEN2COR_BIN=${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor
export GDAL_DATA=${defdir}/anaconda2/lib/python2.7/site-packages/sen2cor-${SEN2VERSION}-py2.7.egg/sen2cor/cfg/gdal_data
EOF
 fi