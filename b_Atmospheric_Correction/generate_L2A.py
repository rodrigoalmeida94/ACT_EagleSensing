# Function to move L2A files from L1C since there's no argument to specify output files destination during sen2cor run.

import os
import shutil
import fire
from run_sen2cor import sen2_batch


def generate_L2A (res, dir_L1C, dir_L2A):
    sen2_batch(res, dir_L1C)
    checker1 = "L2A"
    dfiles = os.listdir(dir_L1C)

    if not os.path.exists(dir_L2A):
        os.makedirs(dir_L2A)
    for folders in dfiles:
        if folders [7:10] == checker1:
            shutil.move(os.path.join(dir_L1C, folders), dir_L2A)
            print "L2A folders successfully moved"
        else:
            print "no finished L2A folders to move"

    new_dir = dir_L2A
    return new_dir

if __name__ == '__main__':
    fire.Fire(generate_L2A)