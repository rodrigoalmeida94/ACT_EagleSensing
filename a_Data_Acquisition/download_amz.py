# a_Data_Acquisition
# download_amz.py
# Downloads tiles captured in a given time interval that intersect with a provided raster, from AWS.

# pip install sentinelhub
import sentinelhub
os.makedirs('a_Data_Acquisition/Data/')
#still need to create timestamp so it does not override


list = ['S2A_MSIL1C_20170414T003551_N0204_R016_T54HVH_20170414T003551','S2A_MSIL1C_20170414T003551_N0204_R016_T54HVH_20170414T003551']
first_tile = list[0]

sentinelhub.get_safe_format(list[0])

sentinelhub.download_safe_format('S2A_MSIL1C_20170414T003551_N0204_R016_T54HVH_20170414T003551', 'a_Data_Acquisituin/Data')