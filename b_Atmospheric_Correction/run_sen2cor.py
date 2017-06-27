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
    if res == int:
        os.system("L2A_Process --resolution=" + str(res) + " " + str(prod))
    else:
        os.system("L2A_Process" + " " + str(prod)) #processes all if resolution is ommitted

# 2. BATCH PROCESSING

def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    os.chdir(dir)
    datafiles = os.listdir(dir)
    slist = []
    for files in datafiles:
        checker1 = "L1C"
        if files[7:10] == checker1:
            slist.append((res, files))
            print slist[-1]
        checker2 = "L2A"
        if files[7:10] == checker2:
            each_folder_dir = str(os.listdir(dir)) + '/' + str(files)
            for subf in each_folder_dir:
                if len(subf) <= 8:
                    shutil.rmtree(files, ignore_errors=True) #resolving the bug that shows error after deleting files
    pool = Pool(4) #adjust accordingly depending on computer processor capacity and files to be run
    all_L2A = parmap.starmap(run_sen2cor, slist, pool=pool)
    return all_L2A

dir_L1C = '/media/sf_M_DRIVE/L1C'


if __name__ == '__main__':
    fire.Fire(sen2_batch)

