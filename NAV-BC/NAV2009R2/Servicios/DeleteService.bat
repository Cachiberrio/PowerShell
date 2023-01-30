@ECHO OFF
IF "%1" == "" GOTO usage
SET NAVPATH=%~dp0
IF EXIST "%NAVPATH%service.org\Microsoft.Dynamics.Nav.Server.exe" GOTO NavPathOK
ECHO.
ECHO Unable to locate original Service directory
ECHO.
ECHO in %NAVPATH%service.org\
ECHO.
ECHO Maybe you need to run recreateoriginalservice.bat
goto :eof
:NavPathOk
C:
CD "%NAVPATH%"
IF EXIST "%1\Microsoft.Dynamics.Nav.Server.exe" GOTO serviceexists
ECHO.
ECHO Service doesn't exist
GOTO usage
:serviceexists
SC query MicrosoftDynamicsNavServer$%1 | FINDSTR "STOPPED"
IF NOT ERRORLEVEL 1 GOTO dontstop

CALL SLEEP.BAT 3
SC stop MicrosoftDynamicsNavServer$%1
CALL SLEEP.BAT 3
:dontstop

SC delete MicrosoftDynamicsNavServer$%1
rd %1 /S /Q
GOTO :eof
:usage
ECHO.
ECHO Usage:
ECHO.
ECHO DeleteService servicename
ECHO.