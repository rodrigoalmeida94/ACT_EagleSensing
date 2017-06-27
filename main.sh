#!/usr/bin/env bash

#Specify parameters below when calling the script:
account_txt="$1"
hub="$2"
extent_file="$3"
from_date="$4"
to_date="$5"
sen_dl_dir="$6"
resolution="$7"

source activate data_acquisition

if [${hub}=ama]
    then python download_amz.py "${sen_dl_dir}" "${extent_file}" "${from_date}" "{$to_date}"
elif [${hub}=esa]
    then python download_amz.py "${sen_dl_dir}" "${extent_file}" "${from_date}" "{$to_date}"
else echo "Please specify the download portal: amazon = ama, esascihub=esa"
fi

source deactivate