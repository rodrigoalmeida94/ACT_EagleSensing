# gaussian naive bayes classification

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.naive_bayes import GaussianNB

shadow_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_shadow_Mask.txt', sep='\t', header=0).dropna()
land_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_land_Mask.txt', sep='\t', header=0).dropna()
cloud_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_cloud_Mask.txt', sep='\t', header=0).dropna()
water_pixels = pd.read_csv('subset_0_of_labeled_resampled_reprojected_water_Mask.txt', sep='\t', header=0).dropna()

bands = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12']

clf = GaussianNB()
training_pixels = pd.concat( [shadow_pixels[bands], land_pixels[bands], cloud_pixels[bands], water_pixels[bands]] )

classes = [1]*len(shadow_pixels) + [2]*len(land_pixels) + [3]*len(cloud_pixels) + [4]*len(water_pixels)

training_pixels.hist()
plt.show()

print(len(training_pixels))
print(len(classes))

clf.fit(training_pixels, classes)

test_data = pd.read_csv('subset_0_of_labeled_resampled_reprojected.csv', sep='\t', header=None, skiprows=int(3.7e6), nrows=int(1e5))

clf.predict( np.array( test_data[list(range(1,14))] )[0] )

fn = 'subset_0_of_labeled_resampled_reprojected.csv'
with open(fn) as f:
    row_count = sum(1 for row in f)
print(row_count)

for j,x in enumerate(test_data.itertuples()):
    print(j,x)
    break

[t]

predictions = np.zeros(row_count-2)
stride = int(1e5)
counter = 0
for i in range(2, row_count, stride):
    test_data = pd.read_csv('subset_0_of_labeled_resampled_reprojected.csv', sep='\t', header=None, skiprows=i, nrows=stride)[list(range(1,14))]
    for j, t in enumerate(test_data.values):
        try:
            p = clf.predict(t.reshape(1,-1))[0]
        except ValueError:
            p = 0
        predictions[counter] = p
        counter += 1
#     predictions[i-2:i-2+len(test_data)] = clf.predict(test_data[list(range(1,14))])
    print(str(i/(row_count-2)*100) + '%')
print('100%')

for i,p in enumerate(predictions):
    if p==0:
        print(i)
        break


plt.hist(predictions)
plt.show()

plt.figure(figsize=(16,9))
plt.imshow(predictions.reshape((1481, 2628)), cmap='inferno')
plt.show()

clf.score(training_pixels, classes)