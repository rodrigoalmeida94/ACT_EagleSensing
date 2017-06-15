# b_Atmospheric_Correction
Academic Consultancy Project for EagleSensing. Remote Sensing and GIS Integration course, Period 6, 2016-2017.

BACKGROUND:

Sen2Cor is a processor for Sentinel-2 Level 2A product generation and formatting; it performs the atmospheric-, terrain and cirrus correction of Top-Of- Atmosphere Level 1C input data. Sen2Cor creates Bottom-Of-Atmosphere, optionally terrain- and cirrus corrected reflectance images; additional, Aerosol Optical Thickness-, Water Vapor-, Scene Classification Maps and Quality Indicators for cloud and snow probabilities. Its output product format is equivalent to the Level 1C User Product: JPEG 2000 images, three different resolutions, 60, 20 and 10 m.

Sen2Cor should be installed according to the Release Note. After installation, the Sen2Cor processor can be launched from a command line or by integrating the processor in SNAP (as it is described in the chapter 3.2.2 of the Software User Manual).


ACTION POINTS:



Installing sen2cor in terminal:
 http://forum.step.esa.int/t/proposition-of-a-step-by-step-tuto-to-install-sen2cor-on-ubuntu-vm-16-10/4370 
 
 Installation issues:
    -L2A_Process should be added to your path variable to be able to run the program from any location.
    -L2a_GIPP.xml should be edited with the following change:
          Aerosol type to MARITIME or RURAL, Mid_Latitude not AUTO
    
    
 Running sen2cor:
    -install Glymur 
 
 
 
 
 

 
Source codes:
 https://github.com/senbox-org 
 
 
 
 
 
 
 
 Raw commands: 
 L2A_Process --resolution=10 --GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml /home/user/SEN2COR/S2A_MSIL1C_20170513T104031_N0205_R008_T32ULC_20170513T104249.SAFE


