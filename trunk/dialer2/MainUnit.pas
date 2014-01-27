unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type
  TMainForm = class(TForm)
    Image1: TImage;
    Button1: TButton;
    BalanceText: TLabel;
    AutoLoad: TCheckBox;
    CheckBox2: TCheckBox;
    TrayIcon: TTrayIcon;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
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
    procedure CloseBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure NetworkBtnClick(Sender: TObject);
    procedure LKabBtnClick(Sender: TObject);
    procedure Site567567Click(Sender: TObject);
    procedure siteDianetruClick(Sender: TObject);
    procedure PogodaBtnClick(Sender: TObject);
    procedure ErrorReportClick(Sender: TObject);
  private
    Login: Ansistring;
    Pass: Ansistring;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

//объявим локальные модули
uses ShellApi, utils;
// ...объявили

{$R *.dfm}


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
  Close;
end;

procedure TMainForm.ErrorReportClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://bt.dianet.info/viewforum.php?f=86', nil,
      nil, SW_SHOWMAXIMIZED);

end;

procedure TMainForm.LKabBtnClick(Sender: TObject);
var
  caburl: string;
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

end.
