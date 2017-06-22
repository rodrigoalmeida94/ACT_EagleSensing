#!/usr/bin/env bash
cd ${defdir}

## Create the necessary environment
yes yes | conda create -n sen2three
source activate sen2three pip

## 4. DOWNLOAD AND INSTALL SEN2THREE
SEN2TREPO=http://step.esa.int/thirdparties/sen2three/
SEN2TVERSION=$(wget -q -O - ${SEN2TREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | tail -n 1 | cut -d \" -f 8)
SEN2TSITE=${SEN2TREPO}${SEN2TVERSION}
SEN2TURL=$(wget -q -O - ${SEN2TSITE} | grep "tar" | head -n 1 | cut -d \" -f 8)
wget -O ${dldir}/sen2three.tar.gz ${SEN2TSITE}${SEN2TURL}
tar -xzvf ${dldir}/sen2three.tar.gz -C ${dldir}/
cd ${dldir}/sen2three-${SEN2TVERSION}
yes yes | python setup.py install

## Drop off / at the end.
SEN2TVERSION=${SEN2TVERSION%?}

## Add path variables to bashrc for use of sen2cor through terminal.
echo "" >> ${profilenondebian}
echo "export SEN2THREE_HOME=\"${defdir}/.config/sen2three\"" >> ${profilenondebian}
echo "export SEN2THREE_BIN=\"/home/user/anaconda2/lib/python2.7/site-packages/sen2three-${SEN2TVERSION}-py2.7.egg/sen2three\"" >> ${profilenondebian}
source $HOME/.bashrc


## Close the conda environment.
source deactivate