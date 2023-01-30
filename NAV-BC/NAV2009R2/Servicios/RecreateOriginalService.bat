@ECHO OFF
IF NOT "%1" == "" GOTO usage
SET NAVPATH=%~dp0
IF EXIST "%NAVPATH%service\Microsoft.Dynamics.Nav.Server.exe" GOTO NavPathOK
ECHO.
ECHO Unable to locate installation service directory
ECHO.
ECHO %NAVPATH%service\
ECHO.
ECHO Maybe you already ran recreateoriginalservice.bat
goto :eof
:NavPathOK
IF NOT EXIST "%NAVPATH%service.org\Microsoft.Dynamics.Nav.Server.exe" GOTO orgok
ECHO.
ECHO Directory already exists
ECHO.
ECHO %NAVPATH%service.org\
ECHO.
ECHO Maybe you already ran recreateoriginalservice.bat
GOTO :eof
:orgok
C:
CD "%NAVPATH%"
SC stop MicrosoftDynamicsNavWS
CALL SLEEP.BAT 3
SC stop MicrosoftDynamicsNavServer
CALL SLEEP.BAT 3
SC delete MicrosoftDynamicsNavWS
SC delete MicrosoftDynamicsNavServer
RENAME Service Service.org
CALL createservice DynamicsNAV dummy dummy auto
COPY /Y customsettings.template service.org\customsettings.config
GOTO :eof
:usage
ECHO.
ECHO Usage:
ECHO.
ECHO recreateoriginalservice.bat
ECHO.