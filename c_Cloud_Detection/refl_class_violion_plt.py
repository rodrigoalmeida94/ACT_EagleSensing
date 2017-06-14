import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

shadow_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_shadow_Mask.txt', sep='\t', header=0)
land_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_land_Mask.txt', sep='\t', header=0)
cloud_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_cloud_Mask.txt', sep='\t', header=0)
water_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_water_Mask.txt', sep='\t', header=0)

bands = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12']

fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(10, 10))

axes[0,0].violinplot(np.array( cloud_pixels[bands] ), range(1,14), showextrema=False)
axes[0,0].set_title('Cloud')

axes[0,1].violinplot(np.array( land_pixels[bands] ), range(1,14), showextrema=False)
axes[0,1].set_title('Land')

axes[1,0].violinplot(np.array( water_pixels[bands] ), range(1,14), showextrema=False)
axes[1,0].set_title('Water')

axes[1,1].violinplot(np.array( shadow_pixels[bands] ), range(1,14), showextrema=False)
axes[1,1].set_title('Shadow')

for ax in axes.flatten():
    ax.set_xticks(range(1,14))
    ax.set_xticklabels(bands)

plt.show()