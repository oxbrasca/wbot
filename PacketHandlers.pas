unit PacketHandlers;

interface

Uses
  Windows, SysUtils, StrUtils, Classes, Structs, uClient;

{$REGION 'Classes'}
type
  TPacketHandlers = Class(TGame)
  public
  Class Procedure SvMsg          (Buffer: array of BYTE);
  Class Procedure Buffs          (Buffer: ARRAY OF BYTE);    //eu acho....
  Class Procedure PutItem        (Buffer: ARRAY OF BYTE);
  class procedure MoveItem       (Buffer: array of BYTE);
  Class Procedure AttInv         (Buffer: ARRAY OF BYTE);
  Class Procedure UpdateScore    (Buffer: ARRAY OF BYTE);
  class procedure UPDATEETC      (Buffer: array of BYTE);
  class Procedure SendToWorld    (Buffer: ARRAY OF BYTE);
  class Procedure SendToCharList (Buffer: ARRAY OF BYTE);
  class Procedure Spaw           (Buffer: ARRAY OF BYTE);
  class Procedure DeleteSpaw     (Buffer: ARRAY OF BYTE);
  Class Procedure MobDead        (Buffer: ARRAY OF BYTE);
  Class Procedure ReqParty       (Buffer: ARRAY OF BYTE);
  Class Procedure EnterParty     (Buffer: ARRAY OF BYTE);
  Class Procedure ExitParty      (Buffer: ARRAY OF BYTE);
  Class Procedure PartyEvok      (Buffer: ARRAY OF BYTE);
  class Procedure Numeric        (Buffer: ARRAY OF BYTE);
  class Procedure MovementPacket (Buffer: ARRAY OF BYTE);
  Class Procedure RefreshHPMP    (Buffer: ARRAY OF BYTE);
  Class Procedure Damage         (Buffer: ARRAY OF BYTE);
end;
{$ENDREGION}

implementation

Uses
 uPackets, CLsocket, EncDec, PlayerData, MiscData, uItem, PathFinding, uSkill, uMacros,
 Func,Def, nDef, Main;

{$REGION 'Damage'}
class procedure TPacketHandlers.Buffs(Buffer: array of BYTE);
var
  P: p3B9 absolute Buffer;
begin
if P.Header.Index = ClientID then
 Move(P.Affect, Affect[0], sizeof(P.Affect));
end;

class procedure TPacketHandlers.Damage(Buffer: array of BYTE);
var
  P: p367 absolute Buffer;
begin
 if(P.attackerID = clientId) then
 begin
  //wait_recv[p_Attack]:= 0; //ta falhando recv
  Mob.Status.curMP:= P.CurrentMP;
  exit;
 end;

 if Players[P.attackerID].Status.cDir.Merchant = 0 then
 begin
  Players[P.attackerID].Index    := P.attackerID;
  Players[P.attackerID].Position := P.AttackerPos;
 end;
end;
{$ENDREGION}

{$REGION 'Spaw'}
class procedure TPacketHandlers.MobDead(Buffer: array of BYTE);
var
  P: p338 absolute Buffer;
begin
 if P.killed = ClientID then
 begin
  Mob.Status.CurHP:= 0;
  WriteLog('no ceu tem pão?');
  TsPackets.Revive;//////usar algo pra voltar
  if hacks.pDead_Route then GuideToMove(BAD.mCoords);
  if hacks.pDead_Perga then TDROP.UseItem(776);
  TMacros.SetMacro;
 end;
 if P.killed = Macro.CurrentID then Macro.CurrentId:= -1;
 RemoveFromMobGrid(p.killed);
end;

class procedure TPacketHandlers.DeleteSpaw(Buffer: array of BYTE);
var
  P: p165 absolute Buffer;
  index: Integer;
begin  //1 morre  0 sai do range// 3 se teleporta
  index:= P.Header.Index;
  if(index = Macro.CurrentId) then Macro.CurrentId:= -1;
  RemoveFromMobGrid(index);
end;

class Procedure TPacketHandlers.Spaw(Buffer: array of Byte);
var
   P: TSendCreateMobPacket absolute Buffer;
   I: Integer;
   Index: Integer;
begin
 index:= P.ClientId;
 Players[index].Status   := P.Status;
 Players[index].Position := P.Position;
 Players[index].Face     := P.ItemEff[0];
 Players[index].index    := index;


 if P.ItemEff[0] = 231 then //231; Grande_Carbunkle;
  begin
   NPCs[0].Index   := Index;
   NPCs[0].Face    := P.ItemEff[0];
   NPCs[0].Position:= P.Position;
  // WriteLog('Grande_Carbunkle');
  end;

  if P.ItemEff[0] = TMacros.NPCQuest then //231; Grande_Carbunkle;
  begin
   NPCs[1].Index   := Index;
   NPCs[1].Face    := P.ItemEff[0];
   NPCs[1].Position:= P.Position;
   WriteLog('NPC Quest');
  end;


  {if (P.Status.cDir.Merchant > 0) and (Index >1000) then
  for I := 0 to 10 do
  if NPCs[i].Index = 0 then
  begin
   NPCs[i].Index:= Index;
   NPCs[i].Face:= P.ItemEff[0];
   NPCs[i].Position:= P.Position;
  end; }

// if Index = ClientId then
// for I := 0 to 31 do
// begin
// Players[index].Affect[i].Index := P.Affect[i].Index;
// Players[index].Affect[i].Time  := P.Affect[i].Time;
// end;

 SetGridID(index, P.Position.X, P.Position.Y);
end;

class procedure TPacketHandlers.SvMsg(Buffer: array of BYTE);
var
 P: TClientMessagePacket absolute Buffer;
begin
 WriteLog(P.Msg);
end;
{$ENDREGION}

{$REGION 'MovementPacket'}
class Procedure TPacketHandlers.MovementPacket(Buffer: array of Byte);
var
  P: p36C absolute Buffer;
  id: Integer;
begin
 id:= P.Header.Index;
 if id = ClientId then
 begin
  MyPos:= P.DstPos;
  Macro.CurrentId:= -1;
  WriteLog('mov');
  //TsPackets.Moved(P.DstPos);
  if(P.mType = 1) then
  begin
  Macro.CurrentId:= -1;
  TsPackets.Moved(P.DstPos);
  WriteLog('Você foi teleportado pelo servidor!');
  end;
 end
 else
 begin
  Players[id].Position:= P.DstPos;
  SetGridID(0,  P.SrcPos.X, P.SrcPos.Y);
  SetGridID(id, P.DstPos.X, P.DstPos.Y);
 end;
end;
{$ENDREGION}

{$REGION 'Item'}
class procedure TPacketHandlers.MoveItem(Buffer: array of BYTE);
var
 P: p376  absolute Buffer;
 aux:TITEM;
begin
 if (P.SrcType = 0) and (P.DstType = 1) then //equip pra inventario
 begin
  aux:= TGame.Mob.Inventory[P.dstSlot];//item inv
			  TGame.Mob.Inventory[P.dstSlot]:= TGame.Mob.Equip[P.SrcSlot];
		   	TGame.Mob.Equip[P.SrcSlot]:= aux;
 end;

 if (P.SrcType = 1) and (P.DstType = 0) then //Inventario pra equip
 begin
  aux:= TGame.Mob.Equip[P.dstSlot];///item equip
			  TGame.Mob.Equip[P.dstSlot]:= TGame.Mob.Inventory[P.SrcSlot];
		   	TGame.Mob.Inventory[P.SrcSlot]:= aux;
 end;
 //falta do bau  fds

 if (P.DstType = 0 ) and (P.DstSlot = 6)
 then
 begin
 DamageRange:= GetMobAbility(EF_RANGE);
 wType      := TGame.GetItemAbility(TGame.Mob.Equip[6], EF_WTYPE);
 end;

end;

class procedure TPacketHandlers.AttInv(Buffer: array of BYTE);
var
 P: p185 absolute Buffer;
begin
 Move(P.item, Mob.Inventory[0], sizeof(TGame.Mob.Inventory));
end;

class procedure TPacketHandlers.PutItem(Buffer: array of BYTE);
var
 P: p182 absolute Buffer;
begin
 case P.invType of
 EQUIP_TYPE:begin//EQUIP_TYPE  = 0;
             Mob.Equip[P.invSlot]:= P.itemData;
             if P.itemData.id > 0 then //
              TDrop.InsertEquip(P.invSlot);
            end;
 INV_TYPE:  begin//INV_TYPE = 1;
             Mob.Inventory[P.invSlot]:= P.itemData;
             if P.itemData.id > 0 then //
             TDrop.Insert(P.invSlot);
            end;
 STORAGE_TYPE:TGame.STORAGE[P.invSlot]:= P.itemData;//STORAGE_TYPE = 2;
 end;
// WriteLn(P.invType);
// WriteLn(P.invSlot);
// WriteLn(P.itemData.id);
 WriteLog(ItemList[P.itemData.id].Name);
end;
{$ENDREGION}

{$REGION 'HP/MP'}
class procedure TPacketHandlers.RefreshHPMP(Buffer: array of BYTE);
var
   P: p181 absolute Buffer;
 Const
  Status: String = 'HP: %d MP: %d';
begin
 if P.Header.Index = ClientId then
 begin
  Mob.Status.CurHP := P.CurHP;
  Mob.Status.CurMP := P.CurMP;
  Mob.Status.MaxHP := P.MaxHP;
  Mob.Status.MaxMP := P.MaxMP;
  BAD.StatusHPMP.Caption:=Format(Status,[P.CurHP,P.CurMP]);
 end
{ else
 begin
  Players[P.Header.Index].Status.curHP := P.curHP;
  Players[P.Header.Index].Status.curMP := P.curMP;
  Players[P.Header.Index].Status.maxHP := P.maxHP;
  Players[P.Header.Index].Status.maxMP := P.maxMP;
 end;}
// if(SelectedMob = P.Header.Index) then RefreshMobStatus();
end;
{$ENDREGION}


{$REGION 'Party'}
class procedure TPacketHandlers.ReqParty(Buffer: array of BYTE);
var
 P: p37F absolute Buffer;
begin
 // WriteLog('%s (%d) enviou solicitação de grupo!', P.Nick, P.SenderId);
 if Hacks.Party then
 TsPackets.Party(P.Nick, P.SenderId);
end;

class procedure TPacketHandlers.ExitParty(Buffer: array of BYTE);
var
   P: p37E absolute Buffer;
   I: Integer;
begin
 if(P.ExitId = clientId) then
 begin
  WriteLog('Saiu do grupo com sucesso!');
  for i := 0 to 11 do
  begin
   Party[i].ClientID := 0;
   Party[i].nickName[0] := '0';
  end;
  LeaderId := 0;
 end
 else
 begin
  for i := 0 to 11 do
  if(Party[i].ClientID = P.ExitId) then
  begin
   WriteLog('%s saiu do grupo", Party[i].nickName');
   Party[i].ClientID		:= 0;
   Party[i].nickName[0]	:= '0';
   break;
  end;
 end;
 if(p.ExitId = LeaderId) then LeaderId := 0;

 for I := 0 to 11 do
 if P.ExitId = Evoks[i] then
 begin
   Evoks[i]:= 0;
   Break;
 end;
 //RefreshGroup();
end;

class procedure TPacketHandlers.EnterParty(Buffer: array of BYTE);
var
   P: p37D absolute Buffer;
   I: Integer;
begin
   for i := 0 to 11 do
   if(Party[i].ClientID = P.ClientId) then exit;
   for i := 0 to 11 do
   if(Party[i].ClientID  = 0) then
   begin
	  Party[i].ClientID := P.ClientId;
    StrPLCopy(Party[i].nickName, P.Nick, Length(P.Nick));
    break;
   end;
  if (p.ClientId = P.LiderID) then LeaderId := P.LiderID;
//  WriteLog('Grupo com %s (%d)', P.Nick, P.LiderID);
 // RefreshGroup();
end;

class procedure TPacketHandlers.PartyEvok(Buffer: array of BYTE);
var
   P: p3EA absolute Buffer;
begin
if P.ClientID = ClientID then Move(P.Ids, Evoks[0], Sizeof(P.Ids));
end;
{$ENDREGION}

{$REGION 'SendScore'}
class procedure TPacketHandlers.UpdateScore(Buffer: array of BYTE);
var
 P: p336 absolute Buffer;
 id: integer;
begin
 id := p.Header.Index;
 if id = ClientId then
 begin
  Mob.Status         := P.Status;
  Mob.SaveMana       := P.SaveMana;
  Mob.Critical       := P.critical;
  Mob.MagicIncrement := P.MagicIncrement;
  Mob.RegenHP        := P.RegenHP;
  Mob.RegenMP        := P.RegenMP;
 end
 else
 //Players[id].Status:= P.Status;
end;

class procedure TPacketHandlers.UPDATEETC(Buffer: array of BYTE);
var
 P: p337 absolute Buffer;
begin
 if P.header.index = ClientID then
 begin
  Mob.exp    := P.exp;
  Mob.Learn  := P.learn[0];
  Mob.pStatus:= P.pStatus;
  Mob.pMaster:= P.pMaster;
  Mob.pSkill := P.pSkill;
  Mob.Gold   := P.gold;
 end;
end;

{$ENDREGION}

{$REGION 'Charlist'}
class Procedure TPacketHandlers.SendToCharList(Buffer: array of Byte);
var
 p: TSendToCharListPacket absolute Buffer;
begin
 TEncDec.Clear;
 WriteLog('CharList '+  p.UserName);
 TEncDec.attTimerRecv(P.header.time);
 Session:= USER_SELCHAR;
 if P.CharactersData.Name[Acc.slot] <> '' then CharInSlot:= True;
 Move(P.Storage, Storage[0]     , sizeof(P.Storage));
 Move(P.Keys   , TEncDec.mKey[0], sizeof(TEncDec.mKey));
 TEncDec.keys_count:= 0;
 TsPackets.Numeric;
end;
{$ENDREGION}

{$REGION 'Numerica'}
class Procedure TPacketHandlers.Numeric(Buffer: array of Byte);
var
 P: TNumericTokenPacket absolute Buffer;
begin
 WriteLog('NUM');
 Session:= USER_CHARWAIT;

 if Not CharInSlot then
 TsPackets.createchar(RandNick,acc.slot, HT);

 TsPackets.EnterWorld;
end;
{$ENDREGION}


{$REGION 'SendToWorld'}
class procedure TPacketHandlers.SendToWorld(Buffer: array of BYTE);
 var
 P: TSendToWorldPacket absolute Buffer;
 I: Integer;
Const
  sOut = 'Logado no personagem %s em %dx %dy %d %d';
begin
 InitConfig;
 TNode.Node;
 TDrop.IncItem:=0;
 MyPos   := P.Pos;
 charId  := P.Character.SlotIndex;
 ClientId:= P.Character.ClientId;
 TEncDec.attTimerRecv(P.header.time);

 Move(P.Character, Mob, Sizeof(TCharacter));
 Move(P.Character.SkillBar1[0], TGame.SkillBar[0][0], 4); //primeiros 4 da primeira barra
 Move(P.Character.SkillBar2[0], TGame.SkillBar[0][4], 6); //restante da segunda barra
 Move(P.Character.SkillBar2[5], TGame.SkillBar[1][0], 10); //toda segunda barra

// for I := 0 to 9 do
//   WriTeln(TGame.SkillBar[0][i]);

 SubStatus := Ingame;
 Session := USER_PLAY;
 TDrop.MaxInv;
 //TDROP.CheckInv;
 DamageRange:= GetMobAbility(EF_RANGE);
 wType      := TGame.GetItemAbility(TGame.Mob.Equip[6], EF_WTYPE);
 if Boolean(Mob.Learn and $20000000) then Inc(DamageRange);
 if Boolean(Mob.Learn and $80000)    then Inc(DamageRange);
 BAD.StatusG.caption:= 'Ingame: '+P.Character.Name;
 WriteLog(Format(sOut,[Mob.Name, MyPos.X, MyPos.Y, ClientId, Mob.Status.Level]));



 // TMacros.SetMacro;



  if hacks.pDead_Route then GuideToMove(BAD.mCoords);
  if hacks.pDead_Perga then TDROP.UseItem(776);

 TDrop.InsertDrop(BAD.listDelete.Text);
 Hacks.onDrop  := true;
 Hacks.onAmount:= true;
 Hacks.onBuild := true;
 Hacks.onPhysic:= true;

  {
  SLOT: 27  ID: 776  Name: Pergaminho_de_Portal(10)
  SLOT: 28  ID: 776  Name: Pergaminho_de_Portal(10)
  SLOT: 29  ID: 411  Name: Pergaminho_Retorno_10x
  }
end;


{$ENDREGION}

end.

