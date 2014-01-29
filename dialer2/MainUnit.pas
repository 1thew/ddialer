unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, RASUnit;

type
  TMainForm = class(TForm)
    Image1: TImage;
    Button1: TButton;
    BalanceText: TLabel;
    AutoRun: TCheckBox;
    SaveData: TCheckBox;
    TrayIcon: TTrayIcon;
    PopupMenu: TPopupMenu;
    N1String: TMenuItem;
    CloseBtn: TMenuItem;
    AboutBtn: TMenuItem;
    NetworkBtn: TMenuItem;
    Dopolnitelno: TMenuItem;
    LKabBtn: TMenuItem;
    PogodaBtn: TMenuItem;
    siteDianetru: TMenuItem;
    ErrorReport: TMenuItem;
    Site567567: TMenuItem;
    LoginEdit: TEdit;
    PassEdit: TEdit;
    Test: TButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure NetworkBtnClick(Sender: TObject);
    procedure LKabBtnClick(Sender: TObject);
    procedure Site567567Click(Sender: TObject);
    procedure siteDianetruClick(Sender: TObject);
    procedure PogodaBtnClick(Sender: TObject);
    procedure ErrorReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TestClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
  private
    CanExit:Boolean;                     // Нужна для кнопки "выход"
    Login: Ansistring;
    Pass: Ansistring;
    procedure LoadConfig;             // процедура загрузки логина/пароля
    procedure SaveConfig;             // процедура сохранения логина/пароля в реестр
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  hConn: HRasConn;
  Connecting:bool;
  Connected:bool;
  ConnectNumber:integer;

implementation

//объявим локальные модули
uses ShellApi,Registry, utils, Iphlp;
// ...объявили

{$R *.dfm}

procedure TMainForm.LoadConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('\Software\DIANET', True) then
  begin
      try
      // загрузим в форму логин
      LoginEdit.Text:=reg.ReadString('dianetl');
      Login:= reg.ReadString('dianetl');
      // пасс грузить не будем, присвоим в переменную и закрасим форму
      PassEdit.Text:='**пароль скрыт**';
      Pass:= reg.ReadString('dianetp');
      // галочка "запомнить"
      if reg.ValueExists('savedata') then
      begin
        if reg.ReadBool('savedata')=true then SaveData.Checked:=true;
      end;
      finally reg.CloseKey;
      end;
  end;
  // проверим автозагрузку, поставим галочку при загрузке
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then
      try
      if reg.ValueExists('dianetdialer') then
        if reg.ReadString('dianetdialer') <> '' then
          AutoRun.Checked := True;
      finally
        reg.CloseKey;
      end;
end;


procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
{    MessageBoxW(Handle, PWideChar(
    UTF8Decode('    Dianet Dialer, Версия ' + VERSION + PERENOS +
    'Автор программы ' + AUTHOR + PERENOS +
    '                           ©' + DIANETSTR + ',2014')),
    PWideChar(UTF8Decode('О программе Dianet Dialer')),
    MB_ICONQUESTION);     }
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  CanExit:=true;
  MainForm.Close;
end;

procedure TMainForm.ErrorReportClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://bt.dianet.info/viewforum.php?f=86', nil,
      nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SaveConfig;           // сохраним в реестр настройки
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanExit=true then CanClose := True
  else
  if MainForm.Visible=true then
  begin MainForm.Hide; CanClose := False;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadConfig;
end;

procedure TMainForm.LKabBtnClick(Sender: TObject);
//var
 // caburl: string;
begin
  {caburl := 'https://billing.dianet.info:40000/cgi-bin/login.cgi?login=' +
    Login.Caption + '&pass=' + Pass.Caption + '&handler=/cgi-bin/main.cgi';
  ShellExecute(Handle, 'open', PChar(caburl), nil, nil, SW_SHOWMAXIMIZED);}
end;

procedure TMainForm.PogodaBtnClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://pogoda.yandex.ru/barnaul/', nil,
      nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.NetworkBtnClick(Sender: TObject);
begin
  WinExec(PAnsiChar('CONTROL.EXE NCPA.CPL'), SW_NORMAL);
end;

procedure TMainForm.SaveConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('\Software\DIANET', True) then
  begin
    if SaveData.Checked then
    begin
      reg.WriteString('dianetl', Login);
      reg.WriteString('dianetp', Pass);
    end;
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

procedure TMainForm.Site567567Click(Sender: TObject);
const
  site567567ru = 'http://567567.ru';
begin
  ShellExecute(Handle, 'open', site567567ru, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.siteDianetruClick(Sender: TObject);
const
  sitedianetru = 'http://dianet.ru';
begin
  ShellExecute(Handle, 'open', sitedianetru, nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.TestClick(Sender: TObject);
begin
  MainForm.Show;
end;


procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  MainForm.Show;
end;

end.
