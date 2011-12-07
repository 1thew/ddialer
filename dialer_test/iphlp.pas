 {$mode delphi}
unit iphlp;

interface

uses Windows,dialogs,Forms,SysUtils;

const
  MAX_HOSTNAME_LEN    = 128;
  MAX_DOMAIN_NAME_LEN = 128;
  MAX_SCOPE_ID_LEN    = 256;

    MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;
  IPHelper = 'iphlpapi.dll';

type
  PIPAddressString = ^TIPAddressString;
  PIPMaskString    = ^TIPAddressString;
  TIPAddressString = record
    _String: array[0..(4 * 4) - 1] of Char;
  end;
  TIPMaskString = TIPAddressString;
  PIPAddrString = ^TIPAddrString;
  TIPAddrString = packed record
    Next: PIPAddrString;
    IpAddress: TIPAddressString;
    IpMask: TIPMaskString;
    Context: DWORD;
  end;
  PFixedInfo = ^TFixedInfo;
  TFixedInfo = packed record
    HostName: array[0..MAX_HOSTNAME_LEN + 4 - 1] of Char;
    DomainName: array[0..MAX_DOMAIN_NAME_LEN + 4 - 1] of Char;
    CurrentDnsServer: PIPAddrString;
    DnsServerList: TIPAddrString;
    NodeType: UINT;
    ScopeId: array[0..MAX_SCOPE_ID_LEN + 4 - 1] of Char;
    EnableRouting,
    EnableProxy,
    EnableDns: UINT;
  end;



IP_ADDRESS_STRING = record
  S: array [0..15] of Char;
end;
IP_MASK_STRING = IP_ADDRESS_STRING;
PIP_MASK_STRING = ^IP_MASK_STRING;


PIP_ADDR_STRING = ^IP_ADDR_STRING;
IP_ADDR_STRING = record
Next: PIP_ADDR_STRING;
IpAddress: IP_ADDRESS_STRING;
IpMask: IP_MASK_STRING;
Context: DWORD;
end;

  PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
  IP_ADAPTER_INFO = record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
    Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
    AddressLength: UINT;
    Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
    Index: DWORD;
    Type_: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIP_ADDR_STRING;
    IpAddressList: IP_ADDR_STRING;
    GatewayList: IP_ADDR_STRING;
    DhcpServer: IP_ADDR_STRING;
    HaveWins: BOOL;
    PrimaryWinsServer: IP_ADDR_STRING;
    SecondaryWinsServer: IP_ADDR_STRING;
    LeaseObtained: cardinal;
    LeaseExpires: cardinal;
  end;





function GetNetworkParams(pFixedInfo: PFixedInfo; pOutBufLen: PULONG): DWORD; stdcall;
procedure GetDNSServers();
procedure GetAdapters();
function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: cardinal): DWORD; stdcall; external  IPHelper;




implementation
uses ipconfig;

const
  iphlpapidll = 'iphlpapi.dll';






procedure GetAdapters();
var
  Len:Cardinal;
  TmpPointer,InterfaceInfo:PIP_ADAPTER_INFO;
  IP: PIP_ADDR_STRING;
  s:string;
  s1:PChar;
begin
  // Смотрим сколько памяти нам требуется?

  if GetAdaptersInfo(nil, Len) = ERROR_BUFFER_OVERFLOW then
  begin

    GetMem(InterfaceInfo, Len);
    try
      if GetAdaptersInfo(InterfaceInfo, Len) = ERROR_SUCCESS then
      begin
            TmpPointer := InterfaceInfo;
            repeat
              Application.ProcessMessages;
              // Имя сетевого интерфейса
              s:=TmpPointer^.AdapterName;
              Form1.nameAdapterAdd(s);
              // Описание сетевого интерфейса
              Form1.descrAdapterAdd(TmpPointer^.Description);
              // определение активности DHCP
              if Boolean(TmpPointer^.DhcpEnabled) then
              begin
                Form1.DHCPEnableAdd(1);
                Form1.DHCPServerAdapterAdd (TmpPointer^.DhcpServer.IpAddress.S);

              end
              else
              begin
                Form1.DHCPEnableAdd(0);
                Form1.DHCPServerAdapterAdd ('0');
              end;

              // перечисляем все IP адреса интерфейса
              IP := @TmpPointer.IpAddressList;

              s1:=IP^.IpAddress.S;
              if s1='0.0.0.0' then Form1.AdapterList.Items.Add('<нет кабеля>')
              else Form1.AdapterList.Items.Add(IP^.IpAddress.S);

              Form1.IPAdapterAdd(IP^.IpAddress.S);

              // основной шлюз:
              Form1.GwAdapterAdd(TmpPointer^.GatewayList.IpAddress.S);
              TmpPointer := TmpPointer.Next;

            until TmpPointer = nil;
      end;
    finally
      FreeMem(InterfaceInfo);
    end;
  end;
end;

procedure GetDNSServers();
var
  pFI: PFixedInfo;
  pIPAddr: PIPAddrString;
  OutLen: Cardinal;
begin
  Form1.ListBox2.Items.Clear;
  OutLen := SizeOf(TFixedInfo);
  GetMem(pFI, SizeOf(TFixedInfo));
  try
    if GetNetworkParams(pFI, @OutLen) = ERROR_BUFFER_OVERFLOW then
    begin
      ReallocMem(pFI, OutLen);
      if GetNetworkParams(pFI, @OutLen) <> NO_ERROR then Exit;
    end;
    if pFI^.DnsServerList.IpAddress._String[0] = #0 then Exit;
    Form1.ListBox2.Items.Add(pFI^.DnsServerList.IpAddress._String);
    pIPAddr := pFI^.DnsServerList.Next;
    while Assigned(pIPAddr) do
    begin
      Form1.ListBox2.Items.Add(pIPAddr^.IpAddress._String);
      pIPAddr := pIPAddr^.Next;
    end;
  finally
    FreeMem(pFI);
  end;
end;


function GetNetworkParams; external iphlpapidll Name 'GetNetworkParams';
end.



