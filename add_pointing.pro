pro add_pointing

;find the files
in_files 	= file_search ( '/media/ben/dur-ext4/jun_run/coords/*'	)

out_files 	= file_search ( '/media/ben/dur-ext4/jun_run/pqso/*'	)

;count the files
nin		=	n_elements ( in_files  )
nout	=	n_elements ( out_files )

;check that they are the same in number
if nin ne nout then MESSAGE, 'FILE NUMBERS NOT EQUAL' 

;extract file names
in_name		=	strmid ( in_files  , 41 , 13 )
out_name	=	strmid ( out_files , 39 , 13 )

;match the file names to each other
match, in_name , out_name , sub_in , sub_out

;for each in get the pointing
for i=0, nin-1 do begin
	;read in matching files
	in_file  = in_files [sub_in [i]]
	out_file = out_files[sub_out[i]]

	;sort out headers
	MODFITS, in_file , 0, header_dummy_in
	MODFITS, out_file, 0, header_dummy_out
	
	;read in after fixed
	in  = mrdfits ( in_file  , 1 , header_in  )
	out = mrdfits ( out_file , 1 , header_out )
	;read the pointings
	ra_pointing  = fxpar ( header_in , 'RA' )
	dec_pointing = fxpar ( header_in , 'DEC')
	;write the pointings to the outfle
	fxaddpar, header_out, 'RA' , ra_pointing , 'RA POINTING OF FIELD'
    fxaddpar, header_out, 'DEC', dec_pointing, 'DEC POINTING OF FIELD'
    ;output files
    WRITEFITS, out_file, out , header_out
endfor
end
