unit uLoad;

interface

uses Windows, SysUtils, Classes, MiscData, PlayerData;

type TLoad = class
  public
   class procedure ReadItemsList;
   class procedure ReadSkillData;
end;

implementation

Uses
 Func, Def;

class procedure TLoad.ReadItemsList;
var
 f : File of _TItemList;
 local : string;
begin
  local := GetCurrentDir+'\ItemList.bin';
  if (FileExists(local)) then begin
    try
      AssignFile(F,local);
      Reset(f);
      Read(f, ItemList);
      CloseFile(f);
    except
     on E: Exception do begin
       WriteLog(E.ClassName + ': ' + E.Message);
       CloseFile(F);
    end;
  end;

  WriteLog('ItemList Carregada');
end;
end;

class procedure TLoad.ReadSkillData;
function IsNumeric(str: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(str, Value, E);
  Result := E = 0;
end;
var DataFile : TextFile;
    lineFile : String;
    fileStrings : TStringList;
    skill: TSkillData;
    ProcName : string;
    skillId : Integer;
begin
  AssignFile(DataFile, 'Skilldata.csv');
  Reset(DataFile);
  fileStrings := TStringList.Create;

  while not EOF(DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','],[' '],PChar(Linefile),fileStrings);
    if(IsNumeric(fileStrings.strings[0], skillId) = false)then
    begin
      filestrings.Clear;
      continue;
    end;
    skill.Index := strtoint(fileStrings.Strings[0]);
    SkillData[skill.Index].Index             := fileStrings.Strings[00].ToInteger;
    SkillData[skill.Index].SkillPoint        := fileStrings.Strings[01].ToInteger;
    SkillData[skill.Index].TargetType        := fileStrings.Strings[02].ToInteger;
    SkillData[skill.Index].ManaSpent         := fileStrings.Strings[03].ToInteger;
    SkillData[skill.Index].Delay             := fileStrings.Strings[04].ToInteger;
    SkillData[skill.Index].Range             := fileStrings.Strings[05].ToInteger;
    SkillData[skill.Index].InstanceType      := fileStrings.Strings[06].ToInteger;
    SkillData[skill.Index].InstanceValue     := fileStrings.Strings[07].ToInteger;
    SkillData[skill.Index].TickType          := fileStrings.Strings[08].ToInteger;
    SkillData[skill.Index].TickValue         := fileStrings.Strings[09].ToInteger;
    SkillData[skill.Index].AffectType        := fileStrings.Strings[10].ToInteger;
    SkillData[skill.Index].AffectValue       := fileStrings.Strings[11].ToInteger;
    SkillData[skill.Index].AffectTime        := fileStrings.Strings[12].ToInteger;
//    SkillData[skill.Index].Act123            := fileStrings.Strings[13];
//    SkillData[skill.Index].Act123_2          := fileStrings.Strings[14];
   //  SkillData[skill.Index].InstanceAttribute := fileStrings.Strings[15];//////
    SkillData[skill.Index].TickAttribute     := fileStrings.Strings[16].ToInteger;
    SkillData[skill.Index].Aggressive        := fileStrings.Strings[17].ToInteger;
    SkillData[skill.Index].Maxtarget         := fileStrings.Strings[18].ToInteger;
    SkillData[skill.Index].PartyCheck        := fileStrings.Strings[19].ToInteger;
    SkillData[skill.Index].AffectResist      := fileStrings.Strings[20].ToInteger;
    SkillData[skill.Index].PassiveCheck      := fileStrings.Strings[21].ToInteger;
 //   SkillData[skill.Index].SkillName         := FilterSkData(fileStrings.Strings[22]);
    filestrings.Clear;
  end;
  fileStrings.Free;
  CloseFile(DataFile);
  WriteLog('Skilldata carregado com sucesso!');
end;


end.

