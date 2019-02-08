unit uGame;

interface

Uses
  Windows, SysUtils, Classes,
  Def, MiscData, PlayerData, uCLient,
  Func,
  Structs,
  uPackets;

type
  TFuncGame = class(TGame)
  public
  class Function InCoord(PosX, PosY: Word; Max_X, Max_Y: Word): Boolean; overload;
  class Function InCoord(Pos: TPosition; Max: Variant): Boolean; overload;
  class function InCoord(Pos1, Pos2: TPOsition;Max: Word): Boolean;overload;
  Class Function ValidPos(Pos: TPosition):Boolean;
end;

implementation

{ TGame }
class function TFuncGame.InCoord(PosX, PosY, Max_X, Max_Y: Word): Boolean;
begin
  if (Abs(PosX - MyPos.X) <= Max_X) and
     (Abs(PosY - MyPos.Y) <= Max_Y) then
      Result := True // ta na coordenada
  else
      Result := False; // fora
end;


class function TFuncGame.InCoord(Pos1, Pos2: TPOsition;Max: Word): Boolean;
begin
  if (Abs(Pos1.X - Pos2.X) <= Max) and
     (Abs(Pos1.Y - Pos2.Y) <= Max) then
      Result := True // ta na coordenada
  else
      Result := False; // fora
end;



class function TFuncGame.ValidPos(Pos: TPosition): Boolean;
begin
Result:= True;
 if (Pos.X<=0) or (Pos.X>= 4095) or
    (Pos.Y<=0) or (Pos.Y>= 4095) then Result:= False;
end;

class function TFuncGame.InCoord(Pos: TPosition; Max: Variant): Boolean;
begin
  if (Abs(Pos.X - MyPos.X) <= Max) and
     (Abs(Pos.Y - MyPos.Y) <= Max) then
      Result := True // ta na coordenada
  else
      Result := False; // fora
end;
end.
