; $ID:	ILLEX_VIEWER_VERSION.PRO,	2022-08-08-09,	USER-KJWH	$
  FUNCTION ILLEX_VIEWER_VERSION, VERSION

;+
; NAME:
;   ILLEX_VIEWER_VERSION
;
; PURPOSE:
;   Get the version specific information for the various ILLEX_VIEWER_INDICATORS functions
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   Result = ILLEX_VIEWER_VERSION()
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
;   Aug 15, 2022 - KJHW: Added LOGS directory
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_VIEWER_VERSION'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  IF NONE(VERSION) THEN VERSION = ['V2023']                       ; Each year, add the next version
  YEAR = DATE_NOW(/YEAR)
  VSTR = []                                                       ; Create a null variable for the version structure
  ; ===> Loop throug the version
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    
    ; ===> Make the project directories
    DIR_PRO = !S.ILLEX_VIEWER
    DIR_FILES = DIR_PRO + 'FILES' + SL
    DIR_VER = DIR_PRO + 'IDL_OUTPUTS' + SL + VER + SL
    DIRNAMES = ['EXTRACTS','EVENTS','PNGS','PLOTS','ANIMATIONS','COMPOSITES','LOGS','NETCDF','COMP_ANIMATIONS'] 
    DNAME = 'DIR_'  + DIRNAMES                                                                      ; The tag name for the directory in the structure
    DIRS  = DIR_VER + DIRNAMES + SL                                                                 ; The actual directory name
    DIR_TEST, DIRS                                                                                  ; Make the output directories if they don't already exist
    DSTR = CREATE_STRUCT('DIR_PROJECT',DIR_PRO,'DIR_FILES',DIR_FILES,'DIR_VERSION',DIR_VER)                               ; Create the directory structure
    FOR D=0, N_ELEMENTS(DIRS)-1 DO DSTR=CREATE_STRUCT(DSTR,DNAME[D],DIRS[D])                        ; Add each directory to the structure

    ; ===> Default product information
    DOWNLOAD_PRODS = ['SST','CHLOR_A'];,'SEALEVEL','OCEAN']
    PROCESS_PRODS = ['SST','CHLOR_A'] ; ,'SEALEVEL','OCEAN'

    CHL_DATASET = 'GLOBCOLOUR' & CHL_ALG = 'GSM' & CHL_TEMP = 'GLOBCOLOUR'
    SST_DATASET  = 'MUR' & SST_TEMP = 'MUR'
    MAP_OUT  = 'NES'                                                                            ; The map to be used for any plots
    SHPFILE  = 'NAFO_SHELFBREAK_40KM'                                 ; The shapefile for any data extractions or image outlines
    PRODS = ['CHLOR_A','SST','GRAD_CHL','GRAD_SST','SEALEVEL','OCEAN','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
    STAT_PERIODS = ['W','WEEK','M','MONTH']
    STAT_TEMP_PERIODS = ['W','M']
    ANOM_PERIODS=['W','M']
    PNG_PRODS = ['CHLOR_A','SST'];,'GRAD_CHL','GRAD_SST']
    PNG_PERIODS = ['W']
    NETCDF_PRODS = PNG_PRODS
    NETCDF_PERIODS = ['D','W','M']
    ANIMATION_PRODS = ['SST','CHLOR_A']
    ANIMATION_PERIOD = ['D']
    FRONT_PRODS = ['GRAD_SST','GRAD_CHL']
    EXTRACT_PRODS = ['CHLOR_A','SST','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
    EXTRACT_PERIODS = ['W','WEEK','M','MONTH']
    EXTRACT_DATERANGE = ['1998',YEAR]
    CHL_DATASET = 'GLOBCOLOUR' & CHL_ALG = 'GSM' & CHL_TEMP = 'GLOBCOLOUR'
    SLA_DATASET = 'CMES' & SLA_TEMP = 'CMES'
    OCN_DATASET = 'CMES' & OCN_TEMP = 'CMES'
    GRADCHL_DATASET = 'OCCCI' & GC_TEMP='GLOBCOLOUR' & GCHL_ALG = 'BOA'
    GRADSST_DATASET = 'MUR' & GS_TEMP='MUR' & GSST_ALG = 'BOA'
    PSZ_DATASET = 'OCCCI' & PSZ_TEMP = ''
    TEMP_PRODS = ['CHLOR_A','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
    PSZ_DATASET = 'OCCCI' & PSZ_TEMP = 'GLOBCOLOUR' & PSZ_ALG = 'TURNER'
    GRID_PERIOD = 'W'

   
    ; ===> Change the specific product information based on the version
    CASE VER OF
     
     'V2023': BEGIN
        ILLEX_YR = '2024'
        SST_DATASET  = 'ACSPO
        SST_TEMP = 'ACSPONRT'
        GRADSST_DATASET = 'ACSPO'  & GS_TEMP='ACSPONRT'
        PROCESS_PRODS = ['SST','CHLOR_A'] ; ,'SEALEVEL','OCEAN'
        EXTRACT_PRODS = ['CHLOR_A','SST']
        SHPFILE  = ['ECOMON4','NES_EPU_NOESTUARIES','NAFO_SHELFBREAK_40KM','NAFO_SHELFBREAK','SHELFBREAK_20KM','SHELFBREAK_40KM']                                 ; The shapefile for any data extractions or image outlines
        COMP_ANIMATION_PRODS = LIST(['SST','CHLOR_A'],'CHLOR_A','SST')
        
      
      END
      'V2022': BEGIN                                                                                ; V2022 specific information
        YEAR = '2022'                                                                           ; The current year
        
        
        
      END
    ENDCASE ; VER
    
    DATFILE = DSTR.DIR_EXTRACTS + VER + '-' + SHPFILE + '-COMPILED_DATA_FILE.SAV'

    FULL_DATERANGE = GET_DATERANGE(['1998',YEAR])
    DATERANGE = GET_DATERANGE('2022',DATE_NOW(/YEAR))                                                     ; The full date range of the current year
    PREVIOUS_DATERANGE = GET_DATERANGE(ILLEX_YR-1)                                                  ; The date range of the previous year

    HSTR = []
    FOR S=0, N_ELEMENTS(SHPFILE)-1 DO BEGIN
      SHPS = READ_SHPFILE(SHPFILE[S], MAPP=MAP_OUT)
      SUBAREAS = TAG_NAMES(SHPS) & SUBAREAS = SUBAREAS[WHERE(SUBAREAS NE 'OUTLINE' AND SUBAREAS NE 'MAPPED_IMAGE')]
      OUTLINE = []
      SUBAREA_TITLES = []
      FOR F=0, N_ELEMENTS(SUBAREAS)-1 DO BEGIN
        POS = WHERE(TAG_NAMES(SHPS) EQ STRUPCASE(SUBAREAS[F]),/NULL)
        OUTLINE = [OUTLINE,SHPS.(POS).OUTLINE]
        TITLE = SHPS.(POS).SUBAREA_TITLE
        SUBAREA_TITLES = [SUBAREA_TITLES,TITLE]
      ENDFOR
      STR = CREATE_STRUCT('MAP_OUT',MAP_OUT,'SHAPEFILE',SHPFILE, 'SUBAREA_NAMES',SUBAREAS,'SUBAREA_TITLES',SUBAREA_TITLES,'SUBAREA_OUTLINE',OUTLINE)
      HSTR = CREATE_STRUCT(HSTR,SHPFILE[S],STR) 
    ENDFOR  
    
    RESOLUTION=300
    
    ISTR = CREATE_STRUCT('DATAFILE',DATFILE,'YEAR',ILLEX_YR,'DATERANGE',DATERANGE,'PREVIOUS_DATERANGE',PREVIOUS_DATERANGE,'FULL_DATERANGE',FULL_DATERANGE,'MAP_OUT',MAP_OUT,'RESOLUTION',RESOLUTION, $
      'STAT_PERIODS',STAT_PERIODS,'STAT_TEMP_PERIODS',STAT_TEMP_PERIODS,'ANOM_PERIODS',ANOM_PERIODS,'PNG_PRODS',PNG_PRODS,'PNG_PERIODS',PNG_PERIODS,'ANIMATION_PRODS',ANIMATION_PRODS,'ANIMATION_PERIOD',ANIMATION_PERIOD,'COMP_ANIMATION_PRODS',COMP_ANIMATION_PRODS,$
      'NETCDF_PRODS',NETCDF_PRODS,'NETCDF_PERIODS',NETCDF_PERIODS,'DOWNLOAD_PRODS',DOWNLOAD_PRODS,'PROCESS_PRODS',PROCESS_PRODS,'TEMP_PRODS',TEMP_PRODS,'FRONT_PRODS',FRONT_PRODS,'EXTRACT_PRODS',EXTRACT_PRODS,'EXTRACT_PERIODS',EXTRACT_PERIODS,'EXTRACT_DATERANGE',EXTRACT_DATERANGE,'GRID_PERIOD',GRID_PERIOD)

    PSTR = []
    FOR P=0, N_ELEMENTS(PRODS)-1 DO BEGIN
      SPROD = PRODS[P]
      ATITLE = ''
      MONTH_SCALE = []
      CASE SPROD OF
        'CHLOR_A':  BEGIN & DTSET=CHL_DATASET & TPSET=CHL_TEMP & SPROD=SPROD+'-'+CHL_ALG & DWLPROD='CHL1' & PTAG='MED'   & PSCALE='CHLOR_A_0.1_10' & PAL='PAL_NAVY_GOLD'  & ASCALE='RATIO_0.1_10'    & APAL='PAL_BLUEGREEN_ORANGE' & ATITLE='Chlorophyll Anomaly (Ratio)' & END
        'SST':      BEGIN & DTSET=SST_DATASET & TPSET=SST_TEMP & SPROD=SPROD             & DWLPROD='' & PTAG='AMEAN' & PSCALE='SST_0_30'       & PAL='PAL_BLUERED'   & ASCALE='DIF_-5_5' & APAL='PAL_SUNSHINE_DIF' & ATITLE='SST Anomaly ' + UNITS('SST',/NO_NAME) 
                            MONTH_SCALE = CREATE_STRUCT('M01', 'SST_0_30',$
                                                      'M02', 'SST_0_30',$
                                                      'M03', 'SST_0_30',$
                                                      'M04', 'SST_5_30',$
                                                      'M05', 'SST_5_30',$
                                                      'M06', 'SST_5_30',$
                                                      'M07', 'SST_10_30',$
                                                      'M08', 'SST_15_30',$
                                                      'M09', 'SST_15_30',$
                                                      'M10', 'SST_10_30',$
                                                      'M11', 'SST_5_30',$
                                                      'M12', 'SST_5_30') 
          END        
        'SEALEVEL': BEGIN & DTSET=SLA_DATASET & TPSET=SLA_TEMP & SPROD=SPROD & DWLPROD='SEALEVEL_NRT' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'OCEAN':    BEGIN & DTSET=OCN_DATASET & TPSET=OCN_TEMP & SPROD=SPROD & DWLPROD='OCEAN_NRT'    & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'GRAD_CHL': BEGIN & DTSET=GRADCHL_DATASET & TPSET=GC_TEMP & SPROD=SPROD+'-'+GCHL_ALG & DWLPROD='' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'GRAD_SST': BEGIN & DTSET=GRADSST_DATASET & TPSET=GS_TEMP & SPROD=SPROD+'-'+GSST_ALG & DWLPROD='' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'MICRO_PERCENTAGE': BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='AMEAN' & PSCALE='NUM_0.0_1.0'    & PAL='PAL_DEFAULT'    & GSCALE=PSCALE            & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='NUM_0_0.8' & APAL='PAL_BLUEGREEN_ORANGE' & END
        'NANO_PERCENTAGE':  BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='AMEAN' & PSCALE='NUM_0.0_1.0'    & PAL='PAL_DEFAULT'    & GSCALE=PSCALE            & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='NUM_0_0.8' & APAL='PAL_BLUEGREEN_ORANGE' & END
        'PICO_PERCENTAGE':  BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='AMEAN' & PSCALE='NUM_0.0_1.0'    & PAL='PAL_DEFAULT'    & GSCALE=PSCALE            & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='NUM_0_0.8' & APAL='PAL_BLUEGREEN_ORANGE' & END
        'MICRO':            BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='MED'   & PSCALE='CHLOR_A_0.1_30' & PAL='PAL_NAVY_GOLD'  & GSCALE='CHLOR_A_0.03_3'  & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='CHLOR_A_0.01_10' & APAL='PAL_BLUEGREEN_ORANGE' & END
        'NANO':             BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='MED'   & PSCALE='CHLOR_A_0.1_30' & PAL='PAL_NAVY_GOLD'  & GSCALE='CHLOR_A_0.03_3'  & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='CHLOR_A_0.01_10' & APAL='PAL_BLUEGREEN_ORANGE' & END
        'PICO':             BEGIN & DTSET=PSZ_DATASET & TPSET=PSZ_TEMP & SPROD=SPROD+'-'+PSZ_ALG & TPROD=SPROD                  & PTAG='MED'   & PSCALE='CHLOR_A_0.1_30' & PAL='PAL_NAVY_GOLD'  & GSCALE='CHLOR_A_0.03_3'  & GPAL='PAL_DEFAULT' & ASCALE='DIF_-5_5' & IMSCALE='CHLOR_A_0.01_10' & APAL='PAL_BLUEGREEN_ORANGE' & END

      ENDCASE ; SPROD
      STR = CREATE_STRUCT('DATASET',DTSET,'TEMP_DATASET',TPSET,'PROD',SPROD,'DOWNLOAD_PROD',DWLPROD,'PLOT_TAG',PTAG,'PROD_SCALE',PSCALE,'PAL',PAL,'ANOM_SCALE',ASCALE,'ANOM_PAL',APAL,'ANOM_TITLE',ATITLE)
      IF MONTH_SCALE NE [] THEN STR = CREATE_STRUCT(STR,'MONTH_SCALE',MONTH_SCALE)
      PSTR = CREATE_STRUCT(PSTR,PRODS[P],STR) 
    ENDFOR ; PRODS
    STR = CREATE_STRUCT('VERSION',VER,'INFO',ISTR,'DIRS',DSTR,'PROD_INFO',PSTR,'SHAPEFILES',HSTR)
    IF N_ELEMENTS(VERSION) EQ 1 THEN RETURN, STR
    VSTR = CREATE_STRUCT(VSTR,VER,STR)
  ENDFOR ; VERSION 
    

END ; ***************** End of ILLEX_VIEWER_INDICATORS_VERSION_INFO *****************
