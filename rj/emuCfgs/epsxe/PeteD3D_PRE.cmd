call PeteD3D_SET.cmd
if not exist PeteD3D_SET.cmd call PeteD3D_DEFAULT.cmd
REG ADD "HKEY_CURRENT_USER\Software\epsxe\config" /f /v "VideoPlugin" /t REG_SZ /d "%GPUD%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "ResX" REG_DWORD /d "%ResX%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "ResY" REG_DWORD /d "%ResY%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "WinSize" REG_DWORD /d "%WinSize%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FilterType" REG_DWORD /d "%FilterType%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "DrawDither" REG_DWORD /d "%DrawDither%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FastMdec" REG_DWORD /d "%FastMdec%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "WindowMode" REG_DWORD /d "%WindowMode%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "ColDepth" REG_DWORD /d "%ColDepth%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseFrameLimit" REG_DWORD /d "%UseFrameLimit%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseFrameSkip" REG_DWORD /d "%UseFrameSkip%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FrameLimit" REG_DWORD /d "%FrameLimit%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FrameRate" REG_DWORD /d "%FrameRate%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FrameRateFloat" REG_DWORD /d "%FrameRateFloat%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseMultiPass" REG_DWORD /d "%UseMultiPass%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "OffscreenDrawing" REG_DWORD /d "%OffscreenDrawing%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "OffscreenDrawingEx" REG_DWORD /d "%OffscreenDrawingEx%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "OpaquePass" REG_DWORD /d "%OpaquePass%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "VRamSize" REG_DWORD /d "%VRamSize%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "TexQuality" REG_DWORD /d "%TexQuality%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "BufferFlip" REG_DWORD /d "%BufferFlip%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "CfgFixes" REG_DWORD /d "%CfgFixes%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseFixes" REG_DWORD /d "%UseFixes%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseScanLines" REG_DWORD /d "%UseScanLines%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "ShowFPS" REG_DWORD /d "%ShowFPS%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FrameTexType" REG_DWORD /d "%FrameTexType%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FrameReadType" REG_DWORD /d "%FrameReadType%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseMask" REG_DWORD /d "%UseMask%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "UseGamma" REG_DWORD /d "%UseGamma%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "ScanBlend" REG_DWORD /d "%ScanBlend%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "FullscreenBlur" REG_DWORD /d "%FullscreenBlur%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "HiResTextures" REG_DWORD /d "%HiResTextures%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "NoScreenSaver" REG_DWORD /d "%NoScreenSaver%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "GPUKeys" REG_BINARY /d "%GPUKeys%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "DeviceName" REG_BINARY /d "%DeviceName%"
reg add "HKCU\Software\Vision Thing\PSEmu Pro\GPU\PeteD3d" /f /v "GuiDev" REG_BINARY /d "%GuiDev%"