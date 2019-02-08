unit CLSocket;

interface

uses
 Winsock, Windows, Sysutils, ScktComp, Classes,StrUtils, MiscData,
 EncDec;

type
  TClient = class(TEncDec)
  Private
    class var PortProxy: Integer;
    class procedure Connected(Sender: TObject; Socket: TCustomWinSocket);
    class procedure Disconnected(Sender: TObject; Socket: TCustomWinSocket);
    class procedure Read(Sender: TObject; Socket: TCustomWinSocket);
    class procedure Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  Public
    class Procedure CLConect(IP: string; Port: word); overload;
    class Procedure CLConect(IP: string); overload;
    class Function  SendBuff(var Buffer; Len: Integer): Integer;
    class Procedure SendPacket(Buffer: array of Byte); overload;
    class Procedure SendPacket(var Packet); overload;
    class procedure SendSignal(packetCode: word; Insert: boolean = False); overload;
    class procedure SendSignal(packetCode, size: word); overload;
    class procedure SendData(packetCode: word; Data: VARIANT); overload;
    class procedure SendData(packetCode: word; Data: Integer); overload;
    class Procedure BeginProxy;
    class Function  CheckProxy(var Buffer: Array of byte;Size: Word):Boolean;
    class Procedure CloseSocket;
    class Function  Active: Boolean;

    class procedure InsertPacket(Time: Integer; var Pak; Pos: Integer = -1);
  end;

{$REGION 'Thread'}
  TDesempaca = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

{$ENDREGION}

implementation

Uses
  Func, nDef, Def,  Structs, uPackets, uClient;

var
  ClientSocket: TClientSocket;
  vThread : TDesempaca;

{$REGION 'ClientSocket'}
class Function TClient.Active: Boolean;
begin
  Result:= ClientSocket.Active;
end;

class procedure TClient.InsertPacket(Time: Integer; var Pak; Pos: Integer = -1);
Var
 Packet: sHeader absolute Pak;
 P: integer;
begin
 p := pos;
 if(p = -1) then
 for p := 0 to MAX_TIMER_PACKETS do
 if (TimerPacket[p].time = 0) then Break;           //procura o primeiro livre
 if(p < 0) or (p > 64) then exit;                  //irregular
 TimerPacket[p].time:= cTime + Time;               //seto o timer
 Move(Pak, TimerPacket[p].buffer[0], Packet.Size); //movo o pacote
end;

class Procedure TClient.Connected(Sender: TObject; Socket: TCustomWinSocket);
begin
  Clear;
  DiconectTime:= 0;
  if Socket.RemotePort = PortServ  then TsPackets.Login;
  if PortProxy = Socket.RemotePort then BeginProxy;
end;

class Procedure TClient.Disconnected(Sender: TObject; Socket: TCustomWinSocket);
begin
  Clear;
  DiconectTime  := now;
  SubStatus     := Deslogado;
  TGame.Session := USER_EMPTY;
  WriteLog('Disconect');
  TGame.Start;
end;

class Procedure TClient.CloseSocket;
begin
  ClientSocket.Close;
end;

class Procedure TClient.Error(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  DiconectTime:= now;
  Socket.Close;
  WriteLog('Error: '+ErrorCode.ToString);
  if ErrorCode = 10060 then TGame.Start;
  ErrorCode:= 0;
end;

class Procedure TClient.Read(Sender: TObject; Socket: TCustomWinSocket);
var
  ReceiveSize: integer;
begin
  ReceiveSize := Socket.ReceiveBuf(pRecvBuffer[nRecvPosition],
                                   RECV_BUFFER_SIZE - nRecvPosition);
 if (ReceiveSize <= 0) or
    (ReceiveSize = (RECV_BUFFER_SIZE - nRecvPosition)) then exit;
 if CheckProxy(pRecvBuffer[nRecvPosition], ReceiveSize) then exit;
    Inc(nRecvPosition, ReceiveSize);
end;

class procedure TClient.BeginProxy;
Var
 p: socks5_r;
begin
  ZeroMemory(@p,Sizeof(p));
  p.ver:=5;
  p.nmet:=1;
  p.met:=0;
  SendBuff(p,Sizeof(p));
end;

class function TClient.CheckProxy(var Buffer: array of byte; Size: Word): Boolean;
Var
P:socks5_r_TPC;
begin
 Result:= False;
 if (Size = 2) and (Buffer[0] = 5) and (Buffer[1]<>$FF) then
 begin
  ZeroMemory(@P,sizeof(P));
  P.ver:=5;
  P.cmd:=1;
  P.rsv:=0;
  P.atyp:=1;
  P.ip:=inet_addr(Pansichar(GetServerIP));
  P.port:=htons(PortServ);
  SendBuff(P,Sizeof(P));
  Result:= True;
  exit;
 end;
 if (Size > 2) and (Buffer[0] = 5) and (Buffer[1] = 0) then
 begin
  WriteLog('Proxy OK');
  TsPackets.Login;
  Result:= True;
 end;
end;

class Procedure TClient.CLConect(IP: string; Port: word);
begin
 try
  ClientSocket.Address := IP;
  ClientSocket.Port    := Port;
  ClientSocket.Open;
  Except
   CloseSocket;
   WriteLog('Erro Connect');
  end;
end;

class Procedure TClient.CLConect(IP: string);
begin
 try
  ClientSocket.Address := SplitString(IP, ':')[0];
  ClientSocket.Port    := SplitString(IP, ':')[1].ToInteger;
  PortProxy:= ClientSocket.Port;
  ClientSocket.Open;
  Except
   CloseSocket;
   WriteLog('Erro Connect');
 end;
end;

class Function TClient.SendBuff(var Buffer; Len: Integer): Integer;
begin
   Result:= ClientSocket.Socket.SendBuf(Buffer, Len);
   if SOCKET_ERROR = Result then CloseSocket;
end;

class Procedure TClient.SendPacket(Buffer: array of Byte);
Var
 Packet: sHeader absolute buffer;
begin
  if SubStatus >= Logando then
  begin
   Encrypt(Buffer);
   SendBuff(Buffer, Packet.Size);
  end;
end;

class Procedure TClient.SendPacket(var Packet);
Var
  Buffer: Array of Byte;
  P: sHeader absolute Packet;
begin
  if SubStatus >= Deslogado then
  begin
    SetLength(Buffer, P.size);
    Move(Packet, Buffer[0], P.size);
    AddMessage(Buffer, P.size); //adc o packet
    SendMessageA; //Envia caso nao precisa acumular  }
  end;
end;

class Procedure TClient.SendData(packetCode: word; Data: VARIANT);
var
  signal: TSignalData;
begin
  ZeroMemory(@signal, sizeof(sHeader));
  signal.Header.size  := $10; // 16
  signal.Header.Index := TGame.ClientId;
  signal.Header.Code  := packetCode;
  signal.Data         := Data;
  SendPacket(signal)
end;

class Procedure TClient.SendData(packetCode: word; Data: Integer);
var
  signal: TSignalData;
begin
  ZeroMemory(@signal, sizeof(sHeader));
  signal.Header.size  := $10; // 16
  signal.Header.Index := TGame.ClientId;
  signal.Header.Code  := packetCode;
  signal.Data         := Data;
  SendPacket(signal)
end;

class Procedure TClient.SendSignal(packetCode: word; Insert: boolean = False);
var
  signal: sHeader;
begin
  ZeroMemory(@signal, sizeof(sHeader));
  signal.size  := $C;
  signal.Index := TGame.ClientId;
  signal.Code  := packetCode;

  if Not Insert then
  SendPacket(signal)
  else
  InsertPacket(100, signal);
end;

class Procedure TClient.SendSignal(packetCode, size: word);
var
  signal: sHeader;
begin
  ZeroMemory(@signal, sizeof(sHeader));
  signal.size  := size;
  signal.Index := TGame.ClientId;
  signal.Code  := packetCode;
  SendPacket(signal);
end;
{$ENDREGION}

{$REGION 'Thread'}
constructor TDesempaca.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpNormal;
  Resume;//  tpLower;       tpNormal
end;

procedure TDesempaca.Execute;
begin
  inherited;
   while not Terminated do
   begin
   TEncDec.ReadMessage;
   sleep(1);
   end;
end;
{$ENDREGION}

{$REGION 'initialization/finalization'}
initialization
 ClientSocket:= TClientSocket.Create(nil);
 ClientSocket.OnConnect    := TClient.Connected;
 ClientSocket.OnDisconnect := TClient.Disconnected;
 ClientSocket.OnRead       := TClient.Read;
 ClientSocket.OnError      := TClient.Error;
 ClientSocket.ClientType   := ctNonBlocking; // (ctNonBlocking, ctBlocking);
 vThread  := TDesempaca.Create;
 TClient.PortProxy:= 0;
finalization
ClientSocket.Free;
{$ENDREGION}

end.
