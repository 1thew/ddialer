unit Unit1; 

//{$mode objfpc}{$H+}
{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  CheckLst, ExtCtrls, Winsock, dynlibs;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    function Ping (add:Pchar) : integer;
    function Resolv (inet_host:ansistring) : integer;
    function VPN_Ping (vpn_host:Pchar) : integer;
    function FindGateway (Sender: TObject) : PChar;
    function FindLocalIP (Sender: TObject) : Pchar;
    function LanConnected : Boolean;
  private
    { private declarations }
  public
    { public declarations }
    gateway : PChar;
  end;


type
  IPINFO = record
  Ttl: char;
  Tos:char;
  IPFlags: char;
  OptSize: char;
  Options: ^char;
end;

type
PNetResourceArray = ^TNetResourceArray;
TNetResourceArray = array[0..MaxInt div SizeOf(TNetResource) - 1] of TNetResource;


type
  ICMPECHO = record
  Source: longint;
  Status: longint;
  RTTime: longint;
  DataSize: Shortint;
  Reserved: Shortint;
  pData: ^variant;
  i_ipinfo: IPINFO;
end;

  TIcmpCreateFile = function():integer;
  {$IFDEF WIN32} stdcall; {$ENDIF}

  TIcmpCloseHandle = procedure(var handle: integer);
  {$IFDEF WIN32} stdcall; {$ENDIF}

  TIcmpSendEcho = function(var handle: integer; endereco: DWORD;
  buffer: variant; tam: WORD; IP: IPINFO; ICMP: ICMPECHO;
  tamicmp: DWORD; tempo: DWORD): DWORD;
  {$IFDEF WIN32} stdcall; {$ENDIF}


var
  Form1: TForm1;

const
  DNS2 =  '78.109.128.2';
  inet_host = 'mail.ru';
  vpn_host = '78.109.128.15';

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Caption := 'Работаем....';
  Button1.Enabled := false;
  case Ping (DNS2) of
     1:
     begin
       Label3.Caption := 'Пинг до DNS2... Работает!'
     end;
     0:
     begin
       Label3.Caption := 'Пинг до DNS2... Проблемы!!'
     end;
  end;

  case Ping (gateway) of
     1:
     begin
       Label2.Caption := 'Пинг до шлюза... Работает!'
     end;
     0:
     begin
       Label2.Caption := 'Пинг до шлюза... Проблемы!!'
     end;
  end;

  case Resolv (inet_host) of
     1:
     begin
       Label4.Caption := 'Резолв mail.ru.... Работает!'
     end;
     0:
     begin
       Label4.Caption := 'Резолв mail.ru....  Проблемы!!'
     end;
  end;
  case VPN_Ping (vpn_host) of
     1:
     begin
       Label5.Caption := 'Пинг до VPN серверов... Работает!'
     end;
     0:
     begin
       Label5.Caption := 'Пинг до VPN серверов...  Проблемы!!'
     end;
  end;

  Button1.Enabled := true;
  Button1.Caption := 'Завершено! Перезапустить?';
end;

function TForm1.Ping (add:PChar) : integer;
var
  wsadt : wsadata;
  icmp :icmpecho;
  HNDicmp : integer;
  hndFile :integer;
  Host :PHostEnt;
  Destino :in_addr;
  Endereco :^DWORD;
  IP : ipinfo;
  Retorno :integer;
  dwRetorno :DWORD;
  x :integer;

  IcmpCreateFile : TIcmpCreateFile;
  IcmpCloseHandle : TIcmpCloseHandle;
  IcmpSendEcho : TIcmpSendEcho;

begin

  HNDicmp := LoadLibrary('ICMP.DLL');
  if (HNDicmp <> 0) then
  begin
    @IcmpCreateFile := GetProcAddress(HNDicmp,'IcmpCreateFile');
    @IcmpCloseHandle := GetProcAddress(HNDicmp,'IcmpCloseHandle');
    @IcmpSendEcho := GetProcAddress(HNDicmp,'IcmpSendEcho');
    if (@IcmpCreateFile=nil) or (@IcmpCloseHandle=nil) or (@IcmpSendEcho=nil) then
    begin
      FreeLibrary(HNDicmp);
      //result :=0;
    end;
  end;
  Retorno := WSAStartup($0101,wsadt);

  if (Retorno <> 0) then
  begin
    WSACleanup();
    FreeLibrary(HNDicmp);
    //result :=0;
  end;

  Destino.S_addr := inet_addr(add);
  if (Destino.S_addr = 0) then
    Host := GetHostbyName(add)
  else
    Host := GetHostbyAddr(@Destino,sizeof(in_addr), AF_INET);

  if (host = nil) then
  begin
    WSACleanup();
    FreeLibrary(HNDicmp);
    result :=0;
    exit;
  end;
  memo1.Lines.Add('Pinging ' + add);

  Endereco := @Host.h_addr_list;

  HNDFile := IcmpCreateFile();
  for x:= 0 to 4 do
  begin
    Ip.Ttl := char(255);
    Ip.Tos := char(0);
    Ip.IPFlags := char(0);
    Ip.OptSize := char(0);
    Ip.Options := nil;

    dwRetorno := IcmpSendEcho(
    HNDFile,
    Endereco^,
    null,
    0,
    Ip,
    Icmp,
    sizeof(Icmp),
    DWORD(5000));
    Destino.S_addr := icmp.source;
    Memo1.Lines.Add('Ping ' + add);
  end;

  FreeLibrary(HNDicmp);
  WSACleanup();
  result :=1;

end;

function TForm1.Resolv (inet_host:ansistring) : integer;
var
  HostEnt: PHostEnt;
  GInitData: TWSAData;
begin
 // WSAStartup(MAKEWORD(2,0), &GInitData);
  WSAStartup($101, GInitData);
  HostEnt:= gethostbyname(PChar(inet_host));
  memo1.Lines.Add('mail.ru =' + Pchar(gethostbyname(PChar(inet_host))));
  if HostEnt <> nil then
  begin
    memo1.Lines.Add('mail.ru =' + PAnsiChar(HostEnt));
    result := 1
  end
  else
  begin
    memo1.Lines.Add('Адрес не резолвится!');
    result := 0;
  end;
  WSACleanup;
end;

function TForm1.VPN_Ping (vpn_host:Pchar) : integer;
begin
  result :=1;
end;

function TForm1.FindGateway (Sender: TObject) : PChar;
begin

end;

function TForm1.FindLocalIP (Sender: TObject): Pchar;
begin

end;

function TForm1.LanConnected : Boolean;
var hEnum  : Cardinal;
    count  : Cardinal;
    size   : Cardinal;
    buffer : TNETRESOURCE;
begin
  Result := True;
  if NO_ERROR = WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK, RESOURCEUSAGE_CONNECTABLE, nil, hEnum) then
  begin
    size := sizeof(buffer);
    if (NO_ERROR = WNetEnumResource(hEnum, count, Addr(buffer), size)) AND
       (count>0) then
    begin
      // LAN is connected.
      exit;
    end;
  end;
  // LAN isn't connected.
  Result := False;
end;

end.

