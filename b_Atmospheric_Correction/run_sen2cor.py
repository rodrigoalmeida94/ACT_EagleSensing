#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path
from multiprocessing import Pool

#connect data to sen2cor (needs adjustment)
#data_dir= '/media/sf_M_DRIVE/ACT_EagleSensing/a_Data_Acquisition/Data'
#sys.path.insert(0, 'data_dir')
#import download_hub
#from download_hub get data_dir

## Directory and L1C folder check
datadir = r'/media/sf_M_DRIVE/L1C/'
os.chdir(datadir)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())

## Run sen2cor

# 1. SINGLE PROCESSING - Get only L1C folders with .SAFE and process it
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res, dir):
    run = []
    for i in datafiles:
        if i[7:10] == str(checker) and i.endswith(".SAFE"):
            run = os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + str(datafiles[1]))
        else:
            os.rename(i, (i + ".SAFE"))
            print "folder renamed, re-run the script/function again."
    return run

run_sen2cor (10, datadir)

## For unfinished sen2cor run, delete unfinished L2A folder always






















####

# 2. PARALLEL PROCESSING
file1= datafiles[0]
file2= datafiles[1]
file3= datafiles[2]

def run_sen2cor (res, dir, file):
    run = []
    for i in datafiles:
        if i[7:10] == str(checker) and i.endswith(".SAFE"):
            run = os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + str(file))
        else:
            os.rename(i, (i + ".SAFE"))
            print "folder renamed, re-run the script/function again."
    return run

pool = Pool(4)
