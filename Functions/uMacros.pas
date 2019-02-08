unit uMacros;

interface

Uses
 Windows, SysUtils,
  uClient, PathFinding;

  {1..35 = campo treinamento
  36..39 armia
  40..115 = Coveiro
  116..191 = jardim}

type TMacros = class(TGame)
Public
 Class Procedure SetMacro;
 Class Function NPCQuest:word;


end;

implementation

Uses
 Func;

{face coveiro =   58    //index 1010 SD
68 01 00 00 //merchant


 face jardim  = 66
 C8 00 00 00  //merchant
 pos: 2224 1715



 4117; Caixa_da_Sabedoria;
 4118; Lágrima_Angelical;
 4119; Coração_do_Kaizen;
 4120; Olho_de_Sangue;
 4121; Pedra_Espiritual_dos_Elfos;
}

{ TMacros }
class function TMacros.NPCQuest: word;
begin
case Mob.Status.Level of
39..115: Result:= 58;
116..190: Result:= 66;
end;
end;

class procedure TMacros.SetMacro;
begin
//Randomize;
//TNode.Node
Delay(300);
if InRange(Mob.Status.Level,0,35) then
 begin
  case Random(5) of
        0:TNode.LoadRouter('dropnewb2.og');
        1:TNode.LoadRouter('dropnewb3.og');
        2:TNode.LoadRouter('dropnewb5.og');
        3:TNode.LoadRouter('dropnewb4.og');
        4:TNode.LoadRouter('dropnewb5.og');
        5:TNode.LoadRouter('dropnewb5.og');
  end;


 end
 else
 case Random(8) of
        0:TNode.LoadRouter('CrillSpot1.og');
        1:TNode.LoadRouter('CrillSpot2.og');
        2:TNode.LoadRouter('CrillSpot3.og');
        3:TNode.LoadRouter('CrillSpot1.og');
        4:TNode.LoadRouter('CrillSpot2.og');
        5:TNode.LoadRouter('CrillSpot3.og');
        6:TNode.LoadRouter('CrillSpot1.og');
        7:TNode.LoadRouter('CrillSpot2.og');
        8:TNode.LoadRouter('CrillSpot2.og');
 end;



 TNode.Queue:= True;


 WriteLog(Mob.Status.Level.toString);
end;

end.
