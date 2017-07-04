# b_Atmospheric_Correction
## Necessary packages
* parmap
* shutil
* fire

Sen2Cor has to be installed in the environment.

## Command Line Interface for Sen2Cor

    generate_L2A.py RES DIR_L1C DIR_L2A
    generate_L2A.py --res RES --dir-L1C DIR_L1C --dir-L2A DIR_L2A

Example:
    
    python generate_L2A.py 10 /media/sf_M_DRIVE/L1C /media/sf_M_DRIVE/L2A

## Background
Sen2Cor is a processor for Sentinel-2 Level 2A product generation and formatting; it performs the atmospheric-, terrain and cirrus correction of Top-Of- Atmosphere Level 1C input data. Sen2Cor creates Bottom-Of-Atmosphere, optionally terrain- and cirrus corrected reflectance images; additional, Aerosol Optical Thickness-, Water Vapor-, Scene Classification Maps and Quality Indicators for cloud and snow probabilities. Its output product format is equivalent to the Level 1C User Product: JPEG 2000 images, three different resolutions, 60, 20 and 10 m.

## Process
After running installation scripts, it is now assumed that this component has its own environmnet called 'atmosphere' and should be activated before running all 'b' scripts.

### Preliminary
-At this point, it is assumed that the key GIPP parameters have been edited already into AUTO.

### Running sen2cor
-The script calls the 'L2A_Process' its command line interpreter which uses argparse to guide users on arguments needed.
-Arguments of this L2A_Process.py include: resolution, GIPP inputs, scene or tree options.
-Our script provides flexibility for single or batch/parallel runs.
-In parallel runs, it is important to know the virtual machine (VM)/machine's specs.
-Accepts old format but do not run old and new format in one folder in parallel.

Script      :         run_sen2cor.py

Variables:
datafiles             -gets all files from source folder
checker               -checks for L1C folders

Functions and Parameters:
run_sen2cor           -runs all L1C folders - resolution and product as arguments
sen2_batch            -runs all L1c folders in parallel using parmap.starmap function - resolution and source file directory as arguments

Imports: os, multiprocessing, itertools, parmap

-The resolution argument for parallel processing accepts fixed resolution (either 10, 20, or 60) only for each function call.
-It might be possible that sen2cor run will be interrupted. Possible causes are low memory of Virtual Machines or full storage. As such, 'unfinished' L2A folders are to be created still. As a rule of thumb, delete this folders always before starting a new function call.
-For more comprehensive information, go to: http://step.esa.int/thirdparties/sen2cor/2.3.1/[L2A-SUM]%20S2-PDGS-MPC-L2A-SUM%20[2.3.0].pdf

### Organizing files
-sen2cor by default puts L2A folders into the same directory as the L1C folders. From its arguments, no destination folder is included.
-This script shall check all L2A folders and move these files into another folder named "L2A" at the same directory where L1C main folder is.

Script      :         generate_L2A.py

Variables:
datadir               -gets all files from source folder
checker               -checks for L2A folders


Functions and Parameters:
sen2_batch            -calls run_sen2cor.py function to chain the commands (see previous script).
folder_arrange        -takes two directories as arguments: dir_L1C(origin) and dir_L2A(destination).

Imports: os, shutil, sen2_batch
