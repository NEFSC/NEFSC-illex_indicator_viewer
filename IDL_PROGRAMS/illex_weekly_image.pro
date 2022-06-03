; $ID:	ILLEX_WEEKLY_IMAGE.PRO,	2022-06-02-11,	USER-KJWH	$
  FUNCTION ILLEX_WEEKLY_IMAGE, VERSTR, FILE=FILE, MAPP=MAPP, BUFFER=BUFFER, CURRENT=CURRENT, $
                               ADD_BATHY=ADD_BATHY, BATHY_DEPTH=BATHY_DEPTH, BATHY_COLOR=BATHY_COLOR, BATHY_THICK=BATHY_THICK, $
                               OUTLINE=OUTLINE, OUT_COLOR=OUT_COLOR, OUT_THICK=OUT_THICK, $
                               ADD_LONLAT=ADD_LONLAT, LONS=LONS, LATS=LATS, LL_COLOR=LL_COLOR, LL_THICK=LL_THICK, $
                               ADD_CONTOURS=ADD_CONTOURS, CONTOURS=CONTOURS, $
                               PSCL=PSCL, CBTITLE=CBTITLE, SCLR=SCLR, PAL=PAL
                               

;+
; NAME:
;   ILLEX_WEEKLY_IMAGE
;
; PURPOSE:
;   This function will return an image to be used in the composites and annimations for the Weekly Illex website
;
; PROJECT:
;   illex_indicator_viewer
;
; CALLING SEQUENCE:
;   Result = ILLEX_WEEKLY_IMAGE($Parameter1$, $Parameter2$, $Keyword=Keyword$, ...)
;
; REQUIRED INPUTS:
;   Parm1.......... Describe the positional input parameters here. 
;
; OPTIONAL INPUTS:
;   Parm2.......... Describe optional inputs here. If none, delete this section.
;
; KEYWORD PARAMETERS:
;   KEY1........... Document keyword parameters like this. Note that the keyword is shown in ALL CAPS!
;
; OUTPUTS:
;   OUTPUT.......... Decribe the output of this program or function
;
; OPTIONAL OUTPUTS:
;   None
;
; COMMON BLOCKS: 
;   None
;
; SIDE EFFECTS:  
;   None
;
; RESTRICTIONS:  
;   None
;
; EXAMPLE:
; 
;
; NOTES:
;   $Citations or any other useful notes$
;   
; COPYRIGHT: 
; Copyright (C) 2022, Department of Commerce, National Oceanic and Atmospheric Administration, National Marine Fisheries Service,
;   Northeast Fisheries Science Center, Narragansett Laboratory.
;   This software may be used, copied, or redistributed as long as it is not sold and this copyright notice is reproduced on each copy made.
;   This routine is provided AS IS without any express or implied warranties whatsoever.
;
; AUTHOR:
;   This program was written on June 02, 2022 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   Jun 02, 2022 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_WEEKLY_IMAGE'
  COMPILE_OPT IDL2
  SL = PATH_SEP()

  FP = PARSE_IT(FILE,/ALL)
  PROD = FP.PROD
  PSTR = VERSTR.PROD_INFO.(WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ PROD))

  TYPE = FP.MATH
  PER = PERIOD_2STRUCT(FP.PERIOD)
  
  IF ~N_ELEMENTS(BATHY)  THEN BATHY = 200 
  IF ~N_ELEMENTS(OUT_COLOR) THEN OCOLOR = 250
  IF ~N_ELEMENTS(OUT_THICK) THEN OTHICK = 3
  IF ~N_ELEMENTS(MAPP)   THEN MP = VERSTR.INFO.MAP_OUT ELSE MP = MAPP
  
  IF KEYWORD_SET(ADD_LONLAT) THEN BEGIN
    IF ~N_ELEMENTS(LONS)   THEN LONS = [-76,-72,-68,-64] & LONNAMES = REPLICATE('',N_ELEMENTS(LONS))
    IF ~N_ELEMENTS(LATS)   THEN LATS = [ 36, 40, 44]     & LATNAMES = REPLICATE('',N_ELEMENTS(LATS))
    IF ~N_ELEMENTS(C_COLOR) THEN LL_COLOR = 254
    IF ~N_ELEMENTS(C_THICK) THEN LL_THICK = 3
  ENDIF  
  
  IF KEYWORD_SET(ADD_CONTOURS) OR N_ELEMENTS(CONTOURS) GT 0 THEN BEGIN
    IF ~N_ELEMENTS(CONTOURS) THEN BEGIN
      CASE PROD OF 
        'SST': C_LEVELS = [12,16,20,24]
      ENDCASE
    ENDIF ELSE C_LEVELS = CONTOURS
    IF ~N_ELEMENTS(C_COLOR) THEN C_COLOR = 249
    IF ~N_ELEMENTS(C_THICK) THEN C_THICK = 4
    IF ~N_ELEMENTS(C_ANNOTATION) THEN C_ANNOTATION = REPLICATE(' ',N_ELEMENTS(C_LEVELS))
  ENDIF ELSE C_LEVELS = []
    
  PSCL = PSTR.PROD_SCALE
  PAL  = PSTR.PAL
  CBTITLE = UNITS(PROD)
  
  CASE PROD OF
    'CHLOR_A': BEGIN 
      CASE TYPE OF
        'ANOMS': BEGIN & SCLR='NAVY'   & PSCL=PSTR.ANOM_SCALE & PAL=PSTR.ANOM_PAL & CBTITLE=PSTR.ANOM_TITLE & END 
        'STATS': BEGIN & SCLR='TOMATO' & END
         ELSE:   BEGIN & SCLR='TOMATO' & END
      ENDCASE
    END           
    'SST': BEGIN
      CASE TYPE OF
        'ANOMS': BEGIN & SCLR = 'NAVY'   & PSCL = PSTR.ANOM_SCALE & PAL=PSTR.ANOM_PAL & CBTITLE=PSTR.ANOM_TITLE & END
        'STATS': BEGIN & SCLR = 'YELLOW' & PSCL = PSTR.MONTH_SCALE.(WHERE(TAG_NAMES(PSTR.MONTH_SCALE) EQ 'M'+PER.MONTH_START)) & END
         ELSE:   BEGIN & SCLR = 'YELLOW' & PSCL = PSTR.MONTH_SCALE.(WHERE(TAG_NAMES(PSTR.MONTH_SCALE) EQ 'M'+PER.MONTH_START)) & END         
      ENDCASE
    END
  ENDCASE
  

  PRODS_2PNG, FILE, OBJ=IMG, MAPP=MP, PAL=PAL, SPROD=PSCL, ADD_BATHY=BATHY, OUTLINE=OUTLINE, OUT_COLOR=OUT_COLOR, OUT_THICK=OUT_THICK, $
              C_LEVELS=C_LEVELS,C_COLOR=C_COLOR,C_THICK=C_THICK,C_ANNOTATION=C_ANNOTATION, $
              ADD_LONLAT=ADD_LONLAT,LL_COLOR=LL_COLOR,LL_THICK=LL_THICK,LONS=LONS,LATS=LATS,LONNAMES=LONNAMES,LATNAMES=LATNAMES,$
              BUFFER=BUFFER, /NO_SAVE, CURRENT=CURRENT

  RETURN, IMG


END ; ***************** End of ILLEX_WEEKLY_IMAGE *****************
