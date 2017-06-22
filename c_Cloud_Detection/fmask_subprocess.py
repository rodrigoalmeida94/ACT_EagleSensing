## Import packages

import subprocess
import os

# 0. Set working directory as the Sentinel2 L1C granule from the image directory
# for example:
# os.chdir('./Sentinel_2_image.SAFE/GRANULE/L1C_PUR_/IMG_DATA')

# 1. Download and install Anaconda

# subprocess.call(["./anaconda_install.sh"])

# 2. download the latest fmask package from the bitbucket repo, unpack and install it

subprocess.call(["./fmask_install.sh"])

command_args = ['conda config --add channels conda-forge',
                'conda create -n clouddetect python-fmask',
                'source activate clouddetect']

process = subprocess.Popen(command_args,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout

# 3. Apply fmask via terminal

# Command 1 creates a VRT (Virtual Dataset) that is a mosaic of the list of
# input GDAL datasets, in this case the bands provided by S2
# Command 2 makes a separate image of the per-pixel sun and satellite angles
# Command 3 creates the cloud mask output image. Note that this assumes
# the bands are in a particular order (as created in the vrt, above):

command_args2 = ['gdalbuildvrt -resolution user -tr 20 20 -separate allbands.vrt *_B0[1-8].jp2 *_B8A.jp2 *_B09.jp2 *_B1[0-2].jp2',
                'fmask_sentinel2makeAnglesImage.py -i ../*.xml -o angles.tif',
                'fmask_sentinel2Stacked.py -a allbands.vrt -z angles.tif -o cloud.tif']

process = subprocess.Popen(command_args2,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout

