#NoEnv
#SingleInstance Force
SetBatchLines -1
FileRead,romlist,romlist.txt
stringreplace,romlist,romlist,roms\,,All
filereadline,frm,romlist.txt,1
filereadline,rtt,romlist.txt,2
AMIC= antimicro.exe
IniRead, keymapper, exeparam.ini,EXECUTABLE,keymapper
if (keymapper = 1)
	{
		gjc= "%AMIC% -l"
		stdout := StdoutToVar_CreateProcess(gjc)
		if (StdOut <> "")
			{
				xtnv= 	
				dskinc=
				Loop, Parse, StdOut,`n`r
					{
						stringsplit,njf,A_LoopField,:
						if (njf1 = "# of joysticks found")
							{
								if (njf2 > 1)
									{
										p2prof= --profile-controller 2 --profile Player2.amgp
									}
							}
					}
			}
		Run, antimicro\%AMIC% --hidden --profile-controller 1 --profile "Select.amgp",%A_ScriptDir%,min,amik
	}
IniRead, emulator, exeparam.ini,EXECUTABLE,emulator
IniRead, arguments, exeparam.ini,EXECUTABLE,arguments
if (arguments = "ERROR")
	{
		arguments=
	}
IniRead, options, exeparam.ini,EXECUTABLE,options
if (options = "ERROR")
	{
		options= 
	}
options.= A_Space

IniRead, quotes, exeparam.ini,EXECUTABLE,quotes
if (quotes = "ERROR")
	{
		quotes= 1
	}
IniRead, extension, exeparam.ini,EXECUTABLE,extension
if (extension = "ERROR")
	{
		extension= 1
	}
IniRead, path, exeparam.ini,EXECUTABLE,path
if (path = "ERROR")
	{
		path= 1
	}
stringreplace,romlist,romlist,`n,|,All
Hotkey, Enter, Button_OK
gosub GUI
return

Gui:
if (rtt = "")
	{
		RUNROM:= "%frm%"
		goto, LAUNCH
	}
Gui, Add, Button,  xp w90 yp gButton_OK, Launch
Gui, Add, Listview, xp yp+30 -E0x200 R5 w200 -Multi hwndThisList vMyList,|
Gui +Resize	

Gosub LV_populate
Gui, Show, h420, Select
GuiControl, Focus, MyList
return

GuiSize:
if A_EventInfo = 1
	{
		return
	}
GuiControl, Move, MyList, % "W" . (A_GuiWidth - 10) . " H" . (A_GuiHeight - 40)
return


;;enter::
Button_OK:
gui,submit,nohide
guicontrol,focus,MyList
RowNum := LV_GetNext(,"Focused")
LV_GetText(Selected,RowNum,1)
RUNROM= "%A_ScriptDir%\roms\%selected%"

LAUNCH:
if (path = "")
	{
		splitpath,RUNROM,RUNROM
	}
if (extension = "")
	{
		splitpath,RUNROM,,,,RUNROM
	}
	
if (quotes = "")
	{
		stringreplace,RUNROM,RUNROM,",,All
		;"
	}
if (keymapper = 1)
	{
		Run, antimicro\%AMIC% --hidden --profile-controller 1 --profile "Player1.amgp" %p2prof%,%A_ScriptDir%,min
	}
stringreplace,RUNROM,RUNROM,`n,,All
stringreplace,RUNROM,RUNROM,`r,,All	
gui,minimize
;;msgbox,,, %emulator%%options%%runrom%%arguments%
RunWait, %emulator%%options%%runrom%%arguments%,%A_ScriptDir%\emu
if (keymapper = 1)
	{
		Process, close, %amik%
	}
GuiClose:
GuiEscape:
ExitApp
return

LV_populate:
IfExist romlist.txt
	{
		Loop, parse, romlist,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				entry := A_LoopField
				if !entry
				continue
				LV_Add("",entry)
			}
	}
return

StdoutToVar_CreateProcess(sCmd, bStream="", sDir="", sInput="")
   {
   bStream=   ; not implemented
   sDir=      ; not implemented
   sInput=    ; not implemented
   
   DllCall("CreatePipe","Ptr*",hStdInRd
                       ,"Ptr*",hStdInWr
                       ,"Uint",0
                       ,"Uint",0)
   DllCall("CreatePipe","Ptr*",hStdOutRd
                       ,"Ptr*",hStdOutWr
                       ,"Uint",0
                       ,"Uint",0)
   DllCall("SetHandleInformation","Ptr",hStdInRd
                                ,"Uint",1
                                ,"Uint",1)
   DllCall("SetHandleInformation","Ptr",hStdOutWr
                                ,"Uint",1
                                ,"Uint",1)

   if A_PtrSize=4
      {
      VarSetCapacity(pi, 16, 0)
      sisize:=VarSetCapacity(si,68,0)
      NumPut(sisize,    si,  0, "UInt")
      NumPut(0x100,     si, 44, "UInt")
      NumPut(hStdInRd , si, 56, "Ptr")
      NumPut(hStdOutWr, si, 60, "Ptr")
      NumPut(hStdOutWr, si, 64, "Ptr")
      }
   else if A_PtrSize=8
      {
      VarSetCapacity(pi, 24, 0)
      sisize:=VarSetCapacity(si,96,0)
      NumPut(sisize,    si,  0, "UInt")
      NumPut(0x100,     si, 60, "UInt")
      NumPut(hStdInRd , si, 80, "Ptr")
      NumPut(hStdOutWr, si, 88, "Ptr")
      NumPut(hStdOutWr, si, 96, "Ptr")
      }

   DllCall("CreateProcess", "Uint", 0
                           , "Ptr", &sCmd
                          , "Uint", 0
                          , "Uint", 0
                           , "Int", True
                          , "Uint", 0x08000000
                          , "Uint", 0
                          , "Uint", 0
                           , "Ptr", &si
                           , "Ptr", &pi)

   DllCall("CloseHandle","Ptr",NumGet(pi,0))
   DllCall("CloseHandle","Ptr",NumGet(pi,A_PtrSize))
   DllCall("CloseHandle","Ptr",hStdOutWr)
   DllCall("CloseHandle","Ptr",hStdInRd)
   DllCall("CloseHandle","Ptr",hStdInWr)

   VarSetCapacity(sTemp,4095)
   nSize:=0
   loop
      {
      result:=DllCall("Kernel32.dll\ReadFile", "Uint", hStdOutRd
                                             ,  "Ptr", &sTemp
                                             , "Uint", 4095
                                             ,"UintP", nSize
                                              ,"Uint", 0)
      if (result="0")
         break
      else
         sOutput:= sOutput . StrGet(&sTemp,nSize,"CP850")
      }

   DllCall("CloseHandle","Ptr",hStdOutRd)
   Return,sOutput
   }
return