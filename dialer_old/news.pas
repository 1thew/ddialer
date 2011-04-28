unit news;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, IdHTTP, utils, windows;


type
  { TNewsThread }
  TNewsThread = class(TThread)
        TempStr:Widestring;
   private
    function Tokenize(Str: WideString; Delimiter: string): TStringList;
  protected
    procedure UpdateLabel();
    procedure Execute; override;
  public
    procedure GetNews1;
  end;


  { TNewsForm }

  TNewsForm = class(TForm)
    ButtonClose: TButton;
    Label1: TLabel;
    Image1: TImage;
    StaticText1: TStaticText;
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  NewsForm: TNewsForm;
  NewsThread: TNewsthread;
  NewsFound:Boolean=False;
  NewsStrList: TStringlist;
  NewsStr:WideString;
  MessageForNews:String = '';
  NewsCounter:integer=0;

const
  URL_News = 'http://update.dianet.info/dialer/news/getnews.php?filial=';

implementation

{ TNewsForm }


procedure TNewsThread.Execute;
begin

   NewsThread.GetNews1;
   // создаём окошки если нашли

end;

procedure TNewsThread.UpdateLabel;
begin
   NewsForm.Label1.Caption:=TempSTR;
end;

procedure TNewsThread.GetNews1;
var IdHTTP4:TIdHTTP;
begin
  try
     try
          IdHTTP4 := TIdHTTP.Create(nil);
          NewsStr:= IdHTTP4.Get(URL_News+Filial);
     except on e : EIDHttpProtocolException do begin
                                               NewsFound:=false;
                                               if Length(MessageForNews)<3 then NewsCounter:=1000+NewsCounter;
                                               end;
     on e:Exception do  begin
                        NewsFound:=false;
                        if Length(MessageForNews)<3 then NewsCounter:=1000+NewsCounter;
                        end;
     end;
  finally
    IdHTTP4.Free;
  end;

  if (Length(MessageForNews)>2) then
  begin
      TempSTR:=MessageForNews;
      Synchronize(@UpdateLabel);
      Exit;
  end;


  if (Length(NewsStr) = 0) or (Pos('error',NewsStr)<>0) then
  begin
     NewsFound:= false;
  end

  else if (Length(NewsStr) <> 0) and (Pos('error',NewsStr)=0) then
  begin
     NewsFound:=true;
     NewsStrList:= TStringlist.Create;
     NewsStrList:= Tokenize(NewsStr, '@@@');
     if NewsStrList.Count < 2 then
     begin
        TempSTR:=NewsStrList[0];
        Synchronize(@UpdateLabel);
     end
     else begin
       TempSTR:=NewsStrList[0]+ #13+NewsStrList[1];
       Synchronize(@UpdateLabel);
     end;
     NewsStrList.Free;
  end;
  NewsCounter:= NewsCounter+1;
end;

function TNewsThread.Tokenize(Str: WideString; Delimiter: string): TStringList;
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


procedure TNewsForm.ButtonCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TNewsForm.FormCreate(Sender: TObject);
begin

end;

procedure TNewsForm.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('dianet.info'), nil, nil, SW_SHOWMAXIMIZED);
end;


initialization
  {$I news.lrs}

end.

