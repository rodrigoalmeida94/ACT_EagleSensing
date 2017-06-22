## Import packages

import subprocess
import os

# 0. Set working directory as the Sentinel2 L1C granule from the image directory
# for example:
# os.chdir('./Sentinel_2_image.SAFE/GRANULE/L1C_PUR_/IMG_DATA')

# 1. Download and install Anaconda (Uncomment the line below if Anaconda is not already installed)

# subprocess.call(["./anaconda_install.sh"])

# 2. Download the latest fmask package from the bitbucket repo or the conda-forge
# channel (make this choice in ./fmask_install.sh), unpack and install it
# (Uncomment the line below if fmask is not already installed)

# subprocess.call(["./fmask_install.sh"])

# 3. Activate the conda environment from which fmask runs
command_args = ['source activate clouddetect']

process = subprocess.Popen(command_args,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout

# 4. Apply fmask via terminal

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

# 5. Close the fmask conda environment
command_args3 = ['source deactivate clouddetect']

process = subprocess.Popen(command_args3,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout