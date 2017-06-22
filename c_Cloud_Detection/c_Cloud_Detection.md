# ACT_EagleSensing
Academic Consultancy Project for EagleSensing. Remote Sensing and GIS Integration course, Period 6, 2016-2017.

The specific packages required are listed in fmaskenv_requirements.txt
To create an environment in terminal:
 'conda create -n fmaskenv',
 'source activate fmaskenv'
 Then activate environment and install the required packages in it using this command:
 $ pip install -r fmaskenv_requirements.txt

However, now in the fmask_install.sh bash script, the user will be prompted to activate the environment
"clouddetect" before commencing with the conda-forge python-fmask package installation. In this way,
 the correct packages should be found in the environment 'clouddetect' but if there is an issue they can
 always be imported from the fmaskenv_requirements.txt file
