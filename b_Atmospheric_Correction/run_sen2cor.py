#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path
from multiprocessing import Pool
from itertools import starmap
import parmap
import shutil

## Directory and L1C folder check
datadir_L1C = r'/media/sf_M_DRIVE/L1C' #modify own directory
os.chdir(datadir_L1C)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())


## RUN SEN2COR--------------------------------

# 1. ONE BY ONE PROCESSING - Get only L1C folders with .SAFE and process it
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res, dir):
    run = []
    for folders in datafiles:
        if folders[7:10] == checker and i.endswith(".SAFE"):
            print folders
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
    parmap.starmap(run_sen2cor, slist, parallel=True)

sen2_batch (60, datadir)

## For unfinished sen2cor run, delete unfinished L2A folder always!



# 3. ORGANIZE L1C AND L2A FOLDERS
checker1 = "L2A"
datadir_L2A = r'/media/sf_M_DRIVE/L2A' #modify own directory
def folder_arrange (dir_L1C, dir_L2A):
    dfiles = os.listdir(dir_L1C)
    if not os.path.exists(dir_L2A):
        os.makedirs(dir_L2A)
    for folders in dfiles:
        if folders [7:10] == checker1:
            shutil.move(os.path.join(dir_L1C, folders), dir_L2A)

folder_arrange(datadir_L1C, datadir_L2A)


----------------------------------------------------------------------------------------