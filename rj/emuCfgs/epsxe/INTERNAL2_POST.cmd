for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Multitap2"') do echo.set MULTITAP2=%%~a>>INTERNAL2_SET.cmd
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\epsxe\config" /v "Pad5"') do echo.set PAD2TYPE=%%~a>>INTERNAL2_SET.cmd