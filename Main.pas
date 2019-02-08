unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,   StrUtils,
  Vcl.ComCtrls, Vcl.TabNotBk;

type
  TBAD = class(TForm)
    mLog: TMemo;
    alive: TTimer;
    Button6: TButton;
    Button8: TButton;
    Button9: TButton;
    TnPages: TTabbedNotebook;
    StatusG: TGroupBox;
    chAutoGrupo: TCheckBox;
    chRevive: TCheckBox;
    Button5: TButton;
    Button17: TButton;
    _charSlot: TLabeledEdit;
    GroupBox2: TGroupBox;
    Button10: TButton;
    vMove: TEdit;
    ListBox1: TListBox;
    Button11: TButton;
    mCoords: TMemo;
    Button12: TButton;
    GroupBox3: TGroupBox;
    chMagic: TCheckBox;
    chFis: TCheckBox;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    usItem: TLabeledEdit;
    Button1: TButton;
    listDelete: TComboBox;
    ChAutoBuff: TCheckBox;
    GroupBox1: TGroupBox;
    rdPerga: TRadioButton;
    rdRota: TRadioButton;
    RadioButton3: TRadioButton;
    clickCarb: TTimer;
    chEvok: TCheckBox;
    LabeledEdit2: TLabeledEdit;
    Button2: TButton;
    sPk: TTimer;
    onMob: TCheckBox;
    chAutoDrop: TCheckBox;
    Button3: TButton;
    listAmount: TComboBox;
    chAmount: TCheckBox;
    chLog: TCheckBox;
    Button7: TButton;
    Button20: TButton;
    _dSlot: TLabeledEdit;
    StatusHPMP: TLabel;
    Label1: TLabel;
    _oMob: TLabeledEdit;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    AtkFis: TTimer;
    chBuild: TCheckBox;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure clickCarbTimer(Sender: TObject);
    procedure aliveTimer(Sender: TObject);
    procedure sPkTimer(Sender: TObject);
    procedure chEvokClick(Sender: TObject);
    procedure ChAutoBuffClick(Sender: TObject);
    procedure chMagicClick(Sender: TObject);
    procedure chFisClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chAutoGrupoClick(Sender: TObject);
    procedure onMobClick(Sender: TObject);
    procedure chAutoDropClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure chAmountClick(Sender: TObject);
    procedure rdRotaClick(Sender: TObject);
    procedure rdPergaClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AtkFisTimer(Sender: TObject);
    procedure chBuildClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BAD: TBAD;

implementation

Uses
 uPackets, uLoad, Func, ProcessTimer, uClient, PathFinding, uItem,
 MiscData, PlayerData, uSKill, EncDec,
 CLSOcket, Def, nDef;

{$R *.dfm}

procedure TBAD.aliveTimer(Sender: TObject);
begin
  if(TGame.Session > USER_SELCHAR) then TsPackets.Tick;//4min
end;

procedure TBAD.AtkFisTimer(Sender: TObject);
begin
 if not Tnode.Queue and (TGame.Session = USER_PLAY) then
 begin
  if not TEncDec.CheckStamp(TGAme.Macro.DelayMs, 1000) then exit;
  if TGame.Hacks.onPhysic  and TSkill.Physical   then Exit;
 end;
end;

procedure TBAD.Button10Click(Sender: TObject);
var
  X, Y: Word;
begin
 X:= SplitString(vMove.Text, ' ')[0].ToInteger;
 Y:= SplitString(vMove.Text, ' ')[1].ToInteger;
 TsPackets.Moved(X, Y, 0);
end;

procedure TBAD.Button11Click(Sender: TObject);
begin
Listbox1.Items.Clear;
Listbox1.Perform(LB_DIR, DDL_ARCHIVE or DDL_DIRECTORY, LongInt(PChar('*.og*')));
end;

procedure TBAD.Button12Click(Sender: TObject);
begin
GuideToMove(mCoords);
end;

procedure TBAD.Button13Click(Sender: TObject);
begin
TGame.InfoInventory(mLog);
end;

procedure TBAD.Button14Click(Sender: TObject);
begin
TGame.InfoEquip(mLog);
end;

procedure TBAD.Button15Click(Sender: TObject);
begin
TGame.InfoCargo(mLog);
end;

procedure TBAD.Button16Click(Sender: TObject);
var
  ID, QTD: Word;
begin
 ID:=  StrToIntDef(SplitString(usItem.Text, ' ')[0], 0);
 QTD:= StrToIntDef(SplitString(usItem.Text, ' ')[1], 0);
 TDROP.UseItem(ID);
end;

procedure TBAD.Button17Click(Sender: TObject);
begin
TsPackets.charList;
Delay(100);
Acc.Slot:= StrToInt(_charSlot.text);
TsPackets.EnterWorld;
end;

procedure TBAD.Button1Click(Sender: TObject);
Var
 I: Integer;
begin
TDrop.InsertDrop(listDelete.Text);
//TDROP.TimerDrop;
end;

procedure TBAD.Button20Click(Sender: TObject);
begin
TsPackets.Erase(StrtoIntDef(_dSlot.text,$FF));
end;

procedure TBAD.Button2Click(Sender: TObject);
begin
TGame.Transform := SplitString(LabeledEdit2.Text, ' ')[0].ToInteger;
TGame.SetEvok   := SplitString(LabeledEdit2.Text, ' ')[1].ToInteger;

TGame.Hacks.RangerMagic := SplitString(LabeledEdit2.Text, ' ')[2].ToInteger;
TGame.Hacks.RangerPhysic:= SplitString(LabeledEdit2.Text, ' ')[3].ToInteger;
end;

procedure TBAD.Button3Click(Sender: TObject);
begin
//TDROP.InsertAmount(listAmount.Text);
StrPLCopy(TGAme.Hacks.sAmountList, listAmount.Text, Length(TGAme.Hacks.sAmountList));
TDROP.Amount(listAmount.Text);
end;

procedure TBAD.Button4Click(Sender: TObject);
begin
TsPackets.Inv(StrToInt(edit1.text),StrToInt(edit2.text));
end;

procedure TBAD.Button5Click(Sender: TObject);
begin
TsPackets.CharList;
end;

procedure TBAD.Button6Click(Sender: TObject);
begin
TrimAppMemorySize;
end;

procedure TBAD.Button7Click(Sender: TObject);
begin
TsPackets.EnterWorld;
end;

procedure TBAD.chAmountClick(Sender: TObject);
begin
 //TDROP.InsertAmount(listAmount.Text);
 StrPLCopy(TGAme.Hacks.sAmountList, listAmount.Text, Length(TGAme.Hacks.sAmountList));
 TGame.Hacks.onAmount:= chAmount.Checked;
end;

procedure TBAD.ChAutoBuffClick(Sender: TObject);
begin
TGame.Hacks.Buff:= ChAutoBuff.Checked;
end;

procedure TBAD.chAutoDropClick(Sender: TObject);
begin
 TDrop.InsertDrop(listDelete.Text);
 TGame.Hacks.ondrop:= chAutoDrop.Checked;
end;

procedure TBAD.chAutoGrupoClick(Sender: TObject);
begin
TGame.Hacks.Party := chAutoGrupo.Checked;
end;

procedure TBAD.chBuildClick(Sender: TObject);
begin
TGame.Hacks.onBuild:= chBuild.Checked;
end;

procedure TBAD.chEvokClick(Sender: TObject);
begin
TGame.Hacks.Evok := chEvok.Checked;
end;

procedure TBAD.chFisClick(Sender: TObject);
begin
TGame.Hacks.onPhysic:= chFis.Checked;
//TGame.wait_recv[p_Attack]:= 0;
end;

procedure TBAD.chMagicClick(Sender: TObject);
begin
TGame.Hacks.onMagic:= chMagic.Checked;
//TGame.wait_recv[p_Attack]:= 0;
end;

procedure TBAD.clickCarbTimer(Sender: TObject);
begin
  TEncDec.getTimerRecv;
end;

procedure TBAD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
TClient.SendSignal($3AE);
end;

procedure TBAD.FormShow(Sender: TObject);
Var
 vThread : TProcessSecTimer;
 thAtk   : TProcessAtk;
begin
 BAD.Caption := Acc.ID +' '+ Acc.Servidor;
 SubStatus   := Deslogado;
 TGame.Session := USER_EMPTY;
 vThread     := TProcessSecTimer.Create;
 thAtk       := TProcessAtk.Create;
 Alive.Interval:= (4*(1000*60))-5000;
 //AllocConsole;
 TLoad.ReadSkillData;
 TLoad.ReadItemsList;
 TGame.start;


end;

procedure TBAD.ListBox1Click(Sender: TObject);
begin
ReadGuide(listBox1.Items[ListBox1.ItemIndex], mCoords);
end;

procedure TBAD.onMobClick(Sender: TObject);
begin
//if _oMob.text = '' then exit;
TSkill.InsertMob(_oMob.text);
TGame.Hacks.onMob:= onMob.Checked;
end;

procedure TBAD.rdPergaClick(Sender: TObject);
begin
TGame.Hacks.pDead_Perga:= rdPerga.Checked;
end;

procedure TBAD.rdRotaClick(Sender: TObject);
begin
TGame.Hacks.pDead_Route:= rdRota.Checked;
end;

procedure TBAD.sPkTimer(Sender: TObject);
Var
 I: Integer;
begin
 if SubStatus >= Logando then
 begin
   for I := 0 to MAX_TIMER_PACKETS do
   if(TimerPacket[i].time > 0) and
     (TimerPacket[i].time <= cTime) then
   begin
    TClient.SendPacket(TimerPacket[i].Buffer);
    ZeroMemory(@TimerPacket[i], sizeof(sTimerPacket));
    Break;
   end;
 end;
end;

procedure TBAD.Timer1Timer(Sender: TObject);
var
 I: integer;
begin
 if SubStatus = Ingame then
for i := 0 to 999 do
 if (TGame.players[i].index >0) and CheckBox1.checked then
 begin
 TsPackets.MyBug(TGame.players[i].index,  11,26);
 delay(10);
 end;

end;

end.
