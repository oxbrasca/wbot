unit ProcessTimer;

interface

Uses
 Windows, SysUtils,
 Structs, MiscData, PlayerData, def, Classes;

 type
  TProcessSecTimer = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
    Class Procedure ProcessSecTimer;
    Class Var mDelay: Integer;
    Class Var Macro: LongWord;
  end;

 type
  TProcessAtk = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
    Class Procedure ProcessAtk;
  end;

implementation

Uses
 Func, nDef, ClSocket, EncDec,
 uClient, uPackets, PathFinding, uItem, uSkill, Main;

{$REGION 'Thread'}
constructor TProcessSecTimer.Create;
begin
mDelay:= 9;
Macro:=  0;

  inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLower;
  Resume;//  tpLower;       tpNormal
end;

procedure TProcessSecTimer.Execute;
begin
  inherited;
   while not Terminated do
   if TGame.Session = USER_PLAY then
   begin
      ProcessSecTimer;
      sleep(100);
   end;
end;

{ TProcessAtk }
constructor TProcessAtk.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLower;
  Resume;//  tpLower;       tpNormal
end;

procedure TProcessAtk.Execute;
begin
  inherited;
   while not Terminated do
   if TGame.Session = USER_PLAY then
   begin
      ProcessAtk;
      sleep(TGame.Macro.DelayProc);
   end;
end;
{$ENDREGION}

class procedure TProcessSecTimer.ProcessSecTimer();
Var
 sec: Integer;
 pos: zPosition;
 OldPos: TPosition;
 p: TPosition;
 I: Integer;
begin
 if    (TGame.Session <= USER_LOGIN)   then exit;
 if not TEncDec.CheckStamp(Macro, 100) then exit;
 sec := TGame.SecCounter;
 //delay := Trunc(2300 + (dist * (1000 - speed)));
// if  (sec mod (14 - TGame.CalcVelo)  = 0)
 if (sec mod  mDelay = 0)
 and Tnode.Queue then  //3
 begin
		pos:= TNode.Route[Tnode.RouteActual];
		if(pos.X <= 0) or (pos.Y <= 0) then
    begin
      Tnode.Queue       := false;
			Tnode.RouteActual := 0;
			Tnode.RouteCount  := 0;
    end
		else
		begin
     OldPos:= TGame.MyPos;
    mDelay:= TsPackets.Moved(TGame.MyPos, Tnode.Route[Tnode.RouteActual], 0);
     if Tnode.Route[Tnode.RouteActual].Teleport then  TsPackets.Portal;
        Inc(Tnode.RouteActual);

     P.X:= Tnode.Route[Tnode.RouteActual].X;
     P.Y:= Tnode.Route[Tnode.RouteActual].Y;
     // TGame.CalcMovement(TGame.MyPos, P);
     if(Tnode.RouteActual > Tnode.RouteCount) then
     begin
      TsPackets.Moved(TGame.MyPos, TGame.MyPos, 0);
      Tnode.Queue       := false;
		  Tnode.RouteActual := 0;
		  Tnode.RouteCount  := 0;
      mDelay            := 10;
     end;
    end;
 end;

 if not Tnode.Queue and (TGame.Session = USER_PLAY) then
 begin
 if (sec mod  32 = 0) and TGame.Hacks.onDrop   then TDROP.TimerDrop;
 if (sec mod  55 = 0) and TGame.Hacks.onAmount then TDROP.Amount(TGAme.Hacks.sAmountList);
 if (sec mod  26 = 0) and TGame.Hacks.onBuild  then TGame.SetBuild;
 if (sec mod  14 = 0) then TDROP.CheckInv;
 end;

  if (TGame.Session = USER_PLAY) then
  if TGame.Mob.Status.Level<=34 then
  if (sec mod  21 = 0) then TGame.CarbunkleBuff;

 Inc(TGame.SecCounter);
 Macro:= TEncDec.GetTime;
 //cada 10 é 1 segundo
end;

class procedure TProcessAtk.ProcessAtk;
begin
 if not Tnode.Queue and (TGame.Session = USER_PLAY) then
 begin
 if not TEncDec.CheckStamp(TGAme.Macro.DelayMs, 1000) then exit;

 if TGame.Hacks.Evok      and TSkill.Evok       then Exit;
 if TGame.Hacks.Buff      and TSkill.AutoBuff   then Exit;
 if TGame.Hacks.onMagic   and TSkill.Magical    then Exit;
 if TGame.Hacks.onPhysic  and TSkill.Physical   then Exit;
 end;
end;

end.
