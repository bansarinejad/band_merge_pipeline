FUNCTION twodf_pqso, file_raw

;### THIS CODES INTERFACES THE GENERATED CATALOGUE WITH THE XDQSO CODE #
;### THIS IS USED TO FIND QSO CANDIDATES ###############################

;## PARAMETER CHECKS ###################################################
IF N_PARAMS() 				NE 1 THEN 	MESSAGE, 'twodf_pqso : MISSING AN INPUT PARAMETER'
IF SIZE(file_raw,/TYPE) 	NE 7 THEN	MESSAGE, 'twodf_pqso : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = MRDFITS(file_raw , 1 , header_raw , STATUS = read_in_status)
IF read_in_status 			NE 0 THEN 	MESSAGE, 'twodf_pqso : RAW FILE CANNOT BE READ'
IF SIZE(data[0].ra,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_pqso : WARNING - RA IS NOT A DOUBLE'
IF SIZE(data[0].dec,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_pqso : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = N_ELEMENTS(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;#### SETUP DATA TO INPUT INTO XDQSO ###################################
;create strucutre suitable FOR xdqso
xd_input = {PSFFLUX:FLTARR(5),PSFFLUX_IVAR:FLTARR(5),EXTINCTION:FLTARR(5)}
xd_input = REPLICATE  ( xd_input[0] , num_cat )
;#######################################################################

; write input data into template structure
; SLOW and MESSY
FOR i=0L,(num_cat-1),1 DO BEGIN 
xd_input[i].psfflux=[		data[i].u3_flux,	$
					data[i].g3_flux,	$
					data[i].r3_flux,	$
					data[i].i3_flux,	$
					data[i].z3_flux]
							
xd_input[i].psfflux_ivar=[	data[i].u3_ivar,		$
							data[i].g3_ivar,	$
							data[i].r3_ivar,	$
							data[i].i3_ivar,	$
							data[i].z3_ivar]

xd_input[i].extinction=[				data[i].u_ext,	$
							data[i].g_ext,	$
							data[i].r_ext,	$
							data[i].i_ext,	$
							data[i].z_ext]
ENDFOR

;add xdqso input to total structure FOR traceability
COMBINE_STRUCTS, data, xd_input, data_int  , STRUCTYP=STRUCTYP
;#######################################################################

;#### INTERFACE WITH XDQSO #############################################
;lower redshift is set here
zl = 0.8

;upper redshift is set here
zu = 2.5

;massive anticlimax
result =  xdqsoz_calculate_prob (xd_input,zl,zu)

;add xdqso output and write out
COMBINE_STRUCTS, data_int, result, outstruct, STRUCTYP=STRUCTYP

;### OUTPUT STUFF ######################################################
;add the pointing to the header
FXADDPAR, header_raw, 'ZL', zl , 'XDQSO - LOWER REDSHIFT INPUT'
FXADDPAR, header_raw, 'ZU', zu , 'XDQSO - UPPER REDSHIFT INPUT'

;STOP

;make a new filename
STRREPLACE, file_raw, 'match/' , 'pqso/'
out_name = STRCOMPRESS(STRSPLIT( file_raw , '.mer' , /EXTRACT , /REGEX ) + '_' + 'xdqso' + '.mer' ,/REMOVE_ALL) 
MWRFITS , outstruct , out_name , header_raw , /CREATE ;overwrite previous files

RETURN, out_name
END
