pro guide_check

for g=0,7 do begin
	file_1=strcompress('/home/ben/Documents/2qdes/feb_run/2df-fields/03h41m..04h01m..-25d36m..-30d33m_str_2df_'+string(g+1)+'.mer',/remove)
	data=mrdfits(file_1,1)

	IF (tag_exist(data,'ra')) THEN BEGIN
		num_cat=n_elements(data.RA)
	ENDIF
	IF (tag_exist(data,'ra_1')) THEN BEGIN
		num_cat=n_elements(data.RA_1)
	ENDIF
	;determine number of objects within the data

	flag_fiducial=replicate(0.,num_cat)
	;create fiducial flag

	guide =	where(	data.g3 ge 13.5		AND $
					data.g3 le 14.0		AND $
					data.g3_class eq -1,count)
	if (count gt 0) then begin
		flag_fiducial[guide]=1
	endif else begin
		print, 'No fiducial targets'
	endelse


	;pointing
	ra_c=median(data.ra,/double)*180.0d0/!dpi
	dec_c=median(data.dec,/double)*180.0d0/!dpi
	ra_i=fix(ra_c)
	dec_i=fix(dec_c)
	pointing=strtrim(string(ra_i,dec_i),2)
	;sexegesimal
	radec, data[guide].ra*180.0d0/!dpi, data[guide].dec*180.0d0/!dpi, ihr_g, imin_g, xsec_g, ideg_g, imn_g, xsc_g



	guide_path='/home/ben/Documents/2qdes/feb_run/2df-guidestars/'
	file_guide = strcompress(guide_path+pointing+'.txt',/remove)

	 openw, lun, file_guide, /get_lun

	for i=0, n_elements(guide)-1 do begin
	printf,lun,strcompress('Star_'+pointing+'_'+string(i)+'_',/remove),$
		ihr_g[i],$
		imin_g[i],$
		xsec_g[i],$
		ideg_g[i],$
		imn_g[i],$
		xsc_g[i],$
		'5',$
		'5',$
		format='(A,TR1,I3,TR1,I2,TR1,F5.2,I4,TR1,I2,TR1,F5.2,TR1,A,TR1,A,TR1)'
	endfor 

	free_lun,lun
endfor



end
