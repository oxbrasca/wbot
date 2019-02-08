unit PlayerData;

interface

uses Windows, MiscData;

type TStatus = Packed Record   //60 face guard
  Level  : DWORD;
  Defence: DWORD;
  Attack : DWORD;

  Dir  :  Byte;
  Speed:  Byte;
  N: Word;
  MaxHP, MaxMP: Integer;
  CurHP, CurMP: Integer;  //certo

  Str,Int: WORD;
  Dex,Con: WORD;

  wMaster: Word;
  fMaster: Word;
  sMaster: Word;
  tMaster: Word;

 Function cDir: TMerchant;
 Function cSpeed: TMove;
end;


type TAffect = Record
	Index: BYTE;
	Master: BYTE;
	Value: smallint;
	Time: integer;
end;


type TCharacter = Packed record
  Name: array[0..11] of AnsiChar;
  CapeInfo: BYTE;
  Merchant: BYTE;
  GuildIndex: WORD;
  unk: array[0..3] of BYTE;
  ClassInfo: BYTE;
  SkillProp: BYTE;
  QuestInfo: WORD;

  Gold: int64;
  Exp: int64;

  Last:    TPosition;
  bStatus: TStatus;  //status base
  Status:  TStatus;  //

  Equip: array[0..15] of TItem;
  Inventory: array[0..63] of TItem; //63
 // unk1_2,unk2_2: woRD;
  Learn:    DWORD;
  Uk: dword;
  pStatus:  WORD;
  pMaster:  WORD;
  pSkill:   WORD;
  Critical: BYTE;
  SaveMana: BYTE;

  SkillBar1: array[0..3] of byte;

  unkb: DWORD;//00 00 00 12

  Null: Array [0..211] of byte; //bytes nulos

  GuildMemberType: byte;
  MagicIncrement: BYTE;
  RegenHP: BYTE;
  RegenMP: BYTE;

  Resist: array[0..3] of BYTE;

  SlotIndex: word;
  ClientId: word;
  unk1: word;

  SkillBar2: array[0..15] of byte;
  Evasion: word;
  Hold: integer;

  Tab: Array [0..25] of ansichar;

  Affects: array[0..15] of TAffect;
  ClasseMaster: integer;
end;


type TParty = Record
  Leader: WORD;
  Members: array[0..10] of WORD;
  RequestId: WORD;
End;

type TPlayerSale = Record
  Name: string[23];
  Item: array[0..11] of TItem;

  Slot: array[0..11] of BYTE;

  Gold: array[0..11] of integer;
  Unknown, Index: smallint;
end;

type TTrade = Record
	IsTrading, Confirma: boolean;
	Waiting: boolean;

	Gold: integer;

	Timer: TDateTime;

	OtherClientid: WORD;

	Itens: array[0..14] of TItem;
	TradeItemSlot: array[0..14] of shortint;
end;

type TItemEffect = Record
    Index: Smallint;
    Value: Smallint;
end;

type TSkillData = Record
  Index : smallint;
  SkillPoint : integer;
  TargetType, ManaSpent, Delay, Range,
  InstanceType, InstanceValue, TickType, TickValue,
  AffectType, AffectValue, AffectTime : Integer;
  TickAttribute, Aggressive,
  Maxtarget, PartyCheck, AffectResist, PassiveCheck: Integer;
 // SkillName : String;
End;

Type TEffect = record
  Index, Value: word;
end;

type TItemList = Record
  Name: Array [0..63]of Ansichar;
  meshs : Array [0..1]of word;
  unk: word;
  level, STR, INT, DEX, CON: word;
  Effects : Array [0..11] of TEffect;
  Price: DWORD;
  Unique, Pos, Extreme, Grade : word;
end;

implementation

{ TStatus }
function TStatus.cDir: TMerchant;
begin
Result.Merchant := Dir and $0F; //shr5
Result.Direction:= Dir shr $4; //and $F0;
end;

function TStatus.cSpeed: TMove;
begin
Result.Move  := Speed and $0F;
Result.Attack:= Speed shr $4;  //and $F0;
end;

end.



