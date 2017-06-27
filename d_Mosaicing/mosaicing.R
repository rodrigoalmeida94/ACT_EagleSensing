# d_Mosaicing
# mosaicing.R
# Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.

## DANGER
setwd("/media/sf_D_DRIVE/hubTue20Jun20171214/L2A/")

# ---- Setting up ----
# Conda environment as well? Or just install packages?
library(rgdal)
library(raster)
library(XML)
library(tools)

mask_dir <- function(mask_file,input_file_list) {
  for(a_file in input_file_list) {
    masked_file <- paste0(dirname(a_file),'/MSK_',basename(file_path_sans_ext(a_file)),'.tif')
    system(paste0('gdal_calc.py -A "', mask_file,'" -B "',a_file,'" --outfile="',masked_file,'" --calc="A*B" --overwrite'))
  }
}

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

# ---- Load products into VRT ----
# Get list of products in the directory
products <- dir(pattern='*.SAFE')

if(length(products)==0){
  stop('Input L2A product directory is empty or does not contain files in the .SAFE format.')
}
if(length(products)==1){
  warning('Input L2A product directory contains only 1 file. Procedding with the masking procedure.')
}

# Load products into VRT, save dates from metadata
products_vrt60 <- c()
products_vrt20 <- c()
products_vrt10 <- c()
dates_products <- c()
for(elem in products) {
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

# Creates mask files - WARNING - LONG RUN TIMES
for(i in seq(length(products))){
  if(length(products_vrt60)!=0){
    mask_scl <- reclassify(products_vrt60[[i]]$bands60.13,reclass_matrix, filename=paste0(products[i],'/mask60.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
  if(length(products_vrt10)!=0){
    mask_scl <- reclassify(products_vrt20[[i]]$bands20.11,reclass_matrix,filename=paste0(products[i],'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
    mask_scl10 <- resample(mask_scl,products_vrt10[[i]]$bands10.1,method='ngb',filename=paste0(products[i],'/mask10.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
  if(length(masked_products_vrt10)==0 && length(products_vrt20)!=0){
    mask_scl <- reclassify(products_vrt20[[i]]$bands20.11,reclass_matrix,filename=paste0(products[i],'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
}
rm(i,mask_scl,mask_scl10)

# ---- Masking of all files in products ----
# Masks every file with the computed cloud mask
for(prod in products) {
  print(paste('Starting masking of',prod,'...'))
  granule = dir(paste0(prod,'/GRANULE/'))
  if(length(products_vrt60)!=0) {
    files_60 <- list.files(paste0(prod,'/GRANULE/',granule,'/IMG_DATA/R60m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_60 <- paste0(prod,'/mask60.tif')
    mask_dir(mask_60,files_60)
  }
  if(length(products_vrt10)!=0) {
    files_10 <- list.files(paste0(prod,'/GRANULE/',granule,'/IMG_DATA/R10m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_10 <- paste0(prod,'/mask10.tif')
    mask_dir(mask_10,files_10)
    files_20 <- list.files(paste0(prod,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(prod,'/mask20.tif')
    mask_dir(mask_20,files_20)
  }
  if(length(masked_products_vrt10)==0 && length(products_vrt20)!=0) {
    files_20 <- list.files(paste0(prod,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(prod,'/mask20.tif')
    mask_dir(mask_20,files_20)
  }
  print(paste('Finished masking of',prod,'.'))
}

rm(products_vrt10,products_vrt20,products_vrt60, files_10, mask_10,files_20,mask_20,files_60,mask_60)

# ---- Loading masked products to VRT ----
# Load masked products into VRT
masked_products_vrt60 <- c()
masked_products_vrt20 <- c()
masked_products_vrt10 <- c()
for(elem in products) {
  granule = dir(paste0(elem,'/GRANULE/'))
  granule_dir60 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R60m/')
  output_file60 = paste0(elem,'/masked_bands60.vrt')
  granule_dir20 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R20m/')
  output_file20 = paste0(elem,'/masked_bands20.vrt')
  granule_dir10 = paste0(elem,'/GRANULE/',granule,'/IMG_DATA/R10m/')
  output_file10 = paste0(elem,'/masked_bands10.vrt')
  
  if(dir.exists(granule_dir60)){
    granule_dir60 = paste0(granule_dir60,'MSK_*.tif')
    system(paste('gdalbuildvrt -separate',output_file60, granule_dir60))
    masked_products_vrt60 <- c(masked_products_vrt60,stack(output_file60))
  }
  
  if(dir.exists(granule_dir20)){
    granule_dir20 = paste0(granule_dir20,'MSK_*.tif')
    system(paste('gdalbuildvrt -separate',output_file20, granule_dir20))
    masked_products_vrt20 <- c(masked_products_vrt20,stack(output_file20))
  }
  
  if(dir.exists(granule_dir10)){
    granule_dir10 = paste0(granule_dir10,'MSK_*.tif')
    system(paste('gdalbuildvrt -separate',output_file10, granule_dir10))
    masked_products_vrt10 <- c(masked_products_vrt10,stack(output_file10))
  }
}
rm(elem, granule, granule_dir60,output_file60, granule_dir20,output_file20,granule_dir10,output_file10)

# ---- Passes 0 to NA ----
# At 60 m
if(length(masked_products_vrt60)!=0) {
  for(i in 1:length(masked_products_vrt60)){
      masked_products_vrt60[[i]][masked_products_vrt60[[i]]==0] <- NA
    }
}
# At 10 m
if(length(masked_products_vrt10)!=0) {
  for(i in 1:length(masked_products_vrt10)){
    masked_products_vrt10[[i]][masked_products_vrt10[[i]]==0] <- NA
  }
}
# At 20 m
if(length(masked_products_vrt20)!=0) {
  for(i in 1:length(masked_products_vrt20)){
    masked_products_vrt20[[i]][masked_products_vrt20[[i]]==0] <- NA
  }
}
rm(i)

# ---- Reproject stacks to same CRS if different ----
# Handle different CRS or use merge
# At 60 m
if(length(masked_products_vrt60)!=0) {
  crs60 <- c()
  for(elem in masked_products_vrt60){
    crs60 <- c(crs60,elem@crs@projargs)
  }
  crs60 <- as.data.frame(table(crs60),stringsAsFactors = F)
  for(i in 1:length(masked_products_vrt60)){
    if(masked_products_vrt60[[i]]@crs@projargs == crs60$crs60[1]){
      template60 <- masked_products_vrt60[[i]]
      break
    }
  }
  if(length(crs60) != 1){
    for(i in 1:length(masked_products_vrt60)){
      
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

# ---- Make Mosaic using mean for each resolution ----
# Run the mosaicing using do.call
if(length(masked_products_vrt60)!=0) {
  rasters.mosaicargs <- masked_products_vrt60
  rasters.mosaicargs$fun <- mean
  level3_60 <- do.call(mosaic, rasters.mosaicargs)   
  }
if(length(masked_products_vrt10)!=0) {
  rasters.mosaicargs <- masked_products_vrt10
  rasters.mosaicargs$fun <- mean
  level3_10 <- do.call(mosaic, rasters.mosaicargs)   
  }
if(length(masked_products_vrt20)!=0) {
  rasters.mosaicargs <- masked_products_vrt20
  rasters.mosaicargs$fun <- mean
  level3_20 <- do.call(mosaic, rasters.mosaicargs)  
  }
rm(rasters.mosaicargs)

# ---- Save Level 3 product to file ----
# Set the directory to output directory, input by user, create dir if not exists?
if(!is.na(args[2])){setwd(args[2])}

# Naming contruct for Level 3
# Example: S2_MSIL3_FROMDATE_TODATE_R060.tif
dates_products <- as.Date(dates_products)
max_date <- as.character(format.Date(max(dates_products),'%Y%m%d'))
min_date <- as.character(format.Date(min(dates_products),'%Y%m%d'))

if(length(masked_products_vrt60)!=0) {
  export_name = paste0('S2_MSIL3_',min_date,'_',max_date,'_R060.tif')
  writeRaster(level3_60,fname = export_name, format = 'GTiff', overwrite=TRUE, bandorder='BIL',options="INTERLEAVE=BAND",bylayer=T)
}
if(length(masked_products_vrt10)!=0) {
  export_name = paste0('S2_MSIL3_',min_date,'_',max_date,'_R010.tif')
  writeRaster(level3_10,fname = export_name, format = 'GTiff', overwrite=TRUE, bandorder='BIL',options="INTERLEAVE=BAND",bylayer=T)
}
if(length(masked_products_vrt20)!=0) {
  export_name = paste0('S2_MSIL3_',min_date,'_',max_date,'_R020.tif')
  writeRaster(level3_20,fname = export_name, format = 'GTiff', overwrite=TRUE, bandorder='BIL',options="INTERLEAVE=BAND",bylayer=T)
}

removeTmpFiles(h=0)

# Back to initial directory
setwd(owd)
