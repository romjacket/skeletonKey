for %%a in ("ResX" "ResY" "WinSize" "FilterType" "DrawDither" "FastMdec" "WindowMode" "ColDepth" "UseFrameLimit" "UseFrameSkip" "FrameLimit" "FrameRate" "FrameRateFloat" "UseMulti" "ass" "OffscreenDrawing" "OffscreenDrawingEx" "OpaquePass" "VRamSize" "TexQuality" "BufferFlip" "CfgFixes" "UseFixes" "UseScanLines" "ShowFPS" "FrameTexType" "FrameReadType" "UseMask" "UseGamma" "ScanBlend" "FullscreenBlur" "HiResTextures" "NoScreenSaver" "GPUKeys" "DeviceName" "GuiDev") do for /f "tokens=3 delims= " %%n in ('reg query "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /v "%%~a"') do if ("%%~n" neq "\Pro\GPU\PeteD3d" echo.SET %%~a=%%~n>>PeteD3D_SET.cmd