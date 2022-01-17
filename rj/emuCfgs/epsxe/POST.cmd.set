for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "VideoPlugin"') do set VIDPLUG=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "SoundPlugin"') do set SNDPLUG=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "CdromPlugin"') do set CDRPLUG=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "GamepadType"') do set PADCFG=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad1"') do set PAD1TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad2"') do set PAD3TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad3"') do set PAD5TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad4"') do set PAD7TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad5"') do set PAD2TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad6"') do set PAD4TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad7"') do set PAD6TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad8"') do set PAD8TYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Muiltitap1"') do set MULTITAP1=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Muiltitap1"') do set MULTITAP2=%%~a
del /q SET.cmd
echo.goto :SETCMDS>SET.cmd
echo.[INI]>>SET.cmd
echo.:SETCMDS>>SET.cmd
echo.SET GPUD=%VIDPLUG%>>SET.cmd
if "%VIDPLUG%" NEQ "gpuadgpu.dll" for /f "delims=" %%a in ("%VIDPLUG:~3,-4%") do echo.SET GPU=%%~a>>SET.cmd
if "%VIDPLUG%"=="gpuadgpu.dll" echo.SET GPU=AmiDog>>SET.cmd

echo.SET SPUD=%SNDPLUG%>>SET.cmd
if "%VIDPLUG%" NEQ "SPUCORE" echo.SET SPU=%SNDPLUG:~3,-4%>>SET.cmd
if "%VIDPLUG%"==SPUCORE echo.SET SPU=SPUCORE>>SET.cmd

echo.SET PAD1TYPE=%PAD1TYPE%>>SET.cmd
echo.SET PAD2TYPE=%PAD2TYPE%>>SET.cmd
echo.SET PAD3TYPE=%PAD3TYPE%>>SET.cmd
echo.SET PAD4TYPE=%PAD4TYPE%>>SET.cmd
echo.SET PAD5TYPE=%PAD5TYPE%>>SET.cmd
echo.SET PAD6TYPE=%PAD6TYPE%>>SET.cmd
echo.SET PAD7TYPE=%PAD7TYPE%>>SET.cmd
echo.SET PAD8TYPE=%PAD8TYPE%>>SET.cmd
echo.SET MULTITAP1=%MULTITAP1%>>SET.cmd
echo.SET MULTITAP2=%MULTITAP2%>>SET.cmd
echo.SET PADCFG=%PADCFG%>>SET.cmd

call %GPU%_POST.cmd
call %SPU%_POST.cmd
for %%a in ('dir /b/a-d "Internal*.cmd"') do call "%%~a"
