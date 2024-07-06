pro s82_wise, file_raw

;#### THIS CODE GENERATES A IPAC TABLE #################################
;#### FOR QUERYING THE WISE DATABASE ###################################

;## PARAMETER CHECKS ###################################################
IF n_params() ne 1 THEN 				MESSAGE, 'twodf_wise : MISSING AN INPUT PARAMETER'
IF size(file_raw,/type) ne 7 THEN 		MESSAGE, 'twodf_wise : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = mrdfits(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_wise : RAW FILE CANNOT BE READ'
IF size(data[0].ra_1,/type) ne 5 THEN 	MESSAGE, 'twodf_wise : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec_1,/type) ne 5 THEN 	MESSAGE, 'twodf_wise : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = n_elements(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;#### WRITE AN IPAC TABLE ##############################################
;make a new filename
strreplace, file_raw, 'coords' , 'wise-in'
out_name = strcompress(strsplit( file_raw , '.mer' , /extract , /regex ) + '_' + 'wise-in' + '.tbl' ,/remove_all)


;generate the ipac header
file_header = '\' + header_raw

;open file
openw, lun, out_name, /get_lun , width=400

;print header etc.
printf , lun , file_header
printf , lun , '|','ATLAS_ID','|','cntr','|','ra',		'|','dec'	,'|','major' ,'|',format='(A,TR10,A,TR11,A,TR4,A,TR4,A,TR9,A,TR17,A,TR8,A,TR14,A,TR8,A,TR13,A)'
printf , lun , '|','char'	 ,'|','int'	,'|','double',	'|','double','|','double','|',format='(A,TR10,A,TR15,A,TR4,A,TR5,A,TR9,A,TR13,A,TR8,A,TR11,A,TR8,A,TR12,A)'
;print the data
for i=0L,num_cat-1 do begin
	printf,lun,data[i].ATLAS_ID,i+1,data[i].RA_1,data[i].DEC_1,10.0d,format='(TR1,A,TR1,I,TR1,D,TR1,D,TR1,D,TR1)'
endfor

close, lun
free_lun, lun

;### CHECK ####
;command = 'scribes' + ' '  out_name'''
;spawn,command


end


