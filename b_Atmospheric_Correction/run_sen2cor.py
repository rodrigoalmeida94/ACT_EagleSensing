#Function to check L1C sourcefile, format properly, and run sen2cor

import os
from multiprocessing import Pool
from itertools import starmap
import parmap
import fire


## RUN SEN2COR---------------------------------------------------------

# 1. ONE BY ONE PROCESSING

def run_sen2cor (res, dir): #Gets only L1C folders with .SAFE and process it
    os.chdir(dir)
    datafiles = os.listdir(os.getcwd())
    checker = "L1C"
    L2A_only = ()
    for folders in datafiles:
        if folders[7:10] == checker and folders.endswith(".SAFE"):
            tfile = folders
            str(tfile)
            os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + "/" + tfile)
            L2A_only = os.listdir (dir)
    return L2A_only



# 2. BATCH PROCESSING

def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    os.chdir(dir)
    datafiles = os.listdir(os.getcwd())
    multiplier = len(datafiles)
    slist = [(res, dir)]*multiplier
    #pool = Pool(2) #adjust accordingly depending on computer processor capacity and files to be run
    parmap.starmap(run_sen2cor, slist, parallel=True, processes=multiplier)


datadir_L1C = r'/media/sf_M_DRIVE/L1C' #sample directory
sen2_batch (10, datadir_L1C)


## Delete unfinished L2A folder always!

if __name__ == '__main__':
    fire.Fire(sen2_batch)
