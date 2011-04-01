unit news;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, IdHTTP, utils, ShellAPI,windows;

type

  { TNewsForm }

  TNewsForm = class(TForm)
    Button1: TButton;
    ButtonClose: TButton;
    IdHTTP2: TIdHTTP;
    Image1: TImage;
    Label1: TLabel;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { private declarations }
    NewsStr: WideString;
    NewsStrList: TStringlist;
    function Tokenize(Str: WideString; Delimiter: string): TStringList;
  public
    { public declarations }
    procedure GetNews;
  end; 

var
  NewsForm: TNewsForm;
  NewsFound:Boolean=False;

const
  URL_News = 'http://update.dianet.info/dialer/news/getnews.php?filial=';

implementation

{ TNewsForm }

procedure TNewsForm.ButtonCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TNewsForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TNewsForm.FormCreate(Sender: TObject);
begin
   GetNews();
end;

procedure TNewsForm.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('dianet.info'), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TNewsForm.GetNews;
begin
  IdHTTP2 := TIdHTTP.Create(nil);
  NewsFound:=true;
  try
     try
          NewsStr:= IdHTTP2.Get(URL_News+Filial);
     except on e : EIDHttpProtocolException do NewsFound:=false;
     on e:Exception do  NewsFound:=false;
     end;
  finally
    IdHTTP2.Free;
  end;
  if  NewsFound=false then exit;

  if (Length(NewsStr) <> 0) and (NewsStr<>'Error') then
  begin
     NewsFound:=true;
     NewsStrList:= TStringlist.Create;
     NewsStrList:= Tokenize(NewsStr, '@@@');
     if NewsStrList.Count < 2 then  Label1.Caption:=NewsStrList[0]
     else Label1.Caption:=NewsStrList[0]+ #13+NewsStrList[1];
     NewsStrList.Free;
  end;
  if (Length(NewsStr) = 0) or (NewsStr='Error') then
  begin
     NewsFound:= false;
  end;
end;

function TNewsForm.Tokenize(Str: WideString; Delimiter: string): TStringList;
var
  tmpStrList: TStringList;
  tmpString, tmpVal:WideString;
  DelimPos: LongInt;
begin
  tmpStrList := TStringList.Create;
  TmpString := Str;
  DelimPos := 1;
  while DelimPos > 0 do
  begin
    DelimPos := LastDelimiter(Delimiter, TmpString);
    tmpVal := Copy(TmpString, DelimPos + 1, Length(TmpString));
    if tmpVal <> '' then
      tmpStrList.Add(tmpVal);
    Delete(TmpString, DelimPos, Length(TmpString));
  end;
  Tokenize := tmpStrList;
end;

initialization
  {$I news.lrs}

end.

