unit Func;

interface

uses
 Windows, SysUtils,  Classes, StrUtils, mmsystem, DateUtils,
 Forms, Vcl.StdCtrls,
 tlhelp32;


type
 TByteArr   = array of byte;
 TByteArray = array of byte;

  function  KillTask(ExeFileName: string): integer;

  Procedure Delay     (MSeconds : LONGINT);
  function  Explode   (Str : STRING)    : TSTRINGLIST;
  function  LoadFile  (Archive: STRING): TSTRINGLIST;
  Function  BytesStr  (Buff : Array of Byte; Len: Word): String;
  function  GetServerIP:AnsiString;
  Function  AlterneChannel(Num: Word): String;
  procedure SaveToFile    (str, FileDir: string);
  function  CharArrayToString(chars: array of AnsiChar): string;
  function  bintoAscii(const bin: array of byte): AnsiString;
  Function  FilterSkdata(Str: String): String;
  Function  FilterStr(Str: String): String;
  Procedure WriteLog  (S : String);

  procedure SaveLog   (S: String);
  Function  ReplaceStr(Str: String): String;

  function  HourOf(const AValue: TDateTime): Word;
  function  MinuteOf: Word;
  function  SecOf: Word;
  Function  HourCTE(Min,Max: Word): Boolean;

  function  Randomstring(strLen: Integer): string;
  function  RandNick: AnsiString;

  Function  LerParemetro: Boolean;

  Function  InRange (Val, Lo, Hi: Integer) : Boolean;

  Procedure ReadGuide(Name: String;Memo:TMemo);
  Procedure GuideToMove(Memo:TMemo);
  procedure TrimAppMemorySize;
  Function  cTime: longInt;

implementation

Uses
Main,
MiscData, PlayerDAta, PathFinding,
Def ;

Function cTime: longInt;
begin
   result:= TimeGetTime;
// result:= MillisecondOfTheDay(now+1)+2200;
end;

procedure TrimAppMemorySize;
var
  MainHandle : THandle;
begin
    try
      MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
      SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
      CloseHandle(MainHandle) ;
    except
    end;
  Application.ProcessMessages;
end;

Procedure ReadGuide(Name: String;Memo:TMemo);
var
  FCount : integer;
  inFile: TFileStream;
  Route: Array [0..MAX_ROUTE] of zPosition;
  I: Integer;
begin
 inFile := TFileStream.Create(Name,  fmOpenRead);
 inFile.Read(Route[0],sizeof(Route));
 inFile.Free;
 Memo.Clear;

 for I := 0 to MAX_Route do
 if (Route[i].X > 0) or (Route[i].Y > 0) then
    Memo.Lines.add(Route[i].X.ToString+' '+Route[i].Y.ToString+' '+Route[i].Teleport.ToString)
    else
    Break;
end;

Procedure GuideToMove(Memo:TMemo);
var
  I: Integer;
begin
  TNode.Node;
  for I := 0 to Memo.Lines.Count-1 do
  if Memo.Lines[i] <> '' then
  begin
   TNode.Route[i].X       := SplitString(Memo.Lines[i], ' ')[0].ToInteger;
   TNode.Route[i].Y       := SplitString(Memo.Lines[i], ' ')[1].ToInteger;
   TNode.Route[i].Teleport:= SplitString(Memo.Lines[i], ' ')[2].ToBoolean;
  end;
  TNode.RouteCount:= I-1;
  TNode.Queue:= True;
end;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
 ContinueLoop: BOOL;
 FSnapshotHandle: THandle;
 FProcessEntry32: TProcessEntry32;
begin
 result := 0;
 FSnapshotHandle := CreateToolhelp32Snapshot
 (TH32CS_SNAPPROCESS, 0);
 FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
 ContinueLoop := Process32First(FSnapshotHandle,
 FProcessEntry32);
while integer(ContinueLoop) <> 0 do
begin
 if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
    UpperCase(ExeFileName))
or (UpperCase(FProcessEntry32.szExeFile) =
    UpperCase(ExeFileName))) then
 Result := Integer(TerminateProcess(OpenProcess(
 PROCESS_TERMINATE, BOOL(0),
 FProcessEntry32.th32ProcessID), 0));
 ContinueLoop := Process32Next(FSnapshotHandle,
 FProcessEntry32);
 end;
end;

Function InRange (Val, Lo, Hi: Integer) : Boolean;
Begin
 Result := (Val>=Lo)And(Val<=Hi);
End;

Function LerParemetro: Boolean;
begin
 Acc.ID          :=  ParamStr(1);
 Acc.Senha       :=  ParamStr(2);
 Acc.Senha2      :=  ParamStr(3);
 Acc.Slot        :=  StrToIntDef(ParamStr(4),0);
 Acc.Servidor    :=  ParamStr(5);
 Acc.ProxyIP     :=  ParamStr(6);

 if not Acc.ID.IsEmpty then
 Result := True
 else
 Result:= False;
end;

function RandNick: AnsiString;
begin
Randomize;
 case Random(6) of
  0: Result:= Randomstring(4)+'zh';
  1: Result:= Randomstring(4)+'tw';
  2: Result:= Randomstring(4)+'dx';
  4: Result:= 'at'  +Randomstring(4);
  5: Result:= Randomstring(2)+'l'+Randomstring(2);
  6: Result:= 'pi'+Randomstring(4);
   else
   Result:= 'bi'+Randomstring(2)+'pi'+Randomstring(2);
 end;
end;

function Randomstring(strLen: Integer): string;
var
str: string;
begin
Randomize;
str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
Result := '';
repeat
Result := Result + str[Random(Length(str)) + 1];
until (Length(Result) = strLen)
end;

Function HourCTE(Min,Max: Word): Boolean;
begin
  if (MinuteOf >=Min) and (MinuteOf <=Max) then
  Result:= True
  else
  Result:= False;
end;

function HourOf(const AValue: TDateTime): Word;
var
 LSecond, LMinute, LMilliSecond: Word;
begin
  DecodeTime(AValue, Result, LMinute, LSecond, LMilliSecond);
end;

function MinuteOf: Word;
var
  LHour, LSecond, LMilliSecond: Word;
begin
  DecodeTime(Now, LHour, Result, LSecond, LMilliSecond);
end;

function SecOf: Word;
var
  LHour, LMinute, LMilliSecond: Word;
begin
  DecodeTime(Now, LHour, LMinute, Result, LMilliSecond);
end;

Function ReplaceStr(Str: String): String;
begin
Result:= StringReplace(str    ,' ','',[rfReplaceAll]);
Result:= StringReplace(result ,'.','',[rfReplaceAll]);
Result:= StringReplace(result ,',','',[rfReplaceAll]);
end;

Procedure WriteLog(S : String);
begin
 BAD.mLog.Lines.Add(s);
end;

procedure SaveLog(S: String);
var
  NomeDoLog: string;
  Arquivo: TextFile;
begin
    NomeDoLog := 'log.txt';
    AssignFile(Arquivo, NomeDoLog);
 if FileExists(NomeDoLog) then
   	Append(arquivo)
    else
    ReWrite(arquivo);
  try
  WriteLn(arquivo,S);
  finally	CloseFile(arquivo)
  end;
end;

Function FilterStr(Str: String): String;
Var
 A,B : String;
begin
  A      := StringReplace(str ,#10 ,' ',[rfReplaceAll]);
  B      := StringReplace(A   ,#13 ,' ',[rfReplaceAll]);
  Result := StringReplace(B   ,'  ',' ',[rfReplaceAll]);
end;

Function FilterSkdata(Str: String): String;
Var
 ProcName : String;
begin
    ProcName := StringReplace(Str, 'ç', 'c', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'é', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ú', 'u', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'á', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'í', 'i', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ã', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ê', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, '_', '' , [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'â', 'a', [rfReplaceAll, rfIgnoreCase]);
   Result:= ProcName;
end;

function bintoAscii(const bin: array of byte): AnsiString;
var
 i: integer;
 A: String;
begin
  SetLength(Result, Length(bin));
  for i := 0 to Length(bin)-1 do
    Result[1+i] := AnsiChar(bin[i]);
end;

function CharArrayToString(chars: array of AnsiChar): string;
begin
  if (Length(chars) > 0) then
    SetString(Result, PAnsiChar(@chars[0]), Length(chars))
  else
    Result := '';

  Result := Trim(Result);
end;

procedure SaveToFile(str, FileDir: string);
var
  f: TextFile;
begin
  AssignFile(f, FileDir);
  begin
    Rewrite(f);
    CloseFile(f);
  end;
  Append(f);
  Writeln(f, str);
  Flush(f);
  CloseFile(f);
end;

{$REGION 'GETSERVIP'}
Function AlterneChannel(Num: Word): String;
begin
 Result:= GetServerIP;
end;

function GetServerIP:AnsiString;
begin
Result:= '127.0.0.1';
case AnsiIndexStr(uppercase(Acc.Servidor),
['ORIGEN_1','ORIGEN_2','ORIGEN_3','ORIGEN_4','ORIGEN_5',
 'ORIGEN_6','SD_1','SD_2'])
of
0: result  := ORIGEN_1;
1: result  := ORIGEN_2;
2: result  := ORIGEN_3;
3: result  := ORIGEN_4;
4: result  := ORIGEN_5;
5: result  := ORIGEN_6;
6:Begin
  Result:= SD_1;
  Acc.Versão:= 757;
  End;
7:Begin
  Result:= SD_2;
  Acc.Versão:= 757;
  End;
end;

end;
{$ENDREGION}

procedure Delay(MSeconds : LONGINT);
var
  Start, Stop: DWORD;
begin
  Start := cTime;//GetTickCount;
  repeat
    Stop := cTime;//GetTickCount;
    Application.ProcessMessages;
    Sleep(1);
  until (Stop - Start) >= MSeconds;
end;

Function BytesStr(Buff : Array of Byte; Len: Word): String;
Function ByteToHex(InByte:byte):String;
const
Digits: array[0..15] of char='0123456789ABCDEF';
begin
 result:=digits[InByte shr 4]+digits[InByte and $0F];
end;
Var
I : Integer;
begin
 Result:= '';
 for I := 0 to len-1 do
 begin
 Result := Result+' '+ByteTohex(Buff[i]);
 end;
end;

function Explode(Str : STRING) : TSTRINGLIST;
var
  P : INTEGER;
  Separador : STRING;
begin
  Separador := ' ';
  Result := TStringList.Create;
  P := Pos(Separador, Str);
  while (P > 0) do
  begin
    Result.Add(Copy(Str, 1, P-1));
    Delete(Str, 1, P + Length(Separador) - 1);
    p := Pos(Separador, Str);
  end;
  if (Str <> '') then Result.Add(Str);
end;

function LoadFile(Archive: STRING): TSTRINGLIST;
var
  fp : TEXTFILE;
  line, local : STRING;
begin
  local := ExtractFilePath(Application.ExeName);
  if FileExists(Local+Archive) then
  begin
    Result := TStringList.Create;
    AssignFile(fp, Local+Archive);
    Reset(fp);
    while not Eof(fp) do
    begin
      Readln(fp, line);
      Result.Add(line);
    end;
    CloseFile(fp);
  end;
end;

end.

