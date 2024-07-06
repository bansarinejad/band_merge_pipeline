pro s82_pqso, file_raw

;### THIS CODES INTERFACES THE GENERATED CATALOGUE WITH THE XDQSO CODE #
;### THIS IS USED TO FIND QSO CANDIDATES ###############################

;## PARAMETER CHECKS ###################################################
IF n_params() ne 1 THEN 				MESSAGE, 'twodf_pqso : MISSING AN INPUT PARAMETER'
IF size(file_raw,/type) ne 7 THEN 		MESSAGE, 'twodf_pqso : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = mrdfits(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_pqso : RAW FILE CANNOT BE READ'
IF size(data[0].ra_1,/type) ne 5 THEN 	MESSAGE, 'twodf_pqso : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec_1,/type) ne 5 THEN 	MESSAGE, 'twodf_pqso : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = n_elements(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;#### INTERFACE WITH XDQSO #############################################
;lower redshift is set here
zl = 0.8

;upper redshift is set here
zu = 2.5

;massive anticlimax
result =  xdqsoz_calculate_prob (data,zl,zu)

;add xdqso output and write out
combine_structs, data, result, outstruct, structyp=structyp

;### OUTPUT STUFF ######################################################
;add the pointing to the header
fxaddpar, header_raw, 'ZL', zl , 'XDQSO - LOWER REDSHIFT INPUT'
fxaddpar, header_raw, 'ZU', zu , 'XDQSO - UPPER REDSHIFT INPUT'


;make a new filename
strreplace, file_raw, 'match/' , 'pqso/'
out_name = strcompress(strsplit( file_raw , '.mer' , /extract , /regex ) + '_' + 'xdqso' + '.mer' ,/remove_all) 
MWRFITS , outstruct , out_name , header_raw , /create ;overwrite previous files



end
