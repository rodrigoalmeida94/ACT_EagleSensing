import xml.etree as ET
import os

datadir = r'/home/user/anaconda2/lib/python2.7/site-packages/sen2cor-2.3.1-py2.7.egg/sen2cor/cfg'
os.chdir(datadir)

et = xml.etree.ElementTree.parse('L2A_GIPP.xml')

before = '1'
after = '6'

line = """<root> 
        <Nr_Processes>1</Nr_Processes>
</root> 
"""

root = ET.fromstring(line)

for item in root.xpath('//*[. = "%s"]' % before):
    item.text = item.text.replace(before, after)

print ET.tostring(root)