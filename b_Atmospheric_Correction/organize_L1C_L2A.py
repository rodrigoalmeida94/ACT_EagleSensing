# Function to move L2A files from L1C since there's no argument to specify output files destination during sen2cor run.

import os
import shutil

## Directory and L1C folder check
datadir_L1C = r'/media/sf_M_DRIVE/L1C' #modify own directory
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())

## Make/set directory of L2A files and move files

def folder_arrange (dir_L1C, dir_L2A):

    checker1 = "L2A"
    dfiles = os.listdir(dir_L1C)
    if not os.path.exists(dir_L2A):
        os.makedirs(dir_L2A)
    for folders in dfiles:
        if folders [7:10] == checker1:
            shutil.move(os.path.join(dir_L1C, folders), dir_L2A)
            print "L2A folders successfully moved"
        else:
            print "no L2A folders yet"

datadir_L1C = r'/media/sf_M_DRIVE/L1C'
datadir_L2A = r'/media/sf_M_DRIVE/L2A'  # modify own directory

folder_arrange(datadir_L1C, datadir_L2A)