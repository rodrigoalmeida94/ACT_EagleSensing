# a_Data_Acquisition
# download_hub.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from Sentinel Data Hub.
# Sources: https://github.com/olivierhagolle/Sentinel-download

import os
import sys
import time
import fire
from itertools import izip
import parmap
from sentinelsat.sentinel import SentinelAPI
sys.path.insert(0, 'a_Data_Acquisition')
from get_products_aoi import get_products_aoi

def download_hub(download_dir,
                 file_path,
                 accounts_file,
                 start_date='NOW-30DAYS',
                 end_date='NOW',
                 downloads_per_account=1,  # maximum allowed is 2
                 max_downloads=10):
    start_date = str(start_date)
    end_date = str(end_date)

    if not os.path.isdir(download_dir):
        raise ValueError('download_dir: '+ download_dir + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')
    if not os.path.exists(file_path):
        raise ValueError('file_path: '+ file_path + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')
    if not os.path.exists(accounts_file):
        raise ValueError('accounts_file: '+ accounts_file + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')

    products, credentials = get_products_aoi(file_path, accounts_file, start_date=start_date, end_date=end_date)

    # Creates directory for download files
    owd = os.getcwd()  # original working directory (owd)
    new_dir = download_dir+'/hub%s' % time.strftime('%a%d%b%Y%H%M%S')
    os.mkdir(new_dir)
    os.chdir(new_dir)

    n_accounts = len(credentials)
    n_products = len(products)

    n_threads = n_products // n_accounts * downloads_per_account
    if n_threads < 1:
        n_threads = 1
    if n_threads >= max_downloads:
        n_threads = max_downloads

    div_products = dict_divider(products, n_threads)

    if n_products > 1:
        div_credentials = credentials.values() * (n_threads // n_accounts)
    else:
        div_credentials = [credentials.values()[0]]

    parmap.starmap(download, izip(div_products, div_credentials))

    for elem in products:
        os.system('unzip ' + products[elem]['title'] + '.zip')
        os.remove(products[elem]['title'] + '.zip')

    os.chdir(owd)

    text_file = open(download_dir+'/TIME_DIR.txt','w')
    text_file.write(new_dir)
    text_file.close()
    return new_dir

def download(product, credentials):
    api = SentinelAPI(credentials[0], credentials[1], 'https://scihub.copernicus.eu/dhus')
    api.download_all(product)


def dict_divider(raw_dict, num):
    list_result = []
    len_raw_dict = len(raw_dict)
    if len_raw_dict > num:
        base_num = len_raw_dict / num
        addr_num = len_raw_dict % num
        for i in range(num):
            this_dict = dict()
            keys = list()
            if addr_num > 0:
                keys = raw_dict.keys()[:base_num + 1]
                addr_num -= 1
            else:
                keys = raw_dict.keys()[:base_num]
            for key in keys:
                this_dict[key] = raw_dict[key]
                del raw_dict[key]
            list_result.append(this_dict)

    else:
        for d in raw_dict:
            this_dict = dict()
            this_dict[d] = raw_dict[d]
            list_result.append(this_dict)

    return list_result


if __name__ == '__main__':
    fire.Fire(download_hub)
    #download_hub('../Source_Data/Phillipines/RGBtile.tif', 'Data/accounts_hub.txt', start_date='NOW-3MONTH', downloads_per_account=2)
