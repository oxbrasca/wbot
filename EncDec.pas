unit EncDec;

interface

Uses
 Windows, SysUtils, DateUtils, MMSystem, Structs;

 Var
  class_timer : array [0..6]of LongWord =(0, 0, 0, 0, 20000, 0, 0);
  static_timer: array [0..1]of LongWord =(0, 0);
  pak_timer   : array [0..1]of LongWord =(0, 0);
  recv_timer  : array [0..2]of LongWord =(0, 0,0);

type
 TEncDec = class
 Private
{$REGION 'Keys'}
Const
 EncDecKeys: array[0..511] of Byte =
($84, $87, $37, $D7, $EA, $79, $91, $7D, $4B, $4B, $85, $7D, $87, $81, $91, $7C, $0F, $73, $91, $91, $87, $7D, $0D, $7D, $86, $8F, $73, $0F, $E1, $DD, $85, $7D,
$05, $7D, $85, $83, $87, $9C, $85, $33, $0D, $E2, $87, $19, $0F, $79, $85, $86, $37, $7D, $D7, $DD, $E9, $7D, $D7, $7D, $85, $79, $05, $7D, $0F, $E1, $87, $7E,
$23, $87, $F5, $79, $5F, $E3, $4B, $83, $A3, $A2, $AE, $0E, $14, $7D, $DE, $7E, $85, $7A, $85, $AF, $CD, $7D, $87, $A5, $87, $7D, $E1, $7D, $88, $7D, $15, $91,
$23, $7D, $87, $7C, $0D, $7A, $85, $87, $17, $7C, $85, $7D, $AC, $80, $BB, $79, $84, $9B, $5B, $A5, $D7, $8F, $05, $0F, $85, $7E, $85, $80, $85, $98, $F5, $9D,
$A3, $1A, $0D, $19, $87, $7C, $85, $7D, $84, $7D, $85, $7E, $E7, $97, $0D, $0F, $85, $7B, $EA, $7D, $AD, $80, $AD, $7D, $B7, $AF, $0D, $7D, $E9, $3D, $85, $7D,
$87, $B7, $23, $7D, $E7, $B7, $A3, $0C, $87, $7E, $85, $A5, $7D, $76, $35, $B9, $0D, $6F, $23, $7D, $87, $9B, $85, $0C, $E1, $A1, $0D, $7F, $87, $7D, $84, $7A,
$84, $7B, $E1, $86, $E8, $6F, $D1, $79, $85, $19, $53, $95, $C3, $47, $19, $7D, $E7, $0C, $37, $7C, $23, $7D, $85, $7D, $4B, $79, $21, $A5, $87, $7D, $19, $7D,
$0D, $7D, $15, $91, $23, $7D, $87, $7C, $85, $7A, $85, $AF, $CD, $7D, $87, $7D, $E9, $3D, $85, $7D, $15, $79, $85, $7D, $C1, $7B, $EA, $7D, $B7, $7D, $85, $7D,
$85, $7D, $0D, $7D, $E9, $73, $85, $79, $05, $7D, $D7, $7D, $85, $E1, $B9, $E1, $0F, $65, $85, $86, $2D, $7D, $D7, $DD, $A3, $8E, $E6, $7D, $DE, $7E, $AE, $0E,
$0F, $E1, $89, $7E, $23, $7D, $F5, $79, $23, $E1, $4B, $83, $0C, $0F, $85, $7B, $85, $7E, $8F, $80, $85, $98, $F5, $7A, $85, $1A, $0D, $E1, $0F, $7C, $89, $0C,
$85, $0B, $23, $69, $87, $7B, $23, $0C, $1F, $B7, $21, $7A, $88, $7E, $8F, $A5, $7D, $80, $B7, $B9, $18, $BF, $4B, $19, $85, $A5, $91, $80, $87, $81, $87, $7C,
$0F, $73, $91, $91, $84, $87, $37, $D7, $86, $79, $E1, $DD, $85, $7A, $73, $9B, $05, $7D, $0D, $83, $87, $9C, $85, $33, $87, $7D, $85, $0F, $87, $7D, $0D, $7D,
$F6, $7E, $87, $7D, $88, $19, $89, $F5, $D1, $DD, $85, $7D, $8B, $C3, $EA, $7A, $D7, $B0, $0D, $7D, $87, $A5, $87, $7C, $73, $7E, $7D, $86, $87, $23, $85, $10,
$D7, $DF, $ED, $A5, $E1, $7A, $85, $23, $EA, $7E, $85, $98, $AD, $79, $86, $7D, $85, $7D, $D7, $7D, $E1, $7A, $F5, $7D, $85, $B0, $2B, $37, $E1, $7A, $87, $79,
$84, $7D, $73, $73, $87, $7D, $23, $7D, $E9, $7D, $85, $7E, $02, $7D, $DD, $2D, $87, $79, $E7, $79, $AD, $7C, $23, $DA, $87, $0D, $0D, $7B, $E7, $79, $9B, $7D,
$D7, $8F, $05, $7D, $0D, $34, $8F, $7D, $AD, $87, $E9, $7C, $85, $80, $85, $79, $8A, $C3, $E7, $A5, $E8, $6B, $0D, $74, $10, $73, $33, $17, $0D, $37, $21, $19);
{ nerthus
($38,$4F,$D9,$D6,$9F,$FF,$90,$61,$DF,$6A,$EF,$FF,$77,$C7,$EC,$BA,$5F,$B8,$4F,$F8,$6C,$5F,$FA,$71,$87,$A0,$33,$3A,$0C,$3F,$E7,$B2,
$A6,$23,$DB,$49,$09,$7F,$D2,$E4,$BD,$B7,$F0,$7A,$FB,$1C,$84,$07,$C6,$F9,$FF,$01,$AF,$86,$2E,$70,$0C,$A4,$08,$CF,$7E,$0E,$38,$D4,
$8F,$E0,$92,$C8,$46,$14,$AE,$9C,$7E,$DD,$DE,$C1,$5F,$8A,$2A,$92,$39,$C2,$18,$4D,$B0,$52,$58,$57,$EC,$E7,$29,$E2,$4B,$57,$8A,$29,
$35,$E1,$0D,$49,$9C,$09,$DA,$82,$D4,$E5,$C1,$DC,$28,$9E,$DE,$7B,$FA,$69,$B9,$9B,$57,$2A,$65,$08,$9E,$2B,$F0,$85,$5B,$FD,$51,$7A,
$5D,$F7,$7F,$D1,$97,$E1,$73,$64,$F6,$C9,$C5,$E9,$22,$95,$05,$35,$D3,$36,$A9,$BC,$51,$29,$22,$BA,$99,$A4,$5D,$DF,$5B,$9A,$62,$E4,
$D1,$63,$3E,$7D,$84,$D2,$78,$E2,$21,$FC,$3B,$17,$5B,$63,$66,$05,$8E,$E6,$4F,$95,$8C,$9E,$3F,$FA,$59,$80,$90,$2A,$3C,$7A,$F6,$D9,
$5F,$5C,$C5,$FA,$F4,$C5,$4B,$F4,$10,$60,$15,$A9,$A8,$AC,$AF,$86,$7B,$AB,$B8,$A1,$BF,$0E,$D2,$A8,$60,$5A,$CF,$33,$33,$9D,$AF,$1D,
$57,$0F,$36,$0F,$BE,$D8,$B5,$E3,$08,$CD,$EB,$F9,$A0,$CD,$70,$29,$ED,$2A,$17,$EA,$61,$AF,$D5,$78,$32,$46,$06,$5E,$B9,$38,$0E,$47,
$90,$98,$4F,$0F,$7E,$5C,$E0,$CD,$CD,$90,$7B,$F4,$1D,$55,$1E,$AE,$BD,$FB,$BD,$15,$2D,$EE,$A5,$F0,$58,$C7,$BF,$A0,$8C,$33,$78,$C5,
$65,$8C,$FA,$E7,$8F,$D6,$DD,$A4,$2E,$68,$24,$99,$3E,$83,$8F,$2F,$45,$AC,$28,$54,$A4,$6B,$04,$6E,$5E,$DA,$AF,$04,$AD,$2B,$3A,$5A,
$31,$F2,$C1,$97,$96,$02,$9F,$AD,$76,$8A,$E9,$7C,$68,$51,$03,$93,$E5,$3E,$70,$71,$8B,$78,$16,$A0,$D4,$ED,$2C,$29,$E0,$F0,$7F,$17,
$57,$45,$D4,$33,$76,$4A,$7C,$02,$79,$9D,$F2,$C6,$40,$E8,$18,$9C,$83,$26,$59,$CB,$69,$1D,$65,$0C,$52,$E1,$2E,$3F,$B0,$09,$DB,$67,
$BD,$73,$85,$DF,$5D,$D1,$B1,$11,$0E,$3E,$8D,$B3,$B3,$A6,$D2,$DB,$04,$4C,$C7,$D2,$8B,$15,$60,$87,$6D,$0C,$53,$8E,$6A,$AA,$46,$87,
$CC,$61,$4A,$D9,$B6,$ED,$DD,$1B,$0F,$7D,$27,$14,$EF,$9F,$9A,$38,$D4,$0E,$C3,$8C,$80,$50,$56,$3E,$43,$B7,$5F,$EF,$9D,$C3,$19,$07,
$F1,$64,$BF,$F0,$B4,$A8,$04,$B7,$DA,$DD,$56,$CA,$E7,$99,$3E,$6B,$E3,$3C,$79,$12,$1E,$F1,$7D,$31,$75,$22,$37,$D3,$21,$75,$91,$4B,
$9F,$C7,$24,$88,$4F,$40,$8B,$CD,$54,$57,$51,$53,$D3,$0F,$6D,$07,$26,$9C,$3C,$90,$FA,$D1,$F0,$34,$27,
$FD, $E3, $3A, $8C, $91, $D3, $8D);
}
{$ENDREGION}
 Public
{$REGION 'Declarações'}
  Const
  RECV_BUFFER_SIZE = 32*1024;
  SEND_BUFFER_SIZE = 8*1024;
  MAX_MESSAGE_SIZE = 16*1024;//6
  class var pRecvBuffer: Array [0..RECV_BUFFER_SIZE] of byte;
  class var pSendBuffer: Array [0..SEND_BUFFER_SIZE] of byte;
  class var mKey       : Array [0..15] of byte;
 	class var nSendPosition: Integer;
 	class var nRecvPosition: Integer;
  class var nProcPosition: Integer;
 	class var nSentPosition: Integer;
  class var keys_count: shortint;
//  class var LastPacket: LongWord;
//  class var TimePacket: LongWord;
  {$ENDREGION}
  class Procedure Encrypt(Var Src:array of byte);
  class Function  Decrypt(Src: Array of byte): Boolean;
  class Procedure Clear;
  class Procedure RefreshRecvBuffer;
  class Procedure RefreshSendBuffer;
  class Function  Receive(Buffer: Array of Byte; Len: Word): Boolean;
  class Procedure ReadMessage; static;
  Class Function  GetTime: LongWord;
  class Procedure SendMessageA;
  class Procedure AddMessage(Msg: Array of byte; Size: Word);overload;
  class Procedure AddMessage(Var Msg; Size: Word);overload;
  Class Function  GetHashIncrement: Byte;
  class function  CheckStamp(Value, Delay: LongWOrd): boolean;
  Class Var       OldTime: LongWOrd;

  Class Function  getTimerRecv: LongWord;
  Class Procedure attTimerRecv(_new: LongWord);
  Class procedure SetInRecv(P: sHeader);
  Class Procedure attTime(var T: LongWord);

  Class var send_tick: LongInt;
  Class Var wrongTime: boolean;
end;

implementation

Uses
 PControl, Def, Func, ClSocket,MAin;

{$REGION 'Clear'}
class Procedure TEncDec.Clear;
begin
  ZeroMemory(@pRecvBuffer, RECV_BUFFER_SIZE);
  ZeroMemory(@pSendBuffer, SEND_BUFFER_SIZE);
  ZeroMemory(@mKey, Sizeof(mKey));

  ZeroMemory(@Class_Timer,  Sizeof(Class_Timer));
  ZeroMemory(@static_timer, Sizeof(static_timer));
  ZeroMemory(@pak_timer,    Sizeof(pak_timer));
  ZeroMemory(@recv_timer,   Sizeof(recv_timer));
 // Class_Timer[4]:=20000;
  nSendPosition:= 0; nSentPosition:= 0;
 	nRecvPosition:= 0; nProcPosition:= 0;
  //LastPacket   := 0; TimePacket   := 0;
  keys_count   := -1;OldTime:= 0;
end;
{$ENDREGION}

{$REGION 'Refresh'}
class Procedure TEncDec.RefreshSendBuffer;
var
 Left: DWORD;
begin
  Left := nSendPosition - nSentPosition;
 if(Left <= 0)then exit;
  Move(pSendBuffer, pSendBuffer[nSentPosition], Left);
  nSentPosition := 0;
  Dec(nSendPosition, Left);
end;

class Procedure TEncDec.RefreshRecvBuffer;
Var
 Left: DWORD;
begin
 Left:= nRecvPosition - nProcPosition;
  if (left <= 0) then exit;
  Move(pRecvBuffer, pRecvBuffer[nProcPosition], Left);
  nProcPosition := 0;
  Dec(nRecvPosition, Left);
end;
{$ENDREGION}

{$REGION 'Recv / Send'}
class Function  TEncDec.Receive(Buffer: Array of Byte; Len: Word): Boolean;
Var
 Rest: Integer;
begin
  Result:= False;
  Rest := RECV_BUFFER_SIZE - nRecvPosition;
  Move(Buffer,pRecvBuffer[nRecvPosition], Rest);
  nRecvPosition:= nRecvPosition + Len;
  Result:= True;
end;

class Procedure TEncDec.AddMessage(Msg: Array of byte; Size: Word);
begin
 if(nSendPosition + Size >= SEND_BUFFER_SIZE)then exit;
  Encrypt(Msg);
  Move(Msg, pSendBuffer[nSendPosition],size);
	nSendPosition:= nSendPosition + Size;
  //SendMessageA;
end;

class Procedure TEncDec.AddMessage(Var Msg; Size: Word);
begin
 if(nSendPosition + Size >= SEND_BUFFER_SIZE)then exit;
  Move(Msg,pSendBuffer[nSendPosition],size);
	nSendPosition:= nSendPosition + Size;
 //SendMessageA;
end;


{$ENDREGION}

{$REGION 'Read Send Message'}
class Procedure TEncDec.ReadMessage;
var
  P  : sHeader;
  Src: Array [0..MAX_MESSAGE_SIZE] of byte;
begin
	if(nProcPosition >= nRecvPosition) then
  begin
		nRecvPosition := 0;
		nProcPosition := 0;
    exit;
  end;
  if (nRecvPosition - nProcPosition) < 12 then exit;

  Move(pRecvBuffer[nProcPosition], P, sizeof(P));///seta a size
  if(P.Size < 12) or (P.Size > MAX_MESSAGE_SIZE) then   //segundo bot dh $1888
	begin
		nRecvPosition:=	0;
		nProcPosition:=	0;
    exit;
  end;
 	if P.Size > (nRecvPosition - nProcPosition) then exit;
  Move(pRecvBuffer[nProcPosition], Src[0], P.Size); //copia pacote
  Inc(nProcPosition, P.Size);
  if(nRecvPosition <=  nProcPosition) then
	begin
		nRecvPosition := 0;
		nProcPosition := 0;
  end;

  if not Decrypt(Src) then
  begin
   WriteLog('dec erro');
  // nRecvPosition := 0;
  // nProcPosition := 0;
   //RefreshRecvBuffer;
  end;
end;

class Procedure TEncDec.SendMessageA;
var
 Left,  SendSize: Integer;
begin
	if(nSentPosition > 0) then 	RefreshSendBuffer;
  if(nSendPosition > SEND_BUFFER_SIZE) or (nSendPosition < 0) then exit;
	if(nSentPosition > nSendPosition) or (nSentPosition > SEND_BUFFER_SIZE) or
    (nSentPosition < 0) then exit;
    Left := nSendPosition - nSentPosition;
    if Left = 0 then exit;
    SendSize:= TClient.SendBuff(pSendBuffer[nSentPosition], Left);
    if(SendSize <> -1) then
		Inc(nSentPosition, SendSize) else exit;
    if(nSendPosition >= nSendPosition) then
    begin
	   nSendPosition:= 0;
		 nSentPosition:= 0;
    end;
end;
{$ENDREGION}

{$REGION 'Time'}
class Function TEncDec.GetHashIncrement: Byte;
Var
 temp_keys : Integer;
begin
 Randomize;
 if keys_count = -1 then temp_keys:= Random($FF) else
 begin
  if(keys_count >= 0 ) and (keys_count <= 15)  then
	begin
	 temp_keys:= mKey[keys_count];
   inc(keys_count);
  end
  else
  begin
	 if (mKey[15] mod 2) = 0 then
   temp_keys := mKey[1] + mKey[3] + mKey[5] - $57
   else
   temp_keys := mKey[13] + mKey[11] - mKey[9] + 4;
  end;
 end;
  Result:= temp_keys XOR $FF;
end;

class Function TEncDec.GetTime: LongWord;
begin
 Result:= static_timer[0];//TimePacket + (cTime - LastPacket);
end;

class function TEncDec.getTimerRecv: LongWord;
Var
 tmp: array [0..5]of LongWord; //-4, -8, -c, -10, -14, -18
begin
  ZeroMemory(@tmp, sizeof(tmp));
	tmp[2]:= timeGetTime - class_timer[2];
	tmp[1]:= class_timer[1] + tmp[2];
	static_timer[0]:= tmp[1];
	tmp[0]:= trunc(tmp[2] / 60000);//ebp-4
	if(tmp[0] <> class_timer[6]) then
  begin
  	attTime(tmp[3]);
		tmp[4] := tmp[3] - class_timer[5];
		tmp[5] := trunc(tmp[2] / 1000);
	//	if(tmp[4] <> tmp[5]) and (class_timer[6] <> 0) then
	//	WriteLog('Timer errado!');// /* Está mensagem não atrapalha nada */
   // wrongTime:= (tmp[4] <> tmp[5]) and (class_timer[6] <> 0);

    class_timer[6]:= tmp[0];
	end;
	result:=tmp[1] + class_timer[4];
end;

class procedure TEncDec.attTime(var T: LongWord);
const
SecsPerDay = 24 *60 *60;
begin
 if(t <> 0) then
 begin  ////ta mt errado essa merda
  t:= Trunc((Now -EncodeDate(1970,1,1)) * SecsPerDay);
  WriteLog('atttime1');
 end;
// WriteLog('atttime2');
 //if(t <> 0) then t:= Round((time) * 24 * 60 * 60);
//if(t <> 0) then t:=Trunc( (time -EncodeDate(1970,1,1)) * SecsPerDay);
end;

class procedure TEncDec.attTimerRecv(_new: LongWord);
begin
	class_timer[0]:= _new;
  class_timer[1]:= _new;
	class_timer[2]:= timeGetTime;
	attTime(class_timer[5]);
end;

class procedure TEncDec.SetInRecv(P: sHeader);
var
 _158: LongWord;
begin
  pak_timer[0]:= P.time;
  pak_timer[1]:= timeGetTime;
  _158:= getTimerRecv;
  recv_timer[0]:= P.time;
  recv_timer[1]:= trunc(_158 / 1000);
  if(_158 > recv_timer[2]+10000) then
  begin
   if (recv_timer[0] > _158 + 500)     then attTimerRecv(_158+85)
   else if (recv_timer[0] < _158 - 500)then attTimerRecv(_158-85);
	 recv_timer[2]:= _158;
  end;
end;

class function TEncDec.CheckStamp(Value, Delay: LongWOrd): boolean;
begin
 Result:= False;
 if (Value > 0) then// transição de atk pra atk
 if (GetTime - Value) < Delay then exit;
 result:= True;
end;
{$ENDREGION}

{$REGION 'Enc/Dec'}
class Procedure TEncDec.Encrypt(Var Src: array of byte);
var
 P: sHeader absolute Src;
 I           : Integer;
 key         : integer;
 pos         : dword;
 CheckSumEnc : Byte;
 CheckSumDec : Byte;
begin
  CheckSumEnc := 0; CheckSumDec := 0; I := 4;
  P.Time:= static_timer[0];
  static_timer[1]:= static_timer[0];
  send_tick:= TimeGetTime;
  P.key:= GetHashIncrement;
  pos:= EncDecKeys[P.key shl 1];
  while( i < P.size) do begin
   Inc(CheckSumDec, src[i] and $FF);//Entrada Dec
   Key:= EncDecKeys[((pos mod $100) shl 1) + 1];
   case (i and 3) of
   0: Src[i]:= Src[i] + (key shl 1);
   1: Src[i]:= Src[i] - (key shr 3);
   2: Src[i]:= Src[i] + (key shl 2);
   3: Src[i]:= Src[i] - (key shr 5);
   end;
  Inc(CheckSumEnc, src[i] and $FF);//Saida  Enc
  Inc(I);
  Inc(pos);
  end;
  P.ChkSum:= (CheckSumEnc - CheckSumDec) and $FF;
end;

class Function TEncDec.Decrypt(Src: Array of byte):Boolean;
var
 P: sHeader absolute Src;
 I           : Integer;
 key         : integer;
 pos         : dword;
 CheckSumEnc : Byte;
 CheckSumDec : Byte;
begin
  CheckSumEnc:= 0; CheckSumDec:= 0; I := 4;
  pos:= EncDecKeys[P.key shl 1];
  while(i < P.Size) do
  begin
   Key:= EncDecKeys[((pos mod $100) shl 1) + 1];
   Inc(CheckSumEnc, Src[i] and $FF);//Entrada and $FF
   case (i and 3) of
   0:Src[i]:= Src[i] - (key shl 1);
   1:Src[i]:= Src[i] + (key shr 3);
   2:Src[i]:= Src[i] - (key shl 2);
   3:Src[i]:= Src[i] + (key shr 5);
   end;
   Inc(CheckSumDec, Src[i] and $FF);//Saida  and $FF
   inc(pos);
   inc(i);
  end;
  Result:= P.ChkSum = ((CheckSumEnc - CheckSumDec) and $FF);
  if result then
  begin
   SetInRecv(P);
   TFunctions.PacketControl(Src);
  end;
end;
{$ENDREGION}
end.




