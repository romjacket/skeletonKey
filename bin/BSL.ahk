#NoEnv
#Singleinstance force
DetectHiddenWindows, On
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 3
Autotrim, off
MouseMove, 9999,-9999
WinHide, ahk_class Shell_TrayWnd
WinHide, Start ahk_class Button
WinMinimize, Windows Media Center
WinMinimize, EmulationStation
WinMinimize, RetroFE
WinMinimize, Steam
WinMinimize, XBMC
WinMinimize, KODI
WinMinimize, LaunchBox
WinMinimize, PLAYNITE
WinMinimize, HyperSpin
WinMinimize, Cabrio
BSLDIR= %A_ScriptDir%
RUNPROGRAM= %1%
FETYP= %2%	
JYTP= %3%	
JYZ= %4%	
DMT= %5%	
CFG= %6%	
CDMDA= %8%	
CDMDB= %9%	
CDMDY= %10%	
CDMDZ= %11%

SplitPath,RUNPROGRAM,RUNROM,RUNPTH,RUNXT,RUNAME
if (RUNXT = "lnk")
	{
		FileGetShortcut, %RUNPROGRAM%,scloc,scdir,scargs
		SPLITPATH,scloc,RUNROM,RUNPTH,RUNTXT,RUNAME
	}
splitpath,RUNPTH,sysdir
IniRead,EMUL,%RUNPTH%\%RUNROM%,INIVARS,EMUL
IniRead,EMUZ,%RUNPTH%\%RUNROM%,INIVARS,EMUZ
IniRead,CMDLINE,%RUNPTH%\%RUNROM%,RUNVARS,CMDLINE


IfNotExist, %BSLDIR%\BSL.ini
	{
		FileAppend,[OPTIONS]`n,%BSLDIR%\BSL.ini
		FileAppend,frontend=MediaCenter`n,%BSLDIR%\BSL.ini
		FileAppend,Joystick=`n,%BSLDIR%\BSL.ini
		FileAppend,Xpadder=`n,%BSLDIR%\BSL.ini
		FileAppend,Daemon_Tools=`n,%BSLDIR%\BSL.ini
		FileAppend,configurations=`n,%BSLDIR%\BSL.ini
		FileAppend,jacket_inject=`n,%BSLDIR%\BSL.ini
		FileAppend,custom_A=`n,%BSLDIR%\BSL.ini
		FileAppend,custom_B=`n,%BSLDIR%\BSL.ini
		FileAppend,custom_Y=`n,%BSLDIR%\BSL.ini
		FileAppend,custom_Z=`n,%BSLDIR%\BSL.ini
	}

Loop, Read, %BSLDIR%\BSL.ini
	{
		gbsl1= 
		gbsl2= 
		stringsplit,gbsl,A_LoopReadLine,=,"
		;"
		if (gbsl2 = "")
			{
				continue
			}
		stringreplace,syset,gbsl1,_,,All
		%syset%= %gbsl2%
	}
if (Jacket_inject = 1)
	{
;;		FileRead,
	}
if ((frontend = "")&&(FETYP = ""))
	{
		FETYP= .
	}
if ((Joystick = "")&&(JYTP = ""))
	{
		JYTP= .
	}
if ((Xpadder = "")&&(JYZ = ""))
	{
		JYZ= .
	}
if ((DaemonTools = "")&&(DMT = ""))
	{
		DMT= .
	}
if ((configurations = "")&&(CFG = ""))
	{
		CFG= .
	}
if ((customA = "")&&(CCMDA = ""))
	{
		CCMDA= .
	}
if ((customB = "")&&(CCMDB = ""))
	{
		CCMDB= .
	}
if ((customY = "")&&(CCMDY = ""))
	{
		CCMDY= .
	}
if ((customZ = "")&&(CCMDZ = ""))
	{
		CCMDZ= .
	}

Process, Exist, xbmc.exe
xbmc_pid=%errorLevel%
If (xbmc_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("xbmc.exe")
	}

Process, Exist, kodi.exe
xbmc_pid=%errorLevel%
If (kodi_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("kodi.exe")
	}

Process, Exist, LaunchBox.exe
xbmc_pid=%errorLevel%
If (LaunchBox_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("LaunchBox.exe")
	}
Process, Exist, PlayniteUI.exe
Playnite_pid=%errorLevel%
If (PlayNite_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("PlayniteUI.exe")
	}

Process, Exist, emulationstation.exe    
emus_pid=%errorLevel%
If (emus_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("emulationstation.exe")
	}

Process, Exist, ehshell.exe   
ehshell_pid=%errorLevel%
If (ehshell_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("ehshell.exe")
	}

Process, Exist, cabrio.exe
cabrio_pid=%errorLevel%
If (cabrio_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("cabrio.exe")
	}

Process, Exist, Steam.exe    
Steam_pid=%errorLevel%
If (Steam_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("Steam.exe")
	}

Process, Exist, retrofe.exe    
retrofe_pid=%errorLevel%
If (retrofe_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("retrofe.exe")
	}

Process, Exist, HyperSpin.exe    
Hyperspin_pid=%errorLevel%
If (Hyperspin_pid = 0)
	{
		{
			If ! errorLevel
				{
				}
		}      
	}
else
	{
		Process_Suspend("Hyperspin.exe")
	}
;msgbox,,,"%FETYP%" "%JYTP%" "%JYZ%" "%DMT%" "%CFG%" "%CCMDA%" "%CCMDB%" "%CCMDY%" "%CCMDZ%"	


;Runwait, %1% "%FETYP%" "%JYTP%" "%JYZ%" "%DMT%" "%CFG%" "%CCMDA%" "%CCMDB%" "%CCMDY%" "%CCMDZ%",%RUNPTH% 
Runwait, %1% "%FETYP%" "%JYTP%" "%JYZ%" "%DMT%" "%CFG%" "%CCMDA%" "%CCMDB%" "%CCMDY%" "%CCMDZ%",%RUNPTH% ,Hide UseErrorLevel

if (ErrorLevel = "ERROR")
	{
	}

Process_Resume("PlayniteUI.exe")
Process_Resume("LaunchBox.exe")
Process_Resume("kodi.exe")
Process_Resume("xbmc.exe")
Process_Resume("Steam.exe")
Process_Resume("retrofe.exe")
Process_Resume("emulationstation.exe")
Process_Resume("cabrio.exe")
Process_Resume("ehshell.exe")
Process_Resume("Hyperspin.exe")

WinRestore, ahk_pid ehshell_pid
;;WinRestore, Windows Media Center
WinRestore, ahk_pid LaunchBox_pid
;;WinRestore, LaunchBox
WinRestore, ahk_pid retrofe_pid
;;WinRestore, RetroFE
WinRestore, ahk_pid Steam_pid
;;WinRestore, Steam
WinRestore, ahk_pid kodi_pid
;;WinRestore, KODI
WinRestore, ahk_pid xmbc_pid
;;WinRestore, XBMC
WinRestore, ahk_pid %EmulationStation_pid%
;;WinRestore, EmulationStation
WinRestore, ahk_pid %HyperSpin_pid%
;;WinRestore, HyperSpin
WinRestore, ahk_pid %Playnite_Pid%
;;WinRestore, Cabrio
WinRestore, ahk_pid %Cabrio_pid%

exitapp
esc::
exit

ProcExist(PID_or_Name="")
	{
		Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
		Return Errorlevel
	}

Process_Resume(PID_or_Name)
	{
		PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
		h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
		If !h   
		Return -1
		DllCall("ntdll.dll\NtResumeProcess", "Int", h)
		DllCall("CloseHandle", "Int", h)
	}

Process_Suspend(PID_or_Name)
	{
		PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
		h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
		If !h   
		Return -1
		DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
		DllCall("CloseHandle", "Int", h)
	}