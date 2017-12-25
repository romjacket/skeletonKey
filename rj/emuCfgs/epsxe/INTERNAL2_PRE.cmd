call INTERNAL2_SET.cmd
if not exist INTERNAL2_SET.cmd call INTERNAL2_DEFAULT.cmd
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "Multitap2" /t REG_SZ /d "%MULTITAP2%"
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "Pad5" /t REG_SZ /d "%PAD2TYPE%"