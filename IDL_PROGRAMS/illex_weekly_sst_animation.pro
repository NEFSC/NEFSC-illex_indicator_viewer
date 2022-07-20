; $ID:	ILLEX_WEEKLY_SST_ANIMATION.PRO,	2022-07-20-11,	USER-KJWH	$
  PRO ILLEX_WEEKLY_SST_ANIMATION, VERSTRUCT, NDAYS=NDAYS, WEEKS=WEEKS, MAPP=MAPP, PROD_SCALE=PROD_SCALE, BUFFER=BUFFER, DIR_OUT=DIR_OUT, _REF_EXTRA=EXTRA

;+
; NAME:
;   ILLEX_WEEKLY_SST_ANIMATION
;
; PURPOSE:
;   $PURPOSE$
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_WEEKLY_SST_ANIMATION,$Parameter1$, $Parameter2$, $Keyword=Keyword$, ....
;
; REQUIRED INPUTS:
;   Parm1.......... Describe the positional input parameters here. 
;
; OPTIONAL INPUTS:
;   NDAYS.......... The number of days in the animation
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
  ROUTINE_NAME = 'ILLEX_WEEKLY_SST_ANIMATION'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  VSTR = VERSTRUCT
    
  IF ~N_ELEMENTS(NDAYS) THEN MDATES=13 ELSE MDATES=NDAYS
  IF ~N_ELEMENTS(MAPP) THEN MP = VSTR.INFO.MAP_OUT ELSE MP = MAPP
  IF ~N_ELEMENTS(WEEKS) THEN WKS = ADD_STR_ZERO(INDGEN(51)+2) ELSE WKS = WEEKS 
  MR = MAPS_READ(MP)
  
  RESIZE = []
  CASE MP OF
    'NES': BEGIN & RESIZE=.85 & END
    'MAB': BEGIN & END  
  ENDCASE
  
  DP = DATE_PARSE(DATE_NOW())
  START_DATE = JD_2DATE(JD_ADD(DP.JD,-14,/DAY))
  PRODS = 'SST'

  FOR N=0, N_ELEMENTS(PRODS)-1 DO BEGIN
    PSTR = VSTR.PROD_INFO.(WHERE(TAG_NAMES(VSTR.PROD_INFO) EQ PRODS[N]))
    DSET = PSTR.DATASET

    
    IF ~N_ELEMENTS(DIR_OUT) THEN DIR_OUT=VSTR.DIRS.DIR_ANIMATIONS + PRODS[N] + SL 
    DIR_PNGS = DIR_OUT + 'ANIMATION_PNGS' + SL & DIR_TEST, DIR_PNGS
    
    
    FOR M=0, N_ELEMENTS(MDATES)-1 DO BEGIN
      MDATE = MDATES[M]
      
      WEEKS = REVERSE('W_2022' + WKS)
      FOR W=0, N_ELEMENTS(WEEKS)-1 DO BEGIN
        WPER = PERIOD_2STRUCT(WEEKS[W])
        PSCL = PSTR.MONTH_SCALE.(WHERE(TAG_NAMES(PSTR.MONTH_SCALE) EQ 'M'+WPER.MONTH_END))
        
        IF DATE_2JD(WPER.DATE_END) GT JD_ADD(DATE_NOW(/JD),2,/DAY) THEN CONTINUE
        DR = [JD_2DATE(JD_ADD(DATE_2JD(WPER.DATE_END),-MDATE,/DAY)),WPER.DATE_END]
        FILES = GET_FILES(DSET,PRODS=PSTR.PROD,PERIOD='D',DATERANGE=DR)
      
        ; ===> Make the PNG images using the scaling of the month at the end of the animation period (e.g. if the period spans May to June, use the June scaling)
        FOR F=0, N_ELEMENTS(FILES)-1 DO BEGIN 
          FP = PARSE_IT(FILES[F],/ALL)
          PNGFILE = DIR_PNGS + REPLACE(FP.NAME +'.PNG',[FP.PROD,FP.MAP],[PSCL,MP])
          IF ~FILE_MAKE(FILES[F],[PNGFILE],OVERWRITE=OVERWRITE,VERBOSE=VERBOSE) THEN CONTINUE
  
          IMG = ILLEX_WEEKLY_IMAGE(VSTR, FILE=FILES[F], MAPP=MP, BUFFER=BUFFER, RESIZE=RESIZE, _EXTRA=EXTRA)
          IMG.SAVE, PNGFILE, RESOLUTION=300
          IMG.CLOSE
        ENDFOR

      
        PNGS = FILE_SEARCH(DIR_PNGS + 'D_*' + MP + '*' + PSCL + '.PNG')
        PNGS = DATE_SELECT(PNGS,DR)
        IF PNGS EQ [] OR N_ELEMENTS(PNGS) LE 2 THEN CONTINUE
        FP = PARSE_IT(PNGS[0])

        MFILE = DIR_OUT + REPLACE(FP.NAME,FP.PERIOD,'DD_'+STRJOIN(STRMID(DR,0,8),'_'))
        EXT = ['webm'] ; 'mov','mp4',
        FOR E=0, N_ELEMENTS(EXT)-1 DO BEGIN
          FPS = 3
          MOVIE_FILE = MFILE + '-FPS_'+ROUNDS(FPS)+'.'+EXT[E]
          IF FILE_MAKE(PNGS,MOVIE_FILE,OVERWRITE=OVERWRITE) EQ 0 THEN CONTINUE
          MAKE_MOVIE, PNGS, MOVIE_FILE=MOVIE_FILE, FRAME_SEC=FPS, AUTHOR=!S.AUTHOR, AFFILIATION=!S.AFFILIATION
        ENDFOR ; EXT

      ENDFOR ; WEEKS
    ENDFOR ; MDATES


  ENDFOR


END ; ***************** End of ILLEX_WEEKLY_SST_ANIMATION *****************
