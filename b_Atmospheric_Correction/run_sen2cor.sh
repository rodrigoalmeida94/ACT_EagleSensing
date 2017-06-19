#!/usr/bin/env bash

#Create data folder and check names
defdir=$HOME
mkdir ${defdir}/sen2data

mv ${defdir}/sen2data/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326 ${defdir}/sen2data/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326.SAFE

#Run sen2cor
L2A_Process --resolution=10 --GIP_L2A /home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg/L2A_GIPP.xml ${defdir}/sen2data/S2A_MSIL1C_20170103T022102_N0204_R003_T51PUR_20170103T023326.SAFE

