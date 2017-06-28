# d_Mosaicing
# func_mosaicing.R
# Utilities and pre-processing functions for the main mosaicing script.

# mask_dir
mask_dir <- function(mask_file,input_file_list) {
  for(a_file in input_file_list) {
    masked_file <- paste0(dirname(a_file),'/MSK_',basename(file_path_sans_ext(a_file)),'.tif')
    system(paste0('gdal_calc.py -A "', mask_file,'" -B "',a_file,'" --outfile="',masked_file,'" --calc="A*B" --overwrite'))
  }
}

# pre_process
pre_process <- function(product_name, reclass_var) {
  
  # Make VRT, save into file
  granule = dir(paste0(product_name,'/GRANULE/'))
  granule_dir60 = paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R60m/')
  output_file60 = paste0(product_name,'/bands60.vrt')
  granule_dir20 = paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R20m/')
  output_file20 = paste0(product_name,'/bands20.vrt')
  granule_dir10 = paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R10m/')
  output_file10 = paste0(product_name,'/bands10.vrt')
  
  if(dir.exists(granule_dir60)){
    granule_dir60 = paste0(granule_dir60,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file60, granule_dir60))
    product_vrt60 <- stack(output_file60)
  }
  
  if(dir.exists(granule_dir20)){
    granule_dir20 = paste0(granule_dir20,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file20, granule_dir20))
    product_vrt20 <- stack(output_file20)
  }
  
  if(dir.exists(granule_dir10)){
    granule_dir10 = paste0(granule_dir10,'*.jp2')
    system(paste('gdalbuildvrt -separate',output_file10, granule_dir10))
    product_vrt10 <- stack(output_file10)
  }
  
  xml_meta <- xmlRoot(xmlParse(paste0(product_name,'/MTD_MSIL2A.xml')))
  date <- xmlValue(xml_meta[[1]][[1]][[1]])
  
  rm(granule, granule_dir60,output_file60, granule_dir20,output_file20,granule_dir10,output_file10,xml_meta)
  
  # Make the reclass mask, save into file
  if(exists('product_vrt60')){
    mask_scl <- reclassify(product_vrt60$bands60.13,reclass_var, filename=paste0(product_name,'/mask60.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
  if(exists('product_vrt10')){
    mask_scl <- reclassify(product_vrt20$bands20.11,reclass_var,filename=paste0(product_name,'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
    mask_scl10 <- resample(mask_scl,product_vrt10$bands10.1,method='ngb',filename=paste0(product_name,'/mask10.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
  if(!exists('product_vrt10') && exists('product_vrt20')){
    mask_scl <- reclassify(product_vrt20$bands20.11,reclass_var,filename=paste0(product_name,'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
  }
  
  rm(mask_scl,mask_scl10)
  
  # Masking product, save into file
  print(paste('Starting masking of',product_name,'...'))
  granule = dir(paste0(product_name,'/GRANULE/'))
  if(exists('product_vrt60')) {
    files_60 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R60m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_60 <- paste0(product_name,'/mask60.tif')
    mask_dir(mask_60,files_60)
  }
  if(exists('product_vrt10')) {
    files_10 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R10m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_10 <- paste0(product_name,'/mask10.tif')
    mask_dir(mask_10,files_10)
    files_20 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(product_name,'/mask20.tif')
    mask_dir(mask_20,files_20)
  }
  if(!exists('product_vrt10') && exists('product_vrt20')) {
    files_20 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(product_name,'/mask20.tif')
    mask_dir(mask_20,files_20)
  }
  print(paste('Finished masking of',product_name,'.'))
  
  rm(product_vrt10,product_vrt20,product_vrt60, files_10, mask_10,files_20,mask_20,files_60,mask_60)
  
  # Make masked VRT, save into file
  granule = dir(paste0(product_name, '/GRANULE/'))
  granule_dir60 = paste0(product_name, '/GRANULE/', granule, '/IMG_DATA/R60m/')
  output_file60 = paste0(product_name, '/masked_bands60.vrt')
  granule_dir20 = paste0(product_name, '/GRANULE/', granule, '/IMG_DATA/R20m/')
  output_file20 = paste0(product_name, '/masked_bands20.vrt')
  granule_dir10 = paste0(product_name, '/GRANULE/', granule, '/IMG_DATA/R10m/')
  output_file10 = paste0(product_name, '/masked_bands10.vrt')
  
  if (dir.exists(granule_dir60)) {
    granule_dir60 = paste0(granule_dir60, 'MSK_*.tif')
    system(paste('gdalbuildvrt -separate', output_file60, granule_dir60))
    masked_product_vrt60 <- stack(output_file60)
  }
  
  if (dir.exists(granule_dir20)) {
    granule_dir20 = paste0(granule_dir20, 'MSK_*.tif')
    system(paste('gdalbuildvrt -separate', output_file20, granule_dir20))
    masked_product_vrt20 <- stack(output_file20)
  }
  
  if (dir.exists(granule_dir10)) {
    granule_dir10 = paste0(granule_dir10, 'MSK_*.tif')
    system(paste('gdalbuildvrt -separate', output_file10, granule_dir10))
    masked_product_vrt10 <- stack(output_file10)
  }

  rm(
    granule,
    granule_dir60,
    output_file60,
    granule_dir20,
    output_file20,
    granule_dir10,
    output_file10
  )
  
  # Pass 0 to NA
  # At 60 m
  if(exists('masked_product_vrt60')) {
      masked_product_vrt60[masked_product_vrt60==0] <- NA
  }
  # At 10 m
  if(exists('masked_product_vrt10')) {
      masked_product_vrt10[masked_product_vrt10==0] <- NA
  }
  # At 20 m
  if(exists('masked_product_vrt20')) {
      masked_product_vrt20[masked_product_vrt20==0] <- NA
  }

  # Write masked result into file
  # At 60 m
  if(exists('masked_product_vrt60')) {
    writeRaster(masked_product_vrt60, filename=product_name+'/MSK_60.tif',format='GTiff')
  }
  # At 10 m
  if(exists('masked_product_vrt10')) {
    writeRaster(masked_product_vrt10, filename=product_name+'/MSK_10.tif',format='GTiff')
  }
  # At 20 m
  if(exists('masked_product_vrt20')) {
    writeRaster(masked_product_vrt20, filename=product_name+'/MSK_20.tif',format='GTiff')
  }
  
  return(date)
}

