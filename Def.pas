unit Def;

interface

uses
 Windows, SysUtils,Structs, MiscData, PlayerData;

{$REGION 'Proxy'}
type socks5_r = record //InitProxy
   ver:byte;
   nmet:byte;
   met:byte;
end;

Type socks5_r_TPC = Packed record //Config Proxy
    ver:byte;
    cmd:byte;
    rsv:byte;
    atyp:byte;
    ip:ulong;
    port:ushort;
end;
{$ENDREGION}

type TGameStatus  = (Erro = -1 ,Deslogado, Logando, ListChar, ingame);

type TMax = Record
  Equip     : SmallInt;
  Inventory : SmallInt;
  Cargo     : SmallInt;
end;

{$REGION 'ItemList Data'}
type _TItemList  = ARRAY[0..6499] OF TItemList;
type _TSkillData = ARRAY[0..110] OF TSkillData;
{$ENDREGION}

{$REGION 'Acc'}
Type TAcc =Record
  ID, Senha, Senha2: String;
  ProxyIP      : String;
  Servidor     : String;
  Slot, Versão : Integer;
  Log          : Boolean;
End;

Type TInfoBot = Packed Record
  ID    : Array [0..31] of ansichar;
  Pass  : Array [0..31] of ansichar;
  Pass2 : Array [0..03] of ansichar;
  Slot  : byte;
End;
{$ENDREGION}

{$REGION 'IPS'}
const
 ORIGEN_1 = '198.27.96.13';
 ORIGEN_2 = '198.27.96.14';
 ORIGEN_3 = '198.27.96.15';
 ORIGEN_4 = '198.27.96.12';
 ORIGEN_5 = '198.27.96.11';
 ORIGEN_6 = '198.27.96.10';

 SD_1 = '164.132.24.96';
 SD_2 = '164.132.24.100';

 PortServ   = 8281;
{$ENDREGION}

var
  InitCode        : DWORD   = $1F11F311;
  DiconectTime    : TDateTime = 0;
  ItemList        : _TItemList;
  skilldata       : _TSkillData;
  InfoBot         : TInfoBot;
  ACC             : TACC;
  SubStatus       : TGameStatus;
  cMax            : TMAX;

implementation

Uses
func;

begin
  cMax.Equip     := 15;
  cMax.Inventory := 60;
  cMax.Cargo     := 120;
  Acc.ID        := '';
  Acc.Slot      :=  0;
  Acc.Versão    := 7623; //757
  Acc.ProxyIP   := '';
  ZeroMemory(@InfoBot, Sizeof(InfoBot));
end.





