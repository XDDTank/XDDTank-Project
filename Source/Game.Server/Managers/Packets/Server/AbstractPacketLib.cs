using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using Game.Server.GameObjects;
using Game.Server.Managers;
using SqlDataProvider.Data;
using Game.Server;
using Game.Server.Packets;
using Bussiness;
using Game.Server.Rooms;
using Game.Server.GameUtils;
using Game.Server.SceneMarryRooms;
//using Game.Server.HotSpringRooms;
using Game.Server.Quests;
using Game.Server.Buffer;
using System.Configuration;
//using Game.Logic;

namespace Game.Base.Packets
{
    [PacketLib(1)]
    public class AbstractPacketLib : IPacketLib
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected readonly GameClient m_gameClient;

        public AbstractPacketLib(GameClient client)
        {
            m_gameClient = client;
        }
        #region Farm Members
        public GSPacketIn SendEnterFarm(PlayerInfo Player, UserFarmInfo farm, UserFieldInfo[] fields)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.ID);
            packet.WriteByte((byte)FarmPackageType.ENTER_FARM);
            packet.WriteInt(farm.FarmID);//_model.currentFarmerId = _loc_2.readInt();
            packet.WriteBoolean(farm.isFarmHelper);// _loc_3:* = _loc_2.readBoolean(); isFarmHelper/isAutomatic
            packet.WriteInt(farm.isAutoId);// _loc_4:* = _loc_2.readInt(); isAutoId/autoSeedID
            packet.WriteDateTime(farm.AutoPayTime);// _loc_5:* = _loc_2.readDate();//startdate
            packet.WriteInt(farm.AutoValidDate);// _loc_6:* = _loc_2.readInt();//_autoTime
            packet.WriteInt(farm.GainFieldId);// _loc_7:* = _loc_2.readInt();//_needSeed
            packet.WriteInt(farm.KillCropId);// _loc_8:* = _loc_2.readInt();//_getSeed

            packet.WriteInt(fields.Length);// _loc_9:* = _loc_2.readInt();//field count
            foreach (UserFieldInfo field in fields)
            {
                packet.WriteInt(field.FieldID);//_loc_11 = _loc_2.readInt();//fieldID
                packet.WriteInt(field.SeedID);//_loc_12 = _loc_2.readInt();//seedID :332112
                packet.WriteDateTime(field.PayTime);//_loc_13 = _loc_2.readDate();//payTime
                packet.WriteDateTime(field.PlantTime);//_loc_14 = _loc_2.readDate();//plantTime
                packet.WriteInt(field.GainCount);//_loc_15 = _loc_2.readInt();//gainCount
                packet.WriteInt(field.FieldValidDate);//_loc_16 = _loc_2.readInt();//fieldValidDate
                packet.WriteInt(field.AccelerateTime);//_loc_17 = _loc_2.readInt();//AccelerateTime  
            }
            if (farm.FarmID == Player.ID)
            {
                packet.WriteString(farm.PayFieldMoney);//_model.payFieldMoney = _loc_2.readUTF();
                packet.WriteString(farm.PayAutoMoney);//_model.payAutoMoney = _loc_2.readUTF();
                packet.WriteDateTime(farm.AutoPayTime);//_model.autoPayTime = _loc_2.readDate();
                packet.WriteInt(farm.AutoValidDate);//_model.autoValidDate = _loc_2.readInt();
                packet.WriteInt(Player.VIPLevel);//_model.vipLimitLevel = _loc_2.readInt(); of player
                packet.WriteInt(20);//_model.buyExpRemainNum = _loc_2.readInt(); 7road
            }
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendHelperSwitchField(PlayerInfo Player, UserFarmInfo farm)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.ID);
            packet.WriteByte((byte)FarmPackageType.HELPER_SWITCH_FIELD);
            packet.WriteBoolean(farm.isFarmHelper);// _loc_3:* = _loc_2.readBoolean(); isFarmHelper/isAutomatic
            packet.WriteInt(farm.isAutoId);// _loc_4:* = _loc_2.readInt(); isAutoId/autoSeedID
            packet.WriteDateTime(farm.AutoPayTime);// _loc_5:* = _loc_2.readDate();//startdate
            packet.WriteInt(farm.AutoValidDate);// _loc_6:* = _loc_2.readInt();//_autoTime
            packet.WriteInt(farm.GainFieldId);// _loc_7:* = _loc_2.readInt();//_needSeed
            packet.WriteInt(farm.KillCropId);// _loc_8:* = _loc_2.readInt();//_getSeed
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendSeeding(PlayerInfo Player, UserFieldInfo field)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.ID);
            packet.WriteByte((byte)FarmPackageType.GROW_FIELD);
            packet.WriteInt(field.FieldID);//_loc_3:* = fieldId.readInt();
            packet.WriteInt(field.SeedID);// _loc_4:* = seedID.readInt();
            packet.WriteDateTime(field.PlantTime);// _loc_5:* = plantTime.readDate();
            packet.WriteDateTime(field.PayTime);// _loc_6:* = _loc_2.readDate();
            packet.WriteInt(field.GainCount);// _loc_7:* = gainCount.readInt();
            packet.WriteInt(field.FieldValidDate);// _loc_8:* = _loc_2.readInt();
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendPayFields(GamePlayer Player, List<int> fieldIds)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.PlayerCharacter.ID);
            packet.WriteByte((byte)FarmPackageType.PAY_FIELD);
            packet.WriteInt(Player.PlayerCharacter.ID);
            packet.WriteInt(fieldIds.Count);// _loc_9:* = _loc_2.readInt();//field count
            foreach (int id in fieldIds)
            {
                UserFieldInfo field = Player.Farm.GetFieldAt(id);
                packet.WriteInt(field.FieldID);//_loc_11 = _loc_2.readInt();//fieldID
                packet.WriteInt(field.SeedID);//_loc_12 = _loc_2.readInt();//seedID :332112
                packet.WriteDateTime(field.PayTime);//_loc_13 = _loc_2.readDate();//payTime
                packet.WriteDateTime(field.PlantTime);//_loc_14 = _loc_2.readDate();//plantTime
                packet.WriteInt(field.GainCount);//_loc_15 = _loc_2.readInt();//gainCount
                packet.WriteInt(field.FieldValidDate);//_loc_16 = _loc_2.readInt();//fieldValidDate
                packet.WriteInt(field.AccelerateTime);//_loc_17 = _loc_2.readInt();//AccelerateTime
            }
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendKillCropField(PlayerInfo Player, UserFieldInfo field)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.ID);
            packet.WriteByte((byte)FarmPackageType.KILLCROP_FIELD);
            packet.WriteBoolean(true);
            packet.WriteInt(field.FieldID);//_loc_3:* = fieldId.readInt();
            packet.WriteInt(field.SeedID);// _loc_4:* = seedID.readInt();
            packet.WriteInt(field.AccelerateTime);// _loc_8:* = _loc_2.readInt();
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn sendCompose(GamePlayer Player)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.PlayerCharacter.ID);
            packet.WriteByte((byte)FarmPackageType.COMPOSE_FOOD);
            SendTCP(packet);
            return packet;
        }

        public GSPacketIn SenddoMature(GamePlayer Player)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.PlayerCharacter.ID);
            packet.WriteByte((byte)FarmPackageType.ACCELERATE_FIELD);
            //pkg.readBoolean();            
            //.model.matureId = event.pkg.readInt();
            //_loc_3.gainCount = event.pkg.readInt();
            //_loc_3.AccelerateTime = event.pkg.readInt();
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendtoGather(PlayerInfo Player, UserFieldInfo field)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.FARM, Player.ID);
            packet.WriteByte((byte)FarmPackageType.GAIN_FIELD);
            packet.WriteBoolean(true);//var _loc_3:* = event.pkg.readBoolean();
            packet.WriteInt(field.FieldID);//model.gainFieldId = event.pkg.readInt();
            packet.WriteInt(field.SeedID);//_loc_2.seedID = event.pkg.readInt();
            packet.WriteDateTime(field.PlantTime);//_loc_2.plantTime = event.pkg.readDate();
            packet.WriteInt(field.GainCount);//_loc_2.gainCount = event.pkg.readInt();
            packet.WriteInt(field.AccelerateTime);//_loc_2.AccelerateTime = event.pkg.readInt();
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendDiceActiveOpen(int ID)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.DICE_SYSTEM, ID);
            packet.WriteByte(1);
            packet.WriteInt(0);
            packet.WriteInt(100);
            packet.WriteInt(15);
            packet.WriteInt(20);
            packet.WriteInt(30);
            packet.WriteInt(10);
            packet.WriteInt(1);
            for (int i = 0; i < 1; i++)
            {
                packet.WriteInt(0);
                packet.WriteInt(20);
                for (int j = 0; j < 20; j++)
                {
                    packet.WriteInt(7048);
                    packet.WriteInt(1);
                }
            }
            this.SendTCP(packet);
            return packet;
        }

 

 

        public void SendPetGuildOptionChange()
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.OPTION_CHANGE);
            packet.WriteBoolean(true);
            packet.WriteInt(8);
            SendTCP(packet);
            //return packet;
        }
        #endregion
        #region WorldBoss
        public GSPacketIn SendNewPacket(GamePlayer Player)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
            packet.WriteByte((byte)WorldBossPackageType.OPEN);
           
            SendTCP(packet);
            return packet;
        }
        public void SendOpenWorldBoss()
        {
            //GSPacketIn packet = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            //packet.WriteByte((byte)WorldBossPackageType.OPEN);
            //packet.WriteString("4");//this._bossResourceId = event.pkg.readUTF();
            //packet.WriteInt(30004);//_currentPVE_ID = event.pkg.readInt();
            //packet.WriteString("Fuck");//event.pkg.readUTF();
            //packet.WriteString("Fuck");//_bossInfo.name = event.pkg.readUTF();
            //packet.WriteLong(8000000000);//_bossInfo.total_Blood = event.pkg.readLong();
            ////  packet.WriteLong(RoomMgr.WorldBossRoom.MaxBlood);

            //packet.WriteInt(5);//var _loc_2:* = event.pkg.readInt();
            //packet.WriteInt(5);//var _loc_3:* = event.pkg.readInt();
            //packet.WriteInt(1);
            ////for
            //packet.WriteInt(800); packet.WriteInt(560);//_bossInfo.playerDefaultPos = new Point(event.pkg.readInt(), event.pkg.readInt());
            ////}
            //packet.WriteDateTime(DateTime.Now);//_bossInfo.begin_time = event.pkg.readDate();
            //packet.WriteDateTime(DateTime.Now.AddDays(1));//_bossInfo.end_time = event.pkg.readDate();
            //packet.WriteInt(450);//_bossInfo.fight_time = event.pkg.readInt();
            //packet.WriteBoolean(false);//_bossInfo.fightOver = event.pkg.readBoolean();
            //packet.WriteBoolean(false);//_bossInfo.roomClose = event.pkg.readBoolean();
            //packet.WriteInt(11573);//_bossInfo.ticketID = event.pkg.readInt();
            //packet.WriteInt(0);//_bossInfo.need_ticket_count = event.pkg.readInt();
            //packet.WriteInt(30);//_bossInfo.timeCD = event.pkg.readInt();
            //packet.WriteInt(30);//_bossInfo.reviveMoney = event.pkg.readInt();

            //packet.WriteInt(1);//var _loc_4:* = event.pkg.readInt();
            ////while (_loc_5 < _loc_4)
            ////{  
            //packet.WriteInt(1);    //_loc_6.ID = event.pkg.readInt();
            //packet.WriteString("Tăng dame");    //_loc_6.name = event.pkg.readUTF();
            //packet.WriteInt(30);    //_loc_6.price = event.pkg.readInt();
            //packet.WriteString("Tăng dame gấp 10000 lần");    //_loc_6.decription = event.pkg.readUTF();  
            //packet.WriteInt(1);//_loc_8.costID = event.pkg.readInt();
            ////}
            //packet.WriteBoolean(true);//_isShowBlood = event.pkg.readBoolean();
            //packet.WriteBoolean(false);//_autoBlood = event.pkg.readBoolean();
            //SendTCP(packet);
            //return packet;
            string[] strArray = new string[] { "Cuồng long", "Bá tước Hắc Ám", "Đội trưởng" };
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            packet.WriteByte(0);
            packet.WriteString("4");
            packet.WriteInt(30004);
            packet.WriteString("Thần thú");
            packet.WriteString(strArray[2]);
            packet.WriteLong(RoomMgr.WorldBossRoom.MaxBlood);
            packet.WriteInt(0);
            packet.WriteInt(0);
            packet.WriteInt(1);
            packet.WriteInt(265);
            packet.WriteInt(1030);
            packet.WriteDateTime(DateTime.Now);
            packet.WriteDateTime(DateTime.Now.AddDays(1.0));
            packet.WriteInt(60);
            packet.WriteBoolean(false);
            packet.WriteBoolean(false);
            packet.WriteInt(11573);
            packet.WriteInt(0);
            packet.WriteInt(15);
            packet.WriteInt(10);
            packet.WriteInt(12);
            packet.WriteInt(30);
            packet.WriteInt(200);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteString("Tăng Sát Thương");
            packet.WriteInt(30);
            packet.WriteString("Sát thương cơ bản tăng 200.");
            packet.WriteInt(-1);
            packet.WriteBoolean(true);
            packet.WriteBoolean(false);
            this.SendTCP(packet);

        }
        #endregion
        #region 
        //new
        #endregion
        public void SendLittleGameActived()
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.LITTLEGAME_ACTIVED);
            packet.WriteBoolean(true);
            SendTCP(packet);
            //return packet;
        }
        //public GSPacketIn SendNewPacketDragonBoat(GamePlayer Player)
        //{
        //    GSPacketIn packet = new GSPacketIn((byte)ePackageType.DRAGON_BOAT, Player.PlayerCharacter.ID);
        //    packet.WriteByte((byte)DragonBoatPackageType.START_OR_CLOSE);

        //    SendTCP(packet);
        //    return packet;
        //}
        public void SendDragonBoat(PlayerInfo info)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.DRAGON_BOAT, info.ID);
         
            packet.WriteInt(1);
            int _loc_4 = 0;
            while (_loc_4 < 1) ;
            {
                packet.WriteInt(1);
                packet.WriteInt(1);
                packet.WriteString("a");
                _loc_4++;

            }
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1250000);
            packet.WriteInt(1);
            packet.WriteInt(1000);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            packet.WriteInt(1);
            
            this.SendTCP(packet);
        }
        public GSPacketIn SendContinuation(GamePlayer player, HotSpringRoomInfo hotSpringRoomInfo)
        {
            throw new NotImplementedException();
        }
        /*
        public GSPacketIn SendHotSpringRoomInfo(GamePlayer player, HotSpringRoom[] allHotRoom)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.HOTSPRING_ROOM_LIST_GET, player.PlayerCharacter.ID);
            packet.WriteInt(allHotRoom.Length);
            foreach (HotSpringRoom room in allHotRoom)
            {
                packet.WriteInt(room.Info.RoomNumber);
                packet.WriteInt(room.Info.RoomID);
                packet.WriteString(room.Info.RoomName);
                packet.WriteString(room.Info.Pwd);
                packet.WriteInt(room.Info.AvailTime);
                packet.WriteInt(room.Count);
                packet.WriteInt(player.PlayerCharacter.ID);
                packet.WriteString(player.PlayerCharacter.UserName);
                packet.WriteDateTime(room.Info.BeginTime);
                packet.WriteString(room.Info.RoomIntroduction);
                packet.WriteInt(room.Info.RoomType);
                packet.WriteInt(room.Info.MaxCount);
            }
            SendTCP(packet);
            return packet;
        }*/
        public GSPacketIn SendOpenVIP(PlayerInfo Player)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.VIP_RENEWAL, Player.ID);
            packet.WriteByte(Player.typeVIP);
            packet.WriteInt(Player.VIPLevel);
            packet.WriteInt(Player.VIPExp);
            packet.WriteDateTime(Player.VIPExpireDay);
            packet.WriteDateTime(Player.LastVIPPackTime);
            packet.WriteInt(Player.VIPNextLevelDaysNeeded);
            packet.WriteBoolean(Player.CanTakeVipReward);
            SendTCP(packet);
            return packet;
        }
        public GSPacketIn SendGetBoxTime(int ID, int receiebox, bool result)
        {
            GSPacketIn packet = new GSPacketIn((byte)ePackageType.GET_TIME_BOX, ID);
            packet.WriteBoolean(result);
            packet.WriteInt(receiebox);
            SendTCP(packet);
            return packet;
        }
        public static IPacketLib CreatePacketLibForVersion(int rawVersion, GameClient client)
        {
            foreach (Type t in ScriptMgr.GetDerivedClasses(typeof(IPacketLib)))
            {
                foreach (PacketLibAttribute attr in t.GetCustomAttributes(typeof(PacketLibAttribute), false))
                {
                    if (attr.RawVersion == rawVersion)
                    {
                        try
                        {
                            IPacketLib lib = (IPacketLib)Activator.CreateInstance(t, client);
                            return lib;
                        }
                        catch (Exception e)
                        {
                            if (log.IsErrorEnabled)
                                log.Error("error creating packetlib (" + t.FullName + ") for raw version " + rawVersion, e);
                        }
                    }
                }
            }
            return null;
        }

        public void SendTCP(GSPacketIn packet)
        {
            m_gameClient.SendTCP(packet);
        }
        public void SendWeaklessGuildProgress(PlayerInfo player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.USER_ANSWER, player.ID);
            /*
            byte[] _weaklessGuildProgress = Base64.decodeToByteArray(player.WeaklessGuildProgressStr);
            pkg.WriteInt(_weaklessGuildProgress.Length);            
            for (int i = 0; i < _weaklessGuildProgress.Length; i++)
            {
                pkg.WriteByte(_weaklessGuildProgress[i]);
            }
            */
            pkg.WriteInt(player.weaklessGuildProgress.Length);
            for (int i = 0; i < player.weaklessGuildProgress.Length; i++)
            {
                pkg.WriteByte(player.weaklessGuildProgress[i]);
            }
            SendTCP(pkg);
        }  
        public void SendLoginFailed(string msg)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LOGIN);
            pkg.WriteByte(1);
            pkg.WriteString(msg);
            SendTCP(pkg);
        }
               
        public void SendLoginSuccess()
        {
            if (m_gameClient.Player == null)
                return;

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LOGIN, m_gameClient.Player.PlayerCharacter.ID);
            pkg.WriteByte(0);
            pkg.WriteInt(4);//_loc_3.ZoneID = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Attack);//_loc_3.Attack = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Defence);//_loc_3.Defence = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Agility); //_loc_3.Agility = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Luck);//_loc_3.Luck = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.GP);//_loc_3.GP = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Repute);//_loc_3.Repute = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Gold);//_loc_3.Gold = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Money);//_loc_3.Money = _loc_2.readInt();
            pkg.WriteInt(0);//7road;
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.GiftToken);//_loc_3.DDTMoney = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Score);//_loc_3.Score = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Hide);//_loc_3.Hide = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.FightPower);//_loc_3.FightPower = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.apprenticeshipState
            pkg.WriteInt(0);//_loc_3.masterID            
            pkg.WriteString("");// _loc_3.setMasterOrApprentices
            pkg.WriteInt(0);//_loc_3.graduatesCount
            pkg.WriteString("");//_loc_3.honourOfMaster
            pkg.WriteDateTime(DateTime.Now.AddDays(50));//_loc_3.freezesDate = _loc_2.readDate();
            pkg.WriteByte(m_gameClient.Player.PlayerCharacter.typeVIP); //_loc_3.typeVIP = _loc_2.readByte();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.VIPLevel);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.VIPExp);
            pkg.WriteDateTime(m_gameClient.Player.PlayerCharacter.VIPExpireDay);
            pkg.WriteDateTime(m_gameClient.Player.PlayerCharacter.LastDate);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.VIPNextLevelDaysNeeded);//_loc_3.VIPNextLevelDaysNeeded = _loc_2.readInt();
            pkg.WriteDateTime(DateTime.Now);// _loc_3.systemDate = _loc_2.readDate();
            pkg.WriteBoolean(m_gameClient.Player.PlayerCharacter.CanTakeVipReward);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.OptionOnOff);//_loc_3.OptionOnOff = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.AchievementPoint);
            pkg.WriteString("");// _loc_3.honor = _loc_2.readUTF();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.OnlineTime);
            pkg.WriteBoolean(m_gameClient.Player.PlayerCharacter.Sex);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.Style + "&" + m_gameClient.Player.PlayerCharacter.Colors);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.Skin);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaID);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.ConsortiaName);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.badgeID);//_loc_3.badgeID = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.DutyLevel);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.DutyName);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Right);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.ChairmanName);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaHonor);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.ConsortiaRiches);
            pkg.WriteBoolean(m_gameClient.Player.PlayerCharacter.HasBagPassword);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.PasswordQuest1);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.PasswordQuest2);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.FailedPasswordAttemptCount);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.UserName);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Nimbus);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.PvePermission);
            pkg.WriteString(m_gameClient.Player.PlayerCharacter.FightLabPermission);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.AnswerSite);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.receiebox);//receiebox = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.receieGrade);//receieGrade = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.needGetBoxTime);//needGetBoxTime = _loc_2.readInt();
            pkg.WriteDateTime(m_gameClient.Player.PlayerCharacter.LastSpaDate);
            pkg.WriteDateTime(DateTime.Now);//_loc_3.shopFinallyGottenTime = _loc_2.readDate();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.RichesOffer);//_loc_3.UseOffer = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.dailyScore = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.dailyWinCount = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.dailyGameCount = _loc_2.readInt();
            pkg.WriteBoolean(false);//_loc_3.DailyLeagueFirst = _loc_2.readBoolean();
            pkg.WriteInt(0);//_loc_3.DailyLeagueLastScore = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.weeklyScore = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.weeklyGameCount = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_3.matchInfo.weeklyRanking = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.spdTexpExp);//_loc_3.spdTexpExp = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.attTexpExp);//_loc_3.attTexpExp = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.defTexpExp);//_loc_3.defTexpExp = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.hpTexpExp);//_loc_3.hpTexpExp = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.lukTexpExp);//_loc_3.lukTexpExp = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.texpTaskCount);//_loc_3.texpTaskCount = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.Texp.texpCount);//_loc_3.texpCount = _loc_2.readInt();
            pkg.WriteDateTime(m_gameClient.Player.PlayerCharacter.Texp.texpTaskDate);//_loc_3.texpTaskDate = _loc_2.readDate();
            pkg.WriteBoolean(m_gameClient.Player.PlayerCharacter.isOldPlayerHasValidEquitAtLogin);//_loc_3.isOldPlayerHasValidEquitAtLogin = _loc_2.readBoolean();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.badLuckNumber);//_loc_3.badLuckNumber = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.luckyNum);//_loc_3.luckyNum = _loc_2.readInt();
            pkg.WriteDateTime(m_gameClient.Player.PlayerCharacter.lastLuckyNumDate);//_loc_3.lastLuckyNumDate = _loc_2.readDate();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.lastLuckNum);//_loc_3.lastLuckNum = _loc_2.readInt();
            pkg.WriteBoolean(m_gameClient.Player.PlayerCharacter.IsOldPlayer);//_loc_3.isOld = _loc_2.readBoolean();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.CardSoul);//_loc_3.CardSoul = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.uesedFinishTime);//_loc_3.uesedFinishTime = _loc_2.readInt();
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.totemId);//_loc_3.totemId = _loc_2.readInt(); 7road
            SendTCP(pkg);
        }
       
        public void SendRSAKey(byte[] m, byte[] e)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.RSAKEY);
            pkg.Write(m);
            pkg.Write(e);
            SendTCP(pkg);
        }

        public void SendCheckCode()
        {
            if (m_gameClient.Player == null || m_gameClient.Player.PlayerCharacter.CheckCount < GameProperties.CHECK_MAX_FAILED_COUNT)
                return;

            if (m_gameClient.Player.PlayerCharacter.CheckError == 0)
            {
                m_gameClient.Player.PlayerCharacter.CheckCount += 10000;
            }

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CHECK_CODE, m_gameClient.Player.PlayerCharacter.ID, 10240);
            // pkg.WriteBoolean(true);
            if (m_gameClient.Player.PlayerCharacter.CheckError < 1)
            {
                pkg.WriteByte(0);
            }
            else
            {
                pkg.WriteByte(2);
            }
            pkg.WriteBoolean(true);
            m_gameClient.Player.PlayerCharacter.CheckCode = CheckCode.GenerateCheckCode();
            pkg.Write(CheckCode.CreateImage(m_gameClient.Player.PlayerCharacter.CheckCode));

            //string[] codes = CheckCode.GenerateCheckCode(4);
            //int index = ThreadSafeRandom.NextStatic(codes.Length);
            //m_gameClient.Player.PlayerCharacter.CheckIndex = index + 1;
            //for (int i = 0; i < codes.Length; i++)
            //{
            //    pkg.WriteString(codes[i]);
            //}

            //pkg.Write(CheckCode.CreateCheckCodeImage(codes[index]));
            SendTCP(pkg);
        }

        public void SendKitoff(string msg)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.KIT_USER);
            pkg.WriteString(msg);
            SendTCP(pkg);
        }

        public void SendEditionError(string msg)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.EDITION_ERROR);
            pkg.WriteString(msg);
            SendTCP(pkg);
        }

        public void SendWaitingRoom(bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SCENE_LOGIN);
            pkg.WriteByte((byte)(result ? 1 : 0));
            SendTCP(pkg);
        }

        public GSPacketIn SendPlayerState(int id, byte state)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CHANGE_STATE, id);
            pkg.WriteByte(state);
            SendTCP(pkg);
            return pkg;
        }

        public virtual GSPacketIn SendMessage(eMessageType type, string message)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SYS_MESSAGE);
            pkg.WriteInt((int)type);
            pkg.WriteString(message);
            SendTCP(pkg);
            return pkg;
        }

        public void SendReady()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.BUFF_INFO);
            SendTCP(pkg);
        }

        public void SendUpdatePrivateInfo(PlayerInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.UPDATE_PRIVATE_INFO, info.ID);
            pkg.WriteInt(info.Money);
            pkg.WriteInt(info.GiftToken); //this._self.DDTMoney = event.pkg.readInt();
            pkg.WriteInt(0);//event.pkg.readInt(); 7road
            pkg.WriteInt(info.Score);//this._self.Score = event.pkg.readInt();
            pkg.WriteInt(info.Gold);
            pkg.WriteInt(info.badLuckNumber);//_self.badLuckNumber = event.pkg.readInt();
            pkg.WriteInt(info.damageScores);//_self.damageScores = event.pkg.readInt(); 
            //if (ServerConfigManager.instance.petScoreEnable)
            //{
            pkg.WriteInt(info.petScore);//_self.petScore = event.pkg.readInt(); 7road
            //}
            pkg.WriteInt(info.myHonor);//_self.myHonor = event.pkg.readInt(); 7road
            pkg.WriteInt(info.hardCurrency);//_self.hardCurrency = event.pkg.readInt(); 7road
            SendTCP(pkg);
        }
        public GSPacketIn SendUpdatePlayerProperty(PlayerInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.UPDATE_PLAYER_PROPERTY, info.ID);
            pkg.WriteInt(info.ID);
            //for each (_loc_7 in _loc_3)
            for (int i = 0; i < 4; i++)
            {
                pkg.WriteInt(0);    //_loc_2.readInt();
                pkg.WriteInt(0);    //_loc_5["Texp"] = _loc_2.readInt();
                pkg.WriteInt(0);    //_loc_5["Card"] = _loc_2.readInt();
                pkg.WriteInt(0);    //_loc_5["Pet"] = _loc_2.readInt();
                pkg.WriteInt(0);    //_loc_5["Suit"] = _loc_2.readInt();
                pkg.WriteInt(0);    //_loc_5["gem"] = _loc_2.readInt(); 7road;
            }
            pkg.WriteInt(0);//_loc_2.readInt();
            pkg.WriteInt(0);//_loc_5["Texp"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_5["Pet"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_5["Suit"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_5["gem"] = _loc_2.readInt(); 7road;

            pkg.WriteInt(0);//_loc_5["Suit"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_5["Suit"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_4["Damage"]["Bead"] = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_4["Armor"]["Bead"] = _loc_2.readInt();
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendUpdatePublicPlayer(PlayerInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.UPDATE_PLAYER_INFO, info.ID);
            pkg.WriteInt(info.GP);
            pkg.WriteInt(info.Offer);
            pkg.WriteInt(info.RichesOffer);
            pkg.WriteInt(info.RichesRob);
            pkg.WriteInt(info.Win);
            pkg.WriteInt(info.Total);
            pkg.WriteInt(info.Escape);
            pkg.WriteInt(info.Attack);
            pkg.WriteInt(info.Defence);
            pkg.WriteInt(info.Agility);
            pkg.WriteInt(info.Luck);
            pkg.WriteInt(info.hp);//info.hp = pkg.readInt();
            pkg.WriteInt(info.Hide);
            pkg.WriteString(info.Style);
            pkg.WriteString(info.Colors);
            pkg.WriteString(info.Skin);
            pkg.WriteBoolean(info.IsShowConsortia);//info.IsShowConsortia = pkg.readBoolean();
            pkg.WriteInt(info.ConsortiaID);
            pkg.WriteString(info.ConsortiaName);
            pkg.WriteInt(info.badgeID);//info.badgeID = pkg.readInt();
            pkg.WriteInt(0);//unknown1 = pkg.readInt();
            pkg.WriteInt(0);//unknown2 = pkg.readInt(); 
            pkg.WriteInt(info.Nimbus);
            pkg.WriteString(info.PvePermission);
            pkg.WriteString(info.FightLabPermission);
            pkg.WriteInt(info.FightPower);
            pkg.WriteInt(0);//apprenticeshipState = pkg.readInt();
            pkg.WriteInt(0);//masterID = pkg.readInt();
            pkg.WriteString("");//setMasterOrApprentices(pkg.readUTF());
            pkg.WriteInt(0);//graduatesCount = pkg.readInt();
            pkg.WriteString("");//honourOfMaster = pkg.readUTF();
            pkg.WriteInt(info.AchievementPoint);
            pkg.WriteString(""); //honor = pkg.readUTF();
            pkg.WriteDateTime((DateTime)info.LastSpaDate);
            pkg.WriteInt(0);//charmgp
            pkg.WriteInt(0); //unknown3 = pkg.readInt();
            pkg.WriteDateTime(DateTime.Now); //info.shopFinallyGottenTime
            pkg.WriteInt(info.RichesOffer);//info.UseOffer = pkg.readInt();
            pkg.WriteInt(0);//info.matchInfo.dailyScore = pkg.readInt();
            pkg.WriteInt(0);//info.matchInfo.dailyWinCount = pkg.readInt();
            pkg.WriteInt(0);//info.matchInfo.dailyGameCount = pkg.readInt();
            pkg.WriteInt(0);//info.matchInfo.weeklyScore = pkg.readInt();
            pkg.WriteInt(0);//info.matchInfo.weeklyGameCount = pkg.readInt();
            pkg.WriteInt(info.Texp.spdTexpExp);//info.spdTexpExp = pkg.readInt();
            pkg.WriteInt(info.Texp.attTexpExp);//info.attTexpExp = pkg.readInt();
            pkg.WriteInt(info.Texp.defTexpExp);//info.defTexpExp = pkg.readInt();
            pkg.WriteInt(info.Texp.hpTexpExp);//info.hpTexpExp = pkg.readInt();
            pkg.WriteInt(info.Texp.lukTexpExp);//info.lukTexpExp = pkg.readInt();
            pkg.WriteInt(info.Texp.texpTaskCount);//info.texpTaskCount = pkg.readInt();
            pkg.WriteInt(info.Texp.texpCount);//info.texpCount = pkg.readInt();
            pkg.WriteDateTime(info.Texp.texpTaskDate);//info.texpTaskDate = pkg.readDate();
            pkg.WriteInt(9);//len = pkg.readInt();
            for (int i = 1; i < 10; i++)
            {
                pkg.WriteInt(i);//mapId = pkg.readInt();
                pkg.WriteByte(10);//flag = pkg.readByte();
            }
            SendTCP(pkg);
            return pkg;
        }
        public void SendPingTime(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PING);
            player.PingStart = DateTime.Now.Ticks;
            pkg.WriteInt(player.PlayerCharacter.AntiAddiction);
            SendTCP(pkg);
        }

        public GSPacketIn SendNetWork(GamePlayer player, long delay)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NETWORK, player.PlayerId);
            pkg.WriteInt((int)delay / 1000 / 10);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendUserEquip(PlayerInfo player, List<ItemInfo> items)
        {
            if (m_gameClient.Player == null)
                return null;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_EQUIP, m_gameClient.Player.PlayerCharacter.ID, 10240);
            pkg.WriteInt(player.ID);
            pkg.WriteString(player.NickName);
            pkg.WriteInt(player.Agility);
            pkg.WriteInt(player.Attack);
            pkg.WriteString(player.Colors);
            pkg.WriteString(player.Skin);
            pkg.WriteInt(player.Defence);
            pkg.WriteInt(player.GP);
            pkg.WriteInt(player.Grade);
            pkg.WriteInt(player.Luck);
            pkg.WriteInt(player.hp);//_loc_5.hp = _loc_2.readInt();
            pkg.WriteInt(player.Hide);
            pkg.WriteInt(player.Repute);
            pkg.WriteBoolean(player.Sex);
            pkg.WriteString(player.Style);
            pkg.WriteInt(player.Offer);
            pkg.WriteByte(player.typeVIP);
            pkg.WriteInt(player.VIPLevel);
            pkg.WriteInt(player.Win);
            pkg.WriteInt(player.Total);
            pkg.WriteInt(player.Escape);
            pkg.WriteInt(player.ConsortiaID);
            pkg.WriteString(player.ConsortiaName);
            pkg.WriteInt(player.badgeID);//_loc_5.badgeID = _loc_2.readInt();
            pkg.WriteInt(player.RichesOffer);
            pkg.WriteInt(player.RichesRob);
            pkg.WriteBoolean(player.IsMarried);
            pkg.WriteInt(player.SpouseID);
            pkg.WriteString(player.SpouseName);
            pkg.WriteString(player.DutyName);
            pkg.WriteInt(player.Nimbus);
            pkg.WriteInt(player.FightPower);
            pkg.WriteInt(0);//apprenticeshipState = _loc_2.readInt();
            pkg.WriteInt(0);//masterID = _loc_2.readInt();
            pkg.WriteString("");//setMasterOrApprentices(_loc_2.readUTF());
            pkg.WriteInt(0);//graduatesCount = _loc_2.readInt();
            pkg.WriteString("");//honourOfMaster = _loc_2.readUTF();
            pkg.WriteInt(player.AchievementPoint);//
            pkg.WriteString("");//honor = _loc_2.readUTF();
            pkg.WriteDateTime(DateTime.Now.AddDays(-2));
            pkg.WriteInt(player.Texp.spdTexpExp);    //_loc_5.spdTexpExp = _loc_2.readInt();
            pkg.WriteInt(player.Texp.attTexpExp);    //_loc_5.attTexpExp = _loc_2.readInt();
            pkg.WriteInt(player.Texp.defTexpExp);    //_loc_5.defTexpExp = _loc_2.readInt();
            pkg.WriteInt(player.Texp.hpTexpExp);    //_loc_5.hpTexpExp = _loc_2.readInt();
            pkg.WriteInt(player.Texp.lukTexpExp);    //_loc_5.lukTexpExp = _loc_2.readInt();
            pkg.WriteBoolean(false);    //_loc_5.DailyLeagueFirst = _loc_2.readBoolean();
            pkg.WriteInt(0);    //_loc_5.DailyLeagueLastScore = _loc_2.readInt();
            pkg.WriteInt(player.totemId);//_loc_5.totemId = _loc_2.readInt(); 7road
            pkg.WriteInt(items.Count);
            foreach (ItemInfo info in items)
            {
                pkg.WriteByte((byte)info.BagType);
                pkg.WriteInt(info.UserID);
                pkg.WriteInt(info.ItemID);
                pkg.WriteInt(info.Count);
                pkg.WriteInt(info.Place);
                pkg.WriteInt(info.TemplateID);
                pkg.WriteInt(info.AttackCompose);
                pkg.WriteInt(info.DefendCompose);
                pkg.WriteInt(info.AgilityCompose);
                pkg.WriteInt(info.LuckCompose);
                pkg.WriteInt(info.StrengthenLevel);
                pkg.WriteBoolean(info.IsBinds);
                pkg.WriteBoolean(info.IsJudge);
                pkg.WriteDateTime(info.BeginDate);
                pkg.WriteInt(info.ValidDate);
                pkg.WriteString(info.Color);
                pkg.WriteString(info.Skin);
                pkg.WriteBoolean(info.IsUsed);
                pkg.WriteInt(info.Hole1);
                pkg.WriteInt(info.Hole2);
                pkg.WriteInt(info.Hole3);
                pkg.WriteInt(info.Hole4);
                pkg.WriteInt(info.Hole5);
                pkg.WriteInt(info.Hole6);
                pkg.WriteString(info.Template.Pic);
                pkg.WriteInt(info.Template.RefineryLevel);
                pkg.WriteDateTime(DateTime.Now);
                pkg.WriteByte((byte)info.Hole5Level);
                pkg.WriteInt(info.Hole5Exp);
                pkg.WriteByte((byte)info.Hole6Level);
                pkg.WriteInt(info.Hole6Exp);
                if (info.IsGold)
                {
                    pkg.WriteBoolean(info.IsGold);//_loc_8.isGold = _loc_2.readBoolean();
                    pkg.WriteInt(info.goldValidDate);//_loc_8.goldValidDate = _loc_2.readInt();
                    pkg.WriteDateTime(info.goldBeginTime);//_loc_8.goldBeginTime = _loc_2.readDateString();
                }
                else { pkg.WriteBoolean(false); }
                pkg.WriteString(info.latentEnergyCurStr);//item.latentEnergyCurStr = pkg.readUTF(); 7road
                pkg.WriteString(info.latentEnergyNewStr);//item.latentEnergyNewStr = pkg.readUTF(); 7road
                pkg.WriteDateTime(info.latentEnergyEndTime);//item.latentEnergyEndTime = pkg.readDate(); 7road
            }
            //--------------------------------------
            pkg.WriteInt(0);
            /*
            pkg.WriteInt(items.Count);
            foreach (ItemInfo info in items)
            {
                pkg.WriteByte((byte)info.BagType);
                pkg.WriteInt(info.UserID);
                pkg.WriteInt(info.ItemID);
                pkg.WriteInt(info.Count);
                pkg.WriteInt(info.Place);
                pkg.WriteInt(info.TemplateID);
                pkg.WriteInt(info.AttackCompose);
                pkg.WriteInt(info.DefendCompose);
                pkg.WriteInt(info.AgilityCompose);
                pkg.WriteInt(info.LuckCompose);
                pkg.WriteInt(info.StrengthenLevel);
                pkg.WriteBoolean(info.IsBinds);
                pkg.WriteBoolean(info.IsJudge);
                pkg.WriteDateTime(info.BeginDate);
                pkg.WriteInt(info.ValidDate);
                pkg.WriteString(info.Color);
                pkg.WriteString(info.Skin);
                pkg.WriteBoolean(info.IsUsed);
                pkg.WriteInt(info.Hole1);
                pkg.WriteInt(info.Hole2);
                pkg.WriteInt(info.Hole3);
                pkg.WriteInt(info.Hole4);
                pkg.WriteInt(info.Hole5);
                pkg.WriteInt(info.Hole6);
                pkg.WriteString(info.Template.Pic);
                pkg.WriteInt(info.Template.RefineryLevel);
                pkg.WriteDateTime(DateTime.Now);
                pkg.WriteByte((byte)info.Hole5Level);
                pkg.WriteInt(info.Hole5Exp);
                pkg.WriteByte((byte)info.Hole6Level);
                pkg.WriteInt(info.Hole6Exp);
                pkg.WriteBoolean(info.IsGold);//_loc_8.isGold = _loc_2.readBoolean();
                    
            }
             */ 
            pkg.WriteInt(0);//_loc_10 = _loc_2.readInt(); Gemston count 7road
            //for()
            //_loc_14.figSpiritId = _loc_2.readInt();
            //_loc_15 = _loc_2.readUTF(); "0,0,0|0,0,1|0,0,2" => "lv,exp,place|lv,exp,place"
            //_loc_14.equipPlace = _loc_2.readInt();
            pkg.Compress();
            SendTCP(pkg);
            return pkg;
        }

        public void SendDateTime()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SYS_DATE);
            pkg.WriteDateTime(DateTime.Now);
            SendTCP(pkg);
        }

        /// <summary>
        /// 给用户每日赠送物品
        /// </summary>
        /// <param name="player"></param>
        /// <returns></returns>
        public GSPacketIn SendDailyAward(GamePlayer player)
        {
            bool result = false;
            if (DateTime.Now.Date != player.PlayerCharacter.LastAward.Date)
            {
                result = true;
            }
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.DAILY_AWARD, player.PlayerCharacter.ID);
            pkg.WriteBoolean(result);
            pkg.WriteInt(0);
            SendTCP(pkg);
            return pkg;

        }

        #region IPacketLib 房间列表        
        
        public GSPacketIn SendUpdateRoomList(List<BaseRoom> roomlist)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.ROOMLIST_UPDATE);
            pkg.WriteInt(roomlist.Count);
            var length = roomlist.Count < 8 ? roomlist.Count : 8;
            pkg.WriteInt(length);
            for (int i = 0; i < roomlist.Count; i++)
            {
                BaseRoom room = roomlist[i];
                pkg.WriteInt(room.RoomId);
                pkg.WriteByte((byte)room.RoomType);
                pkg.WriteByte((byte)room.TimeMode);
                pkg.WriteByte((byte)room.PlayerCount);
                pkg.WriteByte((byte)room.viewerCnt);//_loc_7.viewerCnt = _loc_3.readByte();
                pkg.WriteByte((byte)room.maxViewerCnt);//_loc_7.maxViewerCnt = _loc_3.readByte();
                pkg.WriteByte((byte)room.PlacesCount);
                pkg.WriteBoolean(string.IsNullOrEmpty(room.Password) ? false : true);
                pkg.WriteInt(room.MapId);
                pkg.WriteBoolean(room.IsPlaying);
                pkg.WriteString(room.Name);
                pkg.WriteByte((byte)room.GameType);
                pkg.WriteByte((byte)room.HardLevel);
                pkg.WriteInt(room.LevelLimits);
                pkg.WriteBoolean(room.isOpenBoss);//_loc_7.isOpenBoss = _loc_3.readBoolean();
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendSceneAddPlayer(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SCENE_ADD_USER, player.PlayerCharacter.ID);
            pkg.WriteInt(player.PlayerCharacter.Grade);
            pkg.WriteBoolean(player.PlayerCharacter.Sex);
            pkg.WriteString(player.PlayerCharacter.NickName);
            pkg.WriteByte(player.PlayerCharacter.typeVIP);
            pkg.WriteInt(player.PlayerCharacter.VIPLevel);
            pkg.WriteString(player.PlayerCharacter.ConsortiaName);
            pkg.WriteInt(player.PlayerCharacter.Offer);
            pkg.WriteInt(player.PlayerCharacter.Win);
            pkg.WriteInt(player.PlayerCharacter.Total);
            pkg.WriteInt(player.PlayerCharacter.Escape);
            pkg.WriteInt(player.PlayerCharacter.ConsortiaID);
            pkg.WriteInt(player.PlayerCharacter.Repute);
            pkg.WriteBoolean(player.PlayerCharacter.IsMarried);

            if (player.PlayerCharacter.IsMarried)
            {
                pkg.WriteInt(player.PlayerCharacter.SpouseID);// player.SpouseID = pkg.readInt();
                pkg.WriteString(player.PlayerCharacter.SpouseName);// player.SpouseName = pkg.readUTF();
            }

            pkg.WriteString(player.PlayerCharacter.UserName); //player.LoginName = pkg.readUTF();
            pkg.WriteInt(player.PlayerCharacter.FightPower);
            pkg.WriteInt(0);//apprenticeshipState = _loc_2.readInt();
            pkg.WriteBoolean(player.PlayerCharacter.IsOldPlayer);//isOld = _loc_2.readBoolean();
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendSceneRemovePlayer(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.SCENE_REMOVE_USER, player.PlayerCharacter.ID);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendGameMissionStart()
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_MISSION_START);
            pkg.WriteBoolean(true);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendGameMissionPrepare()
        {
            GSPacketIn pkg = new GSPacketIn((byte)Game.Logic.eTankCmdType.GAME_MISSION_PREPARE);
            pkg.WriteBoolean(true);
            SendTCP(pkg);
            return pkg;
        }
        #endregion

        #region IPacketLib 房间

        public GSPacketIn SendRoomPlayerAdd(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM, player.PlayerId);//GAME_PLAYER_ENTER            
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_ADDPLAYER);

            bool isInGame = false;
            if (player.CurrentRoom.Game != null)
            {
                isInGame = true;
            }

            pkg.WriteBoolean(isInGame);
            pkg.WriteByte((byte)player.CurrentRoomIndex);
            pkg.WriteByte((byte)player.CurrentRoomTeam);
            pkg.WriteBoolean(true);//_loc_2.readBoolean();//isFirstIn 
            pkg.WriteInt(player.PlayerCharacter.Grade);
            pkg.WriteInt(player.PlayerCharacter.Offer);
            pkg.WriteInt(player.PlayerCharacter.Hide);
            pkg.WriteInt(player.PlayerCharacter.Repute);
            pkg.WriteInt((int)player.PingTime / 1000 / 10);
            pkg.WriteInt(4); //pkg.WriteInt(player.ServerID); 
            pkg.WriteInt(player.PlayerCharacter.ID);
            pkg.WriteString(player.PlayerCharacter.NickName);
            pkg.WriteByte(player.PlayerCharacter.typeVIP);
            pkg.WriteInt(player.PlayerCharacter.VIPLevel);
            pkg.WriteBoolean(player.PlayerCharacter.Sex);
            pkg.WriteString(player.PlayerCharacter.Style);
            pkg.WriteString(player.PlayerCharacter.Colors);
            pkg.WriteString(player.PlayerCharacter.Skin);
            ItemInfo item = player.MainBag.GetItemAt(6);
            pkg.WriteInt(item == null ? 7008 : item.TemplateID);
            if (player.SecondWeapon == null)
            {
                pkg.WriteInt(0);
            }
            else
            {
                pkg.WriteInt(player.SecondWeapon.TemplateID);
            }
            pkg.WriteInt(player.PlayerCharacter.ConsortiaID);
            pkg.WriteString(player.PlayerCharacter.ConsortiaName);
            pkg.WriteInt(player.PlayerCharacter.badgeID);//_loc_14.badgeID = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Win);
            pkg.WriteInt(player.PlayerCharacter.Total);
            pkg.WriteInt(player.PlayerCharacter.Escape);
            pkg.WriteInt(0);//_loc_16 = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_17 = _loc_2.readInt();
            pkg.WriteBoolean(player.PlayerCharacter.IsMarried);
            if (player.PlayerCharacter.IsMarried)
            {
                pkg.WriteInt(player.PlayerCharacter.SpouseID);
                pkg.WriteString(player.PlayerCharacter.SpouseName);
            }
            pkg.WriteString(player.PlayerCharacter.UserName);
            pkg.WriteInt(player.PlayerCharacter.Nimbus);
            pkg.WriteInt(player.PlayerCharacter.FightPower);
            pkg.WriteInt(0);//apprenticeshipState = _loc_2.readInt();
            pkg.WriteInt(0);//masterID = _loc_2.readInt();
            pkg.WriteString("Master");//setMasterOrApprentices(_loc_2.readUTF());
            pkg.WriteInt(0);//graduatesCount = _loc_2.readInt();
            pkg.WriteString("HonorOfMaster");//honourOfMaster = _loc_2.readUTF();
            pkg.WriteBoolean(false);//_loc_14.DailyLeagueFirst = _loc_2.readBoolean();
            pkg.WriteInt(0);//_loc_14.DailyLeagueLastScore = _loc_2.readInt();
            pkg.WriteBoolean(player.PlayerCharacter.IsOldPlayer);//_loc_14.isOld = _loc_2.readBoolean();
            if (player.Pet == null)
            {
                pkg.WriteInt(0);
            }
            else
            {
                pkg.WriteInt(1);//_loc_18 = _loc_2.readInt();
                pkg.WriteInt(player.Pet.Place);//_loc_20 = _loc_2.readInt();Place
                pkg.WriteInt(player.Pet.TemplateID);//_loc_22 = _loc_2.readInt();TemplateID         
                pkg.WriteInt(player.Pet.ID);//_loc_21.ID = _loc_2.readInt();
                pkg.WriteString(player.Pet.Name);//_loc_21.Name = _loc_2.readUTF();
                pkg.WriteInt(player.PlayerCharacter.ID);//_loc_21.UserID = _loc_2.readInt();
                pkg.WriteInt(player.Pet.Level);//_loc_21.Level = _loc_2.readInt();
                List<string> skills = player.Pet.GetSkillEquip();
                pkg.WriteInt(skills.Count);// _loc_2.readInt();
                foreach (string skill in skills)
                {
                    pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_2.readInt();place
                    pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_17 = _loc_2.readInt();
                }
            }

            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomPlayerRemove(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM, player.PlayerId);//GAME_PLAYER_EXIT
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_REMOVEPLAYER);
            pkg.Parameter1 = player.PlayerId;
            pkg.WriteInt(4);
            pkg.WriteInt(4);
            SendTCP(pkg);
            return pkg;
        }       

        public GSPacketIn SendRoomUpdatePlayerStates(byte[] states)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_PLAYER_STATE_CHANGE);
            for (int i = 0; i < states.Length; i++)
            {
                pkg.WriteByte(states[i]);
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomUpdatePlacesStates(int[] states)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_UPDATE_PLACE);
            for (int i = 0; i < states.Length; i++)
            {
                pkg.WriteInt(states[i]);
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomPlayerChangedTeam(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM, player.PlayerId);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_TEAM);
            pkg.WriteByte((byte)player.CurrentRoomTeam);
            pkg.WriteByte((byte)player.CurrentRoomIndex);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomCreate(BaseRoom room)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_CREATE);
            pkg.WriteInt(room.RoomId);
            pkg.WriteByte((byte)room.RoomType);
            pkg.WriteByte((byte)room.HardLevel);
            pkg.WriteByte((byte)room.TimeMode);
            pkg.WriteByte((byte)room.PlayerCount);
            pkg.WriteByte((byte)room.viewerCnt);// _loc_3.viewerCnt = _loc_2.readByte();
            pkg.WriteByte((byte)room.PlacesCount);
            pkg.WriteBoolean(string.IsNullOrEmpty(room.Password) ? false : true);
            pkg.WriteInt(room.MapId);
            pkg.WriteBoolean(room.IsPlaying);
            pkg.WriteString(room.Name);
            pkg.WriteByte((byte)room.GameType);
            pkg.WriteInt(room.LevelLimits);
            pkg.WriteBoolean(room.isCrosszone);//_loc_3.isCrossZone = _loc_2.readBoolean();
            pkg.WriteBoolean(room.isWithinLeageTime);//_loc_3.isWithinLeageTime = _loc_2.readBoolean();
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomLoginResult(bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_LOGIN);
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomPairUpStart(BaseRoom room)
        {

            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);//GAME_PAIRUP_START
            pkg.WriteByte((byte)GameRoomPackageType.GAME_PICKUP_WAIT);
            SendTCP(pkg);
            return pkg;
        }        

        public GSPacketIn SendRoomType(GamePlayer player, BaseRoom game)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);//GAME_PAIRUP_ROOM_SETUP
            pkg.WriteByte((byte)GameRoomPackageType.GAME_PICKUP_STYLE);
            //pkg.WriteByte((byte)game.GameStyle);
            //pkg.WriteInt((int)game.GameType);
            pkg.WriteByte((byte)game.GameStyle);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomPairUpCancel(BaseRoom room)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);//GAME_PAIRUP_CANCEL
            pkg.WriteByte((byte)GameRoomPackageType.GAME_PICKUP_CANCEL);
            SendTCP(pkg);
            return pkg;
        }
        /*
        public GSPacketIn SendRoomClear(GamePlayer player, BaseRoom game)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM_CLEAR, player.PlayerCharacter.ID);
            pkg.WriteInt(game.RoomId);
            SendTCP(pkg);
            return pkg;
        }
        */
        public GSPacketIn SendEquipChange(GamePlayer player, int place, int goodsID, string style)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.EQUIP_CHANGE, player.PlayerCharacter.ID);
            pkg.WriteByte((byte)place);
            pkg.WriteInt(goodsID);
            pkg.WriteString(style);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRoomChange(BaseRoom room)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_ROOM);
            pkg.WriteByte((byte)GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
            pkg.WriteBoolean(room.isOpenBoss);//_current.isOpenBoss
            pkg.WriteInt(room.MapId);
            pkg.WriteByte((byte)room.RoomType);
            pkg.WriteString(room.Password == null ? "" : room.Password);//_current.roomPass = event.pkg.readUTF();
            pkg.WriteString(room.Name == null ? "GunnyII" : room.Name);//_current.roomName = event.pkg.readUTF();
            pkg.WriteByte((byte)room.TimeMode);
            pkg.WriteByte((byte)room.HardLevel);
            pkg.WriteInt(room.LevelLimits);
            pkg.WriteBoolean(room.isCrosszone);
            SendTCP(pkg);
            return pkg;
        }

        #endregion

        #region IPacketLib 熔炼
        public GSPacketIn SendFusionPreview(GamePlayer player, Dictionary<int, double> previewItemList, bool isbind, int MinValid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_FUSION_PREVIEW, player.PlayerCharacter.ID);
            pkg.WriteInt(previewItemList.Count);
            foreach (KeyValuePair<int, double> p in previewItemList)
            {
                pkg.WriteInt(p.Key);
                pkg.WriteInt(MinValid);
                int value = (int)p.Value;
                pkg.WriteInt(value > 100 ? 100 : value < 0 ? 0 : value);

            }

            pkg.WriteBoolean(isbind);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendFusionResult(GamePlayer player, bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_FUSION, player.PlayerCharacter.ID);
            pkg.WriteBoolean(result);           
            SendTCP(pkg);
            return pkg;
        }
        #endregion

        public GSPacketIn SendOpenHoleComplete(GamePlayer player, int type, bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.OPEN_FIVE_SIX_HOLE, player.PlayerCharacter.ID);
            pkg.WriteInt(type);
            pkg.WriteBoolean(result);   
            SendTCP(pkg);
            return pkg;
        }
        #region IPacketLib 炼化
        public GSPacketIn SendRefineryPreview(GamePlayer player, int templateid, bool isbind, ItemInfo item)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_REFINERY_PREVIEW, player.PlayerCharacter.ID);

            pkg.WriteInt(templateid);

            pkg.WriteInt(item.ValidDate);
            pkg.WriteBoolean(isbind);
            pkg.WriteInt(item.AgilityCompose);
            pkg.WriteInt(item.AttackCompose);
            pkg.WriteInt(item.DefendCompose);
            pkg.WriteInt(item.LuckCompose);

            SendTCP(pkg);
            return pkg;
        }

        #endregion

        #region IPacketLib 背包/战利品
        
        public void SendUpdateInventorySlot(PlayerInventory bag, int[] updatedSlots)
        {
            if (m_gameClient.Player == null)
                return;            
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GRID_GOODS, m_gameClient.Player.PlayerCharacter.ID, 20480);
            pkg.WriteInt(bag.BagType);
            pkg.WriteInt(updatedSlots.Length);          
            foreach (int i in updatedSlots)
            {
                pkg.WriteInt(i);

                ItemInfo item = bag.GetItemAt(i);
                if (item == null)
                {
                    pkg.WriteBoolean(false);
                }
                else
                {
                    pkg.WriteBoolean(true);
                    pkg.WriteInt(item.UserID);
                    pkg.WriteInt(item.ItemID);
                    pkg.WriteInt(item.Count);
                    pkg.WriteInt(item.Place);
                    pkg.WriteInt(item.TemplateID);
                    pkg.WriteInt(item.AttackCompose);
                    pkg.WriteInt(item.DefendCompose);
                    pkg.WriteInt(item.AgilityCompose);
                    pkg.WriteInt(item.LuckCompose);
                    pkg.WriteInt(item.StrengthenLevel);
                    pkg.WriteInt(item.StrengthenExp);//item.StrengthenExp = pkg.readInt();
                    pkg.WriteBoolean(item.IsBinds);
                    pkg.WriteBoolean(item.IsJudge);
                    pkg.WriteDateTime(item.BeginDate);
                    pkg.WriteInt(item.ValidDate);
                    pkg.WriteString(item.Color == null ? "" : item.Color);
                    pkg.WriteString(item.Skin == null ? "" : item.Skin);
                    pkg.WriteBoolean(item.IsUsed);
                    pkg.WriteInt(item.Hole1);
                    pkg.WriteInt(item.Hole2);
                    pkg.WriteInt(item.Hole3);
                    pkg.WriteInt(item.Hole4);
                    pkg.WriteInt(item.Hole5);
                    pkg.WriteInt(item.Hole6);
                    pkg.WriteString(item.Template.Pic);
                    pkg.WriteInt(item.Template.RefineryLevel);
                    pkg.WriteDateTime(DateTime.Now);//item.DiscolorValidDate = pkg.readDateString();
                    pkg.WriteInt(item.StrengthenTimes);
                    pkg.WriteByte((byte)item.Hole5Level);
                    pkg.WriteInt(item.Hole5Exp);
                    pkg.WriteByte((byte)item.Hole6Level);
                    pkg.WriteInt(item.Hole6Exp);
                    if (item.IsGold)
                    {
                        pkg.WriteBoolean(item.IsGold);//item.isGold = pkg.readBoolean();
                        pkg.WriteInt(item.goldValidDate);//item.goldValidDate = pkg.readInt();
                        pkg.WriteDateTime(item.goldBeginTime);//item.goldBeginTime = pkg.readDateString();
                    }
                    else { pkg.WriteBoolean(false); }

                    pkg.WriteString(item.latentEnergyCurStr);//item.latentEnergyCurStr = pkg.readUTF(); 7road
                    pkg.WriteString(item.latentEnergyCurStr);//item.latentEnergyNewStr = pkg.readUTF(); 7road
                    pkg.WriteDateTime(item.latentEnergyEndTime);//item.latentEnergyEndTime = pkg.readDate(); 7road
                }
            }

            SendTCP(pkg);
        }
        public void SendPlayerCardEquip(PlayerInfo player, List<UsersCardInfo> cards)
        {
            if (m_gameClient.Player == null)
                return ;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_DATA, m_gameClient.Player.PlayerCharacter.ID);
            pkg.WriteInt(player.ID);
            pkg.WriteInt(cards.Count);
            foreach (UsersCardInfo card in cards)
            {
                pkg.WriteInt(card.Place);

                pkg.WriteBoolean(true);
                pkg.WriteInt(card.CardID);
                pkg.WriteInt(card.CardType);
                pkg.WriteInt(card.UserID);
                pkg.WriteInt(card.Place);
                pkg.WriteInt(card.TemplateID);
                pkg.WriteBoolean(card.isFirstGet);
                pkg.WriteInt(card.Attack);
                pkg.WriteInt(card.Defence);
                pkg.WriteInt(card.Agility);
                pkg.WriteInt(card.Luck);
                pkg.WriteInt(card.Damage);
                pkg.WriteInt(card.Guard);
            }

            SendTCP(pkg);
            //return pkg;
        }

        public void SendPlayerCardInfo(CardInventory bag, int[] updatedSlots)
        {
            if (m_gameClient.Player == null)
                return;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_DATA, m_gameClient.Player.PlayerCharacter.ID);
            pkg.WriteInt(m_gameClient.Player.PlayerCharacter.ID);
            pkg.WriteInt(updatedSlots.Length);
            foreach (int i in updatedSlots)
            {
                pkg.WriteInt(i);
                UsersCardInfo card = bag.GetItemAt(i);
                if (card.TemplateID == 0)
                {
                    pkg.WriteBoolean(false);
                }
                else
                {
                    pkg.WriteBoolean(true);
                    pkg.WriteInt(card.CardID);
                    pkg.WriteInt(card.CardType);
                    pkg.WriteInt(card.UserID);
                    pkg.WriteInt(card.Place);
                    pkg.WriteInt(card.TemplateID);
                    pkg.WriteBoolean(card.isFirstGet);
                    pkg.WriteInt(card.Attack);
                    pkg.WriteInt(card.Defence);
                    pkg.WriteInt(card.Agility);
                    pkg.WriteInt(card.Luck);
                    pkg.WriteInt(card.Damage);
                    pkg.WriteInt(card.Guard);
                }
            }

            SendTCP(pkg);
        }

        public GSPacketIn SendGetCard(PlayerInfo player, UsersCardInfo card)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_DATA, player.ID);
            pkg.WriteInt(player.ID);
            pkg.WriteInt(1);
            pkg.WriteInt(card.Place);
            pkg.WriteBoolean(true);
            pkg.WriteInt(card.CardID);
            pkg.WriteInt(card.CardType);
            pkg.WriteInt(card.UserID);
            pkg.WriteInt(card.Place);
            pkg.WriteInt(card.TemplateID);
            pkg.WriteBoolean(card.isFirstGet);
            pkg.WriteInt(card.Attack);
            pkg.WriteInt(card.Defence);
            pkg.WriteInt(card.Agility);
            pkg.WriteInt(card.Luck);
            pkg.WriteInt(card.Damage);
            pkg.WriteInt(card.Guard);
            SendTCP(pkg);
            return pkg;
        }
        public void SendPlayerCardSlot(PlayerInfo player, List<UsersCardInfo> cardslots)
        {
            if (m_gameClient.Player == null)
                return;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_SLOT, m_gameClient.Player.PlayerCharacter.ID);
            pkg.WriteInt(player.ID);
            pkg.WriteInt(player.CardSoul);//CardSoul
            pkg.WriteInt(cardslots.Count);
            List<UsersCardInfo> cards = new List<UsersCardInfo>();
            foreach (UsersCardInfo card in cardslots)
            {
                pkg.WriteInt(card.Place);//_loc_7.Place = _loc_2.readInt();
                pkg.WriteInt(card.Type);//_loc_7.Type = _loc_2.readInt();
                pkg.WriteInt(card.Level);//_loc_7.Level = _loc_2.readInt();
                pkg.WriteInt(card.CardGP);//_loc_7.GP = _loc_2.readInt();
                if (card.TemplateID > 0)
                    cards.Add(card);
            }
            if (cards.Count > 0)
            {
                SendPlayerCardEquip(player, cards);
            }
            SendTCP(pkg);
            //return pkg;
        }
        public GSPacketIn SendGetPlayerCard(int playerId)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GET_PLAYER_CARD, playerId);            
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendPlayerCardSlot(PlayerInfo player, UsersCardInfo card)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_SLOT, player.ID);
            pkg.WriteInt(player.ID);
            pkg.WriteInt(player.CardSoul);//CardSoul
            pkg.WriteInt(1);
            pkg.WriteInt(card.Place);//_loc_7.Place = _loc_2.readInt();
            pkg.WriteInt(card.Type);//_loc_7.Type = _loc_2.readInt();
            pkg.WriteInt(card.Level);//_loc_7.Level = _loc_2.readInt();
            pkg.WriteInt(card.CardGP);//_loc_7.GP = _loc_2.readInt();
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendPlayerCardReset(PlayerInfo player, List<int> points)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARD_RESET, player.ID);
            pkg.WriteInt(points.Count);
            foreach (int point in points)
            {
                pkg.WriteInt(point);//_loc_7.Place = _loc_2.readInt();                
            }
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendPlayerCardSoul(PlayerInfo player, bool isSoul, int soul)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CARDS_SOUL, player.ID);
            pkg.WriteBoolean(isSoul);
            if (isSoul)
            {
                pkg.WriteInt(soul);
            }        
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendUpdateUserPet(PetInventory bag, int[] slots)
        {
            if (m_gameClient.Player == null)
                return null;
            int playerId = m_gameClient.Player.PlayerCharacter.ID;
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PET, playerId);
            pkg.WriteByte((byte)ePetType.UPDATE_PET);
            pkg.WriteInt(playerId);
            pkg.WriteInt(slots.Length);
            foreach (int i in slots)
            {
                pkg.WriteInt(i);//_loc_11.Place = _loc_7;

                UsersPetinfo pet = bag.GetPetAt(i);
                if (pet == null)
                {                    
                    pkg.WriteBoolean(false);
                }
                else
                {                    
                    pkg.WriteBoolean(true);
                    pkg.WriteInt(pet.ID);//_loc_11.ID = _loc_2.readInt();
                    pkg.WriteInt(pet.TemplateID);//_loc_11.TemplateID = _loc_2.readInt();
                    pkg.WriteString(pet.Name);//_loc_11.Name = _loc_2.readUTF();
                    pkg.WriteInt(pet.UserID);//_loc_11.UserID = _loc_2.readInt();
                    pkg.WriteInt(pet.Attack);//_loc_11.Attack = _loc_2.readInt();
                    pkg.WriteInt(pet.Defence);//_loc_11.Defence = _loc_2.readInt();
                    pkg.WriteInt(pet.Luck);//_loc_11.Luck = _loc_2.readInt();
                    pkg.WriteInt(pet.Agility);//_loc_11.Agility = _loc_2.readInt();
                    pkg.WriteInt(pet.Blood);//_loc_11.Blood = _loc_2.readInt();
                    pkg.WriteInt(pet.Damage);//_loc_11.Damage = _loc_2.readInt();
                    pkg.WriteInt(pet.Guard);//_loc_11.Guard = _loc_2.readInt();
                    pkg.WriteInt(pet.AttackGrow);//_loc_11.AttackGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DefenceGrow);//_loc_11.DefenceGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.LuckGrow);//_loc_11.LuckGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.AgilityGrow);//_loc_11.AgilityGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.BloodGrow);//_loc_11.BloodGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DamageGrow);//_loc_11.DamageGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.GuardGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.Level);//_loc_11.Level = _loc_2.readInt();
                    pkg.WriteInt(pet.GP);//_loc_11.GP = _loc_2.readInt();
                    pkg.WriteInt(pet.MaxGP);//_loc_11.MaxGP = _loc_2.readInt();
                    pkg.WriteInt(pet.Hunger);//_loc_11.Hunger = _loc_2.readInt();
                    pkg.WriteInt(pet.PetHappyStar);//_loc_11.PetHappyStar = _loc_2.readInt();
                    pkg.WriteInt(pet.MP);//_loc_11.MP = _loc_2.readInt();
                    List<string> skills = pet.GetSkill();
                    List<string> skillEquips = pet.GetSkillEquip();
                    pkg.WriteInt(skills.Count);// _loc_2.readInt();==>all Ky nang thu cung
                    foreach (string skill in skills)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_2.readInt();killID 
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_17 = _loc_2.readInt();Place
                    }
                    pkg.WriteInt(skillEquips.Count);// _loc_2.readInt();==>ky nang chien dau tối da 5 kill
                    foreach (string skill in skillEquips)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_2.readInt();place
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_17 = _loc_2.readInt();

                    }

                    pkg.WriteBoolean(pet.IsEquip);//_loc_11.IsEquip = _loc_2.readBoolean();    
                }
            }
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendUpdatePetInfo(PlayerInfo info, UsersPetinfo[] pets)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PET, info.ID);
            pkg.WriteByte((byte)ePetType.UPDATE_PET);
            pkg.WriteInt(info.ID);
            pkg.WriteInt(pets.Length);
            for (int i = 0; i < pets.Length; i++)
            {
                pkg.WriteInt(i);//_loc_11.Place = _loc_7;
                UsersPetinfo pet = pets[i];
                if (pet == null)
                {                    
                    pkg.WriteBoolean(false);
                }
                else
                {
                    pkg.WriteBoolean(true);
                    pkg.WriteInt(pet.ID);//_loc_11.ID = _loc_2.readInt();
                    pkg.WriteInt(pet.TemplateID);//_loc_11.TemplateID = _loc_2.readInt();
                    pkg.WriteString(pet.Name);//_loc_11.Name = _loc_2.readUTF();
                    pkg.WriteInt(pet.UserID);//_loc_11.UserID = _loc_2.readInt();
                    pkg.WriteInt(pet.Attack);//_loc_11.Attack = _loc_2.readInt();
                    pkg.WriteInt(pet.Defence);//_loc_11.Defence = _loc_2.readInt();
                    pkg.WriteInt(pet.Luck);//_loc_11.Luck = _loc_2.readInt();
                    pkg.WriteInt(pet.Agility);//_loc_11.Agility = _loc_2.readInt();
                    pkg.WriteInt(pet.Blood);//_loc_11.Blood = _loc_2.readInt();
                    pkg.WriteInt(pet.Damage);//_loc_11.Damage = _loc_2.readInt();
                    pkg.WriteInt(pet.Guard);//_loc_11.Guard = _loc_2.readInt();
                    pkg.WriteInt(pet.AttackGrow);//_loc_11.AttackGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DefenceGrow);//_loc_11.DefenceGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.LuckGrow);//_loc_11.LuckGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.AgilityGrow);//_loc_11.AgilityGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.BloodGrow);//_loc_11.BloodGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DamageGrow);//_loc_11.DamageGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.GuardGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.Level);//_loc_11.Level = _loc_2.readInt();
                    pkg.WriteInt(pet.GP);//_loc_11.GP = _loc_2.readInt();
                    pkg.WriteInt(pet.MaxGP);//_loc_11.MaxGP = _loc_2.readInt();
                    pkg.WriteInt(pet.Hunger);//_loc_11.Hunger = _loc_2.readInt();
                    pkg.WriteInt(pet.PetHappyStar);//_loc_11.PetHappyStar = _loc_2.readInt();
                    pkg.WriteInt(pet.MP);//_loc_11.MP = _loc_2.readInt();
                    List<string> skills = pet.GetSkill();
                    List<string> skillEquips = pet.GetSkillEquip();
                    pkg.WriteInt(skills.Count);// _loc_2.readInt();==>all Ky nang thu cung
                    foreach (string skill in skills)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_2.readInt();killID 
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_17 = _loc_2.readInt();Place
                    }
                    pkg.WriteInt(skillEquips.Count);// _loc_2.readInt();==>ky nang chien dau tối da 5 kill
                    foreach (string skill in skillEquips)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_2.readInt();place
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_17 = _loc_2.readInt();

                    }
                    pkg.WriteBoolean(pet.IsEquip);//_loc_11.IsEquip = _loc_2.readBoolean();    
                }
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendRefreshPet(GamePlayer player, UsersPetinfo[] pets, ItemInfo[] items, bool refreshBtn)//, bool FinishQuest, int MaxActiveSkillCount, int MaxStaticSkillCount, int MaxSkillCount)
        {           
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PET, player.PlayerCharacter.ID);
            pkg.WriteByte((byte)ePetType.REFRESH_PET);
            int MaxActiveSkillCount = 10;
            int MaxStaticSkillCount = 10;
            int MaxSkillCount = 100;
            if (!player.PlayerCharacter.IsFistGetPet)
            {                
                pkg.WriteBoolean(refreshBtn);
                pkg.WriteInt(pets.Length);
                for (int i = 0; i < pets.Length; i++)
                {
                    UsersPetinfo pet = pets[i];
                    pkg.WriteInt(pet.Place);//_loc_11.Place = _loc_7;
                    pkg.WriteInt(pet.TemplateID);//_loc_11.TemplateID = _loc_2.readInt();
                    pkg.WriteString(pet.Name);//_loc_11.Name = _loc_2.readUTF();
                    pkg.WriteInt(pet.Attack);//_loc_11.Attack = _loc_2.readInt();
                    pkg.WriteInt(pet.Defence);//_loc_11.Defence = _loc_2.readInt();
                    pkg.WriteInt(pet.Luck);//_loc_11.Luck = _loc_2.readInt();
                    pkg.WriteInt(pet.Agility);//_loc_11.Agility = _loc_2.readInt();
                    pkg.WriteInt(pet.Blood);//_loc_11.Blood = _loc_2.readInt();
                    pkg.WriteInt(pet.Damage);//_loc_11.Damage = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.Guard = _loc_2.readInt();
                    pkg.WriteInt(pet.AttackGrow);//_loc_11.AttackGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DefenceGrow);//_loc_11.DefenceGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.LuckGrow);//_loc_11.LuckGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.AgilityGrow);//_loc_11.AgilityGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.BloodGrow);//_loc_11.BloodGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DamageGrow);//_loc_11.DamageGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.GuardGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.Level);//_loc_11.Level = _loc_2.readInt();
                    pkg.WriteInt(pet.GP);//_loc_11.GP = _loc_2.readInt();
                    pkg.WriteInt(pet.MaxGP);//_loc_11.MaxGP = _loc_2.readInt();
                    pkg.WriteInt(pet.Hunger);//_loc_11.Hunger = _loc_2.readInt();
                    pkg.WriteInt(pet.MP);//_loc_11.MP = _loc_2.readInt();
                    List<string> skills = pet.GetSkill();
                    pkg.WriteInt(skills.Count);// _loc_2.readInt();==>all Ky nang thu cung
                    foreach (string skill in skills)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_2.readInt();killID 
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_17 = _loc_2.readInt();Place
                    }
                    pkg.WriteInt(MaxActiveSkillCount);// _loc_7.MaxActiveSkillCount = _loc_2.readInt();
                    pkg.WriteInt(MaxStaticSkillCount);//_loc_7.MaxStaticSkillCount = _loc_2.readInt();
                    pkg.WriteInt(MaxSkillCount);//MaxSkillCount = _loc_2.readInt();

                }
                //adoptItems
                if (items != null)
                {
                    pkg.WriteInt(items.Length);//_loc_4 = _loc_2.readInt();
                    for (int i = 0; i < items.Length; i++)
                    {
                        ItemInfo item = items[i];
                        pkg.WriteInt(item.Place);//_loc_14.place = _loc_2.readInt();
                        pkg.WriteInt(item.TemplateID);// _loc_14.itemTemplateId = _loc_2.readInt();
                        pkg.WriteInt(item.Count);//_loc_14.itemAmount = _loc_2.readInt();
                    }
                }
                else { pkg.WriteInt(0); }
            }
            else
            {                
                pkg.WriteBoolean(refreshBtn);
                pkg.WriteInt(pets.Length);
                for (int i = 0; i < pets.Length; i++)
                {
                    UsersPetinfo pet = pets[i];
                    pkg.WriteInt(pet.Place);//_loc_11.Place = _loc_7;
                    pkg.WriteInt(pet.TemplateID);//_loc_11.TemplateID = _loc_2.readInt();
                    pkg.WriteString(pet.Name);//_loc_11.Name = _loc_2.readUTF();
                    pkg.WriteInt(pet.Attack);//_loc_11.Attack = _loc_2.readInt();
                    pkg.WriteInt(pet.Defence);//_loc_11.Defence = _loc_2.readInt();
                    pkg.WriteInt(pet.Luck);//_loc_11.Luck = _loc_2.readInt();
                    pkg.WriteInt(pet.Agility);//_loc_11.Agility = _loc_2.readInt();
                    pkg.WriteInt(pet.Blood);//_loc_11.Blood = _loc_2.readInt();
                    pkg.WriteInt(pet.Damage);//_loc_11.Damage = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.Guard = _loc_2.readInt();
                    pkg.WriteInt(pet.AttackGrow);//_loc_11.AttackGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DefenceGrow);//_loc_11.DefenceGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.LuckGrow);//_loc_11.LuckGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.AgilityGrow);//_loc_11.AgilityGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.BloodGrow);//_loc_11.BloodGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.DamageGrow);//_loc_11.DamageGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.GuardGrow);//_loc_11.GuardGrow = _loc_2.readInt();
                    pkg.WriteInt(pet.Level);//_loc_11.Level = _loc_2.readInt();
                    pkg.WriteInt(pet.GP);//_loc_11.GP = _loc_2.readInt();
                    pkg.WriteInt(pet.MaxGP);//_loc_11.MaxGP = _loc_2.readInt();
                    pkg.WriteInt(pet.Hunger);//_loc_11.Hunger = _loc_2.readInt();
                    pkg.WriteInt(pet.MP);//_loc_11.MP = _loc_2.readInt();
                    List<string> skills = pet.GetSkill();
                    pkg.WriteInt(skills.Count);// _loc_2.readInt();==>all Ky nang thu cung
                    foreach (string skill in skills)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(',')[0]));//_loc_2.readInt();killID 
                        pkg.WriteInt(int.Parse(skill.Split(',')[1]));//_loc_17 = _loc_2.readInt();Place
                    }
                    pkg.WriteInt(MaxActiveSkillCount);// _loc_7.MaxActiveSkillCount = _loc_2.readInt();
                    pkg.WriteInt(MaxStaticSkillCount);//_loc_7.MaxStaticSkillCount = _loc_2.readInt();
                    pkg.WriteInt(MaxSkillCount);//MaxSkillCount = _loc_2.readInt();

                }
            }
            SendTCP(pkg);
            return pkg;
        }
        #endregion

        #region IPacketLib 好友
        public GSPacketIn SendAddFriend(PlayerInfo user,int relation, bool state)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.IM_CMD, user.ID);//FRIEND_STATE
            pkg.WriteByte((byte)IMPackageType.FRIEND_ADD);
            pkg.WriteBoolean(state);//_loc_3:* = _loc_2.readBoolean();
            pkg.WriteInt(user.ID);
            pkg.WriteString(user.NickName);
            pkg.WriteByte(user.typeVIP);//_loc_4.typeVIP = _loc_2.readByte();
            pkg.WriteInt(user.VIPLevel);//_loc_4.VIPLevel = _loc_2.readInt();
            pkg.WriteBoolean(user.Sex);
            pkg.WriteString(user.Style);
            pkg.WriteString(user.Colors);
            pkg.WriteString(user.Skin);
            pkg.WriteInt(user.State == 1 ? 1 : 0);
            pkg.WriteInt(user.Grade);
            pkg.WriteInt(user.Hide);
            pkg.WriteString(user.ConsortiaName);
            pkg.WriteInt(user.Total);
            pkg.WriteInt(user.Escape);
            pkg.WriteInt(user.Win);
            pkg.WriteInt(user.Offer);
            pkg.WriteInt(user.Repute);
            pkg.WriteInt(relation);
            pkg.WriteString(user.UserName);
            pkg.WriteInt(user.Nimbus);
            pkg.WriteInt(user.FightPower);
            pkg.WriteInt(0);// _loc_4.apprenticeshipState = _loc_2.readInt();
            pkg.WriteInt(0);//_loc_4.masterID = _loc_2.readInt();
            pkg.WriteString("");//_loc_4.setMasterOrApprentices(_loc_2.readUTF());
            pkg.WriteInt(0);//_loc_4.graduatesCount = _loc_2.readInt();
            pkg.WriteString("");//_loc_4.honourOfMaster = _loc_2.readUTF();
            pkg.WriteInt(user.AchievementPoint);//_loc_4.AchievementPoint = _loc_2.readInt();
            pkg.WriteInt(user.AchievementPoint);//_loc_4.honor = _loc_2.readUTF();
            pkg.WriteBoolean(user.IsMarried);//_loc_4.IsMarried = _loc_2.readBoolean();
            pkg.WriteBoolean(user.IsOldPlayer);//_loc_4.isOld = _loc_2.readBoolean();
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendFriendRemove(int FriendID)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.IM_CMD, FriendID);//FRIEND_REMOVE
            pkg.WriteByte((byte)IMPackageType.FRIEND_REMOVE);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendFriendState(int playerID, int state, byte typeVip, int viplevel)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.IM_CMD, playerID);//FRIEND_STATE
            pkg.WriteByte((byte)IMPackageType.FRIEND_STATE);   
            pkg.WriteInt(state);//_loc_4 = _loc_2.readInt();StateID
            pkg.WriteInt(typeVip);//_loc_5 = _loc_2.readByte();typeVIP
            pkg.WriteInt(viplevel);//_loc_6 = _loc_2.readInt();VIPLevel
            pkg.WriteBoolean(true);//_loc_7 = _loc_2.readBoolean();isSameCity
            SendTCP(pkg);
            return pkg;
        }

        #endregion
        public GSPacketIn SendUpdateAllData(PlayerInfo player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.KING_BLESS_MAIN, player.ID);
            pkg.WriteInt(0);
            pkg.WriteDateTime(DateTime.Now.AddDays(+7));
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendGetSpree(PlayerInfo player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.RECHARGE, player.ID);
            pkg.WriteBoolean(false);
            SendTCP(pkg);
            return pkg;
        }
        //updateUpCount
        public GSPacketIn SendUpdateUpCount(PlayerInfo player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.HONOR_UP_COUNT, player.ID);
            pkg.WriteInt(player.MaxBuyHonor);//max 20t/day
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendPlayerRefreshTotem(PlayerInfo player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.TOTEM, player.ID);
            pkg.WriteInt(1);
            pkg.WriteInt(player.myHonor);
            pkg.WriteInt(player.totemId);            
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendLabyrinthUpdataInfo(int ID)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.LABYRINTH, ID);
            pkg.WriteByte((byte)LabyrinthPackageType.REQUEST_UPDATE);
            pkg.WriteInt(0);//_model.myProgress = _loc_2.readInt();
            pkg.WriteInt(1);//_model.currentFloor = _loc_2.readInt();
            pkg.WriteBoolean(false);//_model.completeChallenge = _loc_2.readBoolean();
            pkg.WriteInt(30);//_model.remainTime = _loc_2.readInt();
            pkg.WriteInt(0);//_model.accumulateExp = _loc_2.readInt();
            pkg.WriteInt(0);//_model.cleanOutAllTime = _loc_2.readInt();
            pkg.WriteInt(0);//_model.cleanOutGold = _loc_2.readInt();
            pkg.WriteInt(0);//_model.myRanking = _loc_2.readInt();
            pkg.WriteBoolean(true);//_model.isDoubleAward = _loc_2.readBoolean();
            pkg.WriteBoolean(false);//_model.isInGame = _loc_2.readBoolean();
            pkg.WriteBoolean(false);//_model.isCleanOut = _loc_2.readBoolean();
            SendTCP(pkg);
            return pkg;
        }
        //playerFigSpiritinit
        public GSPacketIn SendPlayerFigSpiritinit(int ID, List<UserGemStone> gems)
        {           
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.FIGHT_SPIRIT, ID);
            pkg.WriteByte((byte)FightSpiritPackageType.FIGHT_SPIRIT_INIT);
            pkg.WriteBoolean(true);
            pkg.WriteInt(gems.Count);
            foreach(UserGemStone g in gems)
            {
                pkg.WriteInt(g.UserID);///_loc_5.userId = event.pkg.readInt();
                pkg.WriteInt(g.FigSpiritId);///_loc_5.figSpiritId = event.pkg.readInt();
                pkg.WriteString(g.FigSpiritIdValue);///_loc_5.figSpiritIdValue = event.pkg.readUTF();"0,0,0|0,0,0" => "lv,exp,place|lv,exp,place"
                pkg.WriteInt(g.EquipPlace);///_loc_5.equipPlace = event.pkg.readInt();
            }
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendPlayerFigSpiritUp(int ID, UserGemStone gem, bool isUp, bool isMaxLevel, bool isFall, int num, int dir)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.FIGHT_SPIRIT, ID);
            pkg.WriteByte((byte)FightSpiritPackageType.PLAYER_FIGHT_SPIRIT_UP);
            string[] FigSpiritIdValue = gem.FigSpiritIdValue.Split('|');
            pkg.WriteBoolean(isUp);//_loc_2.isUp = event.pkg.readBoolean();
            pkg.WriteBoolean(isMaxLevel);//_loc_2.isMaxLevel = event.pkg.readBoolean();
            pkg.WriteBoolean(isFall);//_loc_2.isFall = event.pkg.readBoolean();
            pkg.WriteInt(num);//_loc_2.num = event.pkg.readInt(); //3          
            pkg.WriteInt(FigSpiritIdValue.Length);//var _loc_4:* = event.pkg.readInt();
            int _loc_5 = 0;
            while (_loc_5 < FigSpiritIdValue.Length)
            {
                string FigSpiritId = FigSpiritIdValue[_loc_5];
                pkg.WriteInt(gem.FigSpiritId); //_loc_6.fightSpiritId = event.pkg.readInt();
                pkg.WriteInt(Convert.ToInt32(FigSpiritId.Split(',')[0])); //_loc_6.level = event.pkg.readInt();
                pkg.WriteInt(Convert.ToInt32(FigSpiritId.Split(',')[1])); //_loc_6.exp = event.pkg.readInt();
                pkg.WriteInt(Convert.ToInt32(FigSpiritId.Split(',')[2])); //_loc_6.place = event.pkg.readInt();            
                _loc_5++;
            }
            pkg.WriteInt(gem.EquipPlace);// _loc_2.equipPlace = event.pkg.readInt();
            pkg.WriteInt(dir);//_loc_2.dir = event.pkg.readInt();//1
            SendTCP(pkg);
            return pkg;
        }
        

        public GSPacketIn SendTrusteeshipStart(int ID)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.TRUSTEESHIP, ID);
            pkg.WriteByte((byte)TrusteeshipPackageType.START);
            pkg.WriteInt(0);//_spiritValue = _loc_2.readInt();
            //_list = new Vector.<TrusteeshipDataVo>;
            pkg.WriteInt(1);//var _loc_3:* = _loc_2.readInt();
            var _loc_4 = 0;
            while (_loc_4 < 1)
            {

                pkg.WriteInt(0);//_loc_5.id = _loc_2.readInt();
                pkg.WriteDateTime(DateTime.Now);//_loc_5.endTime = _loc_2.readDate();                
                _loc_4 = _loc_4 + 1;
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendActivityList(int ID)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.EVERYDAY_ACTIVEPOINT, ID);
            pkg.WriteByte((byte)ActivityPackageType.EVERYDAYACTIVEPOINT_DATA);
            pkg.WriteInt(0);
            pkg.WriteInt(0);
            pkg.WriteInt(0);
            pkg.WriteInt(0);
            SendTCP(pkg);
            return pkg;
        }
        #region IPacketLib 任务

        /// <summary>
        /// 发送当前用户的任务数据
        /// </summary>
        /// <param name="player"></param>
        /// <param name="infos"></param>
        /// <returns></returns>
        public GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] infos)
        {
            if (((player == null) || (states == null)) || (infos == null))
            {
                return null;
            }
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.QUEST_UPDATE, player.PlayerCharacter.ID, 20480);
            pkg.WriteInt(infos.Length);
            foreach (BaseQuest info in infos)
            {
                pkg.WriteInt(info.Data.QuestID);           //任务编号
                pkg.WriteBoolean(info.Data.IsComplete);    //是否完成
                pkg.WriteInt(info.Data.Condition1);        //用户条件一
                pkg.WriteInt(info.Data.Condition2);        //用户条件二
                pkg.WriteInt(info.Data.Condition3);        //用户条件三
                pkg.WriteInt(info.Data.Condition4);        //用户条件四
                pkg.WriteDateTime(info.Data.CompletedDate);//用户条件完成日期
                pkg.WriteInt(info.Data.RepeatFinish);      //该任务剩余接受次数。
                pkg.WriteInt(info.Data.RandDobule);        //用户接受任务机会
                pkg.WriteBoolean(info.Data.IsExist);         //是否为新任务
                pkg.WriteInt(info.Data.QuestLevel);//_loc_6.QuestLevel = _loc_2.readInt();
            }
            pkg.Write(states);//loadQuestLog(_loc_2.readByteArray());
            SendTCP(pkg);
            return pkg;
        }
        /*public GSPacketIn SendUpdateQuests(GamePlayer player, byte[] states, BaseQuest[] infos)
        {
            //TODO:完成任务列表的同步
            if (m_gameClient.Player == null)
                return null;


            try
            {
                var length = 0;
                var numSend = infos.Length;
                var j = 0;
                do
                {
                    GSPacketIn pkg = new GSPacketIn((byte)ePackageType.QUEST_UPDATE, m_gameClient.Player.PlayerCharacter.ID);
                    length = (numSend > 7) ? 7 : numSend;
                    pkg.WriteInt(length);
                    for (int i = 0; i < length; i++, j++)
                    {
                        var info = infos[j];
                        if (info.Data.IsExist)
                        {
                            pkg.WriteInt(info.Data.QuestID);           //任务编号
                            pkg.WriteBoolean(info.Data.IsComplete);    //是否完成
                            pkg.WriteInt(info.Data.Condition1);        //用户条件一
                            pkg.WriteInt(info.Data.Condition2);        //用户条件二
                            pkg.WriteInt(info.Data.Condition3);        //用户条件三
                            pkg.WriteInt(info.Data.Condition4);        //用户条件四
                            pkg.WriteDateTime(info.Data.CompletedDate);//用户条件完成日期
                            pkg.WriteInt(info.Data.RepeatFinish);      //该任务剩余接受次数。
                            pkg.WriteInt(info.Data.RandDobule);        //用户接受任务机会
                            pkg.WriteBoolean(info.Data.IsExist);         //是否为新任务
                        }
                    }
                    //输出所有的任务
                    for (int i = 0; i < states.Length; i++)
                    {
                        pkg.WriteByte(states[i]);
                    }
                    numSend -= length;
                    SendTCP(pkg);
                } while (j < infos.Length);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.InnerException);
            }

            return new GSPacketIn((byte)ePackageType.QUEST_UPDATE, m_gameClient.Player.PlayerCharacter.ID);
        }*/
        #endregion

        #region IPacketLib Buffers

        public GSPacketIn SendUpdateBuffer(GamePlayer player, BufferInfo[] infos)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.BUFF_UPDATE, player.PlayerId);
            pkg.WriteInt(infos.Length);
            foreach (BufferInfo info in infos)
            {
                pkg.WriteInt(info.Type);
                pkg.WriteBoolean(info.IsExist);
                pkg.WriteDateTime(info.BeginDate);
                pkg.WriteInt(info.ValidDate);
                pkg.WriteInt(info.Value);
                pkg.WriteInt(info.ValidCount);//_loc_10 = _loc_2.readInt();ValidCount
            }
            SendTCP(pkg);

            return pkg;
        }

        public GSPacketIn SendBufferList(GamePlayer player, List<AbstractBuffer> infos)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.BUFF_OBTAIN, player.PlayerId);
            pkg.WriteInt(infos.Count);
            foreach (AbstractBuffer bufferInfo in infos)
            {
                BufferInfo info = bufferInfo.Info;
                pkg.WriteInt(info.Type);
                pkg.WriteBoolean(info.IsExist);
                pkg.WriteDateTime(info.BeginDate);
                pkg.WriteInt(info.ValidDate);
                pkg.WriteInt(info.Value);
                pkg.WriteInt(info.ValidCount);
            }
            SendTCP(pkg);

            return pkg;
        }

        #endregion

        #region IPacketLib Return

        //type:1加载收件邮，2加载发件邮，3加载全部
        public GSPacketIn SendMailResponse(int playerID, eMailRespose type)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MAIL_RESPONSE);
            pkg.WriteInt(playerID);
            pkg.WriteInt((int)type);
            GameServer.Instance.LoginServer.SendPacket(pkg);
            return pkg;
        }

        #endregion

        #region IPacketLib Auction

        public GSPacketIn SendAuctionRefresh(AuctionInfo info, int auctionID, bool isExist, ItemInfo item)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.AUCTION_REFRESH);
            pkg.WriteInt(auctionID);
            pkg.WriteBoolean(isExist);
            if (isExist)
            {
                pkg.WriteInt(info.AuctioneerID);
                pkg.WriteString(info.AuctioneerName);
                pkg.WriteDateTime(info.BeginDate);
                pkg.WriteInt(info.BuyerID);
                pkg.WriteString(info.BuyerName);
                pkg.WriteInt(info.ItemID);
                pkg.WriteInt(info.Mouthful);
                pkg.WriteInt(info.PayType);
                pkg.WriteInt(info.Price);
                pkg.WriteInt(info.Rise);
                pkg.WriteInt(info.ValidDate);
                pkg.WriteBoolean(item != null);
                if (item != null)
                {
                    pkg.WriteInt(item.Count);
                    pkg.WriteInt(item.TemplateID);
                    pkg.WriteInt(item.AttackCompose);
                    pkg.WriteInt(item.DefendCompose);
                    pkg.WriteInt(item.AgilityCompose);
                    pkg.WriteInt(item.LuckCompose);
                    pkg.WriteInt(item.StrengthenLevel);
                    pkg.WriteBoolean(item.IsBinds);
                    pkg.WriteBoolean(item.IsJudge);
                    pkg.WriteDateTime(item.BeginDate);
                    pkg.WriteInt(item.ValidDate);
                    pkg.WriteString(item.Color);
                    pkg.WriteString(item.Skin);
                    pkg.WriteBoolean(item.IsUsed);
                    pkg.WriteInt(item.Hole1);//_loc_5.Hole1 = event.pkg.readInt();
                    pkg.WriteInt(item.Hole2);//_loc_5.Hole2 = event.pkg.readInt();
                    pkg.WriteInt(item.Hole3);//_loc_5.Hole3 = event.pkg.readInt();
                    pkg.WriteInt(item.Hole4);//_loc_5.Hole4 = event.pkg.readInt();
                    pkg.WriteInt(item.Hole5);//_loc_5.Hole5 = event.pkg.readInt();
                    pkg.WriteInt(item.Hole6);//_loc_5.Hole6 = event.pkg.readInt();
                    pkg.WriteString(item.Template.Pic);//_loc_5.Pic = event.pkg.readUTF();
                    pkg.WriteInt(item.Template.RefineryLevel);//_loc_5.RefineryLevel = event.pkg.readInt();
                    pkg.WriteDateTime(DateTime.Now);//_loc_5.DiscolorValidDate = event.pkg.readDateString();
                    pkg.WriteByte((byte)item.Hole5Level);//_loc_5.Hole5Level = event.pkg.readByte();
                    pkg.WriteInt(item.Hole5Exp);//_loc_5.Hole5Exp = event.pkg.readInt();
                    pkg.WriteByte((byte)item.Hole6Level);//_loc_5.Hole6Level = event.pkg.readByte();
                    pkg.WriteInt(item.Hole6Exp);//_loc_5.Hole6Exp = event.pkg.readInt();
                }
            }
            pkg.Compress();
            SendTCP(pkg);
            return pkg;
        }
        
        public GSPacketIn SendAASState(bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_VISITOR_DATA);//AAS_STATE_GET
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendIDNumberCheck(bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CID_INFO_VALID);//AAS_IDNUM_CHECK
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendAASInfoSet(bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_VISITOR_DATA);//AAS_INFO_SET
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendAASControl(bool result, bool IsAASInfo, bool IsMinor)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ENTHRALL_LIGHT);//AAS_CTRL
            pkg.WriteBoolean(true);
            pkg.WriteInt(1);
            pkg.WriteBoolean(true);
            pkg.WriteBoolean(IsMinor);
            SendTCP(pkg);
            return pkg;
        }
        
        #endregion

        #region MarryInfo
        public GSPacketIn SendMarryRoomInfo(GamePlayer player, MarryRoom room)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_ROOM_CREATE, player.PlayerCharacter.ID);
            bool result = room != null;
            pkg.WriteBoolean(result);
            if (result)
            {
                pkg.WriteInt(room.Info.ID);
                pkg.WriteBoolean(room.Info.IsHymeneal);
                pkg.WriteString(room.Info.Name);
                pkg.WriteBoolean(room.Info.Pwd == "" ? false : true);
                pkg.WriteInt(room.Info.MapIndex);
                pkg.WriteInt(room.Info.AvailTime);
                pkg.WriteInt(room.Count);
                pkg.WriteInt(room.Info.PlayerID);
                pkg.WriteString(room.Info.PlayerName);
                pkg.WriteInt(room.Info.GroomID);
                pkg.WriteString(room.Info.GroomName);
                pkg.WriteInt(room.Info.BrideID);
                pkg.WriteString(room.Info.BrideName);
                pkg.WriteDateTime(room.Info.BeginTime);
                pkg.WriteByte((byte)room.RoomState);
                pkg.WriteString(room.Info.RoomIntroduction);
            }

            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendMarryRoomLogin(GamePlayer player, bool result)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_ROOM_LOGIN, player.PlayerCharacter.ID);
            pkg.WriteBoolean(result);
            if (result)
            {
                pkg.WriteInt(player.CurrentMarryRoom.Info.ID);
                pkg.WriteString(player.CurrentMarryRoom.Info.Name);
                pkg.WriteInt(player.CurrentMarryRoom.Info.MapIndex);
                pkg.WriteInt(player.CurrentMarryRoom.Info.AvailTime);
                pkg.WriteInt(player.CurrentMarryRoom.Count);
                pkg.WriteInt(player.CurrentMarryRoom.Info.PlayerID);
                pkg.WriteString(player.CurrentMarryRoom.Info.PlayerName);
                pkg.WriteInt(player.CurrentMarryRoom.Info.GroomID);
                pkg.WriteString(player.CurrentMarryRoom.Info.GroomName);
                pkg.WriteInt(player.CurrentMarryRoom.Info.BrideID);
                pkg.WriteString(player.CurrentMarryRoom.Info.BrideName);
                pkg.WriteDateTime(player.CurrentMarryRoom.Info.BeginTime);
                pkg.WriteBoolean(player.CurrentMarryRoom.Info.IsHymeneal);
                pkg.WriteByte((byte)player.CurrentMarryRoom.RoomState);
                pkg.WriteString(player.CurrentMarryRoom.Info.RoomIntroduction);
                pkg.WriteBoolean(player.CurrentMarryRoom.Info.GuestInvite);
                pkg.WriteInt(player.MarryMap);
                pkg.WriteBoolean(player.CurrentMarryRoom.Info.IsGunsaluteUsed);
            }

            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendPlayerEnterMarryRoom(Game.Server.GameObjects.GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PLAYER_ENTER_MARRY_ROOM, player.PlayerCharacter.ID);
            pkg.WriteInt(player.PlayerCharacter.Grade);
            pkg.WriteInt(player.PlayerCharacter.Hide);
            pkg.WriteInt(player.PlayerCharacter.Repute);
            pkg.WriteInt(player.PlayerCharacter.ID);
            pkg.WriteString(player.PlayerCharacter.NickName);
            pkg.WriteByte(player.PlayerCharacter.typeVIP);
            pkg.WriteInt(player.PlayerCharacter.VIPLevel);
            pkg.WriteBoolean(player.PlayerCharacter.Sex);
            pkg.WriteString(player.PlayerCharacter.Style);
            pkg.WriteString(player.PlayerCharacter.Colors);
            pkg.WriteString(player.PlayerCharacter.Skin);
            pkg.WriteInt(player.X);
            pkg.WriteInt(player.Y);
            pkg.WriteInt(player.PlayerCharacter.FightPower);
            pkg.WriteInt(player.PlayerCharacter.Win);
            pkg.WriteInt(player.PlayerCharacter.Total);
            pkg.WriteInt(player.PlayerCharacter.Offer);
            pkg.WriteBoolean(player.PlayerCharacter.IsOldPlayer);//_loc_3.isOld = _loc_2.readBoolean();
            SendTCP(pkg);

            return pkg;
        }


        public GSPacketIn SendMarryInfoRefresh(MarryInfo info, int ID, bool isExist)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.AMARRYINFO_REFRESH);
            pkg.WriteInt(ID);
            pkg.WriteBoolean(isExist);
            if (isExist)
            {
                pkg.WriteInt(info.UserID);
                pkg.WriteBoolean(info.IsPublishEquip);
                pkg.WriteString(info.Introduction);
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendPlayerMarryStatus(GamePlayer player, int userID, bool isMarried)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_STATUS, player.PlayerCharacter.ID);
            pkg.WriteInt(userID);
            pkg.WriteBoolean(isMarried);
            SendTCP(pkg);
            return pkg;

        }

        public GSPacketIn SendPlayerMarryApply(GamePlayer player, int userID, string userName, string loveProclamation, int id)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_APPLY, player.PlayerCharacter.ID);
            pkg.WriteInt(userID);//求婚者的ID
            pkg.WriteString(userName);//求婚者的昵称
            pkg.WriteString(loveProclamation);
            pkg.WriteInt(id);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendPlayerDivorceApply(GamePlayer player, bool result, bool isProposer)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.DIVORCE_APPLY, player.PlayerCharacter.ID);
            pkg.WriteBoolean(result);
            //判断是主动提出离婚者还是被动离婚者
            pkg.WriteBoolean(isProposer);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendMarryApplyReply(GamePlayer player, int UserID, string UserName, bool result, bool isApplicant, int id)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_APPLY_REPLY, player.PlayerCharacter.ID);
            pkg.WriteInt(UserID);//对方的ID
            pkg.WriteBoolean(result);
            pkg.WriteString(UserName);//对方的名称
            pkg.WriteBoolean(isApplicant);
            pkg.WriteInt(id);
            SendTCP(pkg);
            return pkg;
        }        

        public GSPacketIn SendPlayerLeaveMarryRoom(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.PLAYER_EXIT_MARRY_ROOM, player.PlayerCharacter.ID);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendMarryRoomInfoToPlayer(GamePlayer player, bool state, MarryRoomInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_ROOM_STATE, player.PlayerCharacter.ID);
            pkg.WriteInt(info.ID);//var _loc_3:* = _loc_2.readInt();
            pkg.WriteBoolean(state);
            if (state)
            {
                pkg.WriteInt(info.ID);
                pkg.WriteString(info.Name);
                pkg.WriteInt(info.MapIndex);
                pkg.WriteInt(info.AvailTime);
                pkg.WriteInt(info.PlayerID);
                pkg.WriteInt(info.GroomID);
                pkg.WriteInt(info.BrideID);
                pkg.WriteDateTime(info.BeginTime);
                pkg.WriteBoolean(info.IsGunsaluteUsed);
            }
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendMarryInfo(GamePlayer player, MarryInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRYINFO_GET, player.PlayerCharacter.ID);
            pkg.WriteString(info.Introduction);
            pkg.WriteBoolean(info.IsPublishEquip);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendContinuation(GamePlayer player, MarryRoomInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRY_CMD, player.PlayerCharacter.ID);
            pkg.WriteByte((byte)MarryCmdType.CONTINUATION);
            pkg.WriteInt(info.AvailTime);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendMarryProp(GamePlayer player, MarryProp info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.MARRYPROP_GET, player.PlayerCharacter.ID);
            pkg.WriteBoolean(info.IsMarried);
            pkg.WriteInt(info.SpouseID);
            pkg.WriteString(info.SpouseName);
            pkg.WriteBoolean(info.IsCreatedMarryRoom);
            pkg.WriteInt(info.SelfMarryRoomID);
            pkg.WriteBoolean(info.IsGotRing);
            SendTCP(pkg);
            return pkg;
        }


        #endregion
        #region Consortia
        public GSPacketIn SendConsortiaCreate(string name1, bool result, int id, string name2, string msg,int dutyLevel,string DutyName,int dutyRight, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_CREATE);
            pkg.WriteString(name1);
            pkg.WriteBoolean(result);
            pkg.WriteInt(id);
            pkg.WriteString(name2);
            pkg.WriteString(msg);
            pkg.WriteInt(dutyLevel);
            pkg.WriteString(DutyName == null ? "" : DutyName);
            pkg.WriteInt(dutyRight);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn SendConsortiaRichesOffer(int money, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
            pkg.WriteInt(money); 
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);       
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendConsortiaInvite(string username, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_INVITE);
            pkg.WriteString(username);     
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);       
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaInvitePass(int id, bool result, int consortiaid, string consortianame, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_INVITE_PASS);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaInviteDel(int id, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendConsortiaLevelUp(byte type, byte level, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_LEVEL_UP);
            pkg.WriteByte(type);
            pkg.WriteByte(level);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);       
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaTryIn(int id, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_TRYIN);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);       
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaTryInPass(int id, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaTryInDel(int id, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaUpdateDescription(string description, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
            pkg.WriteString(description);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);       
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaEquipConstrol(bool result, List<int> Riches, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
            pkg.WriteBoolean(result);
            int i = 0;
            while (i < Riches.Count)
            {
                pkg.WriteInt(Riches[i]);
                i++;
            }
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendConsortiaMemberGrade(int id, bool update, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
            pkg.WriteInt(id);
            pkg.WriteBoolean(update);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);      
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaOut(int id, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_RENEGADE);
            pkg.WriteInt(id);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaChangeChairman(string nick, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
            pkg.WriteString(nick);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaUpdatePlacard(string description, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
            pkg.WriteString(description);
            pkg.WriteBoolean(result);
            pkg.WriteString(msg);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendConsortiaApplyStatusOut(bool state, bool result, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_APPLY_STATE);
            pkg.WriteBoolean(result);
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }

        public GSPacketIn sendBuyBadge(int BadgeID, int ValidDate, bool result, string BadgeBuyTime, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.BUY_BADGE);
            pkg.WriteInt(BadgeID);//var _loc_3:* = _loc_2.readInt();BadgeID
            pkg.WriteInt(BadgeID);//var _loc_4:* = _loc_2.readInt();BadgeID
            pkg.WriteInt(ValidDate);//var _loc_5:* = _loc_2.readInt();ValidDate
            pkg.WriteDateTime(Convert.ToDateTime(BadgeBuyTime));//var _loc_6:* = _loc_2.readDate();BadgeBuyTime
            pkg.WriteBoolean(result);//var _loc_7:* = _loc_2.readBoolean();
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendConsortia(int money, bool result, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
                    
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn SendConsortiaMail(bool result, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD, playerid);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTION_MAIL);
            pkg.WriteBoolean(result);
            SendTCP(pkg);
            return pkg;
        }
        public GSPacketIn sendOneOnOneTalk(int receiverID, bool isAutoReply, string SenderNickName, string msg, int playerid)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.IM_CMD, playerid);
            pkg.WriteByte((byte)IMPackageType.ONE_ON_ONE_TALK);
            pkg.WriteInt(receiverID);//var _loc_3:* = _loc_2.readInt();receiverID
            pkg.WriteString(SenderNickName);//var _loc_4:* = _loc_2.readUTF();sender NickName
            pkg.WriteDateTime(DateTime.Now);//var _loc_5:* = _loc_2.readDate();send date
            pkg.WriteString(msg);//var _loc_6:* = _loc_2.readUTF();msg
            pkg.WriteBoolean(isAutoReply);//var _loc_7:* = _loc_2.readBoolean();isAutoReply
            SendTCP(pkg);
            return pkg;
        }
        #endregion
    }
}
