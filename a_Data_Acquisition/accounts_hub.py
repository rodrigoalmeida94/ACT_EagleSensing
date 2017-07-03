# a_Data_Acquisition
# accounts_hub.py
# Gets Sentinel Hub user credentials out of a text file into a dictionary for use in the download process.

import requests

def account(filepath):
    file = open(filepath, 'r')
    d = {}
    for line in file:
        a, b = line.split(' ')
        if a.endswith('\n'):
            a = a[:-1]
        if b.endswith('\n'):
            b = b[:-1]
        d[a] = [a, b]

    # Checks if provided credentials are valid, removes them if not.
    url = 'https://scihub.copernicus.eu/dhus//login'
    delete =[]
    for cred in d:
        resp = requests.post(url, data={'login_username': d[cred][0], 'login_password': d[cred][1]})
        if resp.status_code != 200:
            delete += [cred]

    for x in delete:
        print 'User '+ delete[0] + ' removed since username or password are invalid.'
        d.pop(x)

    if len(d) == 0:
        raise ValueError('The provided Sentinel Data Hub credentials are incorrect or non-existent.')

    return d

if __name__ == '__main__':
    print(account('Data/accounts_hub.txt'))
