# d_Mosaicing
# mosaicing.R
# Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.

## DANGER
#setwd("/media/sf_D_DRIVE/hubTue20Jun20171214/L2A/")

# ---- Setting up ----
# Libraries
if(!require(rgdal)){install.packages('rgdal')}
if(!require(utils)){install.packages('utils')}
if(!require(raster)){install.packages('raster')}
if(!require(XML)){install.packages('XML')}
if(!require(tools)){install.packages('tools')}

# Sources
source('d_Mosaicing/func_mosaicing.R')

# Handles arguments passed by CLI
args = commandArgs(trailingOnly=TRUE)
# Usage
# Rscript --verbose --default-packages= mosaicing.R INPUT_DIR OUTPUT_DIR

# If no arguments are supplied
if (length(args)<1) {
  stop("One argument must be supplied (input directory and output directory).", call.=FALSE)
}

owd <- getwd()

# Error if no products are present/directory doesn't exist
if(!dir.exists(args[1])){
  stop('Input L2A product directory does not exist.')
}

# Directory inputed by the user, where L2A products are
setwd(args[1])

# ---- Load products into VRT ----
# Get list of products in the directory
products <- dir(pattern='*.SAFE')
dates_products <- c()

if(length(products)==0){
  stop('Input L2A product directory is empty or does not contain files in the .SAFE format.')
}
if(length(products)==1){
  warning('Input L2A product directory contains only 1 file. Proceeding with the masking procedure.')
}

# ---- Reclassification of SCL, mask creation ----
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
# band 8 - B8A
# band 9 - B11
# band 10 - B12
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
# To remove/add classified pixels to the mask, just change the corresponding
# value in the matrix with 1/0. For instance, to mask out water, change 6 to 0
# classes legend
# 0 - NODATA
# 1 - SATURATED OR DEFECTIVE
# 2 - DARK AREA PIXELS
# 3 - CLOUD SHADOW
# 4 - VEGETATION
# 5 - BARE SOIL
# 6 - WATER
# 7 - CLOUD LOW PROB
# 8 - CLOUD MED PROB
# 9 - CLOUD HIGH PROB
# 10 - THIN CIRRUS
# 11 - SNOW

for(prod in products) {
  dates_products <- c(dates_products,pre_process(prod,reclass_matrix))
}
# Returns date
# Files are at product dir in
# product_dir +'/masked_bands60.tif'
# product_dir +'/masked_bands20.tif'
# product_dir +'/masked_bands10.tif'

# NDVI files are at
# product/NDVI_R020.tif
# product/NDVI_R010.tif
# product/NDVI_R060.tif
masked_products_vrt60 <- c()
masked_products_vrt20 <- c()
masked_products_vrt10 <- c()

for(prod in products) {
	if(file.exists(paste0(prod,'/masked_bands60.tif'))) {
        calc_ndvi(paste0(prod,'/masked_bands60.tif'),60)
        ndvi <- raster(paste0(prod,'/NDVI_R060.tif'))
        masked_products_vrt60 <- c(masked_products_vrt60, ndvi)
  }
  if(file.exists(paste0(prod,'/masked_bands20.tif'))) {
    calc_ndvi(paste0(prod,'/masked_bands20.tif'),20)
    ndvi <- raster(paste0(prod,'/NDVI_R020.tif'))
    masked_products_vrt20 <- c(masked_products_vrt20, ndvi)
  }
  if(file.exists(paste0(prod,'/masked_bands10.tif'))) {
   calc_ndvi(paste0(prod,'/masked_bands10.tif'),10)
    ndvi <- raster(paste0(prod,'/NDVI_R010.tif'))
    masked_products_vrt10 <- c(masked_products_vrt10,ndvi)
  }
}
rm(ndvi)

# ---- Reproject stacks to same CRS if different ----
# Handle different CRS or use merge
# At 60 m
if(length(masked_products_vrt60)!=0) {
  crs60 <- c()
  for(elem in masked_products_vrt60){
    crs60 <- c(crs60,elem@crs@projargs)
  }
  crs60 <- as.data.frame(table(crs60),stringsAsFactors = F)
  for(i in 1:length(masked_products_vrt60)) {
    if(masked_products_vrt60[[i]]@crs@projargs == crs60$crs60[1]) {
      template60 <- masked_products_vrt60[[i]]
      break
    }
  }
  if(length(crs60) != 1){
    for(i in 1:length(masked_products_vrt60)) {
      if(masked_products_vrt60[[i]]@crs@projargs != crs60$crs60[1]){
        masked_products_vrt60[[i]] <- projectRaster(masked_products_vrt60[[i]],template60)
      }
    }
  }
}
# At 10 m
if(length(masked_products_vrt10)!=0) {
  crs10 <- c()
  for(elem in masked_products_vrt10){
    crs10 <- c(crs10,elem@crs@projargs)
  }
  crs10 <- as.data.frame(table(crs10),stringsAsFactors = F)
  for(i in 1:length(masked_products_vrt10)){
    if(masked_products_vrt10[[i]]@crs@projargs == crs10$crs10[1]){
      template10 <- masked_products_vrt10[[i]]
      break
    }
  }
  if(length(crs10) != 1){
    for(i in 1:length(masked_products_vrt10)){

      if(masked_products_vrt10[[i]]@crs@projargs != crs10$crs10[1]){
        masked_products_vrt10[[i]] <- projectRaster(masked_products_vrt10[[i]],template10)
      }
    }
  }
}
# At 20 m
if(length(masked_products_vrt20)!=0) {
  crs20 <- c()
  for(elem in masked_products_vrt20){
    crs20 <- c(crs20,elem@crs@projargs)
  }
  crs20 <- as.data.frame(table(crs20),stringsAsFactors = F)
  for(i in 1:length(masked_products_vrt20)){
    if(masked_products_vrt20[[i]]@crs@projargs == crs20$crs20[1]){
      template20 <- masked_products_vrt20[[i]]
      break
    }
  }
  if(length(crs20) != 1){
    for(i in 1:length(masked_products_vrt20)){

      if(masked_products_vrt20[[i]]@crs@projargs != crs20$crs20[1]){
        masked_products_vrt20[[i]] <- projectRaster(masked_products_vrt20[[i]],template20)
      }
    }
  }
}
rm(crs10,crs20,crs60,elem,template20,template10,template60)

# Naming contruct for Level 3
# Example: S2_MSIL3_FROMDATE_TODATE_R060.tif
# dates_products <- c('2017-03-14T02:33:21.026Z','2017-03-24T02:16:01.026Z','2017-04-23T02:33:31.026Z')
dates_products <- as.Date(dates_products)
max_date <- as.character(format.Date(max(dates_products),'%Y%m%d'))
min_date <- as.character(format.Date(min(dates_products),'%Y%m%d'))

# ---- Make Mosaic using mean for each resolution ----
# ---- Save Level 3 product to file ----
# Set the directory to output directory, input by user, create dir if not exists?
if(!is.na(args[2])){setwd(args[2])}

# Run the mosaicing using do.call
if(length(masked_products_vrt60)!=0) {
  rasters.mosaicargs <- masked_products_vrt60
  rasters.mosaicargs$fun <- mean
  rasters.mosaicargs$filename <- paste0('S2_MSIL3_NDVI_',min_date,'_',max_date,'_R060.tif')
  level3_60 <- do.call(mosaic, rasters.mosaicargs)
  }
if(length(masked_products_vrt10)!=0) {
  rasters.mosaicargs <- masked_products_vrt10
  rasters.mosaicargs$fun <- mean
  rasters.mosaicargs$filename <- paste0('S2_MSIL3_NDVI_',min_date,'_',max_date,'_R010.tif')
  level3_10 <- do.call(mosaic, rasters.mosaicargs)
  }
if(length(masked_products_vrt20)!=0) {
  rasters.mosaicargs <- masked_products_vrt20
  rasters.mosaicargs$fun <- mean
  rasters.mosaicargs$filename <- paste0('S2_MSIL3_NDVI_',min_date,'_',max_date,'_R020.tif')
  level3_20 <- do.call(mosaic, rasters.mosaicargs)
  }
rm(rasters.mosaicargs)

# Naming contruct for Level 3
# Example: S2_MSIL3_FROMDATE_TODATE_R060.tif
removeTmpFiles(h=0)

# Back to initial directory
setwd(owd)
