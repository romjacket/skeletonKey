#NoEnv
;#Warn
;#NoTrayIcon
#Persistent
#SingleInstance Force



;{;;;;;;   TOGGLE   ;;;;;;;;;
SetWorkingDir %A_ScriptDir%
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
skeltmp= 
IfExist, %A_MyDocuments%\skeletonKey
	{
		skeltmp= %A_MyDocuments%\skeletonKey
	}
gitrttmp= 
IfExist, %A_MyDocuments%\Github
	{
		gitrttmp= %A_MyDocuments%\Github
	}
gittmp= 
IfExist, %A_MyDocuments%\Github\skeletonKey
	{
		gittmp= %A_MyDocuments%\Github\skeletonKey
	}
comptmp= 
IfExist, %A_ProgramFiles%\AutoHotkey\Compiler
	{
		comptmp= %A_ProgramFiles%\AutoHotkey\Compiler
	}
depltmp= 
IfExist, %A_MyDocuments%\Github\skeletonkey.deploy
	{
		depltmp= %A_MyDocuments%\Github\skeletonkey.deploy
	}
bldtmp= 
IfExist, %A_WorkingDir%\skdeploy.set
	{
		bldtmp= %A_WorkingDir%
	}

FormatTime, date, YYYY_MM_DD, yyyy-MM-dd
FormatTime, TimeString,,Time
rntp= hide
skhtnum=
oldvrnum= 
buildtnum= 
oldsznum= 
olsize= 
olsha= 
olrlsdt= 
vernum= 
INIT= 

if ("%1%" = "show")
	{
		rntp= 
	}

IfNotExist, skopt.ini
	{
		INIT= 1
		gosub, SelDir
	}
	
Loop, Read, skopt.ini
	{
		curvl1= 
		curvl2= 
		stringsplit, curvl, A_LoopReadLine,=
		if (curvl1 = "Build_Directory")
			{
				if (curvl2 <> "")
					{
						BUILDIR= %curvl2%
					}
			}
		if (curvl1 = "Working_file")
			{
				if (curvl2 <> "")
					{
						BUILDW= %curvl2%
					}
			}
		if (curvl1 = "Source_Directory")
			{
				if (curvl2 <> "")
					{
						SKELD= %curvl2%
					}
			}
		if (curvl1 = "Compiler_Directory")
			{
				if (curvl2 <> "")
					{
						AHKDIR= %curvl2%
					}
			}
		if (curvl1 = "Deployment_Directory")
			{
				if (curvl2 <> "")
					{
						DEPL= %curvl2%
					}
			}
	if (curvl1 = "NSIS")
			{
				if (curvl2 <> "")
					{
						NSIS= %curvl2%
					}
			}
	if (curvl1 = "Git_Root")
			{
				if (curvl2 <> "")
					{
						GITROOT= %curvl2%
					}
			}
	if (curvl1 = "Git_Directory")
			{
				if (curvl2 <> "")
					{
						GITD= %curvl2%
					}
			}

	if (curvl1 = "shader_url")
			{
				if (curvl2 <> "")
					{
						SHDRPURL= %curvl2%
					}
			}
	
	if (curvl1 = "net_ip")
			{
				if (curvl2 <> "")
					{
						GETIPADR= %curvl2%
					}
			}
	
	if (curvl1 = "lobby_url")
			{
				if (curvl2 <> "")
					{
						NLOB= %curvl2%
					}
			}
	
	if (curvl1 = "repository_url")
			{
				if (curvl2 <> "")
					{
						REPOURL= %curvl2%
					}
			}
	if (curvl1 = "update_url")
			{
				if (curvl2 <> "")
					{
						UPDTURL= %curvl2%
					}
			}
		if (curvl1 = "git_url")
				{
					if (curvl2 <> "")
						{
							GITSRC= %curvl2%
						}
				}
		if (curvl1 = "git_rls")
				{
					if (curvl2 <> "")
						{
							GITRLS= %curvl2%
						}
				}
		if (curvl1 = "git_username")
				{
					if (curvl2 <> "")
						{
							GITUSER= %curvl2%
						}
				}
		if (curvl1 = "git_token")
				{
					if (curvl2 <> "")
						{
							GITPAT= %curvl2%
						}
				}

	}	


if (GITROOT = "")
	{
		gosub, GitRoot
	}
if (GITROOT = "")
	{
		msgbox,1,,Git Root Directory must be set.
		ExitApp
		return
	}
if (BUILDIR = "")
	{
		gosub, GetBld
	}
if (BUILDIR = "")
	{
		msgbox,1,,Build Directory must be set.
		ExitApp
		return
	}
if (BUILDW = "")
	{
		gosub, GetWrk
	}
if (BUILDW = "")
	{
		msgbox,1,,Working development file must be set.
		ExitApp
		return
	}

if (GITRLS = "")
	{
		gosub, GetRls
	}
if (GITRLS = "")
	{
		msgbox,1,,Git-Release.exe must be set.
		ExitApp
		return
	}

if (SKELD = "")
	{
		gosub, GetSrc
	}
if (SKELD = "")
	{
		msgbox,1,,Source Directory must be set.
		ExitApp
		return
	}
if (AHKDIR = "")
	{
		gosub, GetComp
	}
if (AHKDIR = "")
	{
		msgbox,1,,Compiler Directory must be set.
		ExitApp
		return
	}
if (GITD = "")
	{
		gosub, GetGit
	}
if (GITD = "")
	{
		msgbox,1,,Git Directory must be set.
		ExitApp
		return
	}
	
if (GITUSER = "")
	{
		gosub, GetGUSR
	}
if (GITUSER = "")
	{
		msgbox,1,,Git User must be set.
		ExitApp
		return
	}

if (GITPAT = "")
	{
		gosub, GetGPAC
	}
if (GITPAT = "")
	{
		msgbox,1,,Git Personal Access Token must be set.
		ExitApp
		return
	}

if (GITRLS = "")
	{
		gosub, GetRls
	}
if (GITRLS = "")
	{
		msgbox,1,,Git-Release.exe must be set.
		ExitApp
		return
	}
	
if (NSIS = "")
	{
		nstmp= %ProgramFilesX86%
		gosub, GetNSIS
	}
if (NSIS = "")
	{
		msgbox,1,,makeNSIS.exe must be set.
		ExitApp
		return
	}
if (DEPL = "")
	{
		gosub, GetDepl
	}
if (DEPL = "")
	{
		msgbox,1,,Deployment Directory must be set.
		ExitApp
		return
	}
if (SHDRPURL = "")
	{
		gosub, GetShaderP
	}
if (REPOURL = "")
	{
		gosub, RepoURL
	}
if (GETIPADR = "")
	{
		gosub, GetIPAddr
	}
if (NLOB = "")
	{
		gosub, NewLobby
	}
if (UPDTURL = "")
	{
		gosub, UpdateURL
	}
if (GITSRC = "")
	{
		gosub, GitSRC
	}
oldsize=
oldsha= 
olrlsdt=
vernum=	

VERSIONGET:
sklnum= 
getversf= %gitroot%\%GITUSER%.github.io\index.html

ifnotexist,%getversf%
	{
		FileDelete,ORIGHTML.html
		UrlDownloadToFile, http://romjacket.github.io/index.html, ORIGHTML.html
		getversf= ORIGHTML.html
	}

Loop, Read, %getversf%
	{
		sklnum+=1
		getvern= 
		ifinstring,A_LoopReadLine,<h99>
			{
				stringgetpos,verstr,A_LoopReadLine,<h99>
				stringgetpos,endstr,A_LoopReadLine,</h99>
				strstr:= verstr + 6
				midstr:= (endstr - verstr - 5)
				stringmid,vernum,A_LoopReadLine,strstr,midstr
				if (midstr = 0)
					{
						vernum= 0.99.00.00
					}
				continue
			}
			ifinstring,A_LoopReadLine,<h88>
					{
						stringgetpos,verstr,A_LoopReadLine,<h88>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h87>
					{
						stringgetpos,verstr,A_LoopReadLine,<h87>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h77>
					{
						stringgetpos,verstr,A_LoopReadLine,<h77>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsha,sklin,%getvern%,40
						continue
					}
			ifinstring,A_LoopReadLine,<h66>
					{
						stringgetpos,verstr,A_LoopReadLine,<h66>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,olrlsdt,sklin,%getvern%,18
						continue
					}	
}
		
		
if (vernum = "")
	{
		vernum= [DIVERSION]
	}

;{;;;;;;;;;;;;;;;                     MENU                    ;;;;;;;;;;;;;;;;;;;;;;;
;Gui Add, Tab2, x2 y-1 w487 h171 Bottom, Deploy|Reset
;Gui, Tab, 1
;Gui Tab, Deploy
Gui, Add, Edit, x8 y24 w469 h50 vPushNotes gPushNotes,%date% :%A_Space%
Gui, Add, Edit, x11 y146 w115 h21 vVernum gVerNum +0x2, %vernum%
Gui, Add, CheckBox, x386 y100 w104 h23 vOvrStable gOvrStable, Overwite Stable
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCOMPILE gCOMPILE, DEPLOY
gui,font,normal
Gui, Add, Text, x8 y7, Git Push Description / changelog
Gui, Add, CheckBox, x9 y75 h17 vGitPush gGitPush checked, Git Push
Gui, Add, CheckBox, x9 y94 h17 vServerPush gServerPush checked, Server Push
Gui, Add, CheckBox, x9 y112 h17 vSiteUpdate gSiteUpdate checked, Site Update
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCANCEL gCANCEL hidden, CANCEL
gui,font,normal
Gui, Add, Text, x130 y150, Version
Gui, Add, CheckBox, x90 y76 w104 h13 vPortVer gPortVer checked, Portable Version
Gui, Add, CheckBox, x90 y95 w154 h13 vDevlVer gDevlVer checked, Development Version
Gui, Add, CheckBox, x90 y113 w154 h13 vDATBLD gDatBld, Database Recompile

Gui, Add, Text, x271 y82, Directory
Gui, Add, Button, x424 y78 w52 h21 vSELDIR gSelDir, Select
Gui, Add, DropDownList, x318 y78 w100 vSRCDD gSrcDD, Source||Compiler|Deployment|Build|NSIS|Github|Git-Release


Gui Add, DropDownList,x331 y2 w92 vResDD gResDD, Dev-Build||Portable-Build|Stable-Build|Deployer|Update-URL|Shader-URL|Repo-URL|Internet-IP-URL|Git-URL
Gui Add, Button, x425 y2 w52 h21 vResB gResB, Reset

Gui, Add, Progress, x12 y135 w388 h8 vprogb -Smooth, 0

Gui, Add, StatusBar, x0 y151 w488 h18, Compiler Status
Gui, Show, w488 h194,, Deploy skeletonKey
Return

;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SelDir:
gui,submit,nohide
if (INIT = 1)
	{
		SRCDD= Source
	}
if (SRCDD = "Source")
	{
		gosub, GetSrc
	}
if (INIT = 1)
	{
		SRCDD= Compiler
	}
if (SRCDD = "Compiler")
	{
		gosub, GetComp
	}
if (INIT = 1)
	{
		SRCDD= Git
	}
if (SRCDD = "Git")
	{
		gosub, GetGit
	}
if (INIT = 1)
	{
		SRCDD= Deployment
	}
if (SRCDD = "Deployment")
	{
		gosub, GetDepl
	}
if (INIT = 1)
	{
		SRCDD= Build
	}
if (SRCDD = "Build")
	{
		gosub, GetBld
	}
if (INIT = 1)
	{
		SRCDD= NSIS
	}
if (SRCDD = "NSIS")
	{
		nstmp= %ProgramFilesX86%
		gosub, GetNSIS
	}
INIT= 
return

GetNSIS:
NSIST= %NSIS%
ifexist, %nstmp%\NSIS\
	nstmp= %nstmp%\NSIS
FileSelectFile, NSIST,0,%nstmp%\makensis.exe,Select makensis.exe,makensis.exe
SplitPath, NSIST,,NSISD
nstmp= 
nsisexists= 
if (NSIS <> "")
	{
		if (NSIST = "")
			{
				SB_SetText("makensis.exe is " NSIS " ")
				return
			}
	}
Loop, %NSISD%\makensis.exe
	{
		nsisexists= 1
	}
if (nsisexists = 1)
	{
		NSIS:= NSIST
		iniwrite, %NSIS%,skopt.ini,GLOBAL,NSIS
		return
	}
Msgbox,5,makensis,makensis.exe not found
IfMsgBox, Abort
	{
		ExitApp
	}
nstmp= 
gosub, GetNSIS
return

GetWrk:
BUILDWT= %BUILDW%
FileSelectFile,BUILDWT,3,%BUILDIR%\working.ahk,Select The working development file,*.ahk
if (BUILDW <> "")
	{
		if (BUILDWT = "")
			{
				SB_SetText("Working development file is " BUILDW " ")
				return
			}
	}
if (BUILDWT = "")
	{
		return
	}
BUILDW= %BUILDWT%	
FileCopy, %BUILDIR%\Working.ahk,%BUILDIR%\Working.bak,1
FileCopy, %BUILDWT%,%BUILDIR%\Working.ahk,1
IniWrite, %BUILDW%,skopt.ini,GLOBAL,Working_file
return

GitRoot:
GITROOTT= %GITROOT%
FileSelectFolder, GITROOTT,%gitrttmp% ,1,Select The GitHub Directory
gitrttmp= 
gitrtexists= 
if (GITROOT <> "")
	{
		if (GITROOT = "")
			{
				SB_SetText("Github dir is " GITROOT " ")
				return
			}
	}
if (GITROOTT <> "")
	{
		GITROOT:= GITROOTT
		iniwrite, %GITROOT%,skopt.ini,GLOBAL,Git_Root
		return
	}
Msgbox,5,Github Root,Github Directory not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GitRoot
return

	
GetBld:
BUILDIT= %BUILDIR%
FileSelectFolder, BUILDIT,%bldtmp% ,1,Select The Build Directory
bldtmp= 
bldexists= 
if (BUILDIR <> "")
	{
		if (BUILDIT = "")
			{
				SB_SetText("BUILD dir is " BUILDIR " ")
				return
			}
	}
Loop, %BUILDIT%\skdeploy.set
	{
		bldexists= 1
	}
if (bldexists = 1)
	{
		BUILDIR:= BUILDIT
		iniwrite, %BUILDIR%,skopt.ini,GLOBAL,Build_Directory
		FileRead, nsiv, %BUILDIR%\skdeploy.set
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[INSTYP],-installer,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
		FileAppend, %nsiv%,%BUILDIR%\skdeploy.nsi
		return
	}
Msgbox,5,Build Dir,Build Directory not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GetBld
return

GetShaderP:
gui,submit,NoHide
SHDRPURL= 
if (SHDRPURLT = "") 
	SHDRPURLT= http://raw.githubusercontent.com/libretro/shader-previews/master/
inputbox,SHDRPURL,Shader Preveiw URL,Enter the url of the shader preview master directory,,345,140,,,,,%SHDRPURLT%
if (SHDRPURL = "")
	{
		SHDRPRUL= %SHDRPURLT%
	}
iniwrite,%SHDRPURL%,skopt.ini,GLOBAL,shader_url
return

GetIpAddr:
gui,submit,nohide
GETIPADR= 
if (GETIPADRT = "")
	GETIPADRT= http://www.netikus.net/show_ip.html
inputbox,GETIPADR,Internet-IP-Address,Enter the url of the file which contains your internet ip-address,,345,140,,,,,%GETIPADRT%
if (GETIPADR = "")
	{
		GETIPADR= %GETIPADRT%
	}
IniWrite,%GETIPADR%,skopt.ini,GLOBAL,net_ip
return

UpdateURL:
gui,submit,nohide
UPDTURL= 
if (UPDTURLT = "")
	UPDTURLT= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
inputbox,UPDTURL,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTURLT%
if (UPDTURL = "")
	{
		UPDTURL= %UPDTURLT%
	}
IniWrite,%UPDTURL%,skopt.ini,GLOBAL,update_url
return

UpdateFILE:
gui,submit,nohide
UPDTURL= 
if (UPDTFILET = "")
	UPDTFILET= http://raw.githubusercontent.com/romjacket/skeletonkey/master/skeletonKey.zip
inputbox,UPDTFILE,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTFILET%
if (UPDTFILE = "")
	{
		UPDTFILE= %UPDTFILET%
	}
IniWrite,%UPDTFILE%,skopt.ini,GLOBAL,update_file
return

GitSRC:
gui,submit,nohide
GitSRC= 
if (GitSRCT = "")
		GitSRC= http://github.com/romjacket/skeletonkey
inputbox,GitSRC,Git Repo,Enter the url for the git repo,,345,140,,,,,%GitSRC%
if (GitSRC = "")
	{
		GitSRC= %GitSRCT%
	}
IniWrite,%GitSRC%,skopt.ini,GLOBAL,git_url
return

RepoUrl:
gui,submit,nohide
REPOURL= 
if (REPORULT = "")
	REPOURLT= http://github.com/romjacket
	UPDTFILE= http://github.com/romjacket/skeletonKey/releases/download/nodats
inputbox,REPOURL,Repository-URL,Enter the url of the file-repository,,345,140,,,,,%REPOURLT%
if (REPOURL = "")
	{
		REPOURL= %REPOURLT%
		UPDTFILE= %UPDTFILE%
	}
IniWrite,%REPOURL%,skopt.ini,GLOBAL,repository_url
return

NewLobby:
gui,submit,nohide
NLOB= 
if (NLOBT = "")
	NLOBT= http://newlobby.libretro.com/list
inputbox,NLOB,retroarch lobby,Enter the url of the lobby list file,,275,140,,,,,%NLOBT%
if (NLOB = "")
	{
		NLOB= %NLOBT%
	}
IniWrite,%NLOB%,skopt.ini,GLOBAL,lobby_url
return

GetUpdate:
UPDTURLT=  http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
UPDTURL=
InputBox,UPDTURL,Update URL,If you wish to deploy updates from your own repository`nEnter the http address of the update file`nusually where ''version.txt'' can be found,0,,,,,,,%UPDTURLT%
		if (UPDTURL = "")
				{
					UPDTURL= http://raw.githubusercontent.com/romjacket/skeletonkey/master/version.txt
				}
return

GetDepl:
DEPLT= %A_MyDocuments%\Github\skeletonkey.deploy
FileSelectFolder, DEPLT,%depltmp% ,1,Select The Deployment Directory
depltmp= 
deplexists= 
if (DEPL <> "")
	{
		if (DEPLT= "")
			{
				SB_SetText(" Deploy dir is " DEPL " ")
				return
			}
	}

		DEPL:= DEPLT
		iniwrite, %DEPL%,skopt.ini,GLOBAL,Deployment_Directory
		return
Msgbox,5,index.html,Deployment Environment not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GetDepl
return

GetComp:
AHKDIT= %AHKDIR%
FileSelectFolder, AHKDIT,%comptmp% ,0,Select The AHK Compiler Directory
comptmp= 
compexists= 
if (AHKDIR <> "")
	{
		if (AHKDIT = "")
			{
				SB_SetText(" AHK Compiler dir is " AHKDIR " ")
				return
			}
	}
Loop, %AHKDIT%\Ahk2Exe.exe
	{
		compexists= 1
	}
if (compexists = 1)
	{
		AHKDIR:= AHKDIT
		iniwrite, %AHKDIR%,skopt.ini,GLOBAL,Compiler_Directory
		return
	}
Msgbox,5,Ahk2Exe.exe,AutoHotkey Compiler not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GetComp
return

GetSrc:
SKELT= %SKELD%
FileSelectFolder, SKELT,%skeltmp% ,1,Select The Source Directory
skelexists= 
if (SKELD <> "")
	{
		if (SKELT = "")
			{
				SB_SetText(" SOURCE dir is " SKELD " ")
				return
			}
	}
Loop, %SKELT%\skeletonkey.ahk
	{
		skelexists= 1
	}
if (skelexists = 1)
	{
		SKELD:= SKELT
		iniwrite, %SKELD%,skopt.ini,GLOBAL,Source_Directory
		return
	}
Msgbox,5,skeletonkey.ahk,skeletonkey source file not found
IfMsgBox, Abort
	{
		ExitApp
	}
skeltmp= 
gosub, GetSrc	
return

GetRls:
gitrlstmp= %a_programfiles%\git\bin
GITRLST= %GITRLS%
GITRLSCONT:
FileSelectFile, GITRLST,3,%gitrlstmp%,Select the github-release.exe,*.exe
gitrlstmp= 
gitrlsxst= 
if (GITRLS <> "")
	{
		if (GITRLST = "")
			{
				SB_SetText("Git-Release is " GITRLS " ")
				return
			}
	}	
ifexist, %a_programfiles%\git\bin\github-release.exe
	{
		GITRLSXST= 1
	}
IF (GITRLSXST = 1)	
	{	
		GITRLST= %a_programfiles%\git\bin\github-release.exe
	}
if (GITRLST = "")
	{
		GITRLS=
		MsgBox,5,Github-Release,Github-Release not found, Locate?
		ifmsgbox, Cancel
			{
				return		
			}
		ifmsgbox, No
			{
				return		
			}
		ifmsgbox, Ok
			{
				gitrlstmp= 
				goto, GITRLSCONT
			}
			
	}
GITRLS= %GITRLST%
iniwrite, %GITRLS%,skopt.ini,GLOBAL,git_rls
return

GetGPAC:
GITPATT= 
envGet, GITPATT, GITHUB_TOKEN
InputBox, GITPATT , Git-PAC, Input your git token, , 160, 120, , , ,,%GITPATT%
if (GITPAT <> "")
	{
		if (GITPATT = "")
			{
				envGet, GITPATT, GITHUB_TOKEN
				SB_SetText(" Git Access token is " GITPAT " ")
			}
	}
GITPAT= %GITPATT%	
iniwrite, %GITPAT%,skopt.ini,GLOBAL,git_token
return


GetGUSR:
GITUSERT= 
InputBox, GITUSERT , Git-Username, Input your git username, , 160, 120, , , ,, %a_username%
if (GITUSER <> "")
	{
		if (GITUSERT = "")
			{
				SB_SetText(" Git Username is " GITUSER " ")
				return
			}
	}
GITUSER= %GITUSERT%	
iniwrite, %GITUSER%,skopt.ini,GLOBAL,Git_username
filecreatedir, %gitroot%\%GITUSER%.github.io
return

GetGit:
GITT= %GITD%
FileSelectFolder, GITT,%gittmp% ,1,Select The Git Project Directory
gittmp= 
gitexists= 
if (GITD <> "")
	{
		if (GITT = "")
			{
				SB_SetText(" GIT dir is " GITD " ")
				return
			}
	}
Loop, %GITT%\skeletonkey.ahk
	{
		gitexists= 1
	}
if (gitexists = 1)
	{
		GITD:= GITT
		iniwrite, %GITD%,skopt.ini,GLOBAL,Git_Directory
		FileDelete, %GITD%\gitcommit.bat
		FileAppend,cd "%GITD%"`n,%GITD%\gitcommit.bat
		FileAppend,git add .`n,%GITD%\gitcommit.bat
		FileAppend,git commit -m `%1`%`n,%GITD%\gitcommit.bat
		FileAppend,git push`n,%GITD%\gitcommit.bat
		return
	}
Msgbox,5,skeletonkey.ahk,Git Source file not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GetGit
return

SrcDD:
gui,submit,nohide
guicontrolget,SRCDD,,SRCDD
if (SRCDD = "Compiler")
	{
		SB_SetText(" " AHKDIR " ")
	}
if (SRCDD = "Build")
	{
		SB_SetText(" " BUILDIR " ")
	}
if (SRCDD = "Deployment")
	{
		SB_SetText(" " DEPL " ")
	}
if (SRCDD = "Source")
	{
		SB_SetText(" " SKELD " ")
	}
if (SRCDD = "Github")
	{
		SB_SetText(" " GITD " ")
	}
if (SRCDD = "NSIS")
	{
		SB_SetText(" " NSIS " ")
	}
if (RESDD = "Git-Release")
	{
		SB_SetText(" " GITRLS " ")
	}
	
return

ResDD:
gui,submit,nohide
guicontrolget,RESDD,,RESDD
if (RESDD = "Dev-Build")
	{			
		SB_SetText(" BUILDING ")
		if (DBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "Update-URL")
	{
		SB_SetText(" " UPDTURL " ")
	}
if (RESDD = "Git-URL")
	{
		SB_SetText(" " GITSRC " ")
	}
if (RESDD = "Portable-Build")
	{
		SB_SetText(" BUILDING ")
		if (PBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "Stable-Build")
	{
		SB_SetText(" BUILDING ")
		if (SBOV = 1)
			SB_SetText(" Overriding ")
	}
if (RESDD = "NSIS")
	{
		SB_SetText(" " NSIST " ")
	}
if (RESDD = "Deployer")
	{
		SB_SetText(" Reset this tool to default options !Remember your password!")
	}
if (RESDD = "Shader-URL")
	{
		SB_SetText(" " SHDRPURL " ")
	}
if (RESDD = "Internet-IP-URL")
	{
		SB_SetText(" " GETIPADR " ")
	}
if (RESDD = "Repo-URL")
	{
		SB_SetText(" " REPOURL " ")
	}
return

ResB:
gui,submit,nohide
if (RESDD = "Stable-Build")
	{
		StbBld= 
		SBOV= 
		FileSelectFile,StbBld,3,skeletonKey.zip,Select Stable Build
		if (StbBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your Stable Build?
			IfMsgBox, OK
				{
					FileCopy, %StbBld%,%DEPL%,1
					SBOV= 1
				}
	}

if (RESDD = "Portable-Build")
	{
		PortBld= 
		PBOV= 
		FileSelectFile,PortBld,3,skeletonKey-portable.zip,Select Portable Build
		if (PortBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your portable Build?
			IfMsgBox, OK
				{
					FileCopy, %PortBld%,%DEPL%,1
					PBOV= 1
				}
	}

if (RESDD = "Dev-Build")
	{
		DevBld= 
		DBOV= 
		FileSelectFile,DevBld,3,skeletonKey-portable.zip,Select Portable Build
		if (DevBld = "")
			{
				return
			}
		MsgBox,1,Confirm Overwrite,Are you sure you want to revert your Development Build?
			IfMsgBox, OK
				{
					rvbldn= 
					buildrv= 
					Loop, %DEPL%\skeletonKey-%date%*.zip
						{
							rvbldn+=1
							buildrv= -%rvbldn%
						}
						if (rvbldn = 1)
							{
								buildrv= 
							}
					FileCopy, %DevBld%,%DEPL%\skeletonKey-%date%%buildrv%,1
					DBOV= 1
				}
	}

if (RESDD = "Deployer")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the Deployment Tool?
		IfMsgBox, OK
			{
				FileDelete, %GITD%\gitcommit.bat
				FileDelete, %BUILDIR%\skdeploy.nsi				
				FileDelete, %BUILDIR%\skopt.ini
				FileDelete, %BUILDIR%\ltc.txt
				FileDelete, %BUILDIR%\insts.sha1
				ExitApp
			}
	}

if (RESDD = "NSIS")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the NSIS makensis.exe?
		IfMsgBox, OK
			{
				NSIStmp= 
				NBOV= 
				FileSelectFile,NSIST,3,%NSISD%\makensis.exe,Select makensis.exe
				if (NSIST = "")
					{
						return
					}
				MsgBox,1,Confirm Overwrite,Are you sure you want to change the makensis.exe?
					IfMsgBox, OK
						{
							NSIS= %NSIST%
							NBOV= 1
						}
				ExitApp
			}
	}

if (RESDD = "Git-Release")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the github-release.exe?
		IfMsgBox, OK
			{
				GITRLSTtmp= 
				GBOV= 
				FileSelectFile,GITRLST,3,%gitroot%\github-release.exe,Select github-release.exe
				if (GITRLST = "")
					{
						return
					}
				MsgBox,1,Confirm Overwrite,Are you sure you want to change the github-release.exe?
					IfMsgBox, OK
						{
							GITRLS= %GITRLST%
							GBOV= 1
						}
				ExitApp
			}
	}
	
if (RESDD = "Repo-URL")
	{
		REPOURLT= %REPOURL%
		Gosub, RepoURL
	}

if (RESDD = "Internet-IP-URL")
	{
		GETIPADRT= %GETIPADR%
		Gosub, GetIpAddr
	}

if (RESDD = "Shader-URL")
	{
		SHDRPURLT= %SHDRPURL%
		Gosub, GetShaderP
	}

if (RESDD = "Git-URL")
	{
		GITSRCT= %GITSRC%
		Gosub, GitSRC
	}
if (RESDD = "Update-URL")
	{
		UPDTURLT= %UPDTURL%
		Gosub, UpdateURL
	}
return


VerNum:
gui,submit,nohide
guicontrolget,vernum,,vernum
return

PortVer:
gui,submit,nohide

return

OvrStable:
gui,submit,nohide

return

DevlVer:
gui,submit,nohide

return

DatBld:
gui,submit,nohide

return

PushNotes:
gui,submit,nohide
guicontrolget, PushNotes,,PushNotes
return

ServerPush:
gui,submit,nohide

return

GitPush:
gui,submit,nohide

return

SiteUpdate:
gui,submit,nohide

return

CANCEL:
gui,submit,nohide
BCANC= 1
guicontrol,enable,PushNotes
guicontrol,enable,VerNum
guicontrol,enable,GitPush
guicontrol,enable,ServerPush
guicontrol,enable,SiteUpdate
guicontrol,enable,PortVer
guicontrol,enable,DevlVer
guicontrol,enable,RESDD
guicontrol,enable,ResB
guicontrol,enable,SrcDD
guicontrol,enable,SelDir
guicontrol,hide,CANCEL
guicontrol,show,COMPILE
guicontrol,,progb,0
SB_SetText(" Operation Cancelled ")
return

BUILDING:
BUILT= 1
FileDelete, %DEPL%\skeletonD.zip
FileDelete, %DEPL%\skeletonK.zip
FileDelete, %DEPL%\skeletonkey-installer.exe
FileDelete, %DEPL%\skeletonkey-Full.exe
FileDelete, %BUILDIR%\skdeploy.nsi
	{			
		FileRead, nsiv, %BUILDIR%\skdeploy.set
		StringReplace, nsiv, nsiv,[INSTYP],-installer,All
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
		FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
	}

RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" ", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-installer.exe" > "%BUILDIR%\fcivINST.txt" ", %BUILDIR%,%rntp%
FileReadLine, nchash, %BUILDIR%\fcivINST.txt,4

FileDelete, %BUILDIR%\skdeploy.nsi
	{			
		FileRead, nsiv, %BUILDIR%\skdeploy.set
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[INSTYP],-Full,All
		StringReplace, nsiv, nsiv,;File,File,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
		FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
	}

RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" ", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-Full.exe" > "%BUILDIR%\fcivFULL.txt" ", %BUILDIR%,%rntp%
FileReadLine, fchash, %BUILDIR%\fcivFULL.txt,4
;;  

FileDelete,%BUILDIR%\fciv*.txt
StringSplit,Tsha,nchash, %A_Space%
FileDelete, %SKELD%\version.txt
FileAppend, %date% %timestring%=%Tsha1%=%verapnd%,%SKELD%\version.txt

buildnum= 
buildtnum= 1
Loop, %DEPL%\skeletonkey-%date%*.zip
	{
		buildnum+=1
	}

if (buildnum <> "")
	{
		buildnum= -%buildnum%
	}	

RunWait, "%BUILDIR%\7za.exe" a "%DEPL%\skeletonK.zip" "%DEPL%\skeletonkey-installer.exe", %BUILDIR%,%rntp%

if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileCopy,%DEPL%\skeletonK.zip, %DEPL%\skeletonkey-%date%%buildnum%.zip,1
				FileMove,%DEPL%\skeletonK.zip, %DEPL%\skeletonKey.zip,1	
			}
	}
buildnum= 
buildtnum= 1
Loop, %DEPL%\skeletonkey-Full-%date%*.zip
	{
		buildnum+=1
	}
if (buildnum <> "")
	{
		buildnum= -%buildnum%
	}	
RunWait, "%BUILDIR%\7za.exe" a "%DEPL%\skeletonD.zip" "%DEPL%\skeletonkey-Full.exe", %BUILDIR%,%rntp%

if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileMove,%DEPL%\skeletonD.zip, %DEPL%\skeletonkey-Full-%date%%buildnum%.zip,1
			}
	}

if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						ifExist, %DEPL%\skeletonKey.zip
							{
								FileMove,%DEPL%\skeletonKey.zip, %DEPL%\skeletonKey.zip.bak,1
							}
					}
	}

if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						ifExist, %DEPL%\skeletonKey.zip
							{
								FileMove,%DEPL%\skeletonKey.zip, %DEPL%\skeletonKey.zip.bak,1
							}
						FileMove,%DEPL%\skeletonK.zip, %DEPL%\skeletonKey.zip,1	
					}
	}
return

COMPILE:
BCANC= 
gui,submit,nohide
guicontrol,disable,RESDD
guicontrol,disable,ResB
guicontrol,disable,SrcDD
guicontrol,disable,SelDir
guicontrol,hide,COMPILE
guicontrol,show,CANCEL
guicontrol,disable,PushNotes
guicontrol,disable,VerNum
guicontrol,disable,GitPush
guicontrol,disable,ServerPush
guicontrol,disable,SiteUpdate
guicontrol,disable,DatBld
guicontrol,disable,PortVer
guicontrol,disable,DevlVer

readme= 
FileMove,%SKELD%\ReadMe.md, %SKELD%\ReadMe.bak,1
FileRead,readme,%SKELD%\ReadMe.set
StringReplace,readme,readme,[CURV],%vernum%
StringReplace,readme,readme,[VERSION],%date% %timestring%
FileAppend,%readme%,%SKELD%\ReadMe.md

arcorg= 
FileMove, %SKELD%\Themes.set, %SKELD%\Themes.bak,1
FileMove, %SKELD%\arcorg.set, %SKELD%\arcorg.bak,1
FIleRead,themes,%SKELD%\Themes.put
FIleRead,arcorg,%SKELD%\arcorg.put
StringReplace,themes,themes,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorg,arcorg,[UPDATEFILE],%UPDTFILE%,All
StringReplace,arcorg,arcorg,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorg,arcorg,[LOBBY],%NLOB%,All
StringReplace,arcorg,arcorg,[SHADERHOST],%SHDRPURL%,All
StringReplace,arcorg,arcorg,[SOURCEHOST],%UPDTURL%,All
StringReplace,arcorg,arcorg,[IPLK],%GETIPADR%,All
FileAppend,%themes%,%SKELD%\Themes.set
FileAppend,%arcorg%,%SKELD%\arcorg.set

FileDelete,%SKELD%\skeletonkey.tmp
FileMove,%SKELD%\skeletonkey.ahk,%SKELD%\skel.bak,1
FileCopy, %SKELD%\working.ahk, %SKELD%\skeletonkey.tmp,1
sktmp= 
sktmc= 
sktmv= 
FileRead, sktmp,%SKELD%\skeletonkey.tmp
StringReplace,sktmc,sktmp,[VERSION],%date% %TimeString%,All
StringReplace,sktmv,sktmc,[CURV],%vernum%,All
FileAppend,%sktmv%,%SKELD%\skeletonkey.ahk
FileDelete,%SKELD%\skeletonkey.tmp

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Compile ")
		guicontrol,,progb,0
		;Sleep, 500
		return
	}
	
SB_SetText(" Compiling ")
ifexist, %SKELD%\skeletonkey.exe
	{
		FileMove, %SKELD%\skeletonkey.exe, %SKELD%\skeletonkey.exe.bak,1
	}

runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\skeletonkey.ahk" /out "%SKELD%\skeletonkey.exe" /icon "%SKELD%\key.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" ", %SKELD%,%rntp%
guicontrol,,progb,15
FileDelete,%SKELD%\*.lpl
FileDelete,%SKELD%\*.tmp
FileDelete,%SKELD%\version.txt
FileDelete,ltc.txt
FileAppend, "%SKELD%\skeletonkey.ahk"`n,ltc.txt
FileAppend, "%SKELD%\SKey-Deploy.ahk"`n,ltc.txt
FileAppend, "%SKELD%\BSL.ahk"`n,ltc.txt
FileAppend, "%SKELD%\AHKsock.ahk"`n,ltc.txt
FileAppend, "%SKELD%\LVA.ahk"`n,ltc.txt
FileAppend, "%SKELD%\tf.ahk"`n,ltc.txt
Loop, %SKELD%\*
		{
			if (A_LoopFileExt = "cfg")
				continue
			if (A_LoopFileExt = "7z")
				continue
			if (A_LoopFileExt = "zip")
				continue
			if (A_LoopFileExt = "ini")
				continue
			if (A_LoopFileExt = "ahk")
				continue
			if (A_LoopFileExt = "bak")
				continue
			FileAppend, "%A_LoopFileFullPath%"`n,ltc.txt
		}
FileAppend,:%SKELD%\rj\ES\*.set`n,ltc.txt
FileAppend,:%SKELD%\joyImg`n,ltc.txt
FileAppend,:%SKELD%\rj\joycfgs`n,ltc.txt
FileAppend,:%SKELD%\rj\KODI\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\KODI\AEL\*.set`n,ltc.txt
FileAppend,:%SKELD%\rj\emucfgs`n,ltc.txt											   
FileAppend,:%SKELD%\rj\emucfgs`n,ltc.txt
FileAppend,:%SKELD%\rj\scrapeart`n,ltc.txt

Loop, %SKELD%\rj\scrapeart\*.7z
	{
		FileAppend,"%A_LoopFileFullPath%"`n,ltc.txt
	}

Loop, %SKELD%\rj\emucfgs\*,2
	{
		FileAppend,:"%A_LoopFileFullPath%"`n,ltc.txt
		Loop, %A_LoopFileFullPath%\*
			{
				FileAppend,"%A_LoopFIleFullPath%"`n,ltc.txt
			}
	}

Loop, %SKELD%\rj\joycfgs\*,2
	{											  
		FileAppend,:"%A_LoopFileFullPath%"`n,ltc.txt
		Loop, %A_LoopFileFullPath%\*
			{
				FileAppend,"%A_LoopFIleFullPath%"`n,ltc.txt
			}
	}
guicontrol,,progb,20

if (DATBLD = 1)
	{		
		SB_SetText(" Recompiling Database ")
		FileDelete, %DEPL%\DATFILES.7z
		Loop, rj\scrapeArt\*.7z
			{
				runwait, "%BUILDIR%\7za.exe" a "%DEPL%\DATFILES.zip" "%A_LoopFileFullPath%",,hide
			}
	}

FileGetSize,dbsize,%DEPL%\DATFILES.zip,K
DATSZ:= dbsize / 1000
	
if (PortVer = 1)
	{		
		SB_SetText(" Building portable ")
		COMPLIST= 
		runwait, %comspec% cmd /c "fart.exe ltc.txt "\"" --remove ", %BUILDIR%,%rntp%
		;"
		if (PBOV <> 1)
			{
				FileDelete, %DEPL%\skeletonKey-full.zip
				FileDelete, %DEPL%\skeletonKey-portable.zip
				runwait, "%BUILDIR%\7za.exe" a "%DEPL%\skeletonKey-portable.zip" "*.set" "*.ico" "*.ttf" "BSL.ahk" "skeletonkey.ahk" "SKey-Deploy.ahk" "index.html" "*.exe" "tf.ahk" "AHKsock.ahk" "LVA.ahk" "Portable.bat" "*.exe" "rj\*.set" "rj\joyCfgs\*" "rj\emuCfgs\*" "rj\scrapeart\*.set" "joyimg\*" "gam\*.gam" -r, %SKELD%,%rntp%
				sleep, 1000
				runwait, "%BUILDIR%\7za.exe" a "%DEPL%\skeletonKey-portable.zip" "*.png", %SKELD%,%rntp%
			}
	}

guicontrol,,progb,35
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Development Build ")
		guicontrol,,progb,0
		return
	}
	
if (DevlVer = 1)
	{
		SB_SetText(" Building Devel ")
		gosub, BUILDING
		guicontrol,,progb,55
}

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Git Push ")
		guicontrol,,progb,0
		return
	}

if (GitPush = 1)
	{
		SB_SetText(" Pushing changes to git ")
		IF (PushNotes = "")
			{
				PushNotes= %date% %TimeString%
			}
		IfExist,%SKELD%\!gitupdate.cmd
			{
				FIleMove, %SKELD%\!gitupdate.cmd, %BUILD%\!gitupdate.cmd.bak,1
			}
		FileAppend, robocopy gam "%GITD%\gam" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tdb"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tmp"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, rd /s /q "%GITD%\rj\netArt\*"`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy rj "%GITD%\rj" /s /e /w:1 /r:1 /xf syscfgs`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy joyimg "%GITD%\joyimg" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\scrapeArt\*.7z" "%GITD%\scrapaArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "*.exe" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "*.set" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "Portable.bat" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "index.html" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "BSL.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "LVA.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "tf.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "AHKsock.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "SKey-Deploy.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "skeletonkey.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "*.ico" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "*.png" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "ReadMe.md" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "version.txt" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\skeletonKey.exe"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "Themes.put" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "arcorg.put" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileSetAttrib, +h, %SKELD%\!gitupdate.cmd
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" ",%SKELD%,%rntp%
		IfNotExist, %GITD%\gitcommit.bat
			{
				FileAppend,cd "%GITD%"`n,%GITD%\gitcommit.bat
				FileAppend,git add .`n,%GITD%\gitcommit.bat
				FileAppend,git commit -m `%1`%`n,%GITD%\gitcommit.bat
				FileAppend,git push`n,%GITD%\gitcommit.bat
			}
		FileAppend, "%PushNotes%`n",%DEPL%\changelog.txt
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" ",%SKELD%,%rntp%
		StringReplace,PushNotes,PushNotes,",,All
		;"
		RunWait, %comspec% cmd /c " "%GITD%\gitcommit.bat" "%PushNotes%" ",%GITD%,%rntp%
		guicontrol,,progb,65
	}

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Stable Overwrite ")
		guicontrol,,progb,0
		return
	}

if (OvrStable = 1)
	{
		SB_SetText(" overwriting stable ")
		if (BUILT<> 1)
			{
				gosub, BUILDING
			}
	}				
guicontrol,,progb,70

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Server Upload ")
		guicontrol,,progb,0
		return
	}

if (ServerPush = 1)
	{
		FileDelete, %DEPL%\gpush.cmd
		FileAppend, set GITHUB_USER=%GITUSER%`n,%DEPL%\gpush.cmd
		FileAppend, set GITHUB_TOKEN=%GITPAT%`n,%DEPL%\gpush.cmd
		FileAppend, pushd "%DEPL%"`n,%DEPL%\gpush.cmd
		
		SB_SetText(" Uploading to server ")
		
		if (PortVer = 1)
			{
				if (ServerPush = 1)
					{	
						FileAppend, "%GITRLS%" delete -r skeletonkey -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t portable -l portable -n skeletonKey-portable.zip -f "%DEPL%\skeletonKey-portable.zip"`n,%DEPL%\gpush.cmd
					}
			}
		if (DATBLD = 1)
			{
				if (ServerPush = 1)
					{					
						FileAppend, "%GITRLS%" delete -r skeletonkey -t dats`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t dats`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t dats -l "dat files" -n DATFILES.7z -f "%DEPL%\DATFILES.7z"`n,%DEPL%\gpush.cmd
					}
			}
		if (OvrStable = 1)
			{
				if (ServerPush = 1)
					{
						FileAppend, "%GITRLS%" delete -r skeletonkey -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t Installer -l Installer -n Installer.zip -f "%DEPL%\skeletonkey-%date%%buildnum%.zip"`n,%DEPL%\gpush.cmd
					}
			}

		if (DevlVer = 1)
			{
				if (ServerPush = 1)
					{
						FileAppend, "%GITRLS%" delete -r skeletonkey -t FullVersion`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -r skeletonkey -t FullVersion`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -R -r skeletonkey -t FullVersion -l "Full Version" -n FullVersion.zip -f "%DEPL%\skeletonkey-Full-%date%%buildnum%.zip"`n,%DEPL%\gpush.cmd
					}
			}
		if (SiteUpdate <> 1)
			{

			}
		guicontrol,,progb,80
		if (GitPush = 1)
			{
				RunWait, %comspec% cmd /c "%DEPL%\gpush.cmd",%DEPL%,%rntp%
			}
	}
	
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Site Update ")
		guicontrol,,progb,0
		return
	}

if (SiteUpdate = 1)
	{
		SB_SetText(" Updating the website ")
		RDATE= %date% %timestring%
		if (DBOV = 1)
			{
				RDATE= reverted
			}
		if (PBOV = 1)
			{
				RDATE= reverted
			}
		if (SBOV = 1)
			{
				RDATE= reverted
			}
		if (ServerPush = 0)
			{
				buildnum= 
				sha1:= olsha 
				RDATE:= olrlsdt
				dvms:= olsize
				olnan1= 
				olnan2= 
				olnan3= 
				olnan4= 
				olnan5= 
				stringsplit, olnan,olrlsb,-
				date= %olnan2%-%olnan3%-%olnan4% 
				if (olnan5 <> "")
					{
						buildnum= -%olnan5%
					}
			}

		if (ServerPush = 1)
			{
				FileMove, %DEPL%\index.html, %DEPL%\index.bak,1
				FileRead,skelhtml,%BUILDIR%\index.html
				StringReplace,skelhtml,skelhtml,[CURV],%vernum%,All
				FileDelete,%BUILDIR%\insts.sha1

				if (OvrStable = 1)
					{
						ifExist, %DEPL%\skeletonkey-installer.exe
							{
								Runwait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-installer.exe" >"%BUILDIR%\insts.sha1" ", %BUILDIR%,%rntp%
								if (SBOV = 1)
									{
										sha1= reverted
									}
								if (DBOV = 1)
									{
										sha1= reverted
									}
							}
						ifExist, %DEPL%\skeletonkey-Full.exe
							{
								Runwait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DEPL%\skeletonkey-Full.exe" >"%BUILDIR%\instsFull.sha1" ", %BUILDIR%,%rntp%
								if (SBOV = 1)
									{
										shb1= reverted
									}
								if (DBOV = 1)
									{
										shb1= reverted
									}
							}
						ifExist, %DEPL%\skeletonkey-%date%%buildnum%.zip
							{
								FileGetSize,dvlsize,%DEPL%\skeletonkey-%date%%buildnum%.zip, K
								dvps:= dvlsize / 1000
								StringLeft,dvms,dvps,4
								if (DBOV = 1)
									{
										dvms= reverted
									}
								if (SBOV = 1)
									{
										dvms= reverted
									}
							}
					}
			}			
		ifExist, %DEPL%\skeletonkey-Full-%date%%buildnum%.zip
			{
				FileGetSize,dvgsize,%DEPL%\skeletonkey-Full-%date%%buildnum%.zip, K
				dvpg:= dvgsize / 1000
				StringLeft,dvmg,dvpg,4
				if (DBOV = 1)
					{
						dvmg= reverted
					}
				if (SBOV = 1)
					{
						dvmg= reverted
					}
			}
		FileReadLine,shap,%BUILDIR%\insts.sha1,4
		stringsplit,sha,shap,%A_Space%
		FileReadLine,shag,%BUILDIR%\instsFull.sha1,4
		stringsplit,shb,shag,%A_Space%		
		
		guicontrol,,progb,90
		StringReplace,skelhtml,skelhtml,[RSHA1],%sha1%,All
		StringReplace,skelhtml,skelhtml,[RSHA2],%shb1%,All
		StringReplace,skelhtml,skelhtml,[WEBURL],http://%GITUSER%.github.io,All
		StringReplace,skelhtml,skelhtml,[GITSRC],%GITSRC%,All
;;		StringReplace,skelhtml,skelhtml,[REVISION],http://github.com/%gituser%/skeletonkey-%date%%buildnum%,All
		StringReplace,skelhtml,skelhtml,[REVISION],http://github.com/%gituser%/download/Installer/Installer.zip,All
		StringReplace,skelhtml,skelhtml,[PORTABLE],https://github.com/%gituser%/skeletonKey/releases/download/portable/skeletonKey-portable.zip,All
		StringReplace,skelhtml,skelhtml,[DATFILES],https://github.com/%gituser%/skeletonKey/releases/download/DATFILES/DATFILES.7z,All
		StringReplace,skelhtml,skelhtml,[FULLRELEASE],https://github.com/%gituser%/skeletonKey/releases/download/FullVersion/FullVersion.zip,All
		StringReplace,skelhtml,skelhtml,[RDATE],%RDATE%,All
		StringReplace,skelhtml,skelhtml,[RSIZE],%dvms%,All
		StringReplace,skelhtml,skelhtml,[RSIZE2],%dvmg%,All
		StringReplace,skelhtml,skelhtml,[DBSIZE],%DATSZ%,All
		FileDelete,%gitroot%\%gituser%.github.io\index.html
		FileAppend,%skelhtml%,%gitroot%\%gituser%.github.io\index.html
	}
uptoserv=

if (SiteUpdate = 1)
	{
		uptoserv= 1
	}

if (ServerPush = 1)
	{
		uptoserv= 1
	}

if (uptoserv = 1)
	{
		SB_SetText(" Uploading to server ")
		FileDelete, %BUILDIR%\sitecommit.bat
		FileAppend,cd "%gitroot%\%GITUSER%.github.io"`n,%BUILDIR%\sitecommit.bat
		FileAppend,git add .`n,%BUILDIR%\sitecommit.bat
		FileAppend,git commit -m siteupdate`n,%BUILDIR%\sitecommit.bat
		FileAppend,git push`n,%BUILDIR%\sitecommit.bat
		RunWait, %comspec% cmd /c " "%BUILDIR%\sitecommit.bat" "site-commit" ",%BUILDIR%,%rntp%
	}

guicontrol,,progb,100
SB_SetText(" Complete ")
guicontrol,,progb,0

guicontrol,enable,RESDD
guicontrol,enable,ResB
guicontrol,enable,SrcDD
guicontrol,enable,SelDir
guicontrol,enable,PushNotes
guicontrol,enable,VerNum
guicontrol,enable,GitPush
guicontrol,enable,ServerPush
guicontrol,enable,SiteUpdate
guicontrol,enable,DatBld
guicontrol,enable,PortVer
guicontrol,enable,DevlVer
guicontrol,hide,CANCEL
guicontrol,show,COMPILE
guicontrol,,progb,0
return


esc::
GuiEscape:
GuiClose:
ExitApp
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
