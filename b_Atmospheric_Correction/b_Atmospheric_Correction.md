# b_Atmospheric_Correction
Academic Consultancy Project for EagleSensing. Remote Sensing and GIS Integration course, Period 6, 2016-2017.

BACKGROUND:

Sen2Cor is a processor for Sentinel-2 Level 2A product generation and formatting; it performs the atmospheric-, terrain and cirrus correction of Top-Of- Atmosphere Level 1C input data. Sen2Cor creates Bottom-Of-Atmosphere, optionally terrain- and cirrus corrected reflectance images; additional, Aerosol Optical Thickness-, Water Vapor-, Scene Classification Maps and Quality Indicators for cloud and snow probabilities. Its output product format is equivalent to the Level 1C User Product: JPEG 2000 images, three different resolutions, 60, 20 and 10 m.

Sen2Cor should be installed according to the Release Note. After installation, the Sen2Cor processor can be launched from a command line or by integrating the processor in SNAP (as it is described in the chapter 3.2.2 of the Software User Manual).


ACTION POINTS:



Installing sen2cor in terminal:
 http://forum.step.esa.int/t/proposition-of-a-step-by-step-tuto-to-install-sen2cor-on-ubuntu-vm-16-10/4370 
 
 Installation notes:
    -Check python directory. After installing anaconda, restart terminal!!!!! Check python (which python in terminal) should be inside anaconda2.
    -Anaconda default settings using -b parameter
    -L2A_Process should be added to your path variable to be able to run the program from any location.
    -L2a_GIPP.xml should be edited with the following change:
          Aerosol type to MARITIME or RURAL, Mid_Latitude not AUTO
    -A sen2cor folder inside .egg in user directory should exist before running
    -Setting up environment variables is crucial
    
    
 Running sen2cor:
    -install/update Glymur
    -use GPF
     
 
 
 
 Running SNAP:
    -remember put sudo when running SNAP
    -make sure sen2cor directory is set, you should see these paths with "echo %SEN2COR_HOME%" and echo "%SEN2COR_BIN%"
 

 
Source codes:
 https://github.com/senbox-org 
 
 
Calling sen2cor from python script:

 
 
 
 
 Process chain sample presentation:
    http://seom.esa.int/S2forScience2014/files/01_S2forScience-MethodsII_MULLER-WILM.pdf
 
 
 
 
 
 Raw commands: 
 L2A_Process --resolution=10 --GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml /home/user/sen2data/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326.SAFE


