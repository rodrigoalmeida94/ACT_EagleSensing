import os
import os.path

#Check directory of L1C images, rename if necessary
os.getcwd()
datadir = r'/home/user/sen2data'
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

#command line
ls= "L2A_Process --resolution=10 --GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml datadir/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326.SAFE"
os.system (ls)

