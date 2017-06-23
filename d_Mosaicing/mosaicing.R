# d_Mosaicing
# mosaicing.R
# Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.

## DANGER
setwd("/media/sf_D_DRIVE/hubTue20Jun20171214/L2A/")

install.packages('gdalUtils')

library(gdalUtils)
library(rgdal)
library(raster)

# Handles arguments passed by CLI

args = commandArgs(trailingOnly=TRUE)
#Rscript --vanilla mosaicing.R input_dir output_dir resolution?

# If no arguments are supplied
if (length(args)!=2) {
  stop("Two arguments must be supplied (input directory and output directory).", call.=FALSE)
}
setwd(args[0])

# Gel list of products in the directory
products <- dir(pattern='*.SAFE')

products_vrt <- c()

for(elem in products) {
  # DANGER RESOLUTION
  granule = dir(paste0(elem,'/GRANULE/'))
  granule_dir = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/*.jp2')
  output_file = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/bands.vrt')
  system(paste('gdalbuildvrt -separate',output_file, granule_dir))
  products_vrt <- c(products_vrt,stack(output_file))
}

# Band 13 is SCL, let's hope the order is always the same.

reclass_matrix <- matrix(data=c(0,0,
                                1,0,
                                2,1,
                                3,1,
                                4,1,
                                5,1,
                                6,1,
                                7,1,
                                8,0,
                                9,0,
                                10,0,
                                11,1),nrow=12,ncol=2,byrow=TRUE)

for(vrt in products_vrt){
  mask_scl <- reclassify(vrt$bands.13,reclass_matrix)
  vrt[mask_scl == 0] <- vrt$bands.1@file@nodatavalue
}

plot(products_vrt[[3]]$bands.10)
plot(mask)
