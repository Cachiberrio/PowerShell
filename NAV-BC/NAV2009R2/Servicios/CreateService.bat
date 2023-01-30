@ECHO OFF
IF "%1" == "" GOTO usage
SET SERVICE=%1
SET DBSERVER=%2
SET DATABASE=%1
SET START=%4
SET WHICH=%5
IF "%START%" == "" SET START=demand
IF "%START%" == "auto" goto startok
IF "%START%" == "demand" goto startok
IF "%START%" == "disabled" goto startok
ECHO.
ECHO Illegal value for 4th parameter
GOTO usage
:startok
IF "%WHICH%" == "" SET WHICH=both
IF "%WHICH%" == "both" goto whichok
IF "%WHICH%" == "servicetier" goto whichok
IF "%WHICH%" == "ws" goto whichok
ECHO.
ECHO Illegal value for 5th parameter
GOTO usage
:whichok
SET type=own
IF "%WHICH%" == "both" SET type=share
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
IF EXIST "%NAVPATH%%SERVICE%\Microsoft.Dynamics.Nav.Server.exe" GOTO serviceexists
C:
CD "%NAVPATH%"
MKDIR "%SERVICE%"
IF ERRORLEVEL 1 GOTO nodir
XCOPY service.org %SERVICE% /s/e
SET SERVICEDIR=%NAVPATH%%SERVICE%
replacestringinfile.vbs #INSTANCE# %SERVICE% "%SERVICEDIR%\customsettings.config"
IF '%DBSERVER%' == '' GOTO editconfig
replacestringinfile.vbs #DBSERVER# %DBSERVER% "%SERVICEDIR%\customsettings.config"
IF '%DATABASE%' == '' GOTO editconfig
replacestringinfile.vbs #DATABASE# %DATABASE% "%SERVICEDIR%\customsettings.config"
GOTO configdone
:editconfig
NOTEPAD %SERVICEDIR%\customsettings.config
:configdone
SC CONFIG NetTcpPortSharing start= demand
SET DEP=
if "%WHICH%" == "ws" goto onlyws

sc CREATE MicrosoftDynamicsNAV$%SERVICE% binpath= "%SERVICEDIR%\Microsoft.Dynamics.Nav.Server.exe $%SERVICE%" DisplayName= "NAV Server  %SERVICE%" start= %START% type= %type% obj= "NT Authority\NetworkService" depend= NetTcpPortSharing
netsh http add urlacl url=http://+:7046/%SERVICE%/ user=todos

SET DEP=/MicrosoftDynamicsNavServer$%SERVICE%
if "%WHICH%" == "servicetier" goto notws
:onlyws
sc CREATE MicrosoftDynamicsNAVWS$%SERVICE% binpath= "%SERVICEDIR%\Microsoft.Dynamics.Nav.Server.exe $%SERVICE%" DisplayName= "NAV Server  %SERVICE% WS" start= %START% type= %type% obj= "NT Authority\NetworkService" depend= NetTcpPortSharing

netsh http add urlacl url=http://+:7047/%SERVICE%/ user=todos

:notws
IF "%START%" == "demand" GOTO :eof
IF "%START%" == "disabled" GOTO :eof
if "%WHICH%" == "ws" goto startws
SC START MicrosoftDynamicsNavServer$%SERVICE%
if "%WHICH%" == "servicetier" goto :eof
:startws

goto :eof
:serviceexists
ECHO.
ECHO Service already exists
ECHO.
GOTO :eof
:nodir
ECHO.
ECHO Could not create service directory
ECHO.
GOTO :eof
:usage
ECHO.
ECHO Usage:
ECHO.
ECHO CreateService servicetiername [databaseserver] ["databasename"] [demand^|auto^|disabled] [both^|servicetier^|ws]
ECHO.
ECHO.