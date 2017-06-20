#!/usr/bin/env bash
cd ${defdir}


## 5. DOWNLOAD AND INSTALL LATEST SNAP
SNAPREPO=http://step.esa.int/downloads/
SNAPVERSION=$(wget -q -O - ${SNAPREPO} | egrep '[[:alnum:]]\.[[:alnum:]]' | grep "$(date +%Y)" | grep -v ".txt" | tail -n 1 | cut -d \" -f 8)
SNAPINSTALLDIR=$(wget -q -O - ${SNAPREPO}${SNAPVERSION} | grep "installers" | tail -n 1 | cut -d \" -f 8)
SNAPFILE=$(wget -q -O - ${SNAPREPO}${SNAPVERSION}${SNAPINSTALLDIR} | grep "all" | grep "unix" |  tail -n 1 | cut -d \" -f 8)
wget -O ${dldir}/snap.sh ${SNAPREPO}${SNAPVERSION}${SNAPINSTALLDIR}${SNAPFILE}
mkdir ${defdir}/SNAP -p
cd ${defdir}/SNAP/
yes yes | bash ${SNAPFILE} -c