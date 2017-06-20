import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
import rasterio
import time

## check modules
from skimage import io
import scipy.misc
from PIL import Image

tar = os.chdir('/home/user')
print os.getcwd()

# output additional info during the training process
tf.logging.set_verbosity(tf.logging.INFO)

###

# define names of columns. To distinguish features from the label, separately define features and the label name.

COLUMNS = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12', 'label']
FEATURES = ['B1','B2','B3','B4','B5','B6','B7','B8','B8A','B9','B10','B11','B12']
LABEL = "label"

# formally define feature columns for tensorflow
feature_cols = [tf.contrib.layers.real_valued_column(k) for k in FEATURES]

# instantiate dense neural network (DNN) classifier
classifier = tf.contrib.learn.DNNClassifier(feature_columns=feature_cols,
                                          hidden_units=[7],
                                          n_classes=4,
                                          model_dir='./NN_model_data')


## training part


# part 1: data formatting to use it as tensors

def input_fn(data_set):

# Accepts a Pandas dataframe and returns feature columns and label values as tensors

    feature_cols = {k: tf.constant(data_set[k].values)
                    for k in FEATURES}
    labels = tf.constant(data_set[LABEL].values)
    return feature_cols, labels

# part 2: training with 80% of the data

# load training pixels
training_set = pd.read_csv('./S2A_exported_pixels/NN_training_data.csv', header=0)

# check data
training_set.head()

# part 3: train the classifier

# the input function is specified as a lambda so that any Pandas dataframe can be entered as an argument
classifier.fit(input_fn=lambda: input_fn(training_set), steps=2000)

# part 4: test the classifier

accuracies = []
test_set = pd.read_csv('./S2A_exported_pixels/NN_test_data.csv', header=0, iterator=True)
for i in range(10):
    try:
        c = test_set.get_chunk(250000)
        ev = classifier.evaluate(input_fn=lambda: input_fn(c), steps=1) # steps=1 is important here
        accuracies.append(ev['accuracy'])
    except StopIteration:
        break
print()
print("Accuracy: {}".format(np.mean(accuracies)))

# part 5: training with 20% of the data
# not really convinced why to use it, because this is purely for validation purposes of the already trained classifier and should not be used further

#load the test data
#test_set = pd.read_csv('./S2A_exported_pixels/NN_test_data.csv', header=0)

# check data
#test_set.head()

#classifier fit with 20% of the data
#classifier.fit(input_fn=lambda: input_fn(test_set), steps=2000)


## -- relevant prediction part -- ##

# part 1: test the prediction data

# load prediction data
# For this, take a subset of different scenes than those used for gaining training pixels and also extract the whole subset.
# should be resampled as before, either 10x10 or 20x20, but stick to the same resolution

#cols = [f+':float' for f in FEATURES]
cols = FEATURES
predict_data = pd.read_csv('./S2A_exported_pixels/subset_0_of_S2A_MSIL1C_20170513T023331_N0205_R003_T51PTR_20170513T023328_subset_1_resampled_prediction_mask.txt',
                           sep='\t', skiprows=2, header=0, usecols=cols)

predict_data = predict_data.rename(index=str, columns={b:a for b,a in zip(cols,FEATURES)})

predict_data.head()

# function to define the input prediction set

def input_predict_data(data_set):
    feature_cols = {k: tf.constant(data_set[k].values)
                    for k in FEATURES}
    return feature_cols

# returns predicted probabilities for given features (predict_proba), herein using the whole S2 image of May 2017
y = classifier.predict_proba(input_fn=lambda: input_predict_data(predict_data))

## result checking
## check if print statements are required

y = np.array(list(y))
print(y.shape)

classification = np.argmax(y, axis=1)
confidence = np.max(y, axis=1)

print(classification.shape)
print(confidence.shape)

classifications = np.array([np.argmax(p) for p in y])

## plotting

# plot ranges
plt.bar(range(4),y[0])
plt.show()

# classification plot
# the reshape int provided (x,y) depend on how to resolve the shapes given in either classificatio.shape or
# confidence.shape (have to be similiar). In this case 129538 is the product of x * y, i.e. 271 * 478 (amongst other solutions)

plt.figure(figsize=(16,9))
#plt.imshow(classification.reshape((1481,2628)), cmap='inferno')
plt.imshow(classification.reshape((271,478)), cmap='inferno')
plt.colorbar()
plt.show()

# classification confidence
plt.figure(figsize=(16,9))
plt.imshow(classification.reshape((271,478)), cmap='inferno')
#plt.imshow(confidence.reshape((1481,2628)), cmap='inferno')
plt.colorbar()
plt.show()

#returns predictions for a given number of features
# should be at some point be updated to predict_classes
y = classifier.predict(input_fn=lambda: input_predict_data(predict_data))

# 0 = shadow
# 1 = land
# 2 = cloud
# 3 = water

# attempt with EQUAL sample sizes per class
# new model with less conservative cloud training data
y = np.array(list(y)).reshape((271,478))
plt.figure(figsize=(16,9))
plt.imshow(y, cmap='inferno')
plt.colorbar()
plt.show()

# attempt with EQUAL sample sizes per class
# y = np.array(list(y)).reshape((1481,2628))
# plt.figure(figsize=(16,9))
# plt.imshow(y, cmap='inferno')
# plt.colorbar()
# plt.show()

# # attempt with EQUAL sample sizes per class
# y = np.array(list(y)).reshape((815,2628))
# plt.figure(figsize=(16,9))
# plt.imshow(y, cmap='inferno')
# plt.colorbar()
# plt.show()


## classify entire image

def input_predict_data(data_set):
    feature_cols = {k: tf.constant(data_set[k].values)
                    for k in FEATURES}
    return feature_cols


def classify(filename):
    ###
    # Input argument should be path to tif file.
    # Returns (classification, confidence) per pixel as arrays with the same width and height as the input image
    ###
    with rasterio.open(filename) as src:
        print('Width, height: {}'.format((src.width, src.height)))
        print('Read block size: {}'.format(src.block_shapes[0]))
        block_size = src.block_shapes[0][0]  # read this size blocks for faster reads

        out = np.zeros((src.width, src.height))
        confidence = np.zeros((src.width, src.height))

        # load and classify chunks at a time
        for i in range(0, src.height, block_size):
            for j in range(0, src.width, block_size):
                rows = (i, min(i + block_size, src.height))
                cols = (j, min(j + block_size, src.width))
                current_block_size = (rows[1] - rows[0], cols[1] - cols[0])

                data = src.read(indexes=list(range(1, 14)), window=(rows, cols))
                data = pd.DataFrame(
                    np.rollaxis(data, 0, 3).reshape((current_block_size[0] * current_block_size[1], -1))).rename(
                    index=str, columns={i: f for i, f in zip(range(0, 13), FEATURES)})
                data = data / 10000  # reflectance scale factor
                # can be found in the ESA SNAP toolbox -> select band -> Analysis -> Information

                y = classifier.predict_proba(input_fn=lambda: input_predict_data(data))

                y = np.array(list(y))
                classification = np.argmax(y, axis=1)
                conf = np.max(y, axis=1)

                out[rows[0]:rows[1], cols[0]:cols[1]] = classification.reshape(current_block_size)
                confidence[rows[0]:rows[1], cols[0]:cols[1]] = conf.reshape(current_block_size)

        return out, confidence

print(time.time())

t0 = time.time()
out, confidence = classify('/media/sf_M_DRIVE/s2a_tif/S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled.tif')
print('Time taken: {} seconds'.format(time.time() - t0))

# 0 = shadow
# 1 = land
# 2 = cloud
# 3 = water

plt.figure(figsize=(16, 16))
plt.title('Classification')
plt.imshow(out, cmap='inferno', vmin=0, vmax=3)
plt.colorbar()
plt.show()

plt.figure(figsize=(16, 16))
plt.title('Confidence (%)')
plt.imshow(confidence, cmap='inferno', vmin=.25, vmax=1)
plt.colorbar()
plt.show()

plt.figure(figsize=(16, 16))
plt.title('Classification')
plt.imshow(out, cmap='inferno', vmin=0, vmax=3)
plt.colorbar()
plt.show()

plt.figure(figsize=(16, 16))
plt.title('Confidence (%)')
plt.imshow(confidence, cmap='inferno', vmin=0, vmax=1)
plt.colorbar()
plt.show()

plt.figure(figsize=(16, 16))
plt.title('Classification')
plt.imshow(out, cmap='inferno', vmin=0, vmax=3)
plt.colorbar()
plt.show()


## Describe results

print('Land: {}%'.format(len(np.argwhere(out == 1)) / (out.shape[0] * out.shape[1]) * 100))
print('Cloud: {}%'.format(len(np.argwhere(out == 2)) / (out.shape[0] * out.shape[1]) * 100))
print('Shadow: {}%'.format(len(np.argwhere(out == 0)) / (out.shape[0] * out.shape[1]) * 100))
print('Water: {}%'.format(len(np.argwhere(out == 3)) / (out.shape[0] * out.shape[1]) * 100))
print('Mean confidence: {}%'.format(np.mean(confidence) * 100))

# Land: 26.911987684181536 %
# Cloud: 15.268612247470978 %
# Shadow: 14.851559882017645 %
# Water: 42.967840186329845 %
# Mean confidence: 87.32829916202061 %

plt.hist(confidence.flatten()[::10])
plt.xlim((0, 1))
plt.show()

## Combine two images based on highest confidence for land/water per pixel

images_fn = ['/media/sf_M_DRIVE/s2a_tif/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326_resampled.tif', '/media/sf_M_DRIVE/s2a_tif/S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled.tif']


def combine(image_filenames):
    def input_predict_data(data_set):
        feature_cols = {k: tf.constant(data_set[k].values)
                        for k in FEATURES}
        return feature_cols

    confidences = []
    for fn in image_filenames:
        with rasterio.open(fn) as src:
            print('Width, height: {}'.format((src.width, src.height)))
            print('Read block size: {}'.format(src.block_shapes[0]))
            block_size = src.block_shapes[0][0]  # read this size blocks for faster reads

            #             classification = np.zeros((src.width, src.height))
            confidence = np.zeros((src.width, src.height))

            # load and classify chunks at a time
            for i in range(0, src.height, block_size):
                for j in range(0, src.width, block_size):
                    rows = (i, min(i + block_size, src.height))
                    cols = (j, min(j + block_size, src.width))
                    current_block_size = (rows[1] - rows[0], cols[1] - cols[0])

                    data = src.read(indexes=list(range(1, 14)), window=(rows, cols))
                    data = pd.DataFrame(
                        np.rollaxis(data, 0, 3).reshape((current_block_size[0] * current_block_size[1], -1))).rename(
                        index=str, columns={i: f for i, f in zip(range(0, 13), FEATURES)})
                    data = data / 10000  # reflectance scale factor

                    y = classifier.predict_proba(input_fn=lambda: input_predict_data(data))

                    y = np.array(list(y))
                    #                     classification = np.argmax(y, axis=1)
                    landwaterconf = np.max(y[:, (1, 3)], axis=1)

                    #                     classification[rows[0]:rows[1], cols[0]:cols[1]] = classification.reshape(current_block_size)
                    confidence[rows[0]:rows[1], cols[0]:cols[1]] = landwaterconf.reshape(current_block_size)

        confidences.append(confidence)

    confidences = np.array(confidences)

    which_image = np.argmax(confidences, axis=0)
    print((len(FEATURES),) + confidences[0].shape)
    combined = np.zeros((len(FEATURES),) + confidences[0].shape)
    print(combined.shape)
    for c, fn in enumerate(image_filenames):
        with rasterio.open(fn) as src:
            block_size = src.block_shapes[0][0]  # read this size blocks for faster reads
            # load chunks at a time
            for i in range(0, src.height, block_size):
                for j in range(0, src.width, block_size):
                    rows = (i, min(i + block_size, src.height))
                    cols = (j, min(j + block_size, src.width))
                    current_block_size = (rows[1] - rows[0], cols[1] - cols[0])

                    data = src.read(indexes=list(range(1, 14)), window=(rows, cols))

                    part_of_combined = combined[:, rows[0]:rows[1], cols[0]:cols[1]]
                    part_of_which_image = which_image[rows[0]:rows[1], cols[0]:cols[1]]
                    combined[:, rows[0]:rows[1], cols[0]:cols[1]][:, part_of_which_image == c] = data[:,
                                                                               part_of_which_image == c]

    return combined

t0 = time.time()
combined = combine(images_fn)
print('Time taken: {} seconds'.format(time.time()-t0))

blackwhite = np.mean(combined[(1,2,3),:,:],axis=0)

io.imsave('/media/sf_M_DRIVE/s2a_tif/combined.tif', combined)
io.imsave('/media/sf_M_DRIVE/s2a_tif/combined_rgb.tif', combined[(1,2,3),:,:])
scipy.misc.imsave('/media/sf_M_DRIVE/s2a_tif/combined_rgb.jpg', np.rollaxis(combined[(1,2,3),:,:], 0, 3))
scipy.misc.imsave('/media/sf_M_DRIVE/s2a_tif/combined_bw.tif', blackwhite)

# bw image plotting

blackwhite = np.mean(combined[(1,2,3),:,:],axis=0)

plt.figure(figsize=(16,16))
plt.imshow(blackwhite, cmap='gray', vmax=3000)
plt.colorbar()
plt.show()

## No idea where classify_landwater below comes from, therefore its not found.
## The original code also seems to use a resampled 200meter version of the two scenes instead of 20m, but that doesn't answer the question.

## Classification to detect only land and water

'''
img1_class, img1_conf = classify_landwater('/media/sf_M_DRIVE/s2a_tif/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326_resampled.tif')
img2_class, img2_conf = classify_landwater('/media/sf_M_DRIVE/s2a_tif/S2A_MSIL1C_20170413T021601_N0204_R003_T51PUR_20170413T023314_resampled.tif')


# plots of the images

plt.imshow(img1_conf, cmap='inferno', vmin=0, vmax=1)
plt.colorbar()
plt.show()

plt.imshow(img2_conf, cmap='inferno', vmin=0, vmax=1)
plt.colorbar()
plt.show()

stack = np.vstack((img1_conf.flatten(),img2_conf.flatten()))
print(stack.shape)

highest_conf = np.argmax(stack, axis=0)
print(highest_conf.shape)

combined = np.zeros(img1_class.flatten().shape)

## Mask clouds and shadows


with rasterio.open('predict_data/20170103_resampled_200m.tif') as src:
    r = src.read_band(4)
    g = src.read_band(3)
    b = src.read_band(2)

# from PIL import image

gamma = 0.5
r_s = (((r / max(r.max(), g.max(), b.max())) ** gamma) * 255).astype(np.uint8)
g_s = (((g / max(r.max(), g.max(), b.max())) ** gamma) * 255).astype(np.uint8)
b_s = (((b / max(r.max(), g.max(), b.max())) ** gamma) * 255).astype(np.uint8)

# remove clouds
mask = out==2
r_s[mask] = 0
g_s[mask] = 0
b_s[mask] = 0

# remove cloud shadows
mask = out==0
r_s[mask] = 0
g_s[mask] = 0
b_s[mask] = 0

rgbArray = np.dstack((r_s,g_s,b_s))
img = Image.fromarray(rgbArray)

plt.imshow(img)
plt.show()

img.save('clouds_removed2.jpg')'''