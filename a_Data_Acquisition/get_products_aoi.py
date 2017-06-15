# a_Data_Acquisition
# get_products_aoi.py
# Gets a list of product names matching a given time interval that intersect with a provided raster.
# Sources:

import sys
from sentinelsat import SentinelAPI
sys.path.insert(0, 'a_Data_Acquisition')
from get_extent import get_extent
from accounts_hub import account

def get_products_aoi(extent_file = '../Source_Data/Phillipines/RGBtile.tif',
                     accounts_file = 'Data/accounts_hub.txt',
                     start_date = 'NOW-30DAYS',
                     end_date = 'NOW'):

    AOI = get_extent(extent_file)
    credentials = account(accounts_file)

    api = SentinelAPI(credentials['rodr_almatos'][0], credentials['rodr_almatos'][1],'https://scihub.copernicus.eu/dhus')

    points = []
    for elem in AOI['coordinates']:
        x,y = elem
        points += [str(round(x,7))+' '+str(round(y,7))]

    AOI_wkt = 'POLYGON ((%s, %s, %s, %s, %s))' % (points[0],points[1],points[2],points[3],points[0])

    products = api.query(AOI_wkt, initial_date=start_date, end_date=end_date, platformname='Sentinel-2')

    return products

if __name__ == '__main__':
    print(get_products_aoi())

''' def query(self, area=None, initial_date='NOW-1DAY', end_date='NOW',
              order_by=None, limit=None, offset=0,
              area_relation='Intersects', **keywords):
        """Query the OpenSearch API with the coordinates of an area, a date interval
        and any other search keywords accepted by the API.
        Parameters
        ----------
        area : str, optional
            The area of interest formatted as a Well-Known Text string.
        initial_date : str or datetime, optional
            Beginning of the time interval for sensing time. Defaults to 'NOW-1DAY'.
            Either a Python datetime or a string in one of the following formats:
                - yyyy-MM-ddThh:mm:ss.SSSZ (ISO-8601)
                - yyyy-MM-ddThh:mm:ssZ
                - YYYMMdd
                - NOW
                - NOW-<n>DAY(S) (or HOUR(S), MONTH(S), etc.)
                - NOW+<n>DAY(S)
                - yyyy-MM-ddThh:mm:ssZ-<n>DAY(S)
                - NOW/DAY (or HOUR, MONTH etc.) - rounds the value to the given unit
        end_date : str or datetime, optional
            Beginning of the time interval for sensing time.  Defaults to 'NOW'.
            See initial_date for allowed format.
        order_by: str, optional
            A comma-separated list of fields to order by (on server side).
            Prefix the field name by '+' or '-' to sort in ascending or descending order, respectively.
            Ascending order is used, if prefix is omitted.
            Example: "cloudcoverpercentage, -beginposition".
        limit: int, optional
            Maximum number of products returned. Defaults to no limit.
        offset: int, optional
            The number of results to skip. Defaults to 0.
        area_relation : {'Intersection', 'Contains', 'IsWithin'}, optional
            What relation to use for testing the AOI. Case insensitive.
                - Intersects: true if the AOI and the footprint intersect (default)
                - Contains: true if the AOI is inside the footprint
                - IsWithin: true if the footprint is inside the AOI
        Other Parameters
        ----------------
        Additional keywords can be used to specify other query parameters, e.g. orbitnumber=70.
        See https://scihub.copernicus.eu/twiki/do/view/SciHubUserGuide/3FullTextSearch
        for a full list of accepted parameters.
        Returns
        -------
        dict[string, dict]
            Products returned by the query as a dictionary with the product ID as the key and
            the product's attributes (a dictionary) as the value.
            '''