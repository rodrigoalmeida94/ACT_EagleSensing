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
    system(paste0('gdal_translate "',product_name,'/mask60.tif" "',product_name,'/mask60_0.tif" -a_nodata 0'))
  }
  if(exists('product_vrt10')){
    mask_scl <- reclassify(product_vrt20$bands20.11,reclass_var,filename=paste0(product_name,'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
    mask_scl10 <- resample(mask_scl,product_vrt10$bands10.1,method='ngb',filename=paste0(product_name,'/mask10.tif'),format='GTiff',datatype='INT2U',overwrite=T)
    system(paste0('gdal_translate "',product_name,'/mask20.tif" "',product_name,'/mask20_0.tif" -a_nodata 0'))
    system(paste0('gdal_translate "',product_name,'/mask10.tif" "',product_name,'/mask10_0.tif" -a_nodata 0'))
 }
  if(!exists('product_vrt10') && exists('product_vrt20')){
    mask_scl <- reclassify(product_vrt20$bands20.11,reclass_var,filename=paste0(product_name,'/mask20.tif'),format='GTiff',datatype='INT2U',overwrite=T)
    system(paste0('gdal_translate "',product_name,'/mask20.tif" "',product_name,'/mask20_0.tif" -a_nodata 0'))
  }

  rm(mask_scl,mask_scl10)

  # Masking product, save into file
  print(paste('Starting masking of',product_name,'...'))
  granule = dir(paste0(product_name,'/GRANULE/'))
  if(exists('product_vrt60')) {
    files_60 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R60m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_60 <- paste0(product_name,'/mask60_0.tif')
    mask_dir(mask_60,files_60)
  }
  if(exists('product_vrt10')) {
    files_10 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R10m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_10 <- paste0(product_name,'/mask10_0.tif')
    mask_dir(mask_10,files_10)
    files_20 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(product_name,'/mask20_0.tif')
    mask_dir(mask_20,files_20)
  }
  if(!exists('product_vrt10') && exists('product_vrt20')) {
    files_20 <- list.files(paste0(product_name,'/GRANULE/',granule,'/IMG_DATA/R20m'),pattern=glob2rx('*.jp2'), full.names=T)
    mask_20 <- paste0(product_name,'/mask20_0.tif')
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
    system(paste('gdalbuildvrt -separate', output_file60, granule_dir60,'-overwrite'))
    masked_product_vrt60 <- stack(output_file60)
  }

  if (dir.exists(granule_dir20)) {
    granule_dir20 = paste0(granule_dir20, 'MSK_*.tif')
    system(paste('gdalbuildvrt -separate', output_file20, granule_dir20,'-overwrite'))
    masked_product_vrt20 <- stack(output_file20)
  }

  if (dir.exists(granule_dir10)) {
    granule_dir10 = paste0(granule_dir10, 'MSK_*.tif')
    system(paste('gdalbuildvrt -separate', output_file10, granule_dir10,'-overwrite'))
    masked_product_vrt10 <- stack(output_file10)

  }

  # Write masked result into file
  # At 60 m
  if(exists('masked_product_vrt60')) {
    writeRaster(masked_product_vrt60, filename=paste0(product_name,'/masked_bands60.tif'),format='GTiff',overwrite=TRUE)
  }
  # At 10 m
  if(exists('masked_product_vrt10')) {
    writeRaster(masked_product_vrt10, filename=paste0(product_name,'/masked_bands10.tif'),format='GTiff',overwrite=TRUE)
  }
  # At 20 m
  if(exists('masked_product_vrt20')) {
    writeRaster(masked_product_vrt20, filename=paste0(product_name,'/masked_bands20.tif'),format='GTiff',overwrite=TRUE)
  }

  # Clean Up, delete files
  if (dir.exists(granule_dir60)) {
    system(paste('find',granule_dir60,'-type f -name "MSK_*.tif" -delete'))
    system(paste0('rm ', product_name,'/bands60.vrt'))
    system(paste0('rm ', product_name,'/masked_bands60.vrt'))
    system(paste0('rm ', product_name,'/mask60.tif'))
    system(paste0('rm ', product_name,'/mask60_0.tif'))
  }

  if (dir.exists(granule_dir20)) {
    system(paste('find',granule_dir20,'-type f -name "MSK_*.tif" -delete'))
    system(paste0('rm ', product_name,'/bands20.vrt'))
    system(paste0('rm ', product_name,'/masked_bands20.vrt'))
    system(paste0('rm ', product_name,'/mask20.tif'))
    system(paste0('rm ', product_name,'/mask20_0.tif'))
  }

  if (dir.exists(granule_dir10)) {
    system(paste('find',granule_dir10,'-type f -name "MSK_*.tif" -delete'))
    system(paste0('rm ', product_name,'/bands10.vrt'))
    system(paste0('rm ', product_name,'/masked_bands10.vrt'))
    system(paste0('rm ', product_name,'/mask10.tif'))
    system(paste0('rm ', product_name,'/mask10_0.tif'))
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

  return(date)
}

# calc_ndvi
calc_ndvi <- function(input_file,res) {
    out_file <- paste0(dirname(input_file),'/NDVI_R0',res,'.tif')
    if(res==60){
        system(paste0('gdal_calc.py -A "', input_file,'" --A_band=9 -B "',input_file,'" --B_band=5 --outfile="',out_file,'" --calc="((A-B)/(A+B))*10000" type="Int16" --overwrite -'))
    }
    if(res==20){
    system(paste0('gdal_calc.py -A "', input_file,'" --A_band=8 -B "',input_file,'" --B_band=4 --outfile="',out_file,'" --calc="((A-B)/(A+B))*10000" type="Int16" --overwrite'))
    }
    if(res==10){
        system(paste0('gdal_calc.py -A "',input_file,'" --A_band=4 -B "',input_file,'" --B_band=3 --outfile="',out_file,'" --calc="((A-B)/(A+B))*10000" type="Int16" --overwrite'))
    }
}
