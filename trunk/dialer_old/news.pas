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
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    Image1: TImage;
    StaticText1: TStaticText;
    procedure ButtonCloseClick(Sender: TObject);
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
  NewsCounter:integer=0;
  function IsLastDay():boolean;

const
  URL_News = 'http://update.dianet.info/dialer/news/getnews.php?filial=';

implementation
uses balance, MainUnit;

{ TNewsForm }


procedure TNewsThread.Execute;
begin
   NewsThread.GetNews1;
end;

procedure TNewsThread.UpdateLabel;
begin
   NewsForm.Label1.Caption:=TempSTR;
end;

procedure TNewsThread.GetNews1;
var IdHTTP4:TIdHTTP;
  i1,i2,i3:String;
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

  else if (Length(NewsStr) > 3) and (Pos('error',NewsStr)=0) then
  begin
     NewsFound:=true;
     NewsStrList:= TStringlist.Create;
     NewsStrList:= Tokenize(NewsStr, '@@@');

     if (NewsStrList.Count < 2) and (NewsStrList.Count >0) then TempSTR:=NewsStrList[0]
     else if NewsStrList.Count > 1 then TempSTR:=NewsStrList[0]+ #13+NewsStrList[1];

     Synchronize(@UpdateLabel);
     NewsStrList.Free;
  end;

      // если последний день и баланс низкий
   if (IsLastDay=true) and (BalanceIntg<490) and (Connected=true) then
        begin
        if BalanceFound= false then exit;

        i1:='Уважаемый пользователь! В ночь на первое число каждого месяца снимается абонентская плата.';
        i2:='Для того, чтобы оставаться "на связи" - не забывайте своевременно пополнять баланс.';
        i3:='Ваш баланс: '+BalanceStr + ' рублей';

        NewsStrList:= TStringlist.Create;
        NewsStrList.Add(i1);
        NewsStrList.Add(i2);
        NewsStrList.Add(i3);
        TempSTR:=NewsStrList[0]+ #13+NewsStrList[1]+#13+#13+NewsStrList[2];
        NewsFound:=true;
        Synchronize(@UpdateLabel);
        NewsStrList.Free;
        Exit;
        end;
      // текст для сообщения об отрицательном балансе
   if (BalanceMinus=true) and (LastError<>0) and (BalanceFound=true) then
        begin
           i1:='У вас отрицательный баланс! Пополните счёт на '+IntToStr(BalanceIntg+1)+' рублей';
           NewsFound:= true;
           TempSTR:=i1;
           Synchronize(@UpdateLabel);
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

procedure TNewsForm.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('dianet.info'), nil, nil, SW_SHOWMAXIMIZED);
end;


function IsLastDay: boolean;
 var
   y, m, d: Word;
   LastDay: Word;
 begin
   DecodeDate(now, y, m, d);
   if (m=01)or(m=03)or(m=05)or(m=07)or(m=08)or(m=10)or(m=12) then Lastday:= 31
   else if (m=02) then  LastDay:=28
   else LastDay:=30;
   if Lastday <> d then result:=false else result:=true;
end;


initialization
  {$I news.lrs}

end.

