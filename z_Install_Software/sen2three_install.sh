#!/usr/bin/env bash
cd ${defdir}

## 4. DOWNLOAD AND INSTALL SEN2THREE
SEN2TREPO=http://step.esa.int/thirdparties/sen2three/
SEN2TVERSION=$(wget -q -O - ${SEN2TREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2TSITE=${SEN2TREPO}${SEN2TVERSION}
SEN2TURL=$(wget -q -O - ${SEN2TSITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
sudo wget -O ${dldir}/sen2three.tar.gz ${SEN2TSITE}${SEN2TURL}
sudo mkdir ${defdir}/SEN2THREE -p
sudo tar -xzvf ${dldir}/sen2three.tar.gz -C ${defdir}/SEN2THREE/
cd ${defdir}/SEN2THREE/sen2three-${SEN2TVERSION}
yes yes | python setup.py install

 if grep -q export SEN2THREE_HOME=${defdir}/.config/sen2three "${profilefile}"; then
   exit
   else sudo cat <<EOF >> ${profilefile}
export SEN2THREE_HOME=${defdir}/.config/sen2three
export SEN2THREE_BIN=/home/user/anaconda2/lib/python2.7/site-packages/sen2three-${SEN2TVERSION}-py2.7.egg/sen2three
EOF
 fi

 if grep -q export SEN2THREE_HOME=${defdir}/.config/sen2three "${profilenondebian}"; then
   exit
   else sudo cat <<EOF >> ${profilenondebian}
export SEN2THREE_HOME=${defdir}/.config/sen2three
export SEN2THREE_BIN=/home/user/anaconda2/lib/python2.7/site-packages/sen2three-${SEN2TVERSION}-py2.7.egg/sen2three
EOFsen2three to default .config folder + changed anaconda version (CANNOT BE LATEST)
 fi