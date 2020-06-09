#NoEnv
#SingleInstance Force
rjsyst= %1%
rjemut= %2%
process, exist, %3%
if (ERRORLEVEL = 0)
	{
		exitapp
	}
splitpath,A_ScriptDir,,,,,drvp
RJEMUF= %ejemut%
RJSYSTEMS= %rjsyst%
if (RJEMUF = "")
	{
		RJEMUF= %drvp%\Emulators
		ejemut= %RJEUF%
	}
if (RJSYSTEMS = "")
	{
		RJSYSTEMS=%drvp%\Console
		rjsyst= %RJSYSTEMS%
	}	
ADJDIRS_TT :="Enables identification, detection and renaming or linking to supported nomenclature"
LNKDIR_TT :="Links detected console directories to supported nomenclature"
RNMDIR_TT :="Renames detected console directories to supported nomenclature"
INTRMSYS_TT :="The directory where ROMs should be located."
INTRMEMU_TT :="The directory where Emulators should be located."
SETJKR_TT :="Selcts the systems directory"
SETEMUD_TT :="Selects the emulators directory."
CONTINUE_TT :="Confirm the current settings and initializes setup."
LNKTOD_TT :="Sets the destination for linked folders`n***This will be skeletonKey's ''systems'' folder"

Gui,Font, Bold
Gui, Add, GroupBox, x100 y0 w169 h42
Gui, Add, GroupBox, x4 y0 w265 h162 +Center,< SETUP >
Gui,Font, Normal
Gui, Add, Text, x13 y10 h14, System Scan
Gui, Add, Text, x80 y96 w46 h18, Emulators
Gui, Add, Edit, x13 y42 w247 h42 vintrmsys +readonly,:DEFAULT:%rjsyst%
Gui, Add, Edit, x13 y110 w247 h42 vintrmemu +readonly,:DEFAULT:%rjemut%
Gui, Add, Checkbox, x105 y16 h16 Right vADJDIRS gADJDIRS checked,Identify Folders
Gui, Add, Radio, x205 y10 h14 vLNKDIR gLNKDIR,Link
Gui, Add, Radio, x205 y26 h14 vRNMDIR gRNMDIR checked,Rename
Gui, Add, Button, x248 y10 h16 w16 vLNKTOD gLNKTOD hidden,>
Gui,Font, Bold
Gui, Add, Button, x13 y24 w65 h18 gSETJKR, BROWSE
Gui, Add, Button, x13 y92 w65 h18 gSETEMUD, BROWSE
Gui Add, Button, x190 y163 w80 h23 vCONTINUE gCONTINUE, CONTINUE
Gui,Font, Normal
Gui Add, Text, x10 y168 w120 h13, Drag'n Drop supported
Gui Add, StatusBar,, Status Bar
OnMessage(0x200, "WM_MOUSEMOVE")
Gui, Show, w274 h211, Window
ifexist,%rjsyst%\
	{
		ifexist,%rjemut%\
			{
				RJSYSTEMS= %rjsyst%
				RJEMUF= %rjemut%
				IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
				IniWrite, "%RJSYSTEMS%",Settings.ini,GLOBAL,systems_directory
				guicontrol,enable,CONTINUE			
			}
	}
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}
return

SETJKD:
RJSYSTSL= %1%
SETJKR:
RJSYSTEMF=
FileSelectFolder, RJSYSTEMF,*%RJSYSTSL%,3,Select the Root folder for all systems %vvtmp%
RJSYSTEMFX= %RJSYSTEMF%
if (RJSYSTEMF = "")
	{
		IF (SYSRETRY = "1")
			{
				MsgBox,1,--=REQUIRED=--,You must select a location for your systems to continue.
			}
		if (SYSRETRY = "")
			{
				SYSRETRY= 1
				RJSYSTSL= 
				vvtmp= 
				goto, SETJKR
			}
	}
SYSTEMSELECTED:
stringright,efi,RJSYSTEMF,2	
stringLeft,efix,RJSYSTEMF,2
if (efi = ":\")
	{
		RJSYSDRV= %RJSYSTEMF%
		RJSYSTEMF= %efix%
		RJSYSTEMFX= %RJSYSTEMF%Console
	}
splitpath,RJSYSTEMFX,pthnm
if (pthnm = A_Username)
	{
		Msgbox,3,User Directory Root?,Systems Directory set to`n " %RJSYSTEMF%\Console "`n      Is this okay?
		ifmsgbox,yes
			{
				RJSYSTEMF=%RJSYSTEMF%\Console
				ifnotexist, %RJSYSTEMF%\Console
					{
						FileCreateDir,%RJSYSTEMF%\Console
						if (ERRORLEVEL <> 0)
							{
								Msgbox,5,Directory Creation Failed,Directory %RJSYSTEMF% could not be created.
								ifmsgbox, Retry
									{
										RJSYSTSL= 
										goto, SETJKR
									}
								FileDelete,Settings.ini
								Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
								ExitApp	
							}
					}
			}
		ifmsgbox,no
			{
				avhl= SJMPOT
				if (alii = 1)
					{
						avhl= SETJKD	
					}
				alii= 	
				goto, %avhl%
			}
		ifmsgbox,cancel
			{
				goto, SETJKD
			}
	
	}
if (efi = ":\")
	{
		SFEvb= Create a
		RJSYSTEMFR= %RJSYSTEMF%
		ifexist, %RJSYSTEMF%\Console
			{
				SFEvb= Use the
				RJSYSTEMFR= %RJSYSTEMF%\Console
			}
		Msgbox,8196,Confirm,%SFEvb% Console directory?,4
		RJSYSTEMF= %RJSYSTEMFR%
		ifmsgbox,no
			{
				RJSYSTEMF= %efix%
			}
		ifmsgbox,cancel
			{
				RJSYSTSL= 
				goto, SETJKR
			}
		ifnotexist, %RJSYSTEMF%\
			{
				filecreatedir,%RJSYSTEMF%
					if (ERRORLEVEL <> 0)
						{
							Msgbox,5,Directory Creation Failed,Directory %RJSYSTEMF% could not be created.
							ifmsgbox, Retry
								{
									RJSYSTSL= 
									goto, SETJKR
								}
							FileDelete,Settings.ini
							Run, %comspec% cmd /c taskkill /f /im init.exe,,hide
							Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
							ExitApp	
						}
			}
			
	}
fileappend,f,%RJSYSTEMF%\sk
if (ERRORLEVEL <> 0)
	{
		MsgBox,1,NoWrite,skeletonKey does not have write access`nAre you sure you want to use the ''%RJSYSTEMF%'' directory?
		ifMsgBox,OK
			{
				goto,JKDFINISH
			}
		goto, SETJKD
	}
	else {
		filedelete,%RJSYSTEMF%\sk
	}
JKDFINISH:
filedelete,%RJSYSTEMF%\sk
AUTOFUZ= 0
JUNCTOPT= 1
RJSYSTEMS= %RJSYSTEMF%
nfemu= 1
stringreplace,RJSYSTEMS,RJSYSTEMS,\\,\,All
IniWrite, "%RJSYSTEMS%",Settings.ini,GLOBAL,systems_directory

splitpath,RJSYSTEMF,RJHHS

guicontrol,,intrmsys,%RJSYSTEMS%
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}
return

LNKDIR:
gui,submit,nohide
guicontrol,show,LNKTOD
guicontrolget,RJSTMX,,intrmsys
stringreplace,RJSTMX,RJSTMX,:DEFAULT:,,All
SB_SetText("''Systems'' set to " RJSTMX "")
return

LNKTOD:
gui,submit,nohide
guicontrolget,RJSTMX,,intrmsys
stringreplace,RJSTMX,RJSTMX,:DEFAULT:,,All
stringleft,rjlimit,RJSTMX,3
LNKDEST= 
FileSelectFolder, LNKDEST,%rjlimit%,3,Select the Destination for Linked Directories
	if (LNKDEST = "")
		{
			return
			SB_SetText("The systems directory has been set to " RJSYSTEMS "")
		}
SB_SetText("Links --> " LNKDEST "")
return

RNMDIR:
gui,submit,nohide
guicontrol,hide,LNKTOD
return


ADJDIRS:
gui,submit,nohide
guicontrolget,ADJDIRS,,ADJDIRS
if (ADJDIRS = 0)
	{
		guicontrol,disable,LNKDIR
		guicontrol,disable,RNMDIR
		iniwrite,"0",Settings.ini,GLOBAL,global_filter
		return
	}
iniwrite,"1",Settings.ini,GLOBAL,global_filter
guicontrol,enable,LNKDIR
guicontrol,enable,RNMDIR
return


SETEMUD:
ifexist, %A_ScriptDir%\apps
	{
		EMUTSL= %A_ScriptDir%\apps
	}
ifexist, %drvp%\Emulators
	{
		EMUTSL= %drvp%\Emulators
	}
vvtmp= (cancel to select any location)
RJEMUF=

SETEMUR:
FileSelectFolder, RJEMUF,*%EMUTSL%,3,Select the Root folder for all emulators %vvtmp%
if (RJEMUF = "")
	{
		if (EMUTRST = 1)
			{
				MsgBox,1,--=REQUIRED=--,You must select a directory for emulators.			
			}
		if (EMUTRST = "")
			{
				emutrst= 1
				EMUTSL= 
				vvtmp= 
				goto, SETEMUR
			}
	}
emuselected:
splitpath,RJEMUF,usremum
stringright,efi,RJEMUF,2	
stringLeft,efix,RJEMUF,2	
if (usremum = A_Username)
	{
		SFEvb= Create an
		ifexist,%RJEMUF%\Emulators
			{
				SFEvb= Use the
			}
		RJSDRV= %RJEMUF%
		RJEMUF= %RJEMUF%Emulators
		Msgbox,8196,Confirm,Confirm %SFEvb% Emulator directory?,4
		ifmsgbox,no
			{
				RJEMUF= %RJSDRV%
			}
		ifmsgbox,cancel
			{
				EMUTSL= 
				goto, SETEMUR
			}
		ifnotexist,%RJEMUF%\
			{
				filecreatedir,%RJEMUF%
				if (ERRORLEVEL <> 0)
					{
						Msgbox,5,Directory Creation Failed, Directory %RJEMUF% could not be created.
						ifmsgbox, Retry
							{
								EMUTSL= 
								goto, SETEMUR
							}
						FileDelete,Settings.ini
						Run, %comspec% cmd /c taskkill /f /im init.exe,,hide
						Run, %comspec% cmd /c taskkill /f /im skeletonKey.exe,,hide
						ExitApp
					}
			}
	}
if (efi = ":\")
	{
		RJEMUF= %efix%
	}
fileappend,f,%RJEMUF%\sk
if (ERRORLEVEL <> 0)
	{
		MsgBox,1,NoWrite,skeletonKey does not have write access`nAre you sure you want to use the ''%RJEMUF%'' directory?
		ifMsgBox,OK
			{
				goto,EMUDFINISH
			}
		goto, SETEMUD
	}
EMUDFINISH:
filedelete,%RJEMUF%\sk
IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
guicontrol,,intrmemu,%RJEMUF%
iniread,RJSYSTEMS,Settings.ini,GLOBAL,systems_directory
iniread,RJEMUD,Settings.ini,GLOBAL,emulators_directory
if ((RJSYSTEMS <> "") && (RJEMUD <> "") && (RJSYSTEMS <> "ERROR") && (RJEMUD <> "ERROR"))
	{
		guicontrol,enable,CONTINUE
	}

return

CONTINUE:
gui,submit,nohide
guicontrolget,RJEMUF,,intrmemu
guicontrolget,ADJDIRS,,ADJDIRS
guicontrolget,RJSYSTEMS,,intrmsys
if ((RJEMUF = "") or (RJSYSTEMS = "") or (RJEMUF = ":DEFAULT:") or (RJSYSTEMS = ":DEFAULT:"))
	{
		msgbox,,Not Set,An Emulator Directory and a Systems Directory Must be set to continue
		return
	}

stringreplace,RJEMUF,RJEMUF,:DEFAULT:,,All
ifnotexist,%RJEMUF%\
	{
		filecreatedir,%RJEMUF%
		ifnotexist,%RJEMUF%\
			{
				SB_SetText("Cannot create directory")
				return
			}
		guicontrol,,intrmenu,%RJEMUF%	
	}
stringreplace,RJSYSTEMS,RJSYSTEMS,:DEFAULT:,,All

ifnotexist,%RJSYSTEMS%\
	{
		filecreatedir,%RJSYSTEMS%
		ifnotexist,%RJSYSTEMS%\
			{
				SB_SetText("Cannot create directory")
				return
			}
	}
LNKVRJ= %LNKDEST%
if (LNKVRJ = "")
	{
		LNKVRJ= %RJSYSTEMS%
	}
IniWrite, "%RJEMUF%",Settings.ini,GLOBAL,emulators_directory
IniWrite, "%LNKVRJ%",Settings.ini,GLOBAL,systems_directory
exlst= |
exls= |
guicontrolget,RNMDIR,,RNMDIR

guicontrol,disable,continue
guicontrol,disable,SETJKR
guicontrol,disable,LNKDIR
guicontrol,disable,RNMDIR
guicontrol,disable,ADJDIRS
guicontrol,disable,SETEMUD
FileRead,SysLLst,sets\lkup.set
FileRead,fuzsys,sets\fuzsyslk.set	
SB_SetText("Detecting systems")
if (ADJDIRS = 1)
	{
		loop, %RJSYSTEMS%\*,2
			{
				if sym_link(A_LoopFileLongPath,nii)
				 {
					 SB_SetText(" " A_LoopFileName " ")
					 lnk_List .= (lnk_List?"`n":"") A_LoopFileFullPath
				 }
			}
		loop,parse,lnk_List,`n
			{
				if (A_LoopField = "")
					{
						continue
					}
				filedelete,dxt.ini	
				runwait, %comspec% cmd /c "for /f "tokens=2`,3 delims=<>" `%a in ('dir /a:d "%a_LoopField%*?`"') do if "`%~a"=="JUNCTION" for /f "tokens=* delims= " `%n in ("`%~b") do echo."`%~n" >dxt.ini &&exit /b ",,hide
				ifexist, dxt.ini
					{
						filereadline,fei,dxt.ini,1
						stringsplit,fnn,fei,:
						stringtrimright,fax,fnn1,3
						stringreplace,fax,fax,",,All
						;"
						stringright,hh,fnn1,1
						stringtrimright,fam,fnn2,4
						knin= %hh%:%fam%
						ifnotexist,%knin%\
							{
								fileremovedir,%fax%
							}
						a= 
						loop,%knin%\*.*
							{
								a+=1
								break
							}
						if (a < 1)
							{
								fileremovedir,%A_LoopFileLongPath%
							}	
					}
			}	
		Loop, Parse, SysLLst,`n`r
			{
				if (A_LoopField = "")
					{
						continue
					}
				stringsplit,afe,A_LoopField,=
				%afe2%= %afe1%
				ifexist,%RJSYSTEMS%\%afe1%\
					{
						av+= 1
						exlst.= afe1 . "|"
						exls.= afe2 . "|"
						if (LNKDEST = "")
							{
								continue
							}
						ifnotexist,%LNKDEST%\%afe1%\
							{
								Runwait,%comspec% /c mklink /J "%LNKDEST%\%fsys%" "%RJSYSTEMS%\%afe1%",,hide	
							}
					}	
			}
		SB_SetText(" " av " systems detected")
		Loop, parse, fuzsys,`n`r
			{
				 if (A_LoopField = "")
					{
						continue
					}
				fuzn1=
				fuzn2=
				flsn=
				fsys=
				stringsplit,fuztst,A_LoopField,>
				ifinstring,exls,|%fuztst2%|
					{
						continue
					}
				flsn= %fuztst2%
				fsys= % %fuztst2%
				Loop, Parse, fuztst1,|
					{
						aeg=
						Loop,%RJSYSTEMS%\%A_LoopField%,2
							{
								ifinstring,exlst,|%A_LoopFileName%|
									{
										continue
									}	
								if (RNMDIR = 1)
									{
										FileMoveDir,%A_LoopFileFullPath%,%A_LoopFileDir%\%fsys%,R							
										if (ERRORLEVEL <> 0)
											{
												SB_SetText("Could not rename " A_LoopFileName "")
												continue
											}
									}
									else {
										van= %LNKDEST%
										if (LNKDEST = "")
											{
												van= %A_LoopFileDir%
											}
										Runwait,%comspec% /c mklink /J "%van%\%fsys%" "%A_LoopFileName%",%A_LoopFileDir%,hide
										ifnotexist, %van%\%fsys%\
											{
												SB_SetText("Could not Link " A_LoopFileName "")
												fileappend,"%van%\%fsys%\:%A_LoopFileName%"`n,C:\users\romjacket\desktop\error.txt
												continue
											}								
									}
								ax+= 1	
							}
					}			
			}
		SB_SetText("Renamed " ax " directories")
	}
exitapp


ESC::
msgbox,1,Exit,Exit Skeletonkey?
ifmsgbox,OK
	{
		FileDelete,Settings.ini
		exitapp
	}
return
GuiClose:
FileDelete,Settings.ini
ExitApp

GuiDropFiles:
if ( (A_GuiX >= 13) && (A_GuiX <= 13+247) && (A_GuiY >= 42) && (A_GuiY <= 42+42) )
	{
		ifnotexist,%A_GuiEvent%\
			{
				return
			}
		RJSYSTEMF= %A_GuiEvent%
		gosub, systemselected
		return
	}

if ( (A_GuiX >= 14) && (A_GuiX <= 14+247) && (A_GuiY >= 110) && (A_GuiY <= 110+42) )
	{
		ifnotexist,%A_GuiEvent%\
			{
				return
			}
		RJEMUF= %A_GuiEvent%
		gosub, emuselected
		return
	}
return


WM_MOUSEMOVE(){
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl)
		{
			SetTimer, DisplayToolTip, -300
			PrevControl := CurrControl
		}
	return

	DisplayToolTip:
	try
			ToolTip % %CurrControl%_TT
	catch
			ToolTip
	SetTimer, RemoveToolTip, -2000
	return

	RemoveToolTip:
	ToolTip
	return
}

sym_link(filepath,ByRef target="", ByRef type="")
{
SplitPath, filepath , FileName, DirPath,
objShell :=   ComObjCreate("Shell.Application")
objFolder :=   objShell.NameSpace(DirPath)      ;set the directry path
objFolderItem :=   objFolder.ParseName(FileName)   ;set the file name
att := objFolder.GetDetailsOf(objFolderItem, 6)
target := objFolder.GetDetailsOf(objFolderItem, 189)
if (att="AL")
    type:="File"
else if (att="DL")
    type := "Folder"
if (att="AL" or att="DL")
    return 1
else
    return 0
}