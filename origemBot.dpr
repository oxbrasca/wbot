program origemBot;

uses
  Windows,
  Vcl.Forms,
  Main in 'Main.pas' {BAD},
  CLSocket in 'CLSocket.pas',
  EncDec in 'EncDec.pas',
  PControl in 'PControl.pas',
  PacketHandlers in 'PacketHandlers.pas',
  Func in 'Func.pas',
  Def in 'Def.pas',
  Structs in 'Structs.pas',
  uPackets in 'uPackets.pas',
  MiscData in 'MiscData.pas',
  PlayerData in 'PlayerData.pas',
  uGame in 'Functions\uGame.pas',
  uItem in 'Functions\uItem.pas',
  uSkill in 'Functions\uSkill.pas',
  uClient in 'Functions\uClient.pas',
  PathFinding in 'Functions\PathFinding.pas',
  ProcessTimer in 'Functions\ProcessTimer.pas',
  uLoad in 'Functions\uLoad.pas',
  nClient in 'dh\nClient.pas',
  nDef in 'dh\nDef.pas',
  uMacros in 'Functions\uMacros.pas';

{$R *.res}

begin

if not LerParemetro then ExitProcess(0);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBAD, BAD);
  Application.Run;
end.
