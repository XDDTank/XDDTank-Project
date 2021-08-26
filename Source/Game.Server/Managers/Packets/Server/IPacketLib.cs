using System.Collections.Generic;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using Game.Server.Packets;
using Game.Server.Rooms;
using Game.Server.GameUtils;
using Game.Server.SceneMarryRooms;
//using Game.Server.HotSpringRooms;
using Game.Server.Quests;
using Game.Server.Buffer;

namespace Game.Base.Packets
{
    public interface IPacketLib
    {
        GSPacketIn SendActivityList(int ID);
        void SendWeaklessGuildProgress(PlayerInfo player);
        GSPacketIn SendGetBoxTime(int ID, int receiebox, bool result);
        #region Consortia
        GSPacketIn SendConsortiaCreate(string name1, bool result, int id, string name2, string msg, int dutyLevel, string DutyName, int dutyRight, int playerid);
        GSPacketIn SendConsortiaRichesOffer(int money, bool result, string msg, int playerid);
        GSPacketIn SendConsortiaInvite(string username, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaInvitePass(int id, bool result, int consortiaid, string consortianame, string msg, int playerid);
        GSPacketIn sendConsortiaInviteDel(int id, bool result, string msg, int playerid);
        GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaTryIn(int id, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaTryInPass(int id, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaTryInDel(int id, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaUpdateDescription(string description, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaEquipConstrol(bool result, List<int> Riches, int playerid);
        GSPacketIn SendConsortiaMemberGrade(int id, bool update, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaOut(int id, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaChangeChairman(string nick, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaUpdatePlacard(string description, bool result, string msg, int playerid);
        GSPacketIn sendConsortiaApplyStatusOut(bool state, bool result, int playerid);
        GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid);
        #endregion

        #region Farm Members
        GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm);
        GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields);
        GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field);
        GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field);
        GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field);
        GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds);
        void SendPetGuildOptionChange();
        #endregion
        void SendOpenWorldBoss();
        GSPacketIn SendDiceActiveOpen(int ID);
 

        void SendLittleGameActived();
        void SendTCP(GSPacketIn packet);
        void SendLoginSuccess();        
        void SendCheckCode();
        void SendLoginFailed(string msg);
        void SendKitoff(string msg);
        void SendEditionError(string msg);
        
        GSPacketIn SendGameMissionStart();
        GSPacketIn SendGameMissionPrepare();
        GSPacketIn SendRefreshPet(GamePlayer player, UsersPetinfo[] pets, ItemInfo[] items, bool refreshBtn);//, bool FinishQuest, int MaxActiveSkillCount, int MaxStaticSkillCount, int MaxSkillCount);
        void SendDateTime();
        //发送当前用户是否可以接收每日赠送
        GSPacketIn SendDailyAward(GamePlayer player);
        void SendPingTime(GamePlayer player);
        void SendUpdatePrivateInfo(PlayerInfo info);
        GSPacketIn SendUpdatePlayerProperty(PlayerInfo info);
        GSPacketIn SendUpdatePublicPlayer(PlayerInfo info);
        GSPacketIn SendNetWork(GamePlayer player, long delay);
        GSPacketIn SendUserEquip(PlayerInfo info, List<ItemInfo> items);
        GSPacketIn SendMessage(eMessageType type, string message);

        GSPacketIn SendGetPlayerCard(int playerId);
        GSPacketIn SendPlayerCardReset(PlayerInfo player, List<int> points);
        void SendPlayerCardSlot(PlayerInfo info, List<UsersCardInfo> cardslots);
        GSPacketIn SendPlayerCardSlot(PlayerInfo player, UsersCardInfo card);
        GSPacketIn SendPlayerCardSoul(PlayerInfo player, bool isSoul, int soul);
        GSPacketIn SendGetCard(PlayerInfo info, UsersCardInfo card);
        void SendPlayerCardInfo(CardInventory bag, int[] updatedSlots);
        GSPacketIn SendUpdatePetInfo(PlayerInfo info, UsersPetinfo[] pets);
        GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots);        
        GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid);
        //房间列表
        void SendWaitingRoom(bool result);
        GSPacketIn SendUpdateRoomList(List<BaseRoom> room);
        GSPacketIn SendSceneAddPlayer(GamePlayer player);
        GSPacketIn SendSceneRemovePlayer(GamePlayer player);
        GSPacketIn SendOpenHoleComplete(GamePlayer player, int type, bool result);
        //房间
        GSPacketIn SendRoomCreate(BaseRoom room);
        GSPacketIn SendRoomLoginResult(bool result);
        GSPacketIn SendRoomPlayerAdd(GamePlayer player);
        GSPacketIn SendRoomPlayerRemove(GamePlayer player);
        GSPacketIn SendRoomUpdatePlayerStates(byte[] states);
        GSPacketIn SendRoomUpdatePlacesStates(int[] states);
        GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player);
        GSPacketIn SendRoomPairUpStart(BaseRoom room);
        GSPacketIn SendRoomPairUpCancel(BaseRoom room);
        GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style);
        GSPacketIn SendRoomChange(BaseRoom room);
        //熔炼
        GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isBind, int MinValid);
        GSPacketIn SendFusionResult(GamePlayer player, bool result);
        //炼化
        GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind,ItemInfo item);

        //背包
        void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots);

        GSPacketIn SendAddFriend(PlayerInfo user, int relation, bool state);
        GSPacketIn SendFriendRemove(int FriendID);
        GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel);
        GSPacketIn SendUpdateAllData(PlayerInfo player);
        //
        GSPacketIn SendGetSpree(PlayerInfo player);
        //
        GSPacketIn SendUpdateUpCount(PlayerInfo player);
        GSPacketIn SendPlayerRefreshTotem(PlayerInfo player);
        //
        GSPacketIn SendLabyrinthUpdataInfo(int ID);
        GSPacketIn SendTrusteeshipStart(int ID);
        GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems);
        GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir);
        //Buffer
        GSPacketIn SendUpdateBuffer(GamePlayer player, BufferInfo[] infos);
        GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos);
        
        //任务
        GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] quests);
        GSPacketIn SendMailResponse(int playerID, eMailRespose type);
        GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item);
        GSPacketIn SendIDNumberCheck(bool result);
        GSPacketIn SendConsortiaMail(bool result, int playerid);
        //防沉迷
        GSPacketIn SendAASState(bool result);
        GSPacketIn SendAASInfoSet(bool result);
        GSPacketIn SendAASControl(bool result, bool IsAASInfo, bool IsMinor);

        //GSPacketIn SendHotSpringRoomInfo(GamePlayer player, HotSpringRoom[] room);
        GSPacketIn SendOpenVIP(PlayerInfo Player);
       // void SendOpenWorldBoss();
        GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist);
        
        GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room);

        GSPacketIn SendPlayerEnterMarryRoom(Game.Server.GameObjects.GamePlayer player);

        GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried);

        GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation,int ID);

        GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer);

        GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant,int ID);

        GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player);
        void SendDragonBoat(PlayerInfo info);


        GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result);

        GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info);

        GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info);

        GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info);
       
        GSPacketIn SendContinuation(GamePlayer player, HotSpringRoomInfo hotSpringRoomInfo);

        GSPacketIn SendMarryProp(GamePlayer player, MarryProp info);

        GSPacketIn SendRoomType(GamePlayer player, BaseRoom game);
    }
}
