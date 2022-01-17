#NoEnv
#SingleInstance Force
SetBatchLines -1
SetTitlematchMode,2
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
IniRead, exe_title, exeparam.ini,EXECUTABLE,exe_title
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

Gui:
if (rtt = "")
	{
		RUNROM= "%A_ScriptDir%\%frm%"
		splitpath,runrom,,,runxt,runfrm
		goto, LAUNCH
	}
retroms= 1	
Gui, Add, Button,  xp w90 yp gButton_OK, Launch
Gui, Add, Listview, xp yp+30 -E0x200 R5 w200 -Multi hwndThisList vMyList gMyList,|
Gui +Resize

Gosub LV_populate
Gui, Show, h420, %exe_title%
GuiControl, Focus, MyList
guicontrolget,MyList,,MyList
return

MyList:
guicontrolget,MyList,,MyList
return

GuiSize:
if A_EventInfo = 1
	{
		return
	}
GuiControl, Move, MyList, % "W" . (A_GuiWidth - 10) . " H" . (A_GuiHeight - 40)
return

enter::
send, {enter}
If (A_GuiControl = MyList)
	{
		Hotkey, enter , off
		goto Button_OK
		return
	}
	else {
	} 
return

;;enter::
Button_OK:
gui,submit,nohide
guicontrol,focus,MyList
RowNum := LV_GetNext(,"Focused")
LV_GetText(Selected,RowNum,1)
if (selected = "")
	{
		return
	}
splitpath,selected,,,runxt,runfrm	
RUNROM= "%A_ScriptDir%\roms\%selected%"

LAUNCH:
gui, destroy
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
		Loop, 2
			{
				ifexist,%runfrm%_Player%A_Index%.amgp
					{
						p%A_index%gam= %runfrm%_Player%A_Index%
						if (A_Index = 2)
							{
								stringreplace,p2prof,p2prof,Player2,%runfrm%_Player2,All
							}
					}
				else {
					p%A_index%gam= Player%A_Index%.amgp
				}
				
			}
		Run, antimicro\%AMIC% --hidden --profile-controller 1 --profile "%p1gam%.amgp" %p2prof%,%A_ScriptDir%,min,amik
	}
stringreplace,RUNROM,RUNROM,`n,,All
stringreplace,RUNROM,RUNROM,`r,,All	
gui,minimize
if (retroms = 1)
	{
		gosub, pre
	}
RunWait, %emulator%%options%%runrom%%arguments%,%A_ScriptDir%\emu

if (retroms = 1)
	{
		Hotkey, enter , On
		gosub, post
		goto, Gui
	}

GuiClose:
GuiEscape:
if (keymapper = 1)
	{
		Process, close, %amik%
	}
ExitApp
return

pre:
iniread,CFGFINC,exeparam.ini,EXECUTABLE,CFGFINC
Loop,parse,CFGFINC,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		ifinstring,A_LoopField,*.
			{
				stringsplit,ebe,A_LoopField,*
				manfbx= %ebe2%
			}
		Loop,files,emu\%A_LoopField%
			{
				stringreplace,enr,A_LoopFilename,%runfrm%_,,All
				if (ERRORLEVEL = 0)
					{
					}
				filemove,%A_LoopFileFullPath%,%enr%,1
				filemove,%runfrm%_%A_LoopFileFullPath%,%enr%,1
			}
	}
return

post:
Loop,parse,CFGFINC,|
	{
		if (A_LoopField = "")
			{
				continue
			}	
		Loop,files,emu\%A_LoopField%
			{
				stringreplace,enr,A_LoopFileFullPath,%runfrm%_,,All
				filecopy,%enr%,emu\%runfrm%_%A_LoopFilename%,1
			}
	}
Loop, 2
	{
		ifnotexist,%runfrm%_Player%A_Index%.amgp
			{
				filecopy,Player%A_Index%.amgp, %runfrm%_Player%A_Index%.amgp,1
			}
	}
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