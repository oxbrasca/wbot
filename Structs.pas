unit  Structs;

interface

Uses  Windows,
      PlayerData, MiscData;

{$REGION 'Header'}
type sHeader = Record
    Size  : Word;
    Key   : Byte;
    ChkSum: Byte;
    Code  : Word;
    Index : Word;
    Time  : LongInt;
end;

type TSignalData = packed record
  Header    : sHeader;
  Data      : integer;
end;
{$ENDREGION}


Type TEffect = record
  Index, Value: word;
end;



{$REGION 'Login'}
type p20D = packed record
  Header   : sHeader;
  Pass     : Array [0..11]of Ansichar;
  Username : Array [0..67]of Ansichar;
  cLiver   : DWORD;
  unk      : DWORD;//1
  Hwid     : Array [0..15]of byte;//22 5B DE 04 4D 41 20 FD 87 20 EF 8D 9B 68 06 BE
end;
{$ENDREGION}

{$REGION 'ITEMLIST_ST'}     //size 140     ///909996 / 140  /////910000
Type ITEMLIST_ST = Packed Record
  Name: Array [0..63]of Ansichar;
  meshs : Array [0..1]of word;
  unk: word;
  level, STR, INT, DEX, CON: word;
  Effect : Array [0..11]of TEffect;
  Price: DWORD;
  Unique, Pos, Extreme, Grade : word;
End;

Type TITEMLIST  = ARRAY[0..6499] OF ITEMLIST_ST; //6500
{$ENDREGION}

{$REGION 'MOB_ST'}
Type MOB_ST = Packed Record
Name: Array [0..15]of Ansichar;
CapeInf: Byte;
GuildIndex : word;
ClassInfo: byte;
BitInfo: byte;
QuestInfo : WOrd;
Gold, Exp: DWORD;
Last: TPosition;
Learn : DWORD;
pStatus, pMaster, pSKill : Word;
Critical, SaveMana : byte;
qSkillBarl: Array [0..3]of Byte;
GuildMemberType, MagicalIncremente: Byte;
RegenHP, RegenMP: byte;
Resist: Array [0..3]of byte;
End;
{$ENDREGION}

{$REGION 'Move'}
Type p36C = Record
  Header : sHeader;
  SrcPos : TPosition;
  mType  : DWORD;
  sMove  : DWORD;
  cmd    : Array [0..23]of AnsiChar;
  DstPos : TPosition;
{SEND 0x036C >> 34 00 D1 FE 6C 03 CC 03 62 2F 96 04
19 08 13 08 SrcPos
00 00 00 00 mType
03 00 00 00 SpeedMove
31 34 34 34 34 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
14 08 12 08 DstPos}
End;
{$ENDREGION}
{$REGION 'MSG_KEY'}
Type p374 = Record
  Header : sHeader;
  index: DWORD;
  mode: word;
  null:word;
End;
{
 RECV 0x0374 >> 14 00 2F 83 74 03 48 00 80 AB 19 02
 C8 3A 00 00
01 00
00 00
}
{$ENDREGION}
{$REGION 'MSG_CREATEOBJECT'}
Type p26E = Record
  Header : sHeader;
  Pos: TPosition;
  item: TITEM;
  Rotate: Byte;
  Stage : Byte;
  Height: Byte;
  unk:byte;
  nul:word;
End;
{ RECV 0x026E >>
20 00 C8 C9 6E 02 30 75 71 BA 0F 02
5F 08 C1 07
C8 3A
CB 01 00 00 00 00 00 00
02
03
12
00
00 00
458; Primeira_Porta;
459; Segunda_Porta;
461; Última_Porta;
}
{$ENDREGION}

{$REGION 'Move Item'}
Type p376 = Record
  Header : sHeader;
  DstType, DstSlot: Byte;
  SrcType, SrcSlot: Byte;
  Unk: DWORD;
End;
{$ENDREGION}

{$REGION 'Use Item'}
Type p373 = Record
  Header : sHeader;
  DstType, DstSlot: DWORD;
  SrcType, SrcSlot: DWORD;
  Pos: TPosition;
  unk: DWORD;
  {
   SEND 0x0373 >> 24 00 98 46 73 03 77 03 35 1A B7 1B
01 00 00 00
04 00 00 00
00 00 00 00
00 00 00 00 EE 07 63 06 00 00 00 00
  }
End;
{$ENDREGION}

{$REGION 'Sell Item'}
Type p37A = Record
  Header  : sHeader;
  NpcID   : Word;
  SlotType: Word;
  Slot    : DWORD;
End;
// SEND 0x037A >> 14 00 96 58 7A 03 B4 02 FF AB BB 05 3F 04 01 00 04 00 00 00
{$ENDREGION}



{$REGION 'MSG_SPLITITEM'}
Type p2E5 = Record   //0x14
  Header  : sHeader;
  Slot, ItemID, Num   : Integer;
End;
{$ENDREGION}

{$REGION 'Buy Item'}
Type p379 = Record
  Header  : sHeader;
  NpcID   : Word;
  sellSlot,
  invSlot,
  Unknown1 : Word;
  Unknown2 : DWORD;
End;
{$ENDREGION}
// SEND 0x0379 >> 18 00 96 BC 79 03 B4 02 99 72 BD 05 3F 04 08 00 00 00 00 00 00 00 00 00{$ENDREGION}
{$REGION 'Delete Item'}
Type p2E4 = Record
  Header : sHeader;
  Slot, ItemID: DWORD;
End;
{$ENDREGION}

//SEND 0x027B >> 10 00 96 88 7B 02 B4 02 4F A7 B8 05 41 04 40 C0 OpenNPC

type
  TRequestLoginPacket = packed record
    Header: sHeader;
    PassWord: array [0 .. 11] of AnsiChar;
    UserName: array [0 .. 15] of AnsiChar;
    Null    : array [0 .. 51] of AnsiChar;
    Version : DWORD; //7654
    unk1    : DWORD; //14405
    Keys    : array [0 .. 15] of AnsiChar;
end;
{
>> 74 00
   A2 8E
   00 03 opcode
   00 00 index
   0E 92 79 16 time
   62 61 64 30 31 32 33 34 35 36 00 00
   62 61 64 64 61 79 30 31 00 00 00 00 00 00 00 00
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   E6 1D 00 00 versão
   45 38 00 00 unk
   22 5B DE 04 4D 41 20 FD 87 20 EF 8D 9B 68 06 BE

  11 F3 11 1F
 74 00
 00 00
 00 03
 00 00
 00 00 00 00
 62 61 64 30 31 32 33 34 35 36 00 00
 62 61 64 64 61 79 30 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 E6 1D 00 00 45 38 00 00 22 5B DE 04 4D 41 20 FD 87 20 EF 8D 9B 68 06 BE
Conect: 149.56.238.176 Port: 8281


>> 11 F3 11 1F
>> 74 00 89 88 00 03 00 00
AA 24 09 17
62 61 64 30 31 32 33 34 35 36 00 00
62 61 64 64 61 79 30 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
E6 1D 00 00
45 38 00 00
22 5B DE 04 4D 41 20 FD 87 20 EF 8D 9B 68 06 BE

}

type
  TRefreshMoneyPacket = record
    Header: sHeader;
    Gold: integer;
  end;

type
  TRefreshEtcPacket = record
    Header: sHeader;
    Hold: integer;
    Exp: integer;
    Learn: integer;
    StatusPoint: Smallint;
    MasterPoint: Smallint;
    SkillsPoint: Smallint;
    MagicIncrement: Smallint;
    Gold: integer;
  end;

type
  TClientMessagePacket = record
    Header: sHeader;
    Msg: Array [0..127] of ansichar;
  end;

type
  TClientMessagePacket2 = record
    Header: sHeader;
    unks: array [0..1]of word;
    Message: Array [0..127] of ansichar;
  end;

type
  TRefreshInventoryPacket = record
    Header: sHeader;
    Inventory: array [0 .. 63] of TItem;
    Gold: integer;
  end;

type
  TSendCurrentHPMPPacket = record
    Header: sHeader;
    CurHP: WORD;
    MaxHP: WORD;
    CurMP: WORD;
    MaxMP: WORD;
  end;

type
  TSendScorePacket = record
    Header: sHeader;
    Score: TStatus;
    Critical: shortint;
    SaveMana: shortint;
    // Skill Info
    Affects: array [0 .. 15] of TAffect;
    Guildindex: Smallint;
    Guildmember: Smallint;
    Resist: array [0 .. 3] of shortint;
    CurHP: Smallint;
    CurMP: Smallint;
    Unknown: Smallint;
 end;

  // Request Command
type
  TCommandPacket = record
    Header: sHeader;
    Command: String[15];
    Value: String[99];
    // eCommand: array[0..15] of AnsiChar;
    // eValue: array[0..99] of AnsiChar;
end;

type
  TChatPacket = record
    Header: sHeader;
    Chat: string[95];
  end;

type
  TMovementPacket = packed record
    Header: sHeader;
    xSrc, ySrc: WORD;
    mSpeed: integer;
    mType: integer;
    xDst, yDst: Smallint;
    mCommand: string[23];
  end; // p366 and p367

type
  p39B = Record
    Header: sHeader;
    Index, slot: integer;
  end;

  // Request Add Points
type
  p277 = packed record
    Header: sHeader;
    Mode, Info: Smallint;
    unk: integer;
    // SEND 0x0277 >> 14 00 DB E9 77 02 0C 00 1D 4E 0A 08 00 00 02 00 00 00 00 00


end;

  // Request Add Points
type
  pAD9 = packed record
    Header: sHeader;
    cType: Array [0..1]of DWORD;
end;

type
  p213 = packed record
    Header: sHeader;
    Slot: DWORD;
    Zero: Array [0..19]of byte;
end;

type
  TCharListCharactersData = Record
    Position: array [0 .. 3] of TPosition;
    Name: array [0 .. 3] of Array [0 .. 15] of AnsiChar;
    Status: array [0 .. 3] of TStatus;
    Equip: array [0 .. 3] of array [0 .. 15] of TItem;
    Guildindex: array [0 .. 3] of WORD;
    Gold: array [0 .. 3] of DWORD;
    Exp: array [0 .. 3] of int64; //8bytes
end;

type
  TSendToCharListPacket = packed record  //010A
    Header: sHeader;
    Keys: Array [0..15] of byte;
    unk: DWORD;
    CharactersData: TCharListCharactersData;
    Storage: array [0 .. 127] of TItem;
    Gold: integer;
    UserName: Array [0..14] of Ansichar;
    nulll: word;
    unks :Array [0..2]of DWORD;
 end;

type
  TNumericTokenPacket = packed record
    Header: sHeader;
    num: array [0 .. 5] of AnsiChar;
    unk: array [0 .. 9] of AnsiChar;
    RequestChange: DWORD;
end;

type
  TCreateCharacterRequestPacket = Record
    Header: sHeader;
    SlotIndex: integer;
    Name: array [0 .. 15] of AnsiChar;
    ClassIndex: integer;
  end;

type
  TUpdateCharacterListPacket = Record
    Header: sHeader;
    CharactersData: TCharListCharactersData;
  end;

type
  TDeleteCharacterRequestPacket = packed record
    Header: sHeader;
    SlotIndex: integer;
    Name: array [0 .. 15] of AnsiChar;
    PassWord: array [0 .. 11] of AnsiChar;
  end;

type
  TSelectCharacterRequestPacket = Record
    Header: sHeader;
    CharacterId: Byte;
  End;

type
  TSendToWorldPacket = packed record
    Header   : sHeader;
    Pos      : TPosition;
    Character: TCharacter;
    Zero: array [0 .. (1244 - (sizeof(TCharacter) + sizeof(TPosition) + 12) )] of Byte;
end;

type
  TAffectInPacket = Record
    Time: Byte;
    Index: Byte;
end;

type
  p17C = Record
    Header: sHeader;
    Merch: integer;
    Itens: array [0 .. 26] of TItem;
    Imposto: integer;
End;




  // Send Party Request
type
  p37F = Record
    Header: sHeader;
    LiderID: WORD;
    Level: WORD;
    MaxHP, CurHP: WORD;
    SenderId: WORD;
    Nick: Array [0..15] of ansichar;
    unk2: word;
    AlvoID: DWORD;
end;

type
  p3AB = Record
    Header: sHeader;
    LiderID: WORD;
    Nick: Array [0..15] of ansichar;
end;


type
  p20F = Record
    Header: sHeader;
    Slot: DWORD;
    Name: Array [0..15] of ansichar;
    Classe: DWORD;
end;

type
  p3B9 = Record
    Header: sHeader;
    Affect: Array [0..31] of st_Affect;
end;

type
  p37E = Record
    Header: sHeader;
    ExitId: WORD;
    unk: WORD; // $CCCC
end;

type
  p3EA = Record
    Header: sHeader;
    ClientId: WORD;
    IDs:Array [0..11] of word;
    unk: WORD; // $CCCC
    {
     RECV 0x03EA >> 28 00 10 0B EA 03 30 75 FC B5 07 10
     59 01
     EB 06 EC 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CC CC
    }
end;

type
  p37D = Record
    Header: sHeader;
    LiderID: WORD;
    Level: WORD;
    MaxHP, CurHP: WORD;
    ClientId: WORD;
    Nick: Array [0..15] of ansichar;
    ID: WORD;
end;

type
  zp373 = Record
    Header: sHeader;
    SrcType, SrcSlot: integer;
    DstType, DstSlot: integer;

    PosX, PosY: Smallint;
    unk: integer;
end;

///MOB DEAD
type
  p338 = packed record
    Header: sHeader;
    Hold: integer;
    killed, killer: Smallint;
    unk: longint;
    Exp: int64;
// RECV 0x0338 >> 20 00 D4 B5 38 03 30 75 51 19 D9 16 00 00 00 00 58 10 F6 00 CC CC CC CC E5 92 02 00 00 00 00 00
end;

type
  mob_kill = Record
    Hold, Exp: integer;
    EnemyList, EnemyIndex: pInteger;
    Dead: boolean;
    inBattle: pBoolean;
end;

Type p165 = Record
  Header : sHeader;
  wType  : DWORD;
End;

type
  TSendCreateMobPacket = packed record
    Header: sHeader;
    Position: TPosition;
    ClientId: WORD;
    Name: array [0 .. 11] of AnsiChar;
    ChaosPoint: Byte;
    CurrentKill: Byte;
    TotalKill: WORD;
    ItemEff: array [0 .. 15] of WORD;
    Affect: array [0 .. 31] of TPacketAffect; ///////////////
    Unk0: LongInt; //00 00 00 CC     //player 14 02 00 CC
    Guildindex: WORD;
    Status: TStatus;
    SpawnType: Byte;
    MemberType: Byte;
    AnctCode: array [0 .. 15] of Byte;
    Tab: array [0 .. 24] of AnsiChar;
    unk: array [0 .. 3] of Byte;
    {
RECV 0x0364 >> E8 00 3F 6D 64 03 30 75 93 E4 27 21
52 08 F3 07
FC 03
43 61 62 75 6E 63 6C 65 57 69 6E 64
00
FE
FE FE
E7 00 00 00 00 00 00 00 00 00 00 00 BD 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CC
00 00  GuildIndex
////status
03 00 00 00 level
01 00 00 00
F4 01 00 00
F8 03 00 00 //move e merchant
28 23 00 00  //stats HP....
00 00 00 00
28 23 00 00
00 00 00 00
05 00 64 00 00 00 E8 03
C8 00 07 00 C8 00 07 00 // master
////////////////////////////////////////////////////////status
00 00 spawtype
00 membertype
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 anctcode
CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC CC tab
00 CC CC CC unk }
end;

type
  TSendCreateMobTradePacket = packed record
    Header: sHeader;
    Position: TPosition;
    Index: WORD;
    Name: array [0 .. 11] of AnsiChar;
    ChaosPoint: Byte;
    CurrentKill: Byte;
    TotalKill: WORD;
    ItemEff: array [0 .. 15] of WORD;
    Affect: array [0 .. 15] of TAffect;
    Guildindex: WORD;
    Status: TStatus;
    SpawnType: Byte;
    MemberType: Byte;
    unk: array [0 .. 13] of Byte;
    ClientId, unk2, y2, x2, clock: integer;
    unk3: array [0 .. 7] of Byte;
    StoreName: string[23]; // Array[0..23]of AnsiChar;
    unk4: array [0 .. 3] of Byte;
    // tab: string[200];
  end;

type
  SendTrade = Record
    Header: sHeader;
    TradeItem: array [0 .. 14] of TItem;
    TradeItemSlot: array [0 .. 14] of shortint;
    Unknow: Byte;
    Gold: integer;
    Confirma: boolean;
    OtherClientid: WORD;
end;

  // Request Open Trade
type
  p39A = Record
    Header: sHeader;
    Index: integer;
end;

  // Request Buy Item Trade
type
  p398 = Record
    Header: sHeader;
    slot, Index: integer;
    Gold, Unknown: integer;
    Item: sHeader;
end;

  // Request Create Item
type
  p182 = record
    Header:   sHeader;
    invType:  Word;
    invSlot:  Word;
    itemData: TItem;
end;

type
  p185 = record
    Header:   sHeader;
    item: Array [0..63] of TItem;
    Gold: DWORD;
end;

  // Request Refresh Inventory
  // Request Refresh Etc
  // Request Move Item
type
  zp376 = record
    Header: sHeader;
    destType: Byte;
    destSlot: Byte;
    SrcType: Byte;
    SrcSlot: Byte;
    Unknown: integer; // provavel gold banco
  end;

  // Request Refresh Itens
type
  p36B = record
    Header: sHeader;
    itemIDEF: array [0 .. 15] of WORD;
    pAnctCode: array [0 .. 15] of shortint;
end;

type
  affect336 = record
    Time: Byte;
    Index: Byte;
end;

type
  p336 = Packed record
    Header: sHeader;
    Status: TStatus;
    Critical, SaveMana: Byte;
    Affect: Array [0..31] of affect336;
    GuildIndex: Word;
    RegenHP,RegenMP : Byte;
    Resist: Array [0..3]of byte;
    Unk: Word;
    CurrHP: Word;
    CurrMP: DWORD;
    unk2: Byte;
    MagicIncrement: Byte;
    unk3: DWORD;
end;

type
  p337 = Packed record
    Header: sHeader;
    Hold: DWORD;
    Exp: Int64;
    Learn: array [0..1]of DWORD;
    pStatus, pMaster, pSkill: WORD;
    Magic: Byte;
    Unk: Byte;
    Gold: DWORD;
    xCCCC: DWORD;
{
     RECV 0x0337 >> 30 00 36 D6 37 03 1A 02 C4 D7 68 0A
00 00 00 00
0D 5A 00 00 00 00 00 00
00 00 00 00
 00 00 00 00
1B 00 1E 00 2D 00
CC
CC
 00 00 00 00
CC CC CC CC


    }
end;

type
  p181 = Record
    Header: sHeader;
    CurHP,CurMP: DWORD;
    MaxHP,MaxMP: DWORD;
 end;

 type
  p378 = Record
    Header: sHeader;
    SkillBar1: Array [0..3]of byte;
    SkillBar2: Array [0..15]of byte;
 end;


type
  sTradeLoja = Record
    Name: string[23];
    Item: array [0 .. 11] of TItem;
    slot: array [0 .. 11] of Byte;
    Gold: array [0 .. 11] of integer;
    Unknown, index: Smallint;
  end;

type
  p397 = Record
    Header: sHeader;
    Trade: sTradeLoja;
end;

type
  TTarget = Record
    TargetID, Damage: WORD;
end;

{$REGION 'Atake'} // atack reto
type
  p39E = packed record
    Header : sHeader;                //size= 5E
    HOLD : DWORD;
    reqMP: DWORD;
    Unk  : DWORD;
    CurrentExp: int64;
    unknow: Word;
    AttackerPos: TPosition;
    TargetPos: TPosition;
    attackerID: word;
    AttackerCount: word;
    Motion: byte;
    skillparm: byte; //07
    DoubleCritical: byte;
    FlagLocal: byte;
    Rsv: word;
    CurrentMP: Integer;
    skill: smallint;
    _ReqMp: word;
    Target: array [0..1] of St_Target;
    Padding: DWORD; //+0xBBB   onehit
 end;

Type p367 = packed Record    //certo
    Header : sHeader;                //size= 5E
    HOLD : DWORD;
    reqMP: DWORD;
    Unk  : DWORD;
    CurrentExp: int64;
    unknow: Word;
    AttackerPos: TPosition;
    TargetPos: TPosition;
    attackerID: word;
    AttackerCount: word;
    Motion: byte;
    skillparm: byte; //07
    DoubleCritical: byte;
    FlagLocal: byte;
    Rsv: word;
    CurrentMP: Integer;
    skill: word; //$FFFF
    _ReqMp: word;
    Target: Array [0..12]of St_Target;
    Padding: DWORD; //+0xBBB   onehit
    //+4
    {
    RECV 0x039D >> 48 00 1C 17 9D 03 30 75 F8 E6 2B 0F
00 00 00 00 hold
85 01 00 00 reqmp
00 00 00 00 unk
F5 1C 01 00 00 00 00 00 exp
00 00 unk
3A 08  F2 07 POS
3A 08 F2 07 POS
 CD 02 attackerid
00 00 att count
 FF motion
 00 skillparm
 00doublecritical
 00 flaglocal
 00 00  rsv
85 01 00 00 currentMP
28 00  skill id
 00 00 rqmp
55 2F 00 00 8B 00 00 00 00 00 00 00

 RECV 0x039D >> 48 00 DC 17 9D 03 30 75 2A 48 39 0F
CC CC CC CC
FF FF FF FF
CC CC CC CC CC CC CC CC CC CC CC CC CC CC
38 08 EF 07 pos
3A 08 F2 07 pos
64 16 attackerid

CC CC
 04 motion
00skillparm
 00 doublecritical
00 flaglocal
CC CC rsv

FF FF FF FF currentMP

69 00 skill id

CC CC _ReqMp
CD 02
 CC CC 04 00 00 00 CC CC CC CC

    }
End;

Type p39D = Record
    Header : sHeader;
    HOLD : DWORD;
    reqMP: DWORD;
    Unk  : DWORD;
    CurrentExp: int64;
    unknow: Word;
    AttackerPos: TPosition;
    TargetPos: TPosition;
    attackerID: word;
    AttackerCount: word;
    Motion: byte;
    skillparm: byte;
    DoubleCritical: byte;
    FlagLocal: byte;
    Rsv: word;
    CurrentMP: Integer;
    skill: word;
    _ReqMp: word;
    Target: St_Target;
    Padding: DWORD;
End;
{$ENDREGION}

  // Request Emotion
type
  p36A = Record
    Header: sHeader;
    effType, effValue: Smallint;
    Unknown1: integer;
  end;

type
  TSendWeatherPacket = Record
    Header: sHeader;
    WeatherId: integer;
  End;

  // Ataque em area
type
  p36Cz = packed record
    Header: sHeader;
    AttackerID, AttackCount: Smallint; // Id de quem Realiza o ataque
    AttackerPos: TPosition; // Posicao X e Y de quem Ataca
    TargetPos: TPosition; // Posicao X e Y de quem Sofre o Ataque
    SkillIndex: Smallint; // Id da skill usada
    CurrentMp: Smallint; // Mp atual de quem Ataca
    Motion: shortint;
    SkillParm: shortint;
    FlagLocal: shortint;
    DoubleCritical: shortint; // 0 para critico Simples, 1 para critico Duplo
    Hold, CurrentExp: integer;
    ReqMp: Smallint; // Mp necessario para usar a Skill
    Rsv: Smallint;
    Target: array [0 .. 12] of TTarget;
end;

type
  TCompoundersPacket = record
    Header: sHeader;
    Item: array [0 .. 7] of TItem;
    slot: array [0 .. 7] of Byte;
  end;

  // SendAffect
type
  TSendAffectsPacket = record
    Header: sHeader;
    Affects: array [0 .. 15] of TAffect;
  end;


Const
  EQUIP_TYPE = 0;
  INV_TYPE = 1;
  STORAGE_TYPE = 2;
  Cargo_TYPE = 2;
  EF_NONE = 0;
  // Status
  EF_LEVEL = 1;
  EF_DAMAGE = 2;
  EF_AC = 3;
  EF_HP = 4;
  EF_MP = 5;
  EF_EXP = 6;
  EF_STR = 7;
  EF_INT = 8;
  EF_DEX = 9;
  EF_CON = 10;
  EF_SPECIAL1 = 11;
  EF_SPECIAL2 = 12;
  EF_SPECIAL3 = 13;
  EF_SPECIAL4 = 14;
  EF_SCORE14 = 15;
  EF_SCORE15 = 16;
  // Requeriment
  EF_POS = 17;
  EF_CLASS = 18;
  EF_R1SIDC = 19;
  EF_R2SIDC = 20;
  EF_WTYPE = 21;
  EF_REQ_STR = 22;
  EF_REQ_INT = 23;
  EF_REQ_DEX = 24;
  EF_REQ_CON = 25;
 // Bonus
  EF_ATTSPEED = 26;
  EF_RANGE = 27;
  EF_PRICE = 28;
  EF_RUNSPEED = 29;
  EF_SPELL = 30;
  EF_DURATION = 31;
  EF_PARM2 = 32;
  EF_GRID = 33;
  EF_GROUND = 34;
  EF_CLAN = 35;
  EF_HWORDCOIN = 36;
  EF_LWORDCOIN = 37;
  EF_VOLATILE = 38;
  EF_KEYID = 39;
  EF_PARRY = 40;
  EF_HITRATE = 41;
  EF_CRITICAL = 42;
  EF_SANC = 43;
  EF_SAVEMANA = 44;
  EF_HPADD = 45;
  EF_MPADD = 46;
  EF_REGENHP = 47;
  EF_REGENMP = 48;
  EF_RESIST1 = 49;
  EF_RESIST2 = 50;
  EF_RESIST3 = 51;
  EF_RESIST4 = 52;
  EF_ACADD = 53;
  EF_RESISTALL = 54;
  EF_BONUS = 55;
  EF_HWORDGUILD = 56;
  EF_LWORDGUILD = 57;
  EF_QUEST = 58;
  EF_UNIQUE = 59;
  EF_MAGIC = 60;
  EF_AMOUNT = 61;
  EF_HWORDINDEX = 62;
  EF_LWORDINDEX = 63;
  EF_INIT1 = 64;
  EF_INIT2 = 65;
  EF_INIT3 = 66;
  EF_DAMAGEADD = 67;
  EF_MAGICADD = 68;
  EF_HPADD2 = 69;
  EF_MPADD2 = 70;
  EF_CRITICAL2 = 71;
  EF_ACADD2 = 72;
  EF_DAMAGE2 = 73;
  EF_SPECIALALL = 74;
  // Mount
  EF_CURKILL = 75;
  EF_LTOTKILL = 76;
  EF_HTOTKILL = 77;
  EF_INCUBATE = 78;
  EF_MOUNTLIFE = 79;
  EF_MOUNTHP = 80;
  EF_MOUNTSANC = 81;
  EF_MOUNTFEED = 82;
  EF_MOUNTKILL = 83;
  EF_INCUDELAY = 84;
  EF_SUBGUILD = 85;
  // Set Option
  EF_GRADE0 = 10;
  EF_GRADE1 = 101;
  EF_GRADE2 = 102;
  EF_GRADE3 = 103;
  EF_GRADE4 = 104;
  EF_GRADE5 = 105;
  // DELETE MOB TYPES
  DELETE_NORMAL = 0; // Somente desaparece
  DELETE_DEAD = 1; // Animacao da morte do spawn
  DELETE_DISCONNECT = 2; // Efeito de quando o personagem sai do jogo
  DELETE_UNSPAWN = 3; // Efeito quando os monstros ancts somem
  // SPAWN TYPES
  SPAWN_NORMAL = 0; // Somente aparece
  SPAWN_TELEPORT = 2;
  // Efeito usado quando o personagem nasce ou eh teleportado
  SPAWN_BABYGEN = 10; // Efeito de quando uma cria nasce (75x only)


  EF_UNKNOW1			=	118;

implementation

end.
