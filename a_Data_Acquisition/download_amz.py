# a_Data_Acquisition
# download_amz.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.

import os
import sentinelhub
import time

def dowload_amz(list)
    new_dir = 'Data/%s'%time.strftime('%a%d%b%Y%H%M')
    os.mkdir(new_dir)
    os.chdir(new_dir)
    for element in list:
        sentinelhub.download_safe_format(element)