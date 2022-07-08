; $ID:	ILLEX_WEEKLY_INDICATORS_VERSION_INFO.PRO,	2022-05-05-12,	USER-KJWH	$
  FUNCTION ILLEX_WEEKLY_VERSION, VERSION

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
    DIR_PRO = !S.ILLEX_INDICATOR_VIEWER
    DIR_VER = DIR_PRO + VER + SL
    DIRNAMES = ['FILES','EXTRACTS','PNGS','ANIMATIONS','COMPOSITES'] 
    DNAME = 'DIR_'  + DIRNAMES                                                                      ; The tag name for the directory in the structure
    DIRS  = DIR_VER + DIRNAMES + SL                                                                 ; The actual directory name
    DIR_TEST, DIRS                                                                                  ; Make the output directories if they don't already exist
    DSTR = CREATE_STRUCT('DIR_PROJECT',DIR_PRO,'DIR_VERSION',DIR_VER)                               ; Create the directory structure
    FOR D=0, N_ELEMENTS(DIRS)-1 DO DSTR=CREATE_STRUCT(DSTR,DNAME[D],DIRS[D])                        ; Add each directory to the structure

    ; ===> Get the VERSION specific product information
    CASE VER OF
      'V2022': BEGIN                                                                                ; V2022 specific information
        ILLEX_YR = '2022'                                                                           ; The current year
        DATERANGE = ['20220101','20221231']                                                         ; The full date range of the current year
        PREVIOUS_DATERANGE = ['202100101','20211231']                                               ; The date range of the previous year
        FULL_DATERANGE = ['1998','2022']
        MAP_OUT  = 'NES'                                                                            ; The map to be used for any plots
        SHPFILE  = 'NAFO_SHELFBREAK_40KM'                                 ; The shapefile for any data extractions or image outlines
        PRODS = ['CHLOR_A','SST','GRAD_CHL','GRAD_SST','SEALEVEL','OCEAN','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
        DOWNLOAD_PRODS = ['CHLOR_A','SST','SEALEVEL','OCEAN']
        PNG_PRODS = ['CHLOR_A','SST'];,'GRAD_CHL','GRAD_SST']
        PNG_PERIODS = ['W']
        FRONT_PRODS = ['GRAD_SST','GRAD_CHL']
        EXTRACT_PRODS = ['CHLOR_A','SST','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
        EXTRACT_PERIODS = ['W','WEEK','M','MONTH']
        CHL_DATASET = 'GLOBCOLOUR' & CHL_ALG = 'GSM' & CHL_TEMP = 'GLOBCOLOUR'
        SST_DATASET  = 'MUR' 
        SLA_DATASET = 'CMES' & SLA_TEMP = 'CMES'
        OCN_DATASET = 'CMES' & OCN_TEMP = 'CMES'
        GRADCHL_DATASET = 'GLOBCOLOUR' & GC_TEMP='GLOBCOLOUR' & GCHL_ALG = 'BOA'
        GRADSST_DATASET = 'MUR' & GS_TEMP='GLOBCOLOUR' & GSST_ALG = 'BOA'
        PSZ_DATASET = 'OCCCI' & PSZ_TEMP = ''
        
        
        TEMP_PRODS = ['CHLOR_A','MICRO','NANO','PICO',['MICRO','NANO','PICO']+'_PERCENTAGE']
       ; STACKED_PRODS = LIST(['CHLOR_A','PPD'],['CHLOR_A','MICRO','PPD'],['CHLOR_A','MICRO_PERCENTAGE','PPD'],['MICRO','NANO','PICO'],['MICRO','NANO','PICO']+'_PERCENTAGE')
       ; COMPOSITE_PRODS = LIST([['MICRO','NANO','PICO']],[['MICRO','NANO','PICO']+'_PERCENTAGE'])
       ; COMPOSITE_PERIODS = ['ANNUAL','MONTH','WEEK','A','W','M']
       ; MOVIE_PERIODS = ['WEEK','MONTH']
       ; CHL_DATASET = 'OCCCI' & CHL_TEMP = 'GLOBCOLOUR' & CHL_ALG = 'CCI' & CTEMP_ALG = 'GSM'
       ; PP_DATASET  = 'OCCCI' & PP_TEMP  = 'GLOBCOLOUR' & PP_ALG  = 'VGPM2'
        PSZ_DATASET = 'OCCCI' & PSZ_TEMP = 'GLOBCOLOUR' & PSZ_ALG = 'TURNER'
        SST_DATASET = 'MUR' & SST_TEMP = 'MUR'
        DATFILE = DSTR.DIR_EXTRACTS + VER + '-' + SHPFILE + '-COMPILED_DATA_FILE.SAV'
        GRID_PERIOD = 'W'
        
      END
    ENDCASE ; VER
    
    SHPS = READ_SHPFILE(SHPFILE, MAPP=MAP_OUT)
    SUBAREAS = TAG_NAMES(SHPS) & SUBAREAS = SUBAREAS[WHERE(SUBAREAS NE 'OUTLINE' AND SUBAREAS NE 'MAPPED_IMAGE')]
    OUTLINE = []
    SUBAREA_TITLES = []
    FOR F=0, N_ELEMENTS(SUBAREAS)-1 DO BEGIN
      POS = WHERE(TAG_NAMES(SHPS) EQ STRUPCASE(SUBAREAS[F]),/NULL)
      OUTLINE = [OUTLINE,SHPS.(POS).OUTLINE]
      TITLE = SHPS.(POS).SUBAREA_TITLE
      SUBAREA_TITLES = [SUBAREA_TITLES,TITLE]
    ENDFOR
    
    RESOLUTION=300
    
    ISTR = CREATE_STRUCT('DATAFILE',DATFILE,'ILLEX_YEAR',ILLEX_YR,'DATERANGE',DATERANGE,'PREVIOUS_DATERANGE',PREVIOUS_DATERANGE,'FULL_DATERANGE',FULL_DATERANGE,$
      'MAP_OUT',MAP_OUT,'SHAPEFILE',SHPFILE, 'SUBAREA_NAMES',SUBAREAS,'SUBAREA_TITLES',SUBAREA_TITLES,'SUBAREA_OUTLINE',OUTLINE,'RESOLUTION',RESOLUTION, $
      'PNG_PRODS',PNG_PRODS,'PNG_PERIODS',PNG_PERIODS,'DOWNLOAD_PRODS',DOWNLOAD_PRODS,'TEMP_PRODS',TEMP_PRODS,'FRONT_PRODS',FRONT_PRODS,'EXTRACT_PRODS',EXTRACT_PRODS,'EXTRACT_PERIODS',EXTRACT_PERIODS,'GRID_PERIOD',GRID_PERIOD)

    PSTR = []
    FOR P=0, N_ELEMENTS(PRODS)-1 DO BEGIN
      SPROD = PRODS[P]
      ATITLE = ''
      MONTH_SCALE = []
      CASE SPROD OF
        'CHLOR_A':  BEGIN & DTSET=CHL_DATASET & TPSET=CHL_TEMP & SPROD=SPROD+'-'+CHL_ALG & DWLPROD='CHL1' & PTAG='MED'   & PSCALE='CHLOR_A_0.01_10' & PAL='PAL_NAVY_GOLD'  & ASCALE='RATIO'    & APAL='PAL_BLUEGREEN_ORANGE' & ATITLE='Chlorophyll Anomaly (Ratio)' & END
        'SST':      BEGIN & DTSET=SST_DATASET & TPSET=SST_TEMP & SPROD=SPROD             & DWLPROD='' & PTAG='AMEAN' & PSCALE='SST_0_30'       & PAL='PAL_BLUERED'   & ASCALE='DIF_-5_5' & APAL='PAL_SUNSHINE_DIF' & ATITLE='SST Anomaly ' + UNITS('SST',/NO_NAME) 
                            MONTH_SCALE = CREATE_STRUCT('M01', 'SST_0_30',$
                                                      'M02', 'SST_0_30',$
                                                      'M03', 'SST_0_30',$
                                                      'M04', 'SST_5_30',$
                                                      'M05', 'SST_5_30',$
                                                      'M06', 'SST_10_30',$
                                                      'M07', 'SST_10_30',$
                                                      'M08', 'SST_15_30',$
                                                      'M09', 'SST_15_30',$
                                                      'M10', 'SST_10_30',$
                                                      'M11', 'SST_5_30',$
                                                      'M12', 'SST_5_30') 
          END        
        'SEALEVEL': BEGIN & DTSET=SLA_DATASET & TPSET=SLA_TEMP & SPROD=SPROD & DWLPROD='SEALEVEL_NRT' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'OCEAN':    BEGIN & DTSET=OCN_DATASET & TPSET=OCN_TEMP & SPROD=SPROD & DWLPROD='OCEAN_NRT'    & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'GRAD_CHL': BEGIN & DTSET=GRADCHL_DATASET & TPSET=GS_TEMP & SPROD=SPROD+'-'+GCHL_ALG & DWLPROD='' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
        'GRAD_SST': BEGIN & DTSET=GRADSST_DATASET & TPSET=GC_TEMP & SPROD=SPROD+'-'+GSST_ALG & DWLPROD='' & PTAG='' & PSCALE='' & PAL='' & ASCALE='' & APAL='' & END
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
    STR = CREATE_STRUCT('VERSION',VER,'INFO',ISTR,'DIRS',DSTR,'PROD_INFO',PSTR)
    IF N_ELEMENTS(VERSION) EQ 1 THEN RETURN, STR
    VSTR = CREATE_STRUCT(VSTR,VER,STR)
  ENDFOR ; VERSION 
    

END ; ***************** End of ILLEX_WEEKLY_INDICATORS_VERSION_INFO *****************
