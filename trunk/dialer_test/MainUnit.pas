unit MainUnit;

{$mode objfpc}{$H+}
//{$define DEBUG}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, ExtCtrls, StdCtrls,
  Menus, Buttons, RASUnit, Windows, Registry, GraphType, FPimage, IntfGraphics,
  Dialogs, Utils, news, balance,ipconfig;

type

  TSetRCT = class(TThread)
  private
    procedure SetTime;
  protected
    procedure Execute; override;
  public
  end;

  TSetNewsTimer = class(TThread)
  private
    procedure SetTimer;
  protected
    procedure Execute; override;
  public
  end;

  { TMyEdit }

  TMyEdit = class(TEdit)
  public
    procedure EraseBackground(DC: HDC); override;
    procedure Paint;
    property EchoMode;
  end;


  { TMyStaticText }

  TMyStaticText = class(TStaticText)
  public
    procedure Paint;
  end;


  { TConfigForm }

  TConfigForm = class(TForm)
    AutoRun: TCheckBox;
    Autoconnect: TCheckBox;
    ConnSel: TComboBox;
    CustomEdit: TEdit;
    ConnImg: TImage;
    ConfImg: TImage;
    CloseImg: TImage;
    ConnSelImg: TImage;
    AutorunImg: TImage;
    AutoConnectImg: TImage;
    AboutBtn: TMenuItem;
    Image1: TImage;
    diagnos: TMenuItem;
    SayProblem: TMenuItem;
    DoUpdateProgram: TMenuItem;
    LKab: TMenuItem;
    MenuItem4: TMenuItem;
    Dopolnitelno: TMenuItem;
    Pogoda: TMenuItem;
    ReTrakerBtn: TMenuItem;
    ShowNews: TTimer;
    BalanceText: TMyStaticText;
    StaticText1: TStaticText;
    TimerReConnect: TTimer;
    TraffTimer: TTimer;
    RemPassImg: TImage;
    SiteLink: TImage;
    UpdateTimer: TIdleTimer;
    okImg: TImage;
    RemPass: TCheckBox;
    ConnectBtn: TMenuItem;
    DisconBtn: TMenuItem;
    CloseBtn: TMenuItem;
    Login: TMyEdit;
    Pass: TMyEdit;
    OpenConfig: TMenuItem;
    Popup: TPopupMenu;
    Tray: TTrayIcon;
    procedure AboutBtnClick(Sender: TObject);
    procedure AutoconnectChange(Sender: TObject);
    procedure AutoRunChange(Sender: TObject);
    procedure BgImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure BgImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure BgImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Button1Click(Sender: TObject);
    procedure CabinetBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure CloseImgClick(Sender: TObject);
    procedure CloseImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure CloseImgMouseEnter(Sender: TObject);
    procedure CloseImgMouseLeave(Sender: TObject);
    procedure CloseImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ConfImgClick(Sender: TObject);
    procedure ConfImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ConfImgMouseEnter(Sender: TObject);
    procedure ConfImgMouseLeave(Sender: TObject);
    procedure ConfImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ConnectBtnClick(Sender: TObject);
    procedure ConnImgClick(Sender: TObject);
    procedure ConnImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ConnImgMouseEnter(Sender: TObject);
    procedure ConnImgMouseLeave(Sender: TObject);
    procedure ConnImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ConnSelChange(Sender: TObject);
    procedure ConnSelClick(Sender: TObject);
    procedure CustomComboBoxChange(Sender: TObject);
    procedure DisconBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoSiteClick(Sender: TObject);
    procedure DoUpdateProgramClick(Sender: TObject);
    procedure LKabClick(Sender: TObject);
    procedure diagnosClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure PogodaClick(Sender: TObject);
    procedure UpdateProgramClick(Sender: TObject);
    procedure SayProblemClick(Sender: TObject);
    procedure okImgClick(Sender: TObject);
    procedure okImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure okImgMouseEnter(Sender: TObject);
    procedure okImgMouseLeave(Sender: TObject);
    procedure okImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure OpenConfigClick(Sender: TObject);
    procedure PassChange(Sender: TObject);
    procedure PassClick(Sender: TObject);
    procedure PopupClose(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure RemPassChange(Sender: TObject);
    procedure ReTrakerBtnClick(Sender: TObject);
    procedure ShowNewsTimer(Sender: TObject);
    procedure SiteImgMouseLeave(Sender: TObject);
    procedure SiteLinkClick(Sender: TObject);
    procedure SiteLinkMouseEnter(Sender: TObject);
    procedure SiteLinkMouseLeave(Sender: TObject);
    procedure StartNewsThread(Sender: TObject);
    procedure TimerReConnectTimer(Sender: TObject);
    procedure TraffTimerTimer(Sender: TObject);
    procedure TrayClick(Sender: TObject);
    procedure TrayDblClick(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    { private declarations }
    function connect(): DWORD;
    procedure DoConnect;
    function disconnect(): boolean;
    procedure DoDisconnect;
    procedure LoadConfig;
    procedure SaveConfig;
    procedure LButtonDown(x, y: integer);
    procedure LButtonUp(x, y: integer);
    procedure FormMouseMove(x, y: integer);
    procedure UpdateWin;
    procedure CheckRegForl2tp;
    function Reboot(RebootParam: longword): boolean;
  protected

  public
    { public declarations }
  end;

  TDisconThread = class(TTHread)
  private
    FShow: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    property ShowDiscon: boolean read FShow write FShow;
  end;

// *** процедуры ***

procedure DoEvent(number: integer);


var
  ConfigForm: TConfigForm;
  CanExit: boolean = False;
  FirstStart: boolean = True;
  LastError: integer = 0;
  Filial: PChar;

  SetNewsTimer: TSetNewsTimer;
  SetRCT: TSetRCT;

  MessageForNews: WideString = '';

  ConnectNumber: integer = 0;
  CompleteConnect: integer = 0;

  Connecting: boolean = False;
  Connected: boolean = False;

  ConnectError: boolean = False;
  UnBinding: boolean = False;
  PopUpVisible: boolean = False;
  ConnType: integer;
  ConnSuffix: string;

  Capturing: boolean = False;
  MouseDownSpot: TPoint;

  hConn: HRasConn;
  dEvent: HANDLE;
  Discon: TDisconThread;

  png: Graphics.TPicture;
  bmp: Graphics.TBitmap;
  BlendFunction: TBlendFunction;
  BitmapPos, TopLeft: Classes.TPoint;
  BitmapSize: TSize;

  confvisible: boolean = True;
  PassChanged: boolean = False;

  tx, rx: QWord;

implementation

procedure CreateError(title, hint: string; flag: TBalloonFlags; disconnect: boolean);
begin
  if flag = bfError then
    if ConnectError then
      exit
    else
      ConnectError := True;
  ConfigForm.Tray.BalloonTitle := title;
  ConfigForm.Tray.BalloonHint := hint;
  ConfigForm.Tray.BalloonFlags := flag;
  ConfigForm.Tray.ShowBalloonHint;
  if disconnect then
  begin
    if Assigned(Discon) then
      Discon.ShowDiscon := False;
    ConfigForm.disconnect();
  end;
end;

procedure Callback(hrasconn: HRasConn; msg: integer; state: RASCONNSTATE;
  error, dwExtendedError: integer); stdcall;
var
  ErrTitle, ErrHint: string;
  WErrHint: WideString;
  s: array [0..512] of widechar;
  e: integer;
begin
  try
    if (error > 600) or (dwExtendedError > 600) then
    begin
      LastError := error;

      case error of       // передаём в эвент номер ошибки
        629: DoEvent(629);
        630: DoEvent(630);
        633: DoEvent(633);
        691: DoEvent(691);
        692: DoEvent(692);
        800: DoEvent(800);
      end;

      if Assigned(Discon) then
        Discon.ShowDiscon := False;
      ConfigForm.disconnect();

      if dwExtendedError > 600 then
        error := dwExtendedError;

      ErrTitle := 'Ошибка подключения: ' + IntToStr(error);

      e := RasGetErrorStringW(error, s, SizeOf(s));
      WErrHint := s;
      ErrHint := UTF8Encode(WErrHint);
      CreateError(ErrTitle, ErrHint, bfError, False);
    end;

    case state of
      RASCS_Connected:
      begin
        ConfigForm.Tray.Hint := DIASTR + 'Подключен';
        CreateError(DIANETSTR, 'Подключен', bfInfo, False);
        ConfigForm.DisconBtn.Enabled := True;
        ConfigForm.Tray.Icon.LoadFromLazarusResource('icon_tray_connect');
        Connected := True;
        Connecting := False;
        ConfigForm.ConnImg.Picture.LoadFromLazarusResource('button_disconnect');
        ConfigForm.Visible := False;
        CheckUpdate;
        tx := 0;
        rx := 0;
        CompleteConnect := CompleteConnect + 1;
        LastError := 0;
        DoEvent(0);
      end;
      RASCS_Authenticate: CreateError(DIANETSTR, 'Авторизация...',
          bfInfo, False);
      RASCS_Authenticated: CreateError(
          DIANETSTR, 'Авторизация прошла успешно',
          bfInfo, False);
    end;
  except
    ConfigForm.disconnect();
  end;
  Connecting := False;
end;

{ TDisconThread }
constructor TDisconThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  FShow := True;
  inherited Create(CreateSuspended);
end;

procedure TDisconThread.Execute;
begin
  WaitForSingleObject(dEvent, INFINITE);

  ConfigForm.Tray.Hint := DIASTR + 'Не подключен';
  if FShow then
    CreateError(DIANETSTR, 'Отключен', bfInfo, False);
  if not Connecting then
  begin
    CreateError(DIANETSTR, 'Соединение прервано', bfInfo, False);
    DoEvent(100);
  end;
  ConfigForm.ConnectBtn.Enabled := True;
  ConfigForm.DisconBtn.Enabled := False;
  ConfigForm.Tray.Icon.LoadFromLazarusResource('icon_tray_disconnect');

  Connected := False;
  Connecting := False;

  ConfigForm.ConnImg.Picture.LoadFromLazarusResource('button_connect');

  ResetEvent(dEvent);
  CloseHandle(dEvent);
  hConn := 0;
end;

{ TConfigForm }
procedure TConfigForm.SaveConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('\Software\DIANET', True) then
  begin
    reg.WriteInteger('conntype', ConnType);
    reg.WriteBool('autoconnect', Autoconnect.Checked);
    reg.WriteBool('rempass', RemPass.Checked);
    reg.WriteString('dianetl', Login.Caption);
    if RemPass.Checked then
      reg.WriteString('dianetp', Pass.Caption)
    else
      reg.WriteString('dianetp', '');
  end;
  reg.CloseKey;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then
    if AutoRun.Checked then
      reg.WriteString('dianetdialer', Application.ExeName)
    else if reg.ValueExists('dianetdialer') then
      reg.DeleteValue('dianetdialer');
  reg.CloseKey;
  reg.Destroy;
end;

procedure TConfigForm.LoadConfig;
var
  reg: TRegistry;
  i:integer;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('\Software\DIANET', True) then
  begin
    if reg.ValueExists('conntype') then
      ConnType := reg.ReadInteger('conntype');
    if (ConnType > MAX_CONN_TYPE) or (ConnType < MIN_CONN_TYPE) then
      ConnType := VPN;
    case ConnType of
      VPN: ConnSel.Text := 'VPN (default)';
      PPPoE: ConnSel.Text := 'PPPoE';
      VPN_POLI: ConnSel.Text := 'VPN (Политех)';
    end;
    i:=CheckConnectType;
    if (i = 1) then
      ConnType := VPN;
    if (i = 2) then
      ConnType := VPN_POLI;
    if (i = 4) then
      ConnType := PPPoE;

    case ConnType of
      VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
      VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
      PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
    end;

    if reg.ValueExists('autoconnect') then
      Autoconnect.Checked := reg.ReadBool('autoconnect');
    if Autoconnect.Checked then
      AutoConnectImg.Picture.LoadFromLazarusResource('checked')
    else
      AutoConnectImg.Picture.LoadFromLazarusResource('not_checked');

    if reg.ValueExists('rempass') then
      RemPass.Checked := reg.ReadBool('rempass');
    if RemPass.Checked then
      RemPassImg.Picture.LoadFromLazarusResource('checked')
    else
      RemPassImg.Picture.LoadFromLazarusResource('not_checked');

    if reg.ValueExists('dianetl') then
      Login.Caption := reg.ReadString('dianetl');
    if RemPass.Checked then
      if reg.ValueExists('dianetp') then
        Pass.Caption := reg.ReadString('dianetp');
  end;
  reg.CloseKey;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then
    if reg.ValueExists('dianetdialer') then
      if reg.ReadString('dianetdialer') <> '' then
        AutoRun.Checked := True;
  if AutoRun.Checked then
    AutorunImg.Picture.LoadFromLazarusResource('checked')
  else
    AutorunImg.Picture.LoadFromLazarusResource('not_checked');

  reg.CloseKey;
  reg.Destroy;
  PassChanged := False;
end;

function TConfigForm.connect(): DWORD;
var
  a, dwSize: longint;
  lpfPassword: longbool;
  RE: RASENTRY;
  RD: RASDIALPARAMSW;
  Conn: TConnectionType;
  C: array[0..100] of char;
begin
  ConnectError := False;
  Conn := TConnectionType.Create(ConnType);

  dwSize := sizeof(RasEntry);
  Fillchar(RE, dwSize, 0);
  RE.dwSize := dwSize;
  a := 0;

  Result := RasGetEntryPropertiesW(nil, Conn.EntryName, @RE, dwSize, nil, a);
  {$ifndef DEBUG}
  RE.dwfOptions := RASEO_RemoteDefaultGateway + RASEO_RequireCHAP + RASEO_RequirePAP;
  {$else}
  RE.dwfOptions := RASEO_RequireCHAP + RASEO_RequirePAP;
  {$endif}
  //RE.dwfOptions2:=RASEO2_Internet + RASEO2_ReconnectIfDropped;
  RE.dwfOptions2 := RASEO2_Internet;

  RE.szLocalPhoneNumber := Conn.PhoneNumber;
  RE.dwfNetProtocols := RASNP_Ip+RASNP_Ipv6;
  RE.dwFramingProtocol := RASFP_Ppp;

  RE.szDeviceType := Conn.DeviceType;
  RE.szDeviceName := Conn.DeviceName;

  RE.dwEncryptionType := ET_Optional;

  RE.dwType := Conn.ConnType;
  RE.dwVpnStrategy := VS_L2tpOnly;
  //RE.dwRedialCount:=0;
  //RE.dwRedialPause:=0;
  RE.dwIdleDisconnectSeconds := RASIDS_Disabled;

  Result := RasSetEntryPropertiesW(nil, Conn.EntryName, @RE, sizeof(RasEntry), nil, 0);

  Fillchar(RD, sizeof(RASDIALPARAMSW), 0);
  RD.dwSize := SizeOf(RASDIALPARAMSW);
  RD.szEntryName := Conn.EntryName;

  Result := RasGetEntryDialParamsW(nil, RD, lpfPassword);

  RD.szUserName := ConfigForm.Login.Text;
  RD.szPassword := ConfigForm.Pass.Text;

  Application.ProcessMessages;

  Result := RasDialW(nil, nil, RD, 1, @Callback, hConn);
  Conn.Destroy;
  if Result <> 0 then
  begin
    RasGetErrorString(Result, C, 100);
    MessageBox(0, C, 'Dianet Dialer ERROR', MB_OK);
    // возвращаем кнопки в исходное положение
    Discon.ShowDiscon := False;
    ConfigForm.disconnect();
    Connecting := False;
    Connected := False;
    // вернули кнопки
    Exit;
  end;

  dEvent := CreateEvent(nil, True, False, nil);
  RasConnectionNotification(hConn, dEvent, RASCN_Disconnection);
  Discon := TDisconThread.Create(False);
end;

function TConfigForm.disconnect(): boolean;
begin
  Result := False;
  if RasHangUpW(hConn) = SUCCESS then
  begin
    Result := True;
    DisconBtn.Enabled := False;

    Connected := False;
    Connecting := False;

    ConnImg.Picture.LoadFromLazarusResource('button_connect');
  end;
end;

procedure TConfigForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ConfigForm.Visible then
    ConfigForm.Visible := False;
  if not CanExit then
    CanClose := False;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
begin
  // проверяем параметры реестра для ХР + l2tp
  if IsOldWindows = 5 then
    CheckRegForl2tp;

  Filial:= 'other';
  CheckIp;

  DianetPPPDisconnect;

  Tray.Hint := DIASTR + 'Не подключен';
  Pass.EchoMode := emPassword;

  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or
    WS_EX_LAYERED);
  //SetLayeredWindowAttributes(Handle,$ff00ff,200,LWA_ALPHA or LWA_COLORKEY);

  png := TPicture.Create;
  png.LoadFromLazarusResource('orange_white');

  BitmapPos := Classes.Point(0, 0);
  BitmapSize.cx := png.Width;
  BitmapSize.cy := png.Height;

  TopLeft := Classes.Point(Left, Top);

  // Setup alpha blending parameters
  BlendFunction.BlendOp := AC_SRC_OVER;
  BlendFunction.BlendFlags := 0;
  BlendFunction.SourceConstantAlpha := 255;
  BlendFunction.AlphaFormat := AC_SRC_ALPHA;

  png.Bitmap.Canvas.Font.Style := [fsItalic];
  png.Bitmap.Canvas.Font.FPColor := colBlack;

  CheckIp;
end;

procedure TConfigForm.FormHide(Sender: TObject);
begin
  UpdateTimer.Enabled := False;
end;

procedure TConfigForm.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  UpdateWin;
end;

procedure TConfigForm.UpdateWin;
var
  DC, tmpDC: HDC;
begin
  Width := 430;
  Height := 372;

  TopLeft.X := Left;
  TopLeft.Y := Top;

  DC := GetWindowDC(Handle);
  tmpDC := CreateCompatibleDC(DC);
  png.Bitmap.Canvas.Draw(CloseImg.Left, CloseImg.Top, CloseImg.Picture.Bitmap);
  png.Bitmap.Canvas.Draw(ConnImg.Left, ConnImg.Top, ConnImg.Picture.Bitmap);
  png.Bitmap.Canvas.Draw(ConfImg.Left, ConfImg.Top, ConfImg.Picture.Bitmap);

  png.Bitmap.Canvas.Draw(SiteLink.Left, SiteLink.Top, SiteLink.Picture.Bitmap);

  if confvisible then
  begin
    png.Bitmap.Canvas.Draw(okImg.Left, okImg.Top, okImg.Picture.Bitmap);
    png.Bitmap.Canvas.Draw(ConnSelImg.Left, ConnSelImg.Top, ConnSelImg.Picture.Bitmap);

    Login.Paint;
    Pass.Paint;

    png.Bitmap.Canvas.Draw(RemPassImg.Left, RemPassImg.Top, RemPassImg.Picture.Bitmap);
    png.Bitmap.Canvas.Draw(AutorunImg.Left, AutorunImg.Top, AutorunImg.Picture.Bitmap);
    png.Bitmap.Canvas.Draw(AutoConnectImg.Left, AutoConnectImg.Top,
      AutoConnectImg.Picture.Bitmap);
  end;
  if BalanceFound = True then
    BalanceText.Paint;

  // ... and action!
  UpdateLayeredWindow(Handle, tmpDC, @TopLeft, @BitmapSize,
    png.Bitmap.Canvas.Handle, @BitmapPos, 0, @BlendFunction, ULW_ALPHA);

  DeleteObject(tmpDC);
  ReleaseDC(Handle, DC);
end;

procedure TConfigForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LButtonDown(x, y);
end;

procedure TConfigForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  FormMouseMove(x, y);
end;

procedure TConfigForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LButtonUp(x, y);
end;

procedure TConfigForm.FormPaint(Sender: TObject);
begin
  UpdateWin;
end;

procedure TConfigForm.FormShow(Sender: TObject);

begin
  UpdateTimer.Enabled := True;
  if FirstStart then
  begin
    FirstStart := False;
    LoadConfig();
    if Autoconnect.Checked then
      DoConnect;
  end;
end;

procedure TConfigForm.GoSiteClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', DIANET_SITE, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.SayProblemClick(Sender: TObject);
var
  url: string;
begin
  url := 'http://bt.dianet.info/viewforum.php?f=86';
  ShellExecute(Handle, 'open', PChar(url), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.DoUpdateProgramClick(Sender: TObject);
begin
  case DoUpdateProgramm of
    1: ShowMEssage('Нет доступных обновлений');
    3: ShowMEssage('Проблема доступа для обновления');
  end;
end;

procedure TConfigForm.LKabClick(Sender: TObject);
var
  caburl: string;
begin
  if not Connected and (ConnType = PPPOE) then
    Exit;
  caburl := 'https://billing.dianet.info:40000/cgi-bin/login.cgi?login=' +
    Login.Caption + '&pass=' + Pass.Caption + '&handler=/cgi-bin/main.cgi';
  ShellExecute(Handle, 'open', PChar(caburl), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.diagnosClick(Sender: TObject);
begin
  ConfigForm.Hide;
  Form1.Show;
end;

procedure TConfigForm.MenuItem4Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', DIANET_SITE, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.PogodaClick(Sender: TObject);
begin
  if (Connecting = True) then
    exit;

  if Connected = False then
  begin
    DoConnect;
  end;

  if Filial = 'aleysk' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/aleysk/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'belokuriha' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/zarinsk/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'rubtsovsk' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/rubtsovsk/',
      nil, nil, SW_SHOWMAXIMIZED)
  else if Filial = 'barnaul' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/barnaul/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'novoalt' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/novoaltaysk/',
      nil, nil, SW_SHOWMAXIMIZED)
  else if Filial = 'zarinsk' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/zarinsk/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'biysk' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/biysk/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'sibir' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/sibirskij/', nil,
      nil, SW_SHOWMAXIMIZED)
  else if Filial = 'other' then
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/barnaul/', nil,
      nil, SW_SHOWMAXIMIZED)
  else
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/barnaul/', nil,
      nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.UpdateProgramClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'updater.exe', nil, nil, SW_normal);
end;

procedure TConfigForm.okImgClick(Sender: TObject);
begin
  SaveConfig;
  png.LoadFromLazarusResource('white');
  confvisible := False;
end;

procedure TConfigForm.okImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  okImg.Picture.LoadFromLazarusResource('ok_push');
end;

procedure TConfigForm.okImgMouseEnter(Sender: TObject);
begin
  okImg.Picture.LoadFromLazarusResource('ok_invert');
end;

procedure TConfigForm.okImgMouseLeave(Sender: TObject);
begin
  okImg.Picture.LoadFromLazarusResource('ok');
end;

procedure TConfigForm.okImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (X > 0) and (X < okImg.Width) and (Y > 0) and (Y < okImg.Height) then
    okImg.Picture.LoadFromLazarusResource('ok_invert');
end;

procedure TConfigForm.OpenConfigClick(Sender: TObject);
begin
  ConfigForm.Visible := True;

  confvisible := True;
  png.LoadFromLazarusResource('orange_white');
  case ConnType of
    VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
    VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
    PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
  end;
end;

procedure TConfigForm.PassChange(Sender: TObject);
begin
  PassChanged := True;
end;

procedure TConfigForm.PassClick(Sender: TObject);
begin
  PassChanged := True;
end;

procedure TConfigForm.PopupClose(Sender: TObject);
begin
  PopUpVisible := False;
end;

procedure TConfigForm.PopupPopup(Sender: TObject);
begin
  PopUpVisible := True;
end;

procedure TConfigForm.RemPassChange(Sender: TObject);
begin
  if RemPass.Checked then
    RemPassImg.Picture.LoadFromLazarusResource('checked')
  else
    RemPassImg.Picture.LoadFromLazarusResource('not_checked');
end;

procedure TConfigForm.ReTrakerBtnClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', RETRAKER_URL, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.ShowNewsTimer(Sender: TObject);
begin
  if (NewsFound = True) or (Length(MessageForNews) > 2)
    or (AllowNewsWindow=true)then
  begin
    NewsForm.Show;
    ShowNews.Enabled := False;
    AllowNewsWindow:=false;
  end;
  if NewsCounter > 20 then
    ShowNews.Enabled := False;
end;

procedure TConfigForm.SiteImgMouseLeave(Sender: TObject);
begin
  if confvisible then
  begin
    png.LoadFromLazarusResource('orange_white');
    case ConnType of
      VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
      VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
      PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
    end;
  end
  else
    png.LoadFromLazarusResource('white');
end;

procedure TConfigForm.SiteLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', DIANET_SITE, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.SiteLinkMouseEnter(Sender: TObject);
begin
  SiteLink.Picture.LoadFromLazarusResource('copyright_invert');
end;

procedure TConfigForm.SiteLinkMouseLeave(Sender: TObject);
begin
  if not confvisible then
    png.LoadFromLazarusResource('white')
  else
  begin
    png.LoadFromLazarusResource('orange_white');
    case ConnType of
      VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
      VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
      PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
    end;
  end;
  SiteLink.Picture.LoadFromLazarusResource('copyright');
end;

procedure TConfigForm.StartNewsThread(Sender: TObject);
begin
  Newsthread := TNewsThread.Create(False);
  Newsthread.FreeOnTerminate := True;
  Newsthread.Resume;
end;

procedure TConfigForm.TimerReConnectTimer(Sender: TObject);
begin
  // если нет успешных подключений то отключаемся
  if CompleteConnect=0 then
  begin
    ConfigForm.TimerReconnect.Enabled := False;
  end;
  // если число номер попытки коннекта больше 40 то отключаем реконнекты
  if ConnectNumber > 40 then
  begin
    ConfigForm.TimerReConnect.Enabled := False;
    exit;
  end
  else if Connected = True or Connecting = True then
    Exit
  else
  begin
    ConfigForm.DoConnect();
  end;
end;

procedure TConfigForm.TraffTimerTimer(Sender: TObject);
var
  stat: TRAS_STATS;
  rxhint, txhint: string;
begin
  if Connected then
  begin
    stat.dwSize := SizeOf(TRAS_STATS);
    stat.dwBytesXmited := 0;
    stat.dwBytesRcved := 0;
    RasGetConnectionStatistics(hConn, @stat);
    rx := rx + stat.dwBytesRcved;
    tx := tx + stat.dwBytesXmited;
    RasClearConnectionStatistics(hConn);

    if rx >= 1048576 then
      rxhint := 'Мегабайт принято: ' + IntToStr(
        round(rx / (1024 * 1024))) + PERENOS
    else if tx >= 1024 then
      rxhint := 'Килобайт принято: ' +
        IntToStr(round(rx / 1024)) + PERENOS
    else
      rxhint := 'Байт принято: ' + IntToStr(rx) + PERENOS;

    if tx >= 1048576 then
      txhint := 'Мегабайт передано: ' +
        IntToStr(round(tx / (1024 * 1024)))
    else if tx >= 1024 then
      txhint := 'Килобайт передано: ' + IntToStr(round(tx / 1024))
    else
      txhint := 'Байт передано: ' + IntToStr(tx);

    Tray.Hint := 'ДИАНЭТ' + PERENOS + 'Подключен' +
      PERENOS + rxhint + txhint;
  end
  else if Connected = False then
  begin
    Tray.Hint := 'ДИАНЭТ' + PERENOS + 'Не подключен';
  end;
end;

procedure TConfigForm.TrayClick(Sender: TObject);
begin
  ConfigForm.Visible := True;
end;

procedure TConfigForm.TrayDblClick(Sender: TObject);
begin
  ConfigForm.Visible := True;
end;

procedure TConfigForm.UpdateBtnClick(Sender: TObject);
begin

end;

procedure TConfigForm.UpdateTimerTimer(Sender: TObject);
begin
  UpdateWin;
end;

procedure TConfigForm.CloseBtnClick(Sender: TObject);
begin
  CanExit := True;
  Close;
end;

procedure TConfigForm.BgImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LButtonDown(x, y);
end;

procedure TConfigForm.AutoRunChange(Sender: TObject);
begin
  if AutoRun.Checked then
    AutorunImg.Picture.LoadFromLazarusResource('checked')
  else
    AutorunImg.Picture.LoadFromLazarusResource('not_checked');
end;

procedure TConfigForm.AutoconnectChange(Sender: TObject);
begin
  if Autoconnect.Checked then
    AutoConnectImg.Picture.LoadFromLazarusResource('checked')
  else
    AutoConnectImg.Picture.LoadFromLazarusResource('not_checked');
end;

procedure TConfigForm.AboutBtnClick(Sender: TObject);
begin
  MessageBoxW(Handle, PWideChar(
    UTF8Decode('    Dianet Dialer, Версия ' + VERSION + PERENOS +
    'Автор программы ' + AUTHOR + PERENOS +
    '                           ©' + DIANETSTR + ',2011')),
    PWideChar(UTF8Decode('О программе Dianet Dialer')),
    MB_ICONQUESTION);
end;

procedure TConfigForm.BgImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  FormMouseMove(x, y);
end;

procedure TConfigForm.BgImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  LButtonUp(x, y);
end;

procedure TConfigForm.Button1Click(Sender: TObject);
begin

end;

procedure TConfigForm.CabinetBtnClick(Sender: TObject);
var
  caburl: string;
begin
  if not Connected then
    Exit;
  caburl := 'https://billing.dianet.info:40000/cgi-bin/login.cgi?login=' +
    Login.Caption + '&pass=' + Pass.Caption + '&handler=/cgi-bin/main.cgi';
  ShellExecute(Handle, 'open', PChar(caburl), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TConfigForm.CloseImgClick(Sender: TObject);
begin
  ConfigForm.Visible := False;
end;

procedure TConfigForm.CloseImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  CloseImg.Picture.LoadFromLazarusResource('quit_push');
end;

procedure TConfigForm.CloseImgMouseEnter(Sender: TObject);
begin
  CloseImg.Picture.LoadFromLazarusResource('quit_invert');
end;

procedure TConfigForm.CloseImgMouseLeave(Sender: TObject);
begin
  CloseImg.Picture.LoadFromLazarusResource('quit');
end;

procedure TConfigForm.CloseImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (X > 0) and (X < CloseImg.Width) and (Y > 0) and (Y < CloseImg.Height) then
    CloseImg.Picture.LoadFromLazarusResource('quit');
end;

procedure TConfigForm.ConfImgClick(Sender: TObject);
begin
  if confvisible then
  begin
    confvisible := False;
    png.LoadFromLazarusResource('white');
  end
  else
  begin
    confvisible := True;
    png.LoadFromLazarusResource('orange_white');
    case ConnType of
      VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
      VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
      PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
    end;
  end;
end;

procedure TConfigForm.ConfImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ConfImg.Picture.LoadFromLazarusResource('button_options_push');
end;

procedure TConfigForm.ConfImgMouseEnter(Sender: TObject);
begin
  ConfImg.Picture.LoadFromLazarusResource('button_options_invert');
end;

procedure TConfigForm.ConfImgMouseLeave(Sender: TObject);
begin
  ConfImg.Picture.LoadFromLazarusResource('button_options');
end;

procedure TConfigForm.ConfImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (X > 0) and (X < ConfImg.Width) and (Y > 0) and (Y < ConfImg.Height) then
    ConfImg.Picture.LoadFromLazarusResource('button_options_invert');
end;

procedure TConfigForm.DoConnect;
var
  e: DWORD;
  ErrTitle, ErrHint: string;
  WErrHint: WideString;
  s: array [0..512] of widechar;
begin
  ConnectBtn.Enabled := False;
  if Login.Caption = '' then
  begin
    CreateError('Ошибка', 'Логин не указан', bfInfo, False);
    ConnectBtn.Enabled := True;
    Exit;
  end;
  if Pass.Caption = '' then
  begin
    CreateError('Ошибка', 'Пароль не указан', bfInfo, False);
    ConnectBtn.Enabled := True;
    Exit;
  end;
  if Length(Pass.Caption) < 3 then
  begin
    CreateError('Ошибка', 'Пароль менее 3х символов',
      bfInfo, False);
    ConnectBtn.Enabled := True;
    Exit;
  end;

  ConnectBtn.Enabled := True;
  ConnImg.Picture.LoadFromLazarusResource('button_connecting');
  png.LoadFromLazarusResource('white');
  confvisible := False;

  Tray.Hint := DIASTR + 'Соединение...';
  Tray.BalloonHint := 'Соединение...';
  Tray.BalloonTitle := DIANETSTR;
  Tray.BalloonFlags := bfInfo;
  Tray.ShowBalloonHint;

  Connecting := True;
  ConnectBtn.Enabled := False;
  DisconBtn.Enabled := True;
  e := connect();
  Connecting := True;
  ConnectNumber := ConnectNumber + 1;
end;

procedure TConfigForm.ConnectBtnClick(Sender: TObject);
begin
  DoConnect;
  ConnectNumber := 0;
end;

procedure TConfigForm.ConnImgClick(Sender: TObject);
begin
  if Binding then
    exit;
  if not Connecting then
  begin
    if Connected then
    begin
      DoDisconnect;
    end
    else
    begin
      ConnectNumber := 0;
      DoConnect;
    end;
  end;
end;

procedure TConfigForm.ConnImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Binding then
    exit;
  if not Connecting then
  begin
    if Connected then
      ConnImg.Picture.LoadFromLazarusResource('button_disconnect_push')
    else
      ConnImg.Picture.LoadFromLazarusResource('button_connect_push');
  end;
end;

procedure TConfigForm.ConnImgMouseEnter(Sender: TObject);
begin
  if Binding then
    exit;
  if not Connecting then
  begin
    if Connected then
      ConnImg.Picture.LoadFromLazarusResource('button_disconnect_invert')
    else
      ConnImg.Picture.LoadFromLazarusResource('button_connect_invert');
  end;
end;

procedure TConfigForm.ConnImgMouseLeave(Sender: TObject);
begin
  if Binding then
    exit;
  if not Connecting then
  begin
    if Connected then
      ConnImg.Picture.LoadFromLazarusResource('button_disconnect')
    else
      ConnImg.Picture.LoadFromLazarusResource('button_connect');
  end;
end;

procedure TConfigForm.ConnImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Binding then
    exit;
  if UnBinding then
  begin
    UnBinding := False;
    if (Mouse.CursorPos.x - ConfigForm.Left - ConnImg.Left > 0) and
      (Mouse.CursorPos.x - ConfigForm.Left - ConnImg.Left < ConnImg.Width) and
      (Mouse.CursorPos.Y - ConfigForm.Top - ConnImg.Top > 0) and
      (Mouse.CursorPos.Y - ConfigForm.Top - ConnImg.Top < ConnImg.Height) then
      ConnImg.Picture.LoadFromLazarusResource('button_connect_invert')
    else
      ConnImg.Picture.LoadFromLazarusResource('button_connect');
    Exit;
  end;
  if (X > 0) and (X < ConnImg.Width) and (Y > 0) and (Y < ConnImg.Height) then
    if not Connecting then
    begin
      if Connected then
        ConnImg.Picture.LoadFromLazarusResource('button_disconnect_invert')
      else
        ConnImg.Picture.LoadFromLazarusResource('button_connect_invert');
    end;
end;

procedure TConfigForm.ConnSelChange(Sender: TObject);
var i:integer;
begin
  i:=  CheckConnectType;
  if (i = 1) then
    ConnType := VPN
  else if (i = 2) then
    ConnType := VPN_POLI
  else if (i = 4) then
    ConnType := PPPoE
  else
  begin
    if ConnSel.Text = 'PPPoE' then
      ConnType := PPPoE;
    if ConnSel.Text = 'VPN (default)' then
      ConnType := VPN;
    if ConnSel.Text = 'VPN (Политех)' then
      ConnType := VPN_POLI;
  end;

  case ConnType of
    VPN: ConnSelImg.Picture.LoadFromLazarusResource('vpn');
    VPN_POLI: ConnSelImg.Picture.LoadFromLazarusResource('vpn_poli');
    PPPoE: ConnSelImg.Picture.LoadFromLazarusResource('pppoe');
  end;
end;

procedure TConfigForm.ConnSelClick(Sender: TObject);
begin

end;

procedure TConfigForm.CustomComboBoxChange(Sender: TObject);
begin

end;

procedure TConfigForm.DoDisconnect;
begin
  ConfigForm.TimerReConnect.Enabled := False;
  Connecting := True;
  Tray.Hint := DIASTR + 'Отключение...';
  Tray.BalloonHint := 'Отключение...';
  Tray.BalloonTitle := DIANETSTR;
  Tray.BalloonFlags := bfInfo;
  Tray.ShowBalloonHint;

  ConnectBtn.Enabled := False;
  DisconBtn.Enabled := False;
  disconnect();
end;

procedure TConfigForm.DisconBtnClick(Sender: TObject);
begin
  DoDisconnect;
end;

procedure TConfigForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DoDisconnect();
  SaveConfig;
end;

//Движение по мыши
//Left Down
procedure TConfigForm.LButtonDown(x, y: integer);
begin
  MouseDownSpot.x := x;
  MouseDownSpot.y := y;
  Capturing := True;
end;
//Left Up
procedure TConfigForm.LButtonUp(x, y: integer);
begin
  Capturing := False;
  MouseDownSpot.x := x;
  MouseDownSpot.y := y;
end;
//Move
procedure TConfigForm.FormMouseMove(x, y: integer);
begin
  if not Capturing then
    exit;
  ConfigForm.Top := ConfigForm.Top - (MouseDownSpot.Y - y);
  ConfigForm.Left := ConfigForm.Left - (MouseDownSpot.X - x);
  //MouseDownSpot:=Point(x,y);
end;

{ TMyEdit }

procedure TMyEdit.EraseBackground(DC: HDC);
begin
  //  inherited EraseBackground(DC);
end;

procedure TMyEdit.Paint;
var
  Bitmap: Graphics.TBitmap;
  cpos: integer;
  tmpstr: string;
  i: integer;
begin

  Bitmap := Graphics.TBitmap.Create;
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.PixelFormat := pf32bit;


  // Draws the background
  Bitmap.Canvas.Pen.FPColor := colDkGray;
  Bitmap.Canvas.Brush.FPColor := colBlack;
  Bitmap.Canvas.Rectangle(0, 0, Width, Height);
  Bitmap.Canvas.Font.FPColor := colWhite;

  tmpstr := Text;
  if EchoMode = emPassword then
  begin
    if PassChanged then
    begin
      tmpstr := '';
      if GetKeyboardLayout(GetWindowThreadProcessId(GetForegroundWindow, nil)) <>
        67699721 then
      begin
        Configform.Tray.Hint := 'Ошибка';
        Configform.Tray.BalloonHint :=
          'Раскладка клавиатуры переключена на английскую';
        Configform.Tray.BalloonTitle := 'Ошибка';
        Configform.Tray.BalloonFlags := bfInfo;
        Configform.Tray.ShowBalloonHint;

        LoadKeyboardLayout('00000409', KLF_ACTIVATE);
      end
      else
      begin
        if Length(Text) > 0 then
          for i := 1 to Length(Text) do
            tmpstr := tmpstr + '*';
      end;
    end
    else
    begin
      Bitmap.Canvas.Font.FPColor := colDkGray;
      Bitmap.Canvas.Font.Style := [fsItalic];
      tmpstr := 'Пароль...';
    end;
  end;

  if SelText <> '' then
  begin
    Bitmap.Canvas.TextOut(2, 2, tmpstr);

    cpos := GetSelStart;
    if cpos > 0 then
      cpos := Bitmap.Canvas.GetTextWidth(copy(tmpstr, 1, GetSelStart));
    Bitmap.Canvas.Brush.FPColor := colRed;

    Bitmap.Canvas.TextOut(cpos + 2, 2, copy(tmpstr, GetSelStart + 1, GetSelLength));
    Bitmap.Canvas.Brush.FPColor := colBlack;
  end
  else
    Bitmap.Canvas.TextOut(2, 2, tmpstr);

  // Draw caret
  if Focused then
  begin
    if EchoMode = emPassword then
      PassChanged := True;
    Bitmap.Canvas.Pen.FPColor := colLtGray;
    if CaretPos.x > 0 then
      cpos := Bitmap.Canvas.TextWidth(Copy(tmpstr, 1, CaretPos.x))
    else
      cpos := 0;
    Bitmap.Canvas.MoveTo(cpos + 2, 3);
    Bitmap.Canvas.LineTo(cpos + 2, Height - 3);
  end
  else
    Bitmap.Canvas.TextOut(2, 2, tmpstr);

  // Draw
  BitBlt(png.Bitmap.Canvas.Handle, Left, Top, Left + Width, Top + Height,
    Bitmap.Canvas.Handle, 0, 0, NOTSRCCOPY);

  Bitmap.Free;
  //  inherited Paint;
end;


procedure DoEvent(number: integer);

begin
  case number of
    629:
    begin
      ConfigForm.TimerReconnect.Enabled := False;
      CompleteConnect := 0;

          SetNewsTimer := TSetNewsTimer.Create(False);
          SetNewsTimer.FreeOnTerminate := True;
          SetNewsTimer.Resume;
    end;
    630:
    begin
      ConfigForm.TimerReconnect.Enabled := False;
      CompleteConnect := 0;

          SetNewsTimer := TSetNewsTimer.Create(False);
          SetNewsTimer.FreeOnTerminate := True;
          SetNewsTimer.Resume;
    end;
    633:
    begin
      ConfigForm.TimerReconnect.Enabled := False;
      CompleteConnect := 0;

          SetNewsTimer := TSetNewsTimer.Create(False);
          SetNewsTimer.FreeOnTerminate := True;
          SetNewsTimer.Resume;
    end;
    691:
    begin
      ConfigForm.TimerReconnect.Enabled := False;
      CompleteConnect := 0;

        BalanceThread := TBalanceThread.Create(False);
        BalanceThread.FreeOnTerminate := True;
        BalanceThread.Resume;
        BalanceThread.WaitFor;
        if BalanceFound=true then
        begin

          SetNewsTimer := TSetNewsTimer.Create(False);
          SetNewsTimer.FreeOnTerminate := True;
          SetNewsTimer.Resume;

        end;
    end;

    692:
    begin
      ConfigForm.TimerReconnect.Enabled := False;
      CompleteConnect := 0;
      HealError(692);

          SetNewsTimer := TSetNewsTimer.Create(False);
          SetNewsTimer.FreeOnTerminate := True;
          SetNewsTimer.Resume;
    end;

    0:
      // нуль это успешное соединение
    begin
      BalanceThread := TBalanceThread.Create(False);
      BalanceThread.FreeOnTerminate := True;
      BalanceThread.Resume;
      BalanceThread.WaitFor;

      // запускаем новости
      SetNewsTimer := TSetNewsTimer.Create(False);
      SetNewsTimer.FreeOnTerminate := True;
      SetNewsTimer.Resume;

    end;
    100:
      // "соединение потеряно", он же возможно дисконнект
      // или неудачное соединение
    begin
      if (LastError = 691) or (LastError = 651) or (LastError = 800) then
        exit;     // если 691 ошибка то реконнект не запускаем

      SetRCT := TSetRCT.Create(False);
      SetRCT.FreeOnTerminate := True;
      SetRCT.Resume;
    end;
  end;

end;


procedure TSetRCT.Execute;
begin
  Synchronize(@SetTime);
end;


procedure TSetRCT.SetTime;
var
  time, j, r: integer;
begin
  // r - коэффициент на что умножаем время рандомного генератора при длительных перебоях
  r := 1;
  // если число попыток больше 10 (~30 минут) то увеличиваем время в 3 раза
  // или опять упал биллинг
  if (Connectnumber > 10) or (LastError = 718) then
    r := 3;
  // включаем таймеры
  j := Roll(180000);
  time := r * (40000 + j);
  ConfigForm.TimerReConnect.Interval := time;
  ConfigForm.TimerReConnect.Enabled := True;

  if ConfigForm.TimerReConnect.Enabled = False then
    ConfigForm.ConnImg.Picture.LoadFromLazarusResource('button_connect');
  // +новости
  if CompleteConnect >= 3 then
    ConfigForm.ShowNews.Enabled := False
  else if CompleteConnect < 3 then
    ConfigForm.ShowNews.Enabled := True;
end;


procedure TMyStaticText.Paint;
var
  Bitmap: Graphics.TBitmap;
begin

  Bitmap := Graphics.TBitmap.Create;

  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.PixelFormat := pf32bit;

  Bitmap.Canvas.Font.Size := 10;
  Bitmap.Canvas.Font.Color := clWhite;

  Bitmap.Canvas.Brush.FPColor := colBlack;
  Bitmap.Canvas.Brush.Style := bsClear;

  Bitmap.Canvas.TextOut(0, 10, 'Ваш баланс: ' + BalanceStr);

  BitBlt(png.Bitmap.Canvas.Handle, Left, Top, Left + Width, Top +
    Height, Bitmap.Canvas.Handle, 0, 0, NOTSRCCOPY);
  Bitmap.Free;

end;

procedure TSetNewsTimer.Execute;
begin
  Synchronize(@SetTimer);
end;

procedure TSetNewsTimer.SetTimer;
begin
  if CompleteConnect >= 3 then
    ConfigForm.ShowNews.Enabled := False
  else
    ConfigForm.ShowNews.Enabled := True;
end;


procedure TConfigForm.CheckRegForl2tp;
var
  reg: TRegistry;
  i: integer;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey('System\CurrentControlSet\Services\Rasman\Parameters', True) then
  begin
    try
      i := reg.ReadInteger('ProhibitIpSec');
    except
      reg.WriteInteger('ProhibitIpSec', 1);
      i := 1;
      if MessageBoxW(Handle, PWideChar(
        UTF8Decode('Для корректной работы программы необходимо перезагрузить компьютер')), PWideChar(UTF8Decode('Dianet Dialer')), MB_ICONQUESTION + MB_YESNO) = idYes then
        reboot(EWX_REBOOT or EWX_FORCE);
    end;
    // проверяем если значение в реестре не равно нужному
    if i <> 1 then
    begin
      reg.WriteInteger('ProhibitIpSec', 1);
      if MessageBoxW(Handle, PWideChar(
        UTF8Decode('Для корректной работы программы необходимо перезагрузить компьютер')), PWideChar(UTF8Decode('Dianet Dialer')), MB_ICONQUESTION + MB_YESNO) = idYes then
        reboot(EWX_REBOOT or EWX_FORCE);
    end;
  end;
  reg.closekey;
  reg.Free;
end;


function TConfigForm.Reboot(RebootParam: longword): boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or
      TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil,
        SE_SHUTDOWN_NAME,
        TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd,
          False,
          TTokenPvg,
          cbtpPrevious,
          rTTokenPvg,
          pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;


initialization
  {$I MainUnit.lrs}
  {$I iface.lrs}

end.

