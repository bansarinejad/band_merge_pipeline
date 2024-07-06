pro guide_ps

list=file_search('/home/ben/Documents/2qdes/feb_run/2df-guidestars/','*.fits')
name=fltarr(n_elements(list))
name=repstr(list,'.fits','.ps')
pson,filename=name[0]
loadct,11 ;blue
stop
for i=0,n_elements(list)-1 do begin
	
		fits_read,list[i],image,header
		tv,image;,true=1
		erase
;wait,1
endfor
psoff
print, 'PS conversion completed'



end
