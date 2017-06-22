#!/bin/bash

## Import packages

import subprocess
import os

# 0. Set working directory as the Sentinel2 L1C granule from the image directory
# for example:
os.chdir('/home/user/S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314.SAFE/GRANULE/L1C_T51PUR_A009438_20170413T023314/IMG_DATA')
#os.chdir('./Sentinel_2_image.SAFE/GRANULE/L1C_PUR_/IMG_DATA')

# 1. Download and install Anaconda (Uncomment the line below if Anaconda is not already installed)

# subprocess.call(["./anaconda_install.sh"])

# 2. Download the latest fmask package from the bitbucket repo or the conda-forge
# channel (make this choice in ./fmask_install.sh), unpack and install it
# Be prepared! This installation is time consuming (approx 30 minutes)
# (Uncomment the line below if fmask is not already installed)

# subprocess.call(["./fmask_install.sh"])

# 3. Activate the conda environment from which fmask runs
command_args = ['source /home/user/anaconda2/envs/clouddetect/bin/activate']

process = subprocess.Popen(command_args,stdout=subprocess.PIPE, shell=True, executable='/bin/bash')
proc_stdout = process.communicate()[0].strip()
print proc_stdout

# 4. Apply fmask via terminal

# Command 1 creates a VRT (Virtual Dataset) that is a mosaic of the list of
# input GDAL datasets, in this case the bands provided by S2
# Command 2 makes a separate image of the per-pixel sun and satellite angles
# Command 3 creates the cloud mask output image. This step also is time consuming.
# Note that this assumes the bands are in a particular order (as created in the vrt, above):

# two issues: multiple commands in one popen, after gdalbuildvrt the fmask execution of the .py scripts is not done,
# therefore we split them into several bash pipelines...............................................
# is the environment necessary for executing the python files

command_args2 = ['gdalbuildvrt -resolution user -tr 20 20 -separate allbands.vrt *_B0[1-8].jp2 *_B8A.jp2 *_B09.jp2 *_B1[0-2].jp2',
                 'fmask_sentinel2makeAnglesImage.py -i ../*.xml -o angles.tif',
                 'fmask_sentinel2Stacked.py -a allbands.vrt -z angles.tif -o cloud.tif']

process = subprocess.Popen(command_args2, executable='/bin/bash',stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout

command_args3 = ['fmask_sentinel2makeAnglesImage.py -i ../*.xml -o angles.tif','fmask_sentinel2Stacked.py -a allbands.vrt -z angles.tif -o cloud.tif']
process = subprocess.Popen(command_args3, executable='/bin/bash',stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout

# 5. Close the fmask conda environment
command_args4 = ['source deactivate clouddetect']

process = subprocess.Popen(command_args3,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout