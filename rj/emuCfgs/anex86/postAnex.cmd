for /f "tokens=3,* Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "path"') do set LOCAL=%%~a %%~b
for /f "tokens=3,* Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "fdd1"') do set DISK=%%~a %%~b
for /f "tokens=3,* Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "hdd1"') do set HDISK=%%~a %%~b
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "configwnd"') do set CFGWIND=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "jstk"') do set JOYSTK=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "amode"') do set STARTYPE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "window"') do set WINDOW=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "wmode"') do set WMODE=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "setting"') do set SETTING=%%~a
for /f "tokens=3 Delims= " %%a in ('REG QUERY "HKEY_CURRENT_USER\Software\A.N.\anex86\config\default" /v "video"') do set VIDEO=%%~a
del /q SET.cmd
echo.for %%%%b in ("%LOCAL%") do SET LOCAL=%%%%~b>>SET.cmd
echo.for %%%%b in ("%DISK%") do SET DISK=%%%%~b>>SET.cmd
echo.for %%%%b in ("%HDISK%") do SET HDISK=%%%%~b>>SET.cmd
echo.for %%%%b in ("%CFGWIND%") do SET CFGWIND=%%%%~b>>SET.cmd
echo.for %%%%b in ("%JOYSTK%") do SET JOYSTK=%%%%~b>>SET.cmd
echo.for %%%%b in ("%STARTYPE%") do SET STARTYPE=%%%%~b>>SET.cmd
echo.for %%%%b in ("%WINDOW%") do SET WINDOW=%%%%~b>>SET.cmd
echo.for %%%%b in ("%WMODE%") do SET WMODE=%%%%~b>>SET.cmd
echo.for %%%%b in ("%SETTING%") do SET SETTING=%%%%~b>>SET.cmd
echo.for %%%%b in ("%VIDEO%") do SET VIDEO=%%%%~b>>SET.cmd