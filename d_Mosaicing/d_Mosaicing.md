# d_Mosaicing

## Necessary libraries
* rgdal
* utils
* raster
* XML
* tools

## Command Line Interface for mosaicing

    Rscript mosaicing.R --default-packages=rgdal,utils,raster,XML,tools --verbose INPUT_DIR [OUTPUT_DIR]

## Modules

* **mosaicing.R**
    * Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.
    * Contains the following parameters:
        * input_dir
            * Folder where the L2A products are located. Expecting .SAFE format.
        * output_dir (default is input_dir)
* func_mosaicing.R
    * Includes utilities and pre-processing function for the main mosaicing script.
    * Contains the following functions:
        * mask_dir <- takes a mask_file and an input_file_list.
        * pre_process <- takes a product_name and a reclass_var/matrix.
        * ndvi_calc <- takes a product_name and returns a file of the NDVI with a certain resolution.
