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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    function GetFileSize(FileName: String): Integer;               // узнаём размер файла
    function CheckFile(File_work,File_update :string): Integer;                    // проверяем наличие новых версий файла
    procedure InstallFileUpdate (File_work, File_update : string);        // устанавливает обновления
    procedure InstallUpdate();
  public
    { public declarations }
  end; 

var
  Update: TUpdate;
  UpdateFile : string;
  Filename : string;
  File_work : string;            // рабочий файл
  File_update : string;          // из директории с обновлениями /update
const
  UpdateDir = 'update/';         // директория с обновлениями
  Dir  = 'e:/ddialer/updater/';                 // костыль

implementation

procedure TUpdate.Button2Click(Sender: TObject);
begin
  //InstallUpdate();
end;

procedure TUpdate.Button1Click(Sender: TObject);
var
    FS: TFileStream;
begin
  if not FileExists('e:/ddialer/updater/dianetdialer.exe') then     ShowMessage('Файл не найден')
  else begin
     FS := TFileStream.Create('e:/ddialer/updater/dianetdialer.exe', fmOpenRead);

  ShowMessage(IntToStr(FS.Size));
      FS.Free;

  end;
end;

function TUpdate.CheckFile(File_work,File_update : string): Integer;
begin
    if GetFileSize(File_work) <> GetFileSize(File_update) then
        result:=1                                               // если размер НЕ одинаковый
     else if GetFileSize(File_work) = GetFileSize(File_update) then
        begin
            if  GetFileSize(File_work) = -1 then
                    result:=2                                  // файлЫ не существуют
            else result:=3;                                    // если размер одинаковый
        end;
end;

procedure TUpdate.InstallFileUpdate (File_work, File_update : string);
begin

end;

procedure TUpdate.InstallUpdate();
begin
  Filename := 'dianetdialer.exe';
  // начало цикла
   File_work :=  Dir+Filename;
   File_update := Dir+UpdateDir+Filename;
   ShowMessage (File_update);

   case CheckFile (File_work,File_update) of
   1:
     begin
       InstallFileUpdate (File_work, File_update);
       ShowMessage('Установлено обновление');
     end;
   2: ShowMessage('Файлы не обнаружены. Пожалуйста, переустановите программу!');
   3: ShowMessage('Размер файлов одинаковый. Обновление пропущено');
   end;
  // конец цикла

end;

// узнаём размер файла
// Если файл не существует, то вместо размера файла функция вернёт -1
function TUpdate.GetFileSize(FileName: String): Integer;
var
  FS: TFileStream;
begin
    if not FileExists(Filename) then
       begin
           result := -1;
           ShowMessage('Файл не найден');
       end
    else begin
         FS := TFileStream.Create(Filename, fmOpenRead);
         ShowMessage(IntToStr(FS.Size));
         result := FS.Size;
         end;
    FS.Free;


end;


{$R *.lfm}

end.

