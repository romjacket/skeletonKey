call PadSSSPSX_SET.cmd
if not exist PadSSSPSX_SET.cmd call PadSSSPSX_DEFAULT.cmd
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "GamepadType" /t REG_SZ /d "%PADCFG%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\PAD\PadSSSPSX" /f /v "cfg" /t REG_DWORD /d "%cfg%"
