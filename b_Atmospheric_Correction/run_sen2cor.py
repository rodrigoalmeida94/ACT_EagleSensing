#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path
from multiprocessing import Pool
from itertools import starmap
import parmap


#connect data to sen2cor (needs adjustment)
#data_dir= '/media/sf_M_DRIVE/ACT_EagleSensing/a_Data_Acquisition/Data'
#sys.path.insert(0, 'data_dir')
#import download_hub
#from download_hub get data_dir

## Directory and L1C folder check
datadir = r'/media/sf_M_DRIVE/L1C'
os.chdir(datadir)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())



## RUN SEN2COR-----------------------

# 1. ONE BY ONE PROCESSING - Get only L1C folders with .SAFE and process it
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res, dir):
    run = []
    for i in datafiles:
        if i[7:10] == checker and i.endswith(".SAFE"):
            tfile = i
            str(tfile)
            run = os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + "/" + tfile)
        else:
            os.rename(i, (i + ".SAFE"))
            print "folder renamed, re-run the script/function again."
    return run

#run_sen2cor (60, datadir)


# 2. BATCH PROCESSING
def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    multiplier = len(datafiles)
    slist = [(res, dir)]*multiplier
    pool = Pool(processes=4)
    parmap.starmap(run_sen2cor, slist, parallel=True, processes=multiplier, pool=pool)

sen2_batch (10, datadir)


## For unfinished sen2cor run, delete unfinished L2A folder always


----------------------------------------------------