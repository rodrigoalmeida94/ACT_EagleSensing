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
#Rscript --vanilla mosaicing.R input_dir output_dir

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
  granule_dir = paste0(elem,'/GRANULE/',substr(elem,8,60),'/IMG_DATA/R60m/*.jp2')
  output_file = paste0(elem,'/GRANULE/',substr(elem,8,60),'/IMG_DATA/R60m/bands.vrt')
  system(paste('gdalbuildvrt -separate',output_file,granule_dir))
  products_vrt <- c(products_vrt,stack(output_file))
}


