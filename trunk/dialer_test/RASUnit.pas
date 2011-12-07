{$mode delphi}
unit RASUnit;

interface

uses Windows, SysUtils;

const
  RAS_MaxDeviceType = 16;
  RAS_MaxPhoneNumber = 128;
  RAS_MaxIpAddress = 15;
  RAS_MaxIpxAddress = 21;
  RAS_MaxEntryName = 256;
  RAS_MaxDeviceName = 128;
  RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
  RAS_MaxAreaCode = 10;
  RAS_MaxPadType = 32;
  RAS_MaxX25Address = 200;
  RAS_MaxFacilities = 200;
  RAS_MaxUserData = 200;
  RAS_MaxReplyMessage = 1024;
  RAS_MaxDnsSuffix = 256;
  RDEOPT_UsePrefixSuffix = $00000001;
  RDEOPT_PausedStates = $00000002;
  RDEOPT_IgnoreModemSpeaker = $00000004;
  RDEOPT_SetModemSpeaker = $00000008;
  RDEOPT_IgnoreSoftwareCompression = $00000010;
  RDEOPT_SetSoftwareCompression = $00000020;
  RDEOPT_DisableConnectedUI = $00000040;
  RDEOPT_DisableReconnectUI = $00000080;
  RDEOPT_DisableReconnect = $00000100;
  RDEOPT_NoUser = $00000200;
  RDEOPT_PauseOnScript = $00000400;
  RDEOPT_Router = $00000800;
  REN_User = $00000000;
  REN_AllUsers = $00000001;
  VS_Default = 0;
  VS_PptpOnly = 1;
  VS_PptpFirst = 2;
  VS_L2tpOnly = 3;
  VS_L2tpFirst = 4;
  RASDIALEVENT = 'RasDialEvent';
  WM_RASDIALEVENT = $CCCD;
  RASEO_UseCountryAndAreaCodes = $00000001;
  RASEO_SpecificIpAddr = $00000002;
  RASEO_SpecificNameServers = $00000004;
  RASEO_IpHeaderCompression = $00000008;
  RASEO_RemoteDefaultGateway = $00000010;
  RASEO_DisableLcpExtensions = $00000020;
  RASEO_TerminalBeforeDial = $00000040;
  RASEO_TerminalAfterDial = $00000080;
  RASEO_ModemLights = $00000100;
  RASEO_SwCompression = $00000200;
  RASEO_RequireEncryptedPw = $00000400;
  RASEO_RequireMsEncryptedPw = $00000800;
  RASEO_RequireDataEncryption = $00001000;
  RASEO_NetworkLogon = $00002000;
  RASEO_UseLogonCredentials = $00004000;
  RASEO_PromoteAlternates = $00008000;

  RASEO2_SecureFileAndPrint = $00000001;
  RASEO2_SecureClientForMSNet = $00000002;
  RASEO2_DontNegotiateMultilink = $00000004;
  RASEO2_DontUseRasCredentials = $00000008;
  RASEO2_UsePreSharedKey = $00000010;
  RASEO2_Internet = $00000020;
  RASEO2_DisableNbtOverIP = $00000040;
  RASEO2_UseGlobalDeviceSettings = $00000080;
  RASEO2_ReconnectIfDropped = $00000100;
  RASEO2_SharePhoneNumbers = $00000200;

  RASNP_NetBEUI = $00000001;
  RASNP_Ipx = $00000002;
  RASNP_Ip = $00000004;
  RASNP_Ipv6 = $00000008;
  RASFP_Ppp = $00000001;
  RASFP_Slip = $00000002;
  RASFP_Ras = $00000004;

  RASDT_Modem                     = 'modem';
  RASDT_Isdn                      = 'isdn';
  RASDT_X25                       = 'x25';
  RASDT_Vpn                       = 'vpn';
  RASDT_Pad                       = 'pad';
  RASDT_Generic                   = 'GENERIC';
  RASDT_Serial        		= 'SERIAL';
  RASDT_FrameRelay                = 'FRAMERELAY';
  RASDT_Atm                       = 'ATM';
  RASDT_Sonet                     = 'SONET';
  RASDT_SW56                      = 'SW56';
  RASDT_Irda                      = 'IRDA';
  RASDT_Parallel                  = 'PARALLEL';
  RASDT_PPPoE                     = 'PPPoE';

  RASET_Phone = 1;
  RASET_Vpn = 2;
  RASET_Direct = 3;
  RASET_Internet = 4;
  RASET_Broadband = 5;

  RASEO_SecureLocalFiles = $00010000;
  RASCN_Connection = $00000001;
  RASCN_Disconnection = $00000002;
  RASCN_BandwidthAdded = $00000004;
  RASCN_BandwidthRemoved = $00000008;
  RASEDM_DialAll = 1;
  RASEDM_DialAsNeeded = 2;
  RASIDS_Disabled = $ffffffff;
  RASIDS_UseGlobalValue = 0;
  RASADFLG_PositionDlg = $00000001;
  RASCM_UserName = $00000001;
  RASCM_Password = $00000002;
  RASCM_Domain = $00000004;
  RASADP_DisableConnectionQuery = 0;
  RASADP_LoginSessionDisable = 1;
  RASADP_SavedAddressesLimit = 2;
  RASADP_FailedConnectionTimeout = 3;
  RASADP_ConnectionQueryTimeout = 4;

  RDEOPT_CustomDial = $00001000;
  RASLCPAP_PAP = $C023;
  RASLCPAP_SPAP = $C027;
  RASLCPAP_CHAP = $C223;
  RASLCPAP_EAP = $C227;
  RASLCPAD_CHAP_MD5 = $05;
  RASLCPAD_CHAP_MS = $80;
  RASLCPAD_CHAP_MSV2 = $81;
  RASLCPO_PFC = $00000001;
  RASLCPO_ACFC = $00000002;
  RASLCPO_SSHF = $00000004;
  RASLCPO_DES_56 = $00000008;
  RASLCPO_3_DES = $00000010;
  RASCCPCA_MPPC = $00000006;
  RASCCPCA_STAC = $00000005;
  RASCCPO_Compression = $00000001;
  RASCCPO_HistoryLess = $00000002;
  RASCCPO_Encryption56bit = $00000010;
  RASCCPO_Encryption40bit = $00000020;
  RASCCPO_Encryption128bit = $00000040;
  RASEO_RequireEAP = $00020000;
  RASEO_RequirePAP = $00040000;
  RASEO_RequireSPAP = $00080000;
  RASEO_Custom = $00100000;
  RASEO_PreviewPhoneNumber = $00200000;
  RASEO_SharedPhoneNumbers = $00800000;
  RASEO_PreviewUserPw = $01000000;
  RASEO_PreviewDomain = $02000000;
  RASEO_ShowDialingProgress = $04000000;
  RASEO_RequireCHAP = $08000000;
  RASEO_RequireMsCHAP = $10000000;
  RASEO_RequireMsCHAP2 = $20000000;
  RASEO_RequireW95MSCHAP = $40000000;
  RASEO_CustomScript = $80000000;
  RASIPO_VJ = $00000001;
  RCD_SingleUser = 0;
  RCD_AllUsers = $00000001;
  RCD_Eap = $00000002;
  RASEAPF_NonInteractive = $00000002;
  RASEAPF_Logon = $00000004;
  RASEAPF_Preview = $00000008;
  ET_40Bit = 1;
  ET_128Bit = 2;
  ET_None = 0;
  ET_Require = 1;
  ET_RequireMax = 2;
  ET_Optional = 3;

  RASCS_PAUSED = $1000;
  RASCS_DONE = $2000;

type
  LUID = record
      LowPart:DWORD;
      HighPart:LONG;
  end;
  PLUID = ^LUID;
  LPLUID = PLUID;

  RASCONNSTATE = (
      RASCS_OpenPort = 0,
      RASCS_PortOpened,
      RASCS_ConnectDevice,
      RASCS_DeviceConnected,
      RASCS_AllDevicesConnected,
      RASCS_Authenticate,
      RASCS_AuthNotify,
      RASCS_AuthRetry,
      RASCS_AuthCallback,
      RASCS_AuthChangePassword,
      RASCS_AuthProject,
      RASCS_AuthLinkSpeed,
      RASCS_AuthAck,
      RASCS_ReAuthenticate,
      RASCS_Authenticated,
      RASCS_PrepareForCallback,
      RASCS_WaitForModemReset,
      RASCS_WaitForCallback,
      RASCS_Projected,
      RASCS_StartAuthentication,
      RASCS_CallbackComplete,
      RASCS_LogonNetwork,
      RASCS_SubEntryConnected,
      RASCS_SubEntryDisconnected,
      RASCS_Interactive = RASCS_PAUSED,
      RASCS_RetryAuthentication,
      RASCS_CallbackSetByCaller,
      RASCS_PasswordExpired,
      RASCS_InvokeEapUI,
      RASCS_Connected = RASCS_DONE,
      RASCS_Disconnected
  );
  PRASCONNSTATE = ^RASCONNSTATE;
  LPRASCONNSTATE = PRASCONNSTATE;

  RASPROJECTION = (
      RASP_Amb = $10000,
      RASP_PppNbf = $803F,
      RASP_PppIpx = $802B,
      RASP_PppIp = $8021,
      RASP_PppCcp = $80FD,
      RASP_PppLcp = $C021,
      RASP_Slip = $20000
  );
  PRASPROJECTION = ^RASPROJECTION;
  LPRASPROJECTION = PRASPROJECTION;

  //HRasConn  = Longint;
  PHRASCONN = ^HRasConn;
  LPHRASCONN = PHRASCONN;

  RASIPADDR = record
        a : BYTE;
        b : BYTE;
        c : BYTE;
        d : BYTE;
  end;
  PRASIPADDR = ^RASIPADDR;
  LPRASIPADDR = PRASIPADDR;

  RASDIALPARAMSW = record
      dwSize : DWORD;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of WCHAR;
      szPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of WCHAR;
      szCallbackNumber : array[0..(RAS_MaxCallbackNumber+1)-1] of WCHAR;
      szUserName : array[0..(UNLEN+1)-1] of WCHAR;
      szPassword : array[0..(PWLEN+1)-1] of WCHAR;
      szDomain : array[0..(DNLEN+1)-1] of WCHAR;
      //(WINVER >= 0x401)
      dwSubEntry : DWORD;
      dwCallbackId : ULONG_PTR;
  end;
  PRASDIALPARAMSW = ^RASDIALEXTENSIONS;
  LPRASDIALPARAMSW = PRASDIALPARAMSW;

  RASDIALPARAMS = RASDIALPARAMSW;
  PRASDIALPARAMS = ^RASDIALPARAMS;
  LPRASDIALPARAMS = PRASDIALPARAMS;

  RASDIALPARAMSA = record
      dwSize : DWORD;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of CHAR;
      szPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of CHAR;
      szCallbackNumber : array[0..(RAS_MaxCallbackNumber+1)-1] of CHAR;
      szUserName : array[0..(UNLEN+1)-1] of CHAR;
      szPassword : array[0..(PWLEN+1)-1] of CHAR;
      szDomain : array[0..(DNLEN+1)-1] of CHAR;
      dwSubEntry : DWORD;
      dwCallbackId : ULONG_PTR;
  end;
  PRASDIALPARAMSA = ^RASDIALPARAMSA;
  LPRASDIALPARAMSA = PRASDIALPARAMSA;

  RASEAPINFO = record
        dwSizeofEapInfo : DWORD;
        pbEapInfo : PBYTE;
  end;

  RASDIALEXTENSIONS = record
        dwSize : DWORD;
        dwfOptions : DWORD;
        hwndParent : HWND;
        reserved : ULONG_PTR;
        reserved1 : ULONG_PTR;
        RasEapInfo : RASEAPINFO;
  end;
  PRASDIALEXTENSIONS = ^RASDIALEXTENSIONS;
  LPRASDIALEXTENSIONS = PRASDIALEXTENSIONS;

  RASCONNA = record
      dwSize : DWORD;
      hrasconn : HRASCONN;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of CHAR;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of CHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of CHAR;
      szPhonebook : array[0..(MAX_PATH)-1] of CHAR;
      dwSubEntry : DWORD;
      guidEntry : GUID;
      dwFlags : DWORD;
      luid : LUID;
  end;
  PRASCONNA = ^RASCONNA;
  LPRASCONNA = PRASCONNA;

  RASCONNW = record
      dwSize : DWORD;
      hrasconn : HRASCONN;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of WideChar;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of WideChar;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of WideChar;
      szPhonebook : array[0..(MAX_PATH)-1] of WideChar;
      dwSubEntry : DWORD;
      guidEntry : GUID;
      dwFlags : DWORD;
      luid : LUID;
  end;
  PRASCONNW = ^RASCONNW;
  LPRASCONNW = PRASCONNW;

  RASCONN = RASCONNW;
  PRASCONN = ^RASCONN;
  LPRASCONN = PRASCONN;

  RASENTRYW = record
      dwSize : DWORD;
      dwfOptions : DWORD;
      dwCountryID : DWORD;
      dwCountryCode : DWORD;
      szAreaCode : array[0..(RAS_MaxAreaCode+1)-1] of WIDECHAR;
      szLocalPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of WIDECHAR;
      dwAlternateOffset : DWORD;
      ipaddr : RASIPADDR;
      ipaddrDns : RASIPADDR;
      ipaddrDnsAlt : RASIPADDR;
      ipaddrWins : RASIPADDR;
      ipaddrWinsAlt : RASIPADDR;
      dwFrameSize : DWORD;
      dwfNetProtocols : DWORD;
      dwFramingProtocol : DWORD;
      szScript : array[0..(MAX_PATH)-1] of WIDECHAR;
      szAutodialDll : array[0..(MAX_PATH)-1] of WIDECHAR;
      szAutodialFunc : array[0..(MAX_PATH)-1] of WIDECHAR;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of WIDECHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of WIDECHAR;
      szX25PadType : array[0..(RAS_MaxPadType+1)-1] of WIDECHAR;
      szX25Address : array[0..(RAS_MaxX25Address+1)-1] of WIDECHAR;
      szX25Facilities : array[0..(RAS_MaxFacilities+1)-1] of WIDECHAR;
      szX25UserData : array[0..(RAS_MaxUserData+1)-1] of WIDECHAR;
      dwChannels : DWORD;
      dwReserved1 : DWORD;
      dwReserved2 : DWORD;
      //(WINVER >= 0x401)
      dwSubEntries : DWORD;
      dwDialMode : DWORD;
      dwDialExtraPercent : DWORD;
      dwDialExtraSampleSeconds : DWORD;
      dwHangUpExtraPercent : DWORD;
      dwHangUpExtraSampleSeconds : DWORD;
      dwIdleDisconnectSeconds : DWORD;
      //(WINVER >= 0x500)
      dwType : DWORD;
      dwEncryptionType : DWORD;
      dwCustomAuthKey : DWORD;
      guidId : GUID;
      szCustomDialDll : array[0..(MAX_PATH)-1] of WIDECHAR;
      dwVpnStrategy : DWORD;
      //(WINVER >= 0x501)
      dwfOptions2 : DWORD;
      dwfOptions3 : DWORD;
      szDnsSuffix : array[0..(RAS_MaxDnsSuffix)-1] of WIDECHAR;
      dwTcpWindowSize : DWORD;
      szPrerequisitePbk : array[0..(MAX_PATH)-1] of WIDECHAR;
      szPrerequisiteEntry : array[0..(RAS_MaxEntryName+1)-1] of WIDECHAR;
      dwRedialCount : DWORD;
      dwRedialPause : DWORD;

    end;
  PRASENTRYW = ^RASENTRYW;
  LPRASENTRYW = PRASENTRYW;

  RASENTRY = RASENTRYW;
  PRASENTRY = ^RASENTRY;
  LPRASENTRY = PRASENTRY;

  RASENTRYA = record
        dwSize : DWORD;
        dwfOptions : DWORD;
        dwCountryID : DWORD;
        dwCountryCode : DWORD;
        szAreaCode : array[0..(RAS_MaxAreaCode+1)-1] of CHAR;
        szLocalPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of CHAR;
        dwAlternateOffset : DWORD;
        ipaddr : RASIPADDR;
        ipaddrDns : RASIPADDR;
        ipaddrDnsAlt : RASIPADDR;
        ipaddrWins : RASIPADDR;
        ipaddrWinsAlt : RASIPADDR;
        dwFrameSize : DWORD;
        dwfNetProtocols : DWORD;
        dwFramingProtocol : DWORD;
        szScript : array[0..(MAX_PATH)-1] of CHAR;
        szAutodialDll : array[0..(MAX_PATH)-1] of CHAR;
        szAutodialFunc : array[0..(MAX_PATH)-1] of CHAR;
        szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of CHAR;
        szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of CHAR;
        szX25PadType : array[0..(RAS_MaxPadType+1)-1] of CHAR;
        szX25Address : array[0..(RAS_MaxX25Address+1)-1] of CHAR;
        szX25Facilities : array[0..(RAS_MaxFacilities+1)-1] of CHAR;
        szX25UserData : array[0..(RAS_MaxUserData+1)-1] of CHAR;
        dwChannels : DWORD;
        dwReserved1 : DWORD;
        dwReserved2 : DWORD;
        dwSubEntries : DWORD;
        dwDialMode : DWORD;
        dwDialExtraPercent : DWORD;
        dwDialExtraSampleSeconds : DWORD;
        dwHangUpExtraPercent : DWORD;
        dwHangUpExtraSampleSeconds : DWORD;
        dwIdleDisconnectSeconds : DWORD;
        dwType : DWORD;
        dwEncryptionType : DWORD;
        dwCustomAuthKey : DWORD;
        guidId : GUID;
        szCustomDialDll : array[0..(MAX_PATH)-1] of CHAR;
        dwVpnStrategy : DWORD;
        dwfOptions2 : DWORD;
        dwfOptions3 : DWORD;
        szDnsSuffix : array[0..(RAS_MaxDnsSuffix)-1] of CHAR;
        dwTcpWindowSize : DWORD;
        szPrerequisitePbk : array[0..(MAX_PATH)-1] of CHAR;
        szPrerequisiteEntry : array[0..(RAS_MaxEntryName+1)-1] of CHAR;
        dwRedialCount : DWORD;
        dwRedialPause : DWORD;
      end;
  PRASENTRYA = ^RASENTRYA;
  LPRASENTRYA = PRASENTRYA;

  RASENTRYNAMEA = record
      dwSize : DWORD;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of CHAR;
      dwFlags : DWORD;
      szPhonebookPath : array[0..(MAX_PATH+1)-1] of CHAR;
    end;
  PRASENTRYNAMEA = ^RASENTRYNAMEA;
  LPRASENTRYNAMEA = PRASENTRYNAMEA;

  RASENTRYNAMEW = record
      dwSize : DWORD;
      szEntryName : array[0..(RAS_MaxEntryName+1)-1] of WCHAR;
      dwFlags : DWORD;
      szPhonebookPath : array[0..(MAX_PATH+1)-1] of WCHAR;
    end;
  PRASENTRYNAMEW = ^RASENTRYNAMEW;
  LPRASENTRYNAMEW = PRASENTRYNAMEW;

  RASENTRYNAME = RASENTRYNAMEW;
  PRASENTRYNAME = ^RASENTRYNAME;
  LPRASENTRYNAME = PRASENTRYNAME;

  RASCONNSTATUSA = record
      dwSize : DWORD;
      rasconnstate : RASCONNSTATE;
      dwError : DWORD;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of CHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of CHAR;
      szPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of CHAR;
    end;
  PRASCONNSTATUSA = ^RASCONNSTATUSA;
  LPRASCONNSTATUSA = PRASCONNSTATUSA;

  RASCONNSTATUSW = record
      dwSize : DWORD;
      rasconnstate : RASCONNSTATE;
      dwError : DWORD;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of WCHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of WCHAR;
      szPhoneNumber : array[0..(RAS_MaxPhoneNumber+1)-1] of WCHAR;
    end;
  PRASCONNSTATUSW = ^RASCONNSTATUSW;
  LPRASCONNSTATUSW = PRASCONNSTATUSW;

  RASCONNSTATUS = RASCONNSTATUSW;
  PRASCONNSTATUS = ^RASCONNSTATUS;
  LPRASCONNSTATUS = PRASCONNSTATUS;

  RASDEVINFOA = record
      dwSize : DWORD;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of CHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of CHAR;
    end;
  PRASDEVINFOA = ^RASDEVINFOA;
  LPRASDEVINFOA = PRASDEVINFOA;

  RASDEVINFOW = record
      dwSize : DWORD;
      szDeviceType : array[0..(RAS_MaxDeviceType+1)-1] of WCHAR;
      szDeviceName : array[0..(RAS_MaxDeviceName+1)-1] of WCHAR;
    end;
  PRASDEVINFOW = ^RASDEVINFOW;
  LPRASDEVINFOW = PRASDEVINFOW;

  RASDEVINFO = RASDEVINFOW;
  PRASDEVINFO = ^RASDEVINFO;
  LPRASDEVINFO = PRASDEVINFO;

  RASCTRYINFO = record
      dwSize : DWORD;
      dwCountryID : DWORD;
      dwNextCountryID : DWORD;
      dwCountryCode : DWORD;
      dwCountryNameOffset : DWORD;
    end;
  PRASCTRYINFO = ^RASCTRYINFO;
  LPRASCTRYINFO = PRASCTRYINFO;

  RASCTRYINFOW = RASCTRYINFO;
  PRASCTRYINFOW = ^RASCTRYINFOW;
  LPRASCTRYINFOW = PRASCTRYINFOW;

  RASCTRYINFOA = RASCTRYINFO;
  PRASCTRYINFOA = ^RASCTRYINFOA;
  LPRASCTRYINFOA = PRASCTRYINFOA;

  TRAS_STATS = record
    dwSize: DWORD;
    dwBytesXmited: DWORD;
    dwBytesRcved: DWORD;
    dwFramesXmited: DWORD;
    dwFramesRcved: DWORD;
    dwCrcErr: DWORD;
    dwTimeoutErr: DWORD;
    dwAlignmentErr: DWORD;
    dwHardwareOverrunErr: DWORD;
    dwFramingErr: DWORD;
    dwBufferOverrunErr: DWORD;
    dwCompressionRatioIn: DWORD;
    dwCompressionRatioOut: DWORD;
    dwBps: DWORD;
    dwConnectDuration: DWORD;
  end;
  PRAS_STATS = ^TRAS_STATS;

 {* External RAS API function prototypes.
 *}
 {Note: for Delphi the function without 'A' or 'W' is the Ansi one
   as on the other Delphi headers}

 function RasDialA(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
                   var params: RasDialParamsA; dwNotifierType: Longint;
                   lpNotifier: Pointer; var rasconn: HRasConn): Longint; stdcall;
 function RasDialW(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PWideChar;
                   var params: RasDialParamsW; dwNotifierType: Longint;
                   lpNotifier: Pointer; var rasconn: HRasConn): Longint; stdcall;
 function RasDial(lpRasDialExt: LPRasDialExtensions; lpszPhoneBook: PAnsiChar;
                  var params: RasDialParams; dwNotifierType: Longint;
                  lpNotifier: Pointer; var rasconn: HRasConn): Longint; stdcall;

 function RasEnumConnectionsA(RasConnArray: LPRasConnA; var lpcb: Longint;
                              var lpcConnections: Longint): Longint; stdcall;
 function RasEnumConnectionsW(RasConnArray: LPRasConnW; var lpcb: Longint;
                              var lpcConnections: Longint): Longint; stdcall;
 function RasEnumConnections(RasConnArray: LPRasConn; var lpcb: Longint;
                              var lpcConnections: Longint): Longint; stdcall;

 function RasEnumEntriesA(Reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
                          entrynamesArray: LPRasEntryNameA; var lpcb: Longint;
                          var lpcEntries: Longint): Longint; stdcall;
 function RasEnumEntriesW(reserved: PWideChar; lpszPhoneBook: PWideChar;
                          entrynamesArray: LPRasEntryNameW; var lpcb: Longint;
                          var lpcEntries: Longint): Longint; stdcall;
 function RasEnumEntries(reserved: PAnsiChar; lpszPhoneBook: PAnsiChar;
                         entrynamesArray: LPRasEntryName; var lpcb: Longint;
                         var lpcEntries: Longint): Longint; stdcall;

 function RasGetConnectStatusA(hConn: HRasConn; var lpStatus: RasConnStatusA): Longint; stdcall;
 function RasGetConnectStatusW(hConn: HRasConn;var lpStatus: RasConnStatusW): Longint; stdcall;
 function RasGetConnectStatus(hConn: HRasConn;var lpStatus: RasConnStatus): Longint; stdcall;

 function RasGetErrorStringA(errorValue: Integer;erroString: PAnsiChar;cBufSize: Longint): Longint; stdcall;
 function RasGetErrorStringW(errorValue: Integer;erroString: PWideChar;cBufSize: Longint): Longint; stdcall;
 function RasGetErrorString(errorValue: Integer;erroString: PChar;cBufSize: Longint): Longint; stdcall;

 function RasHangUpA(hConn: HRasConn): Longint; stdcall;
 function RasHangUpW(hConn: HRasConn): Longint; stdcall;
 function RasHangUp(hConn: HRasConn): Longint; stdcall;

 function RasGetProjectionInfoA(hConn: HRasConn; rasproj: RasProjection;
                                lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;
 function RasGetProjectionInfoW(hConn: HRasConn; rasproj: RasProjection;
                                lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;
 function RasGetProjectionInfo(hConn: HRasConn; rasproj: RasProjection;
                               lpProjection: Pointer; var lpcb: Longint): Longint; stdcall;

 function RasCreatePhonebookEntryA(hwndParentWindow: HWND;lpszPhoneBook: PAnsiChar): Longint; stdcall;
 function RasCreatePhonebookEntryW(hwndParentWindow: HWND;lpszPhoneBook: PWideChar): Longint; stdcall;
 function RasCreatePhonebookEntry(hwndParentWindow: HWND;lpszPhoneBook: PAnsiChar): Longint; stdcall;

 function RasEditPhonebookEntryA(hwndParentWindow: HWND; lpszPhoneBook: PAnsiChar;
                                 lpszEntryName: PAnsiChar): Longint; stdcall;
 function RasEditPhonebookEntryW(hwndParentWindow: HWND; lpszPhoneBook: PWideChar;
                                 lpszEntryName: PWideChar): Longint; stdcall;
 function RasEditPhonebookEntry(hwndParentWindow: HWND; lpszPhoneBook: PAnsiChar;
                                lpszEntryName: PAnsiChar): Longint; stdcall;

 function RasSetEntryDialParamsA(lpszPhoneBook: PAnsiChar; var lpDialParams: RasDialParamsA;
                                 fRemovePassword: LongBool): Longint; stdcall;
 function RasSetEntryDialParamsW(lpszPhoneBook: PWideChar; var lpDialParams: RasDialParamsW;
                                 fRemovePassword: LongBool): Longint; stdcall;
 function RasSetEntryDialParams(lpszPhoneBook: PAnsiChar; var lpDialParams: RasDialParams;
                                fRemovePassword: LongBool): Longint; stdcall;

 function RasGetEntryDialParamsA(lpszPhoneBook: PAnsiChar; var lpDialParams: RasDialParamsA;
                                 var lpfPassword: LongBool): Longint; stdcall;
 function RasGetEntryDialParamsW(lpszPhoneBook: PWideChar; var lpDialParams: RasDialParamsW;
                                 var lpfPassword: LongBool): Longint; stdcall;
 function RasGetEntryDialParams(lpszPhoneBook: PAnsiChar; var lpDialParams: RasDialParams;
                                var lpfPassword: LongBool): Longint; stdcall;

 const
   RASBASE = 600;
   SUCCESS = 0;

PENDING =600;
ERROR_INVALID_PORT_HANDLE =601;
ERROR_PORT_ALREADY_OPEN =602;
ERROR_BUFFER_TOO_SMALL =603;
ERROR_WRONG_INFO_SPECIFIED =604;
ERROR_CANNOT_SET_PORT_INFO =605;
ERROR_PORT_NOT_CONNECTED =606;
ERROR_EVENT_INVALID =607;
ERROR_DEVICE_DOES_NOT_EXIST =608;
ERROR_DEVICETYPE_DOES_NOT_EXIST =609;
ERROR_BUFFER_INVALID =610;
ERROR_ROUTE_NOT_AVAILABLE =611;
ERROR_ROUTE_NOT_ALLOCATED =612;
ERRERROR_INVALID_COMPRESSION_SPECIFIED =613;
ERROR_OUT_OF_BUFFERS =614;
ERROR_PORT_NOT_FOUND =615;
ERROR_ASYNC_REQUEST_PENDING =616;
ERROR_ALREADY_DISCONNECTING =617;
ERROR_PORT_NOT_OPEN =618;
ERROR_PORT_DISCONNECTED =619;
ERROR_NO_ENDPOINTS =620;
ERROR_CANNOT_OPEN_PHONEBOOK =621;
ERROR_CANNOT_LOAD_PHONEBOOK =622;
ERROR_CANNOT_FIND_PHONEBOOK_ENTRY =623;
ERROR_CANNOT_WRITE_PHONEBOOK =624;
ERROR_CORRUPT_PHONEBOOK =625;
ERROR_CANNOT_LOAD_STRING =626;
ERROR_KEY_NOT_FOUND =627;
ERROR_DISCONNECTION =628;
ERROR_REMOTE_DISCONNECTION =629;
ERROR_HARDWARE_FAILURE =630;
ERROR_USER_DISCONNECTION =631;
ERROR_INVALID_SIZE =632;
ERROR_PORT_NOT_AVAILABLE =633;
ERROR_CANNOT_PROJECT_CLIENT =634;
ERROR_UNKNOWN =635;
ERROR_WRONG_DEVICE_ATTACHED =636;
ERROR_BAD_STRING =637;
ERROR_REQUEST_TIMEOUT =638;
ERROR_CANNOT_GET_LANA =639;
ERROR_NETBIOS_ERROR =640;
ERROR_SERVER_OUT_OF_RESOURCES =641;
ERROR_NAME_EXISTS_ON_NET =642;
ERROR_SERVER_GENERAL_NET_FAILURE =643;
WARNING_MSG_ALIAS_NOT_ADDED =644;
ERROR_AUTH_INTERNAL =645;
ERROR_RESTRICTED_LOGON_HOURS =646;
ERROR_ACCT_DISABLED =647;
ERROR_PASSWD_EXPIRED =648;
ERROR_NO_DIALIN_PERMISSION =649;
ERROR_SERVER_NOT_RESPONDING =650;
ERROR_FROM_DEVICE =651;
ERROR_UNRECOGNIZED_RESPONSE =652;
ERROR_MACRO_NOT_FOUND =652;
ERROR_MACRO_NOT_DEFINED =654;
ERROR_MESSAGE_MACRO_NOT_FOUND =655;
ERROR_DEFAULTOFF_MACRO_NOT_FOUND =656;
ERROR_FILE_COULD_NOT_BE_OPENED =657;
ERROR_DEVICENAME_TOO_LONG =658;
ERROR_DEVICENAME_NOT_FOUND =659;
ERROR_NO_RESPONSES =660;
ERROR_NO_COMMAND_FOUND =661;
ERROR_WRONG_KEY_SPECIFIED =662;
ERROR_UNKNOWN_DEVICE_TYPE =663;
ERROR_ALLOCATING_MEMORY =664;
ERROR_PORT_NOT_CONFIGURED =665;
ERROR_DEVICE_NOT_READY =666;
ERROR_READING_INI_FILE =667;
ERROR_NO_CONNECTION =668;
ERROR_BAD_USAGE_IN_INI_FILE =669;
ERROR_READING_SECTIONNAME =670;
ERROR_READING_DEVICETYPE =671;
ERROR_READING_DEVICENAME =672;
ERROR_READING_USAGE =673;
ERROR_READING_MAXCONNECTBPS =674;
ERROR_READING_MAXCARRIERBPS =675;
ERROR_LINE_BUSY =676;
ERROR_VOICE_ANSWER =677;
ERROR_NO_ANSWER =678;
ERROR_NO_CARRIER =679;
ERROR_NO_DIALTONE =680;
ERROR_IN_COMMAND =681;
ERROR_WRITING_SECTIONNAME =682;
ERROR_WRITING_DEVICETYPE =683;
ERROR_WRITING_DEVICENAME =684;
ERROR_WRITING_MAXCONNECTBPS =685;
ERROR_WRITING_MAXCARRIERBPS =686;
ERROR_WRITING_USAGE =687;
ERROR_WRITING_DEFAULTOFF =688;
ERROR_READING_DEFAULTOFF =689;
ERROR_EMPTY_INI_FILE =690;
ERROR_AUTHENTICATION_FAILURE =691;
ERROR_PORT_OR_DEVICE =692;
ERROR_NOT_BINARY_MACRO =693;
ERROR_DCB_NOT_FOUND =694;
ERROR_STATE_MACHINES_NOT_STARTED =695;
ERROR_STATE_MACHINES_ALREADY_STARTED =696;
ERROR_PARTIAL_RESPONSE_LOOPING =697;
ERROR_UNKNOWN_RESPONSE_KEY =698;
ERROR_RECV_BUF_FULL =699;
ERROR_CMD_TOO_LONG =700;
ERROR_UNSUPPORTED_BPS =701;
ERROR_UNEXPECTED_RESPONSE =702;
ERROR_INTERACTIVE_MODE =703;
ERROR_BAD_CALLBACK_NUMBER =704;
ERROR_INVALID_AUTH_STATE =705;
ERROR_WRITING_INITBPS =706;
ERROR_X25_DIAGNOSTIC =707;
ERROR_ACCT_EXPIRED =708;
ERROR_CHANGING_PASSWORD =709;
ERROR_OVERRUN =710;
ERROR_RASMAN_CANNOT_INITIALIZE =711;
ERROR_BIPLEX_PORT_NOT_AVAILABLE =712;
ERROR_NO_ACTIVE_ISDN_LINES =713;
ERROR_NO_ISDN_CHANNELS_AVAILABLE =714;
ERROR_TOO_MANY_LINE_ERRORS =715;
ERROR_IP_CONFIGURATION =716;
ERROR_NO_IP_ADDRESSES =717;
ERROR_PPP_TIMEOUT =718;
ERROR_PPP_REMOTE_TERMINATED =719;
ERROR_PPP_NO_PROTOCOLS_CONFIGURED =720;
ERROR_PPP_NO_RESPONSE =721;
ERROR_PPP_INVALID_PACKET =722;
ERROR_PHONE_NUMBER_TOO_LONG =723;
ERROR_IPXCP_NO_DIALOUT_CONFIGURED =724;
ERROR_IPXCP_NO_DIALIN_CONFIGURED =725;
ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE =726;
ERROR_ACCESSING_TCPCFGDLL =727;
ERROR_NO_IP_RAS_ADAPTER =728;
ERROR_SLIP_REQUIRES_IP =729;
ERROR_PROJECTION_NOT_COMPLETE =730;
ERROR_PROTOCOL_NOT_CONFIGURED =731;
ERROR_PPP_NOT_CONVERGING =732;
ERROR_PPP_CP_REJECTED =733;
ERROR_PPP_LCP_TERMINATED =734;
ERROR_PPP_REQUIRED_ADDRESS_REJECTED =735;
ERROR_PPP_NCP_TERMINATED =736;
ERROR_PPP_LOOPBACK_DETECTED =737;
ERROR_PPP_NO_ADDRESS_ASSIGNED =738;
ERROR_CANNOT_USE_LOGON_CREDENTIALS =739;
ERROR_TAPI_CONFIGURATION =740;
ERROR_NO_LOCAL_ENCRYPTION =741;
ERROR_NO_REMOTE_ENCRYPTION =742;
ERROR_REMOTE_REQUIRES_ENCRYPTION =743;
ERROR_IPXCP_NET_NUMBER_CONFLICT =744;
ERROR_INVALID_SMM =745;
ERROR_SMM_UNINITIALIZED =746;
ERROR_NO_MAC_FOR_PORT =747;
ERROR_SMM_TIMEOUT =748;
ERROR_BAD_PHONE_NUMBER =749;
ERROR_WRONG_MODULE =750;
ERROR_INVALID_CALLBACK_NUMBER =751;
ERROR_SCRIPT_SYNTAX =752;
ERROR_HANGUP_FAILED =753;
ERROR_BUNDLE_NOT_FOUND =754;
ERROR_CANNOT_DO_CUSTOMDIAL =755;
ERROR_DIAL_ALREADY_IN_PROGRESS =756;
ERROR_RASAUTO_CANNOT_INITIALIZE =757;
ERROR_CONNECTION_ALREADY_SHARED =758;
ERROR_SHARING_CHANGE_FAILED =759;
ERROR_SHARING_ROUTER_INSTALL =760;
ERROR_SHARE_CONNECTION_FAILED =761;
ERROR_SHARING_PRIVATE_INSTALL64 =762;
ERROR_CANNOT_SHARE_CONNECTION =763;
ERROR_NO_SMART_CARD_READER =764;
ERROR_SHARING_ADDRESS_EXISTS =765;
ERROR_NO_CERTIFICATE =766;
ERROR_SHARING_MULTIPLE_ADDRESSES =767;
ERROR_FAILED_TO_ENCRYPT =768;
ERROR_BAD_ADDRESS_SPECIFIED =769;
ERROR_CONNECTION_REJECT =770;
ERROR_CONGESTION =771;
ERROR_INCOMPATIBLE =772;
ERROR_NUMBERCHANGED =773;
ERROR_TEMPFAILURE =774;
ERROR_BLOCKED =775;
ERROR_DONOTDISTURB =776;
ERROR_OUTOFORDER =777;
ERROR_UNABLE_TO_AUTHENTICATE_SERVER =778;
ERROR_SMART_CARD_REQUIRED =779;
ERROR_INVALID_FUNCTION_FOR_ENTRY =780;
ERROR_CERT_FOR_ENCRYPTION_NOT_FOUND =781;
ERROR_SHARING_RRAS_CONFLICT =782;
ERROR_SHARING_NO_PRIVATE_LAN =783;
ERROR_NO_DIFF_USER_AT_LOGON =784;
ERROR_NO_REG_CERT_AT_LOGON =785;
ERROR_OAKLEY_NO_CERT =786;
ERROR_OAKLEY_AUTH_FAIL =787;
ERROR_OAKLEY_ATTRIB_FAIL =788;
ERROR_OAKLEY_GENERAL_PROCESSING =789;
ERROR_OAKLEY_NO_PEER_CERT =790;
ERROR_OAKLEY_NO_POLICY =791;
ERROR_OAKLEY_TIMED_OUT =792;
ERROR_OAKLEY_ERROR =793;
ERROR_UNKNOWN_FRAMED_PROTOCOL =794;
ERROR_WRONG_TUNNEL_TYPE =795;
ERROR_UNKNOWN_SERVICE_TYPE =796;
ERROR_CONNECTING_DEVICE_NOT_FOUND =797;
ERROR_NO_EAPTLS_CERTIFICATE =798;
ERROR_SHARING_HOST_ADDRESS_CONFLICT =799;
ERROR_AUTOMATIC_VPN_FAILED =800;
ERROR_VALIDATING_SERVER_CERT =801;
ERROR_READING_SCARD =802;
ERROR_INVALID_PEAP_COOKIE_CONFIG =803;
ERROR_INVALID_PEAP_COOKIE_USER =804;
ERROR_INVALID_MSCHAPV2_CONFIG =805;
ERROR_VPN_GRE_BLOCKED =806;
ERROR_VPN_DISCONNECT =807;
ERROR_VPN_REFUSED =808;
ERROR_VPN_TIMEOUT =809;
ERROR_VPN_BAD_CERT =810;
ERROR_VPN_BAD_PSK =811;
ERROR_SERVER_POLICY =812;
ERROR_BROADBAND_ACTIVE =813;
ERROR_BROADBAND_NO_NIC =814;
ERROR_BROADBAND_TIMEOUT =815;
ERROR_FEATURE_DEPRECATED =816;
ERROR_CANNOT_DELETE =817;
ERROR_RASQEC_RESOURCE_CREATION_FAILED =818;
ERROR_RASQEC_NAPAGENT_NOT_ENABLED =819;
ERROR_RASQEC_NAPAGENT_NOT_CONNECTED =820;
ERROR_RASQEC_CONN_DOESNOTEXIST =821;
ERROR_RASQEC_TIMEOUT =822;
ERROR_PEAP_CRYPTOBINDING_INVALID =823;
ERROR_PEAP_CRYPTOBINDING_NOTRECEIVED =824;
ERROR_INVALID_VPNSTRATEGY =825;
ERROR_EAPTLS_CACHE_CREDENTIALS_INVALID =826;
ERROR_IPSEC_SERVICE_STOPPED =827;
ERROR_IDLE_TIMEOUT =828;
ERROR_LINK_FAILURE =829;
ERROR_USER_LOGOFF =830;
ERROR_FAST_USER_SWITCH =831;
ERROR_HIBERNATION =832;
ERROR_SYSTEM_SUSPENDED =833;
ERROR_RASMAN_SERVICE_STOPPED =834;
ERROR_INVALID_SERVER_CERT =835;
ERROR_NOT_NAP_CAPABLE =836;
ERROR_INVALID_TUNNELID =837;
ERROR_UPDATECONNECTION_REQUEST_IN_PROCESS =838;
ERROR_PROTOCOL_ENGINE_DISABLED =839;
ERROR_INTERNAL_ADDRESS_FAILURE =840;
ERROR_FAILED_CP_REQUIRED =841;
ERROR_TS_UNACCEPTABLE =842;
ERROR_MOBIKE_DISABLED =843;
ERROR_CANNOT_INITIATE_MOBIKE_UPDATE =844;
ERROR_PEAP_SERVER_REJECTED_CLIENT_TLV =845;
ERROR_INVALID_PREFERENCES =846;
ERROR_EAPTLS_SCARD_CACHE_CREDENTIALS_INVALID =847;
ERROR_ROUTER_STOPPED =900;
ERROR_ALREADY_CONNECTED =901;
ERROR_UNKNOWN_PROTOCOL_ID =902;
ERROR_DDM_NOT_RUNNING =903;
ERROR_INTERFACE_ALREADY_EXISTS =904;
ERROR_NO_SUCH_INTERFACE =905;
ERROR_INTERFACE_NOT_CONNECTED =906;
ERROR_PROTOCOL_STOP_PENDING =907;
ERROR_INTERFACE_CONNECTED =908;
ERROR_NO_INTERFACE_CREDENTIALS_SET =909;
ERROR_ALREADY_CONNECTING =910;
ERROR_UPDATE_IN_PROGRESS =911;
ERROR_INTERFACE_CONFIGURATION =912;
ERROR_NOT_CLIENT_PORT =913;
ERROR_NOT_ROUTER_PORT =914;
ERROR_CLIENT_INTERFACE_ALREADY_EXISTS =915;
ERROR_INTERFACE_DISABLED =916;
ERROR_AUTH_PROTOCOL_REJECTED =917;
ERROR_NO_AUTH_PROTOCOL_AVAILABLE =918;
ERROR_PEER_REFUSED_AUTH =919;
ERROR_REMOTE_NO_DIALIN_PERMISSION =920;
ERROR_REMOTE_PASSWD_EXPIRED =921;
ERROR_REMOTE_ACCT_DISABLED =922;
ERROR_REMOTE_RESTRICTED_LOGON_HOURS =923;
ERROR_REMOTE_AUTHENTICATION_FAILURE =924;
ERROR_INTERFACE_HAS_NO_DEVICES =925;
ERROR_IDLE_DISCONNECTED =926;
ERROR_INTERFACE_UNREACHABLE =927;
ERROR_SERVICE_IS_PAUSED =928;
ERROR_INTERFACE_DISCONNECTED =929;
ERROR_AUTH_SERVER_TIMEOUT =930;
ERROR_PORT_LIMIT_REACHED =931;
ERROR_PPP_SESSION_TIMEOUT =932;
ERROR_MAX_LAN_INTERFACE_LIMIT =933;
ERROR_MAX_WAN_INTERFACE_LIMIT =934;
ERROR_MAX_CLIENT_INTERFACE_LIMIT =935;
ERROR_BAP_DISCONNECTED =936;
ERROR_USER_LIMIT =937;
ERROR_NO_RADIUS_SERVERS =938;
ERROR_INVALID_RADIUS_RESPONSE =939;
ERROR_DIALIN_HOURS_RESTRICTION =940;
ERROR_ALLOWED_PORT_TYPE_RESTRICTION =941;
ERROR_AUTH_PROTOCOL_RESTRICTION =942;
ERROR_BAP_REQUIRED =943;
ERROR_DIALOUT_HOURS_RESTRICTION =944;
ERROR_ROUTER_CONFIG_INCOMPATIBLE =945;
WARNING_NO_MD5_MIGRATION =946;
ERROR_PROTOCOL_ALREADY_INSTALLED =948;
ERROR_INVALID_SIGNATURE_LENGTH =949;
ERROR_INVALID_SIGNATURE =950;
ERROR_NO_SIGNATURE =951;
ERROR_INVALID_PACKET_LENGTH_OR_ID =952;
ERROR_INVALID_ATTRIBUTE_LENGTH =953;
ERROR_INVALID_PACKET =954;
ERROR_AUTHENTICATOR_MISMATCH =955;
ERROR_REMOTEACCESS_NOT_CONFIGURED =956;

 (* RAS functions found in RNAPH.DLL *)
 function RasValidateEntryNameA(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
 function RasValidateEntryNameW(lpszPhonebook,szEntry: PWideChar): Longint; stdcall;
// function RasValidateEntryName(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;

 function RasRenameEntryA(lpszPhonebook,szEntryOld,szEntryNew: PAnsiChar): Longint; stdcall;
 function RasRenameEntryW(lpszPhonebook,szEntryOld,szEntryNew: PWideChar): Longint; stdcall;
// function RasRenameEntry(lpszPhonebook,szEntryOld,szEntryNew: PAnsiChar): Longint; stdcall;

 function RasDeleteEntryA(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;
 function RasDeleteEntryW(lpszPhonebook,szEntry: PWideChar): Longint; stdcall;
// function RasDeleteEntry(lpszPhonebook,szEntry: PAnsiChar): Longint; stdcall;

 function RasGetEntryPropertiesA(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
                                 var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
                                 var lpdwDeviceInfoSize: Longint): Longint; stdcall;
 function RasGetEntryPropertiesW(lpszPhonebook, szEntry: PWideChar; lpbEntry: Pointer;
                                 var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
                                 var lpdwDeviceInfoSize: Longint): Longint; stdcall;
// function RasGetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
//                                 var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
//                                 var lpdwDeviceInfoSize: Longint): Longint; stdcall;

 function RasSetEntryPropertiesA(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
                                 dwEntrySize: Longint; lpbDeviceInfo: Pointer;
                                 dwDeviceInfoSize: Longint): Longint; stdcall;
 function RasSetEntryPropertiesW(lpszPhonebook, szEntry: PWideChar; lpbEntry: Pointer;
                                 dwEntrySize: Longint; lpbDeviceInfo: Pointer;
                                 dwDeviceInfoSize: Longint): Longint; stdcall;
// function RasSetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
//                                dwEntrySize: Longint; lpbDeviceInfo: Pointer;
//                                dwDeviceInfoSize: Longint): Longint; stdcall;

 function RasGetCountryInfoA(var lpCtryInfo: RasCtryInfo;var lpdwSize: Longint): Longint; stdcall;
 function RasGetCountryInfoW(var lpCtryInfo: RasCtryInfo;var lpdwSize: Longint): Longint; stdcall;
// function RasGetCountryInfo(var lpCtryInfo: RasCtryInfo;var lpdwSize: Longint): Longint; stdcall;

 function RasEnumDevicesA(lpBuff: LpRasDevInfoA; var lpcbSize: Longint;
                          var lpcDevices: Longint): Longint; stdcall;
 function RasEnumDevicesW(lpBuff: LpRasDevInfoW; var lpcbSize: Longint;
                          var lpcDevices: Longint): Longint; stdcall;
// function RasEnumDevices(lpBuff: LpRasDevInfo; var lpcbSize: Longint;
//                          var lpcDevices: Longint): Longint; stdcall;

function RasConnectionNotification(hConn:HRASCONN;hEvent:HANDLE;dwFlags:DWORD):Longint;stdcall;
function RasGetConnectionStatistics (hCONN:HRASCONN; RAS_STATS:PRAS_STATS):DWORD;stdcall;
function RasClearConnectionStatistics(hCONN:HRASCONN):DWORD;stdcall;

implementation

function RasCreatePhonebookEntryA; external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasCreatePhonebookEntryW; external 'rasapi32.dll' name 'RasCreatePhonebookEntryW';
function RasCreatePhonebookEntry;  external 'rasapi32.dll' name 'RasCreatePhonebookEntryA';
function RasDialA;                 external 'rasapi32.dll' name 'RasDialA';
function RasDialW;                 external 'rasapi32.dll' name 'RasDialW';
function RasDial;                  external 'rasapi32.dll' name 'RasDialA';
function RasEditPhonebookEntryA;   external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEditPhonebookEntryW;   external 'rasapi32.dll' name 'RasEditPhonebookEntryW';
function RasEditPhonebookEntry;    external 'rasapi32.dll' name 'RasEditPhonebookEntryA';
function RasEnumConnectionsA;      external 'rasapi32.dll' name 'RasEnumConnectionsA';
function RasEnumConnectionsW;      external 'rasapi32.dll' name 'RasEnumConnectionsW';
function RasEnumConnections;       external 'rasapi32.dll' name 'RasEnumConnectionsA';
function RasEnumEntriesA;          external 'rasapi32.dll' name 'RasEnumEntriesA';
function RasEnumEntriesW;          external 'rasapi32.dll' name 'RasEnumEntriesW';
function RasEnumEntries;           external 'rasapi32.dll' name 'RasEnumEntriesA';
function RasGetConnectStatusA;     external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetConnectStatusW;     external 'rasapi32.dll' name 'RasGetConnectStatusW';
function RasGetConnectStatus;      external 'rasapi32.dll' name 'RasGetConnectStatusA';
function RasGetEntryDialParamsA;   external 'rasapi32.dll' name 'RasGetEntryDialParamsA';
function RasGetEntryDialParamsW;   external 'rasapi32.dll' name 'RasGetEntryDialParamsW';
function RasGetEntryDialParams;    external 'rasapi32.dll' name 'RasGetEntryDialParamsA';
function RasGetErrorStringA;       external 'rasapi32.dll' name 'RasGetErrorStringA';
function RasGetErrorStringW;       external 'rasapi32.dll' name 'RasGetErrorStringW';
function RasGetErrorString;        external 'rasapi32.dll' name 'RasGetErrorStringA';
function RasGetProjectionInfoA;    external 'rasapi32.dll' name 'RasGetProjectionInfoA';
function RasGetProjectionInfoW;    external 'rasapi32.dll' name 'RasGetProjectionInfoW';
function RasGetProjectionInfo;     external 'rasapi32.dll' name 'RasGetProjectionInfoA';
function RasHangUpA;               external 'rasapi32.dll' name 'RasHangUpA';
function RasHangUpW;               external 'rasapi32.dll' name 'RasHangUpW';
function RasHangUp;                external 'rasapi32.dll' name 'RasHangUpA';
function RasSetEntryDialParamsA;   external 'rasapi32.dll' name 'RasSetEntryDialParamsA';
function RasSetEntryDialParamsW;   external 'rasapi32.dll' name 'RasSetEntryDialParamsW';
function RasSetEntryDialParams;    external 'rasapi32.dll' name 'RasSetEntryDialParamsA';
function RasValidateEntryNameA;  external 'rasapi32.dll' name 'RasValidateEntryNameA';
function RasValidateEntryNameW;  external 'rasapi32.dll' name 'RasValidateEntryNameW';
function RasRenameEntryA;        external 'rasapi32.dll' name 'RasRenameEntryA';
function RasRenameEntryW;        external 'rasapi32.dll' name 'RasRenameEntryW';
function RasDeleteEntryA;        external 'rasapi32.dll' name 'RasDeleteEntryA';
function RasDeleteEntryW;        external 'rasapi32.dll' name 'RasDeleteEntryW';
function RasGetEntryPropertiesA; external 'rasapi32.dll' name 'RasGetEntryPropertiesA';
function RasGetEntryPropertiesW; external 'rasapi32.dll' name 'RasGetEntryPropertiesW';
function RasSetEntryPropertiesA; external 'rasapi32.dll' name 'RasSetEntryPropertiesA';
function RasSetEntryPropertiesW; external 'rasapi32.dll' name 'RasSetEntryPropertiesW';
function RasGetCountryInfoA;     external 'rasapi32.dll' name 'RasGetCountryInfoA';
function RasGetCountryInfoW;     external 'rasapi32.dll' name 'RasGetCountryInfoW';
function RasEnumDevicesA;        external 'rasapi32.dll' name 'RasEnumDevicesA';
function RasEnumDevicesW;        external 'rasapi32.dll' name 'RasEnumDevicesW';


function RasConnectionNotification;external 'rasapi32.dll' name 'RasConnectionNotificationW';
function RasGetConnectionStatistics;external 'rasapi32.dll' name 'RasGetConnectionStatistics';
function RasClearConnectionStatistics;external 'rasapi32.dll' name 'RasClearConnectionStatistics';
end.
