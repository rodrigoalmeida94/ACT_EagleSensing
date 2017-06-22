#!/usr/bin/env bash
defdir=$HOME
dldir=${defdir}/DL_temp

conda create --name clouddetect
source activate clouddetect

# ATTENTION: UNCOMMENT THE LINES BELOW IF YOU WANT THE NORMAL PYTHON FMASK VERSION!
#FMASKREPO=https://bitbucket.org/chchrsc/python-fmask/downloads/
#FMASKFILE=$(wget -q -O - ${FMASKREPO} | egrep '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]].tar.gz' | head -n 1 | cut -d \" -f 2)
#FMASKVERSION=$(echo ${FMASKLINE} | egrep -o '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]')
#wget -O ${dldir}/fmask.tar.gz https://bitbucket.org$FMASKLINE
#mkdir ${defdir}/FMASK
#tar -xzvf ${dldir}/fmask.tar.gz -C ${defdir}/FMASK/
#cd ${defdir}/FMASK/python-fmask-$FMASKVERSION
#python setup.py build

FMASKCONDAREPO=https://anaconda.org/conda-forge/python-fmask/
FMASKCONDADL=$(wget -q -O - ${FMASKCONDAREPO} | grep 'conda-forge python-fmask')
FMASKCONDAVERSION=$(echo ${FMASKCONDADL} | egrep -o '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]')

conda install -c conda-forge python-fmask=${FMASKCONDAVERSION}
source deactivate
