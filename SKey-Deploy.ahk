#NoEnv
;#Warn
;#NoTrayIcon
#Persistent
#SingleInstance Force

;{;;;;;;, TOGGLE, ;;;;;;;;;
SetWorkingDir %A_ScriptDir%
Process, Exist,
CURPID= %ERRORLEVEL%
cacheloc= %A_Temp%
ARIA= %A_Scriptdir%\bin\aria2c.exe
ARCH= 64
rpfs= %A_ProgramFiles%
rpfsx86= %A_ProgramFiles% (x86)
if (A_Is64bitOS	= 0)
	{
		ARCH= 32
		stringreplace,rpfs,A_ProgramFiles,%A_Space%(x86),,All
		rpfsx86= %A_ProgramFiles%
	}
ifinstring,A_ProgramFiles,(x86)
	{
		stringreplace,rpfs,A_ProgramFiles,%A_Space%(x86),,All
	}
	
optionONE= %1%
optionTWO= %2%
optionTHREE= %3%
optionFOUR= %4%

ifinstring,optionONE,-gituser
	{
		stringsplit,vvi,optionONE,=
		GITUSER= %vvi2%
		ifinstring,optionTWO,-gitpass
			{
				stringsplit,vvb,optionTWO,=
				GITPASS= %vvb2%
				ifinstring,optionTHREE,-gittoken
					{
						stringsplit,vvc,optionTHREE,=
						GITPAT= %vvc2%
					}
			}
	}
GITWEB= http://github.com
GITSWEB= https://github.com
ifinstring,optionONE,-reset
	{
		FileDelete,%save%
		FileDelete,%npsave%
		Msgbox,3,Credentials,Keep git credentials and passwords?
		ifmsgbox,Cancel
			{
				goto, QUITOUT
			}
		cntrst= 1	
		GITROOT=
		BUILDIR=
		SKELD=
		AHKDIR=
		DEPL=
		NSIS=
		GITAPP=
		GITD=
		SITEDIR=
		GETIPADR=
		REPOURL=
		UPDTURL=
		GITSRC=
		GITRLS=
		SCITL=
		ifmsgbox,No
			{
				GITPASS= 
				GITMAIL= 
				GITUSER=
				GITPAT=
				cntrst= 
			}
		filedelete,skopt.cfg
	}

Loop, %save%
	{
		if (A_LoopFileSizeMB < 30)
			{
				filedelete, %save%
			}
	}
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")

skeltmp= %A_ScriptDir% 

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
		rntp= max
	}

IfNotExist, skopt.cfg
	{
		INIT= 1
		if (cntrst = 1)
			{
				if (GITUSER <> "")
					{
						iniwrite,%GITUSER%,skopt.cfg,GLOBAL,git_username
					}
				if (GITUSER <> "")
					{
						iniwrite,%GITMAIL%,skopt.cfg,GLOBAL,git_email
					}
				if (GITPASS <> "")
					{
						iniwrite,%GITPASS%,skopt.cfg,GLOBAL,git_password
					}
				if (GITPAT <> "")
					{
						iniwrite,%GITPAT%,skopt.cfg,GLOBAL,git_token
					}
					
			}
		skeltmp= %A_WorkingDir%
		iniwrite,%skeltmp%,skopt.cfg,GLOBAL,Project_Directory
		bldtmp= %A_WorkingDir%
		iniwrite,%bldtmp%,skopt.cfg,GLOBAL,BUILD_Directory
		CONTPARAM17= 1
		CONTPARAM9= 1
		_BUILDIR= %bldtmp%
		_SKELD= %skeltmp%

		_GITUSER= 
		_GITPASS=
		_GITPAT=
		_RREPO=repo_hub
		_DREPO=dat_hub
		_UPDTURL= http://raw.githubusercontent.com/romjacket/skeletonkey/master/site/version.txt
		_UPDTFILE= %GITSWEB%/romjacket/skeletonKey/releases/download/portable/skeletonKey.zip
		_GETIPADR= http://www.netikus.net/show_ip.html				
		_GITSRC= %GITWEB%/romjacket/skeletonkey
		_REPOURL= %GITWEB%/romjacket
		_ALTHOST= %GITWEB%/romjacket
		iniwrite,%_DREPO%,skopt.cfg,GLOBAL,dat_hub
		iniwrite,%_RREPO%,skopt.cfg,GLOBAL,repo_hub
		gitrttmp=
		_GITROOT= (not set) Github-Projects-Directory
		_GITD= (not set) Github-Skeletonkey-Directory
		IfExist, %A_MyDocuments%\Github
			{
				gitrttmp= %A_MyDocuments%\Github
				CONTPARAM8= 1
				_GITROOT= %gitrttmp%
				GITROOT= %gitrttmp%
				iniwrite,%GITROOT%,skopt.cfg,GLOBAL,Git_Root
				gittmp=
				IfExist, %A_MyDocuments%\Github\skeletonKey
					{
						gittmp= %A_MyDocuments%\Github\skeletonKey
						CONTPARAM10= 1
						_GITD= %gittmp%
						GITD= %gittmp%
						iniwrite,%GITD%,skopt.cfg,GLOBAL,Project_Directory
					}
			}	
			
		_AHKDIR= (not set) Ahk2Exe.exe
		comptmp= 
		IfExist, %rpfs%\AutoHotkey\Compiler
			{
				comptmp= %rpfs%\AutoHotkey\Compiler
				CONTPARAM7= 1
				_AHKDIR= %comptmp%\Ahk2exe.exe
				AHKDIR= %comptmp%
				iniwrite,%AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
			}
		IfExist, %A_MyDocuments%\AutoHotkey\Compiler
			{
				comptmp= %A_MyDocuments%\AutoHotkey\Compiler
				CONTPARAM7= 1
				_AHKDIR= %comptmp%\Ahk2exe.exe
				AHKDIR= %comptmp%
				iniwrite,%AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
			}
			
		depltmp= 
		_DEPL= (not set) Deployment-Directory			
		IfExist, %A_MyDocuments%\Github\skeletonkey.deploy
			{
				depltmp= %A_MyDocuments%\Github\skeletonkey.deploy
				_DEPL= %depltmp%
				DEPL= %depltmp%
				CONTPARAM12= 1
				iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
			}
			
		_GITAPP= (not set) git.exe
		_GITRLS= (not set) github-release.exe
		gitapptmp= 
		gitrlstmp= 
		ifexist,%rpfs%\git\bin\git.exe
			{
				gitapptmp= %rpfs%\git\bin\git.exe
				GITAPP= %gitapptmp%
				_GITAPP= %gitapptmp%
				CONTPARAM4= 1
				iniwrite,%gitapptmp%,skopt.cfg,GLOBAL,git_app
				ifexist,%rpfs%\git\bin\github-release.exe
					{
						gitrlstmp= %rpfs%\git\bin\github-release.exe
						_GITRLS= %gitrlstmp%
						GITRLS= %gitrlstmp%
						CONTPARAM5= 1
						iniwrite,%gitrlstmp%,skopt.cfg,GLOBAL,git_rls
					}
			}
		ifexist,%A_MyDocuments%\git\bin\git.exe
			{
				gitapptmp= %A_MyDocuments%\git\bin\git.exe
				GITAPP= %gitapptmp%
				_GITAPP= %gitapptmp%
				CONTPARAM4= 1
				iniwrite,%gitapptmp%,skopt.cfg,GLOBAL,git_app
				ifexist,%A_MyDocuments%\git\bin\github-release.exe
					{
						gitrlstmp= %A_MyDocuments%\git\bin\github-release.exe
						_GITRLS= %gitrlstmp%
						GITRLS= %gitrlstmp%
						CONTPARAM5= 1
						iniwrite,%gitrlstmp%,skopt.cfg,GLOBAL,git_rls
					}
			}
			
		_NSIS= (not set) makensis.exe
		nsitmp= 
		Loop, %A_MyDocuments%\nsis*,2
			{
				ifexist,%A_LoopfileFullPath%\makensis.exe
					{
						nsitmp= %A_LoopfileFullPath%\makensis.exe
						_NSIS= %nsitmp%
						NSIS= %nsitmp%
						CONTPARAM6= 1
						iniwrite,%NSIS%,skopt.cfg,GLOBAL,NSIS
					}
			}
		Loop, %rpfs%\nsis*,2
			{
				ifexist,%A_LoopfileFullPath%\makensis.exe
					{
						nsitmp= %A_LoopfileFullPath%\makensis.exe
						_NSIS= %nsitmp%
						NSIS= %nsitmp%
						CONTPARAM6= 1
						iniwrite,%NSIS%,skopt.cfg,GLOBAL,NSIS
					}
			}
		
		_SITEDIR= (not set) Site-Directory	
		if (GITUSER = "")
			{
				ifexist,%A_MyDocuments%\GitHub\%A_Username%.github.io
					{
						GITUSER= %A_Username%
						_GITUSER= %A_Username%
						CONTPARAM1= 1
						iniwrite,%GITUSER%,skopt.cfg,GLOBAL,git_username
						
						GITMAIL= %A_Username%@nomailaddy.org
						_GITMAIL= %A_Username%@nomailaddy.org
						CONTPARAM19= 1
						iniwrite,%GITUSER%,skopt.cfg,GLOBAL,git_email
						
						SITEDIR= %A_MyDocuments%\GitHub\%A_Username%.github.io
						_SITEDIR= %SITEDIR%
						CONTPARAM11= 1
						iniwrite,%SITEDIR%,skopt.cfg,GLOBAL,site_directory
						
						UPDTURL= http://raw.githubusercontent.com/%gituser%/skeletonkey/master/site/version.txt
						_UPDTURL= %UPDTURL%
						CONTPARAM13= 1
						iniwrite,%UPDTURL%,skopt.cfg,GLOBAL,update_url
						
						UPDTFILE= %GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip
						_UPDTFILE= %UPDTFILE%
						CONTPARAM14= 1
						iniwrite,%UPDTFILE%,skopt.cfg,GLOBAL,update_file
						
						GITSRC= %GITWEB%/%gituser%/skeletonkey
						_GITSRC= %GITSRC%
						CONTPARAM18= 1
						iniwrite,%GITSRC%,skopt.cfg,GLOBAL,git_url
					}
			}
	}

READSKOPT:
Loop, Read, skopt.cfg
	{
		curvl1= 
		curvl2= 
		stringsplit, curvl, A_LoopReadLine,=
		if (curvl1 = "git_username")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITUSER= %curvl2%
							_GITUSER= %curvl2%
							CONTPARAM1= 1
						}
				}
		if (curvl1 = "git_password")
				{	
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITPASS= %curvl2%
							_GITPASS= %curvl2%
							CONTPARAM2= 1
						}
				}
		if (curvl1 = "git_token")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITPAT= %curvl2%
							_GITPAT= %curvl2%
							CONTPARAM3= 1
						}
				}
		if (curvl1 = "git_app")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITAPP= %curvl2%
							_GITAPP= %curvl2%
							CONTPARAM4= 1
						}
				}		
		if (curvl1 = "git_rls")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITRLS= %curvl2%
							_GITRLS= %curvl2%
							CONTPARAM5= 1
						}
				}
		if (curvl1 = "NSIS")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							NSIS= %curvl2%
							_NSIS= %curvl2%
							CONTPARAM6= 1
						}
				}
		if (curvl1 = "Compiler_Directory")
			{
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						AHKDIR= %curvl2%
						_AHKDIR= %curvl2%
						CONTPARAM7= 1
					}
			}
		if (curvl1 = "Git_Root")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITROOT= %curvl2%
							_GITROOT= %curvl2%
							CONTPARAM8= 1
						}
				}
		if (curvl1 = "Source_Directory")
			{
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						SKELD= %curvl2%
						_SKELD= %curvl2%
						CONTPARAM9= 1
					}
			}
		if (curvl1 = "Project_Directory")
					{
						if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
							{
								GITD= %curvl2%
								_GITD= %curvl2%
								CONTPARAM10= 1
							}
					}
		if (curvl1 = "Site_Directory")
					{
						if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
							{
								SITEDIR= %curvl2%
								_SITEDIR= %curvl2%
								CONTPARAM11= 1
							}
					}
		if (curvl1 = "Deployment_Directory")
			{
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						DEPL= %curvl2%
						_DEPL= %curvl2%
						CONTPARAM12= 1
					}
			}
		if (curvl1 = "update_url")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							UPDTURL= %curvl2%
							_UPDTURL= %curvl2%
							CONTPARAM13= 1
						}
				}
		if (curvl1 = "update_file")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							UPDTFILE= %curvl2%
							_UPDTFILE= %curvl2%
							CONTPARAM14= 1
						}
				}
		if (curvl1 = "net_ip")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GETIPADR= %curvl2%
							_GETIPADR= %curvl2%
							CONTPARAM15= 1
						}
				}
		if (curvl1 = "alt_host")
				{
					_REPOURL= %GITWEB%/romjacket
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							ALTHOST= %curvl2%
							_ALTHOST= %curvl2%
						}
				}
		if (curvl1 = "git_email")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITMAIL= %curvl2%
							_GITMAIL= %curvl2%
							CONTPARAM19= 1
						}
				}

		if (curvl1 = "repo_hub")
				{
					_DREPO= repo_hub
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							RREPO= %curvl2%
							_RREPO= %curvl2%
							CONTPARAM22= 1
						}
				}
		if (curvl1 = "dat_hub")
				{
					_DREPO= dat_hub
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							DREPO= %curvl2%
							_DREPO= %curvl2%
							CONTPARAM23= 1
						}
				}
		if (curvl1 = "repository_url")
				{
					_REPOURL= %GITWEB%/romjacket
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							REPOURL= %curvl2%
							_REPOURL= %curvl2%
							CONTPARAM16= 1
						}
				}
		if (curvl1 = "Build_Directory")
			{
				if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
					{
						BUILDIR= %curvl2%
						_BUILDIR= %curvl2%
						CONTPARAM17= 1
					}
			}
		if (curvl1 = "git_url")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							GITSRC= %curvl2%
							_GITSRC= %curvl2%
							CONTPARAM18= 1
						}
				}
		if (curvl1 = "SciTE4AutoHotkey")
				{
					if ((curvl2 <> "")&&(curvl2 <> "ERROR"))
						{
							SCITL= %curvl2%
						}
				}
	}
;{;;;;;;;;;;;;;;;;;;;;;;;;   TOOL TIPS    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
DwnGit_TT :="Download Git executables"
SelGit_TT :="Select the Git.exe"
ILogin_TT :="github username"
RREPO_TT :="GitHub ROM repository project"
DREPO_TT :="GitHub DAT repository project"
IPass_TT :="github password"
IToken_TT :="Personal Access Token"
DwnRls_TT :="Download Github-release.exe"
SelRls_TT :="Select the github-release.exe"
DwnNSIS_TT :="Download the NSIS executable"
SelNSIS_TT :="Select makensis.exe"
DwnAHK_TT :="Download AutoHotkey"
IALTH_TT :="Alternate user repositories`ndelimited by a ''>''"
SelAHK_TT :="Select the Ahk2Exe compiler executable"
SelBLD_TT :="Select the build directory.`nusually the same as your source directory"
SelGPD_TT :="Select the GitHub Projects directory`nusually ..\..\Documents\GitHub"
DwnPuLL_TT :="Clones skeletonkey from github.com"
SelGSD_TT :="Selects the github skeletonkey project"
DwnIO_TT :="Clones the skeletonkey github website."
SelGWD_TT :="Selects the skeletonkey website directory`nusually ..\Documents\GitHub\`%gituser`%.github.io\"
SelDPL_TT :="Selects the deployment directory`nwhere skeletonkey executables and assets are compiled to"
SelSRC_TT :="The source Directory`nusually this current directory"
UVER_TT :="the 'version.txt' file containing update information."
UFLU_TT :="the update file (also the portable executable)"
IURL_TT :="The Website url which reports the internet ip address"
IREPO_TT :="The URL for all emulators and assets"
SelDXB_TT :="Detect your environment and download needed programs"
IContinue_TT :="Sets the current environment."
SelDIR_TT :="Selects the location of the currently selected item"
RESGET_TT :="Downloads or Clones the currently selected item"
ResB_TT :="Resets the currently selected item/s"
PushNotes_TT :="The commit message uploaded to github as well as the changelog"
VerNum_TT :="The new version of skeletonkey"
AddIncVer_TT :="Increases the version number"
COMPILE_TT :="Deploys skeletonkey"
LogView_TT :="View the deployment log"
GitPush_TT :="Pushes the changes to github.com"
ServerPush_TT :="Uploads releases"
SiteUpdate_TT :="Updates the website"
CANCEL_TT :="Interrupts the deployment"
INITINCL_TT :="Re-indexes the source directory and adds any new files to be included"
RePODATS_TT :="Recompiles any changes to your repository lists"
PortVer_TT :="compiles the portable executable"
OvrStable_TT :="compiles the installer"
DatBld_TT :="Recompiles the metadata database xmls"


;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;;;;;;;  INITIALIZATION MENU GUI  ;;;;;;;;;;;;;;;;;;;;;;;;;;
initchk= 
Loop,19
	{
		vinit= % CONTPARAM%A_Index%
		if (vinit = "")
			{
				initchk= 1
				break
			}
	}
if (initchk = 1)
	{
		setupguiitems= ILogin|IEmail|IPass|IToken|DwnGit|SelGit|DwnRls|SelRls|DwnNSIS|SelNSIS|DwnAHK|SelAHK|SelBLD|SelGPD|DwnPULL|SelGSD|DwnIO|SelGWD|SelDPL|SelSRC|UVER|UFLU|IURL|IREPO|RREPO|DREPO|IReset|SelDXB|ICONTINUE
		Gui,Font,Bold
		Gui Add, GroupBox, x11 y1 w370 h429, Deployment Tool Setup
		Gui,Font,normal
		Gui Add, Text, x20 y20 w29 h14 , login:
		Gui Add, Text, x287 y25 w88 h14 , (github username)
		Gui Add, Edit, x51 y18 w234 h21 vILogin gILogin, %_GITUSER%
		Gui Add, Text, x18 y45 w29 h14 , pass:
		Gui Add, Edit, x51 y41 w138 h21 vIPass gIPass password, %_GITPASS%
		Gui Add, Text, x190 y45 w29 h14 , email:
		Gui Add, Edit, x221 y41 w155 h21 vIEmail gIEmail, %_GITMAIL%
		Gui Add, Text, x18 y68 w29 h14 , token:
		Gui Add, Edit, x51 y64 w295 h21 vIToken gIToken, %_GITPAT%
		Gui Add, Link, x351 y66 w10 h19, <a href="https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line#creating-a-token">?</a>

		Gui Add, Button, x16 y88 w13 h17 vDwnGit gDwnGit, V
		Gui Add, Text, x32 y90 w323 h14 vTxtGit +Right, %_GITAPP%
		Gui Add, Button, x355 y87 w20 h19 vSelGit gSelGit, F
		Gui Add, Text, x14 y106 w363 h2 +0x10

		Gui Add, Button, x16 y109 w13 h17 vDwnRls gDwnRls, V
		Gui Add, Text, x32 y112 w324 h14 vTxtRls +Right, %_GITRLS%
		Gui Add, Button, x355 y108 w20 h19 vSelRls gSelRls, F
		Gui Add, Text, x16 y128 w363 h2 +0x10

		Gui Add, Button, x16 y130 w13 h17 vDwnNSIS gDwnNSIS, V
		Gui Add, Text, x32 y134 w323 h14 vTxtNSIS +Right, %_NSIS%
		Gui Add, Button, x355 y130 w20 h19 vSelNSIS gSelNSIS, F
		Gui Add, Text, x16 y150 w363 h2 +0x10

		Gui Add, Button, x16 y152 w13 h17 vDwnAHK gDwnAHK, V
		Gui Add, Text, x32 y155 w323 h14 vTxtAHK +Right, %_AHKDIR%
		Gui Add, Button, x355 y152 w20 h19 vSelAHK gSelAHK, F
		Gui Add, Text, x16 y170 w363 h2 +0x10

		Gui Add, Text, x23 y197 w322 h14  vTxtBLD +Right, %_BUILDIR%
		Gui Add, Button, x353 y193 w23 h23 vSelBLD gSelBLD, ...
		Gui Add, Text, x16 y191 w363 h2 +0x10

		Gui Add, Text, x23 y175 w322 h14 vTxtGPD +Right, %_GITROOT%
		Gui Add, Button, x353 y170 w23 h23 vSelGPD gSelGPD, ...
		Gui Add, Text, x16 y216 w363 h2 +0x10

		Gui Add, Button, x16 y218 w13 h17 vDwnPULL gPULLSKEL, C
		Gui Add, Text, x37 y221 w307 h14 vTxtGSD +Right, %_GITD%
		Gui Add, Button, x353 y216 w23 h23 vSelGSD gSelGSD, ...
		Gui Add, Text, x16 y239 w363 h2 +0x10

		Gui Add, Button, x16 y241 w13 h17 vDwnIO gPULLIO, C
		Gui Add, Text, x37 y243 w307 h14 vTxtGWD +Right, %_SITEDIR%
		Gui Add, Button, x353 y239 w23 h23 vSelGWD gSelGWD, ...
		Gui Add, Text, x16 y262 w363 h2 +0x10

		Gui Add, Text, x23 y267 w322 h14 vTxtDPL +Right, %_DEPL%
		Gui Add, Button, x353 y262 w23 h23 vSelDPL gSelDPL, ...
		Gui Add, Text, x16 y284 w363 h2 +0x10

		Gui Add, Text, x23 y290 w322 h14 vTxtSRC +Right, %_SKELD%
		Gui Add, Button, x353 y285 w23 h23 vSelSRC gSelSRC, ...

		Gui Add, Edit, x30 y310 w326 h21 vUVER gUVER, %_UPDTURL%
		Gui Add, Edit, x30 y333 w326 h21 vUFLU gUFLU, %_UPDTFILE%
		Gui Add, Edit, x30 y357 w326 h21 vIURL gIURL, %_GETIPADR%
		Gui Add, Edit, x30 y380 w156 h21 vIREPO gIREPO, %_REPOURL%
		Gui Add, Edit, x190 y380 w70 h21 vRREPO gRREPO, %RREPO%
		Gui Add, Edit, x264 y380 w70 h21 vDREPO gDREPO, %DREPO%
		Gui Add, Edit, x30 y403 w326 h21 vIALTH gIALTH, %_ALTHOST%
		Gui Add, Button, x10 y432 w51 h19 vIReset gIReset, reset_all
		Gui Add, Button, x331 y432 w51 h19 vSelDXB gSelDXB, quick
		Gui Add, Button, x159 y433 w80 h23 vICONTINUE gICONTINUE, CONTINUE
		Gui Add, StatusBar,, Status Bar
		OnMessage(0x200, "WM_MOUSEMOVE")
		Gui, Show, w391 h482, _DEV_
		return	
	}
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INITCOMPLETE:
oldsize=
oldsha= 
olrlsdt=
vernum=	
RunWait, %comspec% /c "%gitapp%"
VERSIONGET:
sklnum= 
getversf= %gitroot%\%GITUSER%.github.io\skeletonkey\index.html

ifnotexist,%getversf%
	{
		FileDelete,ORIGHTML.html
		save= ORIGHTML.html
		URLFILE= http://romjacket.github.io/skeletonkey/index.html
		splitpath,save,svaf,svap
		exe_get(ARIA,URLFILE,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(URLFILE, save, True, True)
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
				Loop,Parse,vernum,.
					{
						if A_LoopField is not digit
							{
								vernum= 0.99.00.00
							}
					}
				continue
			}
			ifinstring,A_LoopReadLine,<h88>
					{
						stringgetpos,verstr,A_LoopReadLine,<h88>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h87>
					{
						stringgetpos,verstr,A_LoopReadLine,<h87>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsize,sklin,%getvern%,4
						continue
					}
			ifinstring,A_LoopReadLine,<h77>
					{
						stringgetpos,verstr,A_LoopReadLine,<h77>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,oldsha,sklin,%getvern%,40
						continue
					}
			ifinstring,A_LoopReadLine,<h66>
					{
						stringgetpos,verstr,A_LoopReadLine,<h66>
						FileReadLine,sklin,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= verstr+6
						StringMid,olrlsdt,sklin,%getvern%,18
						continue
					}	
			ifinstring,A_LoopReadLine,<h55>
					{
						stringgetpos,donat,A_LoopReadLine,<h55>
						FileReadLine,donit,%gitroot%\%GITUSER%.github.io\skeletonkey\index.html,%sklnum%
						getvern:= donat+6
						StringMid,donation,donit,%getvern%,5
						continue
					}	
	}

if (vernum = "")
	{
		vernum= 0.99.00.00
	}
initchk= 	
FileReadLine,initchk,skopt.cfg,19
if (initchk = "")
	{
		msgbox,0,,incomplete config
		filedelete,skopt.cfg
		exitapp
	}	
	
FIE= 
if (GITRLS = "")
	{
		FIE= Hidden
	}
if (GITPAT = "")
	{
		FIE= Hidden
	}
if (GITPAT = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	{
		FIE= Hidden
	}

;{;;;;;;;;;;;;;;;,,,,,,,,,, DEPLOYMENT MENU GUI,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;;;
;;Gui Add, Tab2, x2 y-1 w487 h171 vTABMENU Bottom, Setup|Deploy
;;Gui, Tab, 1
;;Gui, Tab, Setup
;;Gui, Add, Text,x164 y5, Location
;;Gui, Add, DropDownList, x8 y2 w100 vSRCDD gSrcDD, Project||Git.exe|github-release|Source|Compiler|Site|Deployment|Build|NSIS|SciTE4AutoHotkey|repo_hub|dat_hub
;;Gui, Add, Button, x109 y2 w52 h21 vSELDIR gSelDir, Select
;;Gui, Add, Button, x109 y26 w52 h21 vRESGET gRESGET, Clone
;;Gui Add, DropDownList,x331 y2 w92 vResDD gResDD, All||Dev-Build|Portable-Build|Stable-Build|Deployer|Update-URL|Update-File|Repo-URL|Internet-IP-URL|Git-User|Git-Password|Git-Token|Git-URL
;;Gui Add, Button, x425 y2 w52 h21 vResB gResB, Reset

;;Gui Add, Text,x4 y125, %ARCH%-bit
;;Gui Add, Picture, x4 y58 w155 h67, img\ins.png
;;Gui Add, Picture, x160 y58 w70 h60, img\cor.png
;;Gui Add, Picture, x241 y58 w70 h60, img\emu.png
;;Gui Add, Picture, x322 y58 w70 h60, img\net.png
;;Gui Add, Picture, x404 y58 w70 h60, img\opt.png

;;Gui, Tab, 2
;;Gui Tab, Deploy
Gui, Add, Edit, x8 y24 w469 h50 vPushNotes gPushNotes,%date% :%A_Space%
Gui, Add, Edit, x161 y151 w115 h21 vVernum gVerNum +0x2, %vernum%
Gui, Add, Button, x280 y154 w16 h16 vAddIncVer gAddIncVer,+
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCOMPILE gCOMPILE, DEPLOY
gui,font,normal
Gui, Add, Text, x8 y7, Git Push Description / changelog
Gui, Add, Button, x452 y106 w31 h17 vLogView gLogView,log
Gui, Add, CheckBox, x9 y75 h17 vGitPush gGitPush checked, Git Push
Gui, Add, CheckBox, x9 y94 h17 vServerPush gServerPush checked, Server Push
Gui, Add, CheckBox, x9 y112 h17 vSiteUpdate gSiteUpdate checked, Site Update
gui,font,bold
Gui, Add, Button, x408 y123 w75 h23 vCANCEL gCANCEL hidden, CANCEL
gui,font,normal
Gui, Add, Text, x308 y155, Version
Gui, Add, CheckBox, x204 y76 w114 h13 vINITINCL gINITINCL checked, Initialize-Include
Gui, Add, CheckBox, x204 y95 w154 h13 vREPODATS gREPODATS, Repository Databases
Gui, Add, CheckBox, x90 y95 w104 h13 vPortVer gPortVer checked %FIE%, Portable/Update
Gui, Add, CheckBox, x90 y76 w104 h13 vOvrStable gOvrStable %FIE% checked,Stable
Gui, Add, CheckBox, x90 y95 w154 h13 vDevlVer gDevlVer hidden, Development Version
Gui, Add, CheckBox, x90 y113 w154 h13 vDATBLD gDatBld, Database Recompile

Gui, Add, Progress, x12 y135 w388 h8 vprogb -Smooth, 0

Gui, Add, StatusBar, x0 y151 w488 h18, Compiler Status
OnMessage(0x200, "WM_MOUSEMOVE")
Gui, Show, w488 h194,_DEV_	
GuiControl, Choose, TABMENU, 2
Return

;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


INITINCL:
INITINCL= 1
return


;{;;;;;;;;;;;;;;;;;;;;;;;;;;;   SETUP MENU ITEMS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;;   RESET BUTTON  ;;;;;;;;;;;;;;;;
IReset:
gui,submit,nohide
guicontrol,,txtGIT,(not set) git.exe
guicontrol,,ilogin,	
guicontrol,,ipass,	
guicontrol,,itoken,	
guicontrol,,txtrls,(not set) github-release.exe
guicontrol,,txtnsis,(not set) makensis.exe
guicontrol,,txtahk,(not set) Ahk2Exe.exe
guicontrol,,txtgpd,(not set) Github-Projects-Directory
guicontrol,,txtgsd,(not set) Github-Skeletonkey-Directory
guicontrol,,txtgwd,(not set) Github-Site-Directory
guicontrol,,txtsrc,(not set) Source-Directory
guicontrol,,txtbld,(not set) Build-Directory
guicontrol,,txtdpl,(not set) Deployment-Directory
guicontrol,,uver, http://raw.githubusercontent.com/romjacket/skeletonkey/master/site/version.txt
guicontrol,,iurl,http://www.netikus.net/show_ip.html
guicontrol,,uflu, %GITSWEB%/romjacket/skeletonKey/releases/download/portable/skeletonKey.zip
guicontrol,,irepo, %GITSWEB%/romjacket
guicontrol,,rrepo,repo_hub
guicontrol,,drepo,dat_hub
guicontrol,,ialth, %GITSWEB%/romjacket
if (optionONE = "DEV")
	{
		guicontrol,,ialth, %optionTWO%
	}
Loop,19
	{
		CONTPARAM%A_Index%= 
	}
CONTPARAM13= 1
CONTPARAM14= 1
CONTPARAM15= 1
CONTPARAM16= 1
filedelete,skopt.cfg
return

;};;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;; COMPLETE SETUP & INITIALIZE ;;;;;;;;;;;;;
ICONTINUE:
nocont= 
stv= 
if (CONTPARAM21 = "")
	{
		guicontrolget,IALTH,,IALTH
		iniwrite,%IALTH%,skopt.cfg,GLOBAL,alt_host
		CONTPARAM21= 1
	}
if (CONTPARAM19 = "")
	{
		guicontrolget,IEmail,,IEmail
		iniwrite,%IEmail%,skopt.cfg,GLOBAL,git_email
		CONTPARAM19= 1
	}
if (CONTPARAM13 = "")
	{
		guicontrolget,UVER,,UVER
		iniwrite,%UVER%,skopt.cfg,GLOBAL,update_url
		CONTPARAM13= 1
	}
if (CONTPARAM14 = "")
	{
		guicontrolget,UFLU,,UFLU
		CONTPARAM14= 1
		iniwrite,%UFLU%,skopt.cfg,GLOBAL,update_file
	}
if (CONTPARAM15 = "")
	{
		guicontrolget,IURL,,IURL
		iniwrite,%IURL%,skopt.cfg,GLOBAL,net_ip
		CONTPARAM15= 1
	}	
if (CONTPARAM22 = "")
	{
		guicontrolget,RREPO,,RREPO
		iniwrite,%RREPO%,skopt.cfg,GLOBAL,repo_hub
		CONTPARAM22= 1
	}	
if (CONTPARAM23 = "")
	{
		guicontrolget,DREPO,,DREPO
		iniwrite,%DREPO%,skopt.cfg,GLOBAL,dat_hub
		CONTPARAM23= 1
	}	
if (CONTPARAM16 = "")
	{
		guicontrolget,IREPO,,IREPO
		reponum1= 
		reponum2= 
		reponum3= 
		reponum4= 
		ALTHOST= 
		stringsplit,reponum,IREPO,>
		IniWrite,%reponum1%,skopt.cfg,GLOBAL,repository_url
		if (reponum2 <> "")
			{
				ALTHOST= %reponum2%
			}
		if (ALTHOST = "")
			{
				ALTHOST= %GITWEB%/romjacket
			}
		CONTPARAM16= 1
	}
Loop,22
	{
		stv= % CONTPARAM%A_Index%
		if (stv = "")
			{
				nocont= 1
			}
	}
if (nocont = 1)
	{
		if (CONTPARAM1 = "")
			{
				SB_SetText("github user not defined")
				return
			}
		if (CONTPARAM2 = "")
			{
				SB_SetText("password not defined")
				return
			}
		if (CONTPARAM3 = "")
			{
				SB_SetText("token not defined")
				return
			}
		if (CONTPARAM4 = "")
			{
				SB_SetText("git.exe not defined")
				return
			}
		if (CONTPARAM5 = "")
			{
				SB_SetText("github-release.exe not defined")
				return
			}
		if (CONTPARAM6 = "")
			{
				SB_SetText("makensis.exe not defined")
				return
			}
		if (CONTPARAM7 = "")
			{
				SB_SetText("Ahk2exe.exe not defined")
				return
			}
		if (CONTPARAM8 = "")
			{
				SB_SetText("github projects directory not defined")
				return
			}
		if (CONTPARAM9 = "")
			{
				SB_SetText("source directory not defined")
				return
			}
		if (CONTPARAM10 = "")
			{
				SB_SetText("github skeletonkey project not defined")
				return
			}
		if (CONTPARAM11 = "")
			{
				SB_SetText("website directory not defined")
				return
			}
		if (CONTPARAM12 = "")
			{
				SB_SetText("deployment directory not defined")
				return
			}
		if (CONTPARAM17 = "")
			{
				SB_SetText("Build Directory not defined")
				return
			}
		if (CONTPARAM18 = "")
			{
				SB_SetText("github skeletonkey project not defined")
				return
			}
	if (CONTPARAM19 = "")
			{
				SB_SetText("github email not defined")
				return
			}
	if (CONTPARAM21 = "")
			{
				SB_SetText("Alternate gituser not defined")
				return
			}
	if (CONTPARAM22 = "")
			{
				SB_SetText("repo_hub is not defined")
				return
			}
	if (CONTPARAM23 = "")
			{
				SB_SetText("dat_hub is not defined")
				return
			}
	}
Gui,Destroy
goto, INITCOMPLETE
;};;;;;;;;;;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ENVIRONMENT DETCTION BUTTON  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SelDXB:
autoinstall=
Msgbox,3,Quick-Setup,This tool can automatically install and initialize a development environment in:`n%A_MyDocuments%`n`nProceed? 
ifmsgbox,No
	{
		return
	}
ifmsgbox,Cancel
	{
		return
	}
autoinstall= 1	
GITAV= GIT_%ARCH%
GITRV= Git_Release_%ARCH%
BLDITEMS=%GITAV%|%GITRV%|SciTE4AutoHotkey|AutoHotkey|NSIS
Loop,parse,BLDITEMS,|
	{
		stringreplace,dwnlsi,A_LoopField,_%ARCH%,,All
		iniread,nwurl,sets\BuildTools.set,BUILDENV,%A_LoopField%
		%dwnlsi%URL= %nwurl%
		splitpath,nwurl,nwurlf
		if (A_LoopField = GITAV)
			{
				ifExist,%rpfs%\Git\bin\git.exe
					{
						iniwrite,%rpfs%\Git\bin\git.exe,skopt.cfg,GLOBAL,git_app
						CONTPARAM4= 1
						GITAPP= %rpfs%\Git\bin\git.exe
						guicontrol,,txtGIT,%GITAPP%
					}
				ifExist,%A_MyDocuments%\Git\bin\git.exe
					{
						iniwrite,%A_MyDocuments%\Git\bin\git.exe,skopt.cfg,GLOBAL,git_app
						GITAPP= %A_MyDocuments%\Git\bin\git.exe
						CONTPARAM4= 1
						guicontrol,,txtGIT,%GITAPP%
					}
			}
		if (CONTPARAM4 = "")
			{
				gosub, GetGitz
			}
		if (A_LoopField = GITRV)
			{
				ifExist,%rpfs%\Git\bin\github-release.exe
					{
						iniwrite,%rpfs%\Git\bin\github-release.exe,skopt.cfg,GLOBAL,git_rls
						CONTPARAM5= 1
						GITRLS= %rpfs%\Git\bin\github-release.exe
						guicontrol,,txtRLS,%GITRLS%
					}
				ifExist,%A_MyDocuments%\Git\bin\github-release.exe
					{
						iniwrite,%A_MyDocuments%\Git\bin\github-release.exe,skopt.cfg,GLOBAL,git_rls
						GITRLS= %A_MyDocuments%\Git\bin\github-release.exe
						CONTPARAM5= 1
						guicontrol,,txtRLS,%GITRLS%
					}
				if (CONTPARAM5 = "")
					{
						gosub, DwnRls
					}
			}
		if (A_LoopField = "AutoHotkey")
			{
				ifExist,%rpfs%\AutoHotkey\Compiler\Ahk2exe.exe
					{
						iniwrite,%rpfs%\AutoHotKey\Compiler,skopt.cfg,GLOBAL,Compiler_Directory
						CONTPARAM7= 1
						AHKDIR= %rpfs%\AutoHotKey\Compiler
						guicontrol,,txtAHK,%AHKDIR%
					}
				ifExist,%A_MyDocuments%\AutoHotKey\Compiler\Ahk2exe.exe
					{
						iniwrite,%A_MyDocuments%\AutoHotKey\Compiler,skopt.cfg,GLOBAL,Compiler_Directory
						CONTPARAM7= 1
						AHKDIR= %A_MyDocuments%\AutoHotKey\Compiler
						guicontrol,,txtAHK,%AHKDIR%
					}
				if (CONTPARAM7 = "")
					{
						gosub, GetAHKZ
					}
			}
		if (A_LoopField = "NSIS")
			{
				Loop,%rpfs%\nsis*,2
					{
						ifExist,%A_LoopFileFullPath%\makensis.exe
							{
								iniwrite,%A_LoopFileFullPath%\makensis.exe,skopt.cfg,GLOBAL,NSIS
								CONTPARAM6= 1
								NSIS= %A_LoopFileFullPath%\makensis.exe
								guicontrol,,txtNSIS,%NSIS%
								break
							}
					}
				Loop,%A_MyDocuments%\nsis*,2
					{
						ifExist,%A_LoopFileFullPath%\makensis.exe
							{
								iniwrite,%A_LoopFileFullPath%\makensis.exe,skopt.cfg,GLOBAL,NSIS
								CONTPARAM6= 1
								NSIS= %A_LoopFileFullPath%\makensis.exe
								guicontrol,,txtNSIS,%NSIS%
								break
							}
					}
				if (CONTPARAM6 = "")
					{
						gosub, GetNSIS
					}
			}
	}
if (SKELD = "")
	{
		SKELD= %A_ScriptDir%
		guicontrol,,txtSRC,%SKELD%
		CONTPARAM9= 1
		iniwrite,%SKELD%,skopt.cfg,GLOBAL,Source_Directory
	}
if (BUILDIR = "")
	{
		BUILDIR= %A_ScriptDir%
		guicontrol,,txtBLD,%BUILDIR%
		CONTPARAM17= 1
		iniwrite,%BUILDIR%,skopt.cfg,GLOBAL,BUILD_Directory
	}
if (GITUSER = "")
	{
		SB_SetText("username must be set to detect project environment")
		autoinstall=
		return
	}
	else {
			if (UPDTFILE = "")
				{
					CONTPARAM14= 1
					UPDTFILE= %GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip
					iniwrite,%UPDTFILE%,skopt.cfg,GLOBAL,update_file
					guicontrol,,UFLU,%UPDTFILE%
				}
			if (UPDTURL = "")
				{
					CONTPARAM13= 1
					UPDTURL= http://raw.githubusercontent.com/%gituser%/skeletonkey/master/site/version.txt
					iniwrite,%UPDTURL%,skopt.cfg,GLOBAL,update_url
					guicontrol,,UVER,%UPDTURL%
				}
			if (GITROOT = "")
				{
					ifnotexist,%A_MyDocuments%\GitHub\
						{
							filecreatedir,%A_MyDocuments%\GitHub
						}
					GITROOT= %A_MyDocuments%\GitHub
					guicontrol,,txtGPD,%GITROOT%
					CONTPARAM8= 1
					iniwrite,%GITROOT%,skopt.cfg,GLOBAL,Git_Root
				}
			if (GITD = "")
				{
					ifnotexist,%GITROOT%\skeletonkey\.git
						{
							gosub, Clonerj
							gosub, confirmSkelClone
						}							
					else {
					if (GITD = "")
						{
							GITD= %GITROOT%\skeletonkey
							CONTPARAM10= 1
							guicontrol,,txtGSD,%GITD%
						}
					ifnotexist,%GITROOT%\skeletonkey\
						{
							guicontrol,,txtGSD,(not set) Github-Skeletonkey-Directory
							autoinstall=
							return
						}	
					}
					if (GITSRC= "")
						{
							GITSRC= %GITWEB%/%gituser%/skeletonkey
							CONTPARAM18= 1
							iniwrite,%GITSRC%,skopt.cfg,GLOBAL,git_url
						}
				}
			ifnotexist,%GITROOT%\%gituser%.github.io\.git
				{
					filecreatedir,%GITROOT%\%gituser%.github.io\skeletonkey
					FileCopyDir,%SKELD%\site,%GITROOT%\%gituser%.github.io\skeletonkey,1
					gosub, completeSkelIO
				}
			ifnotexist,%GITROOT%\%gituser%.github.io\skeletonkey
				{
					filecreatedir,%GITROOT%\%gituser%.github.io\skeletonkey
					FileCopyDir,%SKELD%\site,%GITROOT%\%gituser%.github.io\skeletonkey,1
				}
			SITEDIR= %GITROOT%\%gituser%.github.io\skeletonkey
			CONTPARAM11= 1
			guicontrol,,txtGWD,%SITEDIR%
			iniwrite,%SITEDIR%,skopt.cfg,GLOBAL,site_directory
			DEPL= %GITROOT%\skeletonkey.deploy
			ifnotexist,%GITROOT%\skeletonkey.deploy
				{
					filecreatedir,%GITROOT%\skeletonkey.deploy
				}
			CONTPARAM12= 1
			guicontrol,,txtDPL,%DEPL%
			iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
		}
autoinstall=		
return	
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IEmail:
gui,submit,nohide
guicontrolget,IEMAIL,,IEMAIL
SB_SetText("Enter the email used for your github account.")
if (IEMAIL = "")
	{
		IEMAIL= %A_Username%@nomailaddy.org
		guicontrol,,IEMAIL,%IEMAIL%
	}
CONTPARAM19= 1
iniwrite,%IEMAIL%,skopt.cfg,GLOBAL,git_email
return

IURL:
gui,submit,nohide
guicontrolget,IURL,,IURL
SB_SetText("Enter the url of the file which contains your internet ip-address")
if (IRUL = "")
	{
		IURL= http://www.netikus.net/show_ip.html
		guicontrol,,IURL,%IURL%
	}
CONTPARAM15= 1
iniwrite,%IURL%,skopt.cfg,GLOBAL,net_ip
return

UFLU:
gui,submit,nohide
guicontrolget,UFLU,,UFLU
if (GITUSER = "")
	{
		UFLU= %GITSWEB%/romjacket/skeletonKey/releases/download/portable/skeletonKey.zip			
		guicontrol,,UFLU,%UFLU%
	}
if (UFLU = "")
	{
		UFLU= %GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip
		guicontrol,,UFLU,%UFLU%
	}
CONTPARAM14= 1
iniwrite,%UFLU%,skopt.cfg,GLOBAL,update_file
return

GitGPass:
InputBox, GITPASST , Git-Password, Input your github password,HIDE , 180, 140, , , ,, %GITPASST%
if (GITPASST = "")
	{
		GITPASS= *******
		iniwrite,*******,skopt.cfg,GLOBAL,Git_password
		return
	}
SRCDD= 
GITPASS= %GITPASST%	
iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
return

ILogin:
gui,submit,nohide
guicontrolget,GITUSER,,ILogin
CONTPARAM1= 
if (GITUSER = "")
	{
		SB_SetText("You must enter a username to continue")
		inidelete,skopt.cfg,GLOBAL,Git_username
		return
	}
CONTPARAM1= 1
iniwrite, %GITUSER%,skopt.cfg,GLOBAL,Git_username
guicontrol,,uVer,http://raw.githubusercontent.com/%gituser%/skeletonkey/master/site/version.txt
CONTPARAM13= 1
iniwrite,%uVer%,skopt.cfg,GLOBAL,update_url
guicontrol,,uFLU,%GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip
CONTPARAM14= 1
iniwrite,%uFLU%,skopt.cfg,GLOBAL,update_file
return

IALTH:
gui,submit,nohide
guicontrolget,IALTH,,IALTH
if (IALTH = "")
	{
		iniread,IALTHv,sets\arcorg.set,GLOBAL,ALTHOST
		if ((IALTHv = "")or(IALTHv = "ERROR"))
			{	
				IALTHv= 
				guicontrol,,IALTH,%IALTHv%
			}
		IALTH= %IALTHv%
		IniWrite,%IALTH%,skopt.cfg,GLOBAL,alt_host
		CONTPARAM21= 1
		return	
	}
if (IALTH = "")
	{
		IALTH= %GITWEB%/romjacket
	}
IniWrite,%IALTH%,skopt.cfg,GLOBAL,alt_host
guicontrol,,IALTH,%IALTH%
CONTPARAM21= 1
return

DREPO:
gui,submit,nohide
guicontrolget,DREPO,,DREPO
IniWrite,%DREPO%,skopt.cfg,GLOBAL,dat_hub
if (DREPO = "")
	{
		RREPO= skeletonkey
		IniWrite,%DREPO%,skopt.cfg,GLOBAL,dat_hub
		CONTPARAM23= 1
	}
CONTPARAM23= 1
return

RREPO:
gui,submit,nohide
guicontrolget,RREPO,,RREPO
IniWrite,%RREPO%,skopt.cfg,GLOBAL,repo_hub
if (RREPO = "")
	{
		RREPO= repo_hub
		IniWrite,%RREPO%,skopt.cfg,GLOBAL,repo_hub
		CONTPARAM22= 1
	}
CONTPARAM22= 1
return

IREPO:
gui,submit,nohide
guicontrolget,IREPO,,IREPO
iniread,IREPOv,sets\arcorg.set,GLOBAL,HOSTINGURL
if (IREPO = "")
	{
		if (GITUSER = "")
			{
				SB_SetText("username is not defined.")
				guicontrol,,IREPO,%IREPOv%
				reponum1= 
				reponum2= 
				reponum3= 
				reponum4= 
				iniread,ALTHv,sets\arcorg.set,GLOBAL,ALTHOST
				stringsplit,reponum,ALTHv,>
				if (reponum2 <> "")
					{
						ALTHOST= %reponum2%
					}
				if (ALTHOST = "")
					{
						ALTHOST= %GITWEB%/jomracket
					}
				IniWrite,%reponum1%,skopt.cfg,GLOBAL,repository_url
				IniWrite,%ALTHOST%,skopt.cfg,GLOBAL,alt_host
				CONTPARAM16= 1
				CONTPARAM21= 1
				return
			}
		IREPO= %GITSWEB%/%gituser%
		if (reponum2 <> "")
			{
				ALTHOST= %reponum2%
			}
		if (ALTHOST = "")
			{
				ALTHOST= %GITWEB%/jomracket
			}
		guicontrol,,IREPO,%IREPO%
		IniWrite,%ALTHOST%,skopt.cfg,GLOBAL,alt_host
		CONTPARAM21= 1
	}
CONTPARAM16= 1
IniWrite,%IREPO%,skopt.cfg,GLOBAL,repository_url
return

RepoUrl:
gui,submit,nohide
REPOURL= 
UPDTFILE= %GITWEB%/%GITUSER%/skeletonKey/releases/download/nodats
if (REPORURLT = "")
	{
		iniread,REPOURLT,sets\arcorg.set,GLOBAL,HOSTINGURL
		UPDTFILE= %REPORULT%/skeletonKey/releases/download/nodats
	}
inputbox,REPOURL,Repository-URL,Enter the base-url of the file-repository,,345,140,,,,,%REPOURLT%
if (REPOURL = "")
	{
		REPOURL= %REPOURLT%
		UPDTFILE= %UPDTFILE%
	}
IniWrite,%REPOURL%,skopt.cfg,GLOBAL,repository_url
return

UVER:
gui,submit,nohide
guicontrolget,UVER,,UVER
if (UVER = "")
	{
		UVER= http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/site/version.txt
	}
if (GITUSER = "")
	{
		UVER= http://raw.githubusercontent.com/romjacket/skeletonkey/master/site/version.txt
	}
guicontrol,,UVER,%UVER%
CONTPARAM13= 1
iniwrite,%UVER%,skopt.cfg,GLOBAL,update_url
return

SelGPD:
gui,submit,nohide
GitRoot:
CONTPARAM8= 
gitrttmp= %A_MyDocuments%
ifexist,%gitrttmp%\GitHub
	{
		gitrttmp= %A_MyDocuments%\GitHub
	}
FileSelectFolder, GITROOTT,*%gitrttmp% ,1,Select The GitHub Root Directory (contains all projects)
if (GITROOTT = "")
	{
		inidelete,skopt.cfg,GLOBAL,Git_Root
		guicontrol,,txtGPD, (not set) Github-Projects-Directory
		CONTPARAM8=
		return
	}
GITROOT:= GITROOTT
splitpath,GITROOTT,GITROOTTFN
ifnotinstring,GITROOTTFN,GitHub
	{
		Loop, %GITROOTT%\*,2
			{
				ifinstring,A_LoopFilename,GitHub
					{
						GITROOTT= %A_LoopFileFullPath%
						GITROOT:= GITROOTT
						iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
						SB_SetText("Github dir is " GITROOT " ")
						CONTPARAM8= 1
						guicontrol,,txtGPD,%GITROOT%
						return
					}
			}
		Msgbox,3,Github Directory not found,A ''github'' directory was not found.`nWould you like to create it?
		ifmsgbox,Yes
			{
				filecreatedir, %GITROOTT%\GitHub
				if (ERRORLEVEL = 0)
					{
						GITROOTT= %GITROOTT%\GitHub
						GITROOT:= GITROOTT
					}
			}
		iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
		SB_SetText("Github dir is " GITROOT " ")
		CONTPARAM8= 1
		guicontrol,,txtGPD,%GITROOT%
		return			
	}
CONTPARAM8= 1
guicontrol,,txtGPD,%GITROOT%
iniwrite, %GITROOT%,skopt.cfg,GLOBAL,Git_Root
SB_SetText("Github dir is " GITROOT " ")
return

SelGWD:
GetSiteDir:
if (GITUSER = "")
	{
		SB_SetText("username is not defined")
		guicontrol,focus,ILogin
		return
	}
if (GITPASS = "")
	{
		SB_SetText("password is not defined")
		guicontrol,focus,IPass
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source-directory is not defined")
		return
	}
if (BUILDIR = "")
	{
		SB_SetText("Build-directory is not defined")
		return
	}
if (GITAPP = "")
	{
		SB_SetText("Git.exe is not defined")
		return
	}
if (GITROOT = "")
	{
		SB_SetText("Github-projects-directory is not defined")
		return
	}
gui,submit,nohide
SB_SetText("Usually ..\ " gitroot "\" gituser ".github.io\skeletonkey")
CONTPARAM11= 
if (GITROOT = "")
	{
		inidelete,skopt.cfg,GLOBAL,site_directory
		SB_SetText("GitHub Projects Directory not defined.")
		guicontrol,,txtGWD,(not set) Github-Site-Directory
		return
	}
SITEDIR=
STLOCT=
STLOCtmp= %GITROOT%
FileSelectFolder, STLOCT,*%STLOCtmp%,1,Select The WebSite skeletonkey html Directory.
if (STLOCT = "")
	{
		guicontrol,,txtGWD,(not set) Github-Site-Directory
		CONTPARAM11= 
		inidelete,skopt.cfg,GLOBAL,Site_Directory
		return
	}
webdx= 
splitpath,STLOCT,stlocn,stlocp
ifinstring,stlocp,.github.io
	{
		if (stlocn = "skeletonkey")
			{
				SITEDIR= %STLOCT%
			}
		else {
			ifinstring,stloct,.github.io
				{
					Loop,files,%STLOCT%\*,2
						{
							if (A_LoopFilename = "skeletonkey")
								{
									SITEDIR= %A_LoopFileFullPath%
								}
						}
				}
			}
	}
if (SITEDIR = "")
	{
		msgbox,3,Clone,Would you like to clone the skeletonkey website?
		ifmsgbox,yes
			{
				gosub, PULLIO
			}
	}

ifnotexist, %GITROOT%\%gituser%.github.io\skeletonkey\
	{
		Msgbox,3,SetUp Github Site,Would you like to copy the source's site to your github projects?
		ifmsgbox,Yes
			{
				filecreatedir,%GITROOT%\%gituser%.github.io\skeletonkey
				SITEDIR= %GITROOT%\%gituser%.github.io\skeletonkey
				FileCopyDir,%SKELD%\site,%GITROOT%\%gituser%.github.io\skeletonkey,1
			}
		ifmsgbox,No
			{
				CONTPARAM11= 
				SITEDIR= 
				guicontrol,,txtGWD,(not set) Github-Site-Directory
				inidelete,skopt.cfg,GLOBAL,site_directory
				return
			}
	}	
iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
CONTPARAM11= 1
;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.email "%GITMAIL%",,hide
;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.name "%GITUSER%",,hide
;;RunWait,"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"%gituser%.github.io\`"}`",,hide

FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"%gituser%.github.io"}",gitinit.cmd
RunWait,gitinit.cmd,,hide
FileDelete,gitinit.cmd
				

guicontrol,,txtGWD,%SITEDIR%
return


SelDPL:
gui,submit,nohide
SB_SetText("The directory in which binaries are compiled token.")
GetDepl:
CONTPARAM12= 
DEPL=
depltmp= %A_MyDocuments%
ifexist, %GITROOT%
	{
		depltmp= %GITROOT%
	}
FileSelectFolder, DEPLT,*%depltmp% ,1,Select The Deployment Directory
if (DEPLT = "")
	{
		guicontrol,,txtDPL,(not set) Deployment-Directory
		CONTPARAM12=
		inidelete,skopt.cfg,GLOBAL,Deployment_Directory
		return
	}
splitpath,DEPLT,depln
ifnotinstring,depln,.deploy
	{
		Loop, %DEPLT%\*,2
			{
				ifinstring,A_LoopFileName,skeletonkey.deploy
					{
						DEPLT= %A_LoopFileFullPath%
						DEPL= %DEPLT%
						iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
						CONTPARAM12= 1
						guicontrol,,txtDPL,%DEPL%
						return
					}
			}
	}
DEPL= %DEPLT%
splitpath,DEPLT,depln
if (DEPLN <> "skeletonkey.deploy")
	{
		DEPL= %DEPLT%\skeletonkey.deploy
		filecreatedir,%DEPL%
	}
ifnotexist,%DEPL%\
	{
		inidelete,skopt.cfg,GLOBAL,Deployment_Directory
		guicontrol,,txtDPL,(not set) Deployment-Directory
		CONTPARAM12= 
		return
	}
iniwrite,%DEPL%,skopt.cfg,GLOBAL,Deployment_Directory
CONTPARAM12= 1
guicontrol,,txtDPL,%DEPL%
return

SelAHK:
gui,submit,nohide
GetComp:
CONTPARAM7= 
ifexist, %A_MyDocuments%\AutoHotkey\Compiler\
	{
		comptmp= %A_MyDocuments%\AutoHotkey\Compiler
	}
ifexist, %rpfs%\AutoHotkey\Compiler\
	{
		comptmp= %rpfs%\AutoHotkey\Compiler
	}
FileSelectFile, AHKDIT,3,%comptmp%\Ahk2Exe.exe,Select AHK2Exe,*.exe
if (AHKDIT = "")
	{
		guicontrol,,txtAHK,(not set) Ahk2exe.exe
		CONTPARAM7= 
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		return
	}
splitpath,AHKDIT,,AHKDIR
CONTPARAM7= 1
iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
guicontrol,,txtAHK,%AHKDIR%\Ahk2Exe.exe
return

SelBld:
gui,submit,nohide
CONTPARAM17= 
FileSelectFolder, BUILDT,*%A_ScriptDir% ,1,Select The BUILD Directory
if (BUILDT = "")
	{
		CONTPARAM17= 
		guicontrol,,txtBld,(not set) Build-Directory
		inidelete,skopt.cfg,GLOBAL,BUILD_Directory
		return
	}
splitpath,BUILDT,BUILDTFN
BUILDIR:= BUILDT
CONTPARAM17= 1
guicontrol,,txtBLD,%BUILDIR%
iniwrite, %BUILDIR%,skopt.cfg,GLOBAL,BUILD_Directory
if (SKELD = GITD)
	{
		SB_SetText(It is recommended to keep your BUILD and github directories separate)
	}
return

SelSRC:
gui,submit,nohide
SB_SetText("Usually the current directory")
CONTPARAM9= 
GetSrc:
FileSelectFolder, SKELT,*%A_ScriptDir% ,1,Select The Source Directory
if (SKELT = "")
	{
		CONTPARAM9= 
		guicontrol,,txtBLD,(not set) Source Directory
		inidelete,skopt.cfg,GLOBAL,Source_Directory
		return
	}
splitpath,SKELT,SKELTFN
if (SKELTFN = "skeletonkey")
	{
		skelexists= 1
	}
Loop, %SKELT%\working.ahk
	{
		skelexists= 1
	}
if (skelexists = 1)
	{
		SKELD:= SKELT
		CONTPARAM9= 1
		guicontrol,,txtSRC,%SKELD%
		iniwrite, %SKELD%,skopt.cfg,GLOBAL,Source_Directory
		if (SKELD = GITD)
			{
				SB_SetText(It is recommended to keep your source and github directories separate)
			}
		if (BUILDIR = "")
			{
				BUILDIR= %SKELD%
				guicontrol,,txtBLD,%SKELD%
				iniwrite,%BUILDIR%,skopt.cfg,GLOBAL,BUILD_Directory
				CONTPARAM17= 1
			}
		return
	}	
Msgbox,3,Not-Found,Skeletonkey was not found.`nRetry?
ifmsgbox,Yes
	{
		goto,SelSRC
	}
CONTPARAM9= 
guicontrol,,txtSRC,(not set) Source Directory
inidelete,skopt.cfg,GLOBAL,Source_Directory
CONTPARAM9= 
return

IToken:
gui,submit,nohide
guicontrolget,GITPAT,,IToken
CONTPARAM3= 
if (GITPAT <> "")
	{
		CONTPARAM3= 1
		iniwrite, %GITPAT%,skopt.cfg,GLOBAL,git_token
		return
	}
inidelete,skopt.cfg,GLOBAL,git_token
return

GetGPAC:
GITPATT= 
envGet, GITPATT, GITHUB_TOKEN
InputBox, GITPATT , Git-PAC, Input your git token, , 230, 140, , , ,,%GITPATT%
if (GITPAT <> "")
	{
		if (GITPATT = "")
			{
				envGet, GITPATT, GITHUB_TOKEN
				SB_SetText(" Git Access token is " GITPAT " ")
			}
	}
GITPAT= %GITPATT%	
iniwrite, %GITPAT%,skopt.cfg,GLOBAL,git_token
SB_SetText(" Git Access token is " GITPAT " ")
return


IPass:
gui,submit,nohide
guicontrolget,GITPASS,,IPass
CONTPARAM2= 
if (GITPASS <> "")
	{
		CONTPARAM2= 1
		iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
		return
	}
inidelete,skopt.cfg,GLOBAL,Git_password
return

GetGPass:
InputBox, GITPASST , Git-Password, Input your github password,HIDE , 180, 140, , , ,, %GITPASST%
if (GITPASS <> "")
	{
		if (GITPASST = "")
			{
				GITPASST= *******
				SB_SetText(" Git Password is " ******* " ")
			}
	}
GITPASS= %GITPASST%	
iniwrite, %GITPASS%,skopt.cfg,GLOBAL,Git_password
return

GetGUSR:
GITUSERT= 
InputBox, GITUSERT , Git-Username, Input your git username, , 180, 140, , , ,, %a_username%
if (GITUSER <> "")
	{
		if (GITUSERT = "")
			{
				SB_SetText(" Git Username is " GITUSER " ")
				return
			}
	}
GITUSER= %GITUSERT%	
iniwrite, %GITUSER%,skopt.cfg,GLOBAL,Git_username
return


SelRls:
gui,submit,nohide
CONTPARAM5= 
GetRls:
GITRLST=
grltmp= %GITAPPD%
FileSelectFile,GITRLST,3,%grltmp%\github-release.exe,Select github-release,*.exe
GITRLST:
if (GITRLST = "")
	{
		grltmp= 
		guicontrol,,TxtGit,(not set) Github-release.exe
		CONTPARAM5= 
		return
	}
GITRLS= %GITRLST%
iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
CONTPARAM5= 1
SB_SetText(" Github Release is " GITRLS "")
return

getSCI:
gui,submit,nohide
SCIRT=
FileSelectFile,SCIRT,3,%scitmp%,Select SciTE,*.exe
if (SCIRT = "")
	{
		return
	}
SCITL= %SCIRT%
iniwrite,%SCITL%,skopt.cfg,GLOBAL,SciTE4AutoHotkey
SB_SetText(" SciTE4AutoHotkey " SCITL "")
return


SelNSIS:
gui,submit,nohide
CONTPARAM6= 
ifexist, %A_MyDocuments%\NSIS
	{
		nsisapdtmp= %A_MyDocuments%\NSIS
	}
ifexist, %rpfs%\NSIS
	{
		nsisapdtmp= %rpfs%\NSIS
	}
ifnotexist, %nsisapdtmp%
	{
		nsisapdtmp= 
	}
FileSelectFile, NSIST,3,%nsisapdtmp%\makensis.exe,Select the makensis.exe,*.exe
nsisapptmp= 
if (NSIST = "")
	{
		CONTPARAM6= 
		guicontrol,,txtNSIS,(not set) makensis.exe
		inidelete,skopt.cfg,GLOBAL,NSIS
		return
	}
NSIS= %NSIST%
splitpath, NSIS,,nsisappd
iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
guicontrol,,txtNSIS,%NSIS%
CONTPARAM6= 1
return


SelGit:
gui,submit,nohide
GetAPP:
CONTPARAM4= 
gitapdtmp=
ifexist, %rpfs%\git\bin\git.exe
	{
		gitapdtmp= %rpfs%\git\bin
	}
ifexist, %A_MyDocuments%\Git\bin\git.exe
	{
		gitapdtmp= %A_MyDocuments%\Git\Bin
	}
FileSelectFile, GITAPPT,3,%gitapdtmp%\git.exe,Select the git.exe,*.exe
gitapptmp= 
if (GITAPPT = "")
	{
		CONTPARAM3= 
		guicontrol,,txtGIT,(not set) git.exe
		inidelete,skopt.cfg,GLOBAL,git_app
		return
	}
GITAPP= %GITAPPT%
CONTPARAM4= 1
splitpath, gitapp,,gitappd
iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
guicontrol,,txtGIT,%GITAPP%
return

SelGSD:
gui,submit,nohide
CONTPARAM10= 
CONTPARAM18= 
gittmp= %gitroot%\skeletonkey
if (GITUSER = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (GITPASS = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source-directory is not defined")
		return
	}
if (BUILDIR = "")
	{
		SB_SetText("Build-directory is not defined")
		return
	}
if (GITAPP = "")
	{
		SB_SetText("Git.exe is not defined")
		return
	}
if (GITROOT = "")
	{
		SB_SetText("Github-projects-directory is not defined")
		return
	}
GetGit:
GITT= 
ifnotexist, %gittmp%
	{
		gittmp= 
	}
FileSelectFolder,GITT,*%gittmp%,1,Select The Git skeletonKey Project Directory.
if (GITT = "")
	{
		return
	}
Loop, %GITT%\*,2
	{
		if (A_LoopFileName = "skeletonKey")
			{
				GITT= %A_LoopFileFullPath%
				break
			}
	}	
splitpath,gitt,gittn
if (gittn <> "skeletonKey")
	{
		SB_SetText("Github SkeletonKey directory not found")
		CONTPARAM10= 
		CONTPARAM18= 
		msgbox,3,Clone,Would you like to clone skeletonkey from github?
		ifmsgbox,yes
			{
				goto, PULLSKEL
			}
		return
	}
if ((GITT = BUILDIR)or(GITT = SKELD))
	{
		SB_SetText("Github SkeletonKey project directory should not be your source or build directories")
	}
GITD:= GITT
GITSRC= %GITWEB%/%gituser%/skeletonkey
iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
CONTPARAM10= 1
CONTPARAM18= 1
FileDelete, %BUILDIR%\gitcommit.bat
FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\gitcommit.bat
FileAppend,pushd "%GITD%"`n,%BUILDIR%\gitcommit.bat
FileAppend,"`%gitapp`%" add .`n,%BUILDIR%\gitcommit.bat
FileAppend,"`%gitapp`%" commit -m `%1`%.`n,%BUILDIR%\gitcommit.bat
if (GITPASS <> "")
	{
		FileAppend,"`%gitapp`%" push --repo http://%gituser%:%GITPASS%@github.com/%gituser%/skeletonkey`n,%BUILDIR%\gitcommit.bat			
	}
if (GITPASS = "")
	{
		FileAppend,"`%gitapp`%" push origin master`n,%BUILDIR%\gitcommit.bat			
	}
guicontrol,,txtGSD,%GITD%	
return
;{;;;;;;;;;;;;;;;;;;;;;;;;;;   DOWNLOAD APPS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DwnRls:
gui,submit,nohide
CONTPARAM5= 
iniread,GRLURL,sets\BuildTools.set,BUILDENV,Github_Release_%ARCH%
splitpath,GRLURL,grlfn
grlsv= %cacheloc%\%grlfn%
ifnotexist,%grlsv%
	{
		splitpath,gitapp,,gitappd
		grltmp= %GITAPPD%
		SETUPTOG= disable
		gosub, SETUPTOG
		splitpath,grlsv,svaf,svap
		exe_get(ARIA,GRLURL,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(GRLURL, grlsv, False, True)
		SETUPTOG= enable
		gosub, SETUPTOG
		sleep, 1200
		ifnotexist,%grlsv%
			{
				Msgbox,3,Not Found,%grlsv% not found.`nRETRY?
				ifmsgbox,Yes
					{
						goto,DwnRls
					}
			}
	}
ifnotexist, %grlsv%
	{
		inidelete,skopt.cfg,GLOBAL,git_rls
		CONTPARAM5= 
		return
	}
GRLK=
GRLL=
grltmp= %GITAPPD%
if (autoinstall = 1)
	{
		GRLL= %grltmp%
		goto, GRLLSEL
	}
FileselectFolder,GRLL,*%grltmp%,0,Location to extract Github-release.exe
GRLLSEL:
if (GRLL = "")
	{
		inidelete,skopt.cfg,GLOBAL,git_rls
		CONTPARAM5= 
		guicontrol,,TxtGit,(not set) Github-release.exe
		return
	}
SETUPTOG= disable
gosub, SETUPTOG
SB_SetText(" Extracting github-release to " GITRLS "")
Runwait, "bin\7za.exe" x -y "%grlsv%" -O"%GRLL%",,%rntp%
SETUPTOG= enable
gosub, SETUPTOG

GITRLS= %GRLL%\github-release.exe
iniwrite, %GITRLS%,skopt.cfg,GLOBAL,git_rls
guicontrol,,TxtRLS,%GITRLS%
CONTPARAM5= 1
SB_SetText(" Github-release is " GITRLS "")
return

DwnNSIS:
gui,submit,nohide
CONTPARAM6= 
GetNSIS:
iniread,nsisurl,sets\BuildTools.set,BUILDENV,NSIS
splitpath,nsisurl,nsisf
nsisv= %cacheloc%\%nsisf%
ifnotexist, %cacheloc%\%nsisf%
	{				
		
		SETUPTOG= disable
		gosub, SETUPTOG
		splitpath,nsisv,svaf,svap
		exe_get(ARIA,nsisurl,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(nsisurl, nsisv, False, True)
		SETUPTOG= enable
		gosub, SETUPTOG
		sleep, 1200
	}
ifnotexist, %nsisv%
	{
		gitapdtmp= 
		Msgbox,3,not found,%nsisv% not found.`nRETRY?
		ifmsgbox,yes
			{
				goto, getNSIS
			}
		inidelete,skopt.cfg,GLOBAL,NSIS
		guicontrol,,txtNSIS,(not set) makensis.exe
		CONTPARAM6= 
		return
	}
NSISD= 
NSISDT= 
NSIS= 
NSISDT= %A_MyDocuments%
if (autoinstall = 1)
	{
		NSIST= %NSISDT%
		goto, NSISTSEL
	}
FileSelectFolder, NSIST,*%NSISDT%,0,Location to extract the NSIS programs.
if (NSIST = "")
	{
		inidelete,skopt.cfg,GLOBAL,NSIS
		guicontrol,,txtNSIS,(not set) makensis.exe
		CONTPARAM6= 
		return
	}
NSISTSEL:	
SB_SetText("extracting nsis to " NSIS " ")
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "bin\7za.exe" x -y "%nsisv%" -O"%NSIST%",,%rntp%
SETUPTOG= enable
gosub, SETUPTOG
Loop,%NSIST%\*makensis.exe,0,1
	{		
		NSIS= %A_LoopFileFullPath%
		break
	}
iniwrite, %NSIS%,skopt.cfg,GLOBAL,NSIS
SB_SetText("makensis.exe is " NSIS " ")
guicontrol,,txtNSIS,%NSIS%
CONTPARAM6= 1
return

DwnSCI:
iniread,SCIURL,sets\BuildTools.set,BUILDENV,SciTE4AutoHotkey
splitpath,SCIURL,scifn
scisv= %cacheloc%\%scifn%
ifnotexist,%scisv%
	{
		scitmp= %A_MyDocuments%
		SETUPTOG= disable
		gosub, SETUPTOG
		splitpath,scisv,svaf,svap
		exe_get(ARIA,SCIURL,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(SCIURL, scisv, False, True)
		SETUPTOG= enable
		gosub, SETUPTOG
		sleep, 1200
	}
ifnotexist,%scisv%
	{
		scitmp= 
		Msgbox,3,Not Found,%scisv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				gosub,DwnSCI
			}
		return
	}
SCIK=
SCIL=
scitmp= %A_myDocuments%
FileselectFolder,SCIL,*%scitmp%,0,Location to extract SciTE4AutoHotkey
if (SCIL = "")
	{
		guicontrol,,txtRLS,Github-Release.exe
		CONTPARAM4= 
		return
	}
SB_SetText(" Extracting scite to " SCITL "")
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "bin\7za.exe" x -y "%scisv%" -O"%SCIL%",,%rntp%
SETUPTOG= enable
gosub, SETUPTOG
SCITL= %SCIL%\SciTE.exe
iniwrite,%SCITL%,skopt.cfg,GLOBAL,SciTE4AutoHotKey
SB_SetText(" SciTE4AutoHotkey is " SCITL "")
guicontrol,,txtRLS,%SCITL%
CONTPARAM4= 
return


DwnGit:
gui,submit,nohide
GetGITZ:
CONTPARAM4= 
iniread,gitzurl,sets\BuildTools.set,BUILDENV,GIT_%ARCH%
splitpath,gitzurl,gitzf
gitzsv= %cacheloc%\%gitzf%
gitapdtmp= %A_MyDocuments%
ifnotexist, %gitzsv%
	{
		SETUPTOG= disable
		gosub, SETUPTOG
		splitpath,gitzsv,svaf,svap
		exe_get(ARIA,gitzurl,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(gitzurl, gitzsv, False, True)
		SETUPTOG= enable
		gosub, SETUPTOG
		sleep, 1200
	}
ifexist, %gitzsv%
	{
		GITAPP= 
		GITAPPT=
		if (autoinstall = 1)
			{
				GITAPPT= %gitapdtmp%
				goto, GITZSL
			}
		FileSelectFolder, GITAPPT,*%gitapdtmp%,0,Location to extract the Git programs.
		GITZSL:
		ifinstring,GITAPPT,git
			{
				splitpath,GITAPPT,,gitappdt
				GITAPPT= %gitappdt%
			}
		if (GITAPPT = "")
			{
				gitapdtmp= 
				return
			}
		GITAPPT.= "\Git"
		SB_SetText(" Extracting Git to " GITAPPT "")
		SETUPTOG= disable
		gosub, SETUPTOG
		Runwait, "bin\7za.exe" x -y "%gitzsv%" -O"%GITAPPT%",,%rntp%
		SETUPTOG= enable
		gosub, SETUPTOG
		GITAPP= %GITAPPT%\bin\Git.exe
		splitpath, gitapp,,gitappd
		guicontrol,,txtGIT,%GITAPP%
		CONTPARAM4= 1
		iniwrite, %GITAPP%,skopt.cfg,GLOBAL,git_app
		return
	}
gitapdtmp= 
Msgbox,3,not found,%gitzsv% not found.`nRETRY?
ifmsgbox,yes
	{
		gosub, getGitz
	}	
return


DwnAHK:
gui,submit,nohide
GetAHKZ:
CONTPARAM7= 
iniread,AHKURL,sets\BuildTools.set,BUILDENV,AutoHotkey
splitpath,AHKURL,ahksvf
ahksv= %cacheloc%\%ahksvf%
ifnotexist, %ahksv%
	{
		ahktmp= %A_MyDocuments%
		SETUPTOG= disable
		gosub, SETUPTOG
		splitpath,ahksv,svaf,svap
		exe_get(ARIA,AHKURL,svap,svaf,CURPID,cacheloc)
		;;DownloadFile(AHKURL, ahksv, False, True)
		SETUPTOG= enable
		gosub, SETUPTOG
		sleep, 1200
	}
ifnotexist, %ahksv%
	{
		ahktmp= 
		Msgbox,3,Not Found,%ahksv% not found.`nRETRY?
		ifmsgbox,Yes
			{
				goto,GetAHKZ
			}
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		CONTPARARM7= 
		guicontrol,,txtAHK,(not set) Ahk2Exe.exe
		return
	}
AHKDIR= 
ahktmp= %A_MyDocuments%
if (autoinstall = 1)
	{
		AHKDIT= %ahktmp%
		goto, AHKDITSL
	}
FileSelectFolder, AHKDIT,*%ahktmp%,0,Location to extract the AutoHotkey Programs.
if (AHKDIT = "")
	{
		inidelete,skopt.cfg,GLOBAL,Compiler_Directory
		CONTPARARM7= 
		guicontrol,,txtAHK,(not set) Ahk2Exe.exe
		return
	}
AHKDITSL:
splitpath,AHKDIT,ahktstn
ifnotinstring,ahktstn,AutoHotkey
	{
		AHKDIT.= "\AutoHotKey"
	}
SB_SetText("Extacting to " AHKDIR " ")
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "bin\7za.exe" x -y "%ahksv%" -O"%AHKDIT%",,%rntp%
SETUPTOG= enable
gosub, SETUPTOG
AHKDIR= %AHKDIT%\Compiler
iniwrite, %AHKDIR%,skopt.cfg,GLOBAL,Compiler_Directory
CONTPARAM7= 1
SB_SetText("AutoHotkey Compiler Directory is " AHKDIR " ")
guicontrol,,txtAHK,%AHKDIR%\Ahk2Exe.exe
return
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;};;;;;;;;;;;;;;;;;;;;;;;;;;;;


;{;;;;;;;;;;;;;;;;;;;;;;;;;  CLONE REPOS  ;;;;;;;;;;;;;;;;;;;;;;;
RESGET:
guicontrolget,SRCDD,,SRCDD
if (SRCDD = "Project")
	{
		goto, Clone
	}
if (SRCDD = "Git.exe")
	{
		gitapdtmp= %A_MyDocuments%	
		goto, GetGITZ
	}
if (SRCDD = "github-release")
	{
		goto, GetRls
	}
if (SRCDD = "Site")
	{
		STLOCtmp= %GITROOT%
		ifexist, %GITROOT%\%gituser%.github.io
			{
				filemovedir,%GITROOT%\%gituser%.github.io\skeletonkey,%GITROOT%\%gituser%.skeletonkey.old,1
			}
		goto, GetSiteDir
	}
if (SRCDD = "SciTE4AutoHotkey")
	{
		goto, DwnSCI
	}
if (SRCDD = "Compiler")
	{
		goto, GetAHKZ
	}
if (SRCDD = "NSIS")
	{
		nsitmp= %A_MyDocuments%
		nstmp= %A_MyDocuments%\makensis.exe
		ifexist, %ProgramFilesX86%\NSIS
			{
				nstimp= %ProgramFilesX86%\NSIS
				nstmp= %ProgramFilesX86%\NSIS\makensis.exe
			}
		ifexist, %A_MyDocuments%\NSIS
			{
				nsitmp= %A_MyDocuments%\NSIS
				nstmp= %A_MyDocuments%\NSIS\makensis.exe
			}
		goto, SelNSIS
	}
return
PULLSKEL:
gui,submit,nohide
av= 
if (gitapp = "")
	{
		SB_SetText("git.exe is not located")
		return
	}
if (BUILDIR = "")
	{
		SB_SetText("Build-Directory is not defined")
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source Directory is not defined")
		return
	}
if (gituser = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (gitpass = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (gitroot = "")
	{
		SB_SetText("github project directory is not defined")
		return
	}
SETUPTOG= disable
gosub, SETUPTOG
SB_SetText("Cloning skeletonkey")
Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/%GITUSER%/skeletonKey,%GITROOT%,hide
SB_SetText("")
gcle= %ERRORLEVEL%
SETUPTOG= enable
gosub, SETUPTOG
Loop, %GITROOT%\skeletonKey\*.*
	{
		av+=1
		break
	}
if ((av = "")or(gcle <> 0))
	{
		initskel= 1
		CONTPARAM10= 
		CONTPARAM18= 
		FileSetAttrib, -h,.git
		FileRemoveDir,%GITROOT%\skeletonkey,1
		if (autoinstall = 1)
			{
				goto, clonerj
			}
		Msgbox,3,SetUp Github Project,Would you like to clone romjacket's skeletonkey?
		ifmsgbox,yes
			{				
				gosub, clonerj
			}
		ifmsgbox,no
			{
				Msgbox,3,SetUp Github Project,Would you like to copy the build directory to your github projects?
				ifmsgbox,Yes
					{
						filecreatedir,%GITROOT%\skeletonkey
						FileCopyDir,%SKELD%,%GITROOT%\skeletonkey,1
					}
				ifmsgbox,No
					{
						guicontrol,,txtGSD,(not set) Github-Skeletonkey-Directory
						inidelete,skopt.cfg,GLOBAL,git_url
						inidelete,skopt.cfg,GLOBAL,Project_Directory
						return
					}
			}
	}
confirmSkelClone:	
ifexist,%GITROOT%\skeletonkey\
	{
		GitSRC= %GITWEB%/%gituser%/skeletonkey
		GITD= %GITROOT%\skeletonkey
		CONTPARAM10= 1
		CONTPARAM18= 1
		
		;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\skeletonkey,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" config user.email %GITMAIL%,,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" config user.name %GITUSER%,,hide
		;;RunWait, "bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"skeletonkey\`"}`",,hide
		
		FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"%gituser%.github.io"}",gitinit.cmd
		RunWait,gitinit.cmd,,hide
		FileDelete,gitinit.cmd
				
		guicontrol,,txtGSD,%GITD%
		IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
		iniwrite, %GITD%,skopt.cfg,GLOBAL,Project_Directory
	}
return	

PULLIO:
if (gitapp = "")
	{
		SB_SetText("git.exe is not located")
		return
	}
if (SKELD = "")
	{
		SB_SetText("Source Directory is not defined")
		return
	}
if (gituser = "")
	{
		SB_SetText("username is not defined")
		return
	}
if (gitpass = "")
	{
		SB_SetText("password is not defined")
		return
	}
if (gitroot = "")
	{
		SB_SetText("github project directory is not defined")
		return
	}
SB_SetText("Cloning website")	
ifnotexist, %GITROOT%\%GITUSER%.github.io
	{
		av= 
		SETUPTOG= disable
		gosub, SETUPTOG
		Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/%GITUSER%/%GITUSER%.github.io,%GITROOT%,hide
		SB_SetText("")
		gwde= %ERRORLEVEL%
		SETUPTOG= enable
		gosub, SETUPTOG
		Loop, %GITROOT%\%GITUSER%.github.io\*.*
			{
				av+=1
			}
		if ((av = "")or(gwde <> 0))
			{
				initweb= 1
				FileSetAttrib,-h,%GITUSER%.github.io\.git
				FileRemoveDir,%GITROOT%\%GITUSER%.github.io\skeletonkey,1
				Msgbox,3,SetUp Github Project,Would you like to clone romjacket's site?
				ifmsgbox,yes
					{
						gosub, Cloneio
					}
				ifmsgbox,no
					{
						Msgbox,3,SetUp Github Site,Would you like to copy the source's site to your github projects?
						ifmsgbox,Yes
							{
								filecreatedir,%GITROOT%\%gituser%.github.io\skeletonkey
								FileCopyDir,%SKELD%\site,%GITROOT%\%gituser%.github.io\skeletonkey,1
							}
						ifmsgbox,No
							{
								CONTPARAM11= 
								guicontrol,,txtGWD,(not set) Github-Site-Directory
								inidelete,skopt.cfg,GLOBAL,site_directory
								return
							}
					}
			}
	}
completeSkelIO:	
ifexist,%GITROOT%\%gituser%.github.io\skeletonkey\
	{
		SITEDIR= %GITROOT%\%gituser%.github.io\skeletonkey
		CONTPARAM11= 1	
		;;RunWait, %comspec% cmd /c "%gitapp%" config user.email %GITMAIL%,,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" config user.name %GITUSER%,,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide	
		;;RunWait,"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"%gituser%.github.io\`"}`",,hide

		FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"%gituser%.github.io"}",gitinit.cmd
		RunWait,gitinit.cmd,,hide
		FileDelete,gitinit.cmd
		
		guicontrol,,txtGWD,%SITEDIR%
		iniwrite, %SITEDIR%,skopt.cfg,GLOBAL,Site_Directory
		return
	}
Msgbox,3,Skeletonkey Directory Not Found,Skeletonkey Directory not found.`nCopy the source site to your github site directory?
ifmsgbox,yes
	{
		filecreatedir,%GITROOT%\%gituser%.github.io\skeletonkey
		FileCopyDir,%SKELD%\site,%GITROOT%\%gituser%.github.io\skeletonkey,1
	}
return

Clonerj:
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/romjacket/skeletonkey,%GITROOT%,hide
if (ERRORLEVEL <> 0)
	{
		msgbox,0,ERROR,Could not clone skeletonkey from romjacket
		guicontrol,,txtGSD,(not set) Github-Skeletonkey-Directory
		inidelete,skopt.cfg,GLOBAL,git_url
		inidelete,skopt.cfg,GLOBAL,Project_Directory
		SETUPTOG= enable
		gosub, SETUPTOG
		return
	}
SETUPTOG= enable
gosub, SETUPTOG
return

Cloneio:
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/romjacket/romjacket.github.io,%GITROOT%,hide
SB_SetText("")
if (ERRORLEVEL <> 0)
	{
		msgbox,0,ERROR,Could not clone romjacket.github.io
		guicontrol,,txt,(not set) Github-Site-Directory
		CONTPARAM11= 
		SETUPTOG= enable
		gosub, SETUPTOG
		return
	}
SETUPTOG= enable
gosub, SETUPTOG
FileCopyDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%GITUSER%.github.io\skeletonkey,1
return

;{;;;;;;; glass ;;;;;;;
Clone:
gui, submit, nohide
guicontrol,disable,RESGET
guicontrol,disable,SRCDD
guicontrol,disable,SELDIR
guicontrol,disable,RESDD
guicontrol,disable,RESB
SB_SetText("Cloning current skeletonkey project")
FileCreateDir, %DEPL%
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "%gitapp%" clone %GITSRC%,%gitroot%,hide
SB_SetText("")
SETUPTOG= enable
gosub, SETUPTOG
Loop, %GITROOT%\skeletonKey\*.*
			{
				av+=1
			}
		if (av = "")
			{
				FileSetAttrib, -h,%GITUSER%.github.io\skeletonkey\.git
				FileRemoveDir,%GITROOT%\skeletonkey,1
				SETUPTOG= disable
				gosub, SETUPTOG
				Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/romjacket/skeletonkey,%GITROOT%,hide
				SB_SetText("")
				if (ERRORLEVEL <> 0)
					{
						msgbox,0,ERROR,Could not clone skeletonkey
						guicontrol,,txtGSD,(not set) Github-Skeletonkey-Directory
						inidelete,skopt.cfg,GLOBAL,Project_Directory
						CONTPARAM10= 1
						SETUPTOG= enable
						gosub, SETUPTOG
					}
				SETUPTOG= enable
				gosub, SETUPTOG
				;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\skeletonkey,hide				
				;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.email "%GITMAIL%",,hide
				;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.name "%GITUSER%",,hide
				;;RunWait,"bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"skeletonkey\`"}`",,hide
				
				FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"skeletonkey"}",gitinit.cmd
				RunWait,gitinit.cmd,,hide
				FileDelete,gitinit.cmd
				
			}
SB_SetText("Cloning current skeletonkey website")
SETUPTOG= disable
gosub, SETUPTOG
Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/%GITUSER%/%GITUSER%.github.io,%gitroot%,hide
gwde= %ERRORLEVEL%
SB_SetText("")
SETUPTOG= enable
gosub, SETUPTOG
Loop, %GITROOT%\*.*
	{
		av+=1
	}
if ((av = "")or(gwde <> 0))
	{
		FileSetAttrib, -h,%GITUSER%.github.io\.git
		FileRemoveDir,%GITROOT%\%GITUSER%.github.io,1
		SETUPTOG= disable
		gosub, SETUPTOG
		Runwait, "%gitapp%" clone https://%gituser%:%gitpass%@github.com/romjacket/romjacket.github.io,%GITROOT%,hide
		SB_SetText("")
		if (ERRORLEVEL <> 0)
			{
				MsgBox,0,ERROR,Could not clone romjacket.github.io
				CONTPARAM11= 
				guicontrol,,txtGWD,(not set) Github-Site-Directory
				inidelete,skopt.cfg,GLOBAL,site_directory
				SETUPTOG= enable
				gosub, SETUPTOG
				return
			}
		SETUPTOG= enable
		gosub, SETUPTOG
		
		;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.email "%GITMAIL%",,hide
		;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.name "%GITUSER%",,hide
		;;RunWait,"bin\curl.exe" -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"%gituser%.github.io\`"}`",,hide	
		
		FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"%gituser%.github.io"}",gitinit.cmd
		RunWait,gitinit.cmd,,hide
		FileDelete,gitinit.cmd
				
		
		FileCreateDir,%GITROOT%\%GITUSER%.github.io,1
		FileMoveDir, %GITROOT%\romjacket.github.io\skeletonkey,%GITROOT%\%GITUSER%.github.io\skeletonkey,R
	}
			
SB_SetText("Complete")
guicontrol,enable,SRCDD
guicontrol,enable,SELDIR
guicontrol,enable,RESGET
guicontrol,enable,RESDD
guicontrol,enable,RESB
return
;};;;;;;;;;;;;;;;

;};;;;;;;;;;;;;;;;;;;;;

GetBld:
BUILDIT= %BUILDIR%
ifnotexist, %bldtmp%
	{
		bldtmp= 
	}
FileSelectFolder, BUILDIT,*%bldtmp% ,1,Select The Build Directory
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
Loop,%BUILDIT%\sets\skdeploy.set
	{
		bldexists= 1
	}
if (bldexists = 1)
	{
		BUILDIR:= BUILDIT
		iniwrite, %BUILDIR%,skopt.cfg,GLOBAL,Build_Directory
		FileRead, nsiv,%BUILDIR%\sets\skdeploy.set
		StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
		StringReplace, nsiv, nsiv,[INSTYP],-installer,All
		StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
		StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
		StringReplace, nsiv, nsiv,[CURV],%vernum%,All
		FileAppend, %nsiv%,%BUILDIR%\skdeploy.nsi
		return
	}
Msgbox,3,Build Dir,Build Directory not found`nRetry?
IfMsgBox, Yes
	{
		gosub, GetBld
	}
filedelete, skopt.cfg
ExitApp

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
IniWrite,%GETIPADR%,skopt.cfg,GLOBAL,net_ip
return

UpdateURL:
gui,submit,nohide
UPDTURL= 
if (UPDTURLT = "")
	{
		UPDTURLT= http://raw.githubusercontent.com/%GITUSER%/skeletonkey/master/site/version.txt
	}
inputbox,UPDTURL,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTURLT%
if (UPDTURL = "")
	{
		UPDTURLT= http://raw.githubusercontent.com/romjacket/skeletonkey/master/site/version.txt
		UPDTURL= %UPDTURLT%
	}
IniWrite,%UPDTURL%,skopt.cfg,GLOBAL,update_url
return

UpdateFILE:
gui,submit,nohide
UPDTFILE= 
if (UPDTFILET = "")
	{
		UPDTFILET= %GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip	
	}
inputbox,UPDTFILE,Version,Enter the url of the file which contains your update information,,345,140,,,,,%UPDTFILET%
if (UPDTFILE = "")
	{
		UPDTFILET= %GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip
		UPDTFILE= %UPDTFILET%
	}
IniWrite,%UPDTFILE%,skopt.cfg,GLOBAL,update_file
return

SrcDD:
gui,submit,nohide
guicontrolget,SRCDD,,SRCDD
guicontrol,,RESGET,GET
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
if (SRCDD = "Project")
	{
		guicontrol,,RESGET,CLONE
		SB_SetText(" " GITD " ")
	}
if (SRCDD = "NSIS")
	{
		SB_SetText(" " NSIS " ")
	}
if (SRCDD = "github-release")
	{
		SB_SetText(" " GITRLS " ")
	}
if (SRCDD = "Site")
	{
		guicontrol,,RESGET,CLONE
		SB_SetText(" " SITEDIR " ")
	}
	
if (SRCDD = "SciTE4AutoHotkey")
	{
		SB_SetText(" " SCITE " ")
	}
		
if (SRCDD = "Git.exe")
	{
		SB_SetText(" " GITAPP " ")
	}
	
if (SRCDD = "repo_hub")
	{
		SB_SetText(" " RREPO " ")
	}
	
if (SRCDD = "dat_hub")
	{
		SB_SetText(" " DREPO " ")
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
if (RESDD = "Update-File")
	{
		SB_SetText(" " UPDTFILE " ")
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
if (RESDD = "Internet-IP-URL")
	{
		SB_SetText(" " GETIPADR " ")
	}
if (RESDD = "Git-Password")
	{
		SB_SetText(" ********* ")
	}
if (RESDD = "Git-User")
	{
		SB_SetText(" " GITUSER " ")
	}
if (RESDD = "Git-Token")
	{
		SB_SetText(" " GITPAT " ")
	}
if (RESDD = "Repo-URL")
	{
		REPORURLT= %GITUSER%.github.io
		SB_SetText(" " REPOURL " ")
	}
if (RESDD = "repo_hub")
	{
		RREPO= repo_hub
		SB_SetText(" " RREPO " ")
	}
if (RESDD = "dat_hub")
	{
		DREPO= dat_hub
		SB_SetText(" " DREPO " ")
	}
return

GitSRC:
gui,submit,nohide
GitSRC= 
if (GitSRCT = "")
	{
		GitSRCT= %GITWEB%/%GITUSER%/skeletonkey
	}

inputbox,GitSRC,Git Repo,Enter the url for the skeletonKey git repo,,345,140,,,,,%GitSRCT%
if (GitSRC = "")
	{
		GitSRCT= %GITWEB%/romjacket/skeletonkey
		GitSRC= %GitSRCT%
	}

IniWrite,%GitSRC%,skopt.cfg,GLOBAL,git_url
return

VerNum:
gui,submit,nohide
guicontrolget,vernum,,vernum
return

;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   DEPLOYMENT TOOL BUTTONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SelDir:
gui,submit,nohide
if (SRCDD = "Git-User")
	{
		gosub, GetGUSR
		if (GITUSER = "")
			{
				GITUSER= %A_Username%
			}
	}
if (GITPAT = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	{
		msgbox,1,,Git Personal Access Token must be set to deploy executables.,5
		gosub, GetGPAC
	}
if (SRCDD = "Source")
	{
		skeltmp= %A_ScriptDir%
		gosub, GetSrc
	}
if (SRCDD = "Git.exe")
	{	
		gitapdtmp= %rpfs%\git\bin
		ifnotexist, %gitapptmp%
			{
				gitapdtmp= %A_MyDocuments%
			}
		gosub, GetAPP
	}
if (SRCDD = "GitRoot")
	{
		gitrttmp= %A_MyDocuments%
		gosub, GitRoot
	}
if (SRCDD = "Site")
	{
		STLOCtmp= %GITROOT%
		gosub, GetSiteDir
	}
if (SRCDD = "Compiler")
	{
		ahktmp= %A_MyDocuments%
		comptmp= %A_MyDocuments%
		ifexist, %rpfs%\AutoHotkey\Compiler
			{
				comptmp= %rpfs%\AutoHotkey\Compiler
			}
		ifexist, %A_MyDocuments%\AutoHotkey\Compiler
			{
				comptmp= %A_MyDocuments%\AutoHotkey\Compiler
			}
		gosub, GetComp
	}
if (SRCDD = "Project")
	{
		gittmp= %A_MyDocuments%
		ifexist, %GITROOT%\skeletonKey
			{
				gittmp= %GITROOT%\skeletonKey
			}
		gosub, GetGit
	}
if (SRCDD = "SciTE4AutoHotkey")
	{
		scitmp= %A_MyDocuments%
		gosub, GetSCI
	}
if (SRCDD = "Deployment")
	{
		depltmp= %GITROOT%
		gosub, GetDepl
	}
if (SRCDD = "github-release")
	{
		splitpath,gitapp,,gitrlstmp
		gosub, GetRls
	}
if (SRCDD = "Build")
	{
		gosub, GetBld
	}
if (SRCDD = "NSIS")
	{
		nsitmp= %A_MyDocuments%\NSIS
		nstmp= %A_MyDocuments%\NSIS\makensis.exe
		ifexist, %ProgramFilesX86%\NSIS\makensis.exe
			{
				nsitmp= %ProgramFilesX86%\NSIS
				nstmp= %ProgramFilesX86%\NSIS\makensis.exe
			}
		ifexist, %A_MyDocuments%\NSIS
			{
				nsimp= %A_MyDocuments%\NSIS
				nstmp= %A_MyDocuments%\NSIS\makensis.exe
			}
		ifnotexist, %nsitmp%
			{
				nsitmp= %A_MyDocuments%
			}
		gosub, SelNSIS
	}
INIT= 
return
AddIncVer:
gui,submit,nohide
guicontrolget,vernum,,vernum
stringsplit,vernad,vernum,.
nven:= vernad4+1
stringleft,vernap,vernad4,1
if (vernap = 0)
	{
		nven= 0%nven%
	}
if (vernad4 = 99)
	{
		nven= 00
		if (vernad3 = 99)
			{
				nven= x
			}
			else {
				vernad3+=1
			}
	}
	
vernum:= vernad1 . "." vernad2 . "." vernad3 . "." nven
guicontrol,,VerNum,%vernum%
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

REPODATS:
gui,submit,nohide

return

DatBld:
gui,submit,nohide

return

PushNotes:
gui,submit,nohide
guicontrolget, PushNotes,,PushNotes
ifinstring,pushnotes,$
	{
		stringgetpos,verstr,pushnotes,$
		stringgetpos,endstr,pushnotes,.00
		if (ErrorLevel <> "")
			{
				strstr:= verstr + 2
				midstr:= (endstr - verstr - 1)
				stringmid,donation,pushnotes,strstr,midstr
				SB_SetText(" $" donation " found")
			}
	}
return

ServerPush:
gui,submit,nohide

return

GitPush:
gui,submit,nohide
guicontrolget,GITPUSH,,GITPUSH
return

SiteUpdate:
gui,submit,nohide

return


LogView:
ifexist,%DEPL%\deploy.log
	{
		Run,Notepad "%DEPL%\deploy.log"
		return
	}
SB_SetText("Log Not Found")
return

;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   RESET  BUTTON  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ResB:
gui,submit,nohide
if (RESDD = "Stable-Build")
	{
		StbBld= 
		SBOV= 
		FileSelectFile,StbBld,3,Installer.zip,Select Stable Build
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
		FileSelectFile,PortBld,3,skeletonKey.zip,Select Portable Build
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
		FileSelectFile,DevBld,3,skeletonKey.zip,Select Portable Build
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
				FileDelete, %BUILDIR%\gitcommit.bat
				FileDelete, %BUILDIR%\skdeploy.nsi				
				FileDelete, %BUILDIR%\skopt.cfg
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
if (RESDD = "github-release")
	{
		MsgBox,1,Confirm Tool Reset, Are You sure you want to reset the github-release.exe?
		IfMsgBox, OK
			{
				GITRLSTtmp= 
				GBOV= 
				FileSelectFile,GITRLST,3,%gitroot%\github-release.exe,Select github-release,*.exe.
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
		iniread,REPOURL,sets\arcorg.set,GLOBAL,HOSTINGURL
		Gosub, RepoURL
	}
if (RESDD = "Internet-IP-URL")
	{
		GETIPADRT= %GETIPADR%
		Gosub, GetIpAddr
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
if (RESDD = "Update-File")
	{
		UPDTURLT= %UPDTFILE%
		Gosub, UpdateFile
	}
if (RESDD = "Git-Token")
	{
		GITPAT= XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		Gosub, GetGPAC
	}
if (RESDD = "Git-User")
	{
		GITUSER= 
		Gosub, GetGUSR
	}
if (RESDD = "Git-Password")
	{
		GITPASS= 
		Gosub, GetGPass
	}
if (RESDD = "All")
	{
		Msgbox,3,Confirm Reset,Are you sure you wish to reset the SKey-Deploy tool?
			ifmsgbox,yes
				{
					filedelete,skopt.cfg
					exitapp
				}
		Gosub, GetGPass
	}
return
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  DEPLOYMENT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMPILE:
filedelete,%DEPL%\deploy.log
BCANC= 
gui,submit,nohide
compiling= 1
guicontrol,hide,COMPILE
guicontrol,show,CANCEL
guicontrolget,REPODATS,,REPODATS
guicontrolget,DATBLD,,DATBLD
guicontrolget,GITPUSH,,GITPUSH
guicontrolget,SERVERPUSH,,SERVERPUSH
guicontrolget,SITEUPDATE,,SITEUPDATE
guicontrolget,INITINCL,,INITINCL
guicontrolget,PORTVER,,PORTVER
guicontrol,disable,RESDD
guicontrol,disable,OvrStable
guicontrol,disable,ResB
guicontrol,disable,SrcDD
guicontrol,disable,SelDir
guicontrol,disable,PushNotes
guicontrol,disable,VerNum
guicontrol,disable,GitPush
guicontrol,disable,ServerPush
guicontrol,disable,SiteUpdate
guicontrol,disable,DatBld
guicontrol,disable,REPODATS
guicontrol,disable,PortVer
guicontrol,disable,INITINCL
guicontrol,disable,DevlVer


readme= 
FileMove,%SKELD%\ReadMe.md, %SKELD%\ReadMe.bak,1
FileRead,readme,%SKELD%\sets\ReadMe.set
StringReplace,readme,readme,[CURV],%vernum%
StringReplace,readme,readme,[VERSION],%date% %timestring%
FileAppend,%readme%,%SKELD%\ReadMe.md
FileCopy,%SKELD%\ReadMe.md,site,1
arcorgv= 
FileMove,%SKELD%\sets\themes.set, %SKELD%\themes.bak,1
FileMove,%SKELD%\sets\arcorg.set, %SKELD%\arcorg.bak,1
FIleRead,skthemes,%SKELD%\sets\Themes.put
FIleRead,arcorgv,%SKELD%\sets\arcorg.put
StringReplace,skthemes,skthemes,[ALTHOST],%ALTHOST%,All
StringReplace,skthemes,skthemes,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorgv,arcorgv,[UPDATEFILE],%UPDTFILE%,All
StringReplace,arcorgv,arcorgv,[ALTHOST],%ALTHOST%,All
StringReplace,arcorgv,arcorgv,[HOSTINGURL],%REPOURL%,All
StringReplace,arcorgv,arcorgv,[SHADERHOST],%SHDRPURL%,All
StringReplace,arcorgv,arcorgv,[SOURCEHOST],%UPDTURL%,All
GRARBV= %GITSWEB%/%gituser%/%RREPO%/releases/download
GRARDT= %GITSWEB%/%gituser%/%DREPO%/releases/download
StringReplace,arcorgv,arcorgv,[DATHUB],%GRARDT%,All
StringReplace,arcorgv,arcorgv,[REPOSRC],%GRARBV%,All
StringReplace,arcorgv,arcorgv,[IPLK],%GETIPADR%,All
StringReplace,arcorgv,arcorgv,[CURV],%vernum%,All
FileAppend,%skthemes%,%SKELD%\sets\themes.set
FileAppend,%arcorgv%,%SKELD%\sets\arcorg.set
Loop, %BUILDIR%\gam\*,2
	{
		REPONM= %A_LoopfileName%
		stringreplace,REPONM,REPONM,%A_Space%,_,All
		stringreplace,REPONM,REPONM,-,_,All
		stringreplace,REPONM,REPONM,`,_,All
		stringreplace,REPONM,REPONM,),_,All
		stringreplace,REPONM,REPONM,(,_,All
		stringreplace,REPONM,REPONM,!,_,All
		stringreplace,REPONM,REPONM,[,_,All
		stringreplace,REPONM,REPONM,],_,All
		stringreplace,REPONM,REPONM,;,_,All
		stringreplace,REPONM,REPONM,.,_,All
		stringreplace,REPONM,REPONM,@,_,All
		REPOROOT= % REPONM_%SRC%
		if (REPOROOT = "")
			{
				REPOROOT= %REPONM%
			}
		iniwrite,%REPOROOT%,%SKELD%\sets\arcorg.set,SOURCES,%REPONM%
		stringupper,UPARCNM,REPONM
		iniwrite,%GRARBV%/%UPARCNM%/%A_LoopFileName%.7z,%SKELD%\sets\arcorg.set,SOURCES,%REPONM%:SET
	}
FileDelete, %SKELD%\skeletonKey.exe
FileDelete,%SKELD%\skeletonkey.tmp
FileMove,%SKELD%\skeletonkey.ahk,%SKELD%\skel.bak,1
FileCopy, %SKELD%\working.ahk, %SKELD%\skeletonkey.tmp,1
sktmp= 
sktmc= 
sktmv= 
FileRead, sktmp,%SKELD%\skeletonkey.tmp
StringReplace,sktmc,sktmp,[VERSION],%date% %TimeString%,All
StringReplace,sktmv,sktmc,[CURV],%vernum%
stringreplace,sktmv,sktmv,`/`*  `;`;[DEBUGOV],,All
stringreplace,sktmv,sktmv,`*`/  `;`;[DEBUGOV],,All
FileAppend,%sktmv%,%SKELD%\skeletonkey.ahk
FileDelete,%SKELD%\skeletonkey.tmp

if (BCANC = 1)
	{
		SB_SetText(" Cancelling Compile ")
		guicontrol,,progb,0
		;Sleep, 500
		compiling= 
		return
	}
	
SB_SetText(" Compiling ")
if (OvrStable = 1)
	{
		ifexist, %DEPL%\skeletonkey.exe
			{
				FileMove, %DEPL%\skeletonkey.exe, %DEPL%\skeletonkey.exe.bak,1
			}
		ifexist, %SKELD%\SKey-Deploy.exe
			{
				FileMove, %SKELD%\SKey-Deploy.exe, %SKELD%\SKey-Deploy.exe.bak,1
			}
	}
	
if (INITINCL = 1)
	{
			exprt= 
			exprt.= "FileCreateDir, gam" . "`n"
			exprt.= "FileCreateDir, img" . "`n"
			exprt.= "FileCreateDir, site" . "`n"
			exprt.= "FileCreateDir, sets" . "`n"
			exprt.= "FileCreateDir, bin" . "`n"
			exprt.= "FileCreateDir, src" . "`n"
			exprt.= "IfNotExist, rj" . "`n" . "{" . "`n" . "FileCreateDir, rj" . "`n" . "FILEINS= 1" . "`n" . "}" . "`n"
			exprt.= "If (INITIAL = 1)" . "`n" . "{" . "`n" . "FILEINS= 1" . "`n" . "}" . "`n"
			exprt.= "If (FILEINS = 1)" . "`n" . "{" . "`n" 
			RunWait, %comspec% cmd /c echo.###################  COMPILE DEPLOYER  ####################### >>"%DEPL%\deploy.log", ,%rntp%
			runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\Skey-Deploy.ahk" /out "%SKELD%\Skey-Deploy.exe" /icon "%SKELD%\img\Sharp - X1.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
			RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			Loop, Files, %SKELD%\rj\emuCfgs\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			Loop, Files, %SKELD%\rj\joyCfgs\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			Loop, Files, %SKELD%\rj\KODI\*,DR
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					fcdxp.= "FileCreateDir," . ain . "`n"
				}	
			exprt.= fcdxp . "`n" . "}" . "`n"
			exprt.= "FileCreateDir, rj\ES" . "`n"
			exprt.= "FileCreateDir, rj\PG" . "`n"
			exprt.= "FileCreateDir, rj\RF" . "`n"
			Loop, files, %SKELD%\site\*.txt
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.md
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.ico
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.svg
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.png
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.html
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.ttf
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\site\*.otf
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files,%SKELD%\sets\*.set
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\sets\*.put
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\*.exe
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\bin\*.txt
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\bin\*.exe
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\img\*.png
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\img\*.ico
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\rj\KODI\*.set,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\src\*.ahk,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
				}
			Loop, files, %SKELD%\rj\emucfgs\*.*,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					if (A_LoopFileExt = "ret")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "set")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "get")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
				}
			Loop, files, %SKELD%\rj\joyCfgs\*.*,R
				{
					stringreplace,ain,A_LoopFileFullPath,%A_ScriptDir%\,,All
					if (A_LoopFileExt = "amgp")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
					if (A_LoopFileExt = "xpadderprofile")
						{
							exprt.= "FileInstall," . ain . "," . ain . ",1" . "`n"
						}
				}				
			exprt.= "FileInstall, bin\Portable.bat,bin\Portable.bat" . "`n"	
			exprt.= "FileInstall, bin\7zsd32.sfx,bin\7zsd32.sfx" . "`n"	
			exprt.= "FileInstall, bin\7zsd64.sfx,bin\7zsd64.sfx" . "`n"	
			exprt.= "FileInstall, site\index.html,site\index.html,1" . "`n"	
			exprt.= "FileInstall, site\version.txt,site\version.txt,1" . "`n"	
			exprt.= "FileInstall, working.ahk,working.ahk,1" . "`n"	
			exprt.= "FileInstall, init.ahk,init.ahk,1" . "`n"	
			exprt.= "FileInstall, Update.ahk,Update.ahk,1" . "`n"	
			exprt.= "FileInstall, skeletonKey.ahk,skeletonkey.ahk,1" . "`n"	
			exprt.= "FileInstall, SKey-Deploy.ahk,SKey-Deploy.ahk,1" . "`n"	
			exprt.= "FileInstall, bin\PortableUtil.ahk,bin\PortableUtil.ahk,1" . "`n"	
			exprt.= "FileInstall, bin\emuexe.ahk,bin\emuexe.ahk,1" . "`n"	
			exprt.= "FileInstall, bin\BSL.ahk,bin\BSL.ahk,1" . "`n"	
			exprt.= "FileInstall, src\LV_InCellEdit.ahk,src\LV_InCellEdit.ahk,1" . "`n"	
			exprt.= "FileInstall, src\tf.ahk,src\tf.ahk,1" . "`n"	
			exprt.= "FileInstall, src\lbex.ahk,src\lbex.ahk,1" . "`n"	
			exprt.= "FileInstall, src\LVA.ahk,src\LVA.ahk,1" . "`n"	
			exprt.= "FileInstall, src\HtmlDlg.ahk,src\HtmlDlg.ahk,1" . "`n"	
			exprt.= "FileInstall, src\AHKSock.ahk,src\AHKSock.ahk,1" . "`n"
			exprt.= "FileInstall, Readme.md,Readme.md,1" . "`n"
			FileDelete,%SKELD%\sets\ExeRec.set
			FileAppend,%exprt%,%SKELD%\sets\ExeRec.set
	}

if (OvrStable = 1)
	{
		Process, exist, Skey-Deploy.exe
		if (ERRORLEVEL = 1)
			{
				SB_SetText("You should not compile this tool with the compiled skey-deploy.exe executable")
			}
		RunWait, %comspec% cmd /c echo.##################  COMPILE DEPLOYER  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
		runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\Skey-Deploy.ahk" /out "%SKELD%\Skey-Deploy.exe" /icon "%SKELD%\img\Sharp - X1.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%	
		RunWait, %comspec% cmd /c echo.##################  COMPILE SKELETONKEY  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
		runwait, %comspec% cmd /c " "%AHKDIR%\Ahk2Exe.exe" /in "%SKELD%\skeletonkey.ahk" /out "%DEPL%\skeletonkey.exe" /icon "%SKELD%\site\key.ico" /bin "%AHKDIR%\Unicode 32-bit.bin" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
		FileDelete,%SKELD%\skeletonkey.ahk
		FileCopy, %DEPL%\skeletonkey.exe,%SKELD%,1
	}

guicontrol,,progb,15
FileDelete,%SKELD%\*.lpl
FileDelete,%SKELD%\*.tmp
guicontrol,,progb,20
if (DATBLD = 1)
	{		
		SB_SetText(" Recompiling Databases ")
		FileDelete, %DEPL%\ART_ASSETS.7z
		Loop, %GITD%\rj\scrapeArt\*.7z
			{
				RunWait, %comspec% cmd /c echo.##################  CREATE METADATA  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a -t7z "ART_ASSETS.7z" "%A_LoopFileFullPath%" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
			}
	}
if (REPODATS = 1)
	{
		SB_SetText(" Compiling Repository Databases ")
		repolsts= 
		Loop, %BUILDIR%\gam\*,2
			{
				repolsts+=1
				repoln%A_Index%= %A_LoopFileName%
				RunWait, %comspec% cmd /c echo.##################  CREATE GAMFILES  ######################## >>"%DEPL%\deploy.log", ,%rntp%
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a -t7z "%A_LoopFileName%.7z" "%A_LoopFileFullPath%" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			}	

	}

FileGetSize,dbsize,%DEPL%\ART_ASSETS.7z,K
DATSZ:= dbsize / 1000
	
if (PortVer = 1)
	{		
		SB_SetText(" Building portable ")
		COMPLIST= 
		if (PBOV <> 1)
			{
				FileDelete, %DEPL%\skeletonKey.zip
				RunWait, %comspec% cmd /c echo.##################  CREATE PORTABLE ZIP  ######################## >>"%DEPL%\deploy.log", ,%rntp%	
				runwait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a "%DEPL%\skeletonKey.zip" "%DEPL%\skeletonkey.exe" >>"%DEPL%\deploy.log"", %SKELD%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
				sleep, 1000
			}
	}

guicontrol,,progb,35
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Development Build ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
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
		gosub, canclbld
		compiling= 
		return
	}
if (GitPush = 1)
	{
		ifinstring,pushnotes,|
			{
				stringsplit,ebeb,pushnotes,|
				TAGLINE= %ebeb2%				
			}
			else {
			TAGLINE= A unified interface for ROMs, emulators and frontends.
			}
		ifinstring,pushnotes,$
			{
				stringgetpos,verstr,pushnotes,$
				stringgetpos,endstr,pushnotes,.00
				if (ErrorLevel <> "")
					{
						strstr:= verstr + 2
						midstr:= (endstr - verstr - 1)
						stringmid,donation,pushnotes,strstr,midstr
						SB_SetText(" $" donation " found")
					}
			}
		If (PushNotes = "")
			{
				PushNotes= %date% %TimeString%
				Loop, Read, %getversf%
					{
						sklnum+=1
						getvern= 
						ifinstring,A_LoopReadLine,$
							{
								stringgetpos,verstr,A_LoopReadLine,$
								stringgetpos,endstr,A_LoopReadLine,.00
								if (ErrorLevel <> "")
									{			
										strstr:= verstr + 2
										midstr:= (endstr - verstr - 1)
										stringmid,donation,A_LoopReadLine,strstr,midstr
										if (midstr = [PAYPAL])
											{
												donation= 00.00
											}
										if (donation = "[PAYPAL].00")
											{
												donation= 00.00
											}
										SB_SetText(" $" donation " found")
										break
											
									}
							}
								continue
					}
			}
		if (donation = "")
			{
				donation= 00.00				
			}			
		FileDelete, %SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\gam"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\scrapeArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\ES"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\PG"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\RF"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\emuCfgs"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\ADVL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\IAGL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\rj\KODI\RCB"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, mkdir "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /s /q "%GITD%\rj\netArt\*"`n,%SKELD%\!gitupdate.cmd
		FileAppend, rd /s/q "%GITD%\rj\netArt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, rd /s/q "%GITD%\rj\sysCfgs"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tdb"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.tmp"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.zip"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.cfg"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.txt"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\ES\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\PG\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\rj\RF\*.ini"`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "rj" "%GITD%\rj" /s /e /w:1 /r:1 /xf "*.bak" "*.ini" "*.tdb" "*.tmp" "*.jak" /xd "ES" "RF" "PG" "scrapeArt" "netArt" "syscfgs"`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "img" "%GITD%\img" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		FileAppend, robocopy "rj\emucfgs" "%GITD%\rj\emuCfgs" /s /e /w:1 /r:1`n,%SKELD%\!gitupdate.cmd
		if (DATBLD = 1)
			{
				FileAppend, copy /y "rj\scrapeArt\*.7z" "%GITD%\rj\scrapeArt"`n,%SKELD%\!gitupdate.cmd
			}
		;;FileAppend, copy /y "*.exe" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "bin\*.exe" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\*.set" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\index.html" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\Portable.bat" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\BSL.ahk" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\emuexe.ahk" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\PortableUtil.ahk" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "bin\*.txt" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "init.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "Update.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "SKey-Deploy.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "working.ahk" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\LV_InCellEdit.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\lbex.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\LVA.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\HtmlDlg.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\tf.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "src\AHKsock.ahk" "%GITD%\src"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\RCB\*.set" "%GITD%\rj\KODI\RCB"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\AEL\*.set" "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\IAGL\*.set" "%GITD%\rj\KODI\IAGL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "rj\KODI\AEL\*.set" "%GITD%\rj\KODI\AEL"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "img\*.ico" "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "img\*.png" "%GITD%\img"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "ReadMe.md" "%GITD%"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\ReadMe.md" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "site\version.txt" "%GITD%\site"`n,%SKELD%\!gitupdate.cmd
		FileAppend, del /q "%GITD%\skeletonKey.exe"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\Themes.put" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		FileAppend, copy /y "sets\arcorg.put" "%GITD%\sets"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "bin\7zSD.sfx" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "bin\7zsd32.sfx" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd
		;;FileAppend, copy /y "bin\7zsd64.sfx" "%GITD%\bin"`n,%SKELD%\!gitupdate.cmd

		FileSetAttrib, +h, %SKELD%\!gitupdate.cmd
		SB_SetText(" Adding changes to git ")
		RunWait, %comspec% cmd /c echo.###################  GIT UPDATE  ####################### >>"%DEPL%\deploy.log", ,%rntp%	
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" >>"%DEPL%\deploy.log"",%SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%	
		FileDelete, %SKELD%\!gitupdate.cmd
		SB_SetText(" committing changes to git ")
		FileDelete, %BUILDIR%\gitcommit.bat
			{
				FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\gitcommit.bat
				FileAppend,pushd "%GITD%"`n,%BUILDIR%\gitcommit.bat
				FileAppend,"%GITAPP%" config user.email %GITMAIL%`n,%BUILDIR%\gitcommit.bat
				FileAppend,"%GITAPP%" config user.name %GITUSER%`n,%BUILDIR%\gitcommit.bat
				FileAppend,"`%gitapp`%" add .`n,%BUILDIR%\gitcommit.bat
				FileAppend,"`%gitapp`%" commit -m `%1`%`n,%BUILDIR%\gitcommit.bat
				FileAppend,"`%gitapp`%" push --set-upstream http://%gituser%:%gitpass%@github.com/%gituser%/skeletonkey master`n,gitcommit.bat
				if (GITPASS <> "")
					{
						FileAppend,"`%gitapp`%" push -f --repo http://%GITUSER%:%GITPASS%@github.com/%gituser%/skeletonKey`n,%BUILDIR%\gitcommit.bat
					}
				if (GITPASS = "")
					{
						FileAppend,"`%gitapp`%" push -f origin master`n,%BUILDIR%\gitcommit.bat
					}
			}
			
		FileAppend, "%PushNotes%`n",%DEPL%\changelog.txt
		RunWait, %comspec% cmd /c echo.###################  GIT UPDATE  ####################### >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%SKELD%\!gitupdate.cmd" >>"%DEPL%\deploy.log"",%SKELD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		SB_SetText(" Source changes committed.  Files Copied to git.  Committing...")
		StringReplace,PushNotes,PushNotes,",,All
		;"
		RunWait, %comspec% cmd /c echo.####################  GIT COMMIT  ###################### >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%BUILDIR%\gitcommit.bat" "%PushNotes%" >>"%DEPL%\deploy.log"",%GITD%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		FileDelete, %BUILDIR%\gitcommit.bat
		SB_SetText(" source changes pushed to master ")
		guicontrol,,progb,65
	}
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Stable Overwrite ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
		return
	}
if (OvrStable = 1)
	{
		SB_SetText(" overwriting stable ")
		if (BUILT <> 1)
			{
				gosub, BUILDING
			}
	}				
guicontrol,,progb,70
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Server Upload ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
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
						FileAppend, "%GITRLS%" delete -u %gituser% -s %GITPAT% -r skeletonkey -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -u %gituser% -s %GITPAT% -r skeletonkey -n portable -t portable`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -u %gituser% -s %GITPAT% -R -r skeletonkey -t portable -l portable -n skeletonKey.zip -f "%DEPL%\skeletonKey.zip"`n,%DEPL%\gpush.cmd
					}
			}
		if (DATBLD = 1)
			{
				if (ServerPush = 1)
					{					
						FileAppend, "%GITRLS%" delete -u %gituser% -s %GITPAT% -r %DREPO% -t ART_ASSETS`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -u %gituser% -s %GITPAT% -r %DREPO% -n ART_ASSETS -t ART_ASSETS`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -u %gituser% -s %GITPAT% -R -r %DREPO% -t ART_ASSETS -l "ART_ASSETS" -n ART_ASSETS.7z -f "%DEPL%\ART_ASSETS.7z"`n,%DEPL%\gpush.cmd
					}
			}
		if (REPODATS = 1)
			{
				if (ServerPush = 1)
					{
						Loop,%repolsts%
							{
								rpofn:= % repoln%A_Index%
								stringupper,rpoln,rpofn
								FileAppend, "%GITRLS%" delete -u %gituser% -s %GITPAT% -r %RREPO% -t %rpoln%`n,%DEPL%\gpush.cmd
								FileAppend, "%GITRLS%" release -u %gituser% -s %GITPAT% -r %RREPO% -n %rpoln% -t %rpoln%`n,%DEPL%\gpush.cmd
								FileAppend, "%GITRLS%" upload -u %gituser% -s %GITPAT% -R -r %RREPO% -t %rpoln% -l "%rpoln%" -n %rpofn%.7z -f "%DEPL%\%rpofn%.7z"`n,%DEPL%\gpush.cmd
							}
					}
			}
		if (OvrStable = 1)
			{
				if (ServerPush = 1)
					{
						FileAppend, "%GITRLS%" delete -u %gituser% -s %GITPAT% -r skeletonkey -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" release -u %gituser% -s %GITPAT% -r skeletonkey -n Installer -t Installer`n,%DEPL%\gpush.cmd
						FileAppend, "%GITRLS%" upload -u %gituser% -s %GITPAT% -R -r skeletonkey -t Installer -l Installer -n Installer.zip -f "%DEPL%\Installer.zip"`n,%DEPL%\gpush.cmd
					}
			}
		if (SiteUpdate <> 1)
			{

			}
		guicontrol,,progb,80
		if (GitPush = 1)
			{
				RunWait, %comspec% cmd /c echo.###################  GIT DEPLOYMENT PUSH  ####################### >>"%DEPL%\deploy.log", ,%rntp%
				RunWait, %comspec% cmd /c " "gpush.cmd" >>"%DEPL%\deploy.log"",%DEPL%,%rntp%
				RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
			}
	}	
if (BCANC = 1)
	{
		SB_SetText(" Cancelling Site Update ")
		guicontrol,,progb,0
		gosub, canclbld
		compiling= 
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
				FileMove, %DEPL%\site\index.html, %DEPL%\index.bak,1
				FileRead,skelhtml,%BUILDIR%\site\index.html
				StringReplace,skelhtml,skelhtml,[CURV],%vernum%,All
				StringReplace,skelhtml,skelhtml,[TAGLINE],%tagline%,All
				FileDelete,%BUILDIR%\insts.sha1

				if (OvrStable = 1)
					{
						ifExist, %DEPL%\skeletonkey-installer.exe
							{
								CrCFLN= %DEPL%\skeletonkey-installer.exe
								gosub, SHA1GET
								if (SBOV = 1)
									{
										ApndSHA= reverted
									}
								if (DBOV = 1)
									{
										ApndSHA= reverted
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
		guicontrol,,progb,90
		StringReplace,skelhtml,skelhtml,[RSHA1],%ApndSHA%,All
		StringReplace,skelhtml,skelhtml,[WEBURL],http://%GITUSER%.github.io,All
		StringReplace,skelhtml,skelhtml,[PAYPAL],%donation%
		StringReplace,skelhtml,skelhtml,[GITSRC],%GITSRC%,All
		StringReplace,skelhtml,skelhtml,[REVISION],%GITWEB%/%gituser%/skeletonKey/releases/download/Installer/Installer.zip,All
		StringReplace,skelhtml,skelhtml,[PORTABLE],%GITSWEB%/%gituser%/skeletonKey/releases/download/portable/skeletonKey.zip,All
		
		StringReplace,skelhtml,skelhtml,[GITUSER],%gituser%,All
		StringReplace,skelhtml,skelhtml,[RELEASEPG],%GITSWEB%/%gituser%/skeletonKey/releases,All
		StringReplace,skelhtml,skelhtml,[ART_ASSETS],%GITSWEB%/%gituser%/skeletonKey/releases/download/ART_ASSETS/ART_ASSETS.7z,All
		
		StringReplace,skelhtml,skelhtml,[RDATE],%RDATE%,All
		StringReplace,skelhtml,skelhtml,[RSIZE],%dvms%,All
		StringReplace,skelhtml,skelhtml,[RSIZE2],%dvmg%,All
		StringReplace,skelhtml,skelhtml,[DBSIZE],%DATSZ%,All
		
		FileDelete,%gitroot%\%gituser%.github.io\skeletonkey\index.html
		ifnotexist, %gitroot%\%gituser%.github.io\skeletonkey
			{
				FileCreateDir,%gitroot%\%gituser%.github.io\skeletonkey
				;;RunWait, %comspec% cmd /c "%gitapp%" init,%gitroot%\%GITUSER%.github.io,hide				
				;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.email "%GITMAIL%",,hide
				;;RunWait, %comspec% cmd /c "%gitapp%" config --global user.name "%GITUSER%",,hide
				;;RunWait,"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d `"{\`"name\`":\`"%gituser%.github.io\`"}`",,hide
				
				FileAppend, "%GITAPP%" config user.email %GITMAIL%`n%GITAPP% config user.name %GITNAME%`npushd "%gitroot%\%GITUSER%.github.io"`n%GITAPP% init`npopd`n"bin\curl.exe" -k -u %gituser%:%gitpass% https://api.github.com/user/repos -d "{"name":"%gituser%.github.io"}",gitinit.cmd
				RunWait,gitinit.cmd,,hide
				FileDelete,gitinit.cmd
				
			}
		FileAppend,%skelhtml%,%gitroot%\%gituser%.github.io\skeletonkey\index.html
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
		FileAppend,pushd "%gitroot%\%GITUSER%.github.io"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\Global-Launch-Menu.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\key.ico" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\key.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\paradigm.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\tip.png" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\*.otf" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\*.ttf" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\*.svg" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\ReadMe.md" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,copy /y "%BUILDIR%\site\version.txt" "%gitroot%\%GITUSER%.github.io\skeletonkey"`n,%BUILDIR%\sitecommit.bat
		FileAppend,for /f "delims=" `%`%a in ("%GITAPP%") do set gitapp=`%`%~a`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" config user.name %GITUSER%`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" config user.email %GITMAIL%`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" add skeletonkey`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" commit -m siteupdate`n,%BUILDIR%\sitecommit.bat
		FileAppend,"`%gitapp`%" push --set-upstream http://%gituser%:%gitpass%@github.com/%gituser%/%gituser%.github.io master`n,sitecommit.bat
		if (GITPASS <> "")
			{
				FileAppend,"`%gitapp`%" push -f --repo http://%GITUSER%:%GITPASS%@github.com/%GITUSER%/%GITUSER%.github.io`n,%BUILDIR%\sitecommit.bat
			}
		if (GITPASS = "")
			{
				FileAppend,"`%gitapp`%" push`n,%BUILDIR%\sitecommit.bat
			}
		RunWait, %comspec% cmd /c echo.##################  SITE COMMIT  ######################## >>"%DEPL%\deploy.log", ,%rntp%
		RunWait, %comspec% cmd /c " "%BUILDIR%\sitecommit.bat" "site-commit" >>"%DEPL%\deploy.log"",%BUILDIR%,%rntp%
		RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
		FileDelete,%BUILDIR%\sitecommit.bat
	}

guicontrol,,progb,100
SB_SetText(" Complete ")
gosub, canclbld
guicontrol,,progb,0

guicontrol,enable,OvrStable
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
guicontrol,enable,REPODATS
guicontrol,enable,PortVer
guicontrol,enable,INITINCL
guicontrol,enable,DevlVer
guicontrol,hide,CANCEL
guicontrol,show,COMPILE
guicontrol,,progb,0
compiling= 
return


BUILDING:
BUILT= 1
ifexist, %DEPL%\skeletonD.zip
	{
		FileDelete, %DEPL%\skeletonD.zip
	}
ifexist, %DEPL%\skeletonK.zip
	{
		FileDelete, %DEPL%\skeletonK.zip
	}
ifexist, %DEPL%\skeletonkey-installer.exe
	{
		FileDelete, %DEPL%\skeletonkey-installer.exe
	}
;;FileDelete, %DEPL%\skeletonkey-Full.exe
ifexist, %BUILDIR%\skdeploy.nsi
	{
		FileDelete, %BUILDIR%\skdeploy.nsi
	}

FileRead, nsiv,%BUILDIR%\sets\skdeploy.set
StringReplace, nsiv, nsiv,[INSTYP],-installer,All
StringReplace, nsiv, nsiv,[SOURCE],%SKELD%,All
StringReplace, nsiv, nsiv,[BUILD],%BUILDIR%,All
StringReplace, nsiv, nsiv,[DBP],%DEPL%,All
StringReplace, nsiv, nsiv,[CURV],%vernum%,All
FileAppend, %nsiv%, %BUILDIR%\skdeploy.nsi
SB_SetText("Building Installer")
RunWait, %comspec% /c echo.###################  DEPLOYMENT LOG FOR %date%  ####################### >>"%DEPL%\deploy.log", ,%rntp%
RunWait, %comspec% /c " "%NSIS%" "%BUILDIR%\skdeploy.nsi" >>"%DEPL%\deploy.log" ",,%rntp%
RunWait, %comspec% /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
CrCFLN= %DEPL%\skeletonkey-installer.exe
gosub, SHA1GET
nchash:= ApndSHA
BLDERROR= 
ifnotexist, %DEPL%\skeletonKey-installer.exe
	{
		BLDERROR= 1
	}
BLDCHKSZ= 0
ifexist, %DEPL%\skeletonKey-installer.exe
	{
		FileGetSize, BLDCHKSZ,%DEPL%\skeletonKey-installer.exe,M
		if BLDCHKSZ < 2
			{
				BLDERROR= 1
			}
	}
if (BLDERROR = 1)
	{
		MsgBox,0,,HALT.,INSTALLER FAILED.,CHECK YO SCRIPT MAN!
	}
FileDelete,skdeploy.nsi
FileDelete, %SKELD%\site\version.txt
FileAppend, %date% %timestring%=%nchash%=%vernum%,%SKELD%\site\version.txt
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

RunWait, %comspec% cmd /c echo.##################  CREATE INSTALLER ######################## >>"%DEPL%\deploy.log", ,%rntp%
RunWait, %comspec% cmd /c " "%BUILDIR%\bin\7za.exe" a "%DEPL%\skeletonK.zip" "%DEPL%\skeletonKey-installer.exe" >>"%DEPL%\deploy.log"", %BUILDIR%,%rntp%
RunWait, %comspec% cmd /c echo.########################################## >>"%DEPL%\deploy.log", ,%rntp%
if (DevlVer = 1)
	{
		if (DBOV <> 1)
			{
				FileMove,%DEPL%\skeletonK.zip, %DEPL%\skeletonKey.zip,1	
				FileMove,%DEPL%\skeletonK.zip, %DEPL%\Installer.zip,1	
			}
	}
if (OvrStable = 1)
	{
				if (SBOV <> 1)
					{
						FileCopy,%DEPL%\skeletonK.zip, %DEPL%\skeletonkey-%date%%buildnum%.zip,1
						ifExist, %DEPL%\Installer.zip
							{
								FileMove,%DEPL%\Installer.zip, %DEPL%\Installer.zip.bak,1
							}
						FileMove,%DEPL%\skeletonK.zip, %DEPL%\Installer.zip,1
					}
	}
return
;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;{;;;;;;;;;;;;;;;;;;;  FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;

SETUPTOG:
Loop,Parse,setupguiitems,|
	{
		guicontrol,%SETUPTOG%,%A_LoopField%
	}
return

CANCEL:
gui,submit,nohide
msgbox,8452,Cancel,Are you sure you wish to cancel the deployment?,10
ifmsgbox,Yes
	{
		BCANC= 1
		guicontrol,enable,PushNotes
		guicontrol,enable,VerNum
		guicontrol,enable,GitPush
		guicontrol,enable,ServerPush
		guicontrol,enable,SiteUpdate
		guicontrol,enable,PortVer
		guicontrol,enable,INITINCL
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
	}
return

canclbld:
filemove,%SKELD%\skeletonKey.exe, %SKELD%\skeletonKey.del,1
return

esc::
#IfWinActive _DEV_
FDME:= 8452
quitnum+=1
if (quitnum = 3)
	{
		FDME:= 8196
	}
if (quitnum > 3)
	{
		goto, QUITOUT
	}
sleep,250
if (compiling = 1)
	{
		goto, CANCEL
	}
msgbox,% FDME,Exiting, Would you like to close the publisher?
ifmsgbox, yes
	{
		gosub, QUITOUT
	}
ifmsgbox, no
	{
		DWNCNCL= 
		return
	}
return

SHA1GET:
ApndSHA= % FileSHA1( CrCFLN )
FileSHA1(sFile="", cSz=4) {
 cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 09-Oct-2012
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return,hFil
 hMod := DllCall( "LoadLibrary", Str,"advapi32.dll" )
 DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( SHA_CTX,136,0 ),  DllCall( "advapi32\A_SHAInit", UInt,&SHA_CTX )
 Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
   DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\A_SHAUpdate", UInt,&SHA_CTX, UInt,&Buffer, UInt,bytesRead )
 DllCall( "advapi32\A_SHAFinal", UInt,&SHA_CTX, UInt,&SHA_CTX + 116 )
 DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" ) + 4
  N := NumGet( SHA_CTX,115+A_Index,"Char"), SHA1 .= SubStr(Hex,N>>4,1) SubStr(Hex,N&15,1)
Return SHA1, DllCall( "FreeLibrary", UInt,hMod )
}
StringLower,ApndSHA,ApndSHA
return

QUITOUT:
WinGet, PEFV,PID,_DEV_
Process, close, %PEFV%
GuiEscape:
GuiClose:
ExitApp
DownloadFile(UrlToFile, _SaveFileAs, Overwrite := True, UseProgressBar := True) {
		FinalSize= 
	
      If (!Overwrite && FileExist(_SaveFileAs))
		  {
			FileSelectFile, _SaveFileAs,S, %_SaveFileAs%
			if !_SaveFileAs 
			  return
		  }

      If (UseProgressBar) {
          
            SaveFileAs := _SaveFileAs
          
            try WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			catch {
			}
          
            try WebRequest.Open("HEAD", UrlToFile)
            catch {
			}
			try WebRequest.Send()
			catch {
			}
          
			try FinalSize := WebRequest.GetResponseHeader("Content-Length") 
			catch {
				FinalSize := 1
			}
			SetTimer, DownloadFileFunction_UpdateProgressBar, 100
		
 
      }
    
      UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
    
      If (UseProgressBar) {
          Progress, Off
          SetTimer, DownloadFileFunction_UpdateProgressBar, Off
      }
      return

      DownloadFileFunction_UpdateProgressBar:
    
      try CurrentSize := FileOpen(_SaveFileAs, "r").Length 
	  catch {
			}
			
      try CurrentSizeTick := A_TickCount
    catch {
			}
			
      try Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	  catch {
			}
    
      LastSizeTick := CurrentSizeTick
      try LastSize := FileOpen(_SaveFileAs, "r").Length
    catch {
			}
	
      try PercentDone := Round(CurrentSize/FinalSize*100)
    catch {
			}
			
	 if (PercentDone > 100)
		{
			PercentDone= 
		}
	 SB_SetText(" " Speed " " updtmsg " at " . PercentDone . `% " " CurrentSize " bytes completed")
	Guicontrol, ,progb, %PercentDone%
      return
  }
Guicontrol, ,progb, 0
return

exe_get($ARIA = "", $URL = "", $TARGET = "", $FNM = "", $SAG = "", $CACHESTAT = "")
	{
		Global $exeg_pid
		StringReplace, $URL, $URL, "&", "^&", All
		$CMD = "%$ARIA%" --always-resume=false --http-no-cache=true --allow-overwrite=true --stop-with-process=%$SAG% --check-certificate=false --truncate-console-readout=false --dir="%$TARGET%" --out="%$FNM%" "%$URL%" 1>"%$CACHESTAT%\%$FNM%.status" 2>&1
		Run, %comspec% /c "%$CMD%",,hide,$exeg_pid
		Process, Exist, %$exeg_pid%
		$lastline = 
		while ErrorLevel != 0
			{
				Loop Read, %$CACHESTAT%\%$FNM%.status
					{
						L = %A_LoopReadLine%						
						if ( InStr(L, `%) != 0 )
							{
								StringSplit, DownloadInfo, L, (`%,
								StringLeft, L1, DownloadInfo2, 3								
								if ( L1 = "100" )
									{
										Guicontrol, ,utlPRGA, 0
										Guicontrol, ,ARCDPRGRS, 0
										Guicontrol, ,DWNPRGRS, 0
										Guicontrol, ,FEPRGA, 0
										Break
									}
							}
						if ( InStr(L, `%) = 0 )
							{	
								L = 0
							}
					}
				if ( L1 is digit )
				Guicontrol, ,utlPRGA, %L1%
				Guicontrol, ,ARCDPRGRS, %L1%
				Guicontrol, ,DWNPRGRS, %L1%
				Guicontrol, ,FEPRGA, %L1%
				Process, Exist, %$exeg_pid%
				Sleep, 50
			}
		sleep 200
		FileGetSize, d_size, %$TARGET%\%$FNM%
		if d_size > 0
			{
				FileDelete, %$CACHESTAT%\%$FNM%.status
				Return true
			}
		else
			{
				MsgBox,0,Error, There was a problem accessing the server.`nCheck status file for details.
				FileDelete, %$CACHESTAT%\%$FNM%.status
				Return false
			}
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
;};;;;;;;;;;;;;


;};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
