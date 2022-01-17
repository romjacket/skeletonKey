REM @echo off
echo.
echo.Close this window if you aren't running this from a portable drive
echo.
pause
for /F "usebackq tokens=1,2,3,4 " %%i in (`wmic logicaldisk get caption^,description^,drivetype 2^>NUL`) do (
  if %%l equ 2 (
   SET NEWDRV=%%i
    echo %%i is a USB drive.
    call :FRIM
    )
)
if "%MOVDRV%" == "" start /w "..\bin\VDrive.exe" configuration && if "%VDrive%" NEQ "" start /w "..\Skeletonkey.exe" portable "%VDrive%" && exit /b|| exit /b
for %%c in ("%DEFLOC%") do start /w "..\skeletonkey.exe" portable "%%~c"
exit /b
:FRIM
for %%a in ("%~dp0") do set defra=%%~a
for %%b in ("%defra:~0,2%") do SET DEFDRV=%%~b
if /i "%DEFDRV%"=="%NEWDRV%" set MOVDRV=%DEFDRV%
for %%b in ("%defra:~0,-1%") do SET DEFLOC=%%~b		