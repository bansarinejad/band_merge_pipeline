#!/bin/bash
source ~/.bashrc

FILES="/home/ben/Documents/2qdes/feb_run/2df-guidestars/*.txt"
for f in $FILES
do
	echo "Processing $f"
	new=${f/.txt/}
	mkdir $new
	cd $new
	dss1 -i $f
done
