; $ID:	ILLEX_WEEKLY_EVENTS.PRO,	2022-07-20-15,	USER-KJWH	$
  PRO ILLEX_WEEKLY_EVENTS, EVENTS, BUFFER=BUFFER

;+
; NAME:
;   ILLEX_WEEKLY_EVENTS
;
; PURPOSE:
;   $PURPOSE$
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_WEEKLY_EVENTS,$Parameter1$, $Parameter2$, $Keyword=Keyword$, ....
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
;   This program was written on July 20, 2022 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   Jul 20, 2022 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_WEEKLY_EVENTS'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  

  FOR E=0, N_ELEMENTS(EVENTS)-1 DO BEGIN
    EVENT = EVENTS[E]
    
    ECANYONS = [] & MP = [] & MAKE_ANIM = 0
    CASE EVENTS OF
      'SMALL_SQUID_200207': BEGIN 
        WEEKS=['27','28','29']
        FLATS=DMS2DEG(3834) & FLONS=DMS2DEG(-7312)
        PRODS=['SST_15_30','CHLOR_A_.1_30'] & TYPES='STATS' 
        ADD_PIONNEER=1 
        ECANYONS=['SPENCER']+'_CANYON'
        MP='MAB' 
        MAKE_ANIM=1
        VERSION = 'V2022' 
      END ; Fished at 160-170 fathoms, surface temp=76.2 oF & bottom temp = 55.2 oF
    ENDCASE

    VERSTR = ILLEX_WEEKLY_VERSION(VER)
    IF MP EQ [] THEN MP = VERSTR.INFO.MAP_OUT
    DIR_OUT = VERSTR.DIRS.DIR_EVENTS + EVENT + SL & DIR_TEST, DIR_OUT

    IF MP NE VERSTR.INFO.MAP_OUT THEN MCANYONS = READ_SHPFILE('MAB_CANYONS',MAPP=MP) ELSE MCANYONS = MAB_CANYONS
    IF ECANYONS NE [] THEN BEGIN
      ECANYON_OUTLINES = []
      FOR M=0, N_ELEMENTS(ECANYONS)-1 DO BEGIN
        OK = WHERE(TAG_NAMES(MCANYONS) EQ ECANYONS[M],/NULL)
        IF OK EQ [] THEN STOP
        ECANYON_OUTLINES = [ECANYON_OUTLINES,MCANYONS.(OK).OUTLINE]
      ENDFOR
    ENDIF ELSE ECANYON_OUTLINES = CANYON_OUTLINES

    FOR W=0, N_ELEMENTS(WEEKS)-1 DO BEGIN
      WK = 'W_'+VERSTR.INFO.ILLEX_YEAR + WEEKS[W]
      WPER = PERIOD_2STRUCT(WK)
      IF DATE_2JD(WPER.DATE_START) GT DATE_NOW(/JD) THEN CONTINUE

      DR = [WPER.DATE_START,WPER.DATE_END]
      TXT = 'Week ' + STRMID(WPER.PERIOD,6,2) + ': ' + STRMID(WPER.DATE_START,0,8) + ' - ' + STRMID(WPER.DATE_END,0,8)

      FILES = []
      FOR N=0, N_ELEMENTS(PRODS)-1 DO BEGIN
        APROD = (PRODS_READ(PRODS[N])).PROD
        PSTR = VERSTR.PROD_INFO.(WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ APROD))
        IF APROD NE PRODS[N] THEN PROD_SCALE = PRODS[N] ELSE PROD_SCALE = []
        DSET = PSTR.DATASET
        FOR T=0, N_ELEMENTS(TYPES)-1 DO BEGIN
          ATYPE = TYPES[T]
          FILE = GET_FILES(DSET,PRODS=PSTR.PROD,PERIOD=WPER.PERIOD_CODE,FILE_TYPE=ATYPE, DATERANGE=DR)
          IF N_ELEMENTS(FILE) GT 1 THEN MESSAGE,'ERROR: More that one file found for ' + PSTR.PROD + ' - ' + ATYPE
          FP = PARSE_IT(FILE,/ALL)

          PNGFILE = DIR_OUT + REPLACE(FP.NAME +'.PNG',FP.MAP,MP); WPER.PERIOD + '-' + MP + '-' + STRJOIN(PRODS,'_') + '-' + STRJOIN(TYPES,'_') + '-COMPOSITE' +'.PNG'
          IF ~FILE_MAKE(FILE,PNGFILE,OVERWRITE=OVERWRITE,VERBOSE=VERBOSE) THEN CONTINUE

          IMG = ILLEX_WEEKLY_IMAGE(VERSTR, FILE=FILE, BUFFER=BUFFER, MAPP=MP, OUTLINE=ECANYON_OUTLINES, OUT_COLOR=40, OUT_THICK=2, $
            /ADD_POINTS, PLONS=FLONS, PLATS=FLATS, PSYM='STAR', PCOLOR='DARK_VIOLET', PSIZE=2, $
            /ADD_BATHY, /ADD_LONLAT, PROD_SCALE=PROD_SCALE, CBTITLE=CBTITLE, SCLR=SCLR, PAL=PAL, LONS=LONS, LATS=LATS,$
            RESIZE=RESIZE,/ADD_COLORBAR, /ADD_PIONEER,/ADD_BOARDER,/ADD_TITLE,TITLE_TEXT=TXT)

          IMG.SAVE, PNGFILE, RESOLUTION=RESOLUTION
          IMG.CLOSE
        ENDFOR ; TYPES
      ENDFOR ; PRODS
    ENDFOR ; WEEKS
    IF KEYWORD_SET(MAKE_ANIM) THEN BEGIN
      ILLEX_WEEKLY_SST_ANIMATION, VERSTR, WEEKS=WEEKS, DIR_OUT=DIR_OUT, MAPP=MP, BUFFER=0, PROD_SCALE=PROD_SCALE, $
          /ADD_CONTOURS, /ADD_COLORBAR, /ADD_DATEBAR, /ADD_BATHY, /ADD_LONLAT, /ADD_BOARDER, /ADD_PIONEER,$
          OUTLINE=ECANYON_OUTLINES, OUT_COLOR=10, OUT_THICK=2, OUTCOLOR=0, $
          /ADD_POINTS, PLONS=FLONS, PLATS=FLATS, PSYM='STAR', PCOLOR='DARK_VIOLET', PSIZE=2, $
          DB_POS=DB_POS
    ENDIF

  ENDFOR ; EVENTS


END ; ***************** End of ILLEX_WEEKLY_EVENTS *****************
