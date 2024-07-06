pro s82_radec, file_raw

;### THIS CODE GENERATES A LIST OF SOURCE NAMES ########################
;### THIS WILL PREVENT CONFUSION BETWEEN COORD CONVERSION ##############


;## PARAMETER CHECKS ###################################################
IF n_params() ne 1 THEN 				MESSAGE, 'twodf_radec : MISSING AN INPUT PARAMETER'
IF size(file_raw,/type) ne 7 THEN 		MESSAGE, 'twodf_radec : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = mrdfits(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_radec : RAW FILE CANNOT BE READ'
IF size(data[0].ra_1,/type) ne 5 THEN 	MESSAGE, 'twodf_radec : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec_1,/type) ne 5 THEN 	MESSAGE, 'twodf_radec : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat = n_elements(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d
;#######################################################################di

;#### CREATE A STRUCTURE TO HOLD THE NEW COORDS ########################
new_struct = create_struct('ATLAS_ID','','RA_SEXE','','DEC_SEXE','','TILE','')
new_struct = replicate(new_struct[0],num_cat)

;fill the degrees columns
new_struct.TILE = file_raw

;fill the sexegesimal columns ****GOES FROM THE DEGREES****
radec, data.RA_1 , data.DEC_1 , hh_r , mm_r , ss_r , dd_d , mm_d , ss_d

x = where(mm_d lt 0.)
dd_d = float(dd_d)
dd_d[x] = dd_d[x]*(-1.)
mm_d[x] = mm_d[x]*(-1.)

xx = where(ss_d lt 0.)
dd_d[xx] = dd_d[xx]*(-1.)
ss_d[xx] = ss_d[xx]*(-1.)


dd_d = string(dd_d,format='(F+04.0)')

;#######################################################################

new_struct.RA_SEXE  = strcompress( string(hh_r,'(I+03)') + ':' + string(mm_r,'(I02)') + ':' + string(ss_r,'(D)') , /remove_all )
new_struct.DEC_SEXE = strcompress( string(dd_d,'(A3)') + ':' + string(mm_d,'(I02)') + ':' + string(ss_d,'(D)') , /remove_all )

;make at ATLAS ID - SEE IAU format HHMMSS.ss+DDMMSS.s http://cdsweb.u-strasbg.fr/Dic/iau-spec.html
atlas = replicate('S82_J',num_cat)
new_struct.ATLAS_ID = strcompress( atlas + string(hh_r,'(I2.2)') + ':' + string(mm_r,'(I2.2)') + ':' $
					+ string(ss_r,'(D05.2)') + string(dd_d,'(A3)') + ':' + string(mm_d,'(I02)') + ':' + $
					  string(ss_d,'(D04.1)'), /remove_all )


;## OUTPUT THE DATA ####################################################
;combine the two structures
combine_structs , new_struct , data , outstruct
;make a new filename
strreplace, file_raw, 'fields' , 'coords'
out_name = strcompress(strsplit( file_raw , '.mer' , /extract , /regex ) + '_' + 'coords' + '.mer' ,/remove_all)

MWRFITS , outstruct , out_name , header_raw , /create ;overwrite previous files
end

