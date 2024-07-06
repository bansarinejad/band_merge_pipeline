#!/bin/bash
source /home/ben/.bashrc
# THIS SCRIPT DOWNLOADS THE WISE DATA ##################################
echo $1
curl -F filename=@$1 \
-F spatial=Upload \
-F uradius=3.0 \
-F uradunits=arcsec \
-F catalog=wise_allsky_4band_p3as_psd \
-F outfmt=1 \
"http://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-query"  > $1.tmp
mv $1.tmp ${1/wise-in/wise-out}
#which file contains the targets
#instructs the server that targets will be uploaded
# radius of search i.e. match radius
# units of search radius
#search wise all sky survey
#output reult to ascii file
