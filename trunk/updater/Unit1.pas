unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Windows;

type

  { TUpdForm }

  TUpdForm = class(TForm)
    Image1: TImage;
    StaticText1: TStaticText;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
    procedure ApplicationPath;
  public
    { public declarations }
  end; 

var
  UpdForm: TUpdForm;
  InstallDir:string;

implementation

{$R *.lfm}

{ TUpdForm }

procedure TUpdForm.FormCreate(Sender: TObject);
var params:string;
begin
  ApplicationPath;
  // тут вырубаем процесс диалера
  params:= '/f /im dianetdialer.exe';
  ShellExecute(0,'open','taskkill',Pchar(params),nil,SW_hide);
end;


procedure TUpdForm.Timer1Timer(Sender: TObject);
var params:string;
begin
   // запускаем обновлялку с путями
   params:='/S'+' '+ '/D='+InstallDir;
   ShellExecute(0,'open','update.exe',Pchar(params),nil,SW_hide);
   // не забываем включить таймер2, там запустится диалер
   Timer1.Enabled:=false;
   Timer2.Enabled:=true;
end;

procedure TUpdForm.Timer2Timer(Sender: TObject);
begin
  // таймер запускает процесс диалера
  ShellExecute(0,'open','dianetdialer.exe',nil,nil,SW_normal);
  //DeleteFile('update.exe');
  Timer2.Enabled:=false;
  Close;
end;


procedure TUpdForm.ApplicationPath;
begin
 InstallDir := ExtractFilePath(ParamStr(0));
end;


end.

