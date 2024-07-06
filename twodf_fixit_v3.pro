PRO twodf_fixit_v3, file_raw

;#### THIS CODE PERFORMS ALL ACTION TO TURN A 2dF FIELD INTO AN 
;#### FLD FILE IN A SINGLE STEP - THAT IS A SINGLE IDL PROGRAMME

;## PARAMETER CHECKS ###################################################
IF N_PARAMS() 		   NE 1 THEN	MESSAGE, 'twodf_observation : MISSING AN INPUT PARAMETER'
IF SIZE(file_raw,/TYPE)    NE 7	THEN 	MESSAGE, 'twodf_observation : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = MRDFITS(file_raw , 1 , header_raw , STATUS = read_in_status)
IF read_in_status 	   NE 0 THEN	MESSAGE, 'twodf_observation : RAW FILE CANNOT BE READ'
IF SIZE(data[0].ra,/TYPE)  NE 5 THEN 	MESSAGE, 'twodf_observation : WARNING - RA IS NOT A DOUBLE'
IF SIZE(data[0].dec,/TYPE) NE 5 THEN 	MESSAGE, 'twodf_observation : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;get the coordinates and target names
a = twodf_radec(file_raw)
print, a
e = a[0]
strreplace, e,'coords/','pqso/'
strreplace, e,'.mer','_best_int_noduplicates_wise_xdqso.mer'

;xdqso all objects
;f = twodf_pqso(e)
;print, f

;select the objects
ra_str = a[1]
dec_str = a[2]
print, ra_str , dec_str

;twodf_selection,e, ra_str, dec_str,/CENTRE, /PSTAR
twodf_selection_v3,e, ra_str, dec_str,/CENTRE, /CLASS



END
