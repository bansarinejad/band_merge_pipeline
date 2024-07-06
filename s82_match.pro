pro s82_match , 	file_atlas ,$
					file_wise

;### THIS CODE COMBINES THE ATLAS DATA WITH THE WISE DATA ##############
;### CURRENTLY WE ONLY TAKE THE W1 BAND [3.4um] INFO ###################


;## PARAMETER CHECKS ###################################################
IF n_params() ne 2 THEN 				MESSAGE, 'twodf_match : WRONG NUMBER OF INPUT PARAMETERS'
IF size(file_atlas,/type) ne 7 THEN 	MESSAGE, 'twodf_match : FILE_ATLAS IS NOT A STRING'
IF size(file_wise,/type) ne 7 THEN 		MESSAGE, 'twodf_match : FILE_WISE IS NOT A STRING'
;#######################################################################

; ## READ IN THE ATLAS FILE ##############################################
ATLAS = mrdfits(file_atlas , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_match : ATLAS FILE CANNOT BE READ'
IF size(ATLAS[0].ra_1,/type) ne 5 THEN 	MESSAGE, 'twodf_match : WARNING - ATLAS RA IS NOT A DOUBLE'
IF size(ATLAS[0].dec_1,/type) ne 5 THEN 	MESSAGE, 'twodf_match : WARNING - ATLAS DEC IS NOT A DOUBLE'
;#######################################################################

; ## READ IN THE WISE FILE ##############################################
WISE = read_ipac_table(file_wise , change_null=!NULL )
IF size(WISE[0].ra_01,/type) ne 5 THEN 	MESSAGE, 'twodf_match : WARNING - WISE RA IS NOT A DOUBLE'
IF size(WISE[0].dec_01,/type) ne 5 THEN 	MESSAGE, 'twodf_match : WARNING - WISE DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = n_elements(ATLAS.(0))			;number of rows read from the ATLAS file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;create structure containing desired info from wise
create_struct,extract_info,'',['W1','cntr_01','atlasidentification'],'F,I,A'
extract_info = replicate(extract_info[0],num_cat)

;get the wise data matched to the atlas data
index 									= wise.cntr_01-1
extract_info[index].cntr_01				= wise.cntr_01-1
extract_info[index].w1 					= wise.w1mpro
extract_info[index].atlasidentification = wise.atlas_id_01

;combine structures
combine_structs , atlas , extract_info , outstruct

;add traceable filename to header
fxaddpar, header_raw, 'COMMENT', file_wise

;make a new filename
strreplace, file_atlas, 'wise-in' , 'wise'
out_name = strcompress(strsplit( file_atlas , '.mer' , /extract , /regex ) + '_wise' +'.mer' ,/remove_all)

MWRFITS , outstruct , out_name , header_raw , /create ;overwrite previous files (if any)


end
