#!/usr/bin/env bash

echo -n "
This bash script will install all required programs and packages for the processing of S2AL1A into L3 products.
Existing user settings will be overwritten.
Are you sure you want to install  these programs? [yes|no]
>>> "
read ans
while [[ (${ans} != "yes") && (${ans} != "Yes") && (${ans} != "YES") && (${ans} != "no") && (${ans} != "No") && (${ans} != "NO") ]]
do
echo -n "Please answer 'yes' or 'no':
>>> "
read ans
done
if [[ (${ans} != "yes") && (${ans} != "Yes") && (${ans} != "YES") ]]
then
echo "The install agreement wasn't approved, aborting installation."
exit 2
fi

# 0. SET VARIABLES
defdir=$HOME
pardir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir ${defdir}/DL_temp -p
dldir=${defdir}/DL_temp
profilefile=/etc/bash.bashrc
profilenondebian=$HOME/.bashrc
pip install --upgrade pip
sudo apt-get install -y poppler-utils
sudo apt-get install -y python-dev

#2. Call sen2cor install
cd $pardir
source ./sen2cor_install.sh

#3. Call sen2three install
cd $pardir
source ./sen2three_install.sh

#4. (UNUSED) Call snap install
#cd $pardir
#source ./sen2three_install.sh

#5. Install packages needed for the download script.
yes yes | conda create --name data_acquisition pip
source activate data_acquisition
pip install --upgrade pip
pip install sentinelhub
pip install sentinelsat
pip install parmap
pip install requests
yes yes | conda install -c conda-forge fire
yes yes | conda install -c conda-forge gdal
source deactivate

#6. Install packages needed for the mosaicing script.
yes yes | conda create --name mosaicing pip
source activate mosaicing
GDALCONDAREPO=https://anaconda.org/conda-forge/gdal/
GDALCONDADL=$(wget -q -O - ${GDALCONDAREPO} | grep 'conda-forge gdal')
GDALCONDAVERSION=$(echo ${GDALCONDADL} | egrep -o '[[:alnum:]]\.[[:alnum:]]\.[[:alnum:]]')
yes yes | conda install -c conda-forge gdal=${GDALCONDAVERSION}
sudo apt-get install r-base
sudo apt-get install gdal-bin
sudo apt-get install python-gdal
sudo apt-get install libgdal
sudo apt-get install libproj
## Close the conda environment.
source deactivate
