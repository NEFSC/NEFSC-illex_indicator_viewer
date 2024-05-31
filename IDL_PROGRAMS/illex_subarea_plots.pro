; $ID:	ILLEX_SUBAREA_PLOTS.PRO,	2023-09-19-09,	USER-KJWH	$
  PRO ILLEX_SUBAREA_PLOTS, VERSTR, PRODS=PRODS, DATASETS=DATASETS, MAP_IN=MAP_IN, SHAPEFILE=SHAPEFILE, SUBAREAS=SUBAREAS, DATERANGE=DATERANGE, $
  PERIOD=PERIOD, FILETYPE=FILETYPE, OUTSTATS=OUTSTATS, DATFILE=DATFILE, DIR_DATA=DIR_DATA, DIR_OUT=DIR_OUT, VERBOSE=VERBOSE


;+
; NAME:
;   ILLEX_SUBAREA_PLOTS
;
; PURPOSE:
;   $PURPOSE$
;
; PROJECT:
;   ILLEX_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_SUBAREA_PLOTS,$Parameter1$, $Parameter2$, $Keyword=Keyword$, ....
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
;   OUTPUT.......... Describe the output of this program or function
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
; Copyright (C) 2023, Department of Commerce, National Oceanic and Atmospheric Administration, National Marine Fisheries Service,
;   Northeast Fisheries Science Center, Narragansett Laboratory.
;   This software may be used, copied, or redistributed as long as it is not sold and this copyright notice is reproduced on each copy made.
;   This routine is provided AS IS without any express or implied warranties whatsoever.
;
; AUTHOR:
;   This program was written on June 30, 2023 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   Jun 30, 2023 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_SUBAREA_PLOTS'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  VER = VERSTR.VERSION

  IF ~N_ELEMENTS(DIR_OUT)        THEN DIROUT    = VERSTR.DIRS.DIR_PLOTS + 'SUBAREA_PLOTS'    ELSE DIROUT  = DIR_OUT 
  IF ~N_ELEMENTS(PRODS)          THEN PRODS     = VERSTR.INFO.EXTRACT_PRODS
  IF ~N_ELEMENTS(PERIOD)         THEN DPERS     = VERSTR.INFO.EXTRACT_PERIODS   ELSE DPERS   = PERIOD
  IF ~N_ELEMENTS(FILETYPE)       THEN FILETYPES = ['STATS']                     ELSE FILETYPES=FILETYPE
  IF ~N_ELEMENTS(DATERANGE)      THEN DTR       = VERSTR.INFO.EXTRACT_DATERANGE ELSE DTR     = DATERANGE
  IF ~N_ELEMENTS(SHAPEFILE)      THEN SHPFILES  = TAG_NAMES(VERSTR.SHAPEFILES)  ELSE SHPFILES = SHAPEFILE
  IF ~N_ELEMENTS(DATAFILES)      THEN DATFILES  = VERSTR.INFO.DATAFILE          ELSE DATFILES = DATAFILES
  
  AX = DATE_AXIS([210001,210012],/MONTH,/FYEAR,STEP=1,/MID)
  
  FOR S=3, N_ELEMENTS(SHPFILES)-1 DO BEGIN
    SHPFILE = SHPFILES[S]
    FPS = FILE_PARSE(SHPFILE)
    IF HAS(FPS.NAME, 'NAFO') THEN CONTINUE
    DATFILE = DATFILES[WHERE(STRPOS(DATFILES,'-'+FPS.NAME+'-') GT 0,/NULL)]
    IF DATFILE EQ [] OR N_ELEMENTS(DATFILE) GT 1 THEN STOP
    DAT = IDL_RESTORE(DATFILE)
    
    IF ~N_ELEMENTS(SUBAREAS) THEN BEGIN
      OK = WHERE(TAG_NAMES(VERSTR.SHAPEFILES) EQ SHPFILE,COUNT_SHP)
      IF COUNT_SHP EQ 1 THEN NAMES = VERSTR.SHAPEFILES.(OK).SUBAREA_NAMES ELSE NAMES = []
    ENDIF ELSE NAMES = SUBAREAS
   
    DFILES = []
    FOR A=0, N_ELEMENTS(PRODS)-1 DO BEGIN
      APROD = PRODS[A]  
      CASE APROD OF
        'PHYSIZE': BEGIN & DPRODS=PHYSIZE_PRODS & END
        ELSE:      BEGIN & DPRODS=''            & END
      ENDCASE
      TPRODS = DPRODS
  
      EFILES = []
      FOR D=0, N_ELEMENTS(DPRODS)-1 DO BEGIN
        DPROD = DPRODS[D]
        IF DPROD EQ '' THEN POK = WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ APROD,/NULL) ELSE POK = WHERE(TAG_NAMES(VERSTR.PROD_INFO) EQ DPROD,/NULL)
        PSTR = VERSTR.PROD_INFO.(POK)
        DPRD = PSTR.PROD
        DSET = PSTR.DATASET
        TSET = PSTR.TEMP_DATASET
        DIR_EXTRACT = DIROUT + DSET + SL & DIR_TEST, DIR_EXTRACT
        DTR = GET_DATERANGE(DTR)
        YRS = YEAR_RANGE(DTR,/STRING)
        
        ALG = VALIDS('ALGS',PSTR.PROD) ;& TALG = VALIDS('ALGS',PSTR.TEMP_PROD)
        CASE VALIDS('PRODS',DPRD) OF
          'CHLOR_A': BEGIN & YTITLE=UNITS('CHLOROPHYLL') & YRNG=[0.0,1.6] & PSTATS='MED' & END
          'SST':     BEGIN & YTITLE=UNITS('TEMPERATURE') & YRNG=[0.0,30] & PSTATS='MEAN' & END
        ENDCASE
        
        FOR R=0, N_ELEMENTS(DPERS)-1 DO BEGIN
          APER = DPERS[R]
          PR = PERIODS_READ(APER)
          IF PR.CLIMATOLOGY EQ 1 THEN CONTINUE
          CASE APER OF
            'W': BEGIN & NDATES = 52 & CPER = 'WEEK' & END
            'M': BEGIN & NDATES = 12 & CPER = 'MONTH' & END
          ENDCASE
          
          PNGFILE = DIROUT + APER + '-' + SHPFILE + '-' + DPROD + '-' + 'TIMESERIES.png'
          IF FILE_MAKE(DATFILE,PNGFILE,OVERWRITE=OVERWRITE) EQ 0 THEN CONTINUE
          W = WINDOW(DIMENSIONS=[850,1100])
          T = TEXT(0.5,0.98,FPS.NAME,ALIGNMENT=0.5,FONT_SIZE=14,FONT_STYLE='BOLD',/NORMAL)
          LO = 0
          FOR N=0, N_ELEMENTS(NAMES)-1 DO BEGIN
            ANAME = NAMES[N]
            CSTR = DAT[WHERE(DAT.PERIOD_CODE EQ CPER AND DAT.SUBAREA EQ ANAME AND DAT.PROD EQ APROD)]
            CDATE = DATE_2JD(YDOY_2DATE('2100',DATE_2DOY(PERIOD_2DATE(CSTR.PERIOD))))
            CDATA = GET_TAG(CSTR,PSTATS) & ADATA = CDATA & BDATA = CDATA
            CPLT=PLOT(CDATE,CDATA,LAYOUT=[1,N_ELEMENTS(NAMES),N+1],XRANGE=AX.JD,YRANGE=YRNG,XTICKNAME=AX.TICKNAME,XTICKVALUES=AX.TICKV,XMINOR=0,XSTYLE=1,YMAJOR=YMAJOR,YTICKV=YTICKS,YTITLE=YTITLES,MARGIN=[0.13,0.05,0.05,0.07],/CURRENT)
            FOR Y=0, N_ELEMENTS(YRS)-1 DO BEGIN
              YR = YRS[Y]
              CASE YR OF
                '2024': CLR = 'BLUE'
                '2023': CLR = 'ORANGE'
                '2022': CLR = 'CYAN'
                ELSE:   CLR = 'LIGHT_GREY'
              ENDCASE
              YSTR = DAT[WHERE(DAT.PERIOD_CODE EQ APER AND DATE_2YEAR(PERIOD_2DATE(DAT.PERIOD)) EQ YR AND DAT.SUBAREA EQ ANAME AND DAT.MATH EQ 'STACKED_STATS' AND DAT.PROD EQ APROD,/NULL)]
              IF YSTR EQ [] THEN CONTINUE
              YDATE = DATE_2JD(YDOY_2DATE('2100',DATE_2DOY(PERIOD_2DATE(YSTR.PERIOD))))
              YDATA = GET_TAG(YSTR,PSTATS)
              YPLT=PLOT(YDATE,YDATA,/OVERPLOT,COLOR=CLR)
            ENDFOR ; YEARS
            LO = LO + 1
          ENDFOR ; NAMES     
        W.CLOSE
        ENDFOR ; PERIODS
      ENDFOR ; DPRODS
    ENDFOR ; PRODS
  ENDFOR ; SHAPEFILES
        


END ; ***************** End of ILLEX_SUBAREA_PLOTS *****************
