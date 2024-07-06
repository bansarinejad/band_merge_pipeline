#!/bin/bash
source ~/.bashrc
# THIS SCRIPT SETS UP A NEW DIRECTORY STRUCTURE FOR NEW OBS

########################## DEFINE PATH OPTIONS #########################
not_remote=/home/ben/obs/2qdes/
remote=/obs/r1/hppr34/2qdes/
# TEST FOR not_remote
if [ -d "$not_remote" ]; then
  path=/home/ben/obs/2qdes/
fi
# TEST FOR REMOTE
if [  -d "$remote" ]; then
  path=/obs/r1/hppr34/2qdes/
fi
########################################################################

new_run=$path$1_run

if [ -d "$new_run" ]; then
	echo TOP LEVEL DIRECTORY ALREADY EXISTS
fi

if [ ! -d "$new_run" ]; then
	echo Making new directory - top level
	mkdir $new_run
	cd $new_run
	mkdir cats
	mkdir fields
	mkdir coords
	mkdir wise_in
	mkdir wise_out
	mkdir match
	mkdir target
	mkdir fld
	mkdir guidestars
	mkdir results
	mkdir rz
fi

if [ -d "$new_run" ]; then
	echo TOP LEVEL DIRECTORY ALREADY EXISTS
fi
