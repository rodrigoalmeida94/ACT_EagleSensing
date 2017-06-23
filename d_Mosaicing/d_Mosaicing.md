# d_Mosaicing

## Necessary libraries
* rgdal
* raster
* XML

## Command Line Interface for mosaicing

    Rscript mosaicing.R INPUT_DIR [OUTPUT_DIR] RESOLUTION?

## Modules

* **mosaicing.R**
    * Gets a directory of L2A products and mosaics the non-cloud covered areas into one file.
    * Contains the following parameters:
        * input_dir
            * Folder where the L2A products are located. Expecting .SAFE format.
        * output_dir (default is input_dir)
        * resolution?