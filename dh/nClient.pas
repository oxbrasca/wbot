unit nClient;

interface

Uses
 Windows, Structs, CLSocket, nDef;

type TControl = class(TClient)
 Public
 Class Procedure InsertPacet(Time: TTIme; Var Pak; Pos: Integer = -1);
end;


implementation

{ TControl }
class procedure TControl.InsertPacet(Time: TTIme; var Pak; Pos: Integer = -1);
Var
 Packet: sHeader absolute Pak;
 P: integer;
begin
 p := pos;
 if(p = -1) then
 for p := 0 to MAX_TIMER_PACKETS do
 if (TimerPacket[p].time = 0) then Break;
 if(p < 0) or (p > 64) then exit;
 Move(Pak, TimerPacket[p].buffer, Packet.Size);
// TimerPacket[p].time:= Time;
end;

end.
