FUNCTION remove_duplicates,file_raw

data = MRDFITS ( file_raw , 1 ,header)

no_matches = MAX(data.groupid)
keep = LONARR(no_matches)

sn = (data.u_best_flux/(data.u_best_ivar^(-0.5)))+(data.g3/(data.g3_ivar^(-0.5)))+(data.r3/(data.r3_ivar^(-0.5)))+(data.i3/(data.i3_ivar^(-0.5)))+(data.z3/(data.z3_ivar^(-0.5)))

FOR i=1L, no_matches DO BEGIN
	matches = WHERE ( data.groupid EQ i )
	best = MAX( 	sn[matches] , max_flux  )
	IF max_flux NE 1 THEN max_flux = max_flux[0]
	keep[i-1] = matches[max_flux]
ENDFOR

out = WHERE ( data.groupid LT 1)

out = [keep , out]

out_name = STRCOMPRESS(STRSPLIT( file_raw , '.mer' , /EXTRACT , /REGEX ) + '_' + 'noduplicates' + '.mer' ,/REMOVE_ALL)

MWRFITS,data[out],out_name,header,/CREATE

RETURN, out_name
END
