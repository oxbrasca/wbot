unit PControl;

interface

 Uses
 PacketHandlers, Windows,SYsUtils;

type TFunctions = class(TPacketHandlers)
 Public
  class Procedure PacketControl(var Buffer: array of Byte);
  Private
{$REGION 'Header'}
type sHeader = Record
    Size  : Word;
    Key   : Byte;
    ChkSum: Byte;
    Code  : Word;
    Index : Word;
    Time  : LongInt;
end;
{$ENDREGION}
 end;

implementation

Uses
   Func, def, nDef, EncDec;

{$REGION 'PacketControl'}
class Procedure TFunctions.PacketControl(var Buffer: array of Byte);
var
  Packet: sHeader absolute Buffer;
begin
  case Packet.code of
   $10A : SendToCharList(Buffer);//$3A3
   $114 : SendToWorld(Buffer);
   $FDE : Numeric(Buffer);
   $364, $363: Spaw(Buffer);
   $116 : WriteLog('Back charList');
   $165 : DeleteSpaw(Buffer);
   $338 : MobDead(Buffer);
   $181 : RefreshHPMP(Buffer);
   $336 : UpdateScore(Buffer);
   $337 : UPDATEETC(Buffer);
   $367, $39D, $39E: Damage(Buffer);
   $36C, $366: MovementPacket(Buffer);
   $37F : ReqParty(Buffer);
   $37E : ExitParty(Buffer);
   $37D : EnterParty(Buffer);
   $3EA : PartyEvok(Buffer);
   $182 : PutItem(Buffer);
   $376 : MoveItem(Buffer);
   $185 : AttInv(Buffer);
   $3B9 : Buffs(Buffer);
   $101 : SvMsg(Buffer); //106
  end;
end;
{$ENDREGION}

end.
