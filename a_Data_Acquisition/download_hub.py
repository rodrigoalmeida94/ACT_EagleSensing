# a_Data_Acquisition
# download_hub.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from Sentinel Data Hub.
# Sources: https://github.com/olivierhagolle/Sentinel-download

# connect to the API:  pip install sentinelsat
from sentinelsat.sentinel import SentinelAPI
import sys
import time
import os

sys.path.insert(0, 'a_Data_Acquisition')
from get_products_aoi import get_products_aoi

def download_amz(file_path,
                 accounts_file,
                 start_date = 'NOW-30DAYS',
                 end_date = 'NOW'):

    product, credentials = get_products_aoi(file_path, accounts_file, start_date=start_date, end_date=end_date)

    # Creates directory for download files
    owd = os.getcwd()  # original working directory (owd)
    new_dir = 'Data/hub%s' % time.strftime('%a%d%b%Y%H%M')
    os.mkdir(new_dir)
    os.chdir(new_dir)

    api = SentinelAPI(credentials.values()[0][0], credentials.values()[0][1],'https://scihub.copernicus.eu/dhus')

    api.download_all(product)

    os.chdir(owd)

    return new_dir

if __name__ == '__main__':
    print(os.getcwd())
    download_amz('../Source_Data/Phillipines/RGBtile.tif', 'Data/accounts_hub.txt')

# ISSUE
# Downloads zip file, we need to handle that.