# a_Data_Acquisition

Necessary packages:
* sentinelhub
* sentinelsat
* parmap
* requests

Modules:
* get_extent.py
    * Gets the extent of a raster file and saves it into GeoJSON.
    * Handles differente CRS and provides JSON object in WGS84.
* accounts_hub.py
    * Gets Sentinel Hub user credentials out of a text file (accounts_hub.txt in this case) into a dictionary for use in the download process.
    * Credentials contain: username & password
* get_products_aoi.py
    * Gets a list of product names matching a given time interval that intersect with a provided raster.
    * contains get_products_aoi function: 
         * Creates an ordered dictionary of products that intersect with the extent of a raster file in a provided date interval.
* **download_amz.py**
    * Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.
    * Contains the following parameters:
        * file_path
        * accounts_file 
        * start_date (in format YYYYMMDD, NOW-3DAYS will work)
        * end_date (in format YYYYMMDD, NOW will work)
    * Creates a directory in /Data with timestamp (in format amzDayDaynumberMonthYearHourMinute)
* **download_hub.py**
    * Downloads tiles captured in a given time interval that intersect with a provided raster, from Sentinel Data Hub.
    * Contains the following parameters:
        * file_path
        * accounts_file 
        * start_date (in format YYYYMMDD, NOW-3DAYS will work)
        * end_date (in format YYYYMMDD, NOW will work)
        * downloads_per_account (default is 1, maximum allowed is 2)
        * max_downloads (default = 10)
    * Creates a directory in /Data with timestamp (in format hubDayDaynumberMonthYearHourMinute)
