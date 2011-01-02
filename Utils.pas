unit Utils;

{$mode objfpc}{$H+}
//{$define DEBUG}

interface

uses
  Classes, SysUtils, Windows, lnet, lhttp, lHTTPUtil, lnetSSL, WinInet, XMLRead, DOM, Forms,
  RASUnit, jwaiptypes, JwaIpHlpApi;

const
  PERENOS = Char($0D)+Char($0A);
  DIASTR = 'ДИАНЭТ'+PERENOS;
  DIANETSTR = 'ДИАНЭТ';
  AUTHOR = 'Derwin';
  DIANET = 'Dianet_PPP';
  DIANET_SITE = 'http://dianet.info';

  MIN_CONN_TYPE = 0;
  VPN = 0;
  PPPoE = 1;
  VPN_POLI = 2;
  MAX_CONN_TYPE = 2;

  VPN_IP ='vpn.dianet.info';
  {$ifndef DEBUG}
  VPN_IP_POLI ='172.16.21.254';
  {$else}
  VPN_IP_POLI ='78.109.128.5';
  {$endif}

  VERSION = '2.0.0.0 (alpha)';

  RETRAKER_URL = 'http://start.dianet.info';

function UpdateLayeredWindow(Handle: THandle; hdcDest: HDC; pptDst: PPoint; _psize: PSize; hdcSrc: HDC; pptSrc: PPoint; crKey: COLORREF; pblend: PBLENDFUNCTION; dwFlags: DWORD): Boolean; stdcall; external 'user32' name 'UpdateLayeredWindow';
procedure DelRoute(route:string);
procedure AddRoute(ip,mask,router:string);
function checkVPN(ip:String):boolean;

type

  TIpAddr = record
    a,b,c,d:Byte;
  end;

    { TUpdateThread }
  TUpdateThread = class(TThread)
  protected
    procedure Execute; override;
    procedure ReadXML ();
    function DownloadURL(const UpdateLink: string; var s: String): Boolean;
    function DownFile();
  end;


  { TConnectionType }
  TConnectionType = class
  private
    FDeviceName:String;
    FDeviceType:String;
    FPhoneNumber:String;
    FEntryName:PWideChar;
    FConnType:Byte;
  protected
  public
    Constructor Create(ctype:Byte);
    property DeviceName:String read FDeviceName;
    property DeviceType:String read FDeviceType;
    property PhoneNumber:String read FPhoneNumber;
    property EntryName:PWideChar read FEntryName;
    property ConnType:Byte read FConnType;
  end;

  { TLVPNTest }
  TLVPNTest = class
   private
    FQuit: boolean;
    FStatus:Boolean;
    FCon: TLTcp; // the connection
    procedure OnDs(aSocket: TLSocket);
    procedure OnRe(aSocket: TLSocket);
    procedure OnEr(const msg: string; aSocket: TLSocket);
   public
    constructor Create;
    destructor Destroy; override;
    procedure Test(ip:String);
    property Status:Boolean read FStatus;
  end;

var
  updater:TUpdateThread;
  OutputFile: file;
  UpdateLink:string;
  UpdateFound:Boolean=False;
  Binding:Boolean=False;
  UpdateUrl:string;

implementation



{ TLVPNTest }

procedure TLVPNTest.OnDs(aSocket: TLSocket);
begin

end;

procedure TLVPNTest.OnRe(aSocket: TLSocket);
begin

end;

procedure TLVPNTest.OnEr(const msg: string; aSocket: TLSocket);
begin
  FQuit := true;
end;

constructor TLVPNTest.Create;
begin
FCon := TLTCP.Create(nil); // create new TCP connection with no parent component
FCon.OnError := @OnEr; // assign callbacks
FCon.OnReceive := @OnRe;
FCOn.OnDisconnect := @OnDs;
FCon.Timeout := 50; // responsive enough, but won't hog cpu
end;

destructor TLVPNTest.Destroy;
begin
  FCon.Free; // free the connection
  inherited Destroy;
end;

procedure TLVPNTest.Test(ip:String);
begin
  FCon.Connect(ip, 1723);
  FQuit := False;
  Binding:=True;
  repeat
    FCon.CallAction; // wait for "OnConnect"
    Application.ProcessMessages;
  until FCon.Connected or FQuit;
  Binding:=False;
  FStatus:=FCon.Connected;
end;

function checkVPN(ip:String):boolean;
var
  lVPN:TLVPNTest;
begin
  lVPN := TLVPNTest.Create;
  lVPN.Test(ip);
  Result:=lVPN.Status;
  lVPN.Free;
end;


procedure AddRoute(ip,mask,router:string);
var
  params:String;
begin
  params:='add '+ip+' MASK '+mask+' '+router+' METRIC 1';
  ShellExecute(0,'open','route',PChar(params),nil,SW_HIDE);
end;

procedure DelRoute(route:string);
var
  params:String;
begin
  params:='delete '+route;
  ShellExecute(0,'open','route',PChar(params),nil,SW_HIDE);
end;

procedure CheckIpInList(var ip:TIpAddr);
begin

end;

{ TConnectionType }
constructor TConnectionType.Create(ctype:Byte);
begin
  FEntryName:=DIANET;
  case ctype of
    VPN:
      begin
        FDeviceType:=RASDT_Vpn;
        FDeviceName:='WAN Miniport (PPTP)';
        FPhoneNumber:=VPN_IP;
        FConnType:=RASET_Vpn;
      end;
    PPPoE:
      begin
        FDeviceType:=RASDT_PPPoE;
        FDeviceName:='WAN Miniport (PPPOE)';
        FPhoneNumber:='Dianet';
        FConnType:=RASET_Broadband;
      end;
    VPN_POLI:
      begin
        FDeviceType:=RASDT_Vpn;
        FDeviceName:='WAN Miniport (PPTP)';
        FPhoneNumber:=VPN_IP_POLI;
        FConnType:=RASET_Vpn;
      end;
  end;
end;

Procedure CheckIp;
var
  pAdapterInfo, pAI : PIpAdapterInfo;
  AdapterInfo       :  TIpAdapterInfo;
  OutBufLen: ULONG;
  s: string;
  IpAddrString: TIpAddrString;
  err:DWORD;
  ip:TIpAddr;
  pnext:PIP_ADDR_STRING;
begin
  //upload

  OutBufLen := 0;
  GetMem(pAdapterInfo,sizeof(TIpAdapterInfo));
  FillMemory(pAdapterInfo,SizeOf(TIpAdapterInfo),0);
  err:=GetAdaptersInfo(pAdapterInfo, OutBufLen);
  if err = ERROR_BUFFER_OVERFLOW then
    begin
      FreeMem(pAdapterInfo);
      GetMem(pAdapterInfo,OutBufLen);
      FillMemory(pAdapterInfo,OutBufLen,0);
      err := GetAdaptersInfo(pAdapterInfo, OutBufLen);
    end;
  if err <> NO_ERROR then
    begin
      FreeMem(pAdapterInfo);
      //CreateError('Ошибка','Не удалось получить локальный адрес',bfInfo,False);
      exit;
    end;
  pAI := pAdapterInfo;
  s:='';
  while pAI<>nil do
  begin
    IpAddrString := pAI^.IpAddressList;
    pnext:=@IpAddrString;
    While pNext<>nil Do
    Begin
      IpAddrString:=pnext^;
      s:=IpAddrString.IpAddress.S;
      ip.a := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      ip.b := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      ip.c := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      ip.d := StrToInt(s);
      CheckIpInList(ip);
      pnext := IpAddrString.Next;
    End;
    pAI := pAI^.Next;
  end;
end;

{ TUpdateThread }
procedure TUpdateThread.Execute;
begin

end;


procedure TUpdateThread.ReadXML ();
var
   PassNode: TDOMNode;
   Doc:      TXMLDocument;
begin
   ReadXMLFile(Doc,'update.xml');
   PassNode := Doc.DocumentElement.FindNode('version');
   if PassNode.TextContent<>VERSION then
    begin
      PassNode := Doc.DocumentElement.FindNode('url');
      UpdateLink:=PassNode.TextContent;
      UpdateFound:=True;
    end;
end;

function TUpdateThread.DownloadURL(const Updatelink: string; var s: String): Boolean;
 const BufferSize = 1024;
 var hSession, hURL: HInternet;
 Buffer: array[1..BufferSize] of Byte;
 BufferLen: DWORD;
 f: File;
 sAppName: string;
begin
   Result:=False;
   sAppName := ExtractFileName(Application.ExeName);
   hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG,
         nil, nil, 0);
   try
      hURL := InternetOpenURL(hSession,
      PChar(Updatelink),nil,0,0,0);
      try
         AssignFile(f, s);
         Rewrite(f,1);
         repeat
            InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
            BlockWrite(f, Buffer, BufferLen)
         until BufferLen = 0;
         CloseFile(f);
         Result:=True;
      finally
      InternetCloseHandle(hURL)
      end
   finally
   InternetCloseHandle(hSession)
   end
end;


function TUpdateThread.DownFile();
var FileOnNet, LocalFileName: string;
 begin
   FileOnNet:=aUrl;
   LocalFileName:='MyFile.zip';

   if DownloadURL(FileOnNet,LocalFileName)=True then
      ShowMessage('Download successful')
   else
      ShowMessage('Error in file download')

 end;


end.


