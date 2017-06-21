#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path
import sys

#connect data to sen2cor (needs adjustment)
#data_dir= '/media/sf_M_DRIVE/ACT_EagleSensing/a_Data_Acquisition/Data'
#sys.path.insert(0, 'data_dir')
#import download_hub
#from download_hub get data_dir

## Directory and L1C folder check
datadir = r'/home/user/sen2data/'
os.chdir(datadir)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())

## Run sen2cor

#Get only L1C folders with .SAFE and process it
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res, dir):
    run = []
    for i in datafiles:
        if i[7:10] == str(checker) and i.endswith(".SAFE"):
            run = os.system ("L2A_Process --resolution="+ str(res) + " " + str(dir) + str(datafiles[0]))
        else:
            os.rename(i, (i + ".SAFE"))
            print "folder renamed, re-run the script/function again."
    return run

run_sen2cor (60, datadir)

## For unfinished sen2cor run, delete unfinished L2A folder always



