# z_Install_Software
Sen2cor and Sen2three are both officially ESA endorsed third party applications for the processing of Sentinel-2 raster 
datasets. It must be noted that these applications are therefore still under development and require very specific 
installation requirements. Therefore, an installation bundle is included that takes care that all environmental 
variables and installation folders match up. Anaconda is used for this purpose and several environments are created 
that contain the necessary package versions for the complete bundle to run correctly. This will ensure that processing 
with the Sen2Cor and Sen2Three applications will run smoothly without interfering with other processes and software 
requirements. 


Instructions:

Navigate to ACT_EagleSensing:

Step 1: Run the supplied anaconda download script with (anaconda_install.sh) 

    $ bash z_Install_Software/anaconda_install.sh

Step 2: Use defaults by pressing enter throughout the installation instructions.

Step 3: Close all terminal windows to ensure the python environment is anaconda!

    $ python
    Python 2.7.13 |Anaconda 4.4.0 (64-bit)| (default, Dec 20 2016, 23:09:15) 

Step 4: Run install_software.sh to install Sen2Cor and Sen2Three.

    $ bash z_Install_Software/install_software.sh 

(Step 5: You can install SNAP additionally if you like for manual visual assessments)
