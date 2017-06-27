# z_Install_Software
Sen2cor and Sen2three are both officially ESA endorsed third party applications for the processing of Sentinel-2 raster 
datasets. It must be noted that these applications are therefore still under development and require very specific 
installation requirements. Therefore, an installation bundle is included that takes care that all environmental 
variables and installation folders match up. Anaconda is used for this purpose and several environments are created 
that contain the necessary package versions for the complete bundle to run correctly. This will ensure that processing 
with the Sen2Cor and Sen2Three applications will run smoothly without interfering with other processes and software 
requirements. 


Instructions:

Step 1: Run the supplied anaconda download script (anaconda_install.sh) 

Step 2: Navigate in the terminal to the DL_temp folder (in home directory).

Step 3: Install the Anaconda script with: "bash anaconda.sh". Make sure you use bash, otherwise it will not work!

Step 4: Use defaults by pressing enter throughout the installation instructions.

Step 5: Close all terminal windows to ensure the python environment is anaconda!

Step 6: Run install_software.sh to install Sen2Cor and Sen2Three.

(Step 7: You can install SNAP additionally if you like for manual visual assessments)
