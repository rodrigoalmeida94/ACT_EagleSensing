# a_Data_Acquisition
# download_amz.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.

import os
import sys
import time
import fire
import datetime
import sentinelhub

sys.path.insert(0, 'a_Data_Acquisition')
from get_products_aoi import get_products_aoi


def download_amz(download_dir,
                 file_path,
                 accounts_file,
                 start_date='NOW-30DAYS',
                 end_date='NOW',
                 exclude_date='20161206'):
    start_date = str(start_date)
    end_date = str(end_date)
    exclude_date = datetime.datetime.strptime(str(exclude_date),'%Y%m%d')

    if not os.path.isdir(download_dir):
        raise ValueError('download_dir: '+ download_dir + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')
    if not os.path.exists(file_path):
        raise ValueError('file_path: '+ file_path + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')
    if not os.path.exists(accounts_file):
        raise ValueError('accounts_file: '+ accounts_file + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')

    product, credentials = get_products_aoi(file_path, accounts_file, start_date=start_date, end_date=end_date)

    # This error occurs due to the max directory size in Windows! Still, I think it's good to have the option
    delete = []
    for tile in product:
        if product[tile]['beginposition'] <= exclude_date:
           print(product[tile]['title']+' was excluded since '+str(product[tile]['beginposition'])+' is previous to exclude date.')
           delete += [tile]

    for x in delete:
        product.pop(x)

    owd = os.getcwd()  # original working directory (owd)
    new_dir = download_dir+'/amz%s' % time.strftime('%a%d%b%Y%H%M%S')
    os.mkdir(new_dir)
    os.chdir(new_dir)
    for elem in product:
        sentinelhub.download_safe_format(product[elem]['title'])
    os.chdir(owd)

    text_file = open(download_dir+'/TIME_DIR.txt','w')
    text_file.write(new_dir)
    text_file.close()
    return new_dir

if __name__ == '__main__':
    fire.Fire(download_amz)
    #download_amz('../Source_Data/Phillipines/RGBtile.tif', 'Data/accounts_hub.txt', start_date='NOW-3MONTHS')
