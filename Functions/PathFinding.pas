unit PathFinding;

interface

Uses
 Windows, Classes,
  Structs, MiscData, PlayerData, def, sysutils,strUtils, Vcl.StdCtrls;


type TNode = class
 Public
 Class Procedure Node;
 Class Function isEmpyt(X,Y: Integer): byte;
 class Procedure LoadRouter(Name: String);
 Class Procedure SaveRouter(Name: String);
 class procedure ReadGuide(Name: String;Memo:TMemo);
 class procedure GuideToMove(Memo:TMemo);
 Class Var Queue: boolean;
 Class Var Route: Array [0..MAX_ROUTE] of zPosition;
 Class Var RouteCount : DWORD;
 Class Var RouteActual: DWORD;
end;

implementation

Uses
 uPackets, uItem, Func;

{ TNode }

class function TNode.isEmpyt(X, Y: Integer): byte;
Var
 Bit: Byte;
begin
//Bit:= g_pHeightGrid[Trunc(y/8)][x];
if (X>=0) and (X< 4096) and
   (Y>=0) and (Y< 4096) then
   Result:=  (Bit shr (y mod 8))
   else
   result:= 0;
end;

class procedure TNode.ReadGuide(Name: String;Memo:TMemo);
var
  FCount : integer;
  inFile: TFileStream;
  Route: Array [0..MAX_ROUTE] of TPosition;
  I: Integer;
begin
 inFile := TFileStream.Create(Name,  fmOpenRead);
 inFile.Read(Route[0],sizeof(Route));
 inFile.Free;
 Memo.Clear;

 for I := 0 to MAX_Route do
 if (Route[i].X > 0) or (Route[i].Y > 0) then
    Memo.Lines.add(Route[i].X.ToString+' '+Route[i].Y.ToString)
    else
    Break;
end;

class procedure TNode.GuideToMove(Memo:TMemo);
var
  I: Integer;
  X, Y: Word;
begin
  TNode.Node;
  for I := 0 to Memo.Lines.Count-1 do
  if Memo.Lines[i] <> '' then
  begin
   Route[i].X:= SplitString(Memo.Lines[i], ' ')[0].ToInteger;
   Route[i].Y:= SplitString(Memo.Lines[i], ' ')[1].ToInteger;
  end;
  TNode.RouteCount:= I-1;
  TNode.Queue:= True;
end;

class procedure TNode.SaveRouter(Name: String);
VAr
outFile  : TFileStream;
begin
  outFile := TFileStream.Create(Name, fmCreate);
  outFile.Write(Route[0], Sizeof(Route));
  outFile.Free;
end;

class procedure TNode.LoadRouter(Name: String);
var
  FCount : integer;
  inFile: TFileStream;
  buff: array of byte;
  I: Integer;
begin
Node;

 inFile := TFileStream.Create(Name,  fmOpenRead);
 inFile.Read(Route[0],sizeof(Route));
 inFile.Free;

  for I := 0 to MAX_Route do
  if (Route[i].X <= 0) or (Route[i].Y <= 0) then
  begin
  RouteCount:= i -1;
  Break;
  end;

Queue:= True;
WriteLog(Name);
end;

class procedure TNode.Node;
begin
 	RouteCount := 0;
	RouteActual := 0;
	Queue:= False;
  ZeroMemory(@Route, Sizeof(Route));  ///
end;

end.
