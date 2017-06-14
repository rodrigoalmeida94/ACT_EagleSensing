# a_Data_Acquisition
# accounts_hub.py
# Gets Sentinel Hub user credentials out of a text file into a dictionary for use in the download process.

def account(filepath = 'a_Data_Acquisition/Data/accounts_hub.txt'):
    file = open(filepath,'r')
    d = {}
    for line in file:
        a,b = line.split(' ')
        if a.endswith('\n'):
            a=a[:-1]
        if b.endswith('\n'):
            b=b[:-1]
        d[a] = [a,b]
    return d