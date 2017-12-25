for /f "tokens=3* delims= " %%A in ('reg query "HKCU\Software\Vision Thing\PSEmu Pro\PAD\PadSSSPSX" /v "cfg"') do echo.SET cfg=%%~A>>PadSSSPSX_SET.cmd
