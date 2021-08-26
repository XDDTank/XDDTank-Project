using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using Game.Base.Packets;
using Game.Server.GameUtils;
using Game.Server.Managers;
using System.Threading;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Quests;
using Game.Server.Statics;
using Game.Server.Buffer;
//using Game.Server.HotSpringRooms;
using Game.Server.SceneMarryRooms;
using Game.Server.Packets;
using Game.Server.Rooms;
using Game.Logic;
using Bussiness.Managers;
using System.Collections;
using Game.Logic.Phy.Object;
using Game.Server.ChatServer;
using System.Text;


namespace Game.Server.GameObjects
{
    /// <summary>
    /// 游戏中的玩家类[This class represents a player in the game]
    /// </summary>
    public class GamePlayer : IGamePlayer
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        #region Fields/Properties
        public GamePlayer(int playerId, string account, GameClient client, PlayerInfo info)
            : base()
        {
            m_playerId = playerId;
            m_account = account;
            m_client = client;
            m_character = info;
            LastChatTime = DateTime.Today;
            m_mainBag = new PlayerEquipInventory(this);
            m_BeadBag = new PlayerEquipInventory(this);
            m_propBag = new PlayerInventory(this, true, 49, (int)eBageType.PropBag, 0, true);
            m_unbindBag = new PlayerUnbindInventory(this);
            m_ConsortiaBag = new PlayerInventory(this, true, 100, (int)eBageType.Consortia, 0, true);//bank
            m_storeBag = new PlayerInventory(this, true, 20, (int)eBageType.Store, 0, true);
            m_fightBag = new PlayerInventory(this, false, 3, (int)eBageType.FightBag, 0, false);
            m_tempBag = new PlayerInventory(this, false, 61, (int)eBageType.TempBag, 0, true);
            m_caddyBag = new PlayerInventory(this, false, 30, (int)eBageType.CaddyBag, 0, true);
            m_farmBag = new PlayerInventory(this, true, 30, (int)eBageType.Farm, 0, true);
            m_vegetable = new PlayerInventory(this, true, 30, (int)eBageType.Vegetable, 0, true);
            m_food = new PlayerInventory(this, true, 30, (int)eBageType.Food, 0, true);
            m_petEgg = new PlayerInventory(this, true, 30, (int)eBageType.PetEgg, 0, false);
            m_cardBag = new CardInventory(this, true, 100, 0);
            //m_farm = new PlayerFarm(this, true, 16, 0);
            m_petBag = new PetInventory(this, true, 5, 8, 0);
            //----------------------------

            m_questInventory = new QuestInventory(this);
            m_bufferList = new BufferList(this);
            m_equipEffect = new List<int>();
            m_GemStone = new List<UserGemStone>();
            //双倍经验卡初始化
            GPAddPlus = 1;
            m_toemview = true;
            X = 646;
            Y = 1241;
            MarryMap = 0;
            m_converter = new System.Text.UTF8Encoding();
        }
        //BaseGame game
        protected BaseGame m_game;
        public BaseGame game
        {
            get { return m_game; }
            set { m_game = value; }
        }
        private int m_playerId;
        protected GameClient m_client;
        protected Player m_players;
        private PlayerInfo m_character;
        private string m_account;
        private int m_immunity = 255;
        public int Immunity
        {
            get { return m_immunity; }
            set { m_immunity = value; }
        }
        public int PlayerId
        {
            get { return m_playerId; }
        }
        public bool m_toemview;
        public bool Toemview
        {
            get { return m_toemview; }
            set { m_toemview = value; }
        }
        public int m_open;
        public int OpenTime//số lần lật bài
        {
            get { return m_open; }
            set { m_open = value; }
        }
        public int open_money;
        public int DefaultOpenMoney//số tiền khi lật bài
        {
            get { return open_money; }
            set { open_money = value; }
        }
        public int eye_money;
        public int DefaultEyeMoney//số tiền khi dùng xuyên thấu
        {
            get { return eye_money; }
            set { eye_money = value; }
        }
        public int FightPower;
        public string Account
        {
            get { return m_account; }
        }
        public PlayerInfo PlayerCharacter
        {
            get { return m_character; }
        }

        public GameClient Client
        {
            get { return m_client; }
        }
        public Player Players
        {
            get { return m_players; }
        }
        public bool IsActive
        {
            get { return m_client.IsConnected; }
        }
        public IPacketLib Out
        {
            get { return m_client.Out; }
        }
        private bool m_isMinor;
        public bool IsMinor
        {
            get { return m_isMinor; }
            set { m_isMinor = value; }
        }
        private bool m_isAASInfo;
        public bool IsAASInfo
        {
            get { return m_isAASInfo; }
            set { m_isAASInfo = value; }
        }
        private long m_pingTime;
        public long PingTime
        {
            get { return m_pingTime; }
            set
            {
                m_pingTime = value;
                GSPacketIn pkg = Out.SendNetWork(this, m_pingTime);
                if (m_currentRoom != null)
                {
                    m_currentRoom.SendToAll(pkg, this);
                }
            }
        }

        private byte[] m_pvepermissions;

        public long PingStart;

        #endregion
        private UsersPetinfo m_pet;
        public UsersPetinfo Pet
        {
            get { return m_pet; }
        }

        #region Item and Bags
        private PlayerEquipInventory m_mainBag;
        private PlayerInventory m_propBag;
        private PlayerInventory m_fightBag;
        private PlayerInventory m_ConsortiaBag;
        private PlayerInventory m_storeBag;
        private PlayerInventory m_tempBag;
        private PlayerInventory m_caddyBag;
        private PlayerInventory m_farmBag;//FARM= 13,
        private PlayerInventory m_vegetable;//VEGETABLE= 14,
        private PlayerUnbindInventory m_unbindBag;
        private PlayerInventory m_food;//FOOD= 34,
        private PlayerInventory m_petEgg;//PETEGG= 35,
        private PlayerEquipInventory m_BeadBag;//
        private CardInventory m_cardBag;
        private PlayerFarm m_farm;
        private PetInventory m_petBag;
        private PlayerDragonBoat m_dragon;
        public PlayerDragonBoat DragonInfo
        {
            get { return m_dragon; }
        }
        public PetInventory PetBag
        {
            get { return m_petBag; }
        }
        public PlayerFarm Farm
        {
            get { return m_farm; }
        }
        public PlayerEquipInventory MainBag
        {
            get { return m_mainBag; }
        }
        public PlayerInventory PropBag
        {
            get { return m_propBag; }
        }
        public PlayerInventory FightBag
        {
            get { return m_fightBag; }
        }
        public PlayerInventory TempBag
        {
            get { return m_tempBag; }
        }
        public PlayerInventory ConsortiaBag
        {
            get { return m_ConsortiaBag; }
        }
        public PlayerInventory StoreBag
        {
            get { return m_storeBag; }
        }
        public PlayerInventory CaddyBag
        {
            get { return m_caddyBag; }
        }
        public PlayerInventory FarmBag
        {
            get { return m_farmBag; }
        }
        public PlayerInventory Vegetable
        {
            get { return m_vegetable; }
        }
        public PlayerInventory Food
        {
            get { return m_food; }
        }
        public PlayerInventory PetEgg
        {
            get { return m_petEgg; }
        }
        public PlayerEquipInventory BeadBag
        {
            get { return m_BeadBag; }
        }
        public CardInventory CardBag
        {
            get { return m_cardBag; }
        }
        public PlayerInventory GetInventory(eBageType bageType)
        {
            switch (bageType)
            {
                case eBageType.MainBag:
                    return m_mainBag;
                case eBageType.PropBag:
                    return m_propBag;
                case eBageType.FightBag:
                    return m_fightBag;
                case eBageType.TempBag:
                    return m_tempBag;
                case eBageType.Consortia:
                    return m_ConsortiaBag;
                case eBageType.Store:
                    return m_storeBag;
                case eBageType.CaddyBag:
                    return m_caddyBag;
                case eBageType.Farm:
                    return m_farmBag;
                case eBageType.Vegetable:
                    return m_vegetable;
                case eBageType.Food:
                    return m_food;
                case eBageType.PetEgg:
                    return m_petEgg;
                case eBageType.BeadBag:
                    return m_BeadBag;  
                default:
                    throw new NotSupportedException(string.Format("Did not support this type bag: {0}", bageType));
            }
        }
        public string GetInventoryName(eBageType bageType)
        {
            switch (bageType)
            {
                case eBageType.MainBag:
                    return LanguageMgr.GetTranslation("Game.Server.GameObjects.Equip");
                case eBageType.PropBag:
                    return LanguageMgr.GetTranslation("Game.Server.GameObjects.Prop");
                default:
                    return bageType.ToString();
            }
        }
        public PlayerInventory GetItemInventory(ItemTemplateInfo template)
        {
            return GetInventory(template.BagType);
        }
        public ItemInfo GetItemAt(eBageType bagType, int place)
        {
            PlayerInventory bag = GetInventory(bagType);
            if (bag != null)
            {
                return bag.GetItemAt(place);
            }
            return null;
        }
        public int GetItemCount(int templateId)
        {
            return m_propBag.GetItemCount(templateId) + m_mainBag.GetItemCount(templateId) + m_ConsortiaBag.GetItemCount(templateId);

        }
        public bool AddItem(ItemInfo item)
        {
            AbstractInventory bg = GetItemInventory(item.Template);
            return bg.AddItem(item, bg.BeginSlot);
        }
        public bool StackItemToAnother(ItemInfo item)
        {
            AbstractInventory bg = GetItemInventory(item.Template);
            return bg.StackItemToAnother(item);
        }
        public void UpdateItem(ItemInfo item)
        {
            m_mainBag.UpdateItem(item);
            m_propBag.UpdateItem(item);
        }
        public bool RemoveItem(ItemInfo item)
        {
            if (item.BagType == m_propBag.BagType)
                return m_propBag.RemoveItem(item);
            else if (item.BagType == m_fightBag.BagType)
                return m_fightBag.RemoveItem(item);
            else
                return m_mainBag.RemoveItem(item);
        }

        public bool AddTemplate(ItemInfo cloneItem, eBageType bagType, int count)
        {
            PlayerInventory bag = GetInventory(bagType);
            if (bag != null)
            {
                // cloneItem.IsBinds = cloneItem.Template.BindType == 1;
                if (bag.AddTemplate(cloneItem, count))
                {

                    if (CurrentRoom != null && CurrentRoom.IsPlaying)
                        SendItemNotice(cloneItem);
                    return true;
                }
            }
            return false;
        }
        public bool RemoveTemplate(int templateId, int count)
        {
            int mainItem = m_mainBag.GetItemCount(templateId);
            int propItem = m_propBag.GetItemCount(templateId);
            int storeItem = m_ConsortiaBag.GetItemCount(templateId);
            int tempCount = mainItem + propItem + storeItem;
            ItemTemplateInfo template = ItemMgr.FindItemTemplate(templateId);
            if ((template != null) && (tempCount >= count))
            {

                if ((mainItem > 0) && (count > 0) && RemoveTempate(eBageType.MainBag, template, mainItem > count ? count : mainItem))
                {
                    count = count < mainItem ? 0 : count - mainItem;
                }
                if ((propItem > 0) && (count > 0) && RemoveTempate(eBageType.PropBag, template, propItem > count ? count : propItem))
                {
                    count = count < propItem ? 0 : count - propItem;
                }
                if ((storeItem > 0) && (count > 0) && RemoveTempate(eBageType.Consortia, template, storeItem > count ? count : storeItem))
                {
                    count = count < storeItem ? 0 : count - storeItem;
                }
                if (count == 0)
                    return true;
                if (log.IsErrorEnabled)
                    log.Error(string.Format("Item Remover Error：PlayerId {0} Remover TemplateId{1} Is Not Zero!", m_playerId, templateId));
            }
            return false;
        }
        public bool RemoveTempate(eBageType bagType, ItemTemplateInfo template, int count)
        {
            PlayerInventory bag = GetInventory(bagType);
            if (bag != null)
            {
                return bag.RemoveTemplate(template.TemplateID, count);
            }
            return false;
        }
        public bool RemoveTemplate(ItemTemplateInfo template, int count)
        {
            PlayerInventory bag = GetItemInventory(template);
            if (bag != null)
            {
                return bag.RemoveTemplate(template.TemplateID, count);
            }
            return false;
        }

        public bool ClearTempBag()
        {
            TempBag.ClearBag();
            return true;
        }

        public bool ClearFightBag()
        {
            FightBag.ClearBag();
            return true;
        }
        public void ClearCaddyBag()
        {
            List<ItemInfo> overdueItems = new List<ItemInfo>();
            for (int i = 0; i < CaddyBag.Capalility; i++)
            {
                ItemInfo itemAt = CaddyBag.GetItemAt(i);
                if (itemAt != null)
                {
                    if (itemAt.Template.BagType == eBageType.PropBag)
                    {
                        int slot = PropBag.FindFirstEmptySlot();
                        if (PropBag.StackItemToAnother(itemAt) || PropBag.AddItemTo(itemAt, slot))
                        {

                            CaddyBag.TakeOutItem(itemAt);
                        }
                        else { overdueItems.Add(itemAt); }
                    }
                    else
                    {
                        int slot = MainBag.FindFirstEmptySlot(31);
                        if (MainBag.StackItemToAnother(itemAt) || MainBag.AddItemTo(itemAt, slot))
                        {
                            CaddyBag.TakeOutItem(itemAt);
                        }
                        else { overdueItems.Add(itemAt); }
                    }

                }

            }
            if (overdueItems.Count > 0)
            {
                SendItemsToMail(overdueItems, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"),
                    LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
                Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
            }
        }
        public void AddPointDragonBoat(int point)
        {
            m_dragon.DragonInfo.Point += point;
            OnPropertiesChanged();
        }
        public void AddTotalPointDragonBoat(int point)
        {
            m_dragon.DragonInfo.TotalPoint += point;
            OnPropertiesChanged();
        }
        public void AddExpDragonBoat(int point)
        {
            m_dragon.DragonInfo.Exp += point;
            OnPropertiesChanged();
        }
        public void ClearStoreBag()
        {
            List<ItemInfo> list = m_storeBag.GetItems();
            foreach (ItemInfo item in list)
            {
                PlayerInventory bag = GetItemInventory(item.Template);
                string key = string.Format("temp_place_{0}", item.ItemID);
                if (TempProperties.ContainsKey(key))
                {
                    int toSlot = (int)this.TempProperties[key];
                    TempProperties.Remove(key);
                    if (bag.AddItemTo(item, toSlot))
                    {
                        m_storeBag.TakeOutItem(item);
                    }
                }
                else if (bag.StackItemToAnother(item))
                {
                    m_storeBag.RemoveItem(item, eItemRemoveType.Stack);
                }
                else if (bag.AddItem(item))
                {
                    m_storeBag.TakeOutItem(item);
                }
            }
            list = m_storeBag.GetItems();
            if (list.Count > 0)
            {
                string str1 = LanguageMgr.GetTranslation("Game.Server.GameUtils.Content2");
                string str2 = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title2");
                SendItemsToMail(list, str1, str2, eMailType.ItemOverdue);
                Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
            }
        }

        #endregion

        #region Quests/Event
        private QuestInventory m_questInventory;
        /// <summary>
        /// 当前玩家的
        /// </summary>
        public QuestInventory QuestInventory
        {
            get
            {
                return m_questInventory;
            }
        }
        public event PlayerEventHandle LevelUp;
        /// <summary>
        /// 1、用户升级<客户端触发>
        /// </summary>
        /// <param name="grade"></param>
        public void OnLevelUp(int grade)
        {
            if (LevelUp != null)
            {
                LevelUp(this);
            }
        }
        public delegate void PlayerItemPropertyEventHandle(int templateID);
        public event PlayerItemPropertyEventHandle AfterUsingItem;
        /// <summary>
        /// 2、用户使用某一个道具<客户端触发>
        /// </summary>
        /// <param name="templateID"></param>
        /// <param name="count"></param>
        public void OnUsingItem(int templateID)
        {
            if (AfterUsingItem != null)
            {
                AfterUsingItem(templateID);
            }
        }
        public delegate void PlayerGameOverEventHandle(AbstractGame game, bool isWin, int gainXp); //任务监听<战斗完成>       
        public event PlayerGameOverEventHandle GameOver;
        /// <summary>
        ///【5、完成一场战斗】【 6、战斗胜利/房间模式/数量】【23、完成战斗（无论胜败）/游戏模式/数量】<服务器触发>
        /// </summary>
        /// <param name="game">房间</param>
        /// <param name="isWin">是否胜利</param>
        /// <param name="gainXp">获利</param>
        public void OnGameOver(AbstractGame game, bool isWin, int gainXp)
        {
            if (game.RoomType == eRoomType.Match)
            {
                //PlayerInfo playerCharacter = PlayerCharacter;
                //playerCharacter.CheckCount++;
                //Out.SendCheckCode();
                if (isWin)
                {
                    m_character.Win++;
                }
                //UpdateProperties();
                m_character.Total++;
            }
            if (GameOver != null)
            {
                GameOver(game, isWin, gainXp);
            }
        }
        public delegate void PlayerMissionOverEventHandle(AbstractGame game, int missionId, bool isWin);
        public event PlayerMissionOverEventHandle MissionOver;
        public delegate void PlayerMissionTurnOverEventHandle(AbstractGame game, int missionId, int turnNum);
        public event PlayerMissionTurnOverEventHandle MissionTurnOver;
        /// <summary>
        ///【7、完成副本（无论胜败）/副本ID/次数】【8、通关副本（要求胜利）/副本ID/次数】<服务器触发>
        /// </summary>
        /// <param name="game"></param>
        public void OnMissionOver(AbstractGame game, bool isWin, int missionId, int turnNum)
        {
            if (MissionOver != null)
            {
                MissionOver(game, missionId, isWin);
            }
            if (MissionTurnOver != null && isWin)
            {
                MissionTurnOver(game, missionId, turnNum);
            }
        }
        public delegate void PlayerItemStrengthenEventHandle(int categoryID, int level);
        public event PlayerItemStrengthenEventHandle ItemStrengthen;
        /// <summary>
        /// 9、强化/装备类型/强化等级<服务器触发>
        /// </summary>
        /// <param name="CategoryID">装备类型</param>
        /// <param name="lever">强化等级</param>
        public void OnItemStrengthen(int categoryID, int level)
        {
            if (ItemStrengthen != null)
            {
                ItemStrengthen(categoryID, level);
            }
        }

        public delegate void PlayerShopEventHandle(int money, int gold, int offer, int gifttoken, int medal, string payGoods);
        public event PlayerShopEventHandle Paid;
        /// <summary>
        /// 10、购买/货币类型/支付金额<服务器触发>
        /// </summary>
        /// <param name="shopID"></param>
        /// <param name="price"></param>
        public void OnPaid(int money, int gold, int offer, int gifttoken, int medal, string payGoods)
        {
            if (Paid != null)
            {
                Paid(money, gold, offer, gifttoken, medal, payGoods);
            }
        }

        public delegate void PlayerAdoptPetEventHandle();
        public event PlayerAdoptPetEventHandle AdoptPetEvent;
        public void OnAdoptPetEvent()
        {
            if (AdoptPetEvent != null)
            {
                AdoptPetEvent();
            }
        }
        //
        public delegate void PlayerNewGearEventHandle(int CategoryID);
        public event PlayerNewGearEventHandle NewGearEvent;
        public void OnNewGearEvent(int CategoryID)
        {
            if (NewGearEvent != null)
            {
                NewGearEvent(CategoryID);
            }
        }
        //
        public delegate void PlayerCropPrimaryEventHandle();
        public event PlayerCropPrimaryEventHandle CropPrimaryEvent;
        public void OnCropPrimaryEvent()
        {
            if (CropPrimaryEvent != null)
            {
                CropPrimaryEvent();
            }
        }
        //SeedFoodPet
        public delegate void PlayerSeedFoodPetEventHandle();
        public event PlayerSeedFoodPetEventHandle SeedFoodPetEvent;
        public void OnSeedFoodPetEvent()
        {
            if (SeedFoodPetEvent != null)
            {
                SeedFoodPetEvent();
            }
        }

        public delegate void PlayerItemInsertEventHandle();
        public event PlayerItemInsertEventHandle ItemInsert;
        public void OnItemInsert()
        {
            if (ItemInsert != null)
            {
                ItemInsert();
            }
        }

        public delegate void PlayerItemFusionEventHandle(int fusionType);
        public event PlayerItemFusionEventHandle ItemFusion;
        /// <summary>
        /// 11、熔炼成功/熔炼类型/次数<服务器触发>
        /// </summary>
        /// <param name="fusionType">熔炼类型</param>
        /// <param name="count">熔练</param>
        public void OnItemFusion(int fusionType)
        {
            if (ItemFusion != null)
            {
                ItemFusion(fusionType);
            }
        }
        public delegate void PlayerItemMeltEventHandle(int categoryID);
        public event PlayerItemMeltEventHandle ItemMelt;
        /// <summary>
        /// 12、炼化/装备类型/炼化等级<服务器触发>
        /// </summary>
        /// <param name="meltType"></param>
        /// <param name="count"></param>
        public void OnItemMelt(int categoryID)
        {
            if (ItemMelt != null)
            {
                ItemMelt(categoryID);
            }
        }
        public delegate void PlayerGameKillEventHandel(AbstractGame game, int type, int id, bool isLiving, int demage);
        public event PlayerGameKillEventHandel AfterKillingLiving;

        /// <summary>
        /// 【4、击杀玩家若干人次/房间模式/数量】【13、游戏中杀死玩家或者怪物】【22、击杀玩家若干人次/游戏模式/数量】<服务器触发>
        /// </summary>
        /// <param name="game">游戏类型</param>
        /// <param name="type">1表示玩家、2表示NPC</param>
        /// <param name="id">目标ID</param>
        /// <param name="isLiving">是否活着</param>
        /// <param name="damage">伤害</param>
        public void OnKillingLiving(AbstractGame game, int type, int id, bool isLiving, int damage)
        {
            if (AfterKillingLiving != null)
                AfterKillingLiving(game, type, id, isLiving, damage);
            if ((GameKillDrop != null) && (isLiving == false))
                GameKillDrop(game, type, id, isLiving);
        }
        public delegate void PlayerOwnConsortiaEventHandle();
        public event PlayerOwnConsortiaEventHandle GuildChanged;
        /// <summary>
        /// 18、公会人数/空/具体人数
        /// </summary>
        /// <param name="count"></param>
        public void OnGuildChanged()
        {
            if (GuildChanged != null)
            {
                GuildChanged();
            }
        }

        public delegate void PlayerItemComposeEventHandle(int composeType);
        public event PlayerItemComposeEventHandle ItemCompose;
        /// <summary>
        /// 19、合成成功/合成类型/次数<服务器触发>
        /// </summary>
        /// <param name="fusionType">合成类型</param>
        /// <param name="count">合成</param>
        public void OnItemCompose(int composeType)
        {
            if (ItemCompose != null)
            {
                ItemCompose(composeType);
            }
        }

        public delegate void GameKillDropEventHandel(AbstractGame game, int type, int npcId, bool playResult);
        public event GameKillDropEventHandel GameKillDrop;


        #endregion

        #region Buffers
        private BufferList m_bufferList;
        public BufferList BufferList
        {
            get { return m_bufferList; }
        }
        public delegate void PlayerEventHandle(GamePlayer player);
        public event PlayerEventHandle UseBuffer;
        public void OnUseBuffer()
        {
            if (UseBuffer != null)

                UseBuffer(this);
        }
        private List<UserGemStone> m_GemStone;
        public List<UserGemStone> GemStone
        {
            get { return m_GemStone; }
            set { m_GemStone = value; }
        }

        private List<int> m_equipEffect;
        public List<int> EquipEffect
        {
            get { return m_equipEffect; }
            set { m_equipEffect = value; }
        }
        #endregion

        #region BeginChanges/CommiteChanges/UpdateProperties
        private int m_changed;
        public void BeginAllChanges()
        {
            BeginChanges();
            m_bufferList.BeginChanges();
            m_mainBag.BeginChanges();
            m_propBag.BeginChanges();
            //m_BeadBag.BeginChanges();
            m_farmBag.BeginChanges();
            //m_food.BeginChanges();
            //m_vegetable.BeginChanges();
            //m_petEgg.BeginChanges();
            m_cardBag.BeginChanges();
        }
        public void CommitAllChanges()
        {
            CommitChanges();
            m_bufferList.CommitChanges();
            m_mainBag.CommitChanges();
            m_propBag.CommitChanges();
            //m_BeadBag.BeginChanges();
            m_farmBag.CommitChanges();
            //m_food.CommitChanges();
            //m_vegetable.CommitChanges();
            //m_petEgg.CommitChanges();
            m_cardBag.CommitChanges();
        }
        public void BeginChanges()
        {
            Interlocked.Increment(ref m_changed);
        }
        public void CommitChanges()
        {
            Interlocked.Decrement(ref m_changed);
            OnPropertiesChanged();
        }
        protected void OnPropertiesChanged()
        {
            if (m_changed <= 0)
            {
                if (m_changed < 0)
                {
                    log.Error("Player changed count < 0");
                    Thread.VolatileWrite(ref m_changed, 0);
                }
                UpdateProperties();
            }
        }
        public void UpdateBadgeId(int Id)
        {
            m_character.badgeID = Id;
        }
        public void UpdateTimeBox(int receiebox, int receieGrade, int needGetBoxTime)
        {
            m_character.receiebox = receiebox;
            m_character.receieGrade = receieGrade;
            m_character.needGetBoxTime = needGetBoxTime;
        }
        public void UpdateProperties()
        {
            Out.SendUpdatePrivateInfo(m_character);
            GSPacketIn pkg = Out.SendUpdatePublicPlayer(m_character);
            if (m_currentRoom != null)
            {
                m_currentRoom.SendToAll(pkg, this);
            }
        }
        #endregion

        #region Player Normal Propertis CanUseProp/GPAddPlus/OfferAddPlus/GuildRichAddPlus/LastChatTime
        public bool CanUseProp { get; set; }
        public double GPAddPlus;
        public double OfferAddPlus = 1;
        public double GuildRichAddPlus = 1;
        public DateTime LastChatTime;
        public bool KickProtect;
        #endregion

        #region Player Properties  Gold/Money/GP/Offer/Riches/Style
        public int Level
        {
            get { return m_character.Grade; }
            set
            {
                if (value != m_character.Grade)
                {
                    m_character.Grade = value;
                    OnLevelUp(value);
                    OnPropertiesChanged();
                }
            }
        }
        public int AddGold(int value)
        {
            if (value > 0)
            {
                m_character.Gold += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveGold(int value)
        {
            if (value > 0 && value <= m_character.Gold)
            {
                m_character.Gold -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddMoney(int value)
        {
            if (value > 0)
            {
                m_character.Money += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddHonor(int value)
        {
            if (value > 0)
            {
                m_character.myHonor += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddTotem(int value)
        {
            if (value > 0)
            {
                m_character.totemId += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddMaxHonor(int value)
        {
            if (value > 0)
            {
                m_character.MaxBuyHonor += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveMoney(int value)
        {
            if (value > 0 && value <= m_character.Money)
            {
                m_character.Money -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public void RemoveFistGetPet()
        {
            m_character.IsFistGetPet = false;
        }
        public void RemoveLastRefreshPet()
        {
            m_character.LastRefreshPet = DateTime.Now;
        }
        public void UpdateAnswerSite(int id)
        {
            if (PlayerCharacter.AnswerSite < id)
            {
                PlayerCharacter.AnswerSite = id;
            }
            //PlayerCharacter.openFunction((Step)id);
            UpdateWeaklessGuildProgress();
            Out.SendWeaklessGuildProgress(PlayerCharacter);
        }

        public void UpdateWeaklessGuildProgress()
        {
            if (PlayerCharacter.weaklessGuildProgress == null)
            {
                //byte[] proc = new byte[PlayerCharacter.WeaklessGuildProgressStr.Length];
                PlayerCharacter.weaklessGuildProgress = Base64.decodeToByteArray(PlayerCharacter.WeaklessGuildProgressStr);
            }
            PlayerCharacter.CheckLevelFunction();
            //for (int i = 1; i < proc.Length; i++)
            //{                
            //}
            if (PlayerCharacter.Grade == 1)
            {
                PlayerCharacter.openFunction(Step.GAIN_ADDONE);
            }
            if (PlayerCharacter.IsOldPlayer)
            {
                PlayerCharacter.openFunction(Step.OLD_PLAYER);
            }
            PlayerCharacter.WeaklessGuildProgressStr = Base64.encodeByteArray(PlayerCharacter.weaklessGuildProgress);
        }

        public void AddExpVip(int value) //trminhpc
        {
            //0|200|400|800|2000|4000|8000|20000|40000|80000|200000|400000
            List<int> exp = new List<int> { 0, 200, 400, 800, 2000, 4000, 8000, 20000, 40000, 80000, 200000, 400000 };

            if (value >= 10)
            {
                m_character.VIPExp += (int)(value / 10);
            }
            int VIPExp = m_character.VIPExp;
            int level = m_character.VIPLevel;
            if (level < 12)
            {
                for (int o = exp[level]; o < VIPExp; )
                {
                    if ((VIPExp >= 200 && level == 1) || (VIPExp >= 400 && level == 2) || (VIPExp >= 800 && level == 3) ||
                        (VIPExp >= 2000 && level == 4) || (VIPExp >= 4000 && level == 5) || (VIPExp >= 8000 && level == 6) ||
                        (VIPExp >= 20000 && level == 7) || (VIPExp >= 40000 && level == 8) || (VIPExp >= 80000 && level == 9) ||
                        (VIPExp >= 200000 && level == 10) || (VIPExp >= 400000 && level == 11))
                    {
                        m_character.VIPLevel++;
                    }
                    o = exp[m_character.VIPLevel];
                }
            }
            Out.SendOpenVIP(PlayerCharacter);

        }
        public int AddCardSoul(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.CardSoul += value;
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveCardSoul(int value)
        {
            if (value > 0 && value <= m_character.CardSoul)
            {
                m_character.CardSoul -= value;
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddScore(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.Score += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveScore(int value)
        {
            if (value > 0 && value <= m_character.Score)
            {
                m_character.Score -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddDamageScores(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.damageScores += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveDamageScores(int value)
        {
            if (value > 0 && value <= m_character.damageScores)
            {
                m_character.damageScores -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddPetScore(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.petScore += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemovePetScore(int value)
        {
            if (value > 0 && value <= m_character.petScore)
            {
                m_character.petScore -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddmyHonor(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.myHonor += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemovemyHonor(int value)
        {
            if (value > 0 && value <= m_character.myHonor)
            {
                m_character.myHonor -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddMedal(int value) //trminhpc
        {
            if (value > 0)
            {
                m_character.medal += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveMedal(int value)
        {
            if (value > 0 && value <= m_character.medal)
            {
                m_character.medal -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddOffer(int value)
        {
            return AddOffer(value, true);
        }
        public int AddOffer(int value, bool IsRate)
        {
            if (value > 0)
            {
                if (AntiAddictionMgr.ISASSon)
                {
                    //防沉迷
                    value = (int)(value * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
                }
                if (IsRate)
                {
                    value *= (int)OfferAddPlus == 0 ? 1 : (int)OfferAddPlus;
                }
                m_character.Offer += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveOffer(int value)
        {
            if (value > 0)
            {
                if (value >= m_character.Offer)
                {
                    value = m_character.Offer;
                }

                m_character.Offer -= value;
                OnPropertiesChanged();

                return value;
            }
            return 0;

        }
        public int RemoveGiftToken(int value)
        {
            if (value > 0 && value <= m_character.GiftToken)
            {
                m_character.GiftToken -= value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddGP(int gp)
        {
            if (gp >= 0)
            {
                if (AntiAddictionMgr.ISASSon)
                {
                    //防沉迷
                    gp = (int)(gp * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
                }
                //特定时间经验翻倍
                gp = (int)(gp * RateMgr.GetRate(eRateType.Experience_Rate));
                //经验翻倍道具卡翻倍
                if (GPAddPlus > 0)
                {
                    gp = (int)(gp * GPAddPlus);
                }

                m_character.GP += gp;

                if (m_character.GP < 1)
                    m_character.GP = 1;
                //Level = LevelMgr.FindLevelByGP(m_character.GP);
                Level = LevelMgr.GetLevel(m_character.GP);
                //UpdateFightPower();
                //OnPropertiesChanged();
                MainBag.UpdatePlayerProperties();
                return gp;
            }
            else
            {
                return 0;
            }
        }
        public int RemoveGP(int gp)
        {
            if (gp > 0)
            {
                m_character.GP -= gp;
                if (m_character.GP < 1)
                    m_character.GP = 1;
                //Level = LevelMgr.FindLevelByGP(m_character.GP);
                Level = LevelMgr.GetLevel(m_character.GP);
                OnPropertiesChanged();
                return gp;
            }
            else
            {
                return 0;
            }
        }
        public int AddRobRiches(int value)
        {
            if (value > 0)
            {
                if (AntiAddictionMgr.ISASSon)
                {
                    //防沉迷
                    value = (int)(value * AntiAddictionMgr.GetAntiAddictionCoefficient(PlayerCharacter.AntiAddiction));
                }
                m_character.RichesRob += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddRichesOffer(int value)
        {
            if (value > 0)
            {
                m_character.RichesOffer += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public int AddGiftToken(int value)
        {
            if (value > 0)
            {
                m_character.GiftToken += value;
                OnPropertiesChanged();
                return value;
            }
            else
            {
                return 0;
            }
        }
        public bool CanEquip(ItemTemplateInfo item)
        {
            bool result = true;
            string msg = "";

            if (!item.CanEquip)
            {
                result = false;
                msg = LanguageMgr.GetTranslation("Game.Server.GameObjects.NoEquip");
            }
            else if (!(item.NeedSex == 0 || item.NeedSex == (m_character.Sex ? 1 : 2)))
            {
                result = false;
                msg = LanguageMgr.GetTranslation("Game.Server.GameObjects.CanEquip");


            }
            else if (!(m_character.Grade >= item.NeedLevel))
            {
                result = false;
                msg = LanguageMgr.GetTranslation("Game.Server.GameObjects.CanLevel");
            }
            if (!result)
            {
                Out.SendMessage(Game.Server.Packets.eMessageType.ERROR, msg);
            }
            return result;
        }
        public void UpdateBaseProperties(int attack, int defence, int agility, int lucky, int hp)
        {
            if (attack != m_character.Attack || defence != m_character.Defence || agility != m_character.Agility || lucky != m_character.Luck)
            {
                m_character.Attack = attack;
                m_character.Defence = defence;
                m_character.Agility = agility;
                m_character.Luck = lucky;
                OnPropertiesChanged();
            }
            m_character.hp = (int)((hp + LevelPlusBlood + m_character.Defence / 10 + GetGoldBlood()) * GetBaseBlood());
        }

        public void UpdateStyle(string style, string colors, string skin)
        {
            if (style != m_character.Style || colors != m_character.Colors || skin != m_character.Skin)
            {
                m_character.Style = style;
                m_character.Colors = colors;
                m_character.Skin = skin;
                OnPropertiesChanged();
            }
        }
        public void UpdateFightPower()
        {
            int baseproperty = 0;
            FightPower = 0;
            int blood = 0;
            blood += PlayerCharacter.hp;
            baseproperty += PlayerCharacter.Attack;
            baseproperty += PlayerCharacter.Defence;
            baseproperty += PlayerCharacter.Agility;
            baseproperty += PlayerCharacter.Luck;
            FightPower += (int)((baseproperty + 1000) * (GetBaseAttack() * GetBaseAttack() * GetBaseAttack() + 3.5 * GetBaseDefence() * GetBaseDefence() * GetBaseDefence()) / 100000000 + blood * 0.95);// - 950);
            if (m_currentSecondWeapon != null)
            {
                FightPower += (int)(m_currentSecondWeapon.Template.Property7 * Math.Pow(1.1, (double)m_currentSecondWeapon.StrengthenLevel));
            }
            PlayerCharacter.FightPower = FightPower;
        }
        public int LevelPlusBlood
        {
            get
            {
                int plusblood = ExerciseMgr.GetExercise(m_character.Texp.hpTexpExp, "H");
                plusblood += LevelMgr.FindLevel(m_character.Grade).Blood;
                return plusblood;
            }

        }
        public void UpdateHide(int hide)
        {
            if (hide != m_character.Hide)
            {
                m_character.Hide = hide;
                OnPropertiesChanged();
            }
        }

        private ItemInfo m_MainWeapon;
        public ItemTemplateInfo MainWeapon
        {
            get
            {
                if (m_MainWeapon == null)
                    return null;
                return m_MainWeapon.Template;//trminhpc
            }
        }

        public void UpdateWeapon(ItemInfo item)
        {
            if (item != m_MainWeapon)
            {
                m_MainWeapon = item;
                OnPropertiesChanged();
            }
        }
        public void UpdatePet(UsersPetinfo pet)
        {
            m_pet = pet;
        }
        private ItemInfo m_currentSecondWeapon;
        public ItemInfo SecondWeapon
        {
            get
            {
                if (m_currentSecondWeapon == null)
                    return null;
                return m_currentSecondWeapon;
            }
        }

        public void UpdateSecondWeapon(ItemInfo item)
        {
            if (item != m_currentSecondWeapon)
            {
                m_currentSecondWeapon = item;
                OnPropertiesChanged();
            }
        }

        public void HideEquip(int categoryID, bool hide)
        {
            if (categoryID >= 0 && categoryID < 10)
            {
                EquipShowImp(categoryID, hide ? 2 : 1);
            }
        }

        public void ApertureEquip(int level)
        {
            EquipShowImp(0, level < 5 ? 1 : level < 7 ? 2 : 3);
        }

        private void EquipShowImp(int categoryID, int para)
        {
            UpdateHide((int)(m_character.Hide + Math.Pow(10, categoryID) * (para - m_character.Hide / (int)Math.Pow(10, categoryID) % 10)));
        }

        public void LogAddMoney(AddMoneyType masterType, AddMoneyType sonType, int userId, int moneys, int SpareMoney)
        {
            LogMgr.LogMoneyAdd((LogMoneyType)masterType, (LogMoneyType)sonType, userId, moneys, SpareMoney, 0, 0, 0, 0, "", "", "");
        }
        #endregion

        #region Database
        public bool Login()
        {
            if (WorldMgr.AddPlayer(m_character.ID, this))
            {
                try
                {
                    if (LoadFromDatabase())
                    {
                      
                        Out.SendLoginSuccess();
                        Out.SendUpdatePublicPlayer(PlayerCharacter);
                        Out.SendUpdatePlayerProperty(PlayerCharacter);
                        Out.SendDateTime();                                     
                        Out.SendDailyAward(this);
                        LoadMarryMessage();
                        Out.SendActivityList(PlayerCharacter.ID);
                        Out.SendOpenVIP(PlayerCharacter);
                        Out.SendOpenWorldBoss();
                        if (PlayerCharacter.Grade >= 30)
                        {
                            Out.SendPlayerFigSpiritinit(PlayerCharacter.ID, GemStone);
                        }
                        if (PlayerCharacter.Grade <= 20)
                        {
                            Out.SendGetBoxTime(PlayerCharacter.ID, PlayerCharacter.receiebox, false);
                        }
                        return true;
                    }
                    else
                    {
                        WorldMgr.RemovePlayer(m_character.ID);
                    }
                }
                catch (Exception ex)
                {
                    log.Error("Error Login!", ex);
                }
            }
            return false;
        }
        public void LoadMarryMessage()
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                MarryApplyInfo[] infos = db.GetPlayerMarryApply(PlayerCharacter.ID);

                if (infos != null)
                {
                    foreach (MarryApplyInfo info in infos)
                    {
                        switch (info.ApplyType)
                        {
                            case 1:  //请求结婚
                                Out.SendPlayerMarryApply(this, info.ApplyUserID, info.ApplyUserName, info.LoveProclamation, info.ID);
                                break;
                            case 2:  //应答结婚
                                Out.SendMarryApplyReply(this, info.ApplyUserID, info.ApplyUserName, info.ApplyResult, true, info.ID);
                                if (info.ApplyResult == false)
                                {
                                    Out.SendMailResponse(PlayerCharacter.ID, eMailRespose.Receiver);
                                }
                                break;
                            case 3:  //离婚消息
                                Out.SendPlayerDivorceApply(this, true, false);
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
        }

        public void ChargeToUser()
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                int money = 0;
                db.ChargeToUser(m_character.UserName, ref money, m_character.NickName);
                AddMoney(money);
                LogMgr.LogMoneyAdd(LogMoneyType.Charge, LogMoneyType.Charge_RMB, m_character.ID, money, m_character.Money, 0, 0, 0, 0, "", "", "");//添加日志
            }
        }
        public bool LoadFromDatabase()
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                PlayerInfo detail = db.GetUserSingleByUserID(m_character.ID);
                if (detail == null)
                {
                    Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.Forbid"));
                    Client.Disconnect();
                    return false;
                }
                else
                {
                    m_character = detail;
                    m_character.Texp = db.GetUserTexpInfoSingle(m_character.ID);
                    if (m_character.Texp.texpTaskDate.Date != DateTime.Now.Date)
                    {
                        m_character.Texp.texpCount = 0;
                        db.UpdateUserTexpInfo(m_character.Texp);
                    }

                    if (DateTime.Now.Date != m_character.TimeBox.Date)
                    {
                        m_character.TimeBox = DateTime.Now;
                        m_character.receiebox = 0;
                        m_character.MaxBuyHonor = 0;
                    }
                    if (m_character.Grade >= 20)
                    {
                        UpdateGemStone(db);
                    }
                }
                ChargeToUser();
                int[] sole = new int[] { 0, 1, 2 };
                Out.SendUpdateInventorySlot(FightBag, sole);
                UpdateWeaklessGuildProgress();
                UpdateItemForUser(1);
                ClearStoreBag();
                CheckExpireDay();
                //UpdateWeapon(m_mainBag.GetItemAt(6));
                UpdateWeapon(m_mainBag.GetItemAt(14));
                UpdatePet(m_petBag.GetPetIsEquip());
                UpdateSecondWeapon(m_mainBag.GetItemAt(15));
                m_pvepermissions = string.IsNullOrEmpty(detail.PvePermission) ? InitPvePermission() : m_converter.GetBytes(detail.PvePermission);
                _friends = new Dictionary<int, int>();
                _friends = db.GetFriendsIDAll(m_character.ID);
                _viFarms = new List<int>();
                m_character.State = 1;
                db.UpdatePlayer(m_character);
                return true;
            }

        }
        public void UpdateGemStone(PlayerBussiness db)
        {
            m_GemStone = db.GetSingleGemStones(m_character.ID);
            if (m_GemStone.Count == 0)
            {
                List<int> equipPlace = new List<int> { 11, 5, 2, 3, 13 };//11:Set, 5:mắt, 2:Tóc, 3:mặt, 13:cánh
                List<int> figSpiritId = new List<int> { 100002, 100003, 100001, 100004, 100005 };
                List<UserGemStone> UserGemStone = new List<UserGemStone>();
                for (int p = 0; p < equipPlace.Count; p++)
                {
                    UserGemStone _gemStone = new UserGemStone();
                    _gemStone.ID = 0;
                    _gemStone.UserID = m_character.ID;
                    _gemStone.FigSpiritId = figSpiritId[p];
                    _gemStone.FigSpiritIdValue = "0,0,0|0,0,1|0,0,2";
                    _gemStone.EquipPlace = equipPlace[p];
                    db.AddUserGemStone(_gemStone);
                    UserGemStone.Add(_gemStone);
                }
                m_GemStone = UserGemStone;
            }
        }
        public UserGemStone GetGemStone(int place)
        {
            //UserGemStone _gemStone = new UserGemStone();
            foreach (UserGemStone g in m_GemStone)
            {
                if (place == g.EquipPlace)
                    return g;
            }
            return null;
        }
        public void UpdateItemForUser(object state)
        {
            m_mainBag.LoadFromDatabase();
            m_propBag.LoadFromDatabase();
            m_ConsortiaBag.LoadFromDatabase();
            m_unbindBag.LoadFromDatabase();
 
            //m_BeadBag.LoadFromDatabase();
            m_farmBag.LoadFromDatabase();
            m_petBag.LoadFromDatabase();
            //m_food.LoadFromDatabase();
            //m_vegetable.LoadFromDatabase();
            //m_petEgg.LoadFromDatabase();
            m_cardBag.LoadFromDatabase();
            m_questInventory.LoadFromDatabase(m_character.ID);
            m_bufferList.LoadFromDatabase(m_character.ID);
            //m_farm.LoadFromDatabase();
        }

        public void CheckExpireDay()
        {
            //TimeSpan usedTime = DateTime.Now - m_character.LastVIPPackTime;
            if (m_character.VIPExpireDay.Date >= DateTime.Now.Date)
            {
                if (m_character.LastVIPPackTime.Date != DateTime.Now.Date)
                {
                    m_character.CanTakeVipReward = true;
                }
                else { m_character.CanTakeVipReward = false; }
            }
            else { m_character.CanTakeVipReward = false; }
        }
        public void LastVIPPackTime()
        {
            m_character.LastVIPPackTime = DateTime.Now;
            m_character.CanTakeVipReward = false;
        }
        public void OpenVIP(DateTime ExpireDayOut)
        {
            m_character.typeVIP = 1;
            m_character.VIPLevel = 1;
            m_character.VIPExp = 0;
            m_character.VIPExpireDay = ExpireDayOut;
            m_character.VIPLastDate = DateTime.Now;
            m_character.VIPNextLevelDaysNeeded = 0;
            m_character.CanTakeVipReward = true;
        }
        public void ContinousVIP(DateTime ExpireDayOut)
        {
            m_character.VIPExpireDay = ExpireDayOut;
        }
        /// <summary>
        /// Save the player into the database
        /// </summary>
        public bool SaveIntoDatabase()
        {
            try
            {
                if (m_character.IsDirty)
                {
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        db.UpdatePlayer(m_character);
                    }
                }
                MainBag.SaveToDatabase();
                PropBag.SaveToDatabase();
                ConsortiaBag.SaveToDatabase();
                //BeadBag.SaveToDatabase();
                //Vegetable.SaveToDatabase();
                //PetEgg.SaveToDatabase();
                //Food.SaveToDatabase();
                //Farm.SaveToDatabase();
                FarmBag.SaveToDatabase();
                PetBag.SaveToDatabase();
                CardBag.SaveToDatabase();
                QuestInventory.SaveToDatabase();
                BufferList.SaveToDatabase();
                //Farm.SaveToDatabase();
                return true;
            }
            catch (Exception e)
            {
                log.Error("Error saving player " + m_character.NickName + "!", e);
                return false;
            }
        }
        #endregion

        #region Quit
        /// <summary>
        /// This function saves the character and sends a message to all others
        /// that the player has quit the game!
        /// </summary>
        /// <param name="forced">true if Quit can not be prevented!</param>
        public virtual bool Quit()
        {
            try
            {
                //TODO: 新的这种退出办法的问题？
                //      1、经验值不能立刻扣除。
                //      2、退出游戏的逻辑放在房间里面。
                try
                {
                    if (CurrentRoom != null)
                    {
                        CurrentRoom.RemovePlayerUnsafe(this);
                        CurrentRoom = null;
                    }
                    else
                    {
                        RoomMgr.WaitingRoom.RemovePlayer(this);
                    }

                    if (_currentMarryRoom != null)
                    {
                        _currentMarryRoom.RemovePlayer(this);
                        _currentMarryRoom = null;
                    }
                }
                catch (Exception ex)
                {
                    log.Error("Player exit Game Error!", ex);
                }

                m_character.State = 0;
                SaveIntoDatabase();
            }
            catch (Exception ex)
            {
                log.Error("Player exit Error!!!", ex);
            }
            finally
            {
                WorldMgr.RemovePlayer(m_character.ID);
            }
            return true;
        }
        #endregion
        #region visitor farm
        private List<int> _viFarms;

        public List<int> ViFarms
        {
            get
            {
                return _viFarms;
            }
        }
        public void ViFarmsAdd(int playerID)
        {
            if (!_viFarms.Contains(playerID))
            {
                _viFarms.Add(playerID);
            }

        }

        public void ViFarmsRemove(int playerID)
        {
            if (_viFarms.Contains(playerID))
            {
                _viFarms.Remove(playerID);
            }
        }
        #endregion

        #region Friends Add/Remove/IsBlack

        private Dictionary<int, int> _friends;

        public Dictionary<int, int> Friends
        {
            get
            {
                return _friends;
            }
        }

        public void FriendsAdd(int playerID, int relation)
        {
            if (!_friends.ContainsKey(playerID))
            {
                _friends.Add(playerID, relation);
            }
            else
            {
                _friends[playerID] = relation;
            }
        }

        public void FriendsRemove(int playerID)
        {
            if (_friends.ContainsKey(playerID))
            {
                _friends.Remove(playerID);
            }
        }

        public bool IsBlackFriend(int playerID)
        {
            if (_friends == null)
                return true;

            if (_friends.ContainsKey(playerID))
            {
                return _friends[playerID] == 1;
            }
            return false;
        }

        #endregion

        #region Guild

        public void ClearConsortia()
        {
            PlayerCharacter.ClearConsortia();
            OnPropertiesChanged();

            QuestInventory.ClearConsortiaQuest();
            string sender = LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.Sender");
            string title = LanguageMgr.GetTranslation("Game.Server.GameUtils.Title");
            ConsortiaBag.SendAllItemsToMail(sender, title, eMailType.StoreCanel);
        }

        #endregion

        #region  Room/Game Properties/Events
        private BaseRoom m_currentRoom;
        public BaseRoom CurrentRoom
        {
            get { return m_currentRoom; }
            set
            {
                BaseRoom old = Interlocked.Exchange<BaseRoom>(ref m_currentRoom, value);
                if (old != null)
                {
                    RoomMgr.ExitRoom(old, this);
                }
            }
        }
        public int CurrentRoomIndex;
        public int CurrentRoomTeam;
        public int GamePlayerId { get; set; }

        public void Base(int template, ref double defence, ref double attack)
        {
            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(template);
            if (temp != null && temp.CategoryID == 11 && temp.Property1 == 31 && temp.Property2 == 3)
            {
                defence += temp.Property8;
                attack += temp.Property7;
            }
        }
        public void AddProperty(ItemInfo item, ref double defence, ref double attack)
        {
            if (item.Hole1 > 0)
            {
                Base(item.Hole1, ref defence, ref attack);
            }
            if (item.Hole2 > 0)
            {
                Base(item.Hole2, ref defence, ref attack);
            }
            if (item.Hole3 > 0)
            {
                Base(item.Hole3, ref defence, ref attack);
            }
            if (item.Hole4 > 0)
            {
                Base(item.Hole4, ref defence, ref attack);
            }
            if (item.Hole5 > 0)
            {
                Base(item.Hole5, ref defence, ref attack);
            }
            if (item.Hole6 > 0)
            {
                Base(item.Hole6, ref defence, ref attack);
            }
        }
        public double GetBaseAttack()
        {
            double baseattack = 0.0;
            double basedefence = 0.0;
            //ItemInfo weapon = m_mainBag.GetItemAt(6);
            ItemInfo weapon = m_mainBag.GetItemAt(14);
            if (weapon != null)
            {
                this.AddProperty(weapon, ref basedefence, ref baseattack);
                baseattack += weapon.Template.Property7 * Math.Pow(1.1, (double)weapon.StrengthenLevel);
            }
            ItemInfo head = m_mainBag.GetItemAt(0);
            if (head != null)
            {
                this.AddProperty(head, ref basedefence, ref baseattack);
                basedefence += (int)(head.Template.Property7 * Math.Pow(1.1, (double)head.StrengthenLevel));
            }
            ItemInfo cloth = m_mainBag.GetItemAt(4);
            if (cloth != null)
            {
                this.AddProperty(cloth, ref basedefence, ref baseattack);
                basedefence += (int)(cloth.Template.Property7 * Math.Pow(1.1, (double)cloth.StrengthenLevel));
            }
            return baseattack;
        }
        public double GetBaseDefence()
        {
            double basedefence = 0.0;
            double baseattack = 0.0;
            //ItemInfo weapon = m_mainBag.GetItemAt(6);
            ItemInfo weapon = m_mainBag.GetItemAt(14);
            if (weapon != null)
            {
                AddProperty(weapon, ref basedefence, ref baseattack);
                baseattack += weapon.Template.Property7 * Math.Pow(1.1, (double)weapon.StrengthenLevel);
            }
            ItemInfo head = m_mainBag.GetItemAt(0);
            if (head != null)
            {
                AddProperty(head, ref basedefence, ref baseattack);
                basedefence += (int)(head.Template.Property7 * Math.Pow(1.1, (double)head.StrengthenLevel));
            }
            ItemInfo cloth = m_mainBag.GetItemAt(4);
            if (cloth != null)
            {
                AddProperty(cloth, ref basedefence, ref baseattack);
                basedefence += (int)(cloth.Template.Property7 * Math.Pow(1.1, (double)cloth.StrengthenLevel));
            }
            return basedefence;
        }

        public double GetBaseAgility()
        {
            return 1 - m_character.Agility * 0.001;
        }
        /*/
        public void BaseAttack(int template, ref int baseattack)
        {
            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(template);
            if (temp != null)
            {
                if (temp.CategoryID == 11 && temp.Property1 == 31 && temp.Property2 == 3)
                {
                    baseattack += temp.Property7;
                }
            }
        }
        
        public void AddProperty(ItemInfo item, ref int defence)
        {
            if (item.Hole1 > 0)
                BaseDefence(item.Hole1, ref defence);
            if (item.Hole2 > 0)
                BaseDefence(item.Hole2, ref defence);
            if (item.Hole3 > 0)
                BaseDefence(item.Hole3, ref defence);
            if (item.Hole4 > 0)
                BaseDefence(item.Hole4, ref defence);
            if (item.Hole5 > 0)
                BaseDefence(item.Hole5, ref defence);
            if (item.Hole6 > 0)
                BaseDefence(item.Hole6, ref defence);
        }
        public void BaseDefence(int template, ref int defence)
        {
            ItemTemplateInfo temp = ItemMgr.FindItemTemplate(template);
            if (temp != null)
            {
                if (temp.CategoryID == 11 && temp.Property1 == 31 && temp.Property2 == 3)
                {
                    defence += temp.Property8;
                }
            }
        }
        
        public double GetBaseAttack()
        {
            int baseattack = 0;
            ItemInfo item = m_mainBag.GetItemAt(6);
            if (item != null)
            {
                if (item.Hole1 > 0)
                    BaseAttack(item.Hole1, ref baseattack);
                if (item.Hole2 > 0)
                    BaseAttack(item.Hole2, ref baseattack);
                if (item.Hole3 > 0)
                    BaseAttack(item.Hole3, ref baseattack);
                if (item.Hole4 > 0)
                    BaseAttack(item.Hole4, ref baseattack);
                if (item.Hole5 > 0)
                    BaseAttack(item.Hole5, ref baseattack);
                if (item.Hole6 > 0)
                    BaseAttack(item.Hole6, ref baseattack);
                return item.Template.Property7 * Math.Pow(1.1, item.StrengthenLevel) + baseattack;
            }
            return 50;
        }
        public double GetBaseDefence()
        {
            int defence = 0;
            ItemInfo head = m_mainBag.GetItemAt(0);
            ItemInfo cloth = m_mainBag.GetItemAt(4);
            if (head != null)
            {
                AddProperty(head, ref defence);
                defence += head.Template.Property7 * (int)Math.Pow(1.1, head.StrengthenLevel);
            }

            if (cloth != null)
            {
                AddProperty(cloth, ref defence);
                defence += cloth.Template.Property7 * (int)Math.Pow(1.1, cloth.StrengthenLevel);
            }

            return defence;
        }*/

        public double GetBaseBlood()
        {
            ItemInfo info = MainBag.GetItemAt(12);
            return info == null ? 1 : (100 + (double)info.Template.Property1) / 100;
        }
        public double GetGoldBlood()
        {
            ItemInfo heat = MainBag.GetItemAt(0);
            ItemInfo cloth = MainBag.GetItemAt(4);
            GoldEquipTemplateLoadInfo goldEquip;
            double goldBood = 0;
            if (heat != null)
            {
                goldEquip = GoldEquipMgr.FindGoldEquipCategoryID(heat.Template.CategoryID);
                if (heat.IsGold)
                {
                    goldBood += goldEquip.Boold;
                }
            }
            if (cloth != null)
            {
                goldEquip = GoldEquipMgr.FindGoldEquipCategoryID(cloth.Template.CategoryID);
                if (cloth.IsGold)
                {
                    goldBood += goldEquip.Boold;
                }
            }
            return goldBood;
        }
        private void SendItemNotice(ItemInfo info)
        {
            GSPacketIn pkg = new GSPacketIn((byte)Game.Server.Packets.ePackageType.GET_ITEM_MESS);
            pkg.WriteString(PlayerCharacter.NickName);
            pkg.WriteInt(1);
            pkg.WriteInt(info.TemplateID);
            pkg.WriteBoolean(info.IsBinds);
            pkg.WriteInt(1);
            pkg.WriteString(info.Template.Name);
            if (info.Template.Quality >= 3 && info.Template.Quality < 5)
            {
                if (CurrentRoom != null)
                {
                    CurrentRoom.SendToTeam(pkg, CurrentRoomTeam, this);
                    //Console.WriteLine(">=3 && <5 " + info.Template.Name);
                }
            }
            /*
            else if (info.Template.Quality >= 5)
            {
                GameServer.Instance.LoginServer.SendPacket(pkg);

                GamePlayer[] players = Game.Server.Managers.WorldMgr.GetAllPlayers();
                foreach (GamePlayer p in players)
                {
                    if (p != this)
                    {
                        p.Out.SendTCP(pkg);
                        //Console.WriteLine(">=5 " + info.Template.Name);
                    }
                }

            }*/
        }
        public bool RemoveAt(eBageType bagType, int place)
        {
            PlayerInventory bag = GetInventory(bagType);
            if (bag != null)
            {
                return bag.RemoveItemAt(place);
            }
            else
            {
                return false;
            }
        }
        public bool DeletePropItem(int place)
        {
            FightBag.RemoveItemAt(place);
            return true;
        }
        public bool UsePropItem(AbstractGame game, int bag, int place, int templateId, bool isLiving)
        {
            //背包中的道具
            if (bag == (int)eBageType.PropBag)
            {
                ItemTemplateInfo template = PropItemMgr.FindFightingProp(templateId);
                if (isLiving && template != null)
                {
                    OnUsingItem(template.TemplateID);
                    if (place == -1 && CanUseProp)
                    {
                        return true;
                    }
                    else
                    {
                        ItemInfo item = GetItemAt(eBageType.PropBag, place);
                        if (item != null && item.IsValidItem() && item.Count >= 0)
                        {
                            item.Count--;
                            UpdateItem(item);

                            return true;
                        }
                    }
                }
            }
            //道具栏的道具
            else
            {
                ItemInfo item = GetItemAt(eBageType.FightBag, place);
                if (item.TemplateID == templateId)
                {
                    OnUsingItem(item.TemplateID);
                    return RemoveAt(eBageType.FightBag, place);
                }
            }
            return false;
        }

        public void Disconnect()
        {
            m_client.Disconnect();
        }

        public void SendTCP(GSPacketIn pkg)
        {
            if (m_client.IsConnected)
            {
                m_client.SendTCP(pkg);
            }
        }

        #endregion

        #region Marry
        public int X;
        public int Y;
        public int MarryMap;

        private MarryRoom _currentMarryRoom;
        public MarryRoom CurrentMarryRoom
        {
            get
            {
                return _currentMarryRoom;
            }
            set
            {
                _currentMarryRoom = value;
            }
        }
        public bool IsInMarryRoom
        {
            get
            {
                return _currentMarryRoom != null;
            }
        }
        public void LoadMarryProp()
        {
            using (PlayerBussiness db = new PlayerBussiness())
            {
                MarryProp info = db.GetMarryProp(PlayerCharacter.ID);
                PlayerCharacter.IsMarried = info.IsMarried;
                PlayerCharacter.SpouseID = info.SpouseID;
                PlayerCharacter.SpouseName = info.SpouseName;
                PlayerCharacter.IsCreatedMarryRoom = info.IsCreatedMarryRoom;
                PlayerCharacter.SelfMarryRoomID = info.SelfMarryRoomID;
                PlayerCharacter.IsGotRing = info.IsGotRing;

                Out.SendMarryProp(this, info);
            }
        }
        #endregion
        #region HotSpringRoom
        public int Hot_X;
        public int Hot_Y;
        public int HotMap;

        //private HotSpringRoom _currentHotSpringRoom;
        //public HotSpringRoom CurrentHotSpringRoom
        //{
        //   get
        //   {
        //       return _currentHotSpringRoom;
        //    }
        //    set
        //    {
        //        _currentHotSpringRoom = value;
        //    }
        //}
        //public bool IsInHotSpringRoom
        //{
        //    get
        //    {
        //        return _currentHotSpringRoom != null;
        //    }
        //}

        #endregion

        #region ToString
        public override string ToString()
        {
            return string.Format("Id:{0} nickname:{1} room:{2} ", PlayerId, PlayerCharacter.NickName, CurrentRoom);
        }
        #endregion

        #region IGamePlayer Members
        public int ConsortiaFight(int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth, int count)
        {
            return ConsortiaMgr.ConsortiaFight(consortiaWin, consortiaLose, players, roomType, gameClass, totalKillHealth, count);
        }
        public void SendConsortiaFight(int consortiaID, int riches, string msg)
        {
            GSPacketIn pkg = new GSPacketIn((byte)eChatServerPacket.CONSORTIA_FIGHT);
            pkg.WriteInt(consortiaID);
            pkg.WriteInt(riches);
            pkg.WriteString(msg);

            GameServer.Instance.LoginServer.SendPacket(pkg);
        }
        public int ServerID
        {
            get;
            set;
        }
        #endregion

        #region PvePermission
        private System.Text.UTF8Encoding m_converter;
        public byte[] InitPvePermission()
        {
            byte[] tempByte = new byte[50];
            for (int i = 0; i < 50; i++)
            {
                //每个副本的简单难度等级都是可以玩的
                tempByte[i] = 17;
            }
            return tempByte;
        }
        public bool SetPvePermission(int missionId, eHardLevel hardLevel)
        {
            if (missionId > m_pvepermissions.Length * 2)
                return false;
            if (hardLevel == eHardLevel.Terror)
                return true;
            if (!IsPvePermission(missionId, hardLevel))
                return false;

            //int index = (missionId - 1) / 2;
            //int offset = missionId % 2 == 0 ? 4 + (int)hardLevel : (int)hardLevel;
            ////当前难度完成时，设置下一个难度可以玩
            //offset += 1;
            //m_pvepermissions[index] |= (byte)(0x01 << offset);
            //m_character.PvePermission = m_converter.GetString(m_pvepermissions);
            var setPvePermision = string.Empty;
            string right = m_converter.GetString(m_pvepermissions).Substring(missionId - 1, 1);
            if (hardLevel == eHardLevel.Simple && right == "1")
            {

                setPvePermision = "3";
            }
            else if (hardLevel == eHardLevel.Normal && right == "3")
            {

                setPvePermision = "7";
            }
            else if (hardLevel == eHardLevel.Hard && right == "7")
            {
                setPvePermision = "F";
            }
            else
            {
                return false;
            }
            var strPvePermision = m_converter.GetString(m_pvepermissions);
            var length = strPvePermision.Length;
            strPvePermision = strPvePermision.Substring(0, missionId - 1) + setPvePermision + strPvePermision.Substring(missionId, length - missionId);
            m_character.PvePermission = strPvePermision;
            OnPropertiesChanged();
            return true;
        }
        public bool IsPvePermission(int missionId, eHardLevel hardLevel)
        {
            //if (missionId > m_pvepermissions.Length * 2)
            //    return false;
            if (hardLevel == eHardLevel.Simple)
                return true;
            //int index = (missionId - 1) / 2;
            //int offset = missionId % 2 == 0 ? 4 + (int)hardLevel : (int)hardLevel;
            //int result = m_pvepermissions[index] & (0x01 << offset);

            //return result != 0;
            string right = m_converter.GetString(m_pvepermissions).Substring(missionId - 1, 1);
            //if (hardLevel == eHardLevel.Simple||right==string.Empty)
            ////    return true;
            if (hardLevel == eHardLevel.Normal)
            {
                if (right == "3" || right == "7" || right == "F") return true;
            }
            else if (hardLevel == eHardLevel.Hard)
            {
                if (right == "7" || right == "F") return true;
            }
            else if (hardLevel == eHardLevel.Terror)
            {
                if (right == "F") return true;
            }

            return false;

        }
        #endregion

        #region send message
        /// <summary>
        /// 发送点券不足信息
        /// </summary>
        /// <param name="player"></param>
        /// <param name="type">0:boss战游戏开始点券不足, 1:付费翻牌点券不足, 2:再试一次点券不足</param>
        /// <returns></returns>
        public void SendInsufficientMoney(int type)
        {
            GSPacketIn pkg = new GSPacketIn((byte)Game.Logic.eTankCmdType.INSUFFICIENT_MONEY, PlayerId);
            pkg.WriteByte((byte)type);
            pkg.WriteBoolean(false);
            SendTCP(pkg);
        }
        public void SendMessage(string msg)
        {
            GSPacketIn pkg = new GSPacketIn((byte)Game.Server.Packets.ePackageType.SYS_MESSAGE);
            pkg.WriteInt(0);
            pkg.WriteString(msg);
            SendTCP(pkg);
        }
        #endregion

        //newwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type)
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                return SendItemsToMail(items, content, title, type, pb);
            }
        }
        public bool SendItemsToMail(List<ItemInfo> items, string content, string title, eMailType type, PlayerBussiness pb)
        {
            bool result = true;
            for (int i = 0; i < items.Count; i += 5)
            {
                ItemInfo it;
                MailInfo mail = new MailInfo
                {
                    Title = (title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title"),
                    Gold = 0,
                    IsExist = true,
                    Money = 0,
                    Receiver = this.PlayerCharacter.NickName,
                    ReceiverID = this.PlayerId,
                    Sender = this.PlayerCharacter.NickName,
                    SenderID = this.PlayerId,
                    Type = (int)type,
                    GiftToken = 0
                };
                List<ItemInfo> sent = new List<ItemInfo>();
                StringBuilder annexRemark = new StringBuilder();
                StringBuilder mailContent = new StringBuilder();
                annexRemark.Append(LanguageMgr.GetTranslation("Game.Server.GameUtils.CommonBag.AnnexRemark"));
                content = (content != null) ? LanguageMgr.GetTranslation(content) : "";
                int index = i;
                if (items.Count > index)
                {
                    it = items[index];
                    if (it.ItemID == 0)
                    {
                        pb.AddGoods(it);
                    }
                    mail.Annex1 = it.ItemID.ToString();
                    mail.Annex1Name = it.Template.Name;
                    mail.Title = it.Template.Name;
                    annexRemark.Append(string.Concat("1、", mail.Annex1Name, "x", it.Count, ";"));
                    mailContent.Append(string.Concat("1、", mail.Annex1Name, "x", it.Count, ";"));
                    sent.Add(it);
                }
                index = i + 1;
                if (items.Count > index)
                {
                    it = items[index];
                    if (it.ItemID == 0)
                    {
                        pb.AddGoods(it);
                    }
                    mail.Annex2 = it.ItemID.ToString();
                    mail.Annex2Name = it.Template.Name;
                    annexRemark.Append(string.Concat("2、", mail.Annex2Name, "x", it.Count, ";"));
                    mailContent.Append(string.Concat("2、", mail.Annex2Name, "x", it.Count, ";"));
                    sent.Add(it);
                }
                index = i + 2;
                if (items.Count > index)
                {
                    it = items[index];
                    if (it.ItemID == 0)
                    {
                        pb.AddGoods(it);
                    }
                    mail.Annex3 = it.ItemID.ToString();
                    mail.Annex3Name = it.Template.Name;
                    annexRemark.Append(string.Concat("3、", mail.Annex3Name, "x", it.Count, ";"));
                    mailContent.Append(string.Concat("3、", mail.Annex3Name, "x", it.Count, ";"));
                    sent.Add(it);
                }
                index = i + 3;
                if (items.Count > index)
                {
                    it = items[index];
                    if (it.ItemID == 0)
                    {
                        pb.AddGoods(it);
                    }
                    mail.Annex4 = it.ItemID.ToString();
                    mail.Annex4Name = it.Template.Name;
                    annexRemark.Append(string.Concat("4、", mail.Annex4Name, "x", it.Count, ";"));
                    mailContent.Append(string.Concat("4、", mail.Annex4Name, "x", it.Count, ";"));
                    sent.Add(it);
                }
                index = i + 4;
                if (items.Count > index)
                {
                    it = items[index];
                    if (it.ItemID == 0)
                    {
                        pb.AddGoods(it);
                    }
                    mail.Annex5 = it.ItemID.ToString();
                    mail.Annex5Name = it.Template.Name;
                    annexRemark.Append(string.Concat("5、", mail.Annex5Name, "x", it.Count, ";"));
                    mailContent.Append(string.Concat("5、", mail.Annex5Name, "x", it.Count, ";"));
                    sent.Add(it);
                }
                mail.AnnexRemark = annexRemark.ToString();
                if (content == null && mailContent.ToString() == null)
                {
                    mail.Content = LanguageMgr.GetTranslation("Game.Server.GameUtils.Content");
                }
                else if (content != "")
                {
                    mail.Content = content;
                }
                else
                {
                    mail.Content = mailContent.ToString();
                }
                if (pb.SendMail(mail))
                {
                    foreach (ItemInfo item in sent)
                    {
                        TakeOutItem(item);
                    }
                }
                else
                {
                    result = false;
                }
            }
            return result;
        }

        public bool SendItemToMail(ItemInfo item, string content, string title, eMailType type)
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                return SendItemToMail(item, pb, content, title, type);
            }
        }
        public bool SendItemToMail(ItemInfo item, PlayerBussiness pb, string content, string title, eMailType type)
        {
            MailInfo mail = new MailInfo
            {
                Content = (content != null) ? content : LanguageMgr.GetTranslation("Game.Server.GameUtils.Content"),
                Title = (title != null) ? title : LanguageMgr.GetTranslation("Game.Server.GameUtils.Title"),
                Gold = 0,
                IsExist = true,
                Money = 0,
                GiftToken = 0,
                Receiver = PlayerCharacter.NickName,
                ReceiverID = PlayerCharacter.ID,
                Sender = PlayerCharacter.NickName,
                SenderID = PlayerCharacter.ID,
                Type = (int)type
            };
            if (item.ItemID == 0)
            {
                pb.AddGoods(item);
            }
            mail.Annex1 = item.ItemID.ToString();
            mail.Annex1Name = item.Template.Name;
            if (pb.SendMail(mail))
            {
                TakeOutItem(item);
                return true;
            }
            return false;
        }
        public bool TakeOutItem(ItemInfo item)
        {
            if (item.BagType == m_propBag.BagType)
            {
                return m_propBag.TakeOutItem(item);
            }
            if (item.BagType == m_fightBag.BagType)
            {
                return m_fightBag.TakeOutItem(item);
            }
            //if (item.BagType == m_hideBag.BagType)
            //{
            //    return .m_hideBag.TakeOutItem(item);
            //}
            if (item.BagType == m_ConsortiaBag.BagType)
            {
                return m_ConsortiaBag.TakeOutItem(item);
            }
            return m_mainBag.TakeOutItem(item);
        }
        private Dictionary<string, object> m_tempProperties = new Dictionary<string, object>();

        public Dictionary<string, object> TempProperties
        {
            get
            {
                return m_tempProperties;
            }
        }




    }


}
