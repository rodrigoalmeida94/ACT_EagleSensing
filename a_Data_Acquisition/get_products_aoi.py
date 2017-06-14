# a_Data_Acquisition
# get_products_aoi.py
# Gets a list of product names matching a given time interval that intersect with a provided raster.
# Sources:

import sys,os
sys.path.insert(0, 'a_Data_Acquisition')
from get_extent import get_extent

# For the first 100 results
search_url = 'https://scihub.copernicus.eu/dhus/search?start=0&rows=100&orderby=beginposition des&q='

AOI = get_extent('Source_Data/Phillipines/RGBtile.tif')

points = []
for elem in AOI['coordinates']:
    x,y = elem
    points += [str(x)+' '+str(y)]

AOI_addition = 'footprint:"Intersects(POLYGON((%s,%s,%s,%s,%s)))"' % (points[0],points[1],points[2],points[3],points[0])

os.system(search_url+AOI_addition)
