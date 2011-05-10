unit Utils;

{$mode objfpc}{$H+}
//{$define DEBUG}

interface

uses
  Classes, SysUtils, Windows, lnet, XMLRead, DOM, Forms,
  RASUnit, jwaiptypes, JwaIpHlpApi, IdHTTP;

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


  VERSION = '1.2.9.8';

  RETRAKER_URL = 'http://start.dianet.info';

function UpdateLayeredWindow(Handle: THandle; hdcDest: HDC; pptDst: PPoint; _psize: PSize; hdcSrc: HDC; pptSrc: PPoint; crKey: COLORREF; pblend: PBLENDFUNCTION; dwFlags: DWORD): Boolean; stdcall; external 'user32' name 'UpdateLayeredWindow';
procedure DelRoute(route:string);
procedure AddRoute(ip,mask,router:string);
function checkVPN(ip:String):boolean;
procedure CheckUpdate;
Procedure CheckIp;
function CheckConnectType : integer;
procedure DianetPPPDisconnect;

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
  Filial:WideString;

implementation

{ TUpdateThread }
procedure TUpdateThread.Execute;
var s: string;
     PassNode: TDOMNode;
   Doc:      TXMLDocument;
begin
try
  try
     AssignFile(OutputFile, 'upd.xml');
     ReWrite(OutputFile);
     IdHTTP1 := TIdHTTP.Create(nil);
     s:= idHTTP1.Get('http://update.dianet.info/dialer/index.php?action=version');
     Write(OutputFile, s);
     CloseFile(OutputFile);

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

finally idHTTP1.Free;
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
begin
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
              AddRoute('172.16.32.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.30.1');
              end;
      31:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.30.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.30.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.30.1');
              end;
      34:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.34.1');
              end;
      35:
              begin
			  Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.34.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.34.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.34.1');
              end;
      36:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.36.1');
              end;
       37:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.36.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.36.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.36.1');
              end;
       38:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.38.1');
              end;
        39:
              begin
			    Filial:='zarinsk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.38.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.38.1');
              AddRoute('172.16.44.0','255.255.254.0','172.16.38.1');
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
              AddRoute('10.110.0.0','255.255.252.0','172.16.44.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.44.1');
        end;
      45:
        begin
		    Filial:='biysk';
              AddRoute('10.110.0.0','255.255.252.0','172.16.44.1');
              AddRoute('172.16.28.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.30.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.32.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.34.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.36.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.38.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.40.0','255.255.254.0','172.16.44.1');
              AddRoute('172.16.42.0','255.255.254.0','172.16.44.1');
        end;
    end;

   end;

  //Novoaltaysk to retracker
  if (ip.a=10) and (ip.b=33) then begin
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
    case ip.c of
      26:AddRoute('10.33.0.0','255.255.0.0','10.33.26.1');
      27:AddRoute('10.33.0.0','255.255.0.0','10.33.26.1');

      28:AddRoute('10.33.0.0','255.255.0.0','10.33.28.1');
      29:AddRoute('10.33.0.0','255.255.0.0','10.33.28.1');

      30:AddRoute('10.33.0.0','255.255.0.0','10.33.30.1');
      31:AddRoute('10.33.0.0','255.255.0.0','10.33.30.1');	  
    end;
    Filial:='novoalt';
   end;

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
   end
  else begin
    if Length(Filial)<3 then
      Filial:='other';
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
      if (ip.a=172) and (ip.b=16) then
        begin
          result :=1;
          exit;
        end;
      if (ip.a=10) and (ip.b=110) then
        begin
          result :=4;
          exit;
        end;
      if (ip.a=10) and (ip.b=0) and (ip.c=110) then
        begin
          result :=2;
          exit;
        end;
      if (ip.a=192) and (ip.b=168) and (ip.c=254) then
        begin
          result :=3;
          exit;
        end;
      pnext := IpAddrString.Next;
    End;
    pAI := pAI^.Next;
  end;
  result := 0;
end;

procedure DianetPPPDisconnect;
var
params:String;
begin
  params:='/disconnect';
  ShellExecute(0,'open','rasdial',PChar(params),nil,SW_HIDE);
end;

end.

