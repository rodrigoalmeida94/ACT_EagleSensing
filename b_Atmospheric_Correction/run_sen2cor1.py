#Function to check L1C sourcefile, format properly, and run sen2cor

import os
from multiprocessing import Pool
from itertools import starmap
import parmap
import fire
import shutil


## RUN SEN2COR---------------------------------------------------------

# 1. ONE BY ONE PROCESSING

def run_sen2cor (res, prod): #Gets only L1C folders with .SAFE and process it
    #datafiles = os.listdir(dir)
    #checker = "L1C"
    #sfile = str(prod)
    os.system("L2A_Process --resolution=" + str(res) + " " + str(prod))

run_sen2cor(60, "/media/sf_M_DRIVE/L1C/S2A_MSIL1C_20170314T023321_N0204_R003_T51PUR_20170314T023317.SAFE")

# 2. BATCH PROCESSING

def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    datafiles = os.listdir(dir)
    #multiplier = len(datafiles)
    #print multiplier
    #for files in datafiles:
    slist = [(res, dir, datafiles[0]), (res, dir, datafiles[1]), (res, dir, datafiles[2])]
    pool = Pool(4) #adjust accordingly depending on computer processor capacity and files to be run
    all_L2A = parmap.starmap(run_sen2cor, slist, pool=pool)
    return all_L2A


#datadir_L1C = r'/media/sf_M_DRIVE/L1C' #sample directory

## Delete unfinished L2A folder always!

if __name__ == '__main__':
    fire.Fire(sen2_batch)

