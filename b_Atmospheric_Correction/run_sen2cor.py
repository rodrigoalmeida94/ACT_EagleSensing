#Function to check L1C sourcefile, format properly, and run sen2cor

import os
from multiprocessing import Pool
from itertools import starmap
import parmap
import fire
import shutil


## RUN SEN2COR---------------------------------------------------------

# 1. ONE BY ONE PROCESSING

def run_sen2cor (res, dir): #Gets only L1C folders with .SAFE and process it
    datafiles = os.listdir(dir)
    #checker = "L1C"

    for folders in datafiles:
    #    if folders[7:10] == checker:
        tfile = folders
        os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + "/" + tfile)



# 2. BATCH PROCESSING

def sen2_batch (res, dir): # Creates a list of arguments based on number of files to run
    datafiles = os.listdir(dir)
    checker = "L2A"

    for folders in datafiles:
        if folders[7:10] == checker:
            each_folder_dir = str(os.listdir(dir)) + '/' + str(folders)
            for subf in each_folder_dir:
                if len(subf) <= 8:
                    shutil.rmtree(folders)
                    print "unfinished folder deleted"
                else:
                    print "no unfinished folder"
        else:
            print "processing can proceed"

    multiplier = len(datafiles)
    print multiplier
    slist = [(res, dir)]*multiplier
    #pool = Pool(4) #adjust accordingly depending on computer processor capacity and files to be run
    parmap.starmap(run_sen2cor, slist)


#datadir_L1C = r'/media/sf_M_DRIVE/L1C' #sample directory

## Delete unfinished L2A folder always!

if __name__ == '__main__':
    fire.Fire(sen2_batch)
