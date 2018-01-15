!ifdef NOCOMPRESS
SetCompress on
!endif

Name "skeletonKey"
Caption "Universal ROM-Library Interface Kit"
Icon "C:\Users\sudopinion\Documents\skeletonkey\install.ico"
OutFile "C:\Users\sudopinion\Documents\GitHub\skeletonkey.deploy\skeletonkey-Full.exe"

SetDateSave on
SetDatablockOptimize on
SilentInstall normal
BGGradient off
InstallColors /windows
XPStyle off

InstallDir "$DOCUMENTS\skeletonKey"
InstallDirRegKey HKLM "Software\skeletonKey" "Install_Dir"


LicenseText "Anon, I" "I Agree"
LicenseData "C:\Users\sudopinion\Documents\skeletonkey\ReadMe.md"

RequestExecutionLevel none

		
Page license
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

!ifndef NOINSTTYPES ; only if not defined
  ;InstType "Most"
  ;InstType "Full"
  ;InstType "More"
  ;InstType "Base"
  InstType /NOCUSTOM
  ;InstType /COMPONENTSONLYONCUSTOM
!endif

AutoCloseWindow true
ShowInstDetails show


Section "" ; empty string makes it hidden, so would starting with -

  ; write reg info
  StrCpy $1 "Installation"
  DetailPrint "I like to be able to see what is going on (debug) $1"
  WriteRegStr HKLM SOFTWARE\RoM-Jacket "Install_Dir" "$INSTDIR"

  ; write uninstall strings
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\skeletonKey" "skeletonKey" "skeletonKey (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\skeletonKey" "UninstallString" '"$INSTDIR\skeletonKey-uninst.exe"'

  SetOutPath $INSTDIR

  File "C:\Users\sudopinion\Documents\skeletonkey\*.set"
  File "C:\Users\sudopinion\Documents\skeletonkey\*.html"
  File "C:\Users\sudopinion\Documents\skeletonkey\*.png"
  File "C:\Users\sudopinion\Documents\skeletonkey\*.ico"
  File "C:\Users\sudopinion\Documents\skeletonkey\BSL.ahk"
  File "C:\Users\sudopinion\Documents\skeletonkey\SKey-Deploy.ahk"
  File "C:\Users\sudopinion\Documents\skeletonkey\skeletonkey.ahk"
  File "C:\Users\sudopinion\Documents\skeletonkey\*.exe"
  SetOutPath $INSTDIR\gam
  File "C:\Users\sudopinion\Documents\skeletonkey\gam\*.gam"
  SetOutPath $INSTDIR\joyImg
  File "C:\Users\sudopinion\Documents\skeletonkey\joyImg\*.png"
  SetOutPath $INSTDIR\rj\joyCfgs
  File /r "C:\Users\sudopinion\Documents\skeletonkey\rj\joyCfgs"
  SetOutPath $INSTDIR\rj\emuCfgs
  File /r "C:\Users\sudopinion\Documents\skeletonkey\rj\emuCfgs"
  SetOutPath $INSTDIR\rj\scrapeArt
  File "C:\Users\sudopinion\Documents\skeletonkey\rj\scrapeart\supported.set"
  File "C:\Users\sudopinion\Documents\skeletonkey\rj\scrapeart\*.7z"
  SetOutPath $INSTDIR\rj\KODI\AEL
  File "C:\Users\sudopinion\Documents\skeletonkey\rj\KODI\AEL\*.set"
  SetOutPath $INSTDIR\rj\ES
  File "C:\Users\sudopinion\Documents\skeletonkey\rj\ES\*.set"
  SetOutPath $INSTDIR
  WriteUninstaller "skeletonKey-uninst.exe"
  
  Nop ; for fun

SectionEnd

Section "!skeletonKey"

SectionIn RO

Call CSCTest

  ExecWait '"$INSTDIR\skeletonKey.exe"'
  Sleep 500
  BringToFront

SectionEnd

Function "CSCTest"
  
  CreateDirectory "$SMPROGRAMS\skeletonKey"
  SetOutPath $INSTDIR ; for working directory
  CreateShortCut "$SMPROGRAMS\skeletonKey\Uninstall skeletonKey.lnk" "$INSTDIR\skeletonKey-uninst.exe" ; use defaults for parameters, icon, etc.

FunctionEnd


;--------------------------------

; Uninstaller

UninstallText "This will uninstall skeletonKey. Hit next to continue."
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"

Section "Uninstall"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\skeletonKey"
  DeleteRegKey HKLM "SOFTWARE\skeletonKey"
  Delete "$DESKTOP\skeletonKey.lnk"
    Delete "$SMPROGRAMS\skeletonKey\*.*"
  RMDir "$SMPROGRAMS\skeletonKey"
  
  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to remove the directory $INSTDIR?" IDNO NoDelete
    Delete "$INSTDIR\*.*"
    RMDir /r "$INSTDIR" ; skipped if no
  NoDelete:
  

  IfFileExists "$INSTDIR" 0 NoErrorMsg
    MessageBox MB_OK "Note: $INSTDIR could not be removed!" IDOK 0 ; skipped if file doesn't exist
  NoErrorMsg:

SectionEnd
