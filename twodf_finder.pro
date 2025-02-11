PRO twodf_finder, 	file_raw 	,$ ; raw file INC PATH
					nfields		   ; number of fields

;## PARAMETER CHECKS ###################################################
IF n_params() 				NE 2 THEN 		MESSAGE, 'twodf_finder : MISSING AN INPUT PARAMETER'
IF size(file_raw,/type) 	NE 7 THEN 	MESSAGE, 'twodf_finder : FILE_RAW IS NOT A STRING'
IF size(nfields,/type) 		NE 2 THEN 	MESSAGE, 'twodf_finder : NFIELDS IS NOT AN INTEGER'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data=MRDFITS(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status 			NE 0 THEN 		MESSAGE, 'twodf_finder : RAW FILE CANNOT BE READ'
IF size(data[0].ra,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_finder : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec,/TYPE) 	NE 5 THEN 	MESSAGE, 'twodf_finder : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = N_ELEMENTS(data.(0))		;number of rows read from the fits file , surprisingly useful 
flag_angsep = REPLICATE(0.,num_cat)	; a flag identifying which targets are within the 2df field from the pointing
ra = FLTARR(nfields)
dec = FLTARR(nfields)
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################

;### BELOW HERE START TO MANIPULATE THE INPUT DATA #####################

;FIND THE MAXIMUM & MINIMUM RA ####
ra_max=MAX(data.ra) ; MINimum ra
ra_min=MIN(data.ra) ; MAXimum ra
dec[*]=((MIN(data.dec)+MAX(data.dec))/2.) - 0.01833
;####

FOR i=0,nfields-1 DO BEGIN
;	dec[i]=(MAX(data.dec)-(1*0.01833)) ;uncomment for multiple dec strips 
	IF (i EQ 0) THEN BEGIN
		;ra[i]=5.62571+0.01833
		ra[i]=ra_min+0.0185
	ENDIF ELSE BEGIN
		;ra[i]=ra[i-1]+(2*0.0205)
		ra[i] = max_ra + 0.0205
	ENDELSE
	angsep=acos(sin(dec[i])*sin(data.dec)+cos(dec[i])*cos(data.dec)*cos(ra[i]-data.ra)) ; geometry check for within 2df radius
	
	field = data[where(angsep le 0.01833)] ; set output data into unique structure
	max_ra = MAX(FIELD.RA)
	;GET THE POINTING
	radec , ra[i]*rad2deg , dec[i]*rad2deg , hh_r , mm_r , ss_r , dd_d , mm_d , ss_d
	
	;convert to two strings
	ra_pointing_string	= strcompress( STRING(hh_r,'(I2.2)') + ':' + STRING(mm_r,'(I2.2)') + ':' + STRING(ss_r,'(D)') , /remove_all)
	dec_pointing_string = strcompress( STRING(dd_d,'(I3.2)') + ':' + STRING(mm_d,'(I2.2)') + ':' + STRING(ss_d,'(D)') , /remove_all)

	;do some rounding of the MINutes
	IF ss_r GE 30 THEN mm_r = mm_r + 1
	IF ss_d GE 30 THEN mm_d = mm_d + 1

	combined_pointing_sting = strcompress( STRING(hh_r,'(I2.2)') + 'h' + STRING(mm_r,'(I2.2)') + 'm' + STRING(dd_d,'(I3.2)') + 'd' + STRING(mm_d,'(I2.2)') + 'm',/remove_all)

	;WRITE THE FILE
	;add the pointing to the header
	fxaddpar, header_raw, 'RA', ra_pointing_string , 'RA POINTING OF FIELD'
	fxaddpar, header_raw, 'DEC', dec_pointing_string , 'DEC POINTING OF FIELD'
	
	;make a new filename
	strreplace, file_raw, 'cats' , 'fields'
	field_name = strcompress(strsplit( file_raw , '.mer' , /extract , /regex ) + '_' + combined_pointing_sting + '.mer' ,/remove_all)
	
	PRINT, field_name
	
	MWRFITS , field , field_name , header_raw , /CREATE
ENDFOR

END
