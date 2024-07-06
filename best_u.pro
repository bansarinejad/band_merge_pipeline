;#### ADDED TO REMOVE CLASS -6 AND -7 U BAND DETECTIONS ################
;#### REQUEST OF JOE F
;#### MANUALLY CHECKED BY BTC IN TOPCAT ON o20120530_00196
;made as seperate code on Wed 26 Jun 2013 12:11:34 BST 

FUNCTION best_u, file_raw, null_flux = NULL_FLUX , null_ivar = NULL_IVAR

;read in file, standard checks not used, write a programme to do so?
data 	= MRDFITS ( file_raw , 1 , header )
num_cat = N_ELEMENTS ( data.(0) )

;check input values to see if different null values
IF N_ELEMENTS(null_flux) EQ 0 THEN null_flux  = 1e-10
IF N_ELEMENTS(null_ivar) EQ 0 THEN null_ivar  = 1e-11



;create stucture to hold best fluxes and ivars
flux = {u_best_flux:null_flux,u_best_ivar:null_ivar}
flux = REPLICATE(flux[0],num_cat)

;flags to make subsetting easier
flag_one_u  = INTARR(num_cat)
flag_two_u  = INTARR(num_cat)
flag_both_u = INTARR(num_cat)

; check the quality of u band detections
x = WHERE ( data.u3_1_class NE -6 AND data.u3_1_class NE -7 AND data.u3_2_class NE -6 AND data.u3_2_class NE -7 , count )
IF count GT 0 THEN flag_both_u[x]=1

y = WHERE ( data.u3_1_class NE -6 AND data.u3_1_class NE -7 AND ~flag_both_u , count )
IF count GT 0 THEN flag_one_u[y]=1

z = WHERE ( data.u3_2_class NE -6 AND data.u3_2_class NE -7 AND ~flag_both_u AND ~flag_one_u , count )
IF count GT 0 THEN flag_two_u[z]=1
;###########


; take the good fluxes
flux[WHERE(flag_both_u)].u_best_flux  = data[WHERE(flag_both_u)].u3_flux
flux[WHERE(flag_one_u) ].u_best_flux = data[WHERE(flag_one_u) ].u3_1_flux
flux[WHERE(flag_two_u) ].u_best_flux  = data[WHERE(flag_two_u) ].u3_2_flux
;############

;take the good errors
flux[WHERE(flag_both_u)].u_best_ivar  = data[WHERE(flag_both_u)].u3_ivar
flux[WHERE(flag_one_u) ].u_best_ivar  = data[WHERE(flag_one_u) ].u3_1_ivar
flux[WHERE(flag_two_u) ].u_best_ivar  = data[WHERE(flag_two_u) ].u3_2_ivar
;#######################################################################

;output stuff
combine_structs, data,flux, outstruct
out_name = strcompress(strsplit( file_raw , '.mer' , /extract , /regex ) + '_best' +'.mer' ,/remove_all)

MWRFITS , outstruct , out_name , header , /CREATE ;overwrite previous files (if any)

RETURN, out_name

END
