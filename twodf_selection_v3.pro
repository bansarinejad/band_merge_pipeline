PRO twodf_selection_v3, file_raw , ra_str , dec_str , PSTAR = pstar , CLASS = class , CENTRE = centre 

;### THIS CODE GENERATES A PRIORITY LIST OF CANDIDATES #################

;## PARAMETER CHECKS ###################################################
IF N_PARAMS() ne 3 THEN 			MESSAGE, 'twodf_selection : MISSING AN INPUT PARAMETER'
IF size(file_raw,/TYPE) ne 7 THEN 		MESSAGE, 'twodf_selection : FILE_RAW IS NOT A STRING'
;#######################################################################

; ## READ IN THE RAW FILE ##############################################
data = MRDFITS(file_raw , 1 , header_raw , status = read_in_status)
IF read_in_status ne 0 THEN 			MESSAGE, 'twodf_selection : RAW FILE CANNOT BE READ'
IF size(data[0].ra,/TYPE) ne 5 THEN 		MESSAGE, 'twodf_selection : WARNING - RA IS NOT A DOUBLE'
IF size(data[0].dec,/TYPE) ne 5 THEN 		MESSAGE, 'twodf_selection : WARNING - DEC IS NOT A DOUBLE'
;#######################################################################

;#### SETUP SOME TOP-LEVEL VARIABLES & FLAGS ########################### 
num_cat_raw = n_elements(data.(0))		;number of rows read from the fits file , surprisingly useful 
rad2deg = 180.0d/!dpi
deg2rad = !dpi/180.0d

;######### HACK THE PROBLEM ############################################
IF KEYWORD_SET(CENTRE) THEN BEGIN
	;extract the components of the pointings
	ra_split  = STRSPLIT(ra_str ,':',/EXTRACT)
	dec_split = STRSPLIT(dec_str,':',/EXTRACT)

	;assign values to variables
	ihr_c	=	ra_split[0]
	imin_c	=	ra_split[1]
	xsec_c	=	ra_split[2]
	ideg_c	=	dec_split[0]
	imn_c	=	dec_split[1]
	xsc_c	=	dec_split[2]
ENDIF
;#######################################################################


ra_deg  = tenv(ra_str )*15.0d
dec_deg = tenv(dec_str)

ra_rad  = ra_deg  * deg2rad
dec_rad = dec_deg * deg2rad
;#######################################################################

;####### ADD TAGS TO THE STRUCTURE - REQUIRED FOR TRACEABILITY #########
;add the tags priority and comment THESE ARE IMPORTANT #################
tagnames = [ 'priority' , 'comment' ,'flag_ugg','flag_gri','flag_wise','flag_wise_two','flag_no_wise','flag_nine','flag_eight','flag_seven','flag_six','flag_five','flag_four','flag_three','flag_two','flag_one']
values   = [ '0'	, "'not target'",'0','0','0','0','0','0','0','0','0','0','0','0','0','0' ]


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

IF KEYWORD_SET(PSTAR) THEN BEGIN
	pstar = 0.6 ; arbitrary at this point
	not_selec = WHERE ( data.pstar LT pstar OR  data.g3 LT magb OR  data.g3 GT magf , count )
	selection = WHERE ( data.pstar GE pstar AND data.g3 GE magb AND data.g3 LE magf , count )
	IF ( count GT 0 ) THEN BEGIN
		invalid = data[not_selec]
		data = data[selection]
		fxaddpar, header_raw, 'PSTAR', pstar , 'PSTAR THRESHOLD'
	ENDIF ELSE BEGIN
		PRINT, 'Error: no sources above pstar threshold and within magnitude range'
	ENDELSE 
ENDIF

IF KEYWORD_SET(CLASS) THEN BEGIN
	pstar = '-1 g/r'
	not_selec = WHERE ( (data.g3_class ne -1 OR data.r3_class ne -1) OR  data.g3 LT magb OR  data.g3 GT magf , count )
	selection = WHERE ( (data.g3_class eq -1 OR data.r3_class eq -1) AND data.g3 GE magb AND data.g3 LE magf , count )
	IF ( count GT 0 ) THEN BEGIN
		invalid = data[not_selec]
		data = data[selection]
		fxaddpar, header_raw, 'G or R Class', -1 , 'Morphology selection'
	ENDIF ELSE BEGIN
		PRINT, 'Error: no sources with allowed morphology and within magnitude range'
	ENDELSE 
ENDIF


num_cat = N_ELEMENTS(data.(0))
;#######################################################################
;colours defined here
umg	= data.U3 - data.G3
gmr	= data.G3 - data.R3
rmi	= data.R3 - data.I3
imw	= data.i3 - data.w1
zmw 	= data.z3 - data.w1
gmi	= data.g3 - data.i3
gmz 	= data.g3 - data.z3
w1w2	= data.w1 - data.w2
;############# WORKING WITH REDUCED DATA SET FROM HERE #################

;####### SETUP FLAGS FOR LATER USE #####################################
;flags created
flag_fiducial	=	replicate(0.,num_cat_raw)

flag_ugg	=	replicate(0.,num_cat)
flag_gri	=	replicate(0.,num_cat)
flag_wise	=	replicate(0.,num_cat)
flag_wise_two	=	replicate(0.,num_cat)
flag_no_wise	=	replicate(0.,num_cat)

flag_nine	=	replicate(0.,num_cat)
flag_eight	=	replicate(0.,num_cat)
flag_seven	=	replicate(0.,num_cat)
flag_six	=	replicate(0.,num_cat)
flag_five	=	replicate(0.,num_cat)
flag_four	=	replicate(0.,num_cat)
flag_three	=	replicate(0.,num_cat)
flag_two	=	replicate(0.,num_cat)
flag_one	=	replicate(0.,num_cat)
;#######################################################################

;#### DEFINE VARIOUS COLOUR CUTS HERE ##################################

;VERY CONSERVATIVE COLOUR CUT - MAYBE MAKE LESS CONSERVATIVE - IF TIME
ugg = WHERE(	(data.g3 GT 0 AND data.u3 GT 0)			AND $
		(umg LE 0.75 					AND $
		data.g3 LT 20.0					AND $
		data.g3 GE 18.0					AND $
		umg GT -3.0)					OR $
		(data.g3 LT ((umg*(-10.))+27.5)			AND $
		data.g3 GE 20.0					AND $
		data.g3 LT 20.5					AND $
		umg GT -3.0)					OR $
		(data.g3 LT ((umg*(-2.5))+22.5)			AND $
		data.g3 GE 20.5					AND $
		data.g3 LT 21.0					AND $
		umg GT -3.0)					OR $
		(data.g3 LT ((umg*(-1.))+21.5)			AND $
		data.g3 GE 21.0					AND $
		data.g3 LT 21.5					AND $
		umg GT -3.0)				,count)
IF (count GT 0.) THEN BEGIN
			data[ugg].flag_ugg = 1
			flag_ugg[ugg]	= 1	
ENDIF ELSE BEGIN
	PRINT, 'Error: no sources within ugg colour cut'
ENDELSE 
;###


;VERY CONSERVATIVE COLOUR CUT - MAYBE MAKE LESS CONSERVATIVE - IF TIME
gri = WHERE(		rmi GE ((gmr*(-1.))-0.4),count)
IF (count GT 0) THEN BEGIN
			flag_gri[gri]=1
			data[gri].flag_gri = 1	
ENDIF ELSE BEGIN
	PRINT, 'Error: no sources within gri colour cut'
ENDELSE 
;####

;WISE COLOUR CUT
wise = WHERE(		imw GE gmi + 1.5	 	AND $ ;+1.5 -> 0 intercept
			gmi LE 1.3		 	AND $
			gmi GE -1.			AND $
			imw LE 8.0			AND $
			data.w1 ne 0.			,count)
IF (count GT 0) THEN BEGIN
			data[wise].flag_wise = 1
			flag_wise[wise]	= 1	
ENDIF ELSE BEGIN
	PRINT, 'Error: no sources within wise colour cut'
ENDELSE 
;####

;####

;### NEW WISE COLOUR CUT
wise_two = WHERE( 					$	
		(data.g3 GT 1 AND data.w1 GT 5. AND data.w2 GT 5.)		AND $
		(w1w2 GE 0.4 				AND $
		data.g3 LT 19.5				AND $
		data.g3 GE 16.0				AND $
		w1w2 LT 10.0)				OR $
		(w1w2 GT ((data.g3*(-0.4))+8.2)		AND $
		data.g3 GE 19.5				AND $
		data.g3 LT 22.5				AND $
		w1w2 LT 10.0)				,count)
IF (count GT 0) THEN BEGIN
			data[wise_two].flag_wise_two = 1
			flag_wise_two[wise_two]	= 1	
ENDIF ELSE BEGIN
	PRINT, 'Error: no sources within wise colour cut'
ENDELSE 
;####


;SOURCES WITH NO WISE DETECTION
no_wise = WHERE(	data.w1 LT 3 ,count)
IF (count GT 0) THEN BEGIN
			flag_no_wise[no_wise]		= 1 
			data[no_wise].flag_no_wise 	= 1
ENDIF ELSE BEGIN
	PRINT, 'Error: all sources matched to wise
ENDELSE 
;####

;#######################################################################


nine =	WHERE(		flag_wise	 		AND $
			flag_wise_two	 		AND $
			data.pstar GT 0			AND $
			flag_gri,count)
IF (count GT 0.) THEN BEGIN
			data[nine].flag_nine 	= 1
			flag_nine[nine]		= 9
			data.priority		= flag_nine
			data[nine].comment	= 'wise_colour & all pqso & pstar >' + string(pstar) +' & 16_g3_22.5 & gri'
			PRINT, count, ' sources at priority nine'
ENDIF ELSE BEGIN
	PRINT, 'No sources at priority nine'
ENDELSE 


;eight =	WHERE(data.g3_class eq 3.1415926535,count)
;IF (eight[0] GT 0.) THEN BEGIN
;	flag_eight[eight]=2
;	data.priority+=flag_eight
;	PRINT, total(eight), 'sources at priority eight'
;ENDIF ELSE BEGIN
;	PRINT, 'No sources at priority eight'
;ENDELSE

seven = WHERE(		flag_no_wise			AND $
			data.pqso_allz GE 0.75 		AND $
			flag_gri			AND $
			~data.priority			,count)
IF (count GT 0.) THEN BEGIN
			data[seven].flag_seven 	= 1
			flag_seven[seven]	= 7
			data.priority		+= flag_seven
			data[seven].comment	= '~wise_colour & pqso GE 0.75 & 16_g_22.5 & gri & ' + string(pstar)  
			PRINT, count, ' sources at priority seven'
ENDIF ELSE BEGIN
	PRINT, 'No sources at priority seven'
ENDELSE 

;six =	WHERE(	flag_no_wise				AND $
;		data.pqso_allz GE 0.1			AND $
;		data.pqso_allz LT 0.3			AND $
;		data.g3 GE 21.0				AND $
;		flag_gri				AND $
;		~data.priority,count)
;IF (six[0] GT 0.) THEN BEGIN
;	flag_six[six]=6
;	data.priority+=flag_six
;	data[six].comment='~wise_colour & 0.1 LE pqso LT 0.3 & 16_g_22.5 & gri'
;	PRINT, total(six), 'sources at priority six'
;ENDIF ELSE BEGIN
;	PRINT, 'No sources at priority six'
;ENDELSE

five =	WHERE(		(flag_no_wise			AND $
			data.pqso_allz GE 0.5		AND $
			data.pqso_allz LT 0.75 		AND $
			flag_gri)			OR $
			(flag_no_wise			AND $
			flag_ugg			AND $
			data.pqso_allz GT 0.1		AND $
			flag_gri)			AND $
			~data.priority,count)
IF (count GT 0.) THEN BEGIN
			flag_five[five]		= 5
			data[five].flag_five 	= 1
			data.priority		+= flag_five
			data[five].comment	= '~wise_colour & 0.5 LE pqso LT 0.75 & 16_g_22.5 & gri' + string(pstar) 
			PRINT, count, ' sources at priority five'	
ENDIF ELSE BEGIN
	PRINT, 'No sources at priority five'
ENDELSE 

four =	WHERE(		flag_no_wise			AND $
			data.pqso_allz GE 0.3		AND $
			data.pqso_allz LT 0.5 		AND $
			flag_gri			AND $	
			~data.priority,count)
IF (count GT 0.) THEN BEGIN
			flag_four[four]		= 4
			data[four].flag_four 	= 1
			data.priority		+= flag_four
			data[four].comment	= '~wise_colour & 0.3 LE pqso LT 0.5 & 16_g_22.5 & gri' + string(pstar)
			PRINT, count, ' sources at priority four'	
ENDIF ELSE BEGIN
		PRINT, 'No sources at priority four'
ENDELSE 

three = WHERE(		flag_no_wise			AND $
			data.pqso_allz GE 0.1		AND $
			data.pqso_allz LT 0.3 		AND $
			flag_gri			AND $
			data.priority eq 0,count)
IF (count GT 0.) THEN BEGIN
			data[three].flag_three 	= 1
			flag_three[three]	= 3
			data.priority		+= flag_three
			data[three].comment	= '~wise_colour & 0.1 LE pqso LT 0.3 & 16_g_22.5 & gri' + string(pstar)
			PRINT, count, ' sources at priority three'
ENDIF ELSE BEGIN
	PRINT, 'No sources at priority three'
ENDELSE 

;two =	WHERE(data.g3_class eq 3.1415926535,count)
;IF (two[0] GT 0.) THEN BEGIN
;	flag_two[two]=2
;	data.priority+=flag_two
;	PRINT, total(two), 'sources at priority two'
;ENDIF ELSE BEGIN
;	PRINT, 'No sources at priority two'
;ENDELSE

;one =	WHERE(data.g3_class eq 3.1415926535,count)
;IF (one[0] GT 0.) THEN BEGIN
;	flag_one[one]=1
;	data.priority+=flag_one
;	PRINT, total(one), 'sources at priority one'
;ENDIF ELSE BEGIN
;	PRINT, 'No sources at priority one'
;ENDELSE

target = data[ WHERE (data.priority GT 0)]

;#### OUTPUT DATA ######################################################
file_target = file_raw
strreplace, file_target,'.mer', '_targets_v3.fits'
strreplace, file_target,'pqso/','target/'

MWRFITS,[data,invalid],file_target,/CREATE ;out everything i.e. targets and not targets

;#######################################################################
;#######################################################################

;####### SELECT THE GUIDESTARS FOR THE FIELD ###########################
;**guidestars*************
guide =	WHERE(	stars.g3 GE 13.5		AND $
				stars.g3 LE 14.0		AND $
				stars.g3_class eq -1,count)
IF (count GT 0.) THEN BEGIN
	flag_fiducial[guide]=1.
	guide_s = stars[guide]
ENDIF ELSE BEGIN
	PRINT, 'No fiducial targets'
ENDELSE
	
;file_guide = file_raw
;strreplace, file_guide,'pqso/', 'guidestars/'
;strreplace, file_raw,'.mer', '_guidestars.fits'

;MWRFITS,guide_s,file_guide,/CREATE
;#######################################################################

;######## SELECT THE SKY FIBRES ########################################
;create randoms over the 2df field, as a square
n_rand			= 3000
ra_sky_rand		= randomu ( 150 , n_rand ) 
dec_sky_rand		= randomu ( 151 , n_rand )
ra_sky 			= ra_sky_rand  * 1.05 * 2. + min ( stars.ra_deg  )
dec_sky 		= dec_sky_rand * 1.05 * 2. + min ( stars.dec_deg )

;create array of pointing - in degrees
ra_centre  = REPLICATE ( ra_deg  , n_rand )
dec_centre = REPLICATE ( dec_deg , n_rand )

;reduce list to fibre posns within 2df
gcirc , 2 , ra_centre , dec_centre , ra_sky , dec_sky , sep
sep = sep/3600.

ra_within_2df	= ra_sky [WHERE( sep LE 1.05 , 	   count)]
dec_within_2df	= dec_sky[WHERE( sep LE 1.05		)]

;create struct to store randoms
sky = {ra_rand:0.0,dec_rand:0.0}
sky = REPLICATE( sky[0] , count )

sky.ra_rand  = ra_within_2df
sky.dec_rand = dec_within_2df

;convert randoms to sexegesimal
radec, sky.ra_rand, sky.dec_rand, ihr_s, imin_s, xsec_s, ideg_s, imn_s, xsc_s

;output randoms to file
;STRREPLACE, file_raw,'guidestars', 'randoms'
;MWRFITS,sky,file_raw,/CREATE
;#######################################################################

;**********
;**sexegesimal coords
;radec, data[target].ra*180.0d0/!dpi, data[target].dec*180.0d0/!dpi, ihr, imin, xsec, ideg, imn, xsc
;radec, data[guide].ra*180.0d0/!dpi, data[guide].dec*180.0d0/!dpi, ihr_g, imin_g, xsec_g, ideg_g, imn_g, xsc_g


;#######################################################################
; CREATE THE FLD FILE ##################################################
;#######################################################################

;target_number 	= strtrim(indgen(n_elements(target)), 2)
;star_number 	= strtrim(indgen(n_elements(guide)),2)

;create output file
file_fld = file_raw
STRREPLACE, file_fld,'pqso/','fld/'
STRREPLACE, file_fld,'.mer', '_v3.fld'

;open the file
OPENW, LUN, file_fld, /GET_LUN

;output the header
PRINTF, LUN,'*'
PRINTF, LUN,'LABEL  2dF field ' + file_raw

;please change this or you look stupid
date_obs = '2013 07 28'
PRINTF, LUN,'UTDATE ' + date_obs
 
PRINTF, LUN,'CENTRE', ihr_c, imin_c, xsec_c, ideg_c, imn_c, xsc_c, format='(A,TR1,I3,TR1,I3,TR1,F5.2,TR1,I3.2,TR1,I3,TR1,F5.2,TR1)'
PRINTF, LUN,'EQUINOX J2000.0'
PRINTF, LUN,'* END of header info'
PRINTF, LUN,'* Start of input data'
PRINTF, LUN,'* TargetName(unique for header) RA(h m s) Dec(d m s) TargetType(Program,Fiducial,Sky) Priority(9 is highest) Magnitude 0 TargetName'

target_priority = target.priority
target_magnitude = target.g3
guidestar_magnitude = guide_s.g3

;get sexegesiaml

ra_sex_split     = strarr(n_elements(target.ra_sex)  ,3) 
dec_sex_split    = strarr(n_elements(target.dec_sex) ,3) 
ra_sex_split_gs  = strarr(n_elements(guide_s.ra_sex) ,3) 
dec_sex_split_gs = strarr(n_elements(guide_s.dec_sex),3) 

for h=0,n_elements(target.ra_sex)-1 do begin
	ra_sex_split[h,*] =  STRSPLIT(target[h].ra_sex  ,':',/EXTRACT)
	dec_sex_split[h,*] = STRSPLIT(target[h].dec_sex ,':',/EXTRACT)
endfor

for h=0,n_elements(guide_s.ra_sex)-1 do begin
	ra_sex_split_gs[h,*] =  STRSPLIT(guide_s[h].ra_sex  ,':',/EXTRACT)
	dec_sex_split_gs[h,*] = STRSPLIT(guide_s[h].dec_sex ,':',/EXTRACT)
endfor

;ra_sex_split =  STRSPLIT(target.ra_sex  ,':',/EXTRACT)
;dec_sex_split = STRSPLIT(target.dec_sex ,':',/EXTRACT)
;ra_sex_split_gs =  STRSPLIT(guide_s.ra_sex  ,':',/EXTRACT)
;dec_sex_split_gs = STRSPLIT(guide_s.dec_sex ,':',/EXTRACT)
;######

for i=0, n_elements(target.(0))-1 do BEGIN
PRINTF, LUN,target[i].ATLAS_ID,$
	ra_sex_split[i,0],$
	ra_sex_split[i,1],$
	ra_sex_split[i,2],$
	dec_sex_split[i,0],$
	dec_sex_split[i,1],$
	dec_sex_split[i,2],$
	strtrim('P',2),$
	strtrim(target_priority[i],2),$
	target_magnitude[i],$
	strtrim('0',2),$
	strtrim('Program',2), $
		format='(A,TR1,I3,TR1,I02,TR1,F05.2,I4,TR1,I02,TR1,F05.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
endfor
for i=0, n_elements(guide_s)-1 do BEGIN
PRINTF, LUN,guide_s[i].ATLAS_ID,$
	ra_sex_split_gs[i,0],$
	ra_sex_split_gs[i,1],$
	ra_sex_split_gs[i,2],$
	dec_sex_split_gs[i,0],$
	dec_sex_split_gs[i,1],$
	dec_sex_split_gs[i,2],$
	strtrim('F',2),$
	strtrim('9',2),$
	guidestar_magnitude[i],$
	strtrim('0',2),$
	strtrim('Guide',2), $
		format='(A,TR1,I3,TR1,I02,TR1,F05.2,I4,TR1,I02,TR1,F05.2,TR1,A,TR1,A,TR1,F5.2,TR1,A,TR1,A,TR1)'
endfor 

abc = randomn(5.,300)

for i=0, 299 do BEGIN
PRINTF, LUN,strcompress(date_obs + string(i,'(I03)') + string(ihr_c,'(I03)') + string(imin_c,'(I02)') + string(xsec_c,'(F04.1)') + string(ideg_c,'(I03)') + string(imn_c,'(I02)') + string(xsc_c,'(F04.1)'),/remove_all),$
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
		format='(A,TR1,I3,TR1,I02,TR1,F05.2,I4,TR1,I02,TR1,F05.2,TR1,A,TR1,A,TR1,A,TR1,A,TR1,A,TR1)'
endfor 

Free_lun, lun
end
