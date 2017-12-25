CHCP 1252
MODE CON: COLS=15 LINES=1
TITLE LAUNCHER

set FETYPE=%1%
set JYTP=%2%
set JYZ=%3%
set DMT=%4%
set CFG=%5%
set CCMDA=%6%
set CCMDB=%7%
set CCMDY=%8%
set CCMDZ=%9%
for %%a in ("[FRLOC]") do set FRLOC=%%~a
PLYRN1=
PLYRN2=


if "%JYTP%"=="." set JYTP=[XPALT]
if "%JYTP%"=="" set JYTP=[XPALT]
if "%FETYPE%"=="" set FETYPE=
if "%FETYPE%"=="." set FETYPE=
SET JYX=REM 
if "%JYZ%"=="" set JYX=
if "%JYZ%"=="." set JYX=
SET DMX=REM 
if "%DMT%"=="1" set DMX=
SET XFG=REM 
if "%CFG%"=="" set XFG=
if "%CFG%"=="." set XFG=REM 
SET RLOC=REM 
if "%FRLOC%"=="" set RLOC=

for %%a in ("cmd /c start """) do set XPSTRT=%%~a
for %%a in ("start /w """) do set LAUNCH=%%~a
for %%a in ("start """) do set LSTART=%%~a
for /f "tokens=2 delims=[" %%a in ('ver') do if "%%~a"=="" set WINE=1
if "%WINE%"=="1" for %%a in ("start /w") do set LAUNCH=%%~a
if "%WINE%"=="1" set XPSTRT=

set XPALT=REM 
if "%JYTP%"=="1" set XPALT=

pushd "%~dp0"

for %%A in ("C:\Emulators\zsnes") do SET EMUL=%%~A
for %%A in ("zsnesw.exe") do SET EMUZ=%%~nA
for %%A in ("%~dpn0") do SET GAMNAM=%%~A
for %%A in ("%EMUL:~0,2%") do SET EMUDIR=%%~A
for %%A in ("%CD%") do SET GAMDIR=%%~A
%CCMDA%
%XPALT%%JYX%for %%A in ("C:\Emulators\Antimicro\antimicro.exe") do (
%XPALT%%JYX%SET ANTIMIC=%%~A
%XPALT%%JYX%SET AMDIR=%%~dpA
%XPALT%%JYX%)
%JYX%for %%A in ("C:\Emulators\Xpadder\XPadder.exe") do (
%JYX%SET XPADDER=%%~A
%JYX%XPDIR=%%~dpA
%JYX%)

%DMX%for %%A in ("[DAMVAR]") do SET DAMVAR=%%~A

If "%PLYRN1%"=="" SET PLYRN1=Player1
If "%PLYRN2%"=="" SET PLYRN2=Player2

%XPALT%FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq antimicro.exe" /v^| find /i "antimicro"') DO if "%%~A" NEQ "" goto :CPY
goto :CPY

[INIVARS]
EMUL="C:\Emulators\zsnes"
EMUZ="zsnesw.exe"
GAMNAM="[GAMNAM]"
ANTIMIC="C:\Emulators\Antimicro\antimicro.exe"
XPADDER="C:\Emulators\Xpadder\XPadder.exe"
DAMVAR="[DAMVAR]"
PLYRN1=""
PLYRN2=""
[INIVAREND]

:CPY
%XFG%Zsnes
%JYX%%XPSTRT% "%XPADDER%" /m "%GAMDIR%\%PLYRN1%.xpadderprofile" "%GAMDIR%\%PLYRN2%.xpadderprofile"


%XPALT%pushd "%AMDIR%"
%XPALT%"%ANTIMIC%" -l>"%AMDIR%lst.ini"
%XPALT%for /f "tokens=1,2 delims=: " %%a in ('type "%AMDIR%lst.ini"') do if "%%~a"=="Index" set JNUM=%%~b&&if "%%~b" GEQ "2" for /f "tokens=1,2,3* delims= " %%i in ("--profile-controller 2 --profile %GAMDIR%\%PLYRN2%.amgp") do (
%XPALT%set AMCP2=%%~i %%~j %%~k
%XPALT%set AMCV=%%~l
%XPALT%)
%XPALT%if "%AMCV%" NEQ "" for %%a in ("%AMCV%") do set AMCV=%%a
%XPALT%%XPSTRT% "%ANTIMIC%" --hidden --profile-controller 1 --profile "%GAMDIR%\%PLYRN1%.amgp" %AMCP2% %AMCV%
%XPALT%popd

for /f "delims=" %%a in ('dir /B /A-D "*.sfc" "*.bml" "*.smc" "*.zip"') do (
set ROMF=%%~a
set ROM=%%~na
set ROMX=%%~xa
set ROMFN=%%~nxa
CALL :RUN
)
exit /b

[RUNVARS]
CMDLINE="[CMDLINELOC]"
ROMF="[ROMF]"
ROM="[ROM]"
ROMX="[ROMX]"
ROMFN="[ROMFN]"

[INIVARSEND]

:RUN
%CCMDB%
%RLOC%pushd "%EMUL%"
[RLOOPINJ]
%DMX%"%DAMVAR%" -mount dt, 0, "%GAMDIR%\%ROMF%"
%LAUNCH% "%EMUL%\%EMUZ%.exe"Zsnes"%GAMDIR%\%ROMF%"
%CCMDY%
%RLOC%popd
%XFG%Zsnes
%XPT%%XPSTRT% "%XPADDER%" /m "%FETYPE%.xpadderprofile" nolayout2

%XPALT%pushd "%AMDIR%"
%XPALT%for /f "tokens=1,2 delims=: " %%a in ('type "%AMDIR%lst.ini"') do if "%%~a"=="Index" set JNUM=%%~b&&if "%%~b" GEQ "2" for /f "tokens=1,2,3* delims= " %%i in ("--profile-controller 2 --profile %AMDIR%nolayout2.amgp") do (
%XPALT%set AMCP2=%%~i %%~j %%~k
%XPALT%set AMCV=%%~l
%XPALT%)
%XPALT%if "%AMCV%" NEQ "" for %%a in ("%AMCV%") do set AMCV=%%a
%XPALT%%XPSTRT% "%ANTMIC%" --hidden --profile-controller 1 --profile "%FETYPE%.amgp" %AMCP2% %AMCV%
%XPALT%popd
%CCMDZ%
%DMX%cmd /c "%DAMVAR%" -unmount dt, 0
if "%WINE%"=="" goto :END
taskkill /f /im cmd.exe
:END
FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq cmd.exe" /v^| find /i "LAUNCHER"') DO TASKKILL /F /PID %%A