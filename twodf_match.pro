FUNCTION twodf_match , 	file_atlas ,$
			file_wise

;### THIS CODE COMBINES THE ATLAS DATA WITH THE WISE DATA ##############
;### CURRENTLY WE ONLY TAKE THE W1 BAND [3.4um] INFO ###################


;## PARAMETER CHECKS ###################################################
IF N_PARAMS() 			NE 2 THEN 	MESSAGE, 'twodf_match : WRONG NUMBER OF INPUT PARAMETERS'
IF SIZE(file_atlas,/TYPE) 	NE 7 THEN 	MESSAGE, 'twodf_match : FILE_ATLAS IS NOT A STRING'
IF SIZE(file_wise,/TYPE) 	NE 7 THEN 	MESSAGE, 'twodf_match : FILE_WISE IS NOT A STRING'
;#######################################################################

; ## READ IN THE ATLAS FILE ##############################################
ATLAS = mrdfits(file_atlas , 1 , header_raw , status = read_in_status)
IF read_in_status 		NE 0 THEN 	MESSAGE, 'twodf_match : ATLAS FILE CANNOT BE READ'
IF SIZE(ATLAS[0].ra,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_match : WARNING - ATLAS RA IS NOT A DOUBLE'
IF SIZE(ATLAS[0].dec,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_match : WARNING - ATLAS DEC IS NOT A DOUBLE'
;#######################################################################

; ## READ IN THE WISE FILE ##############################################
WISE = read_ipac_table(file_wise );, change_null=!NULL )
IF SIZE(WISE[0].ra_01,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_match : WARNING - WISE RA IS NOT A DOUBLE'
IF SIZE(WISE[0].dec_01,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_match : WARNING - WISE DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = N_ELEMENTS(ATLAS.(0))		;number of rows read from the ATLAS file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;create structure containing desired info from wise
CREATE_STRUCT,extract_info,'',['W1','W2','W3','W4','cntr_01','atlasidentification'],'F,F,F,F,I,A'
extract_info = REPLICATE(extract_info[0],num_cat)

;get the wise data matched to the atlas data
index 						= wise.cntr_01-1
extract_info[index].cntr_01			= wise.cntr_01-1
extract_info[index].w1 				= wise.w1mpro
extract_info[index].w2 				= wise.w2mpro
extract_info[index].w3 				= wise.w3mpro
extract_info[index].w4 				= wise.w4mpro
extract_info[index].atlasidentification 	= wise.atlas_id_01

;combine structures
COMBINE_STRUCTS , atlas , extract_info , outstruct

;add traceable filename to header
FXADDPAR, header_raw, 'COMMENT', file_wise[0]

;make a new filename
STRREPLACE, file_atlas, 'coords/' , 'match/'
out_name = STRCOMPRESS(STRSPLIT( file_atlas , '.mer' , /EXTRACT , /REGEX ) + '_wise' +'.mer' ,/REMOVE_ALL)

MWRFITS , outstruct , out_name , header_raw , /CREATE ;overwrite previous files (if any)

RETURN, out_name
END
