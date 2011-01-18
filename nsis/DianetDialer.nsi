;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg
SetCompressor /SOLID lzma
CRCCheck on
XPStyle on
;--------------------------------
;Include Modern UI
  !include "MUI2.nsh"
;--------------------------------
;--------------------------------
;Include x64 Check
  !include "x64.nsh"
;--------------------------------
;General

  ;Name and file
  Name "Dianet Dialer Installer"
  OutFile "install1291.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\DIANET"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\DIANET" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define nsProcess::KillProcess `!insertmacro nsProcess::KillProcess`


;--------------------------------
;Pages

  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
!macro nsProcess::KillProcess _FILE _ERR
	nsProcess::_KillProcess /NOUNLOAD `${_FILE}`
	Pop ${_ERR}
!macroend
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "Russian"

;--------------------------------
;Installer Sections

Function .onInit
       ${nsProcess::KillProcess} "dianetdialer.exe" $R0
	   MessageBox MB_OK "Для установки обновления программа Dianet Dialer будет закрыта. После установки обновления запустите программу заного";    Errorlevel: [$R0]"
		
		${If} ${RunningX64}
        ${EnableX64FSRedirection}
		SetRegView 32
        ${EndIf}
FunctionEnd

Section Install

  SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  
  File "dianetdialer.exe"
  File "dianetdialer.exe.manifest"
  File "libeay32.dll"
  File "libssl32.dll"
  File "ssleay32.dll"
  File "msvcr90.dll"
  File "WS2_32.dll"

  CreateDirectory "$SMPROGRAMS\DIANET"
  CreateShortCut "$SMPROGRAMS\DIANET\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
  CreateDirectory "$SMPROGRAMS\DIANET"
  CreateShortcut "$SMPROGRAMS\DIANET\DianetDialer.lnk" "$INSTDIR\dianetdialer.exe"
  CreateShortcut "$DESKTOP\DianetDialer.lnk" "$INSTDIR\dianetdialer.exe"
  CreateShortcut "$SMPROGRAMS\DIANET\Uninstall.lnk" "$INSTDIR\Uninstall.exe"  
  
  ;Store installation folder
  WriteRegStr HKCU "Software\DIANET" "" $INSTDIR

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DIANET" "DisplayName" "Dianet Dialer"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DIANET" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
				 
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section Uninstall

  ;ADD YOUR OWN FILES HERE...
  Delete "$INSTDIR\dianetdialer.exe"
  Delete "$INSTDIR\dianetdialer.exe.manifest"
  Delete "$INSTDIR\libeay32.dll"
  Delete "$INSTDIR\libssl32.dll"
  Delete "$INSTDIR\ssleay32.dll"
  Delete "$INSTDIR\msvcr90.dll"
  Delete "$INSTDIR\WS2_32.dll"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  
  Delete "$SMPROGRAMS\DIANET\DianetDialer.lnk"
  Delete "$SMPROGRAMS\DIANET\Uninstall.lnk"
  Delete "$DESKTOP\DianetDialer.lnk"
  RMDir "$SMPROGRAMS\DIANET"

  DeleteRegKey HKCU "Software\DIANET"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DIANET"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "dianetdialer"

SectionEnd