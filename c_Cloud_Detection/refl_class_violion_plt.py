import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

tar = os.chdir('/media/sf_M_DRIVE/S2A_exported_pixels')
print os.getcwd()

#shadow_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_shadow_Mask.txt', sep='\t', header=0)
#land_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_land_Mask.txt', sep='\t', header=0)
#cloud_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_cloud_Mask.txt', sep='\t', header=0)
#water_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_water_Mask.txt', sep='\t', header=0)

shadow_pixels = pd.read_csv('shadow_pixels.csv', sep='\t', header=0).dropna()
land_pixels = pd.read_csv('land_pixels.csv', sep='\t', header=0).dropna()
cloud_pixels = pd.read_csv('cloud_pixels.csv', sep='\t', header=0).dropna()
water_pixels = pd.read_csv('water_pixels.csv', sep='\t', header=0).dropna()

bands = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12']

fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(10, 10))

violin_parts = axes[0,0].violinplot(np.array( cloud_pixels[bands] ), range(1,14), showmeans=True, showextrema=False)
axes[0,0].set_title('Cloud')

violin_parts_2 = axes[0,1].violinplot(np.array( land_pixels[bands] ), range(1,14), showmeans=True, showextrema=False)
axes[0,1].set_title('Land')

violin_parts_3 = axes[1,0].violinplot(np.array( water_pixels[bands] ), range(1,14), showmeans=True, showextrema=False)
axes[1,0].set_title('Water')

violin_parts_4 = axes[1,1].violinplot(np.array( shadow_pixels[bands] ), range(1,14), showmeans=True, showextrema=False)
axes[1,1].set_title('Shadow')

#violin_dicts_conc = [violin_parts, violin_parts_2, violin_parts_3, violin_parts_4]
#print(violin_dicts_conc)

for ax in axes.flatten():
    ax.set_xticks(range(1,14))
    ax.set_xticklabels(bands)

#for pc in violin_dicts_conc:
#    pc['bodies'].set_facecolor('blue')
#    pc['bodies'].set_edgecolor('black')

#works, could copy this for all violin_parts x4: plt.setp(violin_parts['bodies'], facecolor='red', edgecolor='black')
plt.suptitle('Training dataset 2',fontsize=14)
plt.setp(violin_parts['bodies'], facecolor='red', edgecolor='black')
plt.setp(violin_parts_2['bodies'], facecolor='green', edgecolor='black')
plt.setp(violin_parts_3['bodies'], facecolor='blue', edgecolor='black')
plt.setp(violin_parts_4['bodies'], facecolor='black', edgecolor='black')
plt.show()
plt.savefig('violin_plot_old_datasets.png')
