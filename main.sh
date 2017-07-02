#!/usr/bin/env bash

# HELP AND DEBUG INFORMATION ON HOW TO USE THIS FILE
if [[ $# -eq 0 ]] ; then
echo 'Incorrect usage, please use the -h option to get information on usage'
exit 0
fi

usage="$(basename "$0") 

Program to convert Sentinel-2A L1C  products into L3 products and storing intermediate L2A products. 

Allowed options are: [-a arg] [-p arg] [-x arg] [-s arg] [-e arg] [-d arg] [-r arg] .

    (-h  Shows this help text)

    -a  Specify the path to dummy accounts (txt) to login to the platforms
    -p  Specify the platform (ama for amazon, esa for esa's scihub)    
    -x  Specify the path of the extent dataset (i.e. plantation geotiff)
    -s  Specify a start date (yyyymmdd)
    -e  Specify an end date (yyyymmdd)
    -d  Specify the directory path where the images will be stored
    -r  Specify the resolution for the atmospheric correction (in m)
    -l  Specify the atmospheric corrected L2A product directory"

if [[ $# -ne 16 ]] && [[ $1 != -h ]]; then
	echo "Not enough parameters used, please only use all 8 parameters with arguments! See help (use the -h option)"
exit 0
fi

while getopts ':ha:p:x:s:e:d:r:l:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    a) account_txt=$OPTARG
       echo "selected accounts file: $account_txt"
	if [ ! -f "$account_txt" ]; then
	echo "Accounts file does not exist!"
	exit 1
	fi
       ;;
    p) hub=$OPTARG
	echo "selected download platform: $hub"
	if [ "$hub" != "ama" ] && [ "$hub" != "esa" ]; then
	echo "Illegal argument for the download platform! Please use ama or esa."
	exit 1
	fi
       ;;
    x) extent_file=$OPTARG
	echo "selected extent file: $extent_file"
	if [ ! -f "$extent_file" ]; then
	echo "Exent file does not exist!"
	exit 1
	fi
       ;;
    s) from_date=$OPTARG
	echo "selected from date: $from_date"
	if [ ${#from_date} != 8 ]; then
	echo "Please use the yyyymmdd format for the start date!"
	exit 1
	fi
       ;;
    e) to_date=$OPTARG
	echo "selected to date: $to_date"
	if [ ${#to_date} != 8 ]; then
	echo "Please use the yyyymmdd format for the end date!"
	exit 1
	fi
       ;;
    d) sen_dl_dir=$OPTARG
	echo "selected processing directory: $sen_dl_dir"
	if [ ! -d "$sen_dl_dir" ]; then
	echo "This download directory does not exist! (consider using mkdir first!)"
	exit 1
	fi
       ;;
    r) resolution=$OPTARG
	echo "selected resolution: $resolution"
	if [ $resolution -le 10 ]; then
	echo "Please use for resolution positive numbers greater than or equal to 10"
	exit 1
	fi
       ;;
    l) sen_l2a_dir=$OPTARG
	echo "selected sen_l2a_dir: sen_l2a_dir"
	if [ ! -d "$sen_l2a_dir" ]; then
	echo "This l2a product directory does not exist! (consider using mkdir first!)"
	exit 1
	fi
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG">&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG">&2
	echo "Please use the -h option to see all legal options"
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))



# ACTUAL EXECUTION OF THE OTHER FILES


source activate data_acquisition

if [ "${hub}" = "ama" ]
    then python a_Data_Acquisition/download_amz.py ${sen_dl_dir} ${extent_file} ${account_txt} ${from_date} ${to_date}
elif [ "${hub}" = "esa" ]
    then python a_Data_Acquisition/download_hub.py ${sen_dl_dir} ${extent_file} ${account_txt} ${from_date} ${to_date}
fi

source deactivate


## Get the created dir with timestamp by python from txt file 

sen_l1c_dir=$(grep "${sen_dl_dir}" ${sen_dl_dir}/TIME_DIR.txt) 
rm ${sen_dl_dir}/TIME_DIR.txt


## Start the atmospheric correction with sen2cor

source activate atmosphere

python b_Atmospheric_Correction/generate_L2A.py ${resolution} ${sen_l1c_dir} ${sen_l2a_dir}

source deactivate


## Start the mosaicing

source activate mosaicing

Rscript d_Mosaicing/mosaicing.R --default-packages=rgdal,utils,raster,XML,tools --verbose ${sen_l2a_dir} [OUTPUT_DIR]

source deactivate
