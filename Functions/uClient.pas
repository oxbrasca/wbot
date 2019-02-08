unit uClient;

interface

Uses
 Windows, Classes,
 Structs, MiscData, PlayerData, Def, nDef, SysUtils, Vcl.StdCtrls, Math;

Type THacks = Record
  Buff, Evok, Party, onMob, ondrop, onAmount, onBuild: Boolean;
  onMagic, onPhysic: Boolean;
  RangerMagic, RangerPhysic: byte;
  DropList    : ARRAY[0..174] OF WORD;
  AmountList  : ARRAY[0..20]  OF WORD;
  sAmountList : ARRAY[0..$FF]  OF ansichar;
  DropMaxList : BYTE;
  AmountMaxList : BYTE;
  PartyNames: Array [0..11, 0..15] of ansichar;
  Mobs      : Array [0..30] of word;
  maxmob    : byte;

  pDead_Route: Boolean;
  pDead_Perga: Boolean;
End;

Type TMacro = Record
  progress : Integer;
  CurrentID: smallint;
  BarIndex : Integer;
  SkillID  : byte;
  Delay    : Array [0..102] of LongInt;    //MAX_SKILLDATA
  DelayProc: LongInt;
  DelayMs  : LongInt;
  OutOfPosition: Boolean;
  Position: TPosition;
End;

Type TWater = Record
  Status,
  wType, // 0 = N, 1= M, 2 = A
  Room,
  Moving:  smallint;
End;

Type xPlayers = Record
//  Name: Array [0..15] of Ansichar;
  Status: TStatus;
  Position: TPosition;
  Face: Word;
  Index: Word;
  Affect: Array [0..31] of St_Affect;
End;

Type TNPC = Record
  Face    : word;
  Index   : word;
  Position: TPosition;
End;

Type TParty = Record
    ClientID:  smallint;
    NickName: Array [0..15]of Ansichar;
End;

Type TQuiz = Record
  Question: Array [0..95]of Ansichar;
  Answer: Array [0..3] of Array [0..31] of Ansichar;
End;

Type TEvent = Record
  Status, Delay: DWORD;
End;

type TGame = class
 Public
  Class Procedure Start;
  Class Procedure InitConfig;
  CLass Procedure CarbunkleBuff;
  Class Function  CalcMovement(SrcPos,DstPos: TPosition): Byte;
  Class Function  GetNextSkill:Word;
  Class Function  SelectEnemy: Boolean;
  Class Function  CurrentIsvalid: Boolean;
  Class Procedure MacroSystem;
  Class Procedure ClearEnemyList;
  Class Procedure RemoveFromMobGrid(id: word);
  Class Function  AddEnemyList(EnemyID, distance: SmallInt): Boolean;
  Class Function  UseItem(Var Item: TItem): Boolean;
  Class Procedure SetBuild;
  Class Function AutoPot(HPPercent,MPPercent: DWORD): boolean;
  Class Function HaveSkill(Skillid: integer): Boolean;
  Class Function AutoFeed(feedPercent: Integer): Boolean;
  Class Function DoWater: DWORD;
  Class Function GetCity: Byte;
  Class Function GetFirstSlot(id: word):Integer;
  Class Function GetQuantItem(item: TItem): BYTE;
  Class Function GetMobAbility(eff: integer): integer;
  class function GetMaxAbility(eff: integer): integer;
  class function GetAffectSlot(const item   : TItem; buffId: word): dword;Overload;
  class function GetAffectSlot(const affect: array of st_Affect; buffId: word): Integer;Overload;
  class function GetItemAbility(const item : TItem; eff: integer) : smallint;
  class function GetDistance( x1, y1, x2, y2: integer): Integer; Overload;
  class function GetDistance(SrcPos, DstPos: TPosition): Integer;Overload;
  class function GetDistance2( x1, y1, x2, y2: integer): Integer;
  class function GetDist2( x1, y1, x2, y2: integer): Integer;Overload;
  class function GetDist2(x1, y1: integer): Integer;Overload;
  class function GetEffectValue(itemid: integer; eff:shortint) : smallint;
  class function GetSanc(item : TItem): smallint;
  class function GetManaSpent(skillid, saveMana, mastery: integer):integer;
  Class Function CalcVelo: Word;
  Class Function  GetGridID(PosX,PosY: smallInt): smallint;
  Class Function  SetGridID(Value,PosX,PosY: smallInt): smallint;
  Class Procedure InfoInventory(W: TMemo);
  Class Procedure InfoEquip(W: TMemo);
  Class Procedure InfoCargo(W: TMemo);
  class function  Live: Boolean;
  Class var CharInSlot: Boolean;
  Class Var ClientID :  smallint;
  Class Var CharID   :  smallint;
  Class Var SecCounter:Integer;
  Class Var Token    : Boolean;
  Class Var Session  : byte;
  Class Var DamageRange : byte;
  Class Var wType    : integer;
  Class Var MyPos    : TPosition;
  Class Var Affect   : Array [0..MAX_AFFECT] of st_Affect;
  Class Var EnemyList: Array [0..MAX_ENEMY] of Array [0..1] of smallint;

  Class Var Players  : Array [0..MAX_SPAWN_MOB] of xPlayers; ///999..30k
  Class Var NPCs     : Array [0..10]  of TNPC; ///999..30k
  Class Var Evoks    : Array [0..11]  of word;
  Class Var Party    : Array [0..11]  of TParty;
  Class Var Storage  : Array [0..127] of TItem;
  Class Var MobGrid  : array[MIN_Y..MAX_Y, MIN_X..MAX_X] of word;  //onde vai as index    4095
  Class VAr Transform: byte;
  Class VAr SetEvok  : Byte;
  Class Var SkillBar : Array [0..1, 0..9]of Byte;
  Class Var LeaderId :  smallint;
  Class Var NextUseSK: Boolean;
  Class Var Hacks: THacks;
 // Class Var TotalQuiz: Integer;
  Class Var Macro    : TMacro;
 // Class Var Water    : TWater;
  Class Var mMotion  : Byte;
  Class Function vMotion: Byte;
  Class Var Mob      : TCharacter;
 // Class Var wait_recv: Array [0..MAX_RECV] of byte;
 // Class Var AutoTrade:p397;
//  Class Var CharList : TSendToCharListPacket;
 end;

implementation

Uses
 uPackets, func, ClSocket, EncDec;

 Var cPower : array[0..4] of integer = (220, 250, 280, 320, 370);

class procedure TGame.InitConfig;
begin
  ZeroMemory(@MobGrid  , Sizeof(MobGrid));
  ZeroMemory(@Macro    , Sizeof(Macro));
  ZeroMemory(@Party    , sizeof(Party));
	ZeroMemory(@Players  , sizeof(Players));
	ZeroMemory(@Storage  , sizeof(TItem));
	ZeroMemory(@EnemyList, sizeof(EnemyList));
 // ZeroMemory(@wait_recv, sizeof(wait_recv));
  ZeroMemory(@Evoks    , sizeof(Evoks));
  Hacks.onMob:= False;
  Hacks.Mobs[0]:= 235;
//  Hacks.onMob:= True;

  CharInSlot    := False;
  mMotion       := 4;
	Token	       	:= false;
	SecCounter   	:= 0;
	Session		    := 0;
  DamageRange   := 0;
  Transform     := 64;//64
  SetEvok       := 56;//56
	Macro.BarIndex		  := -1;
	Macro.CurrentId		  := -1;
	Macro.SkillId       := $FF;
  Macro.DelayProc     := TRANS_SK;
  Macro.progress      := 0;
	Macro.OutOfPosition := False;
  MyPos.X:= 0; MyPos.Y:= 0;
end;

class function TGame.Live: Boolean;
begin
  Result := Mob.Status.CurHP > 0;
end;

Class Procedure  TGame.InfoInventory(W: TMemo);
Var
 I,ID: Integer;
Const
   sT: String = 'SLOT: %d  ID: %d  Name: %s ';
begin
w.Clear;
  for i := 0 to cMax.Inventory do
  if Mob.Inventory[i].ID >0 then
  begin
  ID:= Mob.Inventory[i].ID;
  W.Lines.Add(Format(sT,[I, Mob.Inventory[i].ID,  ItemList[ID].Name]));
  end;
end;

Class Procedure  TGame.InfoCargo(W: TMemo);
Var
 I,ID: Integer;
Const
   sT: String = 'SLOT: %d  ID: %d  Name: %s ';
begin
w.Clear;
  for i := 0 to cMax.Inventory do
  if Storage[i].ID > 0 then
  begin
   ID:= Storage[i].ID;
   W.Lines.Add(Format(sT,[I, Storage[i].ID,  ItemList[ID].Name]));
  end;
end;

Class Procedure TGame.InfoEquip(W: TMemo);
Var
 I: Integer;
 ID: integer;
Const
   sT: String = 'SLOT: %d  ID: %d  Name: %s ';
   sT2: String = '%d %d %d %d %d %d %d %d %d %d %d %d %d';
begin
w.Clear;
  for i := 0 to cMax.Equip do
  if Mob.Equip[i].ID >0 then
  begin
  id:= Mob.Equip[i].ID;

  W.Lines.Add(Format(sT,[I, id, ItemList[id].Name ]));
 { W.Lines.Add(Format(sT2,[ItemList[id].Effects[0].Index, ItemList[id].unk,ItemList[id].meshs[0], ItemList[id].meshs[1],
  ItemList[id].level,
  ItemList[id].STR,
  ItemList[id].int,
  ItemList[id].DEX,
  ItemList[id].CON,
  ItemList[id].Unique,
  ItemList[id].Pos,
  ItemList[id].Extreme,
  ItemList[id].Grade
  ]));
  }
  end;

end;


class function TGame.GetAffectSlot(const item: TItem; buffId: word): dword;
var
I: integer;
begin
  for i := 0 to MAX_AFFECT do
  if(Item.Effects[i].Index = buffId) then	Result:= i;
	Dec(result);
end;

class function TGame.GetAffectSlot(const affect: array of st_Affect;
  buffId: word): Integer;
var
I: integer;
begin
  for i := 0 to MAX_AFFECT do
  if(affect[i].index = buffId) then
  begin
  Result:= i;
  Exit;
  end
  else
  Result:= -1;
end;

class function TGame.GetCity: Byte;
begin
Result:= $FF;

 if(Mypos.X >= 2052) and (Mypos.x <= 2171) and (Mypos.y >= 2052) and (Mypos.y <= 2163) then
  Result:= 0;

 if(Mypos.X >= 2432) and (Mypos.x <= 2675) and (Mypos.y >= 1536) and (Mypos.y <= 1767) then
  Result:= 1;

 if(Mypos.X >= 2448) and (Mypos.x <= 2476) and (Mypos.y >= 1966) and (Mypos.y <= 2024) then
  Result:= 2;

 if(Mypos.X >= 3500) and (Mypos.x <= 3700) and (Mypos.y >= 3100) and (Mypos.y <= 3200) then
  Result:= 3;

 if(Mypos.X >= 1036) and (Mypos.x <= 1075) and (Mypos.y >= 1700) and (Mypos.y <= 1775) then
  Result:= 4;
end;

class function TGame.GetDistance(x1, y1, x2, y2: integer): Integer;
begin
//  Result:= sqrt(single(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1))));
  Result:= Trunc(sqrt(sqr(X2-X1)+sqr(y2-y1)));
  //sqrt(sqr(X2-X1)+sqr(y2-y1))

  if Result >1000 then Result:= 30;

end;

class function TGame.GetDist2(x1, y1, x2, y2: integer): Integer;
begin
  Result:= abs(ceil(sqrt(power(x1 - x2, 2) + power(y1 - y2, 2))));
end;

class function TGame.GetDist2(x1, y1: integer): Integer;
begin
   Result:= abs(ceil(sqrt(power(x1 - MyPos.x, 2) + power(y1 - MyPos.Y, 2))));
end;

class function TGame.GetDistance(SrcPos, DstPos: TPosition): Integer;
begin
 Result:= Trunc(sqrt(sqr(DstPos.X-SrcPos.X)+sqr(DstPos.Y-SrcPos.Y)));
end;

class function TGame.GetDistance2(x1, y1, x2, y2: integer): Integer;
var
dx, dy: Integer;
begin
if(x1 > x2) then
		dx := x1 - x2
	else
		dx := x2 - x1;

	if(y1 > y2) then
		dy := y1 - y2
	else
		dy := y2 - y1;

	if(dx <= 6) and (dy <= 6) then
		result:= g_pDistanceTable[dy][dx];

	if(dx > dy) then
		result:= dx+1
	else
		result:= dy+1;
end;

class function TGame.GetEffectValue(itemid: integer; eff: shortint): smallint;
var i: BYTE;
begin
  for i := 0 to 11 do begin
    if(ItemList[itemid].Effects[i].Index = eff)then
    begin
      result:= ItemList[itemid].Effects[i].Value;
      exit;
    end;
  end;
  result:= 0;
end;

{TClient}
class function TGame.AddEnemyList(EnemyID, distance: SmallInt): Boolean;
Var
 I: Integer;
begin
 Result:= False;

 if distance > 23 then exit;


 for i := 0 to MAX_ENEMY do
 if(EnemyList[i][0] = enemyId) then
 begin
  EnemyList[i][0]:= enemyId;
	EnemyList[i][1]:= distance;
  Result:= True;
  Exit;
 end;
 for i := 0 to MAX_ENEMY do
 if(EnemyList[i][0] <= 0) then
 begin
  EnemyList[i][0] := enemyId;
  EnemyList[i][1] := distance;
  Result:= True;
  Exit;
 end;
end;

class function TGame.HaveSkill(Skillid: integer): Boolean;
var skillID2, aux: Integer;
begin
  skillID2 := Skillid mod 24;
  aux      := (Mob.Learn and (1 shl skillID2));
  Result   :=  aux  > 0;
end;

class function TGame.AutoFeed(feedPercent: Integer): Boolean;
Var
 mont: TItem;
 baseId, mountId, searched, slotId: Integer;
begin
  mont := Mob.Equip[14];
  baseId := 0;
	if(mont.id >= 2330) and (mont.id < 2360) then baseId := 2330;
  if(mont.id >= 2360) and (mont.id < 2390) then baseId := 2360;
      mountId := (mont.id - baseId) mod 30; // local1028
	if (mountId >= 6) and (mountId <= 15) or (mountId = 27) then mountId := 6;
  if (mountId = 19) then mountId := 7;
  if (mountId  = 20) then mountId := 8;
  if (mountId = 21)or (mountId = 22) or (mountId = 23) or (mountId = 28) then mountId := 9;
  if (mountId = 24) or (mountId = 25) or (mountId = 26) then mountId := 10;
  if (mountId = 29)  then mountId := 19;
  searched := mountId + 2420;
  slotId := GetFirstSlot(searched);
  if(slotId  = -1) then
  begin
    Result:= false;
    Exit;
  end;
	UseItem(Mob.Inventory[slotId]);
  TsPackets.UseItem(INV_TYPE, slotId, 0, 0);
  Result:=true;
end;

class function TGame.AutoPot(HPPercent, MPPercent: DWORD): boolean;
var
 minHp, minMP, slotId, i: Integer;
begin
 minHp := Trunc(Mob.Status.maxHP * hpPercent / 100);
 minMp := Trunc(Mob.Status.maxMP * mpPercent / 100);
 if(Mob.Status.curHP < minHp) then
 for I := 0 to 2 do
 begin
  slotId := GetFirstSlot(pots[0][i]);
  if(slotId = -1) then continue;
  UseItem(Mob.Inventory[slotId]);
  TsPackets.UseItem(INV_TYPE, slotId, 0, 0);
  Result:=true;
  exit;
 end;
 if(Mob.Status.curMP < minMp) then
 for I := 0 to 2 do
 begin
  slotId := GetFirstSlot(pots[1][i]);
  if(slotId  = -1) then continue;
  UseItem(Mob.Inventory[slotId]);
  TsPackets.UseItem(INV_TYPE, slotId, 0, 0);
  Result:=true;
  exit;
 end;
 Result:=false;
end;

class function TGame.GetGridID(PosX, PosY: smallInt): smallint;
begin
 Result:= MobGrid[posy][PosX];
end;

class procedure TGame.SetBuild;
begin
if Mob.pStatus > 0 then
begin

 case Mob.ClassInfo of
  TK:TsPackets.AddPoint(0,1); //inteligencia   MAGO
  FM:TsPackets.AddPoint(0,1); //inteligencia
  BM:TsPackets.AddPoint(0,1); //inteligencia
  HT:begin
     if inrange(Mob.Status.Level,0,25)  then TsPackets.AddPoint(0,2); //destreza
     if inrange(Mob.Status.Level,26,50) then TsPackets.AddPoint(0,0); //força
     //TsPackets.AddPoint(1,0); //aprender arma
     end;

 end;

end;
   {
if (Mob.pStatus = 0) and (Mob.pMaster > 0) then
begin

 case Mob.ClassInfo of
  TK:TsPackets.AddPoint(0,1); //inteligencia   MAGO
  FM:TsPackets.AddPoint(0,1); //inteligencia
  BM:TsPackets.AddPoint(0,1); //inteligencia
  HT:begin
       TsPackets.AddPoint(1,0); //aprender arma

     end;

 end;

end;
     }
// Dec(Mob.pStatus);
end;

class function TGame.SetGridID(Value, PosX, PosY: smallInt): smallint;
begin
   MobGrid[posy][PosX]:= Value;
end;

class procedure TGame.Start;
begin
if (SubStatus <= Deslogado) then
 TThread.CreateAnonymousThread(
  procedure
  begin
  TThread.Synchronize(nil,
   procedure
   begin
    Delay(1000);
    SubStatus:= Logando;
    Session := USER_LOGIN;
    TClient.CloseSocket;
   if Acc.ProxyIP <> '' then
    TClient.CLConect(Acc.ProxyIP)
    else
    TClient.ClConect(GetServerIP, PortServ);
   end);
  end).Start;
end;

class function TGame.CalcMovement(SrcPos, DstPos: TPosition): Byte;
begin
  Result:=Trunc(TGame.GetDistance(SrcPos,DstPos) * (16 - CalcVelo) /2);
  if (result< 1) or (result> 30) then
   Result:= ceil(TGame.GetDistance(SrcPos, DstPos) / CalcVelo) * 10;

      if (result< 5)  then Result:= 5;
      if (result> 60) then Result:= 60;
      {
   WriteLn('CALC ', floor(Dis / P.sMove));
 WriteLn(ceil(Dis / P.sMove) * 10);
 Result:= TGame.CalcMovement(P.SrcPos, P.DstPos);
 Result:= ceil(TGame.GetDistance(P.SrcPos,P.DstPos) / P.sMove) * 10;
      }
end;

class function TGame.CalcVelo: Word;
begin
 Result:= Mob.Status.cSpeed.Move;
if (Result <= 2) or (Result >= 20) then Result:= 4;
end;

class procedure TGame.CarbunkleBuff;
begin                                             //buff defesa
if (GetDistance(NPCs[0].Position, MyPos) < 6) and (GetAffectSlot(Affect, 2) = -1)  then
TsPackets.ClickNPC(NPCs[0].index);
end;

class procedure TGame.ClearEnemyList;
Var
 I: Integer;
begin
 ZeroMemory(@EnemyList ,sizeof(EnemyList));
	// adicionamos a distância padrão como 100 para análise pela próxima função
	for i := 0 to MAX_ENEMY do
      EnemyList[i][1]:= 100;
end;

class function TGame.CurrentIsvalid: Boolean;
Var
 current, CurrentRanger,distance: Integer;
 Pos: TPosition;
begin
  Result:= false;
  current:= Macro.CurrentId;
  if current = -1 then exit;
  if Players[current].Index<= 0 then exit;

  Pos:= Players[current].Position;

  CurrentRanger:= DamageRange;
 if (Macro.SkillId <> $FF) then
     CurrentRanger:= SkillData[Macro.SkillId].Range;

   distance:= GetDistance(Pos, MyPos);

	if (distance > CurrentRanger) or (distance> 23) then
  begin
   Macro.CurrentId:= -1;
   exit;
  end;

  if (Players[current].Status.CurHP <= 0)
  then
  begin
   RemoveFromMobGrid(current);
   Macro.CurrentId:= -1;
   Exit;
  end;

  Result:=  true;
end;

class function TGame.DoWater: DWORD;
begin

end;

class function TGame.GetFirstSlot(id: word): Integer;
Var
 I: Integer;
begin
  for I := 0 to cMax.Inventory do
  if(Mob.Inventory[i].id = Id) then
  begin
   Result:= i;
   exit;
  end;
	Result:= -1;
end;

class function TGame.GetItemAbility(const item: TItem; eff: integer): smallint;
var resultt,itemid,unique,pos,i,val,ef2,sanc,x: integer;
begin
  resultt:=0;
  itemid:=item.id;
  if(itemid <= 0) or (itemid >= 6500) then
  begin
    result:=0;
    exit;
  end;
  unique:=ItemList[itemid].Unique;
  pos:=ItemList[itemid].Pos;

  if(eff = EF_DAMAGEADD) or (eff = EF_MAGICADD)then
      if(unique < 41) or (unique > 50)then begin
          result:= 0;
          exit;
      end;

  if(eff = EF_CRITICAL)then
      if(item.Effects[1].Index = EF_CRITICAL2) or (item.Effects[2].Index = EF_CRITICAL2)then
          eff := EF_CRITICAL2;

  if(eff = EF_DAMAGE) and (pos = 32)then
      if(item.Effects[1].Index = EF_DAMAGE2) or (item.Effects[2].Index = EF_DAMAGE2)then
          eff := EF_DAMAGE2;

  if(eff = EF_MPADD)then
      if(item.Effects[1].Index = EF_MPADD2) or (item.Effects[2].Index = EF_MPADD2)then
          eff := EF_MPADD2;

  if(eff = EF_ACADD)then
      if(item.Effects[1].Index = EF_ACADD2) or (item.Effects[2].Index = EF_ACADD2)then
          eff := EF_ACADD2;

  if(eff = EF_LEVEL) and (itemID >= 2330) and (itemID < 2360) then
      resultt := (item.Effects[1].Index - 1)
  else if(eff = EF_LEVEL)then
      inc(resultt,ItemList[itemID].Level);

  if(eff = EF_REQ_STR)then
      inc(resultt,ItemList[itemID].Str);
  if(eff = EF_REQ_INT)then
      inc(resultt,ItemList[itemID].Int);
  if(eff = EF_REQ_DEX)then
      inc(resultt,ItemList[itemID].Dex);
  if(eff = EF_REQ_CON)then
      inc(resultt,ItemList[itemID].Con);

  if(eff = EF_POS)then
      inc(resultt,ItemList[itemID].Pos);

  if(eff <> EF_INCUBATE)then
  begin
      for i := 0 to 11 do begin
          if(ItemList[itemID].Effects[i].Index <> eff)then
              continue;

          val := ItemList[itemID].Effects[i].Value;
          if(eff = EF_ATTSPEED) and (val = 1)then
              val := 10;

          inc(resultt,val);
          break;
      end;
  end;

    if(item.id >= 2330) and (item.id < 2390)then
    begin
      if(eff = EF_MOUNTHP)then
      begin
          result:=item.Effects[1].Index;
          exit;
      end;

      if(eff = EF_MOUNTSANC) then
       begin
          result:=item.Effects[1].Index;
          exit;
      end;

      if(eff = EF_MOUNTLIFE)then
       begin
          result:=item.Effects[1].Value;
          exit;
      end;

      if(eff = EF_MOUNTFEED)then begin
          result:=item.Effects[2].Index;
          exit;
      end;

      if(eff = EF_MOUNTKILL)then begin
          result:=item.Effects[2].Value;
          exit;
      end;

      if(item.id >= 2360) and (item.id <= 2389) and (item.Effects[0].Index > 0)then
      begin
          ef2 := item.Effects[1].Index;

          if(eff = EF_DAMAGE)then begin
              result:=Trunc(((GetEffectValue(item.id, EF_DAMAGE) * (ef2 + 20)) / 100));
          end;
         exit;
      end;

          if(eff = EF_MAGIC)then begin
              result:=Trunc(((GetEffectValue(item.id, EF_MAGIC) * (ef2 + 15)) / 100));
              exit;
          end;

          if(eff = EF_PARRY)then begin
              result:=GetEffectValue(item.id, EF_PARRY);
              exit;
          end;

          if(eff = EF_RUNSPEED)then begin
              result:=GetEffectValue(item.id, EF_RUNSPEED);
              exit;
          end;

          if(eff = EF_RESIST1) or (eff = EF_RESIST2) or
             (eff = EF_RESIST3) or (eff = EF_RESIST4) then begin
              result:=GetEffectValue(item.id, EF_RESISTALL);
              exit;
          end;

      result:=resultt;
      exit;
    end;

    if(item.Effects[0].Index = eff)then
    begin

      val := item.Effects[0].Value;
      if(eff = EF_ATTSPEED) and  (val = 1)then
          val := 10;

      inc(resultt,val);
    end
    else
    begin
       if(item.Effects[1].Index = eff)then begin

        val := item.Effects[1].Value;
        if(eff = EF_ATTSPEED) and  (val = 1)then
            val := 10;

        inc(resultt,val);
      end
      else
      begin
         if(item.Effects[2].Index = eff)then begin

          val := item.Effects[2].Value;
          if(eff = EF_ATTSPEED) and  (val = 1)then
              val := 10;

          inc(resultt,val);
        end;
      end;
    end;

    if(eff = EF_RESIST1) or (eff = EF_RESIST2) or
       (eff = EF_RESIST3) or (eff = EF_RESIST4) then
    begin
      for i := 0 to 11 do begin
        if(ItemList[itemID].Effects[i].Index <> EF_RESISTALL)then
            continue;

        inc(resultt,ItemList[itemID].Effects[i].Value);
        break;
      end;

      if(item.Effects[0].Index = EF_RESISTALL)then
        inc(resultt,item.Effects[0].Value)
      else
      if(item.Effects[1].Index = EF_RESISTALL)then
        inc(resultt,item.Effects[1].Value)
      else
      if(item.Effects[2].Index = EF_RESISTALL)then
        inc(resultt,item.Effects[2].Value);
    end;

    sanc := GetSanc(item);
    if(item.id <= 40)then
        sanc := 0;

    if(sanc >= 9) and ((pos and $F00) <> 0) then
        inc(sanc,1);

    if(sanc <> 0) and (eff <> EF_GRID) and (eff <> EF_CLASS) and
       (eff <> EF_POS) and (eff <> EF_WTYPE) and (eff <> EF_RANGE) and
       (eff <> EF_LEVEL) and (eff <> EF_REQ_STR) and (eff <> EF_REQ_INT) and
       (eff <> EF_REQ_DEX) and (eff <> EF_REQ_CON) and (eff <> EF_VOLATILE) and
       (eff <> EF_INCUBATE) and (eff <> EF_INCUDELAY)then
    begin
        if(sanc <= 10)then
            resultt := Trunc((((sanc + 10) * result) / 10))
        else
        begin
          val := cPower[sanc - 11];
          resultt := Trunc(((((result * 10) * val) / 100) / 10));
        end;
    end;

    if(eff = EF_RUNSPEED)then
    begin
        if(resultt >= 3)then
            resultt := 2;

        if(resultt > 0) and (sanc >= 9)then
            inc(resultt,1);
    end;

    if(eff = EF_HWORDGUILD) or (eff = EF_LWORDGUILD)then
    begin
        x := resultt;
        resultt := x;
    end;

    if(eff = EF_GRID)then
        if(resultt < 0) or (resultt > 7)then
            resultt := 0;

    result:=resultt;
end;

class function TGame.GetManaSpent(skillid, saveMana, mastery: integer): integer;
Var
 ManaSpent : DWORD;
begin
  manaspent:=  Skilldata[skillid].ManaSpent;
	manaSpent := trunc((((mastery shr 1) + 100) * manaSpent) / 100);
	manaSpent := trunc(((100 - saveMana) * manaSpent) / 100);
	Result:= manaSpent;
end;

class function TGame.GetMaxAbility(eff: integer): integer;
var MaxAbility,i: integer;
ItemAbility: smallint;
begin
  MaxAbility:=0;
  for i := 0 to 15 do begin
    if(TGame.Mob.Equip[i].id = 0)then
      continue;

    ItemAbility:= GetItemAbility(Mob.Equip[i], eff);
    if(MaxAbility < ItemAbility)then
      MaxAbility := ItemAbility;
  end;
  result:=MaxAbility;
end;

class function TGame.GetMobAbility(eff: integer): integer;
var LOCAL_1,LOCAL_2,LOCAL_19,LOCAL_20,dam1,dam2,arm1,arm2,unique1:integer;
porc,unique2,LOCAL_28: integer;
LOCAL_18: array[0..15] of integer;
begin
  LOCAL_1:=0;
  if(eff = EF_RANGE)then
  begin
    LOCAL_1 := GetMaxAbility(eff);

    LOCAL_2 := Trunc((Mob.Equip[0].id / 10));
    if(LOCAL_1 < 2) and (LOCAL_2 = 3)then
        if((TGame.Mob.Learn and $40) <> 0)then //$40     and $100000
            LOCAL_1 := 2;

    result:=LOCAL_1;
    exit;
  end;

  for LOCAL_19 := 0 to 15 do
  begin
      LOCAL_18[LOCAL_19] := 0;
      LOCAL_20 := TGame.Mob.Equip[LOCAL_19].id;
      if(LOCAL_20 = 0) and (LOCAL_19 <> 7)then continue;
      if(LOCAL_19 >= 1) and (LOCAL_19 <= 5)then
         LOCAL_18[LOCAL_19] := ItemList[LOCAL_20].Unique;
      if(eff = EF_DAMAGE) and (LOCAL_19 = 6)then continue;
      if(eff = EF_MAGIC) and (LOCAL_19 = 7)then continue;
      if(LOCAL_19 = 7) and (eff = EF_DAMAGE)then
      begin
        dam1:= (GetItemAbility(TGame.Mob.Equip[6], EF_DAMAGE) +
                    GetItemAbility(TGame.Mob.Equip[6], EF_DAMAGE2));
        dam2:= (GetItemAbility(TGame.Mob.Equip[7], EF_DAMAGE) +
                    GetItemAbility(TGame.Mob.Equip[7], EF_DAMAGE2));

        arm1 := TGame.Mob.Equip[6].id;
        arm2 := TGame.Mob.Equip[7].id;

        unique1 := 0;
        if(arm1 > 0) and (arm1 < 6500)then
            unique1 := ItemList[arm1].Unique;

        unique2 := 0;
        if(arm2 > 0) and (arm2 < 6500)then
            unique2 := ItemList[arm2].Unique;

        if(unique1 <> 0) and (unique2 <> 0)then
        begin
          porc := 0;
          if(unique1 = unique2)then
              porc := 70    //50
          else
              porc := 50;   //30

              //pericia do caçador
          if Boolean(Mob.Learn and (1 shl 10)) and (Mob.ClassInfo = 3) then
          porc:= 100;

          //mestre das armas
         if Boolean(Mob.Learn and (1 shl 9)) and (Mob.ClassInfo = 9) then
          porc:= 100;


          if(dam1 > dam2)then
              LOCAL_1 := Trunc(((LOCAL_1 + dam1) + ((dam2 * porc) / 100)))
          else
              LOCAL_1 := Trunc(((LOCAL_1 + dam2) + ((dam1 * porc) / 100)));
            continue;
        end;

        if(dam1 > dam2) then inc(LOCAL_1,dam1)
        else
          inc(LOCAL_1,dam2);
         continue;
      end;
      LOCAL_28 := GetItemAbility(Mob.Equip[LOCAL_19], eff);
      if(eff = EF_ATTSPEED) and (LOCAL_28 = 1)then
         LOCAL_28 := 10;
         inc(LOCAL_1,LOCAL_28);
  end;
        if(eff = EF_AC) and (LOCAL_18[1] <> 0)then
        if(LOCAL_18[1] = LOCAL_18[2]) and (LOCAL_18[2] = LOCAL_18[3]) and
          (LOCAL_18[3] = LOCAL_18[4]) and (LOCAL_18[4] = LOCAL_18[5])then
           LOCAL_1 := Trunc(((LOCAL_1 * 105) / 100));
 result := LOCAL_1;
end;

class Function TGame.GetNextSkill: Word;
Var
 count, total: Integer;
 skillId: Byte;
 delay, calc: integer;
 InitBar,i: byte;
begin
  count:= Macro.BarIndex;
  InitBar:= 9;//9;
  if(count < 0) or (count > InitBar) then count := InitBar;
  skillId:= $FF;
  total  := 0;
  Repeat
   Inc(total);
   if(total > 100) then
   begin
	  Macro.SkillId:= $FF;
    break;
   end;
   Dec(count);
   if(count < 0) then count:= InitBar; //volta pro inicio
   skillId:= SkillBar[0][count];
	 if (skillId = $FF) then continue; //se não tiver sk no slot
   if (SkillData[skillId].TargetType = 0) then continue;
   if (SkillData[skillId].TargetType = 2) then continue;//buff de fm em outro player

   delay:= Macro.Delay[skillId];
   if(delay <> 0) then
   begin
    if (TEncDec.GetTime - delay < (SkillData[skillId].Delay * CLOCKS_PER_SEC)) then
    begin
     SkillId:= $FF;
     continue;
    end
    else
    begin  //se o delay ja tiver acabado
     skillId:= SkillBar[0][count];
     break;
    end;
   end;
   if Delay = 0 then
   begin  //se ainda for 0
    skillId:= SkillBar[0][count];
    break;
   end;

  Until(skillId = $FF);
  Macro.BarIndex:= count; //saindo do loop
	Macro.SkillId := skillId;
  if Macro.SkillId = $FF then Macro.DelayProc:= 10;//dMagig;

  Result:= skillId;
end;

class function TGame.GetQuantItem(item: TItem): BYTE;
begin
  result:=1;
  if(item.Effects[0].Index = EF_AMOUNT)then
    result:=item.Effects[0].Value
  else
  if(item.Effects[1].Index = EF_AMOUNT)then
    result:=item.Effects[1].Value
  else
  if(item.Effects[2].Index = EF_AMOUNT)then
    result:=item.Effects[2].Value;
end;

class function TGame.GetSanc(item: TItem): smallint;
var
 value: integer;
begin
  value:=0;
  if(item.id >= 2360) and (item.id <= 2389) then
  begin  //Montarias.
   value := Trunc((item.Effects[2].Index / 10));
   if(value > 9) then value := 9;
   result := value;
   exit;
  end;
  if(item.id >= 2330) and (item.id <= 2359) then
  begin
   //Crias.
   result:= 0;
   exit;
  end;
       if(item.Effects[0].Index = 43) then value := item.Effects[0].Value
  else if(item.Effects[1].Index = 43) then value := item.Effects[1].Value
  else if(item.Effects[2].Index = 43) then value := item.Effects[2].Value;

  if(value >= 230)then
  begin
   value := Trunc(10 + ((value - 230) / 4));
   if(value > 15) then value := 15;
  end
  else
  value :=(value mod 10);
  result:=value;
end;

class procedure TGame.MacroSystem;
var
 hpPercent, mpPercent, feedPercent: Integer;
begin
 if(Mob.Status.curHP <= 0) or (Session <> USER_PLAY) then exit;
 if(hpPercent <> 0) or (mpPercent <> 0) then
 if(AutoPot(hpPercent, mpPercent)) then exit;
 if(feedPercent <> 0) then
 if(AutoFeed(feedPercent)) then exit;
end;

class procedure TGame.RemoveFromMobGrid(id: word);
var
mobId, y, x: integer;
begin
 mobId:= GetGridID(Players[id].Position.X, Players[id].Position.Y);
 if(mobId <> id) then
 begin
	 for y:= MIN_Y to MAX_Y do
   for x:= MIN_X to MAX_X do
   if(MobGrid[y][x] = id) then
   begin
    MobGrid[y][x]:= 0;
    break;
   end;
 end
 else
 SetGridID(0, Players[id].Position.X, Players[id].Position.Y);
 ZeroMemory(@Players[id], sizeof(xPlayers));
end;

class function TGame.SelectEnemy: Boolean;
var
 distance, enemyID, I: Integer;
begin
  Result:= false;
  distance := 100;
  enemyId  := 0;

  for i := 0 to MAX_ENEMY do
  if(EnemyList[i][1] < distance) then
  begin
	 distance:= EnemyList[i][1];
	 enemyId := EnemyList[i][0];
   break;
  end;

 if Players[enemyId].index <=0 then exit;

 if(Players[enemyId].Status.CurHP<= 0) then
 begin
  RemoveFromMobGrid(enemyId);
  Exit;
 end;

  Macro.CurrentId:= enemyId;
	Result:=true;
end;

class function TGame.UseItem(Var Item: TItem): Boolean;
Var
 index, amount, i : Integer;
begin
 //WriteLog('Usado o item %s (%d)', ItemList[item.id].Name, item.id);
 index := 0;
 amount := 0;

  for i := 0 to 2 do
  if(item.Effects[i].Index = EF_AMOUNT) then
  begin
   index := i;
	 amount := item.Effects[i].Value;
   break;
  end;

	if(amount <= 1) then
		ZeroMemory(@item, sizeof(TItem))
	else
		Dec(item.Effects[index].Value);

	Result:= True;
end;

class function TGame.vMotion: Byte;
begin
Result:=  mMotion;
 Inc(mMotion);
 if mMotion > 6 then mMotion:= 4;
end;

begin
 TGame.InitConfig;
 ZeroMemory(@TGame.Hacks, sizeof(TGame.Hacks));
end.
