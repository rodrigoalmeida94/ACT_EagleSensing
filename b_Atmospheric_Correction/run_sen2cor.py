#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path
from multiprocessing import Pool
from itertools import starmap
import parmap

## Directory and L1C folder check
datadir_L1C = r'/media/sf_M_DRIVE/L1C' #modify own directory
os.chdir(datadir_L1C)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())


## RUN SEN2COR--------------------------------

# 1. ONE BY ONE PROCESSING
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res, dir): #Gets only L1C folders with .SAFE and process it
    run = []
    for folders in datafiles:
        if folders[7:10] == checker and folders.endswith(".SAFE"):
            tfile = folders
            str(tfile)
            os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + "/" + tfile)
        else:
            os.rename(folders, (folders + ".SAFE"))
            print "folder renamed, re-run the script/function again."


# 2. BATCH PROCESSING
def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    multiplier = len(datafiles)
    slist = [(res, dir)]*multiplier
    pool = Pool(6) #adjust accordingly depending on computer processor capacity and files to be run
    parmap.starmap(run_sen2cor, slist, parallel=True, pool=pool, processes=multiplier)

sen2_batch (10, datadir_L1C)

## Delete unfinished L2A folder always!


----------------------------------------------------------------------------------------