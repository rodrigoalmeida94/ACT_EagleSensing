# a_Data_Acquisition
# download_hub.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from Sentinel Data Hub.
# Sources: https://github.com/olivierhagolle/Sentinel-download

# connect to the API:  pip install sentinelsat
from sentinelsat.sentinel import SentinelAPI, read_geojson, geojson_to_wkt
import sys
import time

sys.path.insert(0, 'a_Data_Acquisition')
from accounts_hub import account
from get_products_aoi import get_products_aoi



credentials = account('a_Data_Acquisition/Data/accounts_hub.txt')

api = SentinelAPI(credentials['rodr_almatos'][0], credentials['rodr_almatos'][1],'https://scihub.copernicus.eu/dhus')

owd = os.getcwd() #original working directory (owd)
new_dir = 'a_Data_Acquisition/Data/hub%s'%time.strftime('%a%d%b%Y%H%M')
os.mkdir(new_dir)

product = get_products_aoi('Source_Data/Phillipines/RGBtile.tif','a_Data_Acquisition/Data/accounts_hub.txt')

api.download_all(product)

for elem in product:
    print product[elem]['title']







# amount of iterations
def enumerate(list, start=0):
    n = start
    for element in list:
        yield n, element
        n += 1
        print(idx)

# or
for idx, val in enumerate(ints):
    print(idx, val)