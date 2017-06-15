# a_Data_Acquisition
# download_amz.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.

import os
import sentinelhub
import time

def download_amz(product_names)
    owd = os.getcwd() #original working directory (owd)
    new_dir = 'Data/amz%s'%time.strftime('%a%d%b%Y%H%M')
    os.mkdir(new_dir)
    os.chdir(new_dir)

    for elem in product:
        sentinelhub.download_safe_format(element)

    for element in product_names:
        sentinelhub.download_safe_format(element)
    os.chdir(owd)

