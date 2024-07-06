#!/bin/bash
source /home/ben/.bashrc
# THIS SCRIPT MARKS DUPLICATE OBJECTS ##################################
outname=${1/.mer/_int.mer}
stilts tmatch1 matcher=sky params=1 values="RA_DEG DEC_DEG" 	\
               action=identify ifmt=fits ofmt=fits		\
               in=$1 out=$outname
