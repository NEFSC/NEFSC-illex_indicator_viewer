; $ID:	ILLEX_WEEKLY_INDICATORS_VERSION_INFO.PRO,	2022-05-05-12,	USER-KJWH	$
  FUNCTION ILLEX_WEEKLY_INDICATORS_VERSION_INFO

;+
; NAME:
;   ILLEX_WEEKLY_INDICATORS_VERSION_INFO
;
; PURPOSE:
;   Get the version specific information for the various ILLEX_WEEKLY_INDICATORS functions
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   Result = ILLEX_WEEKLY_INDICATORS_VERSION_INFO()
;
; REQUIRED INPUTS:
;   None
;
; OPTIONAL INPUTS:
;   VERSION....... The name of the ILLEX version
;
; KEYWORD PARAMETERS:
;   None
;
; OUTPUTS:
;   OUTPUT.......... A structure containing version specific information 
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
  ROUTINE_NAME = 'ILLEX_WEEKLY_INDICATORS_VERSION_INFO'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  IF NONE(VERSION) THEN VERSION = ['V2022']                       ; Each year, add the next version

  VSTR = []                                                       ; Create a null variable for the version structure
  ; ===> Loop throug the version
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    
    ; ===> Make the project directories
    DIR_VER = !S.ILLEX_INDICATOR_VIEWER + VER + SL
    DNAME = 'DIR_'  + ['PNGS','COMPOSITES']                        ; The tag name for the directory in the structure
    DIRS  = DIR_VER + ['PNGS','COMPOSITES'] + SL  ; The actual directory name
    DIR_TEST, DIRS                                                                                  ; Make the output directories if they don't already exist
    DSTR = CREATE_STRUCT('DIR_VERSION',DIR_VER)                                                     ; Create the directory structure
    FOR D=0, N_ELEMENTS(DIRS)-1 DO DSTR=CREATE_STRUCT(DSTR,DNAME[D],DIRS[D])                        ; Add each directory to the structure

    ; ===> Get the VERSION specific product information
    CASE VER OF
      'V2022': BEGIN                                                                                ; V2022 specific information
        ILLEX_YR = '2022'                                                                           ; The current year
        DATERANGE = ['20220101','20221231']                                                         ; The full date range of the current year
        PREVIOUS_DATERANGE = ['202100101','20211231']                                               ; The date range of the previous year
        MAP_OUT  = 'NES'                                                                            ; The map to be used for any plots
        SHPFILE  = ''                                                            ; The shapefile for any data extractions or image outlines
        PRODS = ['CHLOR_A','SST','GRAD_CHL','GRAD_SST']
        CHL_DATASET = 'GLOBCOLOUR' & CHL_ALG = 'GSM'
        SST_DATASET  = 'MUR' 
        GRADCHL_DATASET = 'GLOBCOLOUR' & GCHL_ALG = 'BOA'
        GRADSST_DATASET = 'MUR' & GSST_ALG = 'BOA'
        GRID_PERIOD = 'W'
      END
    ENDCASE ; VER
    
    ISTR = CREATE_STRUCT('ILLEX_YEAR',ILLEX_YR,'DATERANGE',DATERANGE,'PREVIOUS_DATERANGE',PREVIOUS_DATERANGE,'MAP_OUT',MAP_OUT,'SHAPEFILE',SHPFILE)

    PSTR = []
    FOR P=0, N_ELEMENTS(PRODS)-1 DO BEGIN
      SPROD = PRODS[P]
      CASE SPROD OF
        'CHLOR_A':  BEGIN & DTSET=CHL_DATASET & SPROD=SPROD+'-'+CHL_ALG & PTAG='MED'   & PSCALE='CHLOR_A_0.1_30' & PAL='PAL_NAVY_GOLD'  & ASCALE='RATIO'    & APAL='PAL_BLUEGREEN_ORANGE' & END
        'SST':      BEGIN & DTSET=SST_DATASET & SPROD=SPROD             & PTAG='AMEAN' & PSCALE='SST_0_30'       & PAL='PAL_BLUE_RED'   & ASCALE='DIF_-5_5' & APAL='PAL_ANOM_BWR'    & END
        'GRAD_CHL': BEGIN & DTSET=GRADCHL_DATASET & SPROD=SPROD+'-'+GCHL_ALG & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'GRAD_SST': BEGIN & DTSET=GRADSST_DATASET & SPROD=SPROD+'-'+SCHL_ALG & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
      ENDCASE ; SPROD
      STR = CREATE_STRUCT('DATASET',DTSET,'PROD',SPROD,'PLOT_TAG',PTAG,'PROD_SCALE',PSCALE,'PAL',PAL,'ANOM_SCALE',ASCALE,'ANOM_PAL',APAL)
      PSTR = CREATE_STRUCT(PSTR,PRODS[P],STR)
    ENDFOR ; PRODS
    STR = CREATE_STRUCT('INFO',ISTR,'DIRS',DSTR,'PROD_INFO',PSTR)
    IF N_ELEMENTS(VERSION) EQ 1 THEN RETURN, STR
    VSTR = CREATE_STRUCT(VSTR,VER,STR)
  ENDFOR ; VERSION 
    

END ; ***************** End of ILLEX_WEEKLY_INDICATORS_VERSION_INFO *****************
