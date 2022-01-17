call AmiDog_SET.cmd
if not exist AmiDog_SET.cmd call AmiDog_DEFAULT.cmd
for %%a in ("BrightScanlines" "Display" "FullScreen" "FullScreenScaling" "InterlaceHalfRate" "LimitFrameRate" "NewGPU" "NoScale" "ProgressiveDoubleScan" "TextureCache") do (for /f "tokens=3 delims= " %%n in ('reg query "HKCU\Software\AmiDog\ADGPU" /v "%%~a"') do echo.SET %%~a=%%~n>>AmiDog_SET.cmd)
