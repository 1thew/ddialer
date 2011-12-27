unit Utils;

{$mode objfpc}{$H+}
//{$define DEBUG}

interface

uses
  Classes, SysUtils, Windows, lnet, XMLRead, DOM, Forms,
  RASUnit, jwaiptypes, JwaIpHlpApi, IdHTTP, Registry, winsock, dialogs,
  IdDNSResolver, Idglobal,IdIcmpClient;

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
  VERSION = '1.3.2.3';
  RETRAKER_URL = 'http://start.dianet.info';

  XML_URL='http://update.dianet.info/dialer/downloads/test/upd.xml';
  updater_URL='http://update.dianet.info/dialer/downloads/updater.exe';


function UpdateLayeredWindow(Handle: THandle; hdcDest: HDC; pptDst: PPoint; _psize: PSize; hdcSrc: HDC; pptSrc: PPoint; crKey: COLORREF; pblend: PBLENDFUNCTION; dwFlags: DWORD): Boolean; stdcall; external 'user32' name 'UpdateLayeredWindow';
function checkVPN(ip:String):boolean;
function checkVPNAdv():integer;
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
procedure GetTCfromDNS();
function StringWork(s : ansistring):ansistring;


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
    FError:integer;
    FCon: TLTcp; // the connection
    AvgMS:Double;
    procedure OnDs(aSocket: TLSocket);
    procedure OnRe(aSocket: TLSocket);
    procedure OnEr(const msg: string; aSocket: TLSocket);
    //**********************************************//
    // тут функции по определению проблем
    //**********************************************//

    procedure GetIP();
    procedure GetPing();
    procedure GetDNS();
    // второстепенное
    function PingHost() : Boolean;
    function Resolv () : boolean;
   public
    constructor Create;
    destructor Destroy; override;
    procedure Test(ip:String);
    procedure GetError();
    property Status:Boolean read FStatus;
    property Error:Integer read FError;
  end;


var
  UpdateLink:string;
  UpdateInfo:WideString;
  UpdateFound:Boolean=False;
  UpdateStream:TFileStream;
  updater:TUpdateThread;
  OutputFile: textfile;
  Binding:Boolean=False;
  DNSname:string;
  DNSTC:Ansistring;


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

procedure TLVPNTest.GetError();
begin
  FError:=0;
  GetIP;
  if FError =0 then
  begin
    GetDNS;
    Application.ProcessMessages;
    if FError = 0 then GetPING;
  end;
end;

procedure TLVPNTest.GetIP;
begin
     if Filial='other' then FError:=300;
end;

procedure TLVPNTest.GetPing();
begin
  if PingHost=false then FError:=100;
end;

procedure TLVPNTest.GetDNS();
begin
  if Resolv=false then FError:=200;
end;

function TLVPNTest.Resolv() : boolean;
var
  HostEnt: PHostEnt;
  GInitData: TWSAData;
begin
 // WSAStartup(MAKEWORD(2,0), &GInitData);
  WSAStartup($101, GInitData);
  HostEnt:= gethostbyname(PChar(VPN_IP));
  if HostEnt <> nil then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end;
  WSACleanup;
end;


function TLVPNTest.PingHost() : Boolean;
 var
  R : array of Cardinal;
  i : integer;
const
  ATimes = 50;
begin
  Result := True;
  AvgMS := 0;
  if ATimes>0 then
    with TIdIcmpClient.Create() do
    try
        Host := VPN_IP;
        ReceiveTimeout:=50; //TimeOut ping
        SetLength(R,ATimes);
        {Pinguer le client}
        for i:=0 to Pred(ATimes) do
        begin
            try
              Ping();
              Application.ProcessMessages; //ne bloque pas l'application
              R[i] := ReplyStatus.MsRoundTripTime;
            except
              Result := False;
              Exit;
            end;
          if ReplyStatus.ReplyStatusType<>rsEcho Then result := False; //pas d'écho, on renvoi false.
        end;
        {Faire une moyenne}
        for i:=Low(R) to High(R) do
        begin
          Application.ProcessMessages;
          AvgMS := AvgMS + R[i];
        end;
        AvgMS := AvgMS / i;
    finally
        Free;
    end;
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


function checkVPNAdv():integer;
var
  lVPN:TLVPNTest;
begin
  lVPN := TLVPNTest.Create;
  lVPN.GetError();
  Result:=lVPN.Error;
  lVPN.Free;
end;

procedure CheckUpdate;
begin
  updater:=TUpdateThread.Create(True);
  updater.FreeOnTerminate:=True;
  updater.Resume;
end;



function CheckIpInList(var ip:TIpAddr):integer;
var ipa:string;
begin
  {***************************************************
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

  // объявим что филиал найден, если это не так - в конце исправим
  result:=1;

  {
  if (ip.a=192) and (ip.b=168) and (ip.c=254) then
  begin
    filial:= 'debug';
  end;}

        // начинаем возню с определением филиала по IP
        ipa:=(IntToStr(ip.a)+'.'+IntToStr(ip.b)+'.'+IntToStr(ip.c)+'.'+IntToStr(ip.d));
        DNSname:=GetNameOf(ipa);

        // определяем филиалы
        if AnsiPOS('sibirskiy',DNSname) > 0 then filial:='sibir'
        else if AnsiPOS('aleysk',DNSname) > 0 then filial:='aleysk'
        else if AnsiPOS('belokuriha',DNSname) > 0 then filial:='belokuriha'
        else if AnsiPOS('biysk',DNSname) > 0 then filial:='biysk'
        else if AnsiPOS('novoaltaysk',DNSname) > 0 then filial:='novoalt'
        else if AnsiPOS('rubtsovsk',DNSname) > 0 then filial:='rubtsovsk'
        else if AnsiPOS('zarinsk',DNSname) > 0 then filial:='zarinsk'
        else if AnsiPOS('barnaul',DNSname) > 0 then filial:='barnaul';

  // для АлтГТУ
  if (ip.a=10) and (ip.c=110) then filial:='barnaul';
  if filial='other' then result:=0;

  // если найден филиал, и не сраный политех
  if (result=1) and ((ip.a<>10) and (ip.c<>110)) then
  begin
     GetTCfromDNS();
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
  i:integer;
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
      i:=CheckIpInList(ip);
      if i=1 then exit;
      pnext := IpAddrString.Next;
    End;
    pAI := pAI^.Next;
  end;
end;



function CheckConnectType : integer;
begin
   {*****************************************
      CheckConnectType:
      1 = VPN
      2 = VPN_POLI
      3 = PPPoE or VPN
      4 = PPPoE
      ******************************************}
   if AnsiPOS('pppoe',DNSTC)>0 then result:= 4
   else if AnsiPOS('l2tp',DNSTC)>0 then result:= 1
   else if AnsiPOS('pptp',DNSTC)>0 then result:= 1
   else result:=3;
End;


procedure DianetPPPDisconnect;
var
params:String;
begin
  params:='/disconnect';
  ShellExecute(0,'open','rasdial',PChar(params),nil,SW_HIDE);
end;

function DoUpdateProgramm:integer;
var PassNode: TDOMNode;
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
begin
     TheDns := TIdDNSResolver.Create;
     TheDns.AllowRecursiveQueries := False;
     TheDns.Host := '78.109.128.2';
     TheDns.QueryType := [qtPTR];
try
   TheDns.Resolve(IP);
   //Result := BytesToString(TheDns.QueryResult.Items[0].RData);
   result := TPTRRecord(TheDns.QueryResult.Items[0]).HostName;
except
      Result := ''; //"Not found" as well as errors raise an
end;
TheDns.Destroy;
end;

procedure GetTCfromDNS();
var
   TheDns: TIdDNSResolver;
   s,                     // строка запроса в DNS
     s1,                  //строка после парса, до первой точки DNSName
     s2,                   // строка, после первой точки (без влана)
     s3                   // строка после StringWork
     :ansistring;
   s4:Tstrings;
   i:integer;             // номер символа точки в строке
begin
     TheDns := TIdDNSResolver.Create;
     TheDns.AllowRecursiveQueries := False;
     TheDns.Host := '78.109.128.2';
     TheDns.QueryType := [qtTXT];

if AnsiPOS('.',DNSname)>0  then
begin
i:=AnsiPOS('.',DNSname);
s1:=Copy(DNSname,0,i);     // копируем всё ДО знака первой точки
s2:=Copy(DNSname,i,Length(DNSname)-i+1); // копируем всё ПОСЛЕ первой точки

s3:= StringWork(s1);
//ShowMessage('s1='+s1+' s2='+s2+' s3='+s3);

s:='proto.'+s3+s2;
//ShowMessage(s);
//ShowMessage(s);
try
   TheDns.Resolve(s);

       s4 := TTextRecord(TheDns.QueryResult.Items[0]).text;

       if Length(s4.GetText)>1 then DNSTC:=s4.GetText;
       s4.Clear;

except
end;

end;
TheDns.Destroy;
end;


function StringWork(s: ansistring):ansistring;
var i:integer;
begin
     i:=AnsiPOS('-',s);          // номер знака "-", после номера влана
     s:=Copy(s,0,i-1);          // копируем всё что до знака "-"
     while AnsiPOS('0',s)=1 do
     begin
       s:= Copy(s,2,Length(s)-1);  // урезаем нули перед вланом
       result:=s;
     end;
end;

end.

