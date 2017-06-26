#!/usr/bin/env bash

## Set working directory as the Sentinel2 L1C granule from the image directory
#printf "Please select folder in which Sentinel2 L1C granule imagery is stored :\n"
#select d in */; do test -n "$d" && break; echo ">>> Invalid Selection"; done
dirs=(*/)

read -p "$(
        f=0
        for dirname in "${dirs[@]}" ; do
                echo "$((++f)): $dirname"
        done

        echo -ne 'Please select a directory > '
)" selection

selected_dir="${dirs[$((selection-1))]}"

echo "You selected '$selected_dir'"

cd $selected_dir
PS1='\w\$ '
#cd "$d" && pwdcd "${0%/*}"
#cd ./Sentinel_2_image.SAFE/GRANULE/L1C_PUR_/IMG_DATA

## Run Fmask from the clouddetect environment
source activate clouddetect

# Creates a VRT that is a mosaic of the list of input GDAL datasets, in this case the bands provided by S2
# A resolution of 20 x 20m is used here but 10 x 10m can also be used (note: a trade-off between computational time and resolution!)
gdalbuildvrt -resolution user -tr 20 20 -separate allbands.vrt *_B0[1-8].jp2 *_B8A.jp2 *_B09.jp2 *_B1[0-2].jp2

# Makes a separate image of the per-pixel sun and satellite angles
/home/user/anaconda2/envs/clouddetect/bin/fmask_sentinel2makeAnglesImage.py -i ../*.xml -o angles.tif

# Creates the cloud mask output image. This step also is time consuming.
# Note that this assumes the bands are in a particular order (as created in the vrt, above):
/home/user/anaconda2/envs/clouddetect/bin/fmask_sentinel2Stacked.py -a allbands.vrt -z angles.tif -o cloud.tif


source deactivate
##Return to original working directory
cd