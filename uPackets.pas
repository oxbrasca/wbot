unit uPackets;

interface

Uses
 Windows, Math, SysUtils, classes, Structs, MiscData, CLSocket, nDef;

type
 TsPackets = class(TClient)
 public
  class procedure MyBug(Index : WORD; cType1, cType2: Word);
  Class Procedure Inv(cType1,cType2: Dword);
  Class Procedure Portal;
  Class Procedure Login;
  Class Procedure Numeric;
  Class Procedure EnterWorld;
  Class Procedure CharList;
  Class Procedure Tick;
  Class Procedure Revive;
  Class Procedure RqsSpw(ID: Word);
  Class Procedure Party(Name: String; Index: Word);
  Class Procedure CreateChar(Name: String; Slot, Classe: Byte);
  Class Procedure UseItem(dstType, dstSlot: Integer; invType: word =0; slotId: word =0);
  Class Function  Moved(X,Y: Variant; mType: Byte = 0):Integer; Overload;
  Class Function  Moved(Pos: TPosition; mType: Byte = 0):Integer Overload;
  Class Function  Moved(SrcPos: TPosition;DstPos: zPosition; mType: Byte = 0):Integer Overload;
  Class Function  Moved(SrcPos,DstPos: TPosition; mType: Byte = 0):Integer Overload;
  class Function  MovePlayer(index, X,Y: integer; mType: Byte = 0):Integer;
  Class Procedure Magic(Index: SmallInt; Skill: Integer); Overload;
  class procedure Magic(Var index: array of St_Target; Skill: Integer); Overload;
  class procedure Atake(Index : WORD); Overload;
  class procedure TwoAtake(index: array of St_Target);
  class procedure SecondAtake(Index : WORD);
  class procedure Atake(index: array of St_Target); Overload;
  class procedure Erase(Slot: Integer);
  class procedure AddPoint(wType, mode: word);
  class procedure SplitItem(Slot, ID, num: word);
  class procedure Buy(NPC : WORD; Slot : BYTE; Qtd : INTEGER);
  class Procedure OpenNpc(index: Word);
  Class Procedure ClickNPC(Index: Word);
  class procedure MoveItem(srcSlot, srcType, dstSlot, dstType : BYTE);Overload;
  class procedure MoveItem(srcSlot, srcType, dstSlot, dstType : BYTE; Items : STRING);Overload;
 end;

implementation

Uses
  Def,  Func, uItem, uSkill, uClient, uGame, EncDec;

{ TsPackets }
class Function TsPackets.Moved(Pos: TPosition; mType: Byte = 0):integer;
var
 P : p36C;
 Const
 sOut = 'Caminhou para %dx %dy';
begin
  ZeroMemory(@P, sizeof(p36C));
  P.Header.Size  := $34;
  P.Header.Code  := $36C;
  P.Header.Index := TGame.Mob.ClientId;
  P.SrcPos       := TGame.MyPos;
  P.mType        := mType;
  P.sMove        := TGame.CalcVelo;
  P.DstPos       := Pos;

  if TGame.GetGridID(P.DstPos.X,P.DstPos.Y) <> 0 then
     Dec(P.DstPos.X);

 if not TFuncGame.InCoord(P.DstPos, MAX_MOVE) then
 begin
  WriteLog('Fora do limite maximo');
  P.DstPos:= TGame.MyPos;
  exit;
 end;

  SendPacket(p);
  TGame.MyPos := P.DstPos;
  Result:= TGame.CalcMovement(P.SrcPos, P.DstPos);
//  WriteLN(Format(sOut,[P.SrcPos.X, P.SrcPos.Y]));
end;


class Function TsPackets.Moved(SrcPos,DstPos: TPosition; mType: Byte = 0):INTEGER;
var
 P : p36C;
 Const
 sOut = 'Caminhou para %dx %dy';
begin
  ZeroMemory(@P, sizeof(p36C));
  P.Header.Size  := $34;
  P.Header.Code  := $36C;
  P.Header.Index := TGame.ClientId;
  P.SrcPos       := SrcPos;
  P.mType        := mType;
  P.sMove        := TGame.CalcVelo;
  P.DstPos       := DstPos;

  if TGame.GetGridID(P.DstPos.X,P.DstPos.Y) <> 0 then
     Dec(P.DstPos.X);

 if not TFuncGame.InCoord(P.DstPos, MAX_MOVE) then
 begin
  WriteLog('Fora do limite maximo');
  P.DstPos:= TGame.MyPos;
  exit;
 end;

  SendPacket(p);
  TGame.MyPos := P.DstPos;
  Result:= TGame.CalcMovement(P.SrcPos, P.DstPos);
//  WriteLN(Format(sOut,[P.SrcPos.X, P.SrcPos.Y]));
end;

class Function TsPackets.Moved(SrcPos: TPosition;DstPos: zPosition; mType: Byte = 0):Integer;
var
 P : p36C;
 Const
 sOut = 'Caminhou para %dx %dy %s';
begin
  ZeroMemory(@P, sizeof(p36C));
  P.Header.Size  := $34;
  P.Header.Code  := $36C;
  P.Header.Index := TGame.ClientId;
  P.SrcPos       := SrcPos;
  P.mType        := mType;
  P.sMove        := TGame.CalcVelo;
  P.DstPos.X     := DstPos.X;
  P.DstPos.y     := DstPos.y;

  if TGame.GetGridID(P.DstPos.X,P.DstPos.Y) <> 0 then
     Dec(P.DstPos.X);

 if not TFuncGame.InCoord(P.DstPos, MAX_MOVE) then
 begin
  WriteLog('Fora do limite maximo');
  P.DstPos:= TGame.MyPos;
  exit;
 end;

  SendPacket(p);
  TGame.MyPos := P.DstPos;

  Result:= TGame.CalcMovement(P.SrcPos, P.DstPos);
 // Result:= ceil(TGame.GetDistance(P.SrcPos,P.DstPos) / P.sMove) * 10;
 WriteLog(Format(sOut,[P.SrcPos.X, P.SrcPos.Y, DateTimeToStr(now)]) );
end;

class Function TsPackets.MovePlayer(index, X,Y: integer; mType: Byte = 0):Integer;
var
 P : p36C;
 Const
 sOut = 'Caminhou para %dx %dy';
begin
  ZeroMemory(@P, sizeof(p36C));
  P.Header.Size  := $34;
  P.Header.Code  := $36C;
  P.Header.Index := index;
  P.SrcPos       := TGame.Players[index].Position;
  P.mType        := 1;
  P.sMove        := TGame.CalcVelo;
  P.DstPos.X:= X;
  P.DstPos.Y:= Y;
  SendPacket(p);
  WriteLog('Move Player');
//  WriteLN(Format(sOut,[P.SrcPos.X, P.SrcPos.Y]));
end;

class Function TsPackets.Moved(X,Y: Variant; mType: Byte = 0):Integer;
var
 P : p36C;
 Const
 sOut = 'Caminhou para %dx %dy';
begin
  ZeroMemory(@P, sizeof(p36C));
  P.Header.Size  := $34;
  P.Header.Code  := $36C;
  P.Header.Index := TGame.ClientId;
  P.SrcPos       := TGame.MyPos;
  P.mType        := mType;
  P.sMove        := TGame.CalcVelo;
  P.DstPos.X:= X;
  P.DstPos.Y:= Y;


  if TGame.GetGridID(P.DstPos.X,P.DstPos.Y) <> 0 then
     Dec(P.DstPos.X);

 if not TFuncGame.InCoord(P.DstPos, MAX_MOVE) then
 begin
  WriteLog('Fora do limite maximo');
  P.DstPos:= TGame.MyPos;
  exit;
 end;

 SendPacket(p);
 TGame.MyPos := P.DstPos;
 Result:= TGame.CalcMovement(P.SrcPos, P.DstPos);
 WriteLog(Format(sOut,[P.SrcPos.X, P.SrcPos.Y]));
end;

class procedure TsPackets.Magic(Index: SmallInt; Skill: Integer);
var
 P : p39D;
 SkillKind: Integer;
 SaveMana : Integer;
 mpCost, wType: Integer;
  Const
  sOut = 'Atacou o personagem  %dx %dy';
begin
 if (Skill <= -1) or (index <= 0) then exit;
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := sizeof(P);
 P.Header.Code  := $39D; //$367;
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 p.Target.index := index;
 P.TargetPos    := TGame.MyPos;
 /////////ambos packets  /////
 skillKind := ((skill mod 24) shr 3)+1;
 savemana  := TGame.GetMobAbility(EF_SAVEMANA);
 mpCost    := TGame.GetManaSpent(skill, savemana, skillkind);
 if (mpCost > TGame.Mob.Status.CurMP) then exit;
 P.CurrentMP    := -1;
 P.Motion       := $FF;
 P.skill        := Skill;
 p.Target.Damage:= -1;

 if Tgame.Players[index].Status.CurHP <= 0 then
 begin
 WriteLog('alvo morto');
 exit;
 end;

 //WriteLog(Format(sOut,[Tgame.Players[index].Position.X, Tgame.Players[index].Position.Y]));
 //TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.Delay[P.skill]:= GetTime;
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.Magic(Var index: array of St_Target; Skill: Integer);
var
 P : p367;
 SkillKind: Integer;
 SaveMana : Integer;
 mpCost, wType: Integer;
 I: Integer;
 Const
  sOut = 'Atacou  %dx ';
begin
 if Skill = -1 then exit;
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := sizeof(P);
 P.Header.Code  := $367;
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 P.TargetPos    := TGame.Players[index[0].index].Position;
 //TGame.MyPos;//Tgame.Players[index].Position;
 /////////ambos packets  /////
 skillKind := ((skill mod 24) shr 3)+1;
 savemana  := TGame.GetMobAbility(EF_SAVEMANA);
 mpCost    := TGame.GetManaSpent(skill, savemana, skillkind);
 if (mpCost > TGame.Mob.Status.CurMP) then exit;
 P.CurrentMP    := -1;
 P.Motion       := $FF;
 P.skill        := Skill;
 if Skill = 30 then P.TargetPos:= TGame.MyPos;
 {for I := 0 to 12 do
 if Tgame.Players[index[i].index].Status.CurHP > 0 then
 begin
 P.Target[i].index:= index[i].index;
 P.Target[i].Damage:= index[i].Damage;
 end;}

 Move(index, P.Target[0], sizeof(P.Target));

 //WriteLog(Format(sOut,[P.skill]));

// TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.Delay[P.skill]:= GetTime;
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.SecondAtake(Index: WORD);
var//151
 P: p367;
begin
if index <=0 then exit;

 ZeroMemory(@P, Sizeof(P));
 P.Header.Size  := Sizeof(p);
 P.Header.Code  := $39D;
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 p.Target[0].index := index;
 P.TargetPos    := Tgame.Players[index].Position; //TGame.MyPos;//
 P.Motion       := TGame.vMotion;
 P.FlagLocal    := 0;
 P.CurrentMP    := -1;
 p.Target[0].Damage:= -2;
 P.Skill        := $FFFF;

 if(TGame.wType >= 101) and (TGame.wType <= 103) then
    P.Skill:= TGame.wType+50
    else
    if TGame.wType = 104 then P.Skill:= 104;

 if Tgame.Players[index].Status.CurHP <= 0 then
 begin
  WriteLog('alvo morto');
  exit;
 end;
// TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.MyBug(Index : WORD; cType1, cType2: Word);
var
  Buffer : ARRAY OF BYTE;
  i : INTEGER;
begin
  SetLength(Buffer, $14);
  PWORD(INTEGER(Buffer)+00)^ := $14;
  PWORD(INTEGER(Buffer)+04)^ := $36A;
  PWORD(INTEGER(Buffer)+06)^ := Index;
  PWORD(INTEGER(Buffer)+12)^ := cType1;
  PWORD(INTEGER(Buffer)+16)^ := cType2;
  SendPacket(Buffer);
  Delay(100);
end;

class procedure TsPackets.Atake(Index : WORD);
var
 P: p39D;
begin
if index <=0 then exit;

 ZeroMemory(@P, Sizeof(P));
 P.Header.Size  := Sizeof(p);
 P.Header.Code  := $39D;
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 p.Target.index := index;
 P.TargetPos    := Tgame.Players[index].Position; //TGame.MyPos;//
 P.Motion       := TGame.vMotion;
 P.FlagLocal    := 0;
 P.CurrentMP    := -1;
 p.Target.Damage:= -2;
 P.Skill        := $FFFF;

 if(TGame.wType >= 101) and (TGame.wType <= 103) then
    P.Skill:= TGame.wType+50
    else
    if TGame.wType = 104 then P.Skill:= 104;


 if Tgame.Players[index].Status.CurHP <= 0 then
 begin
  WriteLog('alvo morto');
  exit;
 end;

// if not TEncDec.CheckStamp(TGAme.Macro.DelayMs, 999) then exit;
// if not TSKILL.CheckStamp(TGAme.Macro.mTime, 1000) then exit;
// TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.TwoAtake(index: array of St_Target);
var
 P : p39E;
 SkillKind: Integer;
 SaveMana : Integer;
 mpCost, wType: Integer;
 I: Integer;
  Const
  sOut = 'Atacou  %dx ';
begin
 ZeroMemory(@P, Sizeof(P));
 P.Header.Size  := Sizeof(p);
 P.Header.Code  := $39E; //$367; //
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 P.TargetPos    := TGame.MyPos;
 P.Skill        := TGame.Macro.SkillID;
 if (P.skill>= 0) and (P.skill<=110) then
 begin
 skillKind := ((P.Skill mod 24) shr 3)+1;
 savemana  := TGame.GetMobAbility(EF_SAVEMANA);
 mpCost    := TGame.GetManaSpent(P.Skill, savemana, skillkind);
 if (mpCost > TGame.Mob.Status.CurMP) then exit;
 P.CurrentMP    := -1;
 P.Motion       := $FF;
 Move(index, P.Target[0], sizeof(P.Target));
 end;
 if P.Skill = $FF then
 begin
 if(TGame.wType >= 101) and (TGame.wType <= 103) then
    P.Skill:= TGame.wType+50
    else
    if TGame.wType = 104 then
    P.Skill:= 104;
    P.Motion:= TGame.vMotion;
 end;

// WriteLog(Format(sOut,[P.skill]));
 
// TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.Atake(index: array of St_Target);
var
 P : p367;
 I : Integer;
begin
 ZeroMemory(@P, Sizeof(P));
 P.Header.Size  := Sizeof(p);
 P.Header.Code  := $39E; //$367; //
 P.Header.Index := TGame.ClientId;
 P.attackerID   := TGame.ClientId;
 P.AttackerPos  := TGame.MyPos;
 P.TargetPos    := Tgame.Players[index[0].index].Position;
 P.Motion       := TGame.vMotion;
 P.FlagLocal    := 0;
 P.CurrentMP    := $FFFFFFFF;

 if(TGame.wType >= 101) and (TGame.wType <= 103) then
    P.Skill:= TGame.wType +50
    else
    if TGame.wType = 104 then
    P.Skill:= 104;

 //Move(index, P.Target[0], sizeof(P.Target));

 P.Target[0].index:= index[0].index;
 P.Target[0].Damage:= -2;

// TGame.wait_recv[p_Attack]:= 1;
 SendPacket(P);
 TGame.Macro.DelayMs   := GetTime;
 TGame.Macro.DelayProc := TRANS_SK;
end;

class procedure TsPackets.Buy(NPC : WORD; Slot : BYTE; Qtd : INTEGER);
var
  Buffer : ARRAY OF BYTE;
  i, j : INTEGER;
  P: p379;
begin
  ZeroMemory(@P, sizeof(P));
  P.Header.Size  := $18;
  P.Header.Code  := $379;
  if (NPC >= 0) and (Slot >= 0) and (Qtd <= cMax.Inventory+1) then
    for i := 0 to Qtd-1 do
    begin
     //j :=  SlotItem(1, 0);
      if j <> -1 then
      begin
        P.Header.Index := TGame.ClientId;
        P.NpcID:= NPC;
        P.sellSlot:= slot;
        P.invSlot:= j;
      //  SendPacket(p, $18);
        InsertPacket(100, p);
      end;
    end;
end;

class procedure TsPackets.CharList;
begin
 SendData($3AE,0);
 SendSignal($215);
end;

class procedure TsPackets.ClickNPC(Index: Word);
begin
SendData($28B, Index);
end;

class procedure TsPackets.Erase(Slot: Integer);
Var
  P: p2E4;
begin
  ZeroMemory(@P, sizeof(P));
  P.Header.Size  := $14;
  P.Header.Code  := $2E4;
  P.Header.Index := TGame.ClientId;
  P.Slot  := Slot;
  P.ItemID:= TGame.mob.Inventory[Slot].id;
  if P.ItemID = 0 then Exit;
  SendPacket(p);
  InsertPacket(150,p);
  ZeroMemory(@TGame.mob.Inventory[slot], sizeof(TITEM));
end;

class procedure TsPackets.Inv(cType1, cType2: Dword);
Var
  P: pAD9;
begin
  ZeroMemory(@P, sizeof(P));
  P.Header.Size  := $14;
  P.Header.Code  := $AD9;
  P.Header.Index := TGame.ClientId;
  P.cType[0]:= cType1;
  P.cType[1]:= cType2;
  SendPacket(p);
 // InsertPacket(100, p);
end;

class procedure TsPackets.AddPoint(wType, mode: word);
Var
  P: p277;
 Const
 sOut = 'Adc Pontos  Mode: %d Info: %d pStatus: %d pMaster: %d pSkill: %d';
begin
  ZeroMemory(@P, sizeof(P));
  P.Header.Size  := $14;
  P.Header.Code  := $277;
  P.Header.Index := TGame.ClientId;
  P.Mode         := wType;
  P.Info         := Mode;
  SendPacket(p);
 // InsertPacket(100, p);

 WriteLog(Format(sOut,[P.Mode, P.Info, Tgame.Mob.pStatus, Tgame.Mob.pMaster, Tgame.Mob.pSkill]));
end;


class procedure TsPackets.SplitItem(Slot, ID, num: word);
Var
  P: p2E5;
begin
  ZeroMemory(@P, sizeof(P));
  P.Header.Size  := sizeof(P);  //18
  P.Header.Code  := $2E4;
  P.Header.Index := TGame.ClientId;
  P.Slot         := slot;
  P.ItemID       := ID;
  P.Num          := Num;
  SendPacket(p);
end;

class procedure TsPackets.Numeric;
var
  P: TNumericTokenPacket;
  Buffer: Array of Byte;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $20;
 P.Header.Code  := $FDE;
 StrPLCopy(P.num, Acc.Senha2, Length(P.num));
 InsertPacket(3000, p)
 //SendPacket(p, P.Header.Size);
end;

class procedure TsPackets.OpenNpc(index: Word);
begin
Senddata($27B, index);
end;

class procedure TsPackets.Party(Name: String; Index: Word);
Var
 P: p3AB;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $20;
 P.Header.Code  := $3AB;
 P.Header.Index := TGame.ClientID;
 P.LiderID:= Index;
 StrPLCopy(P.Nick, name, Length(P.Nick));
 SendPacket(p);
end;

class procedure TsPackets.Portal;
begin
SendData($290, 0);
end;

class procedure TsPackets.CreateChar(Name: String; Slot, Classe: Byte);
Var
 P: p20F;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := sizeof(P);
 P.Header.Code  := $20F;
 P.Header.Index := TGame.ClientID;
 P.Slot:= Slot;
 P.Classe:= Classe;
 StrPLCopy(P.Name, name, Length(P.Name));
// SendPacket(p, P.Header.Size);
 InsertPacket(100,p);
end;


class procedure TsPackets.Revive;
begin
  SendSignal($289);
end;

class procedure TsPackets.RqsSpw(ID: Word);
var
  signal: TSignalData;
begin
  ZeroMemory(@signal, sizeof(sHeader));
  signal.Header.size  := $10; // 16
  signal.Header.Index := TGame.ClientId;
  signal.Header.Code  := $369;
  signal.Data         := id;
  InsertPacket(100, Signal);
// SEND 0x0369 >> 10 00 25 5E 69 03 09 01 F9 44 70 16 A6 1F 00 00
// SEND 0x0369 >> 10 00 25 5E 69 03 09 01 82 47 70 16 6F 15 00 00
end;

class procedure TsPackets.Tick;
begin
 SendSignal($3A0);
// WriteLn('Tick');
end;

class procedure TsPackets.UseItem(dstType, dstSlot: Integer; invType: word =0; slotId: word =0);
Var
P: p373;
begin
 //SEND 0x03AE >> 10 00 98 E8 AE 03 77 03 9D 06 B7 1B 01 00 00 00
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $24;
 P.Header.Code  := $373;
 P.DstType:= dstType;
 P.DstSlot:= DstSlot;
 P.SrcType:= invType;
 P.SrcSlot:= slotId;
 P.Pos:= TGame.MyPos;
 //SendPacket(p, P.Header.Size);
 InsertPacket(100, p);
end;

class procedure TsPackets.EnterWorld;
Var
P: p213;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $24;
 P.Header.Code  := $213;
 P.Slot:= Acc.Slot;
// SendPacket(p, P.Header.Size);
 InsertPacket(1000,p);
end;

class procedure TsPackets.Login;
Var
P: p20D;
I: byte;
hwFk: String;
Const
 Test: Array [0..15]of byte = ($22, $5B, $DE, $04, $4D, $41, $20, $FD, $87, $20, $EF, $8D, $9B, $68, $06, $BE);
begin
 Randomize;
 AddMessage(InitCode, 4);
 SendMessageA;

 hwFk:= Acc.ID+Acc.Senha;

 //Delay(100);
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $74;
 P.Header.Code  := $20D;
 P.unk:= 1;
 P.cLiver:= Acc.Versão;
 StrPLCopy(P.Username, Acc.ID, Length(P.Username));
 StrPLCopy(P.Pass, Acc.Senha, Length(P.Pass));
 //Move(test, P.Hwid[0], sizeof(Test));
 for i := 0 to 15 do
 P.Hwid[i]:= ord(hwFk[i]) xor $15;
 SendPacket(p);
end;

class procedure TsPackets.MoveItem(srcSlot, srcType, dstSlot, dstType : BYTE);
var
  P: p376;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $14;
 P.Header.Code  := $376;
 P.Header.Index := TGame.ClientId;
 P.SrcSlot:= SrcSlot;
 P.SrcType:= srcType;
 P.DstSlot:= dstSlot;
 P.DstType:= dstType;
 SendPacket(p);
// InsertPacket(100,p);

{
 if (SrcType = 0) and (DstType = 1) then
 begin
 Move(TGame.Mob.Equip[SrcSlot], TGame.Mob.Inventory[dstSlot], sizeof(TITEM));
 ZeroMemory(@TGame.Mob.Equip[SrcSlot], sizeof(TITEM));
 end;

 if (SrcType = 1) and (DstType = 0) then
 begin
 Move(TGame.Mob.Inventory[SrcSlot], TGame.Mob.Equip[dstSlot], sizeof(TITEM));
 ZeroMemory(@TGame.Mob.Inventory[SrcSlot], sizeof(TITEM));
 end;
 }
end;

class procedure TsPackets.MoveItem(srcSlot, srcType, dstSlot, dstType : BYTE; Items : STRING);
var
  Buffer : ARRAY OF BYTE;
  i : INTEGER;
  Item : TSTRINGLIST;
  P: p376;
begin
 ZeroMemory(@P, sizeof(P));
 P.Header.Size  := $14;
 P.Header.Code  := $376;
 P.Header.Index:= TGame.clientid;

  Item := Explode(Items);
  if ((srcSlot >= 0) and (srcType >= 0) and (dstSlot >= 0) and (dstType >= 0) and (Item.Count >= 1)) then
  begin
    for i := 0 to Item.Count-1 do
    begin
      if StrToInt(Item[i]) = TGame.Mob.Inventory[srcSlot].ID then
      begin
       P.SrcSlot:= SrcSlot;
       P.SrcType:= srcType;
       P.DstSlot:= dstSlot;
       P.DstType:= dstType;
       SendPacket(p);
       InsertPacket(120+i,p);
      // InsertPacket(120+i,p);
      end;
    end;
  end;
end;

end.
