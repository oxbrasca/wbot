unit uItem;

interface

Uses
 Windows, classes, SysuTils,
 Structs, MiscData, PlayerData, def,
 uClient;

type TDROP = class(TGame)
Public
 Class Function CheckEquip(Id: Word): Boolean;
 class Procedure MaxInv;
 class Procedure CheckInv;
 class Procedure Insert(Slot: Word);
 class Procedure InsertEquip(Slot: Word);
 class Procedure SetItem(Slot: Cardinal);
 class Procedure Delete(Slot: Word);
 class procedure UseItem(ID: Word; Qtd: Word = 0);
 class function  SlotItem(Local, ItemID : WORD) : WORD;
 class procedure ReAmount(Items : STRING);//Desagrupar Itens
 class procedure Amount;overload; //Agrupar Itens
 class procedure Amount(Items: STRING);overload; //Agrupar Itens
 class procedure Erase(Items : STRING);
 Class Procedure TimerDrop;
 class Procedure InsertDrop(Items : STRING);
 Class Procedure AttDrop(Item: Word);
 Class Procedure RemoveDrop(Item: Word);
 class Procedure InsertAmount(Items : STRING);
 Class Var IncItem  : Byte;
 Class Var CheckItem: Byte;
 Class Var DropList : Array of word;
end;

implementation

Uses
 uPackets, Func;

class procedure TDROP.TimerDrop;
var
  j : INTEGER;
  Apagar : BOOLEAN;
begin
 Apagar := True;
 for j := 0 to Hacks.DropMaxList do
 if Mob.Inventory[IncItem].ID = Hacks.DropList[j] then Apagar := False;
 if Apagar then
    Erase(IntToStr(Mob.Inventory[IncItem].ID));

  inc(IncItem);
  if IncItem > cMax.Inventory then  IncItem:= 0;
end;


class procedure TDROP.InsertAmount(Items: STRING);
var
  i, j : INTEGER;
  Item : TSTRINGLIST;
begin
 for i := 0 to 20 do
 Hacks.AmountList[i]:= 0;
 j := 0;
 Item := Explode(Items);
 for i := 0 to Item.Count-1 do
 if StrToInt(Item[i]) > 0 then
 begin
  Hacks.AmountList[j]:= StrToInt(Item[i]);
  Inc(j);
 end;
 Hacks.AmountMaxList:= j-1;
end;

class procedure TDROP.AttDrop(Item: Word);
Var
I: Integer;
begin
for I := 0 to Hacks.DropMaxList+1 do
if Hacks.DropList[i] = 0 then
   Hacks.DropList[i]:= item;
inc(Hacks.DropMaxList);
end;

class procedure TDROP.RemoveDrop(Item: Word);
Var
I: Integer;
begin
for I := 0 to Hacks.DropMaxList do
if Hacks.DropList[i] = Item then
   Hacks.DropList[i]:= 0;
end;


class Procedure TDROP.InsertDrop(Items : STRING);
var
  i, j : INTEGER;
  Item : TSTRINGLIST;
begin
  for i := 0 to 174 do
    Hacks.DropList[i]:= 0;

  j := 0;

 {for i := 1 to cMax.Equip do
 if Mob.Equip[i].ID <> 0 then
 begin
  Hacks.DropList[j] := Mob.Equip[i].ID;
  Inc(j);
 end;

 for i := 0 to cMax.Inventory do     ////vai guardar tbm
 if Mob.Inventory[i].ID <> 0 then
 begin
  Hacks.DropList[j]:= Mob.Inventory[i].ID;
  Inc(j);
 end;
 }
 Item := Explode(Items);

 for i := 0 to Item.Count-1 do
 if StrToIntDef(Item[i],0) <> 0 then
 begin
  Hacks.DropList[j]:= StrToInt(Item[i]);
  Inc(j);
 end;

 Hacks.DropMaxList:= j-1;
end;

class procedure TDROP.Erase(Items : STRING);
var
  Buffer : ARRAY OF BYTE;
  i, j : INTEGER;
  Item : TSTRINGLIST;
begin
  begin
    Item := Explode(Items);
    for i := 0 to cMax.Inventory do
      for j := 0 to Item.Count-1 do
       if TGAMe.Mob.Inventory[i].ID > 0 then
        if TGAMe.Mob.Inventory[i].ID = StrToInt(Item[j]) then
        begin
          TsPackets.Erase(i);
        end;
  end;
end;

class procedure TDROP.ReAmount(Items : STRING);//Desagrupar Itens
var
  Buffer : ARRAY OF BYTE;
  vItem : TITEM;
  i, j, k, p, vAmount, mv : INTEGER;
  Item : TSTRINGLIST;
begin
  Item := Explode(Items);
  for p := 0 to Item.Count-1 do
  begin
    for i := 0 to cMax.Inventory do
    begin
      vItem := Mob.Inventory[i];
      if vItem.ID = StrToInt(Item[p]) then
      begin
        vAmount := 1;
        if vItem.Effects[0].Index = 61 then vAmount := vItem.Effects[0].Value else
        if vItem.Effects[1].Index = 61 then vAmount := vItem.Effects[1].Value else
        if vItem.Effects[2].Index = 61 then vAmount := vItem.Effects[2].Value;
        Dec(vAmount);
        mv := 0;
        for k := 0 to 59 do
          if Mob.Inventory[k].ID = 0 then
            Inc(mv);

        if vAmount > mv then
          Dec(mv)
        else
          mv := vAmount-1;

        for j := 0 to mv  do
        begin
         TsPackets.SplitItem(i, StrToInt(Item[p]),1);
         Delay(100);
        end;
      end;
    end;
  end;
end;

class procedure TDROP.Amount(Items: STRING); //Agrupar Itens
var
  vItem : TITEM;
  i, p, vAmount, fItem, faItem : INTEGER;
  Item : TSTRINGLIST;
begin
  Item := Explode(Items);
  for p := 0 to Item.Count-1 do
  begin
    faItem := 0;
    fItem := -1;
    for i := 0 to cMax.Inventory do
    begin
      vItem := Mob.Inventory[i];
      if vItem.ID = StrToInt(Item[p]) then
      begin
        vAmount := 0;
        if vItem.Effects[0].Index = 61 then vAmount := vItem.Effects[0].Value else
        if vItem.Effects[1].Index = 61 then vAmount := vItem.Effects[1].Value else
        if vItem.Effects[2].Index = 61 then vAmount := vItem.Effects[2].Value;
        if vAmount >= 120 then continue;
        if faItem >= 120 then fItem := -1;
        if fItem = -1 then
        begin
          fItem := i;
          faItem := vAmount;
          continue;
        end;
        faItem := + vAmount;
        TsPackets.MoveItem(i, 1, fItem, 1, Item[p]);
      end;
    end;
  end;
end;

class function TDROP.CheckEquip(Id: Word): Boolean;
begin
result:= False;
if not MOb.Status.level >= ItemList[id].level then exit
else
if not MOb.Status.int >= ItemList[id].INT then exit
else
if not MOb.Status.Dex >= ItemList[id].Dex then exit
else
if not MOb.Status.CON >= ItemList[id].CON then exit
else
if not MOb.Status.Str >= ItemList[id].STR then exit;

result:= true;
end;

class procedure TDROP.CheckInv;
Var
 I: Integer;
begin
 /// for I := 0 to cMAX.inventory do
  TDrop.SetItem(CheckItem);

  inc(CheckItem);
  if CheckItem > cMax.Inventory then CheckItem:= 0;
end;

class procedure TDROP.Amount; //Agrupar Itens
var
  vItem : TITEM;
  i, p, vAmount, fItem, faItem : INTEGER;
begin
  for p := 0 to Hacks.AmountMaxList do
  begin
    faItem := 0;
    fItem := -1;
    for i := 0 to cMax.Inventory do
    begin
      vItem := Mob.Inventory[i];
      if vItem.ID = Hacks.AmountList[P] then
      begin
        vAmount := 0;
        if vItem.Effects[0].Index = 61 then vAmount := vItem.Effects[0].Value else
        if vItem.Effects[1].Index = 61 then vAmount := vItem.Effects[1].Value else
        if vItem.Effects[2].Index = 61 then vAmount := vItem.Effects[2].Value;
        if vAmount >= 120 then continue;
        if faItem >= 120 then fItem := -1;
        if fItem = -1 then
        begin
          fItem := i;
          faItem := vAmount;
          continue;
        end;
        faItem := + vAmount;
        TsPackets.MoveItem(i, 1, fItem, 1);
      end;
    end;
  end;
end;

class function TDROP.SlotItem(Local, ItemID : WORD) : WORD;
var
  i, P : INTEGER;
begin
  P := -1;
  if Local = 0 then
  begin
    for i := 0 to cMax.Equip do
      if Mob.Equip[i].ID = ItemID then
      begin
        P := i;
        break;
      end;
  end
  else if Local = 1 then
  begin
    for i := 0 to cMax.Inventory do
      if Mob.Inventory[i].ID = ItemID then
      begin
        P := i;
        break;
      end;
  end
  else
  begin
    for i := 0 to cMax.Cargo do
      if Storage[i].ID = ItemID then
      begin
        P := i;
        break;
      end;
  end;
  Result := P;
end;

class Procedure TDrop.MaxInv;
begin
  cMax.Inventory:= 29;
  //if Mob.Inventory[60].id > 0 then Inc(Max.Inventory, 15);//+1
  //if Mob.Inventory[61].id > 0 then Inc(Max.Inventory, 15);//+1
  if Mob.Inventory[62].id > 0 then Inc(cMax.Inventory, 15);//+1
  if Mob.Inventory[63].id > 0 then Inc(cMax.Inventory, 15);//+1
end;

class Procedure TDrop.Insert(Slot: Word);
begin
 SetItem(slot);
end;

class Procedure TDrop.InsertEquip(Slot: Word);
begin
 case Mob.Equip[Slot].id of
 0:;
 end;
end;

class Procedure TDrop.SetItem(Slot: Cardinal);
var
 ID: integer;
begin
id:=Mob.Inventory[Slot].id;
//
 case id of
 816: if Mob.Equip[6].id = 0 then   //SLOT: 6   ID: 816  Name: Arco_Curto
       TsPackets.MoveItem(slot, INV_TYPE, 6, EQUIP_TYPE);

 923: if CheckEquip(id) then
      if (Mob.Equip[6].id = 0) or (Mob.Equip[6].id = 816) then
      TsPackets.MoveItem(slot, INV_TYPE, 6, EQUIP_TYPE);

 4117: if (Mob.Status.Level>= 39) and (Mob.Status.Level<= 115) then// 4117 Caixa_da_Sabedoria;
        TsPackets.UseItem(1,slot)
        else TsPackets.Erase(slot);

 4118: if (Mob.Status.Level>= 116) and (Mob.Status.Level<= 190) then// Lágrima_Angelical;
        TsPackets.UseItem(1,slot)
        else TsPackets.Erase(slot);

{ 4119: if (Mob.Status.Level>= 39) and (Mob.Status.Level<= 115) then//   Coração_do_Kaizen;
        TsPackets.UseItem(1,slot)
        else TsPackets.Erase(slot);


 4120: if (Mob.Status.Level>= 39) and (Mob.Status.Level<= 115) then// Olho_de_Sangue;
        TsPackets.UseItem(1,slot)
        else TsPackets.Erase(slot);


 4121: if (Mob.Status.Level>= 39) and (Mob.Status.Level<= 115) then// Pedra_Espiritual_dos_Elfos;
        TsPackets.UseItem(1,slot)
        else TsPackets.Erase(slot);
 }


 end;
//if Mob.Inventory[Slot].id <> 477 then TsPackets.Erase(slot);


end;

class procedure TDROP.UseItem(ID: Word; Qtd: Word = 0);
var
 I,z: Integer;
begin
 for i := 0 to cMax.Inventory do
  if TGame.Mob.Inventory[i].id = id then
  begin
   for z := 0 to Qtd do
   TsPackets.UseItem(INV_TYPE, I);
   break;
  end;
end;

class Procedure TDrop.Delete(Slot: Word);
begin
 //TPackets.DeleteItem(slot,1);
end;

begin
TDRop.CheckItem:= 0;

end.
