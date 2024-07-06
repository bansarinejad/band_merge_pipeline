pro twodf_pix

;read in 2df coords
data = mrdfits ( '/home/ben/obs/2qdes/observed/final_catalogue.mer' , 1 )

;set number of annuli
;r = 10
;theta = 8

;set number of pixels
;num_pix = (r*(r+1)*0.5*theta) + 1
;pix_count = fltarr(num_pix)

;set max radius
;maximum = MAX(data.X_POSN,data.Y_POSN)

;radius of each annulus
;delta_r = maximum / r

;for i=0, num_pix-1 do begin
;endfor

;d = fltarr( 2 , n_elements(data.(0)) )
;d[0,*] = data.x_posn
;d[1,*] = data.y_posn

x = data.x_posn
y = data.y_posn

len = 2.5e5
;#
bi   = 10000.
zi = hist_2d(x,y,max1=len,max2=len,min1=-len,min2=-len,bin1=bi,bin2=bi)
xi = findgen(n_elements(zi[0,*]))*bi - len
yi = findgen(n_elements(zi[0,*]))*bi - len

bii   = 5000.
zii = hist_2d(x,y,max1=len,max2=len,min1=-len,min2=-len,bin1=bii,bin2=bii)
xii = findgen(n_elements(zii[0,*]))*bii - len
yii = findgen(n_elements(zii[0,*]))*bii - len

biii   = 2500.
ziii = hist_2d(x,y,max1=len,max2=len,min1=-len,min2=-len,bin1=biii,bin2=biii)
xiii = findgen(n_elements(ziii[0,*]))*biii - len
yiii = findgen(n_elements(ziii[0,*]))*biii - len

biiii   = 1250.
ziiii = hist_2d(x,y,max1=len,max2=len,min1=-len,min2=-len,bin1=biiii,bin2=biiii)
xiiii = findgen(n_elements(ziii[0,*]))*biiii - len
yiiii = findgen(n_elements(ziii[0,*]))*biiii - len

;index = [30,60,90,120,150,220,255]
;c = contour(z,$
;			/FILL,$
;			ASPECT_RATIO=1.);,$
;			RGB_TABLE=39,$
;			RGB_INDICES=index,$
;			C_VALUE=index)

;#### 3D SURFACE PLOT ##################################################
;dem = z
;rotate the data for display purposes
;dem = ROTATE(dem, 1)

; Define the minimum data elements
;dem_min = MIN(dem, MAX=dem_max)
 
; Define the number of levels to display
;nlevels = 15
 
; Define the levels to display
;levels = FINDGEN(nlevels)/nlevels*(dem_max-dem_min) + dem_min

 
;Define the levels to show and the colors to use
;levels = [-1, levels]
 
; Display the filled contour
;c1 = CONTOUR(dem, xaxis , yaxis ,$
;   C_VALUE=levels, RGB_TABLE=12, $
;   /FILL, PLANAR=0,  $
;   XTITLE='X', YTITLE='Y', ZTITLE='Target Density', $
;   TITLE='2QDES - TARGETING')
 
; Move the Z Axis to the back.
;(c1['zaxis']).location = [-3e5, (c1.yrange)[1], 3e5]
 
; Overplot the contour lines to show more detail
;c2 = CONTOUR(dem, $
;   C_VALUE=levels, PLANAR=0, COLOR='black', $
;   /OVERPLOT)
;#######################################################################

;############## 2D CONTOUR PLOT ########################################
; Plot the unsmoothed data:

;unsmooth = CONTOUR(z, TITLE='Unsmoothed', $
	;LAYOUT=[2,1,1],$
;	RGB_TABLE=13, /FILL, N_LEVELS=10)
  
; Draw the outline of the 10 levels
;outline1 = CONTOUR(z, N_LEVELS=10, /OVERPLOT)

; Plot the smoothed data:
;smooth = CONTOUR(MIN_CURVE_SURF(z), TITLE='Smoothed', $
;   /CURRENT, LAYOUT=[2,1,2], RGB_TABLE=13, $
;   /FILL, N_LEVELS=10)
; Draw the outline of the 10 levels
;outline2 = CONTOUR(MIN_CURVE_SURF(z), $
;   N_LEVELS=10, /OVERPLOT)
;#######################################################################


;surface,z,/lego,/nodata
;loadct,13
;DEVICE, DECOMPOSED=0
;surface,z,/lego,shades=z

;#######################################################################
;p=plot(xaxis,yaxis,/nodata,xstyle=1,ystyle=1,title = 'Target Distribution 2QDES')
;loadct, 13
;colours = fltarr(n_elements(z))
;scale = 255./max(z)
;colours = round(Scale_vector(z*scale,0,255))
;stop
;
;for i=1,n_elements(z[0,*])-1 do begin
;	for j=1,n_elements(z[0,*])-1 do begin
;		poly = 	polygon([xaxis[i-1],xaxis[i],xaxis[i],xaxis[i-1]],$
;						[yaxis[j-1],yaxis[j-1],yaxis[j],yaxis[j]],$
;						/data,/fill_background,$
;						rgb_table=13,$
;						fill_color=[scale*z[i-1,j-1]])
;	endfor
;endfor
;stop
;
;p.save,'density_coarse.pdf',/bitmap,/close

will = 23

w = WINDOW(WINDOW_TITLE="My Window", DIMENSIONS=[1024,1024])

im1 = IMAGE(zi, $
   BACKGROUND_COLOR="green", $
   IMAGE_DIMENSIONS=[N_ELEMENTS(zi[0,*]),N_ELEMENTS(zi[*,0])], $
;   IMAGE_LOCATION=[-180,-90], $
;   XRANGE=[-180,0], YRANGE=[-90,90], $
;	TITLE = 'LOWEST RES' ,$
	LAYOUT=[4,1,1]	,$
	/current,$
	DIMENSIONS=[512,512], MARGIN=0,RGB_TABLE=will)

im2 = IMAGE(zii, $
   BACKGROUND_COLOR="green", $
   IMAGE_DIMENSIONS=[N_ELEMENTS(zii[0,*]),N_ELEMENTS(zii[*,0])], $
;   IMAGE_LOCATION=[-180,-90], $
;   XRANGE=[-180,0], YRANGE=[-90,90], $
;	TITLE = 'LOW RES' ,$
	LAYOUT=[4,1,2]	,$
	/current,$
;	/OVERPLOT ,$
	DIMENSIONS=[512,512], MARGIN=0,RGB_TABLE=will)
	
im3 = IMAGE(ziii, $
   BACKGROUND_COLOR="green", $
   IMAGE_DIMENSIONS=[N_ELEMENTS(ziii[0,*]),N_ELEMENTS(ziii[*,0])], $
;   IMAGE_LOCATION=[-180,-90], $
;   XRANGE=[-180,0], YRANGE=[-90,90], $
;	TITLE = 'HIGH RES' ,$
	LAYOUT=[4,2,1]	,$
	/current,$
;	/OVERPLOT ,$
	DIMENSIONS=[512,512], MARGIN=0,RGB_TABLE=will)
	
im4 = IMAGE(ziiii, $
   BACKGROUND_COLOR="green", $
   IMAGE_DIMENSIONS=[N_ELEMENTS(ziiii[0,*]),N_ELEMENTS(ziiii[*,0])], $
;   IMAGE_LOCATION=[-180,-90], $
;   XRANGE=[-180,0], YRANGE=[-90,90], $
;	TITLE = 'HIGHEST RES' ,$
	LAYOUT=[4,2,2]	,$
	/current,$
;	/OVERPLOT ,$
	DIMENSIONS=[512,512], MARGIN=0,RGB_TABLE=will)

stop
im1.save,'image_4.pdf',/bitmap,/close
end
