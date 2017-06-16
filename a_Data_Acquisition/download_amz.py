# a_Data_Acquisition
# download_amz.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.

import sentinelhub
import os
import sys
import time

sys.path.insert(0, 'a_Data_Acquisition')
from get_products_aoi import get_products_aoi

def download_amz(file_path,
                 accounts_file,
                 start_date = 'NOW-30DAYS',
                 end_date = 'NOW'):
    product = get_products_aoi(file_path,accounts_file,start_date=start_date,end_date=end_date)
    owd = os.getcwd() #original working directory (owd)
    new_dir = 'Data/amz%s'%time.strftime('%a%d%b%Y%H%M')
    os.mkdir(new_dir)
    os.chdir(new_dir)
    for elem in product:
        sentinelhub.download_safe_format(product[elem]['title'])
    os.chdir(owd)

    return(new_dir)

if __name__ == '__main__':
    print(os.getcwd())
    download_amz('../Source_Data/Phillipines/RGBtile.tif','Data/accounts_hub.txt')

