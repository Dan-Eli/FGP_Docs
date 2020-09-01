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
PUSHD %Repertoire%\..



REM Define FME transformer path
SET FME_USER_RESOURCE_DIR=%USERPROFILE%\Documents\FME

REM ===========================================================================
REM Create file name variable in relative mode.
REM ===========================================================================
SET NomApp=ON_GEOHUB_RESOURCES_MAPPER
SET fme=%FME2019%


SET UserProfileFmx="%FME_USER_RESOURCE_DIR%\Transformers\%NomApp%.fmx"

REM ===========================================================================
REM Initialization of the variable that contains the result of the execution
REM ===========================================================================
SET Statut=0

REM ===========================================================================
REM Copy FMX to Documents
REM ===========================================================================
COPY/Y fme\%NomApp%.fmx %UserProfileFmx%
SET Statut=%Statut%%ERRORLEVEL%

REM Define sources

REM First FME call, complete GEOHUB data
set test_number=1
SET source=met\source%test_number%.ffs
set lookup=met\Spatial_ON.xlsx
set etalon=met\etalon%test_number%.ffs
SET resultat=met\resultat.ffs
set log=met\log_%test_number%.log
set log_comp=met\log_comp_%test_number%.log

IF EXIST %log% del %log%
IF EXIST met\resultat.xml DEL met\resultat.xml
%fme% met\metrique_on_geohub_resources_mapper.fmw ^
--IN_FFS_FILE %source% ^
--LOOKUP_TABLE %lookup% ^
--OUT_FFS_FILE %resultat% ^
--LOG_FILE %log% 
SET Statut=%Statut%%ERRORLEVEL%

REM Comparison with the standard
IF EXIST %log_comp% del %log_comp%
%fme% met\Comparateur.fmw ^
--IN_ETALON_FILE %etalon% ^
--IN_RESULTAT_FILE %resultat% ^
--LOG_FILE %log_comp% 
SET Statut=%Statut%%ERRORLEVEL%

REM Second FME call, complete GEOHUB data with duplicate in lookup table to throw error
set test_number=2
SET source=met\source1.ffs
set lookup=met\Spatial_ON_2.xlsx
SET resultat=met\resultat.ffs
set log=met\log_%test_number%.log

IF EXIST %log% del %log%
IF EXIST met\resultat.xml DEL met\resultat.xml
%fme% met\metrique_on_geohub_resources_mapper.fmw ^
--IN_FFS_FILE %source% ^
--LOOKUP_TABLE %lookup% ^
--OUT_FFS_FILE %resultat% ^
--LOG_FILE %log% 
FIND "Duplicate tags_value south nation lidar found in Spatial_ON lookup table.  Translation Terminated" %log%
SET Statut=%Statut%%ERRORLEVEL%

@IF [%Statut%] EQU [00000] (
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
