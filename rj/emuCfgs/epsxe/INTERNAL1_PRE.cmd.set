call INTERNAL1_SET.cmd
if not exist INTERNAL1_SET.cmd call INTERNAL1_DEFAULT.cmd
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "Multitap1" /t REG_SZ /d "%MULTITAP1%"
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "GamepadType" /t REG_SZ /d "%PADCFG%"
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "Pad1" /t REG_SZ /d "%PAD1TYPE%"