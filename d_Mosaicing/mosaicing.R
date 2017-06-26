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
#Rscript --vanilla mosaicing.R input_dir output_dir resolution?, works perfectly

# If no arguments are supplied
if (length(args)<1) {
  stop("One argument must be supplied (input directory and output directory).", call.=FALSE)
}

owd <- getwd()

# Error if no products are present/directory doesn't exist
if(!dir.exists(args[1])){
  stop('Input L2A product directory does not exist.')
}

# Directory inputed by the user, where L2A products are, if no output, use the same as input
setwd(args[1])

# Get list of products in the directory
products <- dir(pattern='*.SAFE')

if(len(products)==0){
  stop('Input L2A product directory is empty or does not contain files in the .SAFE format.')
}
if(len(products)==1){
  warning('Input L2A product directory contains only 1 file. Procedding with the masking procedure.')
}

# Load products into VRT, save dates from metadata
products_vrt60 <- c()
products_vrt20 <- c()
products_vrt10 <- c()
dates_products <- c()
for(elem in products) {
  # DANGER RESOLUTION
  granule = dir(paste0(elem,'/GRANULE/'))
  granule_dir60 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/')
  output_file60 = paste0(elem,'/bands60.vrt')
  granule_dir20 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R20m/')
  output_file20 = paste0(elem,'/bands20.vrt')
  granule_dir10 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R10m/')
  output_file10 = paste0(elem,'/bands10.vrt')
  
  if(dir.exists(granule_dir60)){
    granule_dir60 = paste0(granule_dir60,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file60, granule_dir60))
    products_vrt60 <- c(products_vrt60,stack(output_file60))
  }
  
  if(dir.exists(granule_dir20)){
    granule_dir20 = paste0(granule_dir20,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file20, granule_dir20))
    products_vrt20 <- c(products_vrt20,stack(output_file20))
  }
  
  if(dir.exists(granule_dir10)){
    granule_dir10 = paste0(granule_dir10,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file10, granule_dir10))
    products_vrt10 <- c(products_vrt10,stack(output_file10))
  }
  
  xml_meta <- xmlRoot(xmlParse(paste0(elem,'/MTD_MSIL2A.xml')))
  date <- xmlValue(xml_meta[[1]][[1]][[1]])
  dates_products <- c(dates_products,date)
}
rm(elem, granule, granule_dir60,output_file60, granule_dir20,output_file20,granule_dir10,output_file10,date,xml_meta)

# Band 11 is SCL at R20m, let's hope the order is always the same.
# Band 13 is SCL at R60m, let's hope the order is always the same.

# File organization, rename bands if possible
# At 10 m, this files can be found:
# band 1 - AOT
# band 2 - B3
# band 3 - B4
# band 4 - B8
# band 5 - WVP

# At 20 m, this files can be found:
# band 1 - AOT
# band 2 - B2
# band 3 - B3
# band 4 - B4
# band 5 - B5
# band 6 - B6
# band 7 - B7
# band 8 - B11
# band 9 - B12
# band 10 - B8A
# band 11 - SCL
# band 12 - TCI
# band 13 - VIS
# band 14 - WVP

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
masked_products_vrt10 <- c()
masked_products_vrt20 <- c()
masked_products_vrt60 <- c()
for(i in range(length(products))){
  if(length(products_vrt60)!=0){
    mask_scl <- reclassify(products_vrt60[[i]]$bands60.13,reclass_matrix)
    products_vrt60[[i]][mask_scl == 0] <- NA
    masked_products_vrt60 <- c(masked_products_vrt60,vrt)
  }
  if(length(products_vrt10)!=0){
    mask_scl <- reclassify(products_vrt20[[i]]$bands20.11,reclass_matrix)
    products_vrt10[[i]][mask_scl == 0] <- NA
    masked_products_vrt10 <- c(masked_products_vrt10,vrt)
    products_vrt20[[i]][mask_scl == 0] <- NA
    masked_products_vrt20 <- c(masked_products_vrt20,vrt)
  }
  if(length(products_vrt10)==0){
    mask_scl <- reclassify(products_vrt20[[i]]$bands20.11,reclass_matrix)
    products_vrt20[[i]][mask_scl == 0] <- NA
    masked_products_vrt20 <- c(masked_products_vrt20,vrt)
  }
}
rm(mask_scl, i)

# Run the mosaicing using do.call
rasters.mosaicargs <- masked_products_vrt
rasters.mosaicargs$fun <- mean
level3 <- do.call(mosaic, rasters.mosaicargs)   
rm(rasters.mosaicargs)

# Set the directory to output directory, input by user, create dir if not exists?
if(!is.na(args[2])){setwd(args[2])}

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
