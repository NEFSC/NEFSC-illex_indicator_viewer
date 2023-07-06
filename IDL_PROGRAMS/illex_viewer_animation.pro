; $ID:	ILLEX_VIEWER_ANIMATION.PRO,	2022-08-08-09,	USER-KJWH	$
  PRO ILLEX_VIEWER_ANIMATION, VERSTRUCT, PRODS=PRODS, NDAYS=NDAYS, WEEKS=WEEKS, MAPP=MAPP, PROD_SCALE=PROD_SCALE, BUFFER=BUFFER, DIR_OUT=DIR_OUT, _REF_EXTRA=EXTRA

;+
; NAME:
;   ILLEX_VIEWER_ANIMATION
;
; PURPOSE:
;   This program creates an animation of SST images for the Illex Viewer dashboard
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_VIEWER_ANIMATION,$Parameter1$, $Parameter2$, $Keyword=Keyword$, ....
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
  ROUTINE_NAME = 'ILLEX_VIEWER_ANIMATION'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  VSTR = VERSTRUCT
    
  IF ~N_ELEMENTS(NDAYS) THEN MDATES=13 ELSE MDATES=NDAYS
  IF ~N_ELEMENTS(MAPP) THEN MP = VSTR.INFO.MAP_OUT ELSE MP = MAPP
  IF ~N_ELEMENTS(WEEKS) THEN WKS = ADD_STR_ZERO(INDGEN(51)+2) ELSE WKS = WEEKS 
  IF ~N_ELEMENTS(PRODS) THEN PRDS = VSTR.INFO.ANIMATION_PRODS ELSE PRDS = PRODS
  MR = MAPS_READ(MP)
  
  RESIZE = []
  CASE MP OF
    'NES': BEGIN & RESIZE=.85 & END
    'MAB': BEGIN & END  
    'MAB_GS': BEGIN & RESIZE=.9 & END  
  ENDCASE
  
  DP = DATE_PARSE(DATE_NOW())
  START_DATE = JD_2DATE(JD_ADD(DP.JD,-14,/DAY))

  FOR N=0, N_ELEMENTS(PRDS)-1 DO BEGIN
    PSTR = VSTR.PROD_INFO.(WHERE(TAG_NAMES(VSTR.PROD_INFO) EQ PRDS[N]))
    DSET = PSTR.DATASET
    
    IF ~N_ELEMENTS(DIR_OUT) THEN DIROUT=VSTR.DIRS.DIR_ANIMATIONS + PRDS[N] + SL ELSE DIROUT = DIR_OUT
    DIR_PNGS = DIROUT + 'ANIMATION_PNGS' + SL & DIR_TEST, DIR_PNGS
        
    FOR M=0, N_ELEMENTS(MDATES)-1 DO BEGIN
      MDATE = MDATES[M]
      
      WEEKS = 'W_' + VSTR.INFO.ILLEX_YEAR + WKS
      FOR W=0, N_ELEMENTS(WEEKS)-1 DO BEGIN
        WPER = PERIOD_2STRUCT(WEEKS[W])
        IF PSTR.PROD EQ 'SST' THEN PSCL = PSTR.MONTH_SCALE.(WHERE(TAG_NAMES(PSTR.MONTH_SCALE) EQ 'M'+WPER.MONTH_END)) $
                                               ELSE PSCL = PSTR.PROD_SCALE
        
        IF DATE_2JD(WPER.DATE_END) - DATE_NOW(/JD) GT 7 THEN CONTINUE
        DR = [JD_2DATE(JD_ADD(DATE_2JD(WPER.DATE_END),-MDATE,/DAY)),WPER.DATE_END]
        DATES = CREATE_DATE(DR[0],DR[1])
        FILES = GET_FILES(DSET,PRODS=PSTR.PROD,PERIOD='D',DATERANGE=VSTR.INFO.ILLEX_YEAR)
        IF N_ELEMENTS(FILES) NE 1 THEN MESSAGE, 'ERROR: Check FILES'
        FP = PARSE_IT(FILES,/ALL)
        
        PNGFILES = []
        FOR PNF=0, N_ELEMENTS(DATES)-1 DO BEGIN
          PNGFILE = DIR_PNGS + REPLACE(FP.NAME +'.PNG',[FP.PERIOD,FP.PROD,FP.MAP,FP.MAP_SUBSET,FP.PXY],[DATE_2PERIOD(STRMID(DATES[PNF],0,8)),PSCL,MP,'',''])
          WHILE HAS(PNGFILE,'--') DO PNGFILE=REPLACE(PNGFILE,'--','-')
          PNGFILE = REPLACE(PNGFILE, '-'+['STACKED','STACKED_STATS','STACKED_ANOMS'],['','',''])
          PNGFILES = [PNGFILES,PNGFILE]
        ENDFOR
        FA = PARSE_IT(PNGFILES[0])
        OUTPERIOD = 'DD_'+ STRMID(DATES[0],0,8) + '_' +  STRMID(DATES[-1],0,8)

        ; ===> Make the PNG images using the scaling of the month at the end of the animation period (e.g. if the period spans May to June, use the June scaling)
        MFILE = DIROUT + REPLACE(FA.NAME,FA.PERIOD,OUTPERIOD)
        EXT = ['webm'] ; 'mov','mp4',
        PNG_OVERWRITE = 0
        FOR E=0, N_ELEMENTS(EXT)-1 DO BEGIN
          FPS = 3
          MOVIE_FILE = MFILE + '-FPS_'+ROUNDS(FPS)+'.'+EXT[E]
          IF FILE_MAKE(PNGFILES,MOVIE_FILE,OVERWRITE=OVERWRITE) EQ 0 THEN CONTINUE
          IF TOTAL(FILE_TEST([PNGFILES,MOVIE_FILE])) EQ N_ELEMENTS([PNGFILES,MOVIE_FILE]) AND ~KEYWORD_SET(OVERWRITE) THEN CONTINUE
          PNG_OVERWRITE = 1
                  
          FOR F=0, N_ELEMENTS(DATES)-1 DO BEGIN 
            PNGFILE = PNGFILES[F]
            DR = GET_DATERANGE(DATES[F],DATES[F])
            IF ~FILE_MAKE(FILES,[PNGFILE],OVERWRITE=PNG_OVERWRITE,VERBOSE=VERBOSE) THEN CONTINUE
  ;          
            IMG = ILLEX_VIEWER_IMAGE(VSTR, FILE=FILES, DATERANGE=DR,MAPP=MP, PROD_SCALE=PSCL, BUFFER=BUFFER, RESIZE=RESIZE, _EXTRA=EXTRA)
            IF IDLTYPE(IMG) NE 'OBJREF' THEN CONTINUE
            
            PFILE, PNGFILE,/W
            IMG.SAVE, PNGFILE, RESOLUTION=300
            IMG.CLOSE
          ENDFOR ; DATES
      
          PNGS = FILE_SEARCH(DIR_PNGS + 'D_*' + MP + '*' + PSCL + '*.PNG')
          PNGS = DATE_SELECT(PNGS, [DATES[0],DATES[-1]])
          IF PNGS EQ [] OR N_ELEMENTS(PNGS) LE 2 THEN CONTINUE
          MAKE_MOVIE, PNGS, MOVIE_FILE=MOVIE_FILE, FRAME_SEC=FPS, AUTHOR=!S.AUTHOR, AFFILIATION=!S.AFFILIATION
        ENDFOR ; EXT

      ENDFOR ; WEEKS
    ENDFOR ; MDATES


  ENDFOR


END ; ***************** End of ILLEX_VIEWER_SST_ANIMATION *****************
