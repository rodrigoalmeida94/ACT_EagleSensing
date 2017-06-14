# ACT_EagleSensing
Academic Consultancy Project for EagleSensing. Remote Sensing and GIS Integration course, Period 6, 2016-2017.

## Project instructions

### Template for scripts header

- Component name
- Name of script/module (spaces should be underscore)
- Brief description of content
- Sources, if any

For example:

     a_Data_Aquisition
     get_passwords.py
     Gets the passwords for Sentinel Hub from a text file.
     Source: https://gis.stackexchange.com/a/57837 

### Data management

- Expect two folders in the main directory (ACT_EagleSensing)
- Source_Data and Results_Data
- Only actual Data Sources (that area used in multiple components) or Final results should be put here
- Create a directory in the Component folder called Data, intermediate results should be stored here

Final directory should be something like this:

1. ACT_EagleSensing
    1. a_Data_Acquisition
        1. Data
    1. b_0000
    1. ....
    1. Source_Data
    1. Results_Data
    
 ### Documentation
 
 For each component an .MD file (like this one) should be created where a short description and additional info is given about the component operation.
 If additional documents are required (for instance Latex report) they should be linked via a OneDrive link/Overleaf doc.
 
 Project OneDrive Repository: https://1drv.ms/f/s!AmrxdSlgxQEkgf4v3chnmTJsFPTGTQ
 
 ### Installing pycharm

    sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
    sudo apt-get update
    sudo apt-get install ubuntu-make
    umake ide pycharm
