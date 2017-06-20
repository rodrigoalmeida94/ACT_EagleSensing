#Function to check L1C sourcefile, format properly (assuming original data file name with missing .SAFE), and run sen2cor

import os
import os.path



#Check directory of L1C images, rename if necessary

datadir = r'/media/sf_M_DRIVE/ACT_EagleSensing/a_Data_Acquisition/Data/hubTue20Jun20171214/'
os.chdir(datadir)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())
for file in os.listdir(datadir):
    if file.endswith(".SAFE"):
        print "already formatted"
    else:
        os.rename(file,(file + ".SAFE"))



#Run sen2cor

#get only L1C folders and batch process it
datafiles = os.listdir(os.getcwd())
checker = "L1C"
def run_sen2cor (res):
    if datafiles != 0:
        for i in datafiles:
            if i[7:10] == str(checker):
                os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(datadir) + str(datafiles[0]))
                os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(datadir) + str(datafiles[1]))
                os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(datadir) + str(datafiles[2]))
                os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(datadir) + str(datafiles[3]))
                # should have some trick to parallel process
    else:
        print "folder has no files yet"

run_sen2cor (20)




