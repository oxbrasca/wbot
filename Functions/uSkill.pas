unit uSkill;

interface

Uses
 Windows, sysutils,  Classes, DateUtils,
 nDef,
  Structs, MiscData, PlayerData,
  def, uCLient;

type TSkill = class(TGame)
Public
 Class Function FilterEnemy(id: word):Boolean;
 Class Function ReadSkillBar: Boolean;
 Class Function Physical:Boolean;
 Class Function Magical: Boolean;
 Class Function AtkArea: Boolean;
 Class Function HTArea: Boolean;
 Class Function AutoBuff: Boolean;
 Class Function Evok:Boolean;
 class Function InstaceEvok(skillnum: word): byte;
 Class Function GetSkills(id: word): Boolean;
 Class Procedure GetMobList;
 class function GetMobAtk:boolean;
 Class Procedure InsertMob(Mobs: String);
 Class Var Targets: array [0..MAX_ENEMY] of St_Target;
 class function CheckStamp(Value, Delay: LongInt): boolean;
end;

implementation

Uses
 uPackets, Func, uGame, EncDec;

class function TSkill.FilterEnemy(id: word): Boolean;
Var
 Pos : TPosition;
 i   : Integer;
 oMob: Boolean;
begin
 Result:= False;
 Pos   := Players[id].Position;
 if (id <= INIT_SPAWN_MOB) or (id >= MAX_SPAWN_MOB) then exit;
 if Players[id].Index <= 0 then exit;
 if (Pos.X<= 0) or (Pos.X>= 4095) or (Pos.Y<= 0) or (Pos.Y>= 4095) then exit;
 if (Players[id].Status.CurHP <= 0) then exit;
 if (Players[id].Status.cDir.Merchant > 0)
 or (Players[id].Status.cDir.Direction > 0) then exit;
 if Hacks.onMob then
 begin
  oMob:= False;
  for i := 0 to Hacks.maxmob do ////
  if Players[id].Face = Hacks.Mobs[i] then
  begin
   oMob:= True;
   break
  end;
 if oMob = false then exit;
 end;
 Result:= True;
end;

class function TSkill.GetSkills(id: word): Boolean;
var
 maxTarget,count, i : Integer;
 target: Array [0..MAX_ENEMY] of st_Target;
begin
  case id  of
 29:begin //cura em grupo FM
     ZeroMemory(@target,sizeof(target));
	   maxTarget := SkillData[id].Maxtarget;
	   count		  := 1;
     target[0].Index := clientId;
     for i := 0 to maxTarget do
     begin
     if(Party[i].ClientID > 0) and (Party[i].ClientID < MAX_PLAYER)then
      begin
				target[count].Index := Party[i].ClientID;
        Inc(Count);
      end;
      if(count >= maxTarget) then break;
     end;
	  TsPackets.Magic(target, Macro.SkillId);
		Result:= true;
    Exit;
    end;
 end;
 result:= False;
end;

class function TSkill.HTArea: Boolean;
Var
 I,z: Integer;
 OneMob: TPosition;
 Max: integer;
 PrimeId, index: word;
 PrimePos: TPOsition;
 Ranger: Byte;
 Targets: array [0..1] of St_Target;
begin
 result:= False;
 if not HaveSkill(78) then Exit;  //lança de ferro
 ZeroMemory(@Targets, sizeof(Targets));
 PrimeId := Macro.CurrentId;//primeiro mob de index valida
 PrimePos:= Players[PrimeId].Position;
 Ranger  := 1;
 for i := 0 to MAX_ENEMY do
  begin
   index:= EnemyList[i][0];
   if (index<= 0) then continue;
   if (Players[index].status.curHP<= 0) then continue;
   if (GetDistance(PrimePos, Players[index].Position) <= Ranger)
   then
   begin
    Targets[i].index := index;
    Targets[i].Damage:= -2
   end;
  if Targets[1].index > 0 then break;
  end;
  if Targets[1].index = 0 then exit;
  TsPackets.Atake(Targets);
  Result:= True;
  exit;
end;

class procedure TSkill.InsertMob(Mobs: String);
var
  i, j : INTEGER;
  Mob : TSTRINGLIST;
begin
if Mobs = '' then exit;
ZeroMemory(@Hacks.Mobs, sizeof(Hacks.Mobs));

 j := 0;
 Mob := Explode(Mobs);
 for i := 0 to Mob.Count-1 do
 if StrToInt(Mob[i]) <> 0 then
 begin
  Hacks.Mobs[j]:= StrToInt(Mob[i]);
  Inc(j);
 end;

 Hacks.maxmob:= j-1;
end;

class function TSkill.InstaceEvok(skillnum: word): byte;
var
 instancevalue, summons: integer;
begin
instancevalue:= SkillData[skillnum].InstanceValue;
 if (instancevalue >= 1) and (instancevalue <= 50) then
 begin
  if (instancevalue = 1) or (instancevalue = 2) then
      summons := Trunc(Mob.Status.sMaster / 30)
  else if (instancevalue = 3) or (instancevalue = 4) or (instancevalue = 5) then
				   summons := Trunc(Mob.Status.sMaster / 40)
  else if (instancevalue =  6) or (instancevalue = 7) then
						summons := Trunc(Mob.Status.sMaster / 80)
  else if (instancevalue  = 8) then summons := 1;
 end;
 Result:= summons;
end;

class function TSkill.AtkArea: Boolean;
Var
 I: Integer;
 Max: integer;
 PrimeId, index: word;
 PrimePos: TPOsition;
 Ranger: Byte;
 Targets: array [0..MAX_ENEMY] of St_Target;
begin
 result:= False;
 ZeroMemory(@Targets, sizeof(Targets));
 Max:= SkillData[Macro.SkillId].Maxtarget;
 PrimeId := Macro.CurrentId;//primeiro mob de index valida
 PrimePos:= Players[PrimeId].Position;
 case Macro.SkillId of
 0:  Ranger:= 3;
 2:  Ranger:= 1; ///perseguição
 7:  Ranger:= 3;
 12: Ranger:= 1;
 16: Ranger:= 3;
 17: Ranger:= 3;
 23: Ranger:= 3;
 26: Ranger:= 3;
 28: Ranger:= 1;
 30: begin
     PrimeId := ClientID;
     PrimePos:= MyPos;
     Ranger  := 5;
     end;
 35: Ranger:= 5;
 39: Ranger:= 7;
 51: Ranger:= 3;
 55: Ranger:= 5;
 86: Ranger:= 4;// de 2 a 4m   RandomRange(2, 4)
 79: Ranger:= 4;
 else
 Ranger:= SkillData[Macro.SkillId].Range;
 end;

 for i := 0 to MAX_ENEMY do
  begin
   index:= EnemyList[i][0];
   if (Players[index].status.curHP<= 0) then continue;
   if (GetDistance(PrimePos, Players[index].Position) <= Ranger)
   then
   begin
    Targets[i].index := index;
    Targets[i].Damage:= -1
   end;
   if Targets[Max-1].index > 0 then break;
  end;
  Result:= True;
  if Max = 2 then
  begin
   TsPackets.TwoAtake(Targets);
   exit;
  end;
  TsPackets.Magic(Targets, Macro.SkillId);
end;

class function TSkill.GetMobAtk:boolean;
Var
 I: Integer;
 PrimeId, index: word;
 PrimePos: TPOsition;
 Ranger: Byte;
 min, max : TPosition;
 posY, posX, mobId: integer;
 distance: integer;
 cDM: shortInt;
begin
 result:= False;

 if Macro.SkillId = $FF then
 cDm:= -2
 else
 cDm:= -1;

 case Macro.SkillId of
 0:  Ranger:= 3;
 2:  Ranger:= 1; ///perseguição
 7:  Ranger:= 3;
 12: Ranger:= 1;
 16: Ranger:= 3;
 17: Ranger:= 3;
 23: Ranger:= 3;
 26: Ranger:= 3;
 28: Ranger:= 1;
 30: Ranger:= 5;//skill de fm
 35: Ranger:= 5;
 39: Ranger:= 7;
 51: Ranger:= 3;
 55: Ranger:= 5;
 86: Ranger:= 4;// de 2 a 4m   RandomRange(2, 4)
 79: Ranger:= 4;
 $FF:Ranger:= DamageRange + Hacks.RangerPhysic;
 else
 Ranger:= SkillData[Macro.SkillId].Range + Hacks.RangerMagic;
 end;

  ClearEnemyList;
  min.X := MyPos.X - Ranger;
  min.Y := MyPos.Y - Ranger;
  max.X := MyPos.X + Ranger;
  max.Y := MyPos.Y + Ranger;

  I:= 0;
  for posY := min.Y to max.Y do
  for posX := min.X to max.X do
  begin
   if not FilterEnemy(mobId) then continue;
   if GetDistance(posX, posy, MyPos.X, MyPos.y) <= Ranger
   then
   begin
    Targets[i].index := index;
    Targets[i].Damage:= cDm;
   end;
   inc(i);
   if I >= MAX_ENEMY then break
  end;

end;

class procedure TSkill.GetMobList;
var
 min, max : TPosition;
 posY, posX, mobId: integer;
 distance: integer;
 Ranger: Word;
begin
if Macro.SkillId <> $FF then
   Ranger:= SkillData[Macro.SkillId].Range + Hacks.RangerMagic
   else
   Ranger:=DamageRange + Hacks.RangerPhysic;

  ClearEnemyList;
  min.X := MyPos.X - Ranger;
  min.Y := MyPos.Y - Ranger;
  max.X := MyPos.X + Ranger;
  max.Y := MyPos.Y + Ranger;

  for posY := min.Y to max.Y do
  for posX := min.X to max.X do
  begin
   mobId:= GetGridID(posx, posy);
   if not FilterEnemy(mobId) then continue;
   distance:= GetDistance(posX, posy, MyPos.X, MyPos.y);
	 if distance > Ranger then continue;
   if not AddEnemyList(mobId, distance) then break;
  end;
end;

class function TSkill.Magical: Boolean;
var
 i,Ranger: integer;
 Max: byte;
begin
 Result:= false;
 if not Live then Exit;
// if GetCity <> $FF then Exit;
 if GetNextSkill = $FF then Exit;
 Max:= SkillData[Macro.SkillId].Maxtarget;

 if CurrentIsValid and (Max = 1) then
 begin
  TsPackets.Magic(Macro.CurrentId, Macro.SkillId);
  Result:= true;
  exit;
 end;

 GetMobList;

 if SelectEnemy then
 begin
   Result:= true;
   if Max > 1 then AtkArea;
   if Max = 1 then TsPackets.Magic(Macro.CurrentId, Macro.SkillId);
 end;
 Result:= True;
end;

class function TSkill.Physical: Boolean;
begin
 Result:= False;
 if not Live then Exit;
// if GetCity <> $FF then Exit;

 Macro.SkillId:= $FF;
 if CurrentIsValid then
 begin
  TsPackets.SecondAtake(Macro.CurrentId);
  Result:= true;
  exit;
 end;

 GetMobList;
 if SelectEnemy then TsPackets.Atake(Macro.CurrentId); //atk1

 Result:= true;
end;

class function TSkill.ReadSkillBar: Boolean;
begin

end;

class function TSkill.AutoBuff: Boolean;
Var
 classId, affectId, skillId, t, affectSlot, I: Integer;
 delay: longint;
begin
 Result:= False;
// if not TEncDec.CheckStamp(Macro.DelayMs, 1000) then exit;
// if not CheckStamp(Macro.mTime, 1100) then exit;

 classId:= Mob.ClassInfo;
 for i := 0 to 6 do
 begin
  affectId := g_pBuffsId[classId][i][1];
  skillId  := g_pBuffsId[classId][i][0];
 if not HaveSkill(skillId) then continue;// não possui a skill

  if(affectId = 16) then
  begin
  t := i - 1;
  if(t = Transform) then continue;  //
  end;

   affectSlot := GetAffectSlot(Affect, affectId);
   if(affectSlot <> -1) then//  WriteLn('quer dizer que já está buffado');
      continue;
  delay := Macro.Delay[skillId];
  if(delay <> 0) then
  if(TEncDec.GetTime - delay <= (SkillData[skillId].Delay) * CLOCKS_PER_SEC) then
		 continue;

  TsPackets.Magic(clientId, skillId);
  WriteLog('Utilizou o buff: '+ItemList[skillId + 5000].Name);
  Result:= True;
  Exit;
 end;
 Result:= False;
end;

class function TSkill.CheckStamp(Value, Delay: LongInt): boolean;
begin
 Result:= False;
 if (Value <> 0) then// transição de atk pra atk
 if (TEncDec.gettime - Value) < Delay then exit;
 result:= True;
end;

class function TSkill.Evok: Boolean;
Var
 I: Integer;
 delay: longint;
begin
 Result:= False;
//  if not TEncDec.CheckStamp(Macro.DelayMs, 1000) then  exit;

 if Mob.ClassInfo <> BM then Exit;
 if not HaveSkill(SetEvok) then Exit;

 for I := 0 to 11 do    //teste
 if (Evoks[i] = 0) Then break;
 if I >= InstaceEvok(SetEvok) then  exit;

 delay:= Macro.Delay[SetEvok];
 if(delay <> 0) then
 if(TEncDec.GetTime - delay <= (SkillData[SetEvok].Delay) * CLOCKS_PER_SEC) then exit;
 TsPackets.Magic(clientId, SetEvok);
 WriteLog('Utilizou o buff: '+ItemList[SetEvok + 5000].Name);
 Result:= True;
end;

end.
