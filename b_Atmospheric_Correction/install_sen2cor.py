import urllib2
import html2text
import nltk

#!/usr/bin/env python



#sen2cor installation script

#set directory

my dir =



##check latest version and download anaconda
CONTREPO=https://repo.continuum.io/archive/
    # Stepwise filtering of the html at $CONTREPO
    # Get the topmost line that matches our requirements, extract the file name.
    ANACONDAURL=(wget -q -O - $CONTREPO index.html | grep "Anaconda3-" | grep "Linux" | grep "86_64" | head -n 1 | cut -d \" -f 2)
    wget -O ~/Downloads/anaconda.sh $CONTREPO$ANACONDAURL
    bash ~/Downloads/anaconda.sh


    source = urllib2.urlopen("https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh").read()
    open("mydir", "wb").write(source)


