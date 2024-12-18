; $ID:	ILLEX_SUBAREA_EXTRACT.PRO,	2023-09-19-09,	USER-KJWH	$
  PRO ILLEX_SUBAREA_EXTRACT, VERSTR, PRODS=PRODS, DATASETS=DATASETS, MAP_IN=MAP_IN, SHAPEFILE=SHAPEFILE, SUBAREAS=SUBAREAS, DATERANGE=DATERANGE, $
  PERIOD=PERIOD, FILETYPE=FILETYPE, OUTSTATS=OUTSTATS, DATFILE=DATFILE, DIR_DATA=DIR_DATA, DIR_OUT=DIR_OUT, VERBOSE=VERBOSE

;+
; NAME:
;   ILLEX_SUBAREA_EXTRACT
;
; PURPOSE:
;   $PURPOSE$
;
; PROJECT:
;   ILLEX_INDICATORS
;
; CALLING SEQUENCE:
;   ILLEX_SUBAREA_EXTRACT,$Parameter1$, $Parameter2$, $Keyword=Keyword$, ....
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
; Copyright (C) 2022, Department of Commerce, National Oceanic and Atmospheric Administration, National Marine Fisheries Service,
;   Northeast Fisheries Science Center, Narragansett Laboratory.
;   This software may be used, copied, or redistributed as long as it is not sold and this copyright notice is reproduced on each copy made.
;   This routine is provided AS IS without any express or implied warranties whatsoever.
;
; AUTHOR:
;   This program was written on May 10, 2022 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   May 10, 2022 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_SUBAREA_EXTRACT'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  PHYSIZE_PRODS = [['MICRO','NANO','PICO']+'_PERCENTAGE','MICRO','NANO','PICO']

  VER = VERSTR.VERSION
  
  IF ~N_ELEMENTS(DIR_DATA)       THEN DIRDATA   = !S.DATASETS                 ELSE DIRDATA = DIR_DATA
  IF ~N_ELEMENTS(DIR_OUT)        THEN DIROUT    = VERSTR.DIRS.DIR_EXTRACTS    ELSE DIROUT  = DIR_OUT
  IF ~N_ELEMENTS(PRODS)          THEN PRODS     = VERSTR.INFO.EXTRACT_PRODS   
  IF ~N_ELEMENTS(PERIOD)         THEN DPERS     = VERSTR.INFO.EXTRACT_PERIODS ELSE DPERS   = PERIOD
  IF ~N_ELEMENTS(FILETYPE)       THEN FILETYPES = ['STATS']                   ELSE FILETYPES=FILETYPE
  IF ~N_ELEMENTS(DATERANGE)      THEN DTR       = VERSTR.INFO.DATERANGE       ELSE DTR     = DATERANGE
  IF ~N_ELEMENTS(SHAPEFILE)      THEN SHPFILES  = TAG_NAMES(VERSTR.SHAPEFILES)      ELSE SHPFILES = SHAPEFILE
;  IF ~N_ELEMENTS(MAP_IN)         THEN MAPIN     = VERSTR.INFO.MAP_IN          ELSE MAPIN   = MAP_IN

  FOR S=0, N_ELEMENTS(SHPFILES)-1 DO BEGIN
    SHPFILE = SHPFILES[S]
    
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
        FOR F=0, N_ELEMENTS(FILETYPES)-1 DO BEGIN
          ATYPE = FILETYPES[F]
          IF DIRDATA EQ !S.DATASETS THEN FILES = GET_FILES(DSET, PRODS=DPRD, PERIODS=DPERS, FILE_TYPE='STACKED_'+ATYPE, MAPS=MAPIN, VERSION=DVER, DATERANGE=DTR, COUNT=COUNT) $
                                    ELSE FILES = FILE_SEARCH(DIRDATA + DSET + SL + MAPIN + SL + 'STATS' + SL + DPRD + SL + [DPERS] + '*',COUNT=COUNT)
          IF FILES EQ [] THEN CONTINUE
          FP = PARSE_IT(FILES,/ALL)
          IF ~SAME(FP.MAP) THEN MESSAGE, 'ERROR: All input files must have the same map.'
          SAV = DIR_EXTRACT + ROUTINE_NAME + '-' +VER + '-' + STRJOIN(DPERS,'_') + '-' + DSET  + '-' + SHPFILE + '-' + FP[0].MAP + '-' + DPRD + '-' + ATYPE + '.SAV'
          SAV = REPLACE(SAV,['--','-.'],['-',''])
          SUBAREAS_EXTRACT, FILES, SHP_NAME=SHPFILE, SUBAREAS=NAMES, VERBOSE=VERBOSE, DIR_OUT=DIR_EXTRACT, STRUCT=STR, SAVEFILE=SAV, OUTPUT_STATS=OUTSTATS, /ADD_DIR
          EFILES = [EFILES,SAV]
        ENDFOR ; FILETYPE
      ENDFOR ; DPRODS
  
      DATFILE = DIROUT + STRJOIN(DTR,'_') + '-' + DSET + '-' + APROD + '-' + STRJOIN(FILETYPES,'_') + '-' + SHPFILE + '-' + VER +  '.SAV'
      DFILES = [DFILES,DATFILE]
      IF EFILES NE [] AND FILE_MAKE(EFILES,DATFILE,OVERWRITE=OVERWRITE) EQ 1 THEN BEGIN
        STRUCT = IDL_RESTORE(EFILES[0])
        FOR E=1, N_ELEMENTS(EFILES)-1 DO STRUCT = STRUCT_CONCAT(STRUCT,IDL_RESTORE(EFILES[E]))
        STRUCT = STRUCT_DUPS(STRUCT, TAGNAMES=['PERIOD','SUBAREA','PROD','ALG','MATH','MIN','MAX','MED']) ; Remove any duplicates
        SAVE, STRUCT, FILENAME=DATFILE ; ===> SAVE THE MERGED DATAFILE
        SAVE_2CSV, DATFILE
      ENDIF
  
    ENDFOR ; PRODS
    
    ; ===> Merge the product based DATFILE into a single combined DATAFILE
    DATAFILES = VERSTR.INFO.DATAFILE
    DFP = FILE_PARSE(DATAFILES)
    BRK = STR_BREAK(DFP.NAME,'-')
    OK = WHERE(BRK[*,1] EQ SHPFILE, COUNTDAT)
    IF COUNTDAT NE 1 THEN MESSAGE, 'ERROR: Unable to find the correct datafile name for ' + SHPFILE
    DATAFILE = DATAFILES[OK]
    IF ANY(DIR_DATA) THEN DATAFILE = REPLACE(DATAFILE,VERSTR.DIRS.DIR_EXTRACTS,DIROUT)
    IF DFILES NE [] AND FILE_MAKE(DFILES,DATAFILE,OVERWRITE=OVERWRITE) EQ 1 THEN BEGIN
      STRUCT = IDL_RESTORE(DFILES[0])
      FOR T=1, N_ELEMENTS(DFILES)-1 DO STRUCT = STRUCT_CONCAT(STRUCT,IDL_RESTORE(DFILES[T]))
      STRUCT = STRUCT_DUPS(STRUCT, TAGNAMES=['PERIOD','SUBAREA','PROD','ALG','MATH','MIN','MAX','MED'],SUBS=SUBS,DUPS_REMOVED=DUPS_REMOVED) ; Remove any duplicates
      SAVE, STRUCT, FILENAME=DATAFILE ; ===> SAVE THE MERGED DATAFILE
      SAVE_2CSV, DATAFILE
    ENDIF
    
    
  ENDFOR ; SHAPEFILES  

 




END ; ***************** End of ILLEX_SUBAREA_EXTRACT *****************
