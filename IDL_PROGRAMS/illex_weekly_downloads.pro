; $ID:	ILLEX_WEEKLY_DOWNLOADS.PRO,	2022-05-05-12,	USER-KJWH	$
  PRO ILLEX_WEEKLY_DOWNLOADS, VERSTRUCT

;+
; NAME:
;   ILLEX_WEEKLY_DOWNLOADS
;
; PURPOSE:
;   Program to download files for the weekly Illex images
;
; PROJECT:
;   ILLEX_INDICATOR_VIEWER
;
; CALLING SEQUENCE:
;   ILLEX_WEEKLY_DOWNLOADS
;
; REQUIRED INPUTS:
;   None 
;
; OPTIONAL INPUTS:
;   VERSTRUCT........ The version information structure
;
; KEYWORD PARAMETERS:
;   KEY1........... Document keyword parameters like this. Note that the keyword is shown in ALL CAPS!
;
; OUTPUTS:
;   OUTPUT.......... Decribe the output of this program or function
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
  ROUTINE_NAME = 'ILLEX_WEEKLY_DOWNLOADS'
  COMPILE_OPT IDL2
  SL = PATH_SEP()
  
  TODAY = DATE_NOW() & JDAY = DATE_2JD(TODAY)
  VSTR = VERSTRUCT
  VER = VSTR.VERSION
  

  CASE VER OF
    'V2022': BEGIN & PRODS=VSTR.INFO.DOWNLOAD_PRODS & END
  ENDCASE
  
  DSETS = []
  FOR N=0, N_ELEMENTS(PRODS)-1 DO BEGIN
    PSTR = VSTR.PROD_INFO.(N)
    DSET = PSTR.TEMP_DATASET
    DPROD = PSTR.DOWNLOAD_PROD
    IF WHERE(DSETS EQ DSET,/NULL) NE [] THEN CONTINUE
    
    ; Get list of dates from the last ten days
    DTR = GET_DATERANGE(TODAY,JD_2DATE(JD_ADD(JDAY,-10,/DAY)))
  
    CASE DSET OF
      'GLOBCOLOUR': DWLD_GLOBCOLOUR, DATERANGE=DTR, PRODS=DPROD
      'MUR': BEGIN & DWLD_MUR_SST,DATERANGE=DTR & END
        
    ENDCASE
    DSETS = [DSETS,DSET]
  ENDFOR
    
    
    


END ; ***************** End of ILLEX_WEEKLY_DOWNLOADS *****************
