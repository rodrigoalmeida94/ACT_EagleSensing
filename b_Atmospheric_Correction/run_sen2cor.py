#Function to check L1C sourcefile, format properly, and run sen2cor

import os
import os.path


## Directory and L1C folder check

datadir = r'/media/sf_M_DRIVE/ACT_EagleSensing/a_Data_Acquisition/Data/hubTue20Jun20171214/'
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
            run = os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(dir) + str(datafiles[0]))
        else:
            os.rename(i, (i + ".SAFE"))
    return run

run_sen2cor (20, datadir)





