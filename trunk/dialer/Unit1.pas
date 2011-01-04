unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Windows, LResources, Classes, SysUtils, FileUtil, Forms, Controls, Registry, Graphics, Dialogs, ComCtrls, Utils,
  StdCtrls, Menus, Buttons, ExtCtrls, RASUnit, types;


type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DopParam: TCheckBox;
    ReConnect: TCheckBox;
    GroupBox1: TGroupBox;
    RemPass: TCheckBox;
    AutoRun: TCheckBox;
    AutoConnect: TCheckBox;
    ConnSel: TComboBox;
    Login: TEdit;
    Pass: TEdit;
    PageControl1: TPageControl;
    IDCompText: TStaticText;
    StaticText1: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    UpdateTimer: TTimer;
    TimerReConnect: TTimer;
    Tray: TTrayIcon;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DopParamChange(Sender: TObject);
    procedure ConnSelChange(Sender: TObject);
    procedure LoginChange(Sender: TObject);
    procedure RemPassChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerReConnectTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    { private declarations }
    procedure LoadConfig;
    procedure SaveConfig;
    procedure DoConnect;
    function connect():DWORD;
    function disconnect():Boolean;
    procedure CheckUpdate;
    procedure DoDisconnect;
  public
    { public declarations }
  end; 

   TDisconThread = class(TTHread)
  private
    FShow:Boolean;
  protected
    procedure Execute; override;
  public
    Constructor Create(CreateSuspended : boolean);
    property ShowDiscon:Boolean read FShow write FShow;
  end;



var
  Form1: TForm1;
  ConnType:Integer;
  Connecting:Boolean=False;
  ConnectError:Boolean=False;
  Discon:TDisconThread;
  hConn: HRasConn;
  Connected:Boolean=False;
  dEvent:HANDLE;
  FirstStart:Boolean=True;
  IDComp:String;


implementation

{$R *.lfm}

procedure TForm1.CheckUpdate();
begin

end;

procedure CreateID();
begin
  if Length(IDComp)=0 then
  begin
       Randomize;
       IDComp:= (IntToStr(Random(1000))+'_'+IntToStr(Random(10000000)));
  end;
end;

procedure CreateError(title,hint:String;flag:TBalloonFlags;disconnect:Boolean);
begin
  if flag=bfError then
    if ConnectError then exit
    else ConnectError:=True;
      Form1.Tray.BalloonTitle:=title;
      Form1.Tray.BalloonHint:=hint;
      Form1.Tray.BalloonFlags:=flag;
      Form1.Tray.ShowBalloonHint;
  if disconnect then
    begin
      if Assigned(Discon) then Discon.ShowDiscon:=False;
      Form1.disconnect();
    end;
end;

procedure Callback(hrasconn:HRasConn;msg: Integer;state: RASCONNSTATE;error,dwExtendedError: Integer); stdcall;
var
  ErrTitle,ErrHint:String;
  WErrHint:WideString;
  s:array [0..512] of WideChar;
  e:Integer;
begin
  try
  Form1.Button1.Enabled:=false;
  Form1.Button2.Enabled:=false;
  if (error>600) or (dwExtendedError>600) then
    begin
      if Assigned(Discon) then Discon.ShowDiscon:=False;
      Form1.disconnect();

      if dwExtendedError>600 then error:=dwExtendedError;

      ErrTitle:='Ошибка подключения: '+IntToStr(error);

      e:=RasGetErrorStringW(error,s,SizeOf(s));
      WErrHint:=s;
      ErrHint:=UTF8Encode(WErrHint);
      CreateError(ErrTitle,ErrHint,bfError,False);
      Form1.Button1.Enabled:=true;
    end;

  case state of
    RASCS_Connected:
     begin
        Form1.Tray.Hint:=DIASTR+'Подключен';
        CreateError(DIANETSTR,'Подключен',bfInfo,False);
        Connected:=True;
        Connecting:=False;
        Form1.Button2.Enabled:=true;
     end;
    RASCS_Authenticate:CreateError(DIANETSTR,'Авторизация...',bfInfo,False);
    RASCS_Authenticated:CreateError(DIANETSTR,'Авторизация прошла успешно',bfInfo,False);
  end;
  except
    Form1.disconnect();
  end;
end;

{ TForm1 }

procedure TForm1.ConnSelChange(Sender: TObject);
begin
  if ConnSel.Text='PPPoE' then ConnType:=PPPoE
  else if ConnSel.Text='VPN (Политех)' then ConnType:=VPN_POLI
  else begin
    ConnType:=VPN;
  end;
end;

procedure TForm1.LoginChange(Sender: TObject);
begin

end;



procedure TForm1.FormShow(Sender: TObject);
begin
  if FirstStart then
    begin
      FirstStart:=False;
      LoadConfig();
      Form1.PageControl1.ActivePage:=TabSheet1;
      if Autoconnect.Checked then DoConnect;
    end;
  Form1.IDCompText.Caption:=IDComp
end;

procedure TForm1.TimerReConnectTimer(Sender: TObject);
begin
  if Connected=true or Connecting=true then Exit
  else
   begin
      if Form1.ReConnect.Checked=true then
        begin
          Form1.DoConnect();
        end;
   end;
end;

procedure TForm1.UpdateTimerTimer(Sender: TObject);
begin
  CheckUpdate();
  Form1.UpdateTimer.Enabled:=false;
end;



function TForm1.disconnect():Boolean;
begin
  Result:=False;
  if RasHangUpW(hConn) = SUCCESS then
    begin
     Result:=TRUE;
     Connected:=False;
     Connecting:=False;
    end;
end;




procedure TForm1.RemPassChange(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.TimerReConnect.Enabled:=true;
  Form1.UpdateTimer.Enabled:=true;
  DoConnect;
end;



procedure TForm1.Button2Click(Sender: TObject);
begin
  DoDisconnect();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

end;





procedure TForm1.DopParamChange(Sender: TObject);
begin
  if DopParam.Checked then
    begin
       TabSheet3.TabVisible:=true;
       TabSheet3.Visible:=true;
    end
  else
      begin
       TabSheet3.TabVisible:=false;
       TabSheet3.Visible:=false;
      end;
end;


procedure TForm1.SaveConfig;
var
  reg:TRegistry;
begin
reg:=TRegistry.Create();
reg.RootKey:=HKEY_CURRENT_USER;
if reg.OpenKey('\Software\DIANET',True) then
   begin
     reg.WriteInteger('conntype',ConnType);
     reg.WriteBool('autoconnect',Autoconnect.Checked);
     reg.WriteBool('reconnect',ReConnect.Checked);
     reg.WriteBool('rempass',RemPass.Checked);
     reg.WriteString('dianetl',Login.Caption);
     reg.WriteString('idcomp',IDComp);
     if RemPass.Checked then reg.WriteString('dianetp',Pass.Caption)
     else reg.WriteString('dianetp','');
   end;
reg.CloseKey;
if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',False) then
   if AutoRun.Checked then reg.WriteString('dianetdialer',ExtractFilePath(Application.ExeName)+'dianetdialer.exe')
   else if reg.ValueExists('dianetdialer') then reg.DeleteValue('dianetdialer');
reg.CloseKey;
reg.Destroy;
end;


procedure TForm1.LoadConfig;
var
  reg:TRegistry;
begin
  reg:=TRegistry.Create();
  reg.RootKey:=HKEY_CURRENT_USER;
  if reg.OpenKey('\Software\DIANET',True) then
     begin
       if reg.ValueExists('conntype') then ConnType:=reg.ReadInteger('conntype');
       if (ConnType>MAX_CONN_TYPE) or (ConnType<MIN_CONN_TYPE) then ConnType:=VPN;
       case ConnType of
         VPN:ConnSel.Text:='VPN (default)';
         PPPoE:ConnSel.Text:='PPPoE';
         VPN_POLI:ConnSel.Text:='VPN (Политех)';
       end;

       if not reg.ValueExists('idcomp') then
          begin
            CreateID();                                        // генерируем ID вслучае если такого значения нет
            reg.WriteString('idcomp',IDComp);                  // записываем в реестр сгенерированное значение ID
          end;

       if reg.ValueExists('idcomp') then   IDComp:=reg.ReadString('idcomp');

       if reg.ValueExists('reconnect') then ReConnect.Checked:=reg.ReadBool('reconnect');

       if reg.ValueExists('autoconnect') then Autoconnect.Checked:=reg.ReadBool('autoconnect');

       if reg.ValueExists('rempass') then RemPass.Checked:=reg.ReadBool('rempass');

       if reg.ValueExists('dianetl') then Login.Caption:=reg.ReadString('dianetl');
       if RemPass.Checked then
          if reg.ValueExists('dianetp') then Pass.Caption:=reg.ReadString('dianetp');
     end;
  reg.CloseKey;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',False) then
     if reg.ValueExists('dianetdialer') then
       if reg.ReadString('dianetdialer')<>'' then AutoRun.Checked:=True;

  reg.CloseKey;
  reg.Destroy;

end;
procedure TForm1.DoConnect;
var
  e:DWORD;
  ErrTitle,ErrHint:String;
  WErrHint:WideString;
  s:array [0..512] of WideChar;
begin
  Button1.Enabled:=false;
  if Login.Caption='' then
    begin
       CreateError('Ошибка','Логин не указан',bfInfo,False);
       Button1.Enabled:=true;
      Exit;
    end;
  if Pass.Caption='' then
    begin
       CreateError('Ошибка','Пароль не указан',bfInfo,False);
       Button1.Enabled:=true;
      Exit;
    end;
  Connecting:=True;
  e:=connect();
  if e<>0 then
    begin
      ErrTitle:='Ошибка подключения: '+IntToStr(e);
      RasGetErrorStringW(e,s,SizeOf(s));
      WErrHint:=s;
      ErrHint:=UTF8Encode(WErrHint);
      CreateError(ErrTitle,ErrHint,bfError,True);
      disconnect();
      Connecting:=False;
      Connected:=False;
      Button1.Enabled:=true;
    end;
  Button2.Enabled:=true;
  end;

function TForm1.connect():DWORD;
var
  a,dwSize:Longint;
  lpfPassword:LongBool;
  RE: RASENTRY;
  RD: RASDIALPARAMSW;
  Conn:TConnectionType;
begin
  ConnectError:=False;
  Conn:=TConnectionType.Create(ConnType);

  dwSize:=sizeof(RasEntry);
  Fillchar(RE, dwSize, 0);
  RE.dwSize := dwSize;
  a:=0;

  Result:=RasGetEntryPropertiesW(nil,Conn.EntryName,@RE,dwSize,nil,a);
  {$ifndef DEBUG}
  RE.dwfOptions:=RASEO_RemoteDefaultGateway + RASEO_RequireCHAP + RASEO_RequirePAP;
  {$else}
  RE.dwfOptions:=RASEO_RequireCHAP + RASEO_RequirePAP;
  {$endif}
  //RE.dwfOptions2:=RASEO2_Internet + RASEO2_ReconnectIfDropped;
  RE.dwfOptions2:=RASEO2_ReconnectIfDropped;

  RE.szLocalPhoneNumber:=Conn.PhoneNumber;
  RE.dwfNetProtocols:=RASNP_Ip;
  RE.dwFramingProtocol:=RASFP_Ppp;

  RE.szDeviceType:=Conn.DeviceType;
  RE.szDeviceName:=Conn.DeviceName;

  RE.dwEncryptionType:=ET_Optional;

  RE.dwType:=Conn.ConnType;
  RE.dwVpnStrategy:=VS_PptpFirst;
  RE.dwRedialCount:=99;
  RE.dwRedialPause:=120;
  RE.dwIdleDisconnectSeconds:=RASIDS_Disabled;

  Result:=RasSetEntryPropertiesW(nil, Conn.EntryName, @RE, sizeof(RasEntry), nil, 0);

  Fillchar(RD, sizeof(RASDIALPARAMSW), 0);
  RD.dwSize:=SizeOf(RASDIALPARAMSW);
  RD.szEntryName:=Conn.EntryName;

  Result:=RasGetEntryDialParamsW(nil,RD,lpfPassword);

  RD.szUserName:=Form1.Login.Text;
  RD.szPassword:=Form1.Pass.Text;

  Result:=RasDialW(nil,nil,RD,1,@Callback,hConn);
  Conn.Destroy;
  if Result<>0 then Exit;

  dEvent:=CreateEvent(nil, true, false, nil);
  RasConnectionNotification(hConn,dEvent,RASCN_Disconnection);
  Discon:=TDisconThread.Create(False);
end;


procedure TForm1.DoDisconnect;
begin
  Connecting:=True;
  Tray.Hint:=DIASTR+'Отключение...';
  Tray.BalloonHint:='Отключение...';
  Tray.BalloonTitle:=DIANETSTR;
  Tray.BalloonFlags:=bfInfo;
  Tray.ShowBalloonHint;
  disconnect();
end;


procedure TDisconThread.Execute;
begin
  WaitForSingleObject(dEvent, INFINITE);

  Form1.Tray.Hint:=DIASTR+'Не подключен';
  if FShow then CreateError(DIANETSTR,'Отключен',bfInfo,False);
  if not Connecting then
    CreateError(DIANETSTR,'Соединение прервано',bfInfo,False);
    begin
      Form1.Button1.Enabled:=true;
      Form1.Button2.Enabled:=false;
    end;
  Connected:=False;
  Connecting:=False;

  ResetEvent(dEvent);
  CloseHandle(dEvent);
  hConn:=0;
end;

{ TDisconThread }
Constructor TDisconThread.Create(CreateSuspended : boolean);
begin
  FreeOnTerminate := True;
  FShow:=True;
  inherited Create(CreateSuspended);
end;



end.
