import os
import numpy as np
import pandas as pd

tar = os.chdir('/media/sf_M_DRIVE/S2A_exported_pixels')
print os.getcwd()


FEATURES = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12']

# The csv files were exported using ESA's SNAP tool and contain reflectance values for each band per pixel:

# 1. Resample two Sentinel 1C images (nearest neighbour method was used)
# 2. Apply Idepix classification to one of them, leave the other one in provided format
# 3. Select land, water, shadow and cloud masks (Idepix) and create a ROI with the geometry tool
# 4. Right click the ROI and export mask pixels, header=T

# load labeled pixels
shadow_pixels1 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_shadow_1_Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna() # Explicitly pass header=0 to be able to replace existing names,
                                      # header=T when exporting the pixel values with SNAP

shadow_pixels2 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_shadow_2Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()

shadow_pixels3 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_shadow_3_Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
shadow_pixels4 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_shadow_4Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
land_pixels1 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_land_Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
land_pixels2 = pd.read_csv('S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326_resampled_idepix_geometry_Mask_land.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
cloud_pixels1 = pd.read_csv('S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326_resampled_idepix_geometry_Mask_cloud.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
cloud_pixels2 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_cloud_Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
water_pixels1 = pd.read_csv('S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326_resampled_idepix_water_Mask_3_to_use.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()
water_pixels2 = pd.read_csv('S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled_water_Mask.txt',
                   sep='\t',
                   skiprows=3,
                   usecols=FEATURES,
                   header=0).dropna()

shadow_pixels = pd.concat([shadow_pixels1, shadow_pixels2, shadow_pixels3, shadow_pixels4])
land_pixels = pd.concat([land_pixels1, land_pixels2])
cloud_pixels = pd.concat([cloud_pixels1, cloud_pixels2])
water_pixels = pd.concat([water_pixels1, water_pixels2])

# Equal number of pixels per class

# equal size per label
#n = min(len(shadow_pixels1)+len(shadow_pixels2), len(land_pixels1)+len(land_pixels2), len(cloud_pixels1)+len(cloud_pixels2), len(water_pixels1)+len(water_pixels2))
n = min(len(shadow_pixels1)+len(shadow_pixels2)+len(shadow_pixels3)+len(shadow_pixels4), len(land_pixels1)+len(land_pixels2), len(cloud_pixels1)+len(cloud_pixels2), len(water_pixels1)+len(water_pixels2))
print(n)

# random selection
ri_shadow = np.random.permutation(len(shadow_pixels))[:n]
ri_land = np.random.permutation(len(land_pixels))[:n]
ri_cloud = np.random.permutation(len(cloud_pixels))[:n]
ri_water = np.random.permutation(len(water_pixels))[:n]

# combine into one labeled dataframe
training_set = pd.concat( [shadow_pixels.iloc[ri_shadow], land_pixels.iloc[ri_land], cloud_pixels.iloc[ri_cloud], water_pixels.iloc[ri_water]] )
# add class labels column
labels = [0]*n + [1]*n + [2]*n + [3]*n
training_set = training_set.assign(label=pd.Series(labels).values)


## or use all samples

# # combine into one labeled dataframe
# training_set = pd.concat( [shadow_pixels1, shadow_pixels2, land_pixels1, land_pixels2, cloud_pixels1, cloud_pixels2, water_pixels1, water_pixels2] )
# # add class labels column
# labels = [0]*(len(shadow_pixels1)+len(shadow_pixels2)) + [1]*(len(land_pixels1)+len(land_pixels2)) + [2]*(len(cloud_pixels1) + len(cloud_pixels2)) + [3]*(len(water_pixels1) + len(water_pixels2))
# training_set = training_set.assign(label=pd.Series(labels).values)


## save


# shuffle
random_index = np.random.permutation(len(training_set))

# save 80% of data as training data, remaining 20% as test data

i = int(len(training_set)*0.8)

training_set.iloc[random_index[:i]].to_csv('NN_training_data.csv', index=False, index_label=False)
training_set.iloc[random_index[i:]].to_csv('NN_test_data.csv', index=False, index_label=False)



