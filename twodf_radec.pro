FUNCTION twodf_radec, file_raw

;### THIS CODE GENERATES A LIST OF SOURCE NAMES ########################
;### THIS WILL PREVENT CONFUSION BETWEEN COORD CONVERSION ##############


;## PARAMETER CHECKS ###################################################
IF N_PARAMS() NE 1 THEN 		MESSAGE, 'twodf_radec : MISSING AN INPUT PARAMETER'
IF size(file_raw,/TYPE) NE 7 THEN 	MESSAGE, 'twodf_radec : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = MRDFITS(file_raw , 1 , header_raw , STATUS = read_in_status)
IF read_in_status NE 0 THEN 		MESSAGE, 'twodf_radec : RAW FILE CANNOT BE READ'
IF SIZE(data[0].ra,/TYPE) NE 5 THEN 	MESSAGE, 'twodf_radec : WARNING - RA IS NOT A DOUBLE'
IF SIZE(data[0].dec,/TYPE) NE 5 THEN 	MESSAGE, 'twodf_radec : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = N_ELEMENTS(data.(0))		;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################di

;#### CREATE A STRUCTURE TO HOLD THE NEW COORDS ########################
new_struct = create_struct('ATLAS_ID','','RA_DEG',0.0d,'DEC_DEG',0.0d,'RA_SEX','','DEC_SEX','','TILE','')
new_struct = REPLICATE(new_struct,num_cat)

;fill the degrees columns
new_struct.RA_DEG = data.RA*rad2deg
new_struct.DEC_DEG = data.DEC*rad2deg
new_struct.TILE = file_raw

;fill the sexegesimal columns ****GOES FROM THE DEGREES****
radec, new_struct.RA_DEG , new_struct.DEC_DEG , hh_r , mm_r , ss_r , dd_d , mm_d , ss_d
new_struct.RA_SEX  = STRCOMPRESS( STRING(hh_r,'(I2.2)') + ':' + STRING(mm_r,'(I2.2)') + ':' + STRING(ss_r,'(D)') , /REMOVE_ALL )
new_struct.DEC_SEX = STRCOMPRESS( STRING(dd_d,'(I3.2)') + ':' + STRING(mm_d,'(I2.2)') + ':' + STRING(ss_d,'(D)') , /REMOVE_ALL )

;make at ATLAS ID - SEE IAU format HHMMSS.ss+DDMMSS.s http://cdsweb.u-strasbg.fr/Dic/iau-spec.html
atlas = REPLICATE('ATLAS_J',num_cat)
new_struct.ATLAS_ID = STRCOMPRESS( atlas + STRING(hh_r,'(I2.2)') + ':' + STRING(mm_r,'(I2.2)') + ':' $
					+ STRING(ss_r,'(D05.2)') + STRING(dd_d,'(I3.2)') + ':' + STRING(mm_d,'(I2.2)') + ':' + $
					  STRING(ss_d,'(D04.1)'), /REMOVE_ALL )


;read the pointings
ra_str  = FXPAR ( header_raw , 'RA' )
dec_str = FXPAR ( header_raw , 'DEC')
	
	
;## OUTPUT THE DATA ####################################################
;combine the two structures
COMBINE_STRUCTS , new_struct , data , outstruct
;make a new filename
STRREPLACE, file_raw, 'fields' , 'coords'
out_name = STRCOMPRESS(STRSPLIT( file_raw , '.mer' , /EXTRACT , /REGEX ) + '_' + 'coords' + '.mer' ,/REMOVE_ALL)

MWRFITS , outstruct , out_name , header_raw , /CREATE ;overwrite previous files
RETURN, [out_name, ra_str, dec_str]
END
