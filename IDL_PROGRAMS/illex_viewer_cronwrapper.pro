; $ID:	ILLEX_VIEWER_CRONWRAPPER.PRO,	2022-08-08-11,	USER-KJWH	$
  PRO ILLEX_VIEWER_CRONWRAPPER

;+
; NAME:
;   ILLEX_VIEWER_CRONWRAPPER
;
; PURPOSE:
;   Program to be called by the cronjob
;
; PROJECT:
;   ILLEX_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_VIEWER_CRONWRAPPER
;
; REQUIRED INPUTS:
;   None 
;
; OPTIONAL INPUTS:
;   TBD
;
; KEYWORD PARAMETERS:
;   TBD
;
; OUTPUTS:
;   Runs ILLEX_VIEWER_MAIN
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
;   This program was written on August 08, 2022 by Kimberly J. W. Hyde, Northeast Fisheries Science Center | NOAA Fisheries | U.S. Department of Commerce, 28 Tarzwell Dr, Narragansett, RI 02882
;    
; MODIFICATION HISTORY:
;   Aug 08, 2022 - KJWH: Initial code written
;-
; ****************************************************************************************************
  ROUTINE_NAME = 'ILLEX_VIEWER_CRONWRAPPER'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  DT = DATE_PARSE(DATE_NOW())
   
  LOGDIR = !S.ILLEX_VIEWER + 'IDL_OUTPUTS' + SL + 'LOGS' + SL & DIR_TEST, LOGDIR
  LOGFILE = LOGDIR + ROUTINE_NAME + '-' + DATE_NOW() + '.log'
  OPENW, LUN, LOGFILE, /APPEND, /GET_LUN, WIDTH=180 ;  ===> Open log file
  PLUN, LUN, '******************************************************************************************************************'
  PLUN, LUN, 'Starting ' + ROUTINE_NAME + ' log file: ' + LOGFILE + ' on: ' + systime() + ' on ' + !S.COMPUTER, 0
  
  PLUN, LUN, 'Running ILLEX_VIEWER_MAIN...'
  ILLEX_VIEWER_MAIN, VERSION, /LOGFILE, /DOWNLOAD_FILES, /PROCESS_FILES, /ANIMATIONS, /MAKE_COMPOSITES, EVENTS=0, SUBAREA_EXTRACTS=0, JC_ANIMATION=0, /GIT_PUSH, LOGLUN=LUN


END ; ***************** End of ILLEX_VIEWER_CRONWRAPPER *****************
