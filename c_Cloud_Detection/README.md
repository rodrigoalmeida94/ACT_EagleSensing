# c_Cloud_Detection
## Fmask
###Prerequisites
* Fmask installed (via the original bitbucket repository or the conda-forge channel)
* Anaconda installed
* 'clouddetect' conda environment is activated 

Fmask is installed by executing the bash script fmask_install.sh (under ./z_Install_Software/). This 
automatically creates the conda environment "clouddetect", in which all the packages specific for fmask are 
  contained. These packages are also listed in fmaskenv_requirements.txt from where they can be installed with pip
   if need be. 
  

###Required conda packages
* certifi==2017.4.17
* GDAL==2.2.0
* numpy==1.12.1
* python-fmask==0.4.4
* rios==1.4.3
* scipy==0.19.0

###Running Fmask  
Fmask is run by executing the bash script fmask_subprocess.sh (under ./c_Cloud_Detection/). Here, the 
 user must specify the directory in which the Sentinel2 L1C imagery is contained.
 In this bash script, the default output is a single thematic raster in .tif format, but this 
  can be altered by simply changing the extension in the bash file. 

Total run time of the fmask for a single tile with a resolution of 20x20m is approximately 12 minutes.


## Deep Neural Network

Use the script training_data.py and the technical documentation to generate the training and test datasets for the DNN.

Utilising the DNN classifier requires the training and test data to be ready to use. Further, it requires a subset of a Sentinel L1C scene for prediction purposes. \\ \linebreak
The outline of the DNN script is as follows:

1. Initialise the required packages, data and classifier
2. Train the DNN with 80% of the collected reflectances
3. Validate the classifier on 20% of unseen reflectances from the same datapool to check how it perfoms on comparable reflectances. Accuracies within this step have to be high, otherwise the prediction results will be way more worse (as they naturally will be worse than during the validation step).
4. Use the fitted DNN on a new subset or full scene to predict the different classes. We are using a subset and not a whole scene, because of higher computational times. For comparison to highlight the differences: Our training set consists of 305.000 reflectance values, while the bigger, but still small subset consists of \~ 1.300.000 reflectance values. A full scene would be around ten times larger. The classification is easily possible with this implementation of the DNN, but requires more computation time/power to make it suitable for testing purposes.
5. Output the results of the classification and the confidence level per pixel
6. Plot the classification
7. Classfiy an entire image and not just a subset
8. Combine two images based on highest confidence for land/water per pixel and assess the results


## Gaussian Naive Bayes' Classification

Use the script training_data.py and the technical documentation to generate the training and test datasets for the GaussianNB classifier.

The outline of the script is as follows:

1. Initlialise the required packages, data and classifier
2. Fit the GaussianNB classifier on the training data (80%)
3. Validate it on the remaining validation set (20%)
4. Predict on a full Sentinel-2 tile
5. Plot the histogramm of the prediction data
7. Plot the overall class assignments
8. Print scores
