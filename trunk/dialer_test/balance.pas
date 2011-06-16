unit balance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IdHTTP,IdSSLOpenSSL,StrUtils;

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
  i,i2,i3: AnsiString;
  p1,p2,p3,p4:integer;
begin
  BalanceFound:=false;              // обнулим, потому что могут быть старые данные.
  dataStr:=TStringList.Create();
  dataStr.Values['login'] := ConfigForm.Login.Caption;
  dataStr.Values['pass'] := ConfigForm.Pass.Caption;
  try
     IdHTTP1 := TIdHTTP.Create(nil);
     IdSSLIOHandlerSocketOpenSSL1:=TIdSSLIOHandlerSocketOpenSSL.Create(nil);
     IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
     IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method:=sslvSSLv2;
     IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
     IdHTTP1.Request.AcceptCharSet:='windows-1251';
     IdHTTP1.Post('https://billing.dianet.info:40000/cgi-bin/login.cgi?handler=/cgi-bin/main.cgi', DataStr);


     if IdHTTP1.ResponseCode=200 then
     begin

       i:=IdHTTP1.Get('https://billing.dianet.info:40000/cgi-bin/main.cgi');

     end;

  finally idHTTP1.Free;
  end;

  p1:=Pos('<tr><td><b>Текущий баланс:</b></td><td><font color=red>',i);
  if (p1>0) then
  begin
       p2:= PosEx('</font>',i, p1);
       p3:=p1+Length('<tr><td><b>Текущий баланс:</b></td><td><font color=red>');
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
            p1:=Pos('<tr><td><b>Текущий баланс:</b></td><td>',i);
            if (p1>0) then
            begin
                 p2:= PosEx('</td></tr><tr><td><b>',i, p1);
                 p3:=p1+Length('<tr><td><b>Текущий баланс:</b></td><td>');
                 i2:=copy(i,p3,p2-p3);
                 BalanceMinus:=false;
                 BalanceStr:= i2;
                 BalanceFound:=true;
                 // конвертируем в int
                 // p4 - позиция точки в i2
                 p4:=Pos('.',i2);
                 i3:=copy(i2,1,p4-1);
                 BalanceIntg:=StrToInt(i3);
            end;
  end;


end;


end.

