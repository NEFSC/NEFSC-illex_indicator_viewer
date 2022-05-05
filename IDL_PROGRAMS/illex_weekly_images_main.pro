; $ID:	ILLEX_WEEKLY_IMAGES_MAIN.PRO,	2022-05-05-11,	USER-KJWH	$
  PRO ILLEX_WEEKLY_IMAGES_MAIN, VERSION, OUTPUT_MAP=OUTPUT_MAP, RESOLUTION=RESOLUTION, BUFFER=BUFFER, VERBOSE=VERBOSE, OVERWRITE=OVERWRITE

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
  
  ; ===> Manually adjust the SOE program steps as needed
  IF ~N_ELEMENTS(DOWNLOAD_FILES)      THEN DOWNLOAD_FILES      = ''
  IF ~N_ELEMENTS(PROCESS_FILES)       THEN PROCESS_FILES       = ''
  IF ~N_ELEMENTS(RUN_STATS)           THEN RUN_STATS      = ''
  IF ~N_ELEMENTS(MAKE_PNGS)           THEN MAKE_PNGS      = ''
  IF ~N_ELEMENTS(YEARLY_DIF)          THEN YEARLY_DIF       = ''
  IF ~N_ELEMENTS(ANOMALY)             THEN ANOMALY      = ''
  IF ~N_ELEMENTS(MAKE_COMPOSITES)     THEN MAKE_COMPOSITES = ''
  
  ; ===> Loop through versions
  FOR V=0, N_ELEMENTS(VERSION)-1 DO BEGIN
    VER = VERSION[V]
    VERSTR = SOE_VERSION_INFO(VER)
    
  ENDFOR  
  


END ; ***************** End of ILLEX_WEEKLY_IMAGES_MAIN *****************
