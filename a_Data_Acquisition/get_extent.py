# a_Data_Acquisition
# get_extent.py
# Gets the extent of a raster file and saves it into GeoJSON.

from osgeo import gdal,ogr,osr
from geojson import Polygon
import json

def get_extent(file_path):
    ''' Creates a GeoJSON file with the search area (AOI)

            @type file_path: chr
            @param file_path: file path of the airborne data
            @rtype:    NULL
            @return:   NULL, creates file in Data
        '''
    raster = file_path
    ds = gdal.Open(raster)

    gt = ds.GetGeoTransform()
    cols = ds.RasterXSize
    rows = ds.RasterYSize
    ext = GetExtent(gt, cols, rows)

    src_srs = osr.SpatialReference()
    src_srs.ImportFromWkt(ds.GetProjection())
    tgt_srs=osr.SpatialReference()
    tgt_srs.ImportFromEPSG(4326)
    tgt_srs = src_srs.CloneGeogCS()

    geo_ext = ReprojectCoords(ext, src_srs, tgt_srs)

    export_file = Polygon(geo_ext)

    f = open('a_Data_Acquisition/Data/SearchExtent.json','w')
    json.dump(export_file,f)

def GetExtent(gt,cols,rows):
    ''' Return list of corner coordinates from a geotransform

        @type gt: tuple/list
        @param gt: geotransform
        @type cols: int
        @param cols: number of columns in the dataset
        @type rows: int
        @param rows: number of rows in the dataset
        @rtype:    [float,...,float]
        @return:   coordinates of each corner
    '''
    ext=[]
    xarr=[0,cols]
    yarr=[0,rows]

    for px in xarr:
        for py in yarr:
            x=gt[0]+(px*gt[1])+(py*gt[2])
            y=gt[3]+(px*gt[4])+(py*gt[5])
            ext.append([x,y])
            print x,y
        yarr.reverse()
    return ext

def ReprojectCoords(coords,src_srs,tgt_srs):
    ''' Reproject a list of x,y coordinates.

        @type geom:     tuple/list
        @param geom:    List of [[x,y],...[x,y]] coordinates
        @type src_srs:  osr.SpatialReference
        @param src_srs: OSR SpatialReference object
        @type tgt_srs:  osr.SpatialReference
        @param tgt_srs: OSR SpatialReference object
        @rtype:         tuple/list
        @return:        List of transformed [[x,y],...[x,y]] coordinates
    '''
    trans_coords=[]
    transform = osr.CoordinateTransformation( src_srs, tgt_srs)
    for x,y in coords:
        x,y,z = transform.TransformPoint(x,y)
        trans_coords.append([x,y])
    return trans_coords