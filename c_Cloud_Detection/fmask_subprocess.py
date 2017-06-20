## Import packages

'''from osgeo import gdal
from osgeo.gdalconst import GA_ReadOnly, GDT_Float32
import numpy
import numpy as np
import matplotlib.pyplot as plt
import urllib2
import tarfile, sys
import rasterio'''

import subprocess
import os
import pprint
from PIL import Image

# 0. Set working directory as the Sentinel2 L1C granule from the image directory
# for example:
# os.chdir('./Sentinel_2_image.SAFE/GRANULE/L1C_PUR_/IMG_DATA')

# 1. Download and install Anaconda

subprocess.call(["./anaconda_install.sh"])

# 2. download the latest fmask package from the bitbucket repo, unpack and install it

subprocess.call(["./fmask_install.sh"])

command_args = ['conda config --add channels conda-forge',
                'conda create -n myenv python-fmask',
                'source activate myenv']

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
                'fmask_sentinel2makeAnglesImage.py -i ../*.xml -o angles.img',
                'fmask_sentinel2Stacked.py -a allbands.vrt -z angles.img -o cloud.img']

process = subprocess.Popen(command_args2,stdout=subprocess.PIPE, shell=True)
proc_stdout = process.communicate()[0].strip()
print proc_stdout
'''
command =

proc = subprocess.Popen(command, stdout = subprocess.PIPE)

for line in proc.stdout:
  (key, _, value) = line.partition("=")
  os.environ[key] = value

proc.communicate()

pprint.pprint(dict(os.environ))

'''
# 5. Convert it to a .tif file with gdal

im = Image.open('cloud.img')
im.save('cloud.tiff')  # or 'test.tif

'''


# install and check dependencies required to run fmask

install_cmd = []


## Install dependencies for project

cmd = [
'gdalwarp -t_srs "EPSG:4326" /home/ubuntu/Python/Lesson12/data/ndwi.tif /home/ubuntu/Python/Lesson12/data/ndwi_ll.tif']
pipe = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
out, err = pipe.communicate()
result = out.decode()


sudo pip install pylatex
sudo pip install numpy

sudo pip install matplotlib
sudo pip install cartopy
sudo pip install scipy

sudo apt-get install texlive-pictures texlive-science texlive-latex-extra imagemagick
sudo apt-get install idle
sudo apt-get install libgeos-dev
sudo apt-get install python-imaging


## Step 1: Download the Landsat imagery

def download_landsat():
    print "Downloading Landsat imagery..."
    url = "https://www.dropbox.com/s/zb7nrla6fqi1mq4/LC81980242014260-SC20150123044700.tar.gz?dl=1"  # dl=1 is important
    u = urllib2.urlopen(url)
    data = u.read()
    u.close()

    if not os.path.exists('data'):
        os.makedirs('data')

    with open("data/Landsat8.tar.gz", "wb") as f:
        f.write(data)


## Step 2: Untar the Landsat imagery

def untar(fname):
    print "Untarring Landsat imagery..."
    fname.endswith("tar.gz")
    tar = tarfile.open(fname)
    tar.extractall(path='data')
    tar.close()
    print "Extracted in the data directory"


## Step 3: Function calls

download_landsat()
untar('data/Landsat8.tar.gz')


## Step 4: Open the Landsat bands 3 and 5. Convert these two bands to a numpy float array, create a mask and calculate the NDWI array.
## GDAL Library does not work on our machine and gives a pretty complex error "__gdal__module" that we didnt want to spend time on solving it.
print "Loading rasters..."
with rasterio.open('data/LC81980242014260LGN00_sr_band3.tif') as src:
    b3 = src.read(1)

with rasterio.open('data/LC81980242014260LGN00_sr_band5.tif') as src:
    b5 = src.read(1)

b3 = b3.astype(np.float32)
b5 = b5.astype(np.float32)

print "Calculating NDWI..."
mask = np.greater(b5 + b3, 0)

with np.errstate(invalid='ignore'):
    ndwi = np.choose(mask, (-99, (b3 - b5) / (b3 + b5)))

print "NDWI min and max values", ndwi.min(), ndwi.max()
# Check the real minimum value
print ndwi[ndwi > -99].min()

# Define spatial characteristics of output object (basically they are analog to the input)
kwargs = src.meta

# Update kwargs (change in data type)
kwargs.update(
    dtype=rasterio.float32,
    count=1)

print kwargs

with rasterio.open('data/ndwi.tif', 'w', **kwargs) as dst:
    dst.write_band(1, ndwi.astype(rasterio.float32))

## Step 5: Transform the projection system of the NDWI raster to EPSG:4326

print "Transform the projection system of the NWDI"

cmd = [
    'gdalwarp -t_srs "EPSG:4326" /home/ubuntu/Python/Lesson12/data/ndwi.tif /home/ubuntu/Python/Lesson12/data/ndwi_ll.tif']
pipe = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
out, err = pipe.communicate()
result = out.decode()


### Step 6: Visualise the NDWI raster with an appropriate symbology.

print "Visualise the results"

with rasterio.open('data/ndwi_ll.tif') as ndwi_vis_main:
    ndwi_vis = ndwi_vis_main.read(1)

# Now plot the raster data using gist_earth palette
plt.imshow(ndwi_vis, interpolation='nearest', vmin=-1, vmax=1, cmap=plt.cm.gist_earth)
plt.colorbar()
plt.show()
dsll = None

