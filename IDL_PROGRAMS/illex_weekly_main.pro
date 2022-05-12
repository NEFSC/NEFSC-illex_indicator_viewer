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
  IF ~N_ELEMENTS(DOWNLOAD_FILES)      THEN DOWNLOAD_FILES   = ''
  IF ~N_ELEMENTS(PROCESS_FILES)       THEN PROCESS_FILES    = ''
  IF ~N_ELEMENTS(MAKE_PNGS)           THEN MAKE_PNGS        = 'Y'
  IF ~N_ELEMENTS(YEARLY_DIF)          THEN YEARLY_DIF       = ''
  IF ~N_ELEMENTS(ANOMALY)             THEN ANOMALY          = ''
  IF ~N_ELEMENTS(MAKE_COMPOSITES)     THEN MAKE_COMPOSITES  = ''
  IF ~N_ELEMENTS(SUBAREA_EXTRACTS)    THEN SUBAREA_EXTRACTS = ''
  
  
  ; ===> Loop through versions
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    VERSTR = ILLEX_WEEKLY_VERSION(VER)
    
    IF KEYWORD_SET(DOWNLOAD_FILES) THEN ILLEX_WEEKLY_DOWNLOADS, VERSTR
    
    IF KEYWORD_SET(PROCESS_FILES) THEN BEGIN ;ILLEX_WEEKLY_PROCESSING, VERSTR
      BATCH_L3, DO_GHRSST='Y[MUR;M=L3B2]',DO_STATS='Y_2020_2022[MUR;PER=W.M]'
      BATCH_L3, DO_GLOBCOLOUR='Y[;P=CHLOR_A-GSM]',DO_MAKE_PRODS='Y_2020_2022[GLOBCOLOUR]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=CHLOR_A-GSM;PER=W.M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=MICRO-TURNER;PER=M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=NANO-TURNER;PER=M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=PICO-TURNER;PER=M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=MICRO_PERCENTAGE-TURNER;PER=M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=NANO_PERCENTAGE-TURNER;PER=M;M=L3B4]'
;      BATCH_L3, DO_STATS='Y_2020_2022[GLOBCOLOUR;P=PICO_PERCENTAGE-TURNER;PER=M;M=L3B4]'


   
   ; Set up steps to subset the MUR data before making the L3B2
   
    ;  BATCH_L3, DO_STATS='Y[MUR;PER=W.WEEK;M=L3B2]'
    ENDIF
    
    IF KEYWORD_SET(MAKE_PNGS) THEN BEGIN
      PIONEER = VERSTR.DIRS.DIR_FILES + 'PIONEER_ARRAY_COORDINATES.csv'
      PDATA = CSV_READ(PIONEER)
      MP = VERSTR.INFO.MAP_OUT
      MR = MAPS_READ(MP)
      IMG_DIMS  = FLOAT(STRSPLIT(MR.IMG_DIMS,';',/EXTRACT))
      XX = IMG_DIMS[0]/MR.PX & YY = IMG_DIMS[1]/MR.PY
      MAPS_SET, MP
      LL = MAP_DEG2IMAGE(MAPS_BLANK(MP),PDATA.LON,PDATA.LAT,X=X,Y=Y)
      ZWIN
   
      PRODS = VERSTR.INFO.PNG_PRODS
      FOR N=0, N_ELEMENTS(PRODS)-1 DO BEGIN
        PSTR = VERSTR.PROD_INFO.(N)
        DSET = PSTR.DATASET
        
        FILES = GET_FILES(DSET,PRODS=PSTR.PROD,PERIOD='W')
        FILES = REVERSE(FILES) 
        DIR_OUT=VERSTR.DIRS.DIR_PNGS + PRODS[N] + SL & DIR_TEST, DIR_OUT
        
        CASE PRODS[N] OF
          'CHLOR_A': SCLR = 'TOMATO'
          'SST': SCLR = 'YELLOW'
        ENDCASE
        
        FOR F=0, N_ELEMENTS(FILES)-1 DO BEGIN
          FP = PARSE_IT(FILES[F],/ALL)
          PNGFILE = DIR_OUT + REPLACE(FP.NAME +'.PNG',FP.MAP,MP)
          
          IF ~FILE_MAKE(FILES[F],PNGFILE,OVERWRITE=OVERWRITE,VERBOSE=VERBOSE) THEN CONTINUE

          PER = PERIOD_2STRUCT(FP.PERIOD)
          TXT = 'Week ' + STRMID(PER.PERIOD,6,2) + ': ' + STRMID(PER.DATE_START,0,8) + ' - ' + STRMID(PER.DATE_END,0,8)
          
          IF PRODS[N] EQ 'SST' THEN BEGIN
            CASE PER.MONTH_START OF 
              '01': PSCL = 'SST_0_30'
              '02': PSCL = 'SST_0_30'
              '03': PSCL = 'SST_0_30'
              '04': PSCL = 'SST_5_30'
              '05': PSCL = 'SST_5_30'
              '06': PSCL = 'SST_10_30'
              '07': PSCL = 'SST_10_30'
              '08': PSCL = 'SST_15_30'
              '09': PSCL = 'SST_15_30'
              '10': PSCL = 'SST_10_30'
              '11': PSCL = 'SST_5_30'
              '12': PSCL = 'SST_5_30'
            ENDCASE  
          ENDIF ELSE PSCL = PSTR.PROD_SCALE
          
          W = WINDOW(DIMENSIONS=IMG_DIMS,/BUFFER)
          PRODS_2PNG, FILES[F],PAL=PSTR.PAL, SPROD=PSCL, ADD_BATHY=200,$
            DIR_OUT=DIR_OUT, MAPP=MP, /ADD_CB, ADD_TXT=TXT, TXT_ALIGN=0.50, TXT_POS=[0.275,0.96], BUFFER=1, RESOLUTION=300, /CURRENT
          SY = SYMBOL(X*XX,Y*YY,SYMBOL='CIRCLE',/DEVICE, /SYM_FILLED, SYM_COLOR=SCLR, SYM_SIZE=0.65)
          
          W.SAVE, PNGFILE, RESOLUTION=300
          W.CLOSE
          
  
        ENDFOR
      ENDFOR
    ENDIF
    
    
    IF KEYWORD_SET(SUBAREA_EXTRACTS) THEN ILLEX_SUBAREA_EXTRACT, VERSTR, PRODUCTS='PHYSIZE',PERIOD=['M','MONTH']
    
    
  ENDFOR  
  


END ; ***************** End of ILLEX_WEEKLY_IMAGES_MAIN *****************
