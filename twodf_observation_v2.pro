PRO twodf_observation_v2, file_raw

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
a = twodf_radec_v2(file_raw)
print, a

;identify the objects with the best u photometry
b = best_u(a[0])
print, b

;use stilts to identify internal atlas matches 
command = '/obs/r1/hppr34/2qdes/pipeline/./topcat_match.sh ' + b
spawn, command

;get filename for matched topcat list 
int = b
STRREPLACE, int, '.mer','_int.mer'

;remove duplicate objects
c = remove_duplicates(int)
print, c

;wise
d = twodf_wise(c)
print, d

;use curl to download wise data
command = '/obs/r1/hppr34/2qdes/pipeline/./twodf_wise_get_3.sh ' + d
spawn, command

;get the filename for wise table
wise = d
STRREPLACE, wise, 'wise-in', 'wise-out'

;match the two lists
e = twodf_match(c,wise)
print, e

;xdqso all objects
f = twodf_pqso(e)
print, f

;select the objects
ra_str = a[1]
dec_str = a[2]
print, ra_str , dec_str

;twodf_selection,f, ra_str, dec_str,/CENTRE, /PSTAR
twodf_selection_v2,f, ra_str, dec_str,/CENTRE, /CLASS



END
