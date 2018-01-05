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
IfExist, C:\users\%A_UserName%\DropBox\Public
	{
		depltmp= C:\users\%A_UserName%\DropBox\Public
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
						DBP= %curvl2%
					}
			}
	if (curvl1 = "Git_Directory")
			{
				if (curvl2 <> "")
					{
						GITD= %curvl2%
					}
			}
	if (curvl1 = "NSIS")
			{
				if (curvl2 <> "")
					{
						NSIS= %curvl2%
					}
			}
	if (curvl1 = "Port_Number")
			{
				PORTNUM= 22
				if (curvl2 <> "")
					{
						PORTNUM= %curvl2%
					}
			}
	if (curvl1 = "FTP_Type")
			{
				FTPXE= SFTP
				ftptyp= checked
				if (curvl2 <> "")
					{
						FTPXE= %curvl2%
						if (FTPXE = "FTP")
							{
								ftptyp= 
							}
					}
			}
	if (curvl1 = "Server_Login")
			{
				if (curvl2 <> "")
					{
						siteuser= %curvl2%
					}
			}
	if (curvl1 = "Server_Password")
			{
				if (curvl2 <> "")
					{
						sitepass= %curvl2%
					}
			}
	if (curvl1 = "Site_URL")
			{
				if (curvl2 <> "")
					{
						SITEURL= %curvl2%
					}
			}
	if (curvl1 = "Server_Directory")
			{
				if (curvl2 <> "")
					{
						SERVERDIR= %curvl2%
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
if (DBP = "")
	{
		gosub, GetDepl
	}
if (DBP = "")
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
if (SITEURL = "")
	{
		gosub, GetSite
	}
if (SITEURL = "")
	{
		msgbox,262,,Site should be set.
		ifmsgbox,TryAgain
			{
				gosub, GetSite
			}
		IfMsgBox,Cancel
			{
				ExitApp
				return
			}
		if (SITEURL = "")
			{
				IniDelete,skopt.ini,GLOBAL,Site_Login
				IniDelete,skopt.ini,GLOBAL,Site_Password
				IniDelete,skopt.ini,GLOBAL,Server_Directory
				IniDelete,skopt.ini,GLOBAL,Site_user
				goto, VERSIONGET
			}
	}
if (siteuser = "")
	{
		gosub, GetLogin
	}
siteusretry:
if (siteuser = "")
	{
		msgbox,262,,UserName should be set.
		IfMsgBox, Cancel
		{
			ExitApp
			return
		}
		IfMsgBox, TryAgain
			{
				goto, siteusretry
			}
	}
sitepassretry:
if (sitepass = "")
	{
		gosub, GetPass
	}
if (sitepass = "")
	{
		msgbox,518,,You have not set a password.
		ifMsgbox, TryAgain
			{
				goto, sitepassretry
			}
		IfMsgBox, Cancel
			{
				ExitApp
				return
			}
	}
	
if (FTPXE = "")
	{
		FTPXE= SFTP
		ftptyp= checked
	}
if (SERVERDIR = "")
	{
		gosub, GetServerDir
	}
if (SERVERDIR = "")
	{
		msgbox,256,,You have not set a login directory.	
		IfMsgBox, TryAgain
			{
				goto, GetServerDir
			}
		ifmsgbox,Cancel
			{
				ExitApp
				return
			}
	}
if (PORTNUM = "")
	{
		gosub, GetPort
	}
if (PORTNUM = "")
	{
		PORTNUM= 22
	}

oldsize=
oldsha= 
olrlsdt=
vernum=	
VERSIONGET:
sklnum= 
getversf= %DBP%\WEBSITE\skeletonkey.html
ifnotexist,getversf
	{
		FileDelete,ORIGHTML.html
		UrlDownloadToFile, http://romjacket.mudlord.info/WEBSITE/skeletonkey.html, ORIGHTML.html
		getversf= ORIGHTML.html
	}
Loop,Read, %getversf%
	{
	sklnum+=1
	getvern= 
	ifinstring,A_LoopReadLine,<h99>
		{
			stringgetpos,verstr,A_LoopReadLine,<h99>
			FileReadLine,sklin,C:\users\sudopinion\dropbox\public\WEBSITE\skeletonkey.html,%sklnum%
			getvern:= verstr+6
			StringMid,vernum,sklin,%getvern%,10
			if (vernum = "</h99></st")
				{
					vernum= 0.99.0.0
				}
			continue
		}
ifinstring,A_LoopReadLine,<h88>
		{
			stringgetpos,verstr,A_LoopReadLine,<h88>
			FileReadLine,sklin,C:\users\sudopinion\dropbox\public\WEBSITE\skeletonkey.html,%sklnum%
			getvern:= verstr+6
			StringMid,oldsize,sklin,%getvern%,4
			continue
		}
ifinstring,A_LoopReadLine,<h87>
		{
			stringgetpos,verstr,A_LoopReadLine,<h87>
			FileReadLine,sklin,C:\users\sudopinion\dropbox\public\WEBSITE\skeletonkey.html,%sklnum%
			getvern:= verstr+6
			StringMid,oldsize,sklin,%getvern%,4
			continue
		}
ifinstring,A_LoopReadLine,<h77>
		{
			stringgetpos,verstr,A_LoopReadLine,<h77>
			FileReadLine,sklin,C:\users\sudopinion\dropbox\public\WEBSITE\skeletonkey.html,%sklnum%
			getvern:= verstr+6
			StringMid,oldsha,sklin,%getvern%,40
			continue
		}
ifinstring,A_LoopReadLine,<h66>
		{
			stringgetpos,verstr,A_LoopReadLine,<h66>
			FileReadLine,sklin,C:\users\sudopinion\dropbox\public\WEBSITE\skeletonkey.html,%sklnum%
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
Gui, Add, Edit, x8 y24 w410 h50 vPushNotes gPushNotes,%date% :%A_Space%
Gui, Add, Edit, x424 y24 w55 h21vvernum gVerNum, %vernum%
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
Gui, Add, Text, x424 y8, Version
Gui, Add, CheckBox, x90 y75 w104 h13 vPortVer gPortVer checked, Portable Version
Gui, Add, CheckBox, x90 y94 w154 h13 vDevlVer gDevlVer checked, Development Version
Gui, Add, CheckBox, x90 y112 w154 h13 vDATBLD gDatBld, Database Recompile

Gui, Add, Text, x271 y82, Directory
Gui, Add, Button, x424 y78 w52 h21 vSELDIR gSelDir, Select
Gui, Add, DropDownList, x318 y78 w100 vSRCDD gSrcDD, Source||Compiler|Deployment|Build|NSIS|Git


Gui Add, DropDownList, x46 y148 w92 vResDD gResDD, Dev-Build||Portable-Build|Stable-Build|NSIS|Deployer|Update-URL|Shader-URL|Repo-URL|Internet-IP-URL|Git-URL
Gui Add, Button, x139 y148 w52 h21 vResB gResB, Reset
Gui Add, Text, x14 y150, Reset

Gui, Add, Edit, x266 y148 w74 h21 vSetLogin gSetLogin, %siteuser%
Gui, Add, Edit, x378 y149 w74 h21 vSetPass gSetPass Password, %sitepass%
Gui, Add, Button, x185 y3 w75 h20 vSetSite gSetSite, Set Site URL
Gui, Add, Text, x235` y150, Login
Gui, Add, Text, x349 y150, Pass
Gui, Add, Edit, x299 y1 w38 h21 vSetPort gSetPort Number, %PORTNUM%
Gui, Add, Text, x266 y3, PORT
Gui, Add, CheckBox, x346 y0 w45 h23 vSetFTP gSetFTP %ftptyp%, SFTP

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

GetBld:
BUILDIT= %BUILDIR%
FileSelectFolder, BUILDIT,%bldtmp% ,0,Select The Build Directory
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
		StringReplace, nsiv, nsiv,[DBP],%DBP%,All
		FileAppend, %nsiv%,%BUILDIR%\skdeploy.nsi
		return
	}
Msgbox,5,skdeploy.nsi,Build Directory not found
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
	REPOURLT= https://github.com/romjacket
	UPDTFILE= https://github.com/romjacket/skeletonKey/releases/download/nodats
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


GetSite:
gui,submit,nohide
siteurlt= %SITEURL%
if (siteurlt = "")
	siteurlt= http://my.skeletonkey.dev
InputBox,siteurlt,Server URL, Enter the Server URL,,275,140,,,,,%siteurlt%
if (siteurlt <> "")
	{
		SVRTR= 
		SITEURL= %siteurlt%
		StringReplace,SITEURL,SITEURL,http,,All
		StringReplace,SITEURL,SITEURL,https,,All
		StringReplace,SITEURL,SITEURL,ftp:,,All
		StringReplace,SITEURL,SITEURL,sftp:,,All
		StringReplace,SITEURL,SITEURL,:,,All
		StringReplace,SITEURL,SITEURL,/,,All
		StringReplace,SITEURL,SITEURL,/,,All
		IniWrite,%SITEURL%,skopt.ini,GLOBAL,Site_URL
		return
	}
SVRTR+=1
if (SVRTR > 1)
	{
		IniDelete,skopt.ini,GLOBAL,Site_URL
		return
	}
if (SITEURL = "")
	{
		goto, GetSite
	}
return

GetServerDir:
if (SVRTR > 1)
	{
		return
	}
	servertmp:= SERVERDIR
if (servertmp = "")
		servertmp= 
gui,submit,nohide
InputBox,SERVERDIRT,Site Root Directory, Enter the login/root directory to publish into,,345,140,,,,,%servertmp%
if (SERVERDIRT <> "")
	{
		SERVERDIR= %SERVERDIRT%
		IniWrite,%SERVERDIR%,skopt.ini,GLOBAL,Server_Directory
		return
	}	
IniDelete,skopt.ini,GLOBAL,Server_Directory
return

GetPass:
if (SVRTR > 1)
	{
		return
	}
gui,submit,nohide
sitepasd= %sitepass%
sitepastmp:= sitepass
InputBox,sitepasd,Server Password, Enter your Password,HIDE,275,125,,,,,%sitepastmp%
sitepastmp= 
if (sitepasd <> "")
	{
		sitepass= %sitepasd%
		sitepastmp= %sitepasd%
		IniWrite,%sitepass%,skopt.ini,GLOBAL,Server_Password
		return
	}
IniDelete, skopt.ini,GLOBAL,Server_Password
return

GetLogin:
if (SVRTR > 1)
	{
		return
	}
gui,submit,nohide
siteusrd= %siteuser%
siteusrtmp:= siteuser
InputBox,siteuserd,Server Login, Enter your Login,,275,140,,,,,%siteusrtmp%
siteusertmp= 
if (siteuserd <> "")
	{
		siteuser= %siteuserd%
		siteusertmp= 
		IniWrite,%siteuser%,skopt.ini,GLOBAL,Server_Login
		return
	}	
goto, GetLogin
return

GetPort:
if (SVRTR > 1)
	{
		return
	}
gui,submit,nohide
gportmp= %PORTNUM%
if (gportmp = "")
	{
		gportmp= 22
	}
InputBox,portmp,Port Number, Enter the s/ftp port number,,140,140,,,,,%gporttmp%
gporttmp= 
if (portmp = "")
	{
		portmp= 22
	}
if (portmp <> "")
	{
		if portmp is not Integer
				{
					msgbox,6,Not a number,You must enter a whole number
					IfMsgBox,TryAgain
					{
						goto GetPort
					}
					IfMsgBox,Cancel
						{
							Exitapp
						}
					IfMsgBox,Continue
						{
							if (FTPXE = "FTP")
								{
									portmp= 21
								}
						}
				}
		PORTNUM= %portmp%
		gporttmp= %PORTNUM%
		IniWrite,%PORTNUM%,skopt.ini,GLOBAL,Port_Number`n
		return
	}	
goto, GetPort
return


GetDepl:
DEPLT= %DBP%
FileSelectFolder, DEPLT,%depltmp% ,0,Select The Deployment Directory
depltmp= 
deplexists= 
if (DBP <> "")
	{
		if (DEPLT= "")
			{
				SB_SetText(" Deploy dir is " DBP " ")
				return
			}
	}
Loop, %DEPLT%\WEBSITE\skeletonkey.html
	{
		deplexists= 1
	}
if (deplexists = 1)
	{
		DBP:= DEPLT
		iniwrite, %DBP%,skopt.ini,GLOBAL,Deployment_Directory
		return
	}
Msgbox,5,skeletonkey.html,Deployment Environment not found
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
FileSelectFolder, SKELT,%skeltmp% ,0,Select The Source Directory
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

GetGit:
GITT= %GITD%
FileSelectFolder, GITT,%gittmp% ,0,Select The Git Project Directory
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
		FileDelete, gitcommit.bat
		FileAppend,cd "%GITD%"`n,gitcommit.bat
		FileAppend,git add .`n,gitcommit.bat
		FileAppend,git commit -m `%1`%`n,gitcommit.bat
		FileAppend,git push`n,gitcommit.bat
		return	
	}
Msgbox,5,skeletonkey.ahk,Git Source file not found
IfMsgBox, Abort
	{
		ExitApp
	}
gosub, GetGit
return

SetLogin:
gui,submit,nohide
guicontrolget,siteuser,,SETLOGIN
iniwrite,%siteuser%,skopt.ini,GLOBAL,Server_Login
return

SetPass:
gui,submit,nohide
guicontrolget,sitepass,,SETPASS
iniwrite,%sitepass%,skopt.ini,GLOBAL,Server_Password
return

SetSite:
sitetmp= 
gui,submit,nohide 
if (SITEURL <> "")
	{
		sitetmp= %SITEURL%
	}
InputBox,SITEURL,Server Address, Enter the FTP Server IP/Address`nDo not include ftp:// or subdirectories,,270,140,,,,,%sitetmp%
if (SITEURL <> "")
	{
		StringReplace,SITEURL,SITEURL,http,,All
		StringReplace,SITEURL,SITEURL,https,,All
		StringReplace,SITEURL,SITEURL,ftp:,,All
		StringReplace,SITEURL,SITEURL,sftp:,,All
		StringReplace,SITEURL,SITEURL,:,,All
		StringReplace,SITEURL,SITEURL,/,,All
		StringReplace,SITEURL,SITEURL,/,,All	
			IniWrite,%SITEURL%,skopt.ini,GLOBAL,Site_URL
			srvrdtmp= 
			gui,submit,nohide 
			if (SERVERDIR <> "")
				{
					srvrdtmp= %SERVERDIR%
				}
				InputBox,SERVERDIR,Site Root Directory, Enter a subdirectory to login to,,250,140,,,,,%srvrdtmp%
				if (SERVERDIR <> "")
					{
						IniWrite,%SERVERDIR%,skopt.ini,GLOBAL,Server_Directory
					}
				iniwrite,%SITEURL%,skopt.ini,GLOBAL,Site_URL
			SB_SetText(" ftp address is " FTPXE "://" SITEURL "/ " SERVERDIR " on port :" PORTNUM " ")
	}
return

SetFTP:
gui,submit,nohide
guicontrolget,SETFTP,,SETFTP
FTPXE= FTP
if (SETFTP = 1)
	{
		PORTNUM= 22
		FTPXE= SFTP
		guicontrol,,SetPort,22
		PORTNUM= 22
	}
if (SETFTP = 0)
	{
		PORTNUM= 21
		guicontrol,,SetPort,21
	}
iniwrite,%FTPXE%,skopt.ini,GLOBAL,FTP_Type
SB_SetText(" ftp address is " FTPXE "://" SITEURL "/ " SERVERDIR " on port :" PORTNUM " ")
return

SetPort:
PORTNUM= 22
gui,submit,nohide
guicontrolget,PORTNUM,,SETPORT
iniwrite,%PORTNUM%,skopt.ini,GLOBAL,Port_Number
SB_SetText(" ftp address is " FTPXE "://" SITEURL "/ " SERVERDIR " on port :" PORTNUM " ")
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
		SB_SetText(" " DBP " ")
	}
if (SRCDD = "Source")
	{
		SB_SetText(" " SKELD " ")
	}
if (SRCDD = "Git")
	{
		SB_SetText(" " GITD " ")
	}
if (SRCDD = "NSIS")
	{
		SB_SetText(" " NSIS " ")
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
					FileCopy, %StbBld%,%DBP%,1
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
					FileCopy, %PortBld%,%DBP%,1
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
					Loop, %DBP%\skeletonKey-%date%*.zip
						{
							rvbldn+=1
							buildrv= -%rvbldn%
						}
						if (rvbldn = 1)
							{
								buildrv= 
							}
					FileCopy, %DevBld%,%DBP%\skeletonKey-%date%%buildrv%,1
					DBOV= 1
				}
	}
if (RESDD = "Deployer")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the Deployment Tool?
		IfMsgBox, OK
			{
				FileDelete, %BUILDIR%\gitcommit.bat
				FileDelete, %BUILDIR%\skdeploy.nsi				
				FileDelete, ftp.txt
				FileDelete, skeletonkey.scr
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
FileDelete, %DBP%\skeletonD.zip
FileDelete, %DBP%\skeletonK.zip
FileDelete, %DBP%\skeletonkey-installer.exe
FileDelete, %DBP%\skeletonkey-Full.exe
FileDelete, %BUILDIR%\skdeploy.nsi
	{			
		FileRead, nsiv, %BUILDIR%\skdeploy.set
		StringReplace, nsiv, nsiv,[INSTYP],-installer,All
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DBP%,All
		FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
	}
RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" ", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DBP%\skeletonkey-installer.exe" > "%BUILDIR%\fcivINST.txt" ", %BUILDIR%,%rntp%
FileReadLine, nchash, %BUILDIR%\fcivINST.txt,4

FileDelete, %BUILDIR%\skdeploy.nsi
	{			
		FileRead, nsiv, %BUILDIR%\skdeploy.set
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[INSTYP],-Full,All
		StringReplace, nsiv, nsiv,;File,File,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DBP%,All
		FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
	}
RunWait, %comspec% cmd /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" ", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DBP%\skeletonkey-Full.exe" > "%BUILDIR%\fcivFULL.txt" ", %BUILDIR%,%rntp%
FileReadLine, fchash, %BUILDIR%\fcivFULL.txt,4
;;  

FileDelete,%BUILDIR%\fciv*.txt
StringSplit,Tsha,nchash, %A_Space%
FileDelete, %SKELD%\version.txt
FileAppend, %date% %timestring%=%Tsha1%=%verapnd%,%SKELD%\version.txt

buildnum= 
buildtnum= 1
Loop, %DBP%\skeletonkey-%date%*.zip
	{
		buildnum+=1
	}
if (buildnum <> "")
	{
		buildnum= -%buildnum%
	}	
RunWait, "%BUILDIR%\7za.exe" a "%DBP%\skeletonK.zip" "%DBP%\skeletonkey-installer.exe", %BUILDIR%,%rntp%
if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileCopy,%DBP%\skeletonK.zip, %DBP%\skeletonkey-%date%%buildnum%.zip,1
				FileMove,%DBP%\skeletonK.zip, %DBP%\skeletonKey.zip,1	
			}
	}
buildnum= 
buildtnum= 1
Loop, %DBP%\skeletonkey-Full-%date%*.zip
	{
		buildnum+=1
	}
if (buildnum <> "")
	{
		buildnum= -%buildnum%
	}	
RunWait, "%BUILDIR%\7za.exe" a "%DBP%\skeletonD.zip" "%DBP%\skeletonkey-Full.exe", %BUILDIR%,%rntp%
if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileMove,%DBP%\skeletonD.zip, %DBP%\skeletonkey-Full-%date%%buildnum%.zip,1
			}
	}
if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						ifExist, %DBP%\skeletonKey.zip
							{
								FileMove,%DBP%\skeletonKey.zip, %DBP%\skeletonKey.zip.bak,1
							}
					}
	}
return
if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						ifExist, %DBP%\skeletonKey.zip
							{
								FileMove,%DBP%\skeletonKey.zip, %DBP%\skeletonKey.zip.bak,1
							}
						FileMove,%DBP%\skeletonK.zip, %DBP%\skeletonKey.zip,1	
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
StringReplace,arcorg,arcorg,[IPLK],%GETIPTADR%,All
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
		FileDelete, %DBP%\DATFILES.7z
		Loop, rj\scrapeArt\*.7z
			{
				runwait, "%BUILDIR%\7za.exe" a "%DBP%\DATFILES.zip" "%A_LoopFileFullPath%",,hide
			}
	}
FileGetSize,dbsize,%DBP%\DATFILES.zip,K
DATSZ:= dbsize / 1000
	
if (PortVer = 1)
	{		
		SB_SetText(" Building portable ")
		COMPLIST= 
		runwait, %comspec% cmd /c "fart.exe ltc.txt "\"" --remove ", %BUILDIR%,%rntp%
		;"
		if (PBOV <> 1)
			{
				FileDelete, %DBP%\skeletonKey-full.zip
				FileDelete, %DBP%\skeletonKey-portable.zip
				runwait, "%BUILDIR%\7za.exe" a "%DBP%\skeletonKey-portable.zip" "*.set" "*.ico" "*.ttf" "BSL.ahk" "skeletonkey.ahk" "SKey-Deploy.ahk" "skeletonkey.html" "*.exe" "tf.ahk" "AHKsock.ahk" "LVA.ahk" "Portable.bat" "*.exe" "rj\*.set" "rj\joyCfgs\*" "rj\emuCfgs\*" "rj\scrapeart\*.set" "joyimg\*" "gam\*.gam" -r, %SKELD%,%rntp%
				sleep, 1000
				runwait, "%BUILDIR%\7za.exe" a "%DBP%\skeletonKey-portable.zip" "*.png", %SKELD%,%rntp%
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
		;FileMove, C:\users\sudopinion\desktop\skeletonkey-installer.7z, %DBP%\skeletonkey-%date%%buildnum%.7z,1	
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
		FileAppend, copy /y "skeletonkey.html" "%GITD%"`n,%SKELD%\!gitupdate.cmd
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
		IfNotExist, %BUILDIR%\gitcommit.bat
			{
				FileAppend,cd "%GITD%"`n,%BUILDIR%\gitcommit.bat
				FileAppend,git add .`n,%BUILDIR%\gitcommit.bat
				FileAppend,git commit -m `%1`%`n,%BUILDIR%\gitcommit.bat
				FileAppend,git push`n,%BUILDIR%\gitcommit.bat
			}
		FileAppend, "%PushNotes%`n",%DBP%\changelog.txt
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" ",%SKELD%,%rntp%
		StringReplace,PushNotes,PushNotes,",,All
		;"
		RunWait, %comspec% cmd /c " "%BUILDIR%\gitcommit.bat" "%PushNotes%" ",%BUILDIR%,%rntp%
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
		SB_SetText(" Uploading to server ")
		FileDelete, ftp.txt
		FileDelete, skeletonkey.scr
		FileAppend, cd %SERVERDIR%`n, skeletonkey.scr
		FileAppend, open %SITEURL%:%PORTNUM%`n, ftp.txt
		FileAppend, %siteuser%`n
		FileAppend, %sitepass%`n
		FileAppend, cd %SERVERDIR%`n
		FileAppend, dir
		if (PortVer = 1)
			{
				FileAppend, del skeletonKey-portable.zip`n, ftp.txt
				FileAppend, put %DBP%\skeletonKey-portable.zip`n, ftp.txt
				FileAppend, del skeletonKey-portable.zip`n, skeletonkey.scr	
				FileAppend, put %DBP%\skeletonKey-portable.zip`n, skeletonkey.scr
			}
		if (DATBLD = 1)
			{
				FileAppend, del DATFILES\DATFILES.7z`n, ftp.txt
				FileAppend, put  %DBP%\DATFILES.7z`n, ftp.txt
				FileAppend, del DATFILES\DATFILES.7z`n, skeletonkey.scr
				FileAppend, put  %DBP%\DATFILES.7z`n,skeletonkey.scr			
			}
		if (OvrStable = 1)
			{
				FileAppend, del skeletonKey.zip`n, ftp.txt
				FileAppend, put %DBP%\skeletonKey.zip`n, ftp.txt
				FileAppend, del skeletonKey.zip`n, skeletonkey.scr
				FileAppend, put %DBP%\skeletonKey.zip`n, skeletonkey.scr		
			}

		if (DevlVer = 1)
			{
				FileAppend, put %DBP%\skeletonkey-%date%%buildnum%.zip`n, ftp.txt
				FileAppend, put %DBP%\skeletonkey-%date%%buildnum%.zip`n, skeletonkey.scr
			}

		if (SiteUpdate <> 1)
			{
				FileAppend, bye`n, ftp.txt
				FileAppend, quit`n, skeletonkey.scr
				if (FTPXE = "SFTP")
					{
								RunWait, %comspec% cmd /c " "%BUILDIR%\psftp.exe" -be %siteuser%@%SITEURL% -P %PORTNUM% -pw %sitepass% -b skeletonkey.scr ", %BUILDIR%,%rntp%
					}
				if (FTPXE = "FTP")
					{
						RunWait, %comspec% cmd /c " ftp -s:ftp.txt ",%BUILDIR%,%rntp%
					}
			}
		guicontrol,,progb,80
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
		FileAppend, cd WEBSITE`n, skeletonkey.scr
		FileAppend, del skeletonkey.html`n, skeletonkey.scr
		FileAppend, put %DBP%\WEBSITE\skeletonkey.html`n, skeletonkey.scr
		FileAppend, cd WEBSITE`n, ftp.txt
		FileAppend, del skeletonkey.html`n, ftp.txt
		FileAppend, put %DBP%\WEBSITE\skeletonkey.html`n, ftp.txt
		FileAppend, bye, ftp.txt

		FileAppend, quit`n, skeletonkey.scr
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
				FileMove, %DBP%\WEBSITE\skeletonkey.html, %DBP%\WEBSITE\skeletonkey.index.bak,1
				FileRead,skelhtml,%SKELD%\skeletonkey.html
				StringReplace,skelhtml,skelhtml,[CURV],%vernum%,All
				FileDelete,%BUILDIR%\insts.sha1
				if (OvrStable = 1)
					{
						ifExist, %DBP%\skeletonkey-installer.exe
							{
								Runwait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DBP%\skeletonkey-installer.exe" >"%BUILDIR%\insts.sha1" ", %BUILDIR%,%rntp%
								FileReadLine,shap,%BUILDIR%\insts.sha1,4
								stringsplit,sha,shap,%A_Space%
								if (SBOV = 1)
									{
										sha1= reverted
									}
								if (DBOV = 1)
									{
										sha1= reverted
									}
							}
						ifExist, %DBP%\skeletonkey-Full.exe
							{
								Runwait, %comspec% cmd /c " "%BUILDIR%\fciv.exe" -sha1 "%DBP%\skeletonkey-Full.exe" >"%BUILDIR%\instsFull.sha1" ", %BUILDIR%,%rntp%
								FileReadLine,shag,%BUILDIR%\instsFull.sha1,4
								stringsplit,shb,shag,%A_Space%
								if (SBOV = 1)
									{
										shb1= reverted
									}
								if (DBOV = 1)
									{
										shb1= reverted
									}
							}
				ifExist, %DBP%\skeletonkey-%date%%buildnum%.zip
					{
						FileGetSize,dvlsize,%DBP%\skeletonkey-%date%%buildnum%.zip, K
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
				ifExist, %DBP%\skeletonkey-Full-%date%%buildnum%.zip
					{
						FileGetSize,dvgsize,%DBP%\skeletonkey-Full-%date%%buildnum%.zip, K
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
		}
		guicontrol,,progb,90
		StringReplace,skelhtml,skelhtml,[RSHA1],%sha1%,All
		StringReplace,skelhtml,skelhtml,[RSHA2],%shb1%,All
		StringReplace,skelhtml,skelhtml,[WEBURL],http://%SITEURL%/WEBSITE,All
		StringReplace,skelhtml,skelhtml,[GITSRC],%GITSRC%,All
		StringReplace,skelhtml,skelhtml,[REVISION],skeletonkey-%date%%buildnum%,All
		StringReplace,skelhtml,skelhtml,[RDATE],%RDATE%,All
		StringReplace,skelhtml,skelhtml,[RSIZE],%dvms%,All
		StringReplace,skelhtml,skelhtml,[RSIZE2],%dvmg%,All
		StringReplace,skelhtml,skelhtml,[DBSIZE],%DATSZ%,All
		FileAppend,%skelhtml%,%DBP%\WEBSITE\skeletonkey.html
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
		
		RunWait, %comspec% cmd /c " "%BUILDIR%\psftp.exe" -be %siteuser%@%SITEURL% -P %PORTNUM% -pw %sitepass% -b skeletonkey.scr ", %BUILDIR%,%rntp%
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
