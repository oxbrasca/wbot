unit nDef;

interface

Uses
 Windows;

Const
 MAX_COMMANDS      = 2048;
 MAX_TIMER_PACKETS = 64;
 MAX_BUFFER_TIMER  = 2048;
 MAX_RECV          = $400;

// type TPacketID = (
  p_UpdateLeaders = $80D;
	p_SetFameNoatun = $C23;
	p_Disconnect = $3AE;
	p_DisconnectAccount = $40A;
	p_DisconnectAccountTM = $40B;
	p_StartTM = $C19;
	p_StartTMOK = $424;
	p_AttGuild = $C17;
	p_SetLeaderCity = $C18;
	p_SetKefraGuild = $C15;
	p_Celestial = $0C34;
	p_Trombeta = $D1D;
	p_Auxiliar = $D1E;
	p_InitGuild = $0C1B;
	p_ChangeChannel = $814;
	p_RequestWar = $E0E;
	p_RoomTimer = $3A1;
	p_RoomCounter = $3B0;
	p_RequestAlly = $E12;
	p_SendLeaders = $427;
	p_RecvSapphire = $80A;
	p_SendSapphire = $423;
	p_WarChannel = $ED7;
	p_BuyItemCash = $FDC;
	p_LockPassSuccess = $FDE;
	p_LockPassFail = $FDF;
	p_ClientLogin = $803;
	p_ClientReLogin = $808; //new packet login email
	p_LoginInexistent = $421;
	p_LoginBlocked = $425;
	p_LoginOtherComp = $406;
	p_LoginOnline = $420;
	p_LoginOnlineS = $41F;
	p_PasswordIncorrect = $422;
	p_Message = $404;
	p_DisconnectAcc = $805;
	p_CreateChar = $802;
	p_CreateCharSuccess = $418;
	p_CreateCharFail = $41D;
	p_DeleteChar = $809;
	p_DeleteCharFail = $041E;
	p_DeleteCharSuccess = $419;
	p_SubGuild = $3C1C;
	//p_UnkGuild = $3C1A;
	p_UpdateGuild = $3C16;
	p_MessageNPKO = $3409;
	p_SelectCharDB = $804;
	p_SaveChar = $807;
	p_SaveCharQuit = $806;
	p_OutSealFail = $431;
	p_OutSealComplete = $C30;
	p_PutSealFail = $42F;
	p_PutSealComplete = $C2E;
	p_SendCommand = $C2F;
	p_DonateResp = $405;
	p_SealInfo = $C32;
	p_ItemSend = $C0F;
	p_ChangeChannelInfo = $52A;
	p_CmdSend = $C0B;
	p_SelectCharFail = $41C;
	p_LoginSuccess = $416;
	p_SelectCharTM = $417;
	p_Quiz = $7B1;
	///* TM*///
	p_MobKilled = $165; //401884
	p_Spawn = $364;
	p_SpawnTrade = $363;
	p_Attack = $39D;
	p_AttackE = $39E;
	p_AttackArea = $367;
	p_ConquistandoAltar = $3AD;
	p_NpcCount = $3BB;
	p_Gold = $3AF;
	p_CNFMobKill = $338;
	p_Tick = $3A0;
	p_RequestLogin = $20D;
	p_Trade = $383;
	p_CreateTrade = $397;
	p_BuyItem = $398;
	p_SellItem = $37A;
	p_DropItem = $272;
	p_RequestCreateChar = $20F;
	p_RequestDeleteChar = $211;
	p_RequestSelectChar = $213;
	p_CreateCharSuccessTM = $110;
	p_CreateCharFailTM = $11A;
	p_DeleteCharFailTM = $11B;
	p_RequestBackToCharlist = $215;
	p_SendCharlistTM = $116;
	p_RequestNpcItems = $27B;
	p_SendNpcItems = $17C;
	p_RequestRevive = $289;
	p_RequestNpcClick = $28B;
	p_LoginSuccessTM = $10A;
	p_CharInfo = $114;
	p_CharInfoFailTM = $119;
	p_LoginOnlineTM = $11D;
	p_Move1 = $36C;
	p_Move2 = $366;
	p_DeleteCharSuccessTM = $112;
	p_SealInfoTM = $DC3;
	p_Weather = $18B;
	p_ChangeCity = $290;
	p_UpdateCity = $291;
	p_UpdateScore = $336;
	p_Summon1 = $3B3;
//  );

Type sTimerPacket = Record
   Time: Integer;
   Buffer: Array [0..MAX_BUFFER_TIMER]of byte;
End;


 var
  TimerPacket: Array [0..MAX_TIMER_PACKETS+1]of sTimerPacket;



implementation

begin
ZeroMemory(@TimerPacket, sizeof(TimerPacket));

end.
