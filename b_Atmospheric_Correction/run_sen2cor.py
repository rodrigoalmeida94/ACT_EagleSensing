#Function to check L1C sourcefile, format properly (assuming original data file name with missing .SAFE), and run sen2cor

import os
import os.path



#Check directory of L1C images, rename if necessary

os.getcwd()
datadir = r'/home/user/sen2data/'
if not os.path.exists(datadir):
    os.makedirs(datadir)
os.chdir(datadir)
print "The files in the data folder is/are: %s"%os.listdir(os.getcwd())
for file in os.listdir(datadir):
    if file.endswith(".SAFE"):
        print "already formatted"
    else:
        os.rename(file,(file + ".SAFE"))



#Run sen2cor

L1C = os.listdir(os.getcwd())[1]
res = []
def run_sen2cor (res):
    runit = os.system ("L2A_Process --resolution="+ str(res) + " " + "--GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml" + " " + str(datadir) + str(L1C))
    return (runit)

run_sen2cor (10)

