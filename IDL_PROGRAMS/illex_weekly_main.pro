; $ID:	ILLEX_WEEKLY_IMAGES_MAIN.PRO,	2022-05-05-11,	USER-KJWH	$
  PRO ILLEX_WEEKLY_MAIN, VERSION, RESOLUTION=RESOLUTION, BUFFER=BUFFER, VERBOSE=VERBOSE, OVERWRITE=OVERWRITE, $
                                DOWNLOAD_FILES=DOWNLOAD_FILES,$
                                PROCESS_FILES=PROCESS_FILES,$
                                RUN_STATS=RUN_STATS,$
                                MAKE_PNGS=MAKE_PNGS,$
                                YEARLY_DIF=YEARLY_DIF,$
                                ANOMALY=ANOMALY,$
                                MAKE_COMPOSITES=MAKE_COMPOSITES
                                
                                
    

;+
; NAME:
;   ILLEX_WEEKLY_IMAGES_MAIN
;
; PURPOSE:
;   Main program to create weekly images for the Illex indicators project
;
; PROJECT:
;   illex_indicator_viewer
;
; CALLING SEQUENCE:
;   ILLEX_WEEKLY_IMAGES_MAIN
;
; REQUIRED INPUTS:
;    
;
; OPTIONAL INPUTS:
;   VERSION........... The name of the version
;   OUTPUT_MAP........ The name of the output map used for making the images
;   RESOLUTION........ The output resolution of the images
;   DOWNLOAD_FILES....
;   PROCESS_FILES.....
;   RUN_STATS.........
;   MAKE_PNGS.........
;   YEARLY_DIF........
;   ANOMALY...........
;   MAKE_COMPOSITES...
;
; KEYWORD PARAMETERS:
;   BUFFER............ Buffer the plotting steps
;   VERBOSE...... Print steps
;   OVERWRITE.... Overwrite existing files
;
; OUTPUTS:
;   Images, composites, animations, etc. to be used for the Illex indicators project
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
;   This program was written on May 05, 2022 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   May 05, 2022 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_WEEKLY_IMAGES_MAIN'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  DIR_PROJECT = !S.ILLEX_INDICATOR_VIEWER

  IF NONE(VERSION)    THEN VERSION = 'V2022'
  IF NONE(BUFFER)     THEN BUFFER  = 0
  IF NONE(VERBSOE)    THEN VERBOSE = 0
  IF NONE(RESOLUTION) THEN RESOLUTION = 300
  
  ; ===> Manually adjust the SOE program steps as needed
  IF ~N_ELEMENTS(DOWNLOAD_FILES)      THEN DOWNLOAD_FILES  = ''
  IF ~N_ELEMENTS(PROCESS_FILES)       THEN PROCESS_FILES   = ''
  IF ~N_ELEMENTS(MAKE_PNGS)           THEN MAKE_PNGS       = 'Y'
  IF ~N_ELEMENTS(YEARLY_DIF)          THEN YEARLY_DIF      = ''
  IF ~N_ELEMENTS(ANOMALY)             THEN ANOMALY         = ''
  IF ~N_ELEMENTS(MAKE_COMPOSITES)     THEN MAKE_COMPOSITES = ''
  
  ; ===> Loop through versions
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    VERSTR = ILLEX_WEEKLY_VERSION(VER)
    
    IF KEYWORD_SET(DOWNLOAD_FILES) THEN ILLEX_WEEKLY_DOWNLOADS, VERSTR
    
    IF KEYWORD_SET(PROCESS_FILES) THEN BEGIN ;ILLEX_WEEKLY_PROCESSING, VERSTR
      BATCH_L3, DO_GLOBCOLOUR='Y[;P=CHLOR_A-GSM]';, DO_GHRSST='Y[MUR;M=L3B2]';
      BATCH_L3, DO_STATS='Y[GLOBCOLOUR;P=CHLOR_A-GSM;PER=W;M=L3B4]'
   
   ; Set up steps to subset the MUR data before making the L3B2
   
      BATCH_L3, DO_STATS='Y[MUR;PER=W.WEEK;M=L3B2]'
    ENDIF
    
    IF KEYWORD_SET(MAKE_PNGS) THEN BEGIN
      FILES = GET_FILES('GLOBCOLOUR',PRODS='CHLOR_A-GSM',PERIOD='W')
      FILES = REVERSE(FILES) 
      DIR_OUT=VERSTR.DIRS.DIR_PNGS + 'CHLOR_A-GSM' + SL & DIR_TEST, DIR_OUT
      MP = VERSTR.INFO.MAP_OUT
      MR = MAPS_READ(MP)
      FOR F=0, N_ELEMENTS(FILES)-1 DO BEGIN
        FP = PARSE_IT(FILES[F])
        PER = PERIOD_2STRUCT(FP.PERIOD)
        TXT = 'Week ' + STRMID(PER.PERIOD,7,2) + ': ' + STRMID(PER.DATE_START,0,8) + ' - ' + STRMID(PER.DATE_END,0,8)
        PRODS_2PNG, FILES[F], PAL=VERSTR.PROD_INFO.CHLOR_A.PAL, SPROD=VERSTR.PROD_INFO.CHLOR_A.PROD_SCALE, ADD_BATHY=200,$
          DIR_OUT=DIR_OUT, MAPP=MP, /ADD_CB, ADD_TXT=TXT, TXT_ALIGN=0.50, TXT_POS=[0.275,0.96], BUFFER=1, RESOLUTION=300
      ENDFOR
    ENDIF
    
    
    
  ENDFOR  
  


END ; ***************** End of ILLEX_WEEKLY_IMAGES_MAIN *****************
