unit Utils;

{$mode objfpc}{$H+}
//{$define DEBUG}

interface

uses
  Classes, SysUtils, Windows, lnet, XMLRead, DOM, Forms,
  RASUnit, jwaiptypes, JwaIpHlpApi, IdHTTP, Registry, winsock, dialogs,
  IdDNSResolver, Idglobal;

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
  VPN_IP_POLI ='vpn.dianet.info';
  VERSION = '1.3.2.2';
  RETRAKER_URL = 'http://start.dianet.info';

  XML_URL='http://update.dianet.info/dialer/downloads/test/upd.xml';
  updater_URL='http://update.dianet.info/dialer/downloads/updater.exe';


function UpdateLayeredWindow(Handle: THandle; hdcDest: HDC; pptDst: PPoint; _psize: PSize; hdcSrc: HDC; pptSrc: PPoint; crKey: COLORREF; pblend: PBLENDFUNCTION; dwFlags: DWORD): Boolean; stdcall; external 'user32' name 'UpdateLayeredWindow';
procedure DelRoute(route:string);
procedure AddRoute(ip,mask,router:string);
function checkVPN(ip:String):boolean;
procedure CheckUpdate;
Procedure CheckIp;
function CheckConnectType : integer;
procedure DianetPPPDisconnect;
function DoUpdateProgramm:integer;
function Roll(interval:integer):integer;
function IsOldWindows: integer;
procedure HealError(i:integer);
procedure DownloadFile(s1,s2:string);
function getNameOf(const IP: string): Ansistring;

type

  TIpAddr = record
    a,b,c,d:Byte;
  end;

  { TUpdateThread }
  TUpdateThread = class(TThread)
  protected
    IdHTTP1: TIdHTTP;
    procedure Execute; override;
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
  UpdateLink:string;
  UpdateInfo:WideString;
  UpdateFound:Boolean=False;
  UpdateStream:TFileStream;
  updater:TUpdateThread;
  OutputFile: textfile;
  Binding:Boolean=False;


implementation
uses mainUnit;

{ TUpdateThread }
procedure TUpdateThread.Execute;
var s: string;
     PassNode: TDOMNode;
   Doc:      TXMLDocument;
   j: integer;
begin
  //************************************************
  // С некоторым шансом скачиваем апдейтер
  //************************************************
if Roll(100)<8 then
  DownloadFile(updater_URL,'updater.exe');

// далее запускаем рандомизатор обновлений
if Roll(100)<25 then
begin
  try
    DownloadFile(XML_URL,'upd.xml');

     ReadXMLFile(Doc,'upd.xml');

     PassNode := Doc.DocumentElement.FindNode('version');
     if PassNode.TextContent<>VERSION then
     begin
        PassNode := Doc.DocumentElement.FindNode('note');
        UpdateInfo:=PassNode.TextContent;
        PassNode := Doc.DocumentElement.FindNode('url');
        UpdateLink:=PassNode.TextContent;
        UpdateFound:=True;
     end;

  except exit;
  end;

     // если обновление найдено то его качаем.
     if UpdateFound=True then
     begin
       try
          DownloadFile(UpdateLink,'update.exe');
          ShellExecute(0,'open','updater.exe',nil,nil,SW_normal);
       except MessageForNews:='Возникли проблемы с доступом! Проверьте настройки антивируса/фаервола!';
       end;
     end;

end;
end;


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

procedure CheckUpdate;
begin
  updater:=TUpdateThread.Create(True);
  updater.FreeOnTerminate:=True;
  updater.Resume;
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
var name,ipa:string;
begin
  {****************************************************

  список филиалов:

  Filial:='aleysk'
  Filial:='zarinsk'
  Filial:='belokuriha'
  Filial:='biysk'
  Filial:='rubtsovsk'
  Filial:='barnaul'
  Filial:='sibir'
  Filial:='novoalt'

  ****************************************************}


  //Belokuriha, Rubcovsk, Aleysk, Zarinsk, Byisk to retracker
  if (ip.a=172) and (ip.b=16) then
    case ip.c of
      28:AddRoute('172.16.20.58','255.255.255.255','172.16.28.1');
      29:AddRoute('172.16.20.58','255.255.255.255','172.16.28.1');

      30:AddRoute('172.16.20.58','255.255.255.255','172.16.30.1');
      31:AddRoute('172.16.20.58','255.255.255.255','172.16.30.1');

      32:AddRoute('172.16.20.58','255.255.255.255','172.16.32.1');
      33:AddRoute('172.16.20.58','255.255.255.255','172.16.32.1');

      34:AddRoute('172.16.20.58','255.255.255.255','172.16.34.1');
      35:AddRoute('172.16.20.58','255.255.255.255','172.16.34.1');

      36:AddRoute('172.16.20.58','255.255.255.255','172.16.36.1');
      37:AddRoute('172.16.20.58','255.255.255.255','172.16.36.1');

      38:AddRoute('172.16.20.58','255.255.255.255','172.16.38.1');
      39:AddRoute('172.16.20.58','255.255.255.255','172.16.38.1');

      40:AddRoute('172.16.20.58','255.255.255.255','172.16.40.1');
      41:AddRoute('172.16.20.58','255.255.255.255','172.16.40.1');

      42:AddRoute('172.16.20.58','255.255.255.255','172.16.42.1');
      43:AddRoute('172.16.20.58','255.255.255.255','172.16.42.1');

      44:AddRoute('172.16.20.58','255.255.255.255','172.16.44.1');
      45:AddRoute('172.16.20.58','255.255.255.255','172.16.44.1');

      46:AddRoute('172.16.20.58','255.255.255.255','172.16.46.1');
      47:AddRoute('172.16.20.58','255.255.255.255','172.16.46.1');

      48:AddRoute('172.16.20.58','255.255.255.255','172.16.48.1');
      49:AddRoute('172.16.20.58','255.255.255.255','172.16.48.1');


    end;
  //Aleysk to Dianet_local
  if (ip.a=172) and (ip.b=16) then
   begin
     case ip.c of
      28:
              begin
			  Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.28.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.28.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.28.1');
              end;
      29:
              begin
			  Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.28.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.28.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.28.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.28.1');
              end;
      40:
              begin
			  Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.40.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.40.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.40.1');
              end;
      41:
              begin
			  Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.40.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.40.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.40.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.40.1');
              end;
      46:
              begin
                 Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.46.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.46.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.46.1');
              end;

      47:
              begin
                 Filial:='aleysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.46.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.46.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.46.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.46.1');
              end;


     end;
    end;
  //Zarinsk to Dianet_local
  if (ip.a=172) and (ip.b=16) then
   begin
    case ip.c of
      30:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.30.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.32.0','255.255.240.0','172.16.30.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.30.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.30.1');
              end;
      31:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.30.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.32.0','255.255.240.0','172.16.30.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.30.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.30.1');
              end;
      34:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.34.1');

              AddRoute('172.16.36.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.40.0','255.255.248.0','172.16.34.1');
              AddRoute('172.16.48.0','255.255.252.0','172.16.34.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.34.1');
              end;
      35:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.34.1');

              AddRoute('172.16.36.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.40.0','255.255.248.0','172.16.34.1');
              AddRoute('172.16.48.0','255.255.252.0','172.16.34.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.34.1');
              end;
      36:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.32.0','255.255.252.0','172.16.36.1');

              AddRoute('172.16.38.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.40.0','255.255.248.0','172.16.36.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.36.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.36.1');
              end;
       37:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.32.0','255.255.252.0','172.16.36.1');

              AddRoute('172.16.38.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.40.0','255.255.248.0','172.16.36.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.36.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.31.1');
              end;
       38:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.38.1');      //22
              AddRoute('172.16.32.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.38.1');      //23

              AddRoute('172.16.40.0','255.255.248.0','172.16.38.1');      //21
              AddRoute('172.16.48.0','255.255.254.0','172.16.38.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.38.1');
              end;
        39:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.28.0','255.255.252.0','172.16.38.1');      //22
              AddRoute('172.16.32.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.38.1');      //23

              AddRoute('172.16.40.0','255.255.248.0','172.16.38.1');      //21
              AddRoute('172.16.48.0','255.255.254.0','172.16.38.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.38.1');
              end;
    end;

   end;

  //Belokuriha to Dianet_local
  if (ip.a=172) and (ip.b=16) then
   begin
    case ip.c of
          32:
              begin
			   Filial:='belokuriha';
              AddRoute('10.110.0.0','255.255.252.0','172.16.32.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.32.1');

              AddRoute('172.16.34.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.32.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.32.1');
              end;
	  33:
              begin
			   Filial:='belokuriha';
              AddRoute('10.110.0.0','255.255.252.0','172.16.32.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.32.1');

              AddRoute('172.16.34.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.32.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.32.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.32.1');
              end;
          42:
              begin
			   Filial:='belokuriha';
              AddRoute('10.110.0.0','255.255.252.0','172.16.42.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.42.1');

              AddRoute('172.16.44.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.42.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.42.1');
              end;
          43:
              begin
			   Filial:='belokuriha';
              AddRoute('10.110.0.0','255.255.252.0','172.16.42.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.42.1');

              AddRoute('172.16.44.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.46.0','255.255.254.0','172.16.42.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.42.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.42.1');
              end;
          end;
    end;

   //Biysk(vlan 99) to Dianet_local
  if (ip.a=172) and (ip.b=16) then
   begin
    case ip.c of
      44:
        begin
		    Filial:='biysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.44.1');        //22
              AddRoute('172.16.32.0','255.255.248.0','172.16.44.1');       //21
              AddRoute('172.16.40.0','255.255.252.0','172.16.44.1');

              AddRoute('172.16.46.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.44.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.44.1');
        end;
      45:
        begin
		    Filial:='biysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.44.1');        //22
              AddRoute('172.16.32.0','255.255.248.0','172.16.44.1');       //21
              AddRoute('172.16.40.0','255.255.252.0','172.16.44.1');

              AddRoute('172.16.46.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.48.0','255.255.254.0','172.16.44.1');
              AddRoute('172.30.0.0','255.255.0.0','172.16.44.1');
        end;
    end;
   end;

     //Rubtsovsk(VLAN_101) to Dianet_local
  if (ip.a=172) and (ip.b=16) then
   begin
    case ip.c of
      48:
        begin
          Filial:='rubtsovsk';
          AddRoute('10.110.0.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.28.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.30.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.32.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.34.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.36.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.38.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.40.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.42.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.44.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.46.0','255.255.254.0','172.16.48.1');
          AddRoute('172.30.0.0','255.255.0.0','172.16.48.1');
        end;
      49:
        begin
          Filial:='rubtsovsk';
          AddRoute('10.110.0.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.28.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.30.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.32.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.34.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.36.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.38.0','255.255.248.0','172.16.48.1');
          AddRoute('172.16.40.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.42.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.44.0','255.255.252.0','172.16.48.1');
          AddRoute('172.16.46.0','255.255.254.0','172.16.48.1');
          AddRoute('172.30.0.0','255.255.0.0','172.16.48.1');
        end;
    end;
   end;

  //Novoaltaysk to retracker
  if (ip.a=10) and (ip.b=33) then
  begin
    Filial:='novoalt';
    case ip.c of
      26:AddRoute('172.16.20.58','255.255.255.255','10.33.26.1');
      27:AddRoute('172.16.20.58','255.255.255.255','10.33.26.1');

      28:AddRoute('172.16.20.58','255.255.255.255','10.33.28.1');
      29:AddRoute('172.16.20.58','255.255.255.255','10.33.28.1');

      30:AddRoute('172.16.20.58','255.255.255.255','10.33.30.1');
      31:AddRoute('172.16.20.58','255.255.255.255','10.33.30.1');
    end;
  end;

  //Novoaltaysk to local
  if (ip.a=10) and (ip.b=33) then
   begin
      Filial:='novoalt';
    case ip.c of
      26:AddRoute('10.33.0.0','255.255.0.0','10.33.26.1');
      27:AddRoute('10.33.0.0','255.255.0.0','10.33.26.1');

      28:AddRoute('10.33.0.0','255.255.0.0','10.33.28.1');
      29:AddRoute('10.33.0.0','255.255.0.0','10.33.28.1');

      30:AddRoute('10.33.0.0','255.255.0.0','10.33.30.1');
      31:AddRoute('10.33.0.0','255.255.0.0','10.33.30.1');	  
    end;
   end;

  //***************************************
  // FIX ME: маршруты тут не нужны
  //***************************************
  //Politeh to retracker
  if (ip.a=10) and (ip.b=0) then
    case ip.c of
      110:AddRoute('172.16.20.58','255.255.255.255','10.0.110.6');
      111:AddRoute('172.16.20.58','255.255.255.255','10.0.110.6');
    end;
  //Politeh to Barnaul
  if (ip.a=10) and (ip.b=0) then
   begin
    case ip.c of
      110:AddRoute('10.110.0.0','255.255.252.0','10.0.110.6');
      111:AddRoute('10.110.0.0','255.255.252.0','10.0.110.6');
    end;
    Filial:='barnaul';
   end;

  // find "filial" for other location
  if  (ip.a=10) and (ip.b=110) then Filial:='barnaul';
  if  (ip.a=172) and (ip.b=16) then
   begin
     case ip.c of
       24:Filial:='biysk';
       25:Filial:='biysk';
       26:Filial:='rubtsovsk';
       27:Filial:='rubtsovsk';
     end;
   end;
  //*************************************************
  // прописываем НОВЫЕ сети, маршруты получим по DHCP
  //*************************************************

  if (ip.a=172) and (ip.b=30) then
   begin
        // начинаем возню с определением филиала по IP
        ipa:=(IntToStr(ip.a)+'.'+IntToStr(ip.b)+'.'+IntToStr(ip.c)+'.'+IntToStr(ip.d));
        name:=GetNameOf(ipa);

        // определяем филиалы
        if AnsiPOS('sibirskiy',name) > 0 then filial:='sibir'
        else if AnsiPOS('aleysk',name) > 0 then filial:='aleysk'
        else if AnsiPOS('belokuriha',name) > 0 then filial:='belokuriha'
        else if AnsiPOS('biysk',name) > 0 then filial:='biysk'
        else if AnsiPOS('novoaltaysk',name) > 0 then filial:='novoalt'
        else if AnsiPOS('rubtsovsk',name) > 0 then filial:='rubtsovsk'
        else if AnsiPOS('zarinsk',name) > 0 then filial:='zarinsk'
        else if AnsiPOS('barnaul',name) > 0 then filial:='barnaul';
   end;
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



function CheckConnectType : integer;
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
  while (pAI<>nil) do
  begin
    IpAddrString := pAI^.IpAddressList;
    pnext:=@IpAddrString;
    While (pNext<>nil) Do
    Begin
      IpAddrString:=pnext^;
      s:=IpAddrString.IpAddress.S;
      ip.a := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      ip.b := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      ip.c := StrToInt(Copy(s, 1, Pos('.', s) - 1)); Delete(s, 1, Pos('.', s));
      {*****************************************
      CheckConnectType:
      1 = VPN
      2 = VPN_POLI
      3 = PPPoE or VPN
      4 = PPPoE
      ******************************************}
      if (ip.a=172) and (ip.b=16) then
        begin
          result :=1;
          exit;
        end
      else if (ip.a=10) and (ip.b=110) then
        begin
          result :=4;
          exit;
        end
      else if (ip.a=10) and (ip.b=0) and (ip.c=110) then
        begin
          result :=2;
          exit;
        end
      {**************************************
       DEBUG: данный участок нужен для тестирования в оффисе
      ***************************************}
      {else if (ip.a=192) and (ip.b=168) and (ip.c=254) then
        begin
          result :=3;
          exit;
        end}

      // разворачиваем новые диапазоны result :=4;
      else if Filial= 'sibir' then
      begin
       result :=4;
       exit;
      end
      else if Filial= 'barnaul' then
      begin
       result :=3;
       exit;
      end
      else if Filial= 'novoalt' then
      begin
       result :=3;
       exit;
      end
      else if Filial= 'belokuriha' then
      begin
       result :=1;
       exit;
      end
      else if Filial= 'biysk' then
      begin
       result :=1;
       exit;
      end
      else if Filial= 'rubtsovsk' then
      begin
       result :=1;
       exit;
      end
      else if Filial= 'zarinsk' then
      begin
       result :=1;
       exit;
      end
      else if Filial= 'aleysk' then
      begin
       result :=1;
       exit;
      end;
      pnext := IpAddrString.Next;
    End;
    pAI := pAI^.Next;
  end;
end;

procedure DianetPPPDisconnect;
var
params:String;
begin
  params:='/disconnect';
  ShellExecute(0,'open','rasdial',PChar(params),nil,SW_HIDE);
end;

function DoUpdateProgramm:integer;
var GetFile,IdHTTP1: TIdHTTP;
    MStream:TMemoryStream;
    PassNode: TDOMNode;
    Doc: TXMLDocument;
begin
  //********************************************
  // Описание DoUpdateProgramm:result
  // 1 = нет доступных обновлений
  // 2 = всё нормально
  // 3 = проблема доступа для обновления
  //********************************************
     // получаем файл с описанием
    DownloadFile(XML_URL,'upd.xml');

    ReadXMLFile(Doc,'upd.xml');

    PassNode := Doc.DocumentElement.FindNode('version');
    if PassNode.TextContent<>VERSION then
    begin
       PassNode := Doc.DocumentElement.FindNode('note');
       UpdateInfo:=PassNode.TextContent;
       PassNode := Doc.DocumentElement.FindNode('url');
       UpdateLink:=PassNode.TextContent;
       UpdateFound:=True;
    end
    else
    begin
      result:=1;
      exit;
    end;

   //////////////////////////////////////////////////////
   try
      DownloadFile(updater_URL,'updater.exe');
      DownloadFile(UpdateLink,'update.exe');
   except
      result:=3;
   end;

   //////////////////////////////////////////////////////

   // запускаем обновлялку
   ShellExecute(0,'open','updater.exe',nil,nil,SW_normal);
   result:=2;
end;

function Roll(interval:integer):integer;
begin
randomize;
result:=Random(interval);
end;

procedure HealError(i:integer);
var
  reg: TRegistry;
begin
  case i of
    692:
      begin

           reg := TRegistry.Create();
           reg.RootKey := HKEY_LOCAL_MACHINE;
           if (IsOldWindows = 6) and (reg.OpenKey('SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules', True)) then
           begin
             reg.WriteString('RRAS-L2TP-In-UDP', 'v2.10|Action=Allow|Active=TRUE|Dir=In|Protocol=17|LPort=1701|App=System|Name=@FirewallAPI.dll,-33753|Desc=@FirewallAPI.dll,-33756|EmbedCtxt=@FirewallAPI.dll,-33752|');
             reg.WriteString('RRAS-L2TP-Out-UDP', 'v2.10|Action=Allow|Active=TRUE|Dir=Out|Protocol=17|RPort=1701|App=System|Name=@FirewallAPI.dll,-33757|Desc=@FirewallAPI.dll,-33760|EmbedCtxt=@FirewallAPI.dll,-33752|');
           end;
             reg.closekey;       // освобождаем ресурсы
             reg.Free;
      end;
  end;
end;


function IsOldWindows: integer;
var
  OSVersionInfo: TOSVersionInfo;
begin
  Result := 0;                      // Неизвестная версия ОС
  OSVersionInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
  begin
    // если тут 5 то это XP,2000,2003 винды
      Result := OSVersionInfo.DwMajorVersion
  end;
end;


procedure DownloadFile(s1,s2:string);
var GetFile: TIdHTTP;
    MStream:TMemoryStream;
begin
  //*********************************************
  // s1 - URL файла
  // s2 - имя файла на диске
  //*********************************************
   GetFile:=TIdHTTP.Create(nil);
   GetFile.HandleRedirects:=true;
   MStream:=TMemoryStream.Create;
   // работаем с файлом
   try
      GetFile.get(s1,MStream);
      MStream.SaveToFile(s2);
   except
      exit;
   end;
   GetFile.Free;
   MStream.Free;
end;


function GetNameOf(const IP: string): Ansistring;
var
   TheDns: TIdDNSResolver;
   i: integer;
   sTemp: string;
begin
     TheDns := TIdDNSResolver.Create;
     TheDns.AllowRecursiveQueries := False;
     TheDns.Host := '78.109.128.2';
     TheDns.QueryType := [qtPTR];
try
   TheDns.Resolve(IP);
   //Result := BytesToString(TheDns.QueryResult.Items[0].RData);
   Result := TPTRRecord(TheDns.QueryResult.Items[0]).HostName;
except
      Result := ''; //"Not found" as well as errors raise an
//exception in TIdDNSResolver
end;
TheDns.Destroy;
end;


end.

