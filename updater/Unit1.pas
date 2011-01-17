unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TUpdate }

  TUpdate = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    function GetFileSize(FileName: string): integer;
    // узнаём размер файла
    function CheckFile(File_work, File_update: string): integer;
    // проверяем наличие новых версий файла
    procedure InstallFileUpdate(File_work, File_update: string);
    // устанавливает обновления
    procedure InstallUpdate();
    procedure InstallFile(File_work, File_update : string);
  public
    { public declarations }
  end;

var
  Update:      TUpdate;
  UpdateFile:  string;
  Filename:    string;
  File_work:   string;            // рабочий файл
  File_update: string;
// из директории с обновлениями /update

const
  UpdateDir = 'update/';         // директория с обновлениями
  Dir = '';                      // костыль

implementation

procedure TUpdate.Button2Click(Sender: TObject);
begin
  //InstallUpdate();
end;

function TUpdate.CheckFile(File_work, File_update: string): integer;
begin
  if GetFileSize(File_work) <> GetFileSize(File_update) then
    Result := 1
  // если размер НЕ одинаковый
  else if GetFileSize(File_work) = GetFileSize(File_update) then
  begin
    if GetFileSize(File_work) = -1 then
      Result :=
        2                                  // файлЫ не существуют
    else
      Result := 3;
    // если размер одинаковый
  end;
end;

procedure TUpdate.InstallFileUpdate(File_work, File_update: string);
begin
  File_work   := Filename;
  File_update := UpdateDir + Filename;

  case CheckFile(File_work, File_update) of
    1:
    begin
      InstallFile(File_work, File_update);
      ShowMessage('Устанавливается обновление');
    end;
    3: ShowMessage('Размер файлов одинаковый. Обновление пропущено');
    else
      ShowMessage('Файлы программы не обнаружены. Пожалуйста, переустановите программу!');
  end;
end;

procedure TUpdate.InstallUpdate();
begin

end;

// узнаём размер файла
// Если файл не существует, то вместо размера файла функция вернёт -1
function TUpdate.GetFileSize(FileName: string): integer;
var
  FS: TFileStream;
begin
  if not FileExists(Filename) then
  begin
    Result := -1;
    ShowMessage('Файл не найден');
  end
  else
  begin
    FS := TFileStream.Create(Filename, fmOpenRead);
    ShowMessage(IntToStr(FS.Size));
    Result := FS.Size;
    FS.Free;
  end;
end;

procedure TUpdate.InstallFile (File_work, File_update : string);
begin
  if DeleteFile(File_work) then
     MoveFile(File_update, File_work)
  else ShowMessage('Ошибка обновления. Пожалуйста, переустановите программу');
end;


{$R *.lfm}

end.
