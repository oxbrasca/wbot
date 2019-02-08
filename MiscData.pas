unit MiscData;


interface

Uses
 Windows;

Const
 g_pBuffsId : array [0..3, 0..6, 0..1] of Integer =
(((5, 17) ,(11, 13),(3, 14),(0, 0),(0, 0),(0, 0),(0, 0)),
((37, 22),(41, 2),(43, 11),(44, 9),(45, 15),(46, 18),(0, 0)),
((53, 25),(54, 23),(64, 16),(66, 16),(68, 16),(70, 16),(71, 16)),
((75, 27),(76, 19),(77, 21),(81, 37),(87, 38),(0, 0),(0, 0)));


 	g_pDistanceTable: array [0..6,0..6] of byte=//[7][7] =
 ((0, 1, 2, 3, 4, 5, 6),
	(1, 1, 2, 3, 4, 5, 6),
	(2, 2, 3, 4, 4, 5, 6),
	(3, 3, 4, 4, 5, 5, 6),
	(4, 4, 4, 5, 5, 5, 6),
	(5, 5, 5, 5, 5, 6, 6),
	(6, 6, 6, 6, 6, 6, 6));

 pots: Array [0..1]of Array[0..2] of Word =
 ((3322, 404, 3431),
	(3323, 409, 3431));

 MAX_X = 4095;//200;
 MAX_Y = 4095;//200;
 MIN_X = 0;//-200;
 MIN_Y = 0;//-200;

 TK = 0;
 FM = 1;
 BM = 2;
 HT = 3;

 USER_EMPTY       =   0;
 USER_ACCEPT      =   1;
 USER_LOGIN       =   2;
 USER_SELCHAR     =  11;
 USER_CHARWAIT    =  12;
 USER_CREWAIT     =  13;
 USER_DELWAIT     =  14;
 USER_PLAY        =  22;
 MAX_AFFECT		   	=	 32-1;
 MAX_MOVE         =  12;
 MAX_ROUTE        = $FF;
 CLOCKS_PER_SEC   = 1000;  //1000000    1000
 CLOCKS_PER_MIL   = 100;
 DELAY_VELO       = 800; //300 sem dc
 DELAY_PADRAO     = 1;
 SKIPCHECKTICK		=	235543242; //$E0A1ACA base number for the tick checking so people don't get kicked out before doing something
 TRANS_SK         = 10;
 MAX_ENEMY			  = 12;//10

 MAX_MobGrid      = 200;

 MAX_ITEMLIST		  = 6500;
 MAX_EFFECT_NAME  = 256;

 MAX_MESH_BUFFER  = 16;
 MAX_SCORE_BUFFER = 32;
 MAX_EFFECT       = 12;

 MAX_PLAYER	      = 750;
 INIT_SPAWN_MOB 	= 999;
 MAX_SPAWN_MOB	  =	30000;

 MAX_SKILLDATA	  = 128;

 EQUIP_TYPE	     	= 0;
 INV_TYPE		      = 1;
 STORAGE_TYPE	    = 2;

type TPosition = Record
	X:  smallint;
	Y:  smallint;
end;

Type zPosition = Packed Record
  X:  smallint;
	Y:  smallint;
  Teleport: Boolean;
End;

type TMerchant = Record
 Merchant : byte;
 Direction: byte;
end;

type TMove = Record
 Move   : shortint;
 Attack : shortint;
End;

type st_Target = Record
  index,null: Word; //CD 02 CC CC
  Damage : Integer;
End;

type TItemEffect = Record
  Index, Value : BYTE;
End;

type TPacketAffect = Record
  Index, Time : Byte;
End;

Type st_Affect = Record
 Index,
 Master: BYTE;
 Value:	WORD;
 Time: DWORD;
End;

{ index: BYTE;
	Master: BYTE;
	Value: smallint;
	Time: integer;}

type TItem = record
  id: Word;
  Effects : array[0..2] of TItemEffect;
end;

Var
 Power : array[0..4] of integer = (220, 250, 280, 320, 370);

implementation


end.


