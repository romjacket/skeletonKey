#NoEnv
#SingleInstance Force
Process, Exist,
CURPID= %ERRORLEVEL%
makePortable:
filedelete,d.tmp
filedelete,..\vdrv.tmp
splitpath,A_ScriptDir,,,,,skeldrv
RunWait, %comspec% cmd /c for /F "usebackq tokens=1`,2`,3`,4 " `%i in (`wmic logicaldisk get caption^`,description^`,drivetype 2^ >NUL`) do (if `%l equ 2 echo.`%i>>d.tmp),,hide
filereadline,NWDRV,d.tmp,1
RunWait, %comspec% cmd /c start /w "%A_ScriptDir%\VDrive.exe" configuration && if "`%VDrive`%" NEQ "" echo.`%VDrive`%>"..\vdrv.tmp"&& exit /b|| exit /b),,hide
filereadline,tmpraloc,..\vdrv.tmp,1
if ((tmpraloc = "") or (tmpraloc = "`%VDrive`%"))
	{
		tmpraloc= %A_ScriptDir%\..
	}

;;pcfgext= *.ini|*.cfg|*.config|*.conf|*.xml|*.settings|*.opt
pcfgext= ini|cfg|config|conf|xml|settings|opt
stringsplit,pcfgxt,pcfgext,= | ""
recfgf= ovr.ini|hashdb.ini|Assignments.ini|AppParams.ini|Settings.ini|config.cfg
IfNotExist, ..\Settings.ini
	{
		TGLPBL= 1
		MsgBox,3,No Settings,No Settings.ini file has not been found.`nOpen skeleteonKey and create a config?
		ifmsgbox,Ok
			{
				Run,..\Skeletonkey.exe
			}
		goto Quitout
	}
skeloc=
oldskel=
IniRead, pcfgskel, ..\Settings.ini,GLOBAL,working_config
SplitPath,pcfgskel,,oldskel
guicontrol,,PRBFND,|%oldskel%||%oldra%
if (A_ScriptDir <> oldskel)
	{
		gosub, SetPSK
		ifnotexist, %oldskel%
			{
				oldskel:= skeloc
			}
	}
IniRead,syslocdir,..\Settings.ini,GLOBAL,systems_directory
if ((syslocdir = "")or(syslocdir = "ERROR"))
	{
		fileselectFolder, syslocdir,, 3,Select Systems Directory
		if (syslocdir= "")
			{
				SB_SetText("You must select a systems directory")
				return
			}
}

Gui, Add, Button,x333 y0 w43 h22 vSETPRA gSetPRA, Select
Gui, Add, Button, x333 y24 w43 h21 vSETPSK gSetPSK, Select
Gui, Add, Edit, x6 y0 w323 h21 vDisplRaTXT gDisplRaTXT, %syslocdir%
Gui, Add, Edit, x6 y24 w323 h21 vDisplSkTXT gDisplSkTXT, %oldskel%
Gui, Add, Button, x4 y63 w29 h20 vSeekRep gSeekRep, File
Gui, Add, CheckBox, x37 y66 w118 h14 vTGLREP gTglRep, Replace instances of
Gui, Add, ComboBox, x158 y59 w216 vPRBFND gPrbFnd disabled, |%syslocdir%||
Gui, Add, Text, x39 y86h16 vPToTxt disabled, To
Gui, Add, ComboBox, x56 y82 w218 h21 vPRBREP gPrbRep disabled, |%syslocdir%||
Gui, Add, Checkbox, x278 y84 h23 vPplTxt gPortablocal disabled checked, localize
;;gui, Add, Text, x278 y84 h23 vPplTxt disabled hidden, in playlists
gui, font, Bold
Gui, Add, Button, x335 y82 w40 h20 vINJPORTABLE gInjPortable, OK
gui, font, normal
Gui, Add, CheckBox, x246 y46 h13 vMKPDTI gMKPDTI Checked, Create a desktop icon
Gui, Add, CheckBox, x6 y46 h13 vSETSYSTMP gSETSYSTMP, host cache_directory
Gui, Add, StatusBar, vPRBSTATUS, Feedback
Gui Show, w379 h131, PortableUtil
return

;{;;;;;;;;;;;;  ASSIGN PORTABLE DIRECTORIES ;;;;;;;;;;;;;;;


SetPSK:
gui,submit,nohide
skeloc=
FileSelectFolder, skeloc,,3,Select the portable skeletonkey folder
if (skeloc = "")
	{
		goto, QUITOUT
	}
guicontrol,,DisplSkTXT, %skeloc%
return

SETSYSTMP:
gui,submit,nohide
if (SETSYSTMP = 0)
{
	systemp= %temp%
	return
}
FileDelete, %lpful%\tst.txt
FileAppend, tst,%lpful%\tst.txt
if (errorLevel <> 0)
	{
		guicontrol,,SETSYSTMP,0
		systemp= %temp%
		SB_SetText("cache directory set to " lpful "")
		return
	}
systemp= %lpful%
return
;};;;;;;;;;;;;;;;;;;;;

DisplRaTXT:
gui,submit,nohide
guicontrolget,DisplRaTXT,,DisplRaTXT
return

DisplSkTXT:
gui,submit,nohide
guicontrolget,DisplSkTXT,,DisplSkTXT
return

Portablocal:
gui,submit,nohide
guicontrolget, Ppltxt,,PplTxt
return

InjPortable:
gui,submit,nohide
guicontrolget,Ppltxt,,PplTxt
guicontrolget,pradir,,DisplRaTXT
guicontrolget,skeloc,,DisplSkTXT
guicontrolget,MKPDTI,,MKPDTI
if (MKPDTI = 1)
	{
		FileDelete,%A_Desktop%\skeletonKey.lnk
		FileCreateShortcut, %skeloc%\skeletonKey.exe, %A_Desktop%\skeletonKey.lnk, %skeloc%\, , Portable skeletonKey, %skeloc%\key.ico
	}
IniWrite, "%syslocdir%",..\Settings.ini,GLOBAL,systems_directory
iniread,cdtmp,..\Settings.ini,OPTIONS,cache_directory
if (cdtmp = "ERROR")
	{

	}
IniWrite, "%systemp%",..\Settings.ini,OPTIONS,temp_location
if (TGLREP = 1)
	{
		guicontrolget,PRBFND,,PRBFND
		guicontrolget,PRBREP,,PRBREP
		if (PRBFND <> "")
			{
				Loop, Parse, recfgf,|
					{
						FileRead,REPB,..\%A_LoopField%
						FileMove,..\%A_LoopField%,..\%A_LoopField%.bak,1
						StringReplace,NREPB,REPB,%PRBFND%,%PRBREP%,All
						SB_SetText("Replacing in file " A_LoopField " ")
						FileAppend,%NREPB%,..\%A_LoopField%
					}
				ar := Object()
				Loop, Parse, %pcfgxt0%
					{
						new= % (pcfgext%a_index%)
						if (pcfgext%a_index% <> "")
							{
								ar.insert(new)
							}
					}
				cfgplst=
				Loop, Files, cfg\*.*,R
					{
						ext= %A_LoopFileExt%
						noapl=
						for k, v in ar
							{
								extm:= v
								if (ext = extm)
									{
										noapl= 1
									}
							}
						if (noapl = 1)
							{
								cfgplst .= A_LoopFileFullPath . "|"
							}
					}
				Loop, Files, %RJEMUD%\*.*,R
					{
						ext= %A_LoopFileExt%
						noapl=
						for k, v in ar
							{
								extm:= v
								if (ext = extm)
									{
										noapl= 1
									}
							}
						if (noapl = 1)
							{
								cfgplst .= A_LoopFileFullPath . "|"
							}
					}
				if (Ppltxt = 1)
					{
						Loop, Files, %pradir%\playlists\*.lpl
							{
								subpl.= A_LoopFileFullPath . "|"
							}
						Loop, Parse, subpl,|
							{
								FileRead,REPB,%A_LoopField%
								SplitPath,A_LoopField,repfn
								SB_SetText("Replacing in playlist " A_LoopField  " ")
								FileMove,%A_LoopField%,%A_LoopField%.bak,1
								StringReplace,NREPB,REPB,%PRBFND%,downloads,All
								FileAppend,%NREPB%,%A_LoopField%
							}
					}
				if (Ppltxt = 0)
						{
							Loop, Files, %pradir%\playlists\*.lpl
								{
									cfgplst.= A_LoopFileFullPath . "|"
								}
						}
				Loop, Parse, cfgplst,|
					{
						FileRead,REPB,%A_LoopField%
						SplitPath,A_LoopField,repfn
						SB_SetText("Replacing in file " repfn "")
						FileMove,%A_LoopField%,%A_LoopField%.bak,1
						StringReplace,NREPB,REPB,%PRBFND%,%PRBREP%,All
						FileAppend,%NREPB%,%A_LoopField%
					}
		}
	}
msgbox,0,,SkeletonKey can now be launched from the portable device.,10
gui,1:destroy
gosub, QUITOUT
exitapp
return

SeekRep:
gui,submit,nohide
lplsrch=
Fileselectfile,lplsrch,3,,Select a playlist file or database
guicontrolget,PRBFND,,PRBFND
SB_SetText("...Searching...")
fullnm=
fullnm:= StrLen(PRBFND)
if (lplsrch = "")
	{
		return
	}
repPl=
arbdfn=
fndrep=
Loop, read, %lplsrch%
	{
		arbdfn+=1
		vok=
		newprfx := StrLen(A_LoopReadLine)
		if (PRBFND <> "")
			{
				ifinstring,A_LoopReadLine,%PRBFND%
					{
						StringGetPos,vok,A_LoopReadLine, %PRBFND%,
						if (vok >= 0)
							{
								vokk:= vok+fullnm
								newrepp=
								stringleft,newrepp,A_LoopReadLine,%vokk%
								if (newrepp <> fndrep)
									{
										msgbox,4, Search string found,`n"%newrepp%" was detected.`nWould you like to migrate this to your current portable setup?
										IfMsgBox,Yes
											{
												repPl= 1
												SB_SetText(" " newrepp " found")
												guicontrol,,PRBFND,|%newrepp%||%PRBFND%|%syslocdir%
												break
											}
										IfMsgBox,No
											{
												repPl= 0
												fndrep= %newrepp%
											}
									}
							}
					}
			}
	}
Loop, Parse, recfgf,|
	{
		FileRead, RepSet, ..\%A_LoopField%
		FileDelete, ..\%A_LoopField%
		StringReplace, gvo, RepSet,%skeloc%, %skeloc%, All
		StringReplace, repout,gvo,%ralocsel%, %syslocdir%, All
		FileAppend, %repout%, ..\%A_LoopField%
	}

return

TglRep:
gui,submit,nohide
guicontrolget,TGLREP,,TGLREP
guicontrol,disable,PToTxt
guicontrol,disable,PplTxt
guicontrol,disable,PRBREP
guicontrol,disable,PRBFND
if (TGLREP = 1)
	{
		guicontrol,enable,PToTxt
		guicontrol,enable,PplTxt
		guicontrol,enable,PRBREP
		guicontrol,enable,PRBFND
	}
return

MKPDTI:
gui,submit,nohide
return
PrbRep:
gui,submit,nohide
guicontrolget,PRBREP,,PRBREP
return

PrbFnd:
gui,submit,nohide
guicontrolget,PRBFND,,PRBFND
return

;};;;;;;;;;;;;;;;;;

#IfWinActive PortableUtil
esc::
msgbox, 8452,Exiting, Would you like to close the PortableUtil?
ifmsgbox, yes
	{
		gosub, QUITOUT
	}
return


QUITOUT:
GuiEscape:
GuiClose:
Process, close, PortableUtil.exe
Process, close,  %CURPID%
ExitApp