FUNCTION twodf_wise, file_raw

;#### THIS CODE GENERATES A IPAC TABLE #################################
;#### FOR QUERYING THE WISE DATABASE ###################################

;## PARAMETER CHECKS ###################################################
IF N_PARAMS() 			NE 1 THEN MESSAGE, 'twodf_wise : MISSING AN INPUT PARAMETER'
IF SIZE(file_raw,/TYPE) 	NE 7 THEN MESSAGE, 'twodf_wise : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = MRDFITS(file_raw , 1 , header_raw , STATUS = read_in_status)
IF read_in_status 		NE 0 THEN MESSAGE, 'twodf_wise : RAW FILE CANNOT BE READ'
IF SIZE(data[0].ra,/TYPE) 	NE 5 THEN MESSAGE, 'twodf_wise : WARNING - RA IS NOT A DOUBLE'
IF SIZE(data[0].dec,/TYPE) 	NE 5 THEN MESSAGE, 'twodf_wise : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = N_ELEMENTS(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;#### WRITE AN IPAC TABLE ##############################################
;make a NEw filename
file_name = file_raw
strreplace, file_name, 'coords' , 'wise-in'
out_name = strcompress(strsplit( file_name , '.mer' , /extract , /regex ) + '_' + 'wise-in' + '.tbl' ,/remove_all)


;geNErate the ipac header
file_header = '\' + header_raw

;open file
openw, lun, out_name, /get_lun , width=400

;print header etc.
PRINTF , LUN , file_header
PRINTF , LUN , '|','ATLAS_ID','|','cntr','|','ra',		'|','dec'	,'|','major' ,'|',format='(A,TR10,A,TR11,A,TR4,A,TR4,A,TR9,A,TR17,A,TR8,A,TR14,A,TR8,A,TR13,A)'
PRINTF , LUN , '|','char'	 ,'|','int'	,'|','double',	'|','double','|','double','|',format='(A,TR10,A,TR15,A,TR4,A,TR5,A,TR9,A,TR13,A,TR8,A,TR11,A,TR8,A,TR12,A)'
;print the data
FOR i=0L,num_cat-1 DO BEGIN
	PRINTF,lun,data[i].ATLAS_ID,i+1,data[i].RA_DEG,data[i].DEC_DEG,10.0d,FORMAT='(TR1,A,TR1,I,TR1,D,TR1,D,TR1,D,TR1)'
ENDFOR

close, lun
free_lun, lun

;### CHECK ####
;command = 'scribes' + ' '  out_name'''
;spawn,command

RETURN, out_name
END
