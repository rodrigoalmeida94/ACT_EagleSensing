# Function to move L2A files from L1C since there's no argument to specify output files destination during sen2cor run.

import os
import shutil
import fire
from run_sen2cor import sen2_batch


def generate_L2A (res, dir_L1C, dir_L2A):
    sen2_batch(res, dir_L1C)
    checker = "L2A"
    dfiles = os.listdir(dir_L1C)

    if not os.path.exists(dir_L2A):
        os.makedirs(dir_L2A)

    for folders in dfiles:
        if folders [7:10] == checker or folders [16:19] == checker:
            shutil.move(os.path.join(dir_L1C, folders), dir_L2A)
            print "L2A folder successfully done and moved"

    if not os.path.isdir(dir_L1C):
        raise ValueError('L1C_directory: '+ dir_L1C + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')
    if not os.path.isdir(dir_L2A):
        raise ValueError('L2A_directory: '+ dir_L2A + ' does not exist or is inaccesible. Your current working directory is '+os.getcwd()+'.')

    new_dir = dir_L2A
    return new_dir

if __name__ == '__main__':
    fire.Fire(generate_L2A)