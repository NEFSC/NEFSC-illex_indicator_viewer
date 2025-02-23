; $ID:	ILLEX_VIEWER_MAIN.PRO,	2024-01-30-21,	USER-KJWH	$
  PRO ILLEX_VIEWER_MAIN, VERSION, BUFFER=BUFFER, OVERWRITE=OVERWRITE, LOGFILE=LOGFILE, LOGLUN=LOGLUN, $
                         DOWNLOAD_FILES=DOWNLOAD_FILES,$
                         PROCESS_FILES=PROCESS_FILES,$
                         ANIMATIONS=ANIMATIONS,$
                         MAKE_COMPOSITES=MAKE_COMPOSITES,$
                         DO_FRONTS=DO_FRONTS,$
                         EVENTS=EVENTS,$
                         SUBAREA_EXTRACTS=SUBAREAS_EXTRACTS,$
                         JC_ANIMATION=JC_ANIMATION, $
                         GIT_PUSH=GIT_PUSH, EMAIL=EMAIL

;+
; NAME:
;   ILLEX_VIEWER_MAIN
;
; PURPOSE:
;   Main program to create weekly images for the Illex indicators project
;
; PROJECT:
;   illex_indicator_viewer
;
; CALLING SEQUENCE:
;   ILLEX_VIEWER_IMAGES_MAIN
;
; REQUIRED INPUTS:
;    None
;
; OPTIONAL INPUTS:
;   VERSION........... The name of the version
;   LOGLUN.......... If provided, the LUN for the log file
;   LOGFILE............ The name of the output logfile
;   
;
; KEYWORD PARAMETERS:
;   DOWNLOAD_FILES.... Download files
;   PROCESS_FILES..... Use BATCH_L3 to process the downloaded files
;   SST_ANIMATION..... Create the SST animations
;   MAKE_COMPOSITES... Make composite images
;   EVENTS............ Run code to create images for specific events
;   SUBAREA_EXTRACTS.. Extract and plot regional data
;   JC_ANIMATION...... Create animations of the Jennifer Clark charts (in development)
;   MAKE_COMPOSITES...
;   GIT_PUSH......... Run steps to add, commit and push files to GitHub
;   EMAIL............... Send email indicating data were pushed to GitHub
;   
;   BUFFER............ Buffer the plotting steps
;   VERBOSE...... Print steps
;   OVERWRITE.... Overwrite existing files
;
; OUTPUTS:
;   Images, composites, animations, etc. to be used for the Illex indicators project
;
; OPTIONAL OUTPUTS:
;   A logfile 
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
;   Aug 11, 2022 - KJWH: Added option to GIT commit and push
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_VIEWER_MAIN'
  COMPILE_OPT IDL2
  SL = PATH_SEP()  
  DP = DATE_PARSE(DATE_NOW())

  
  DIR_PROJECT = !S.ILLEX_VIEWER
  
  IF KEYWORD_SET(GIT_PUSH) THEN BEGIN
    cd, DIR_PROJECT ; Change directory
    CMD = "git status" ; Check the version control status
    SPAWN, CMD, LOG, EXIT_STATUS=ES
    PLUN, LUN, LOG
    IF HAS(LOG, 'Your branch is up to date') THEN BEGIN
      CMD = "git pull ." ; Pull any "new" files
      SPAWN, CMD, LOG, EXIT_STATUS=ES
      PLUN, LUN, LOG
      IF ES EQ 1 THEN MESSAGE, 'ERROR: Unable to complete git pull '
    ENDIF
  ENDIF    

  IF ~N_ELEMENTS(VERSION)    THEN VERSION = 'V2023'
  IF ~N_ELEMENTS(BUFFER)     THEN BUFFER  = 1
  IF ~N_ELEMENTS(VERBOSE)    THEN VERBOSE = 0
  IF ~N_ELEMENTS(RESOLUTION) THEN RESOLUTION = 300
  IF ~N_ELEMENTS(LOGLUN)     THEN LUN   = [] ELSE LUN = LOGLUN
  
  ; ===> Manually adjust the ILLEX program steps as needed
  IF ~N_ELEMENTS(DOWNLOAD_FILES)      THEN DOWNLOAD_FILES   = ''
  IF ~N_ELEMENTS(PROCESS_FILES)       THEN PROCESS_FILES    = ''
  IF ~N_ELEMENTS(DO_FRONTS)           THEN DO_FRONTS        = ''
  IF ~N_ELEMENTS(ANIMATIONS)          THEN ANIMATIONS       = ''
  IF ~N_ELEMENTS(MAKE_COMPOSITES)     THEN MAKE_COMPOSITES  = 'Y
  IF ~N_ELEMENTS(SUBAREA_EXTRACTS)    THEN SUBAREA_EXTRACTS = ''
  IF ~N_ELEMENTS(EVENTS)              THEN EVENTS           = ''
  IF ~N_ELEMENTS(JC_ANIMATION)        THEN JC_ANIMATION     = ''
  IF ~N_ELEMENTS(GIT_PUSH)            THEN GIT_PUSH     = ''
  IF ~N_ELEMENTS(EMAIL)               THEN EMAIL = ''

  ; ===> Loop through versions
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    VERSTR = ILLEX_VIEWER_VERSION(VER)
    DR = VERSTR.INFO.DATERANGE
    IF KEYWORD_SET(LOGFILE) AND LUN EQ [] THEN BEGIN
      LOGDIR = DIR_PROJECT + 'IDL_OUTPUT' + SL + 'LOGS' + SL & DIR_TEST, LOGDIR
      IF IDLTYPE(LOGFILE) NE 'STRING' THEN LOGFILE =  LOGDIR + ROUTINE_NAME + '-' + DATE_NOW() + '.log'
      OPENW, LUN, LOGFILE, /APPEND, /GET_LUN, WIDTH=180 ;  ===> Open log file
    ENDIF ELSE BEGIN
      LUN = []
      LOGFILE = ''
    ENDELSE
    PLUN, LUN, '******************************************************************************************************************'
    PLUN, LUN, 'Starting ' + ROUTINE_NAME + ' log file: ' + LOGFILE + ' on: ' + systime() + ' on ' + !S.COMPUTER, 0
    
    
    CANYONS = ['HUDSON_CANYON','WILMINGTON_CANYON','NORFOLK_CANYON']
    MAB_CANYONS = READ_SHPFILE('MAB_CANYONS',MAPP=VERSTR.INFO.MAP_OUT)
    CANYON_OUTLINES = []
    FOR M=0, N_ELEMENTS(CANYONS)-1 DO BEGIN
      OK = WHERE(TAG_NAMES(MAB_CANYONS) EQ CANYONS[M],/NULL)
      IF OK EQ [] THEN STOP
      CANYON_OUTLINES = [CANYON_OUTLINES,MAB_CANYONS.(OK).OUTLINE]
    ENDFOR
 
    IF KEYWORD_SET(DOWNLOAD_FILES) THEN ILLEX_VIEWER_DOWNLOADS, VERSTR
    
    IF KEYWORD_SET(PROCESS_FILES) THEN BEGIN ;ILLEX_WEEKLY_PROCESSING, VERSTR
      PRODS=VERSTR.INFO.PROCESS_PRODS

      DSETS = []
      FOR N=0, N_ELEMENTS(PRODS)-1 DO BEGIN
        PSTR = VERSTR.PROD_INFO.(WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ PRODS[N]))
        DSET = PSTR.DATASET
        IF STRUCT_HAS(PSTR,'TEMP_DATASET') THEN BEGIN & TSET = PSTR.TEMP_DATASET & TPERS = VERSTR.INFO.STAT_TEMP_PERIODS & ENDIF ELSE TSET = []
        FILES_2STACKED_WRAPPER, DSET, PRODS=PSTR.PROD,DATERANGE=DR                                            & IF TSET NE [] THEN FILES_2STACKED_WRAPPER, TSET, PRODS=PSTR.PROD,DATERANGE=DR
        STACKED_STATS_WRAPPER, DSET, PRODS=PSTR.PROD, PERIODS=VERSTR.INFO.STAT_PERIODS                        & IF TSET NE [] THEN STACKED_STATS_WRAPPER, TSET, PRODS=PSTR.PROD, PERIODS=TPERS
        STACKED_ANOMS_WRAPPER, DSET, PRODS=PSTR.PROD, PERIODS=VERSTR.INFO.ANOM_PERIODS                        & IF TSET NE [] THEN STACKED_ANOMS_WRAPPER, TSET, PRODS=PSTR.PROD, PERIODS=TPERS
        STACKED_2NETCDF_WRAPPER, DSET,PRODS=PSTR.PROD,PERIODS=VERSTR.INFO.NETCDF_PERIODS, DATERANGE=DR,/ANOMS & IF TSET NE [] THEN STACKED_2NETCDF_WRAPPER, TSET,PRODS=PSTR.PROD,PERIODS=VERSTR.INFO.NETCDF_PERIODS, DATERANGE=DR,/ANOMS
        STACKED_2NETCDF_WRAPPER, DSET,PRODS=PSTR.PROD,PERIODS=VERSTR.INFO.NETCDF_PERIODS, DATERANGE=DR        & IF TSET NE [] THEN STACKED_2NETCDF_WRAPPER, TSET,PRODS=PSTR.PROD,PERIODS=VERSTR.INFO.NETCDF_PERIODS, DATERANGE=DR
      ENDFOR ; PRODS
    ENDIF
    
     IF KEYWORD_SET(DO_FRONTS) THEN BEGIN
       FOR F=0, N_ELEMENTS(VERSTR.INFO.FRONT_PRODS)-1 DO BEGIN
         FPROD = VERSTR.INFO.FRONT_PRODS[F]
         PSTR = VERSTR.PROD_INFO.(WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ FPROD))
         STACKED_MAKE_FRONTS_WRAPPER, PSTR.DATASET,      DATERANGE=DR, /DO_FRONTS, /DO_FRONT_NETCDF, /DO_STATS, /DO_STAT_NETCDF, STAT_PERIODS=['W','M','WEEK','MONTH'], OVERWRITE=OVERWRITE
         STACKED_MAKE_FRONTS_WRAPPER, PSTR.TEMP_DATASET, DATERANGE=DR, /DO_FRONTS, /DO_FRONT_NETCDF, /DO_STATS, /DO_STAT_NETCDF, STAT_PERIODS=['W','M'], OVERWRITE=OVERWRITE
       ENDFOR  
     ENDIF
    
     IF KEYWORD_SET(MAKE_COMPOSITES) THEN BEGIN 
       PROJECT_MAKE_COMPOSITE, VERSTR, PRODS=['SST'], /WEEKS, YEARS=['2022','2023','2024','2025'],TYPES=['STACKED_STATS','STACKED_ANOMS'],/YEAR_COMBO,/ADDDATE,DATE_POS=[0.9,0.1],DATE_ALIGN=1.0,/ADD_LONLAT,/ADD_COLORBAR,/ADD_BATHY,/ADD_BORDER,OUT_COLOR=0,BUFFER=1,DIR_OUT=VERSTR.DIRS.DIR_COMPOSITES + 'YEAR_COMPOSITES' + SL
       PROJECT_MAKE_COMPOSITE, VERSTR, PRODS=['SST','CHLOR_A'],/WEEKS,OUTLINE=CANYON_OUTLINES,/ADD_LONLAT,/ADD_COLORBAR,/ADD_BATHY,/ADD_BORDER,OUT_COLOR=0,BUFFER=1
     ; ILLEX_VIEWER_COMPOSITE, VERSTR, /WEEKS, BUFFER=BUFFER,OUTLINE=CANYON_OUTLINES, OUT_COLOR=0, /ADD_BATHY, /ADD_LONLAT, /ADD_COLORBAR, ADD_PIONEER=0, /ADD_BOARDER
     ENDIF
        
    IF KEYWORD_SET(ANIMATIONS) THEN BEGIN
     ; ILLEX_VIEWER_ANIMATION, VERSTR, MAPP=MAPP, BUFFER=BUFFER, /ADD_CONTOURS, /ADD_COLORBAR, /ADD_DATEBAR, /ADD_BATHY, /ADD_LONLAT, /ADD_BOARDER;, OUTCOLOR=0
      YR = VERSTR.INFO.YEAR
      MONTHS = YEAR_MONTH_RANGE(DR[0],DR[1]) 
      DPM = DATE_PARSE(MONTHS)
      IF N_ELEMENTS(MONTHS) LE 1 THEN CONTINUE
      DATERANGES = LIST(GET_DATERANGE(MONTHS[M]+'01',MONTHS[M]+DAYS_MONTH(DPM[M].MONTH,/STRING))) ; LIST(GET_DATERANGE(VERSTR.INFO.YEAR))
      FOR M=1, N_ELEMENTS(MONTHS)-1 DO DATERANGES.ADD,GET_DATERANGE(MONTHS[M]+'01',MONTHS[M]+DAYS_MONTH(DPM[M].MONTH,/STRING))
      IF DP.DAY EQ '01' THEN DATERANGES.ADD, GET_DATERANGE(VERSTR.INFO.YEAR) ; Only do the complete daterange at the beginning of the month 
      PROJECT_COMPOSITE_ANIMATION, VERSTR, /WEEKS, EXTENSIONS=['webm'],BUFFER=BUFFER, FRAMES=2, /ADD_COLORBAR, /ADD_BATHY, /ADD_LONLAT,/ADD_BORDER;, OUTCOLOR=0

      FOR D=0, N_ELEMENTS(DATERANGES)-1 DO BEGIN
        DTR = DATERANGES[D]
        IF DATE_2JD(DTR[0]) GT DATE_NOW(/JD) THEN CONTINUE
        PROJECT_MAKE_ANIMATION, VERSTR, DATERANGE=DTR,MAPP=MAPP, BUFFER=BUFFER,OUTLINE=CANYON_OUTLINES, /ADD_CONTOURS, /ADD_COLORBAR, /ADD_DATEBAR, /ADD_BATHY, /ADD_LONLAT, /ADD_BORDER, OUTCOLOR=0
      ENDFOR
    ENDIF
    
    IF KEYWORD_SET(SUBAREA_EXTRACTS) THEN BEGIN
  ;    ILLEX_SUBAREA_EXTRACT, VERSTR, PERIOD=['W','WEEK','M','MONTH'],FILETYPE=['STATS','ANOMS'], DATERANGE=['2000','2024']
  ;    ILLEX_SUBAREA_PLOTS, VERSTR, DATERANGE=['2023']
    ENDIF
    


    
;      BATCH_L3, BATCH_DATERANGE=DR,DO_GLOBCOLOUR='Y[GLOBCOLOUR;P=CHLOR_A-GSM]',DO_MAKE_PRODS='Y[GLOBCOLOUR]',DO_STATS='Y[GLOBCOLOUR;P=CHLOR_A-GSM;PER=W.M;M=L3B4]',DO_ANOMS='Y[GLOBCOLOUR;P=CHLOR_A-GSM;PER=WM]', DO_FRONTS='Y[GLOBCOLOUR]',DO_STAT_FRONTS='Y[GLOBCOLOUR;PER=W.M]'
;      BATCH_L3, BATCH_DATERANGE=DR,DO_GHRSST='Y[MUR;M=L3B2.L3B4]',DO_STATS='Y[MUR;PER=W.M]',DO_ANOMS='Y[MUR;PER=WM]',DO_FRONTS='Y[MUR;M=L3B2]',DO_STAT_FRONTS='Y[MUR;PER=W.M]'
;      BATCH_L3, BATCH_DATERANGE=DR,DO_STATS='Y[GLOBCOLOUR;P=PSIZET.PHYPERT;PER=M;M=L3B4]'
;      
      

    
       
;    IF KEYWORD_SET(MAKE_COMPOSITES) THEN ILLEX_VIEWER_COMPOSITE, VERSTR, /WEEKS, BUFFER=1,OUTLINE=CANYON_OUTLINES, OUT_COLOR=0, /ADD_BATHY, /ADD_LONLAT, /ADD_COLORBAR, /ADD_PIONEER, /ADD_BOARDER
;      
;    IF KEYWORD_SET(SST_ANIMATION) THEN ILLEX_VIEWER_SST_ANIMATION, VERSTR, MAPP=MAPP, BUFFER=1, /ADD_CONTOURS, /ADD_COLORBAR, /ADD_DATEBAR, /ADD_BATHY, /ADD_LONLAT, /ADD_BOARDER;, OUTCOLOR=0
;    
;    
;    IF KEYWORD_SET(EVENTS) THEN BEGIN
;      ILLEX_VIEWER_EVENTS, 'SIRATES_2022', BUFFER=0
;    ;  ILLEX_VIEWER_EVENTS, 'WCR_20210608', BUFFER=0
;    ;  ILLEX_VIEWER_EVENTS, 'UPWELLING_202207', BUFFER=1
;    ;  ILLEX_VIEWER_EVENTS, 'SMALL_SQUID_202207', BUFFER=1
;    ENDIF ; EVENTS
;    
;    
;
;    IF KEYWORD_SET(JC_ANIMATION) THEN BEGIN
;
;      DIR_JC = VERSTR.DIRS.DIR_PROJECT + 'images' + SL + 'jc_charts' + SL
;      FILES = FILE_SEARCH(DIR_JC + 'jc_2022*.png')
;      MFILE = VERSTR.DIRS.DIR_ANIMATIONS + '2022-JENIFER_CLARK_CHARTS'
;      EXT = ['webm'] ; 'mov','mp4',
;      ;      FOR E=0, N_ELEMENTS(EXT)-1 DO BEGIN
;      ;        FPS = 5
;      ;        MOVIE_FILE = MFILE + '-FPS_'+ROUNDS(FPS)+'.'+EXT[E]
;      ;        IF FILE_MAKE(FILES,MOVIE_FILE,OVERWRITE=OVERWRITE) EQ 0 THEN CONTINUE
;      ;        MAKE_MOVIE, FILES, MOVIE_FILE=MOVIE_FILE, FRAME_SEC=FPS
;      ;      ENDFOR
;
;      FOR F=0, N_ELEMENTS(FILES)-1 DO BEGIN
;        IMG = READ_IMAGE(FILES[F])
;        PRINT, SIZE(IMG)
;      ENDFOR
;
;      STOP
;    ENDIF
;    
    IF KEYWORD_SET(GIT_PUSH) THEN BEGIN
      
      COUNTER = 0
      WHILE COUNTER LT 2 DO BEGIN
        COUNTER = COUNTER + 1
      
        ; ===> Change directory
        cd, DIR_PROJECT
  
        ; ===> Check the version control status
        CMD = "git status"
        SPAWN, CMD, LOG, EXIT_STATUS=ES
        PLUN, LUN, LOG
        IF ES EQ 1 THEN GOTO, GIT_ERROR
        IF ~HAS(LOG, 'nothing to commit') THEN BEGIN
          
          ; ===> Add the files to git
          CMD = "git add ."
          SPAWN, CMD, LOG, EXIT_STATUS=ES
          PLUN, LUN, LOG
          IF ES EQ 1 THEN GOTO, GIT_ERROR
          
          ; ===> Commit the files to git
          COMMIT_MSG = ' Illex viewer update - ' + NUM2STR(DATE_NOW(/DATE_ONLY))
          CMD = "git commit -m '" + COMMIT_MSG + "'" 
          SPAWN, CMD, LOG, EXIT_STATUS=ES
          PLUN, LUN, LOG
          IF ES EQ 1 THEN GOTO, GIT_ERROR
        ENDIF  
  
        ; ===> Push the files to GitHub
        CMD = "git push"
        SPAWN, CMD, LOG, EXIT_STATUS=ES
        PLUN, LUN, LOG
        IF ES EQ 1 THEN GOTO, GIT_ERROR
  
        ; ===> Double check the Git Status
        CMD = "git status"
        SPAWN, CMD, LOG, EXIT_STATUS=ES
        IF LOG[1] EQ "Your branch is up to date with 'origin/main'." AND LOG[3] EQ "nothing to commit, working tree clean" THEN BREAK

      ENDWHILE
      
      GIT_ERROR:
      IF ES EQ 1 THEN BEGIN
        MESSAGE, 'ERROR: Unable to complete git steps and upload files'
      ENDIF ELSE BEGIN
        MAILTO = 'kimberly.hyde@noaa.gov'
        CMD = 'echo "Illex Viwer composites and animations uploaded to GitHub ' + SYSTIME() + '" | mailx -s "Illex composites ' + SYSTIME() + '" ' + MAILTO
        IF KEYWORD_SET(EMAIL) THEN SPAWN, CMD
      ENDELSE
            
    ENDIF
      
; STOP   
;    DT = '20210608' & TITLE='2021-06-08'
;    F = GET_FILES('MUR',PRODS='SST',DATERANGE=[DT,DT])
;    PNGFILE = VERSTR.DIRS.DIR_PNGS + 'D_'+DT+'-MUR-SST-WCR-FISHING.PNG'
;    OPROD = 'SST_5_30'
;    PAL = VERSTR.PROD_INFO.SST.PAL
;    OVERWRITE = 0
;    IF FILE_MAKE(F,PNGFILE,OVERWRITE=OVERWRITE) EQ 1 THEN BEGIN
;
;      PIONEER = VERSTR.DIRS.DIR_FILES + 'PIONEER_ARRAY_COORDINATES.csv'
;      PDATA = CSV_READ(PIONEER)
;      MP = 'NWA'
;      MR = MAPS_READ(MP)
;      IMG_DIMS  = FLOAT(STRSPLIT(MR.IMG_DIMS,';',/EXTRACT)) & MX = IMG_DIMS[0] & MY = IMG_DIMS[1]
;      XX = MX/MR.PX & YY = MY/MR.PY
;      MAPS_SET, MP
;      LL = MAP_DEG2IMAGE(MAPS_BLANK(MP),PDATA.LON,PDATA.LAT,X=X,Y=Y)
;      ZWIN
;
;      FISHING = VERSTR.DIRS.DIR_FILES + 'study_fleet_observer_fishing_points_2020.csv'
;      FDATA = CSV_READ(FISHING)
;      MAPS_SET, MP
;      LL = MAP_DEG2IMAGE(MAPS_BLANK(MP),FLOAT(FDATA.LON),FLOAT(FDATA.LAT),X=XF,Y=YF)
;      ZWIN
;
;      RTHICK=2
;      RCOLOR='BLACK'
;
;  ;    W = WINDOW(DIMENSIONS=IMG_DIMS)
;      PRODS_2PNG, F, PROD=OPROD, MAPP='NWA', CROP=[150,1200,600,1250], /CURRENT, OBJ=IMG, ADD_BATHY=200, C_LEVELS=[20,24], C_COLOR=249, C_THICK=2, C_ANNOTATION=[' ',' ']
;      TD = TEXT(0.22,0.965, TITLE, FONT_SIZE=20, FONT_STYLE='BOLD', FONT_COLOR='BLACK', ALIGNMENT=0.5)
;      E1 = ELLIPSE(.22,.27,MAJOR=.025,MINOR=.048,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E2 = ELLIPSE(.28,.31,MAJOR=.025,MINOR=.048,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E3 = ELLIPSE(.40,.40,MAJOR=.050,MINOR=.095,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E4 = ELLIPSE(.48,.46,MAJOR=.028,MINOR=.057,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E5 = ELLIPSE(.59,.46,MAJOR=.072,MINOR=.114,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E6 = ELLIPSE(.64,.62,MAJOR=.025,MINOR=.035,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E7 = ELLIPSE(.70,.64,MAJOR=.025,MINOR=.035,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0)
;      E8 = ELLIPSE(.78,.52,MAJOR=.040,MINOR=.084,THICK=RTHICK,COLOR=RCOLOR,TARGET=IMG,FILL_BACKGROUND=0,THETA=16)
;      CBAR, OPROD, OBJ=IMG, FONT_SIZE=14, FONT_STYLE=FONT_STYLE, CB_TYPE=3, CB_POS=[0.02,0.92,0.46,0.96], CB_TITLE=UNITS('SST');, PAL=PAL
;
;
;      SY = SYMBOL((XF-150),(YF-600),SYMBOL='CIRCLE',/DEVICE, /SYM_FILLED, SYM_COLOR='PURPLE', SYM_SIZE=0.75)
;
;      A = TEXT(180,200,'Mid-Atlantic',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ORIENTATION=50) ; TM = TEXT(310,540,'MAB',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      B = TEXT(350,350,'Southern!CNew England', FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ALIGNMENT=0.5) ; TB = TEXT(650,650,'GB', FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      C = TEXT(480,380,'Georges!CBank', FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ALIGNMENT=0.5) ; TB = TEXT(650,650,'GB', FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      D = TEXT(430,500,'Gulf of!CMaine',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ALIGNMENT=0.5) ; TM = TEXT(590,810,'GOM',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      E = TEXT(220,80, 'Gulf Stream',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ORIENTATION=30) ; TM = TEXT(590,810,'GOM',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      F = TEXT(310,240,'Slope !CSea',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ALIGNMENT=0.5) ; TM = TEXT(590,810,'GOM',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE)
;      G = TEXT(625,285,'Warm Core !CRing',FONT_SIZE=FSZ,FONT_STYLE='BOLD',COLOR=FC,/DEVICE,ALIGNMENT=0.5)
;      stop
;
;      IMG.SAVE, PNGFILE
;      IMG.CLOSE
;    ENDIF
    
    
  ENDFOR  
  


END ; ***************** End of ILLEX_VIEWER_IMAGES_MAIN *****************
