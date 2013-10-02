unit balance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IdHTTP,IdSSLOpenSSL,StrUtils, Dialogs;

type
  { TBalanceThread }
  TBalanceThread = class(TThread)
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
  private
    procedure GetBalance();
  protected
    procedure Execute; override;
  public
  end;

var
  BalanceThread: TBalanceThread;
  BalanceStr:string;
  BalanceFound:boolean;
  BalanceIntg:integer;
  BalanceMinus:boolean;

implementation
uses MainUnit;

procedure TBalanceThread.Execute;
begin
   GetBalance();
end;


procedure TBalanceThread.GetBalance();
var
  dataStr:TStringList;
  i: string;
  i2,i3: AnsiString;
  p1,p2,p3,p4:integer;
  IdHTTP_gb : TIdHTTP;
  IdSSL1:TIdSSLIOHandlerSocketOpenSSL;
begin
  BalanceFound:=false;              // обнулим, потому что могут быть старые данные.
  dataStr:=TStringList.Create();
  dataStr.Values['login'] := ConfigForm.Login.Caption;
  dataStr.Values['pass'] := ConfigForm.Pass.Caption;
  try
     IdHTTP_gb := TIdHTTP.Create;
     IdSSL1:=TIdSSLIOHandlerSocketOpenSSL.Create;
     IdHTTP_gb.IOHandler := IdSSL1;
     IdSSL1.SSLOptions.Method:=sslvSSLv2;
     IdHTTP_gb.Request.ContentType := 'text/html';
     IdHTTP_gb.Request.AcceptCharSet:='windows-1251';
     IdHTTP_gb.Request.Connection := 'keep-alive';
     IdHTTP_gb.Post('https://billing.dianet.info:40000/cgi-bin/login.cgi?handler=/cgi-bin/main.cgi', dataStr); //??? D->d

     if IdHTTP_gb.ResponseCode=200 then
     begin
       i:=IdHTTP_gb.Get('https://billing.dianet.info:40000/cgi-bin/main.cgi');
     end;
     IdHTTP_gb.Disconnect;
     idHTTP_gb.Free;
     dataStr.Free;
     except
           on E : Exception do
           begin
                ShowMessage(E.ClassName+' поднята ошибка, с сообщением : '+E.Message);
           end;
  end;

  p1:=Pos('<td id="acc_balance_sub">',i);
  if (p1>0) then
  begin
       p2:= PosEx('</td>',i, p1);
       p3:=p1+Length('<td id="acc_balance_sub">');
       i2:=copy(i,p3,p2-p3);
       // если число минусовое то:
       if Pos('-',i2)>0 then begin
          i2:=copy(i2,2,Length(i2)-1);
          BalanceStr:='-'+i2;
          BalanceMinus:=true;
          BalanceFound:=true;
                 // конвертируем в int
                 // p4 - позиция точки в i2
                 p4:=Pos('.',i2);
                 i3:=copy(i2,1,p4-1);
                 BalanceIntg:=StrToInt(i3);
       end;
  end
  else
  begin
            p1:=Pos('<td id="acc_balance">',i);
            if (p1>0) then
            begin
                 p2:= PosEx('</td>',i, p1);
                 p3:=p1+Length('<td id="acc_balance">');
                 i2:=copy(i,p3,p2-p3);
                 BalanceMinus:=false;
                 BalanceStr:= i2;
                 BalanceFound:=true;
                 // конвертируем в int
                 // p4 - позиция точки в i2
                 p4:=Pos('.',i2);
                 i3:=copy(i2,1,p4-1);
            end;

  end;

end;




end.

