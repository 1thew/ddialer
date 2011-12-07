unit ipconfig;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls,utils,iphlp;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    AdapterList: TListBox;
    ListBox2: TListBox;
    procedure AdapterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    nameAdapter:TListBox;
    descrAdapter:TListBox;
    IPAdapter:TListBox;
    GwAdapter:TListBox;
    DHCPServerAdapter:TListBox;
    DHCPEnable:TListBox;
    procedure ListboxCreate;
  public
    { public declarations }
    procedure nameAdapterAdd(s:string);
    procedure descrAdapterAdd(s:string);
    procedure IPAdapterAdd(s:string);
    procedure GwAdapterAdd(s:string);
    procedure DHCPServerAdapterAdd(s:string);
    procedure DHCPEnableAdd(i:integer);
  end; 

var
  Form1: TForm1; 

implementation

uses MainUnit;
{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  AdapterList.Clear;
  ListBox2.Clear;
  ListboxCreate ;
  GetDNSServers();
  GetAdapters();
end;

procedure TForm1.AdapterClick(Sender: TObject);
var j:integer;
begin
    {******************************************
    nameAdapter:TStringList;
    descrAdapter:TStringList;
    IPAdapter:TStringList;
    GwAdapter:TStringList;
    DHCPServerAdapter:TStringList;
    DHCPEnable:StringList;
    *******************************************}

  if AdapterList.Count<1 then exit;
  try
    Application.ProcessMessages;
    j:=AdapterList.ItemIndex;
    Edit4.text:= nameAdapter.Items.Strings[j];
    Edit5.text:= descrAdapter.Items.Strings[j];
    Edit1.text:= IPAdapter.Items.Strings[j];
    Edit2.text:= GwAdapter.Items.Strings[j];
    Edit3.text:=DHCPServerAdapter.Items.Strings[j];
    if StrToInt(DhcpEnable.Items.Strings[j])=1 then
    begin
      checkbox1.Checked:=true;
      checkbox1.Caption:='DHCP включен';
    end
    else
    begin
       checkbox1.Checked:=false;
       checkbox1.Caption:='DHCP ВЫКЛЮЧЕН'
    end;

  Except ShowMessage('Ошибка заполнения форм');
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
begin
  Button2.Caption:='Работаем....';
  Button2.Enabled:=false;
  CheckIp;
  if filial='other' then
  begin
    ShowMessage('Городская сеть не определена. Функция недоступна.');
    Button2.Caption:='Повторить тест';
    Button2.Enabled:=true;
    exit;
  end;
 i:=checkVPNAdv();

 {***************************************************
 ТУТ:
 300 -- нет IP из нашей сети
 200 -- нет DNS резолва VPN сервера
 100 -- нет пинга VPN сервера
 ****************************************************}

 if i = 0 then ShowMessage('Всё нормально!')
 else if i = 300 then ShowMessage('Нет серого IP из сети Dianet')
 else if i = 200 then ShowMessage('Нет DNS резолва VPN сервера')
 else if i = 100 then ShowMessage('Нет пинга до VPN сервера');
 Button2.Caption:='Повторить тест';
 Button2.Enabled:=true;
end;

procedure  TForm1.ListboxCreate;
begin
   nameAdapter.Free;
   descrAdapter.Free;
   IPAdapter.Free;
   GwAdapter.Free;
   DHCPServerAdapter.Free;
   DHCPEnable.Free;

    nameAdapter:=TListbox.Create(self);
    descrAdapter:=TListbox.Create(self);
    IPAdapter:=TListbox.Create(self);
    GwAdapter:=TListbox.Create(self);
    DHCPServerAdapter:=TListbox.Create(self);
    DHCPEnable:=TListbox.Create(self);
end;

procedure TForm1.nameAdapterAdd(s:string);
begin
  nameAdapter.Items.Add(s);
end;

procedure TForm1.descrAdapterAdd(s:string);
begin
   descrAdapter.Items.Add(s);
end;

procedure TForm1.IPAdapterAdd(s:string);
begin
   IPAdapter.Items.Add(s);
end;

procedure TForm1.GwAdapterAdd(s:string);
begin
   GwAdapter.Items.Add(s);
end;

procedure TForm1.DHCPServerAdapterAdd(s:string);
begin
   DHCPServerAdapter.Items.Add(s);
end;

procedure TForm1.DHCPEnableAdd(i:integer);
begin
    if i=1 then DHCPEnable.Items.Add('1') else DHCPEnable.Items.Add('0');
end;

initialization
  {$I ipconfig.lrs}

end.

