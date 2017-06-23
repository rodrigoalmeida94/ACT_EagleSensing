# d_Mosaicing
# mosaicing.R
# Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.

## DANGER
setwd("/media/sf_D_DRIVE/hubTue20Jun20171214/L2A/")

# Conda environment as well? Or just install packages?
library(rgdal)
library(raster)
library(XML)

# Handles arguments passed by CLI
args = commandArgs(trailingOnly=TRUE)
#Rscript --vanilla mosaicing.R input_dir output_dir resolution?

# If no arguments are supplied
if (length(args)!=2) {
  stop("Two arguments must be supplied (input directory and output directory).", call.=FALSE)
}

owd <- getwd()

setwd(args[0]) # Directory inputed by the user
# Get list of products in the directory
products <- dir(pattern='*.SAFE')

# Error if no products are present/directory doesn't exist

# Load products into VRT, save dates from metadata
products_vrt <- c()
dates_products <- c()
for(elem in products) {
  # DANGER RESOLUTION
  granule = dir(paste0(elem,'/GRANULE/'))
  granule_dir = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/*.jp2')
  output_file = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/bands.vrt')
  system(paste('gdalbuildvrt -separate',output_file, granule_dir))
  products_vrt <- c(products_vrt,stack(output_file))
  xml_meta <- xmlRoot(xmlParse(paste0(elem,'/MTD_MSIL2A.xml')))
  date <- xmlValue(xml_meta[[1]][[1]][[1]])
  dates_products <- c(dates_products,date)
}
rm(elem, granule, granule_dir,output_file,date,xml_meta)

# Band 13 is SCL, let's hope the order is always the same.

# Reclassification matrix, classes 0,1,8,9,10 are no good
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

# Masking each product with reclassification
masked_products_vrt <- c()
for(vrt in products_vrt){
  mask_scl <- reclassify(vrt$bands.13,reclass_matrix)
  vrt[mask_scl == 0] <- NA
  masked_products_vrt <- c(masked_products_vrt,vrt)
}
rm(vrt, mask_scl)

# File organization, rename bands if possible
# At 10 m, this files can be found:

# At 20 m, this files can be found:

# At 60 m, this files can be found:
# band 1 - AOT
# band 2 - B1
# band 3 - B2
# band 4 - B3
# band 5 - B4
# band 6 - B5
# band 7 - B6
# band 8 - B7
# band 9 - B8A
# band 10 - B9
# band 11 - B11
# band 12 - B12
# band 13 - SCL
# band 14 - TCI
# band 16 - WVP

# Run the mosaicing using do.call
rasters.mosaicargs <- masked_products_vrt
rasters.mosaicargs$fun <- mean
level3 <- do.call(mosaic, rasters.mosaicargs)   
rm(rasters.mosaicargs)

# Set the directory to output directory
setwd(args[1])

# Naming contruct for Level 3
# Example: S2_MSIL3_FROMDATE_TODATE_R060.tif
dates_products <- as.Date(dates_products)
max_date <- as.character(format.Date(max(dates_products),'%Y%m%d'))
min_date <- as.character(format.Date(min(dates_products),'%Y%m%d'))
res <- xres(level3)
export_name = paste0('S2_MSIL3_',min_date,'_',max_date,'_R0',res,'.tif')

# Gives error, says brick is not recognized
writeRaster(level3,fname = export_name, format = 'GTiff', overwrite=TRUE, bandorder='BIL',options="INTERLEAVE=BAND",bylayer=T)

removeTmpFiles(h=0)

# Back to initial directory
setwd(owd)
