call AmiDog_SET.cmd
if not exist AmiDog_SET.cmd call AmiDog_DEFAULT.cmd
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "BrightScanlines" /t REG_DWORD /d "%BrightScanlines%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "Display" /t REG_DWORD /d "%Display%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "FullScreen" /t REG_DWORD /d "%FullScreen%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "FullScreenScaling" /t REG_DWORD /d "%FullScreen%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "InterlaceHalfRate" /t REG_DWORD /d "%InterlaceHalfRate%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "LimitFrameRate" /t REG_DWORD /d "%LimitFrameRate%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "NewGPU" /t REG_DWORD /d "%NewGPU%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "NoScale" /t REG_DWORD /d "%NoScale%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "ProgressiveDoubleScan" /t REG_DWORD /d "%ProgressiveDoubleScan%"
reg add "HKCU\Software\AmiDog\ADGPU" /f /v "TextureCache" /t REG_DWORD /d "%TextureCache%"
