import os
import os.path


os.system ('ls')

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

#using snappy

