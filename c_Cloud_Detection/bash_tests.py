import subprocess
import os
import pprint

command_args = ['conda config --add channels conda-forge', 'conda create -n myenv python-fmask', 'source activate myenv']

# working command:
# command_args_2 = ['pip install matplotlib']

#def subprocess_cmd(list_of_commands):
    process = subprocess.Popen(command_args,stdout=subprocess.PIPE, shell=True)
    proc_stdout = process.communicate()[0].strip()
    print proc_stdout
    #proc = subprocess.Popen(list_of_commands, stdout=subprocess.PIPE, shell=True)

    #for line in proc.stdout:
    #    (key, _, value) = line.partition("=")
    #    os.environ[key] = value

    #proc.communicate()

    #pprint.pprint(dict(os.environ))

#subprocess_cmd('conda config --add channels conda-forge; conda create -n myenv python-fmask; source activate myenv')
#subprocess_cmd('echo command')