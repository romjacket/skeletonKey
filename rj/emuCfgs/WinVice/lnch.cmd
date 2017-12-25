CHCP 1252
MODE CON: COLS=15 LINES=1
TITLE LAUNCHER

set FETYPE=%1%
set JYTP=%2%
set JYZ=%3%
set DMT=%4%
set JYTOG=%5%
set FRLOC=[FRLOC]

if "%JYTP%"=="" set JYTP=[XPALT]
if "%FETYPE%"=="" set FETYPE=Mediacenter
SET JYX=REM 
if "%JYZ%"=="" set JYX=
SET DMX=REM 
if "%DMT%"=="" set DMX=
SET XFG=REM 
if "%CFG%"=="" set XFG=
SET RLOC=REM 
if "%FRLOC%"=="" set RLOC=

for %%a in ("cmd /c start """) do set XPSTRT=%%~a
for %%a in ("start /w """) do set LAUNCH=%%~a
for /f "tokens=2 delims=[" %%a in ('ver') do if "%%~a"=="" set WINE=1
if "%WINE%"=="1" for %%a in ("start /w") do set LAUNCH=%%~a
if "%WINE%"=="1" set XPSTRT=

set XPALT=REM 
if "%JYTP%"=="1" set XPALT=

pushd "%~dp0"

for %%A in ("") do SET EMUL=%%~A
for %%A in ("ERROR") do SET EMUZ=%%~nA
for %%A in ("%~dpn0") do SET GAMNAM=%%~A
for %%A in ("%EMUL:~0,2%") do SET EMUDIR=%%~A
for %%A in ("%CD%") do SET GAMDIR=%%~A

%XPALT%%JYX%for %%A in ("0") do (
%XPALT%%JYX%SET ANTIMIC=%%~A
%XPALT%%JYX%SET AMDIR=%%~dpA
%XPALT%%JYX%)
%JYX%for %%A in ("C:\Users\sudopinion\Documents\skeletonkey\app\Xpadder\Xpadder.exe") do (
%JYX%SET XPADDER=%%~A
%JYX%XPDIR=%%~dpA
%JYX%)

%DMX%for %%A in ("[DAMVAR]") do SET DAMVAR=%%~A

SET PLYRN1=Player1
SET PLYRN2=Player2

%XPALT%FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq antimicro.exe" /v^| find /i "antimicro"') DO if "%%~A" NEQ "" goto :CPY
goto :CPY

[INIVARS]
EMUL=""
EMUZ="ERROR"
GAMNAM="[GAMNAM]"
ANTIMIC="0"
XPADDER="C:\Users\sudopinion\Documents\skeletonkey\app\Xpadder\Xpadder.exe"
DAMVAR="[DAMVAR]"
PLYRN1="[PLYAYER1]"
PLYRN2="[PLYAYER2]"
[INIVAREND]

:CPY
%XFG%copy /y "vice.ini" "%EMUL%"
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

for /f "delims=" %%a in ('dir /B /A-D "*.x64" "*.t64" "*.d64" "*.g64" "*.fdi" "*.p00" "*.prg" "*.tap" "*.wav" "*.80" "*.a0" "*.e0" "*.crt" "*.g41" "*.d77" "*.d88" "*.1dd" "*.dfi" "*.imd" "*.ipf" "*.mfi" "*.mfm" "*.td0" "*.cqm" "*.cqi" "*.dsk"') do (
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
%RLOC%pushd "%EMUL%"
[RLOOPINJ]
%DMX%"%DAMVAR%" -mount dt, 0, "%GAMDIR%\%ROMF%"
%LAUNCH% "%EMUL%\%EMUZ%.exe"
%RLOC%popd
%XFG%copy /y "%EMUL%\vice.ini" "%GAMDIR%"
%XPT%%XPSTRT% "%XPADDER%" /m %FETYPE% nolayout2


%XPALT%pushd "%XPDIR%"
%XPALT%for /f "tokens=1,2 delims=: " %%a in ('type "%XPDIR%lst.ini"') do if "%%~a"=="Index" set JNUM=%%~b&&if "%%~b" GEQ "2" for /f "tokens=1,2,3* delims= " %%i in ("--profile-controller 2 --profile %XPDIR%nolayout2.amgp") do (
%XPALT%set AMCP2=%%~i %%~j %%~k
%XPALT%set AMCV=%%~l
%XPALT%)
%XPALT%if "%AMCV%" NEQ "" for %%a in ("%AMCV%") do set AMCV=%%a
%XPALT%%XPSTRT% "%XPADDER%" --hidden --profile-controller 1 --profile "%XPDIR%%FETYPE%.amgp" %AMCP2% %AMCV%
%XPALT%popd

%DMX%cmd /c "%DAMVAR%" -unmount dt, 0
if "%WINE%"=="" goto :END
taskkill /f /im cmd.exe
:END
FOR /F "tokens=2 delims= " %%A IN ('TASKLIST /FI "imagename eq cmd.exe" /v^| find /i "LAUNCHER"') DO TASKKILL /F /PID %%A