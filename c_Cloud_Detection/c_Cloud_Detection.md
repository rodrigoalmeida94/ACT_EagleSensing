# c_Cloud_Detection
Components for technical documentation:
*    Disclaimer
*    Description of project
*    Sources used (repositories, packages, etc.)
*    Quality of sources and specifications
*    Parameters and options used in the scripts
*    Manual interaction
*    Outputs
*    Run time
*    Error messages
*    Further development
*    APPENDIX: Component diagram


## Fmask
###Prerequisites
* Fmask installed (via the original bitbucket repository or the conda-forge channel)
* Anaconda installed
* 'clouddetect' conda environment is activated 

Fmask is installed by executing the bash script fmask_install.sh (under ./z_Install_Software/). This 
automatically creates the conda environment "clouddetect", in which all the packages specific for fmask are 
  contained. These packages are listed in fmaskenv_requirements.txt. 
  

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

Total run time of the fmask for a single tile is approximately 12 minutes.

###Configuring Fmask




## Deep Neural Network


## Gaussian Naive Bayes' Classification 
