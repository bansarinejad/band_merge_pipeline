pro s82_selection, file_raw

;### THIS CODE GENERATES A PRIORITY LIST OF CANDIDATES #################

;## PARAMETER CHECKS ###################################################
IF n_params() ne 1 THEN 				MESSAGE, 'twodf_selection : MISSING AN INPUT PARAMETER'
IF size(file_raw,/type) ne 7 THEN 		MESSAGE, 'twodf_selection : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = mrdfits(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_selection : RAW FILE CANNOT BE READ'
IF size(data[0].ra_1,/type) ne 5 THEN 	MESSAGE, 'twodf_selection : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec_1,/type) ne 5 THEN 	MESSAGE, 'twodf_selection : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat_raw = n_elements(data.(0))			;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d

;get the pointing
ra_deg  = 333.80422d
dec_deg = 0.23629488d

radec, ra_deg, dec_deg, ihr_c, imin_c, xsec_c, ideg_c, imn_c, xsc_c



;assign values to variables
;ihr_c	=	ra_split[0]
;imin_c	=	ra_split[1]
;xsec_c	=	ra_split[2]
;ideg_c	=	dec_split[0]
;imn_c	=	dec_split[1]
;xsc_c	=	dec_split[2]
;#######################################################################




ra_rad  = ra_deg  * deg2rad
dec_rad = dec_deg * deg2rad
;#######################################################################

;####### ADD TAGS TO THE STRUCTURE - REQUIRED FOR TRACEABILITY #########
;add the tags priority and comment THESE ARE IMPORTANT #################
tagnames = [ 'priority' , 'comment' ]
values   = [ '0'		, "'not target'"	   ]

add_tags, data,tagnames,values,new_data
data = new_data

;angular seperation formula (Haversin)
;angsep = acos(sin(dec_centre)*sin(data.dec)+cos(dec_centre)*cos(data.dec)*cos(ra_centre-data.ra))

;guidestars
stars = data

;### CHANGE CODE TO REMOVE FLAGS VIA data = data[subset] DEFINITIONS ###
;### CAN ONLY BE DONE TO UNIVERSAL LIMITS IE MAGNITUDE AND POINTSOURCE #
;###  PSTAR  ###
;set a PSTAR threshold
;###  MAG  ###
;set a MAG threshold
magb = 16. ; bright magnitude limit
magf = 22.5 ; faint magnitude limit
pstar = 0.51 ; arbitrary at this point
;star = where ( data.pstar ge pstar )
selection = where ( data.objc_type eq 6 AND data.g ge magb AND data.g le magf , count )
if ( count gt 0 ) then begin
;	data = data[star]
	data = data[selection]
	fxaddpar, header_raw, 'PSTAR', pstar , 'PSTAR THRESHOLD'
endif else begin
	print, 'Error: no sources above pstar threshold and within magnitude range'
endelse 

;###  MAG  ###
;set a MAG threshold
;magb = 16. ; bright magnitude limit
;magf = 22.5 ; faint magnitude limit
;mag = where ( data.g3 ge magb AND data.g3 le magf , count )
;if ( count gt 0 ) then begin
;	data = data[mag]
;endif else begin
;	print, 'Error: no point sources in magnitude range'
;endelse 

num_cat = n_elements(data.(0))
;#######################################################################
;colours defined here
umg	= data.U - data.G
gmr	= data.G - data.R
rmi	= data.R - data.I
imw	= data.i - data.w1
zmw = data.z - data.w1
gmi	= data.g - data.i
gmz = data.g - data.z
;############# WORKING WITH REDUCED DATA SET FROM HERE #################

;####### SETUP FLAGS FOR LATER USE
;flags created
;flag_angsep=replicate(0.,num_cat)
;flag_point_source=replicate(0.,num_cat)
;flag_mag=replicate(0.,num_cat)
flag_fiducial=replicate(0.,num_cat_raw)
;flag_point_source_r=replicate(0.,num_cat)

flag_ugg=replicate(0.,num_cat)
flag_gri=replicate(0.,num_cat)
flag_wise=replicate(0.,num_cat)
flag_no_wise=replicate(0.,num_cat)


flag_nine=replicate(0.,num_cat)
flag_eight=replicate(0.,num_cat)
flag_seven=replicate(0.,num_cat)
flag_six=replicate(0.,num_cat)
flag_five=replicate(0.,num_cat)
flag_four=replicate(0.,num_cat)
flag_three=replicate(0.,num_cat)
flag_two=replicate(0.,num_cat)
flag_one=replicate(0.,num_cat)
;####

;#### DEFINE VARIOUS COLOUR CUTS HERE ##################################

;VERY CONSERVATIVE COLOUR CUT - MAYBE MAKE LESS CONSERVATIVE - IF TIME
ugg = where(	(umg le 0.75 			AND $
		data.g lt 20.0					AND $
		data.g ge 18.0)				OR $
		(data.g ge ((umg*10.)+27.5)	AND $
		data.g ge 20.0					AND $
		data.g lt 20.5)				OR $
		(data.g ge ((umg*2.5)+22.5)	AND $
		data.g ge 20.5					AND $
		data.g lt 21.0)				OR $
		(data.g ge ((umg*1.)+21.5)		AND $
		data.g ge 21.0					AND $
		data.g lt 21.5)				,count)
if (ugg[0] gt 0.) then begin
	flag_ugg[ugg]=1	
endif else begin
	print, 'Error: no sources within ugg colour cut'
endelse 
;###


;VERY CONSERVATIVE COLOUR CUT - MAYBE MAKE LESS CONSERVATIVE - IF TIME
gri = where(	rmi ge ((gmr*(-1.))-0.4),count)
if (count gt 0) then begin
	flag_gri[gri]=1	
endif else begin
	print, 'Error: no sources within gri colour cut'
endelse 
;####

;WISE COLOUR CUT
wise = where(	imw ge (gmi+1.5)	 	AND $
				gmi le 0.6		 		AND $
				gmi ge -0.5				AND $
				imw le 7.0				AND $
				data.w1 ne 0.			,count)
if (count gt 0) then begin
	flag_wise[wise]=1	
endif else begin
	print, 'Error: no sources within wise colour cut'
endelse 
;####


;SOURCES WITH NO WISE DETECTION
no_wise = where(data.w1 lt 3 ,count)
if (count gt 0) then begin
	flag_no_wise[no_wise]=1	; 
endif else begin
	print, 'Error: all sources matched to wise
endelse 
;####

;#######################################################################


nine =	where(	stars.rz_zq eq 1 ,count)

if (count gt 0.) then begin

	flag_nine[nine]=9
	data.priority=flag_nine
	data[nine].comment='rz_zq eq 1'
	print, count, ' sources at priority nine'
endif else begin
	print, 'No sources at priority nine'
endelse 

seven =	where(	flag_wise	 			AND $
				flag_gri,count)
if (count gt 0.) then begin
	flag_seven[seven]=7
	data.priority+=flag_seven
	data[seven].comment='wise_colour & all pqso & pstar >' + string(pstar) +' & 16_g3_22.5 & gri'
	print, count, ' sources at priority seven'
endif else begin
	print, 'No sources at priority seven'
endelse 


five = where(	flag_no_wise			AND $
				(data.pqso ge 0.75 		OR data.PQSO0PT4TO2PT2 ge 0.75) 	AND $
				flag_gri				AND $
				~data.priority,count)
if (count gt 0.) then begin
	flag_five[five]=5
	data.priority+=flag_five
	data[five].comment='~wise_colour & pqso ge 0.75 & 16_g_22.5 & gri & ' + string(pstar)  
	print, count, ' sources at priority five'
endif else begin
	print, 'No sources at priority five'
endelse 

;six =	where(	flag_no_wise				AND $
;		data.pqso ge 0.1			AND $
;		data.pqso lt 0.3			AND $
;		data.g3 ge 21.0				AND $
;		flag_gri				AND $
;		~data.priority,count)
;if (six[0] gt 0.) then begin
;	flag_six[six]=6
;	data.priority+=flag_six
;	data[six].comment='~wise_colour & 0.1 le pqso lt 0.3 & 16_g_22.5 & gri'
;	print, total(six), 'sources at priority six'
;endif else begin
;	print, 'No sources at priority six'
;endelse

four =	where(	flag_no_wise				AND $
				(data.pqso ge 0.5			OR data.PQSO0PT4TO2PT2 ge 0.5) 	AND $
				(data.pqso lt 0.75 			OR data.PQSO0PT4TO2PT2 lt 0.75) 	AND $
				flag_gri				AND $
				~data.priority,count)
if (count gt 0.) then begin
	flag_four[four]=4
	data.priority+=flag_four
	data[four].comment='~wise_colour & 0.5 le pqso lt 0.75 & 16_g_22.5 & gri' + string(pstar) 
	print, count, ' sources at priority four'	
endif else begin
	print, 'No sources at priority four'
endelse 

three =	where(	flag_no_wise				AND $
				(data.pqso ge 0.3			OR data.PQSO0PT4TO2PT2 ge 0.3) 	AND $
				(data.pqso lt 0.5 			OR data.PQSO0PT4TO2PT2 lt 0.5) 	AND $		
				~data.priority,count)
if (count gt 0.) then begin
		flag_three[three]=3
		data.priority+=flag_three
		data[three].comment='~wise_colour & 0.3 le pqso lt 0.5 & 16_g_22.5 & gri' + string(pstar)
		print, count, ' sources at priority three'	
endif else begin
		print, 'No sources at priority three'
endelse 

two = where(	flag_no_wise				AND $
				(data.pqso ge 0.1			OR data.PQSO0PT4TO2PT2 ge 0.1) 	AND $
				(data.pqso lt 0.3 			OR data.PQSO0PT4TO2PT2 lt 0.3) 	AND $
				flag_gri					AND $
				data.priority eq 0,count)
if (count gt 0.) then begin
	flag_two[two]=2
	data.priority+=flag_two
	data[two].comment='~wise_colour & 0.1 le pqso lt 0.3 & 16_g_22.5 & gri' + string(pstar)
	print, count, ' sources at priority two'
endif else begin
	print, 'No sources at priority two'
endelse 

;two =	where(data.g3_class eq 3.1415926535,count)
;if (two[0] gt 0.) then begin
;	flag_two[two]=2
;	data.priority+=flag_two
;	print, total(two), 'sources at priority two'
;endif else begin
;	print, 'No sources at priority two'
;endelse

;one =	where(data.g3_class eq 3.1415926535,count)
;if (one[0] gt 0.) then begin
;	flag_one[one]=1
;	data.priority+=flag_one
;	print, total(one), 'sources at priority one'
;endif else begin
;	print, 'No sources at priority one'
;endelse

target = data[ where (data.priority gt 0.01)]

;#### OUTPUT DATA ######################################################

strreplace, file_raw,'.mer', '_targets.fits'

MWRFITS,data,file_raw,/create ;out everything i.e. targets and not targets

;#######################################################################
;#######################################################################

;####### SELECT THE GUIDESTARS FOR THE FIELD ###########################
;**guidestars*************
guide =	where(	stars.g ge 13.5		AND $
				stars.g le 14.0		AND $
				stars.objc_type eq 6,count)
if (count gt 0.) then begin
	flag_fiducial[guide]=1.
	guide_s = stars[guide]
endif else begin
	print, 'No fiducial targets'
endelse
	
strreplace, file_raw,'targets', 'guidestars'
MWRFITS,guide_s,file_raw,/create
;#######################################################################

;######## SELECT THE SKY FIBRES ########################################
;create randoms over the 2df field, as a square
n_rand			= 3000
ra_sky_rand		= randomu ( 150 , n_rand ) 
dec_sky_rand	= randomu ( 151 , n_rand )
ra_sky 			= ra_sky_rand  * 1.05 * 2. + min ( stars.ra_1  )
dec_sky 		= dec_sky_rand * 1.05 * 2. + min ( stars.dec_1 )

;create array of pointing - in degrees
ra_centre  = replicate ( ra_deg  , n_rand )
dec_centre = replicate ( dec_deg , n_rand )

;reduce list to fibre posns within 2df
gcirc , 2 , ra_centre , dec_centre , ra_sky , dec_sky , sep
sep = sep/3600.

ra_within_2df	= ra_sky [where( sep le 1.05 , count)]
dec_within_2df	= dec_sky[where( sep le 1.05		)]

;create struct to store randoms
sky = {ra_rand:0.0,dec_rand:0.0}
sky = replicate( sky[0] , count )

sky.ra_rand  = ra_within_2df
sky.dec_rand = dec_within_2df

;convert randoms to sexegesimal
radec, sky.ra_rand, sky.dec_rand, ihr_s, imin_s, xsec_s, ideg_s, imn_s, xsc_s

z = where(imn_s lt 0.)
ideg_s = float(ideg_s)
ideg_s[z] = ideg_s[z]*(-1.)
imn_s[z] = imn_s[z]*(-1.)

zz = where(xsc_s lt 0)
ideg_s[zz] = ideg_s[zz]*(-1.)
xsc_s[zz] = xsc_s[zz]*(-1.)

ideg_s = string(ideg_s,format='(F+04.0)')

;output randoms to file
strreplace, file_raw,'guidestars', 'randoms'
MWRFITS,sky,file_raw,/create
;#######################################################################

;**********
;**sexegesimal coords
radec, target.ra_1, target.dec_1, ihr, imin, xsec, ideg, imn, xsc
radec, guide_s.ra_1, guide_s.dec_1, ihr_g, imin_g, xsec_g, ideg_g, imn_g, xsc_g

x = where(imn lt 0.)
ideg = float(ideg)
ideg[x] = ideg[x]*(-1.)
imn[x] = imn[x]*(-1.)

y = where(imn_g lt 0)
ideg_g = float(ideg_g)
ideg_g[y] = ideg_g[y]*(-1.)
imn_g[y] = imn_g[y]*(-1.)

xx = where(xsc lt 0.)
ideg[xx] = ideg[xx]*(-1.)
xsc[xx] = xsc[xx]*(-1.)

yy = where(xsc_g lt 0)
ideg_g[yy] = ideg_g[yy]*(-1.)
xsc_g[yy] = xsc_g[yy]*(-1.)

ideg = string(ideg,format='(F+04.0)')
ideg_g = string(ideg_g,format='(F+04.0)')
stop
;#######################################################################
; CREATE THE FLD FILE ##################################################
;#######################################################################

;target_number 	= strtrim(indgen(n_elements(target)), 2)
;star_number 	= strtrim(indgen(n_elements(guide)),2)

;create output file
strreplace, file_raw,'randoms',''
strreplace, file_raw,'.fits', '.fld'

;open the file
openw, lun, file_raw, /get_lun

;output the header
printf,lun,'*'
printf,lun,'LABEL  2dF field ' + file_raw

;please change this or you look stupid
date_obs = '2013 06 13'
printf,lun,'UTDATE ' + date_obs
 
printf,lun,'CENTRE', ihr_c, imin_c, xsec_c, ideg_c, imn_c, xsc_c, format='(A,TR1,I3,TR1,I3,TR1,F5.2,TR1,I3.2,TR1,I3,TR1,F5.2,TR1)'
printf,lun,'EQUINOX J2000.0'
printf,lun,'* End of header info'
printf,lun,'* Start of input data'
printf,lun,'* TargetName(unique for header) RA(h m s) Dec(d m s) TargetType(Program,Fiducial,Sky) Priority(9 is highest) Magnitude 0 TargetName'

target_priority = target.priority
target_magnitude = target.g
guidestar_magnitude = guide_s.g





;######

for i=0, n_elements(target.(0))-1 do begin
printf,lun,target[i].ATLAS_ID,$
	ihr[i],$
	imin[i],$
	xsec[i],$
	ideg[i],$
	imn[i],$
	xsc[i],$
	strtrim('P',2),$
	strtrim(target_priority[i],2),$
	target_magnitude[i],$
	strtrim('0',2),$
	strtrim('Program',2), $
;		format='(A,TR1,I2,TR1,I3,TR1,F5.2,TR1,F03.0,TR1,I2.2,TR1,F5.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
		format='(A,TR1,I2,TR1,I3,TR1,F5.2,TR1,A3,TR1,I2.2,TR1,F05.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
endfor
for i=0, n_elements(guide_s)-1 do begin
printf,lun,guide_s[i].ATLAS_ID,$
	ihr_g[i],$
	imin_g[i],$
	xsec_g[i],$
	ideg_g[i],$
	imn_g[i],$
	xsc_g[i],$
	strtrim('F',2),$
	strtrim('9',2),$
	guidestar_magnitude[i],$
	strtrim('0',2),$
	strtrim('Guide',2), $
;		format='(A,TR1,I2,TR1,I3,TR1,F5.2,TR1,F03.0,TR1,I2.2,TR1,F5.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
			format='(A,TR1,I2,TR1,I3,TR1,F5.2,TR1,A3,TR1,I2.2,TR1,F05.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
endfor 

for i=0, 299 do begin
printf,lun,strcompress('S' + date_obs + string(i,'(I03)') + string(ihr_c,'(I03)') + string(imin_c,'(I02)') + string(xsec_c,'(F04.1)') + string(ideg_c,'(I03)') + string(imn_c,'(I02)') + string(xsc_c,'(F04.1)'),/remove_all),$
	ihr_s[i],$
	imin_s[i],$
	xsec_s[i],$
	ideg_s[i],$
	imn_s[i],$
	xsc_s[i],$
	strtrim('S',2),$
	strtrim('9',2),$
	strtrim('20.00',2),$
	strtrim('0',2),$
	strtrim('Sky',2), $
;		format='(A,TR1,I3,TR1,I2,TR1,F5.2,TR1,F03.0,TR1,I2,TR1,F5.2,TR1,A,TR1,A,TR1,A,TR1,A,TR1,A,TR1)'
			format='(A,TR1,I3,TR1,I2,TR1,F5.2,TR1,A3,TR1,I2,TR1,F05.2,TR1,A,TR1,A,TR1,A,TR1,A,TR1,A,TR1)'
endfor 

Free_lun, lun
end

















end
