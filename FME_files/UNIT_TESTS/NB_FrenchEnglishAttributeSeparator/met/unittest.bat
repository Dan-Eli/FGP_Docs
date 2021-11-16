REM ===========================================================================
REM Enable local variables 
REM ===========================================================================
SETLOCAL ENABLEDELAYEDEXPANSION

 
REM ===========================================================================
REM Allow accented characters
REM ===========================================================================
chcp 1252

REM ===========================================================================
REM Determine the directory where the.bat is located and place it  
REM in the directory above while keeping the original directory
REM ===========================================================================
SET Repertoire=%~dp0
SET Ctfolder=%Repertoire%\..\..\..\FME_Custom_Transformers\
PUSHD %Ctfolder%

REM Define FME transformer path
SET FME_USER_RESOURCE_DIR=%USERPROFILE%\Documents\FME

REM ===========================================================================
REM Create file name variable in relative mode.
REM ===========================================================================
SET NomApp=NB_FrenchEnglishAttributeSeparator
SET fme=%FME2020%


SET UserProfileFmx="%FME_USER_RESOURCE_DIR%\Transformers\%NomApp%.fmx"

REM ===========================================================================
REM Initialization of the variable that contains the result of the execution
REM ===========================================================================
SET Statut=0

REM ===========================================================================
REM Copy FMX to Documents
REM ===========================================================================
COPY/Y %Ctfolder%\%NomApp%.fmx %UserProfileFmx%
SET Statut=%Statut%%ERRORLEVEL%

PUSHD %Repertoire%\..

REM Définition de la source 
REM Source 1
REM Une feature sur laquelle on a défini attribute_to_split=ENGLISH / FRENCH et resource.id=0000-0000
REM Source 2
REM Une feature sur laquelle on a défini attribute_to_split=ENGLISH/MULTI/SLASH / FRENCH/MULTI/SLASH et resource.id=1111-1111
REM Source 3
REM Une feature sur laquelle on a défini attribute_to_split=ENGLISH/MULTI/SLASH / FRENCH/MULTI/SLASH et resource.id=2222-2222

REM ============================================================================
REM ========================== TEST  #1   ======================================
REM ============================================================================
REM On test la séparation en/fr avec un slash pour attribute_to_split=ENGLISH / FRENCH
REM ============================================================================
SET test_number=1
SET source=met\source_%test_number%.ffs
SET etalon=met\etalon_%test_number%.ffs
SET lookup=met\lookuptables\NB_SlashCountSeparator.csv
SET resultat=met\resultat_%test_number%.ffs
SET log=met\log_%test_number%.log
SET log_comp=met\log_comp_%test_number%.log
SET att_to_split=attribute_to_split

IF EXIST %log% del %log%
IF EXIST %resultat% DEL %resultat%
%fme% met\metrique_NB_FrenchEnglishAttributeSeparator.fmw ^
--IN_FFS_FILE %source% ^
--ATTRIBUTE_TO_SPLIT %att_to_split% ^
--OUT_FFS_FILE %resultat% ^
--LOOKUP_TABLE %lookup% ^
--LOG_FILE %log% 
SET Statut=%Statut%%ERRORLEVEL%

REM Comparaison avec l'étalon
IF EXIST %log_comp% del %log_comp%
%fme% met\Comparateur.fmw ^
--IN_FFS_ETALON_FILE %etalon% ^
--IN_FFS_RESULTAT_FILE %resultat% ^
--LOG_FILE %log_comp% 
SET Statut=%Statut%%ERRORLEVEL%



REM ============================================================================
REM ========================== TEST  #2   ======================================
REM ============================================================================
REM On test la séparation en/fr avec plusieurs slashs pour attribute_to_split=ENGLISH/MULTI/SLASH / FRENCH/MULTI/SLASH
REM ============================================================================
SET test_number=2
SET source=met\source_%test_number%.ffs
SET etalon=met\etalon_%test_number%.ffs
SET lookup=met\lookuptables\NB_SlashCountSeparator.csv
SET resultat=met\resultat_%test_number%.ffs
SET log=met\log_%test_number%.log
SET log_comp=met\log_comp_%test_number%.log
SET att_to_split=attribute_to_split

IF EXIST %log% del %log%
IF EXIST %resultat% DEL %resultat%
%fme% met\metrique_NB_FrenchEnglishAttributeSeparator.fmw ^
--IN_FFS_FILE %source% ^
--ATTRIBUTE_TO_SPLIT %att_to_split% ^
--OUT_FFS_FILE %resultat% ^
--LOOKUP_TABLE %lookup% ^
--LOG_FILE %log% 
SET Statut=%Statut%%ERRORLEVEL%

REM Comparaison avec l'étalon
IF EXIST %log_comp% del %log_comp%
%fme% met\Comparateur.fmw ^
--IN_FFS_ETALON_FILE %etalon% ^
--IN_FFS_RESULTAT_FILE %resultat% ^
--LOG_FILE %log_comp% 
SET Statut=%Statut%%ERRORLEVEL%



REM ============================================================================
REM ========================== TEST  #3   ======================================
REM ============================================================================
REM On test un feature manquant dans la LOOKUP_TABLE 'NB_SlashCountSeparator' avec attribute_to_split=ENGLISH/MULTI/SLASH / FRENCH/MULTI/SLASH
REM ============================================================================
SET test_number=3
SET source=met\source_%test_number%.ffs
SET etalon=met\etalon_%test_number%.ffs
SET lookup=met\lookuptables\NB_SlashCountSeparator.csv
SET resultat=met\resultat_%test_number%.ffs
SET log=met\log_%test_number%.log
SET log_comp=met\log_comp_%test_number%.log
SET att_to_split=attribute_to_split

IF EXIST %log% del %log%
IF EXIST %resultat% DEL %resultat%
%fme% met\metrique_NB_FrenchEnglishAttributeSeparator.fmw ^
--IN_FFS_FILE %source% ^
--ATTRIBUTE_TO_SPLIT %att_to_split% ^
--OUT_FFS_FILE %resultat% ^
--LOOKUP_TABLE %lookup% ^
--LOG_FILE %log% 
SET Statut=%Statut%%ERRORLEVEL%

REM Comparaison avec l'étalon
IF EXIST %log_comp% del %log_comp%
%fme% met\Comparateur.fmw ^
--IN_FFS_ETALON_FILE %etalon% ^
--IN_FFS_RESULTAT_FILE %resultat% ^
--LOG_FILE %log_comp% 
SET Statut=%Statut%%ERRORLEVEL%



REM ============================================================================
REM ========================== TEST  #ERREUR-1  ================================
REM ============================================================================
REM On test une lookup table sans attribut 'dataid'
REM ============================================================================

SET test_number=ERREUR-1
SET lookup=met\lookuptables\%test_number%.csv
SET resultat=met\resultat_%test_number%.ffs
set source=met\source_2.ffs
SET log=met\log_%test_number%.log
SET log_comp=met\log_comp_%test_number%.log
SET att_to_split=attribute_to_split

IF EXIST %log% del %log%
IF EXIST %resultat% DEL %resultat%
%fme% met\metrique_NB_FrenchEnglishAttributeSeparator.fmw ^
--IN_FFS_FILE %source% ^
--ATTRIBUTE_TO_SPLIT %att_to_split% ^
--OUT_FFS_FILE %resultat% ^
--LOOKUP_TABLE %lookup% ^
--LOG_FILE %log%  

FIND "No value for dataid or lang_sep_pos in look-up table" %log%
SET Statut=%Statut%%ERRORLEVEL%



REM ============================================================================
REM ========================== TEST  #ERREUR-2  ================================
REM ============================================================================
REM On test une lookup table sans attribut 'lang_sep_pos'
REM ============================================================================

SET test_number=ERREUR-2
SET lookup=met\lookuptables\%test_number%.csv
SET resultat=met\resultat_%test_number%.ffs
set source=met\source_2.ffs
SET log=met\log_%test_number%.log
SET log_comp=met\log_comp_%test_number%.log
SET att_to_split=attribute_to_split

IF EXIST %log% del %log%
IF EXIST %resultat% DEL %resultat%
%fme% met\metrique_NB_FrenchEnglishAttributeSeparator.fmw ^
--IN_FFS_FILE %source% ^
--ATTRIBUTE_TO_SPLIT %att_to_split% ^
--OUT_FFS_FILE %resultat% ^
--LOOKUP_TABLE %lookup% ^
--LOG_FILE %log%  

FIND "No value for dataid or lang_sep_pos in look-up table" %log%
SET Statut=%Statut%%ERRORLEVEL%



@IF [%Statut%] EQU [0000000000] (
 @ECHO INFORMATION : Metric test passed
 @COLOR A0
 @SET CodeSortie=999999
) ELSE (
 @ECHO ERROR: Metric test failed
 @COLOR CF
 @SET CodeSortie=-1
)

REM ===========================================================================
REM We return the window to the starting directory
REM ===========================================================================
POPD
 
REM ===========================================================================
REM We pause so that the window does not close 
REM in case we have to double-click on the.bat to execute it.
REM ===========================================================================
PAUSE
COLOR
EXIT /B %CodeSortie%

