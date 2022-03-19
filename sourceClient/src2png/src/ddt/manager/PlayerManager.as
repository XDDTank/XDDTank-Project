// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PlayerManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import im.info.CustomInfo;
    import ddt.data.player.SelfInfo;
    import ddt.data.club.ClubInfo;
    import ddt.data.AccountInfo;
    import pet.date.PetInfo;
    import flash.utils.Dictionary;
    import ddt.data.player.PlayerPropertyType;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import road7th.comm.PackageIn;
    import ddt.data.BagInfo;
    import ddt.states.StateType;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.data.player.PlayerInfo;
    import room.RoomManager;
    import room.model.RoomInfo;
    import cityWide.CityWideEvent;
    import ddt.events.BagEvent;
    import baglocked.BagLockedController;
    import ddt.data.player.FriendListPlayer;
    import ddt.data.player.PlayerState;
    import ddt.data.PathInfo;
    import im.AddCommunityFriend;
    import im.IMEvent;
    import platformapi.tencent.DiamondManager;
    import consortion.ConsortionModelControl;
    import ddt.events.PlayerPropertyEvent;
    import ddt.events.TimeEvents;
    import flash.events.Event;
    import ddt.data.goods.BagCellInfo;
    import totem.TotemManager;
    import com.pickgliss.ui.ComponentFactory;
    import roomList.PassInputFrame;
    import com.pickgliss.ui.LayerManager;
    import road7th.data.DictionaryEvent;
    import ddt.data.CMFriendInfo;
    import flash.utils.ByteArray;
    import ddt.view.chat.ChatData;
    import ddt.data.analyze.FriendListAnalyzer;
    import ddt.data.analyze.RecentContactsAnalyze;
    import im.IMController;
    import bagAndInfo.cell.BagCell;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import ddt.data.CheckCodeData;
    import road7th.utils.BitmapReader;
    import ddt.view.CheckCodeFrame;
    import ddt.data.BuffInfo;
    import ddt.data.analyze.InvitedFriendListAnalyzer;
    import ddt.data.player.InvitedFirendListPlayer;
    import __AS3__.vec.*;

    public class PlayerManager extends EventDispatcher 
    {

        public static const FRIEND_STATE_CHANGED:String = "friendStateChanged";
        public static const FRIENDLIST_COMPLETE:String = "friendListComplete";
        public static const RECENT_CONTAST_COMPLETE:String = "recentContactsComplete";
        public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
        public static const VIP_STATE_CHANGE:String = "VIPStateChange";
        public static const GIFT_INFO_CHANGE:String = "giftInfoChange";
        public static const SELF_GIFT_INFO_CHANGE:String = "selfGiftInfoChange";
        public static const NEW_GIFT_UPDATE:String = "newGiftUPDATE";
        public static const NEW_GIFT_ADD:String = "newGiftAdd";
        public static const FARM_BAG_UPDATE:String = "farmDataUpdate";
        public static const UPDATE_PLAYER_PROPERTY:String = "updatePlayerState";
        public static const UPDATE_PET:String = "updatePet";
        public static const CHAGE_STATE:String = "changestate";
        public static const UPDATE_BAG_CELL:String = "updatebagcell";
        public static const UPDATE_FIGHT_VIP:String = "updateFightVip";
        public static const UPDATE_FATIUE:String = "updateFatiue";
        public static const BUY_FATIUE:String = "buyFatiue";
        public static const UPDATE_GRADE:String = "updateGrade";
        public static const UPDATE_ROOMPLAYER:String = "updateRoomPlayer";
        public static const UPDATE_BAGLIST:String = "updatebaglist";
        public static var isShowPHP:Boolean = false;
        public static const CUSTOM_MAX:int = 10;
        private static var _instance:PlayerManager;
        public static var SelfStudyEnergy:Boolean = true;

        private var _recentContacts:DictionaryData;
        public var customList:Vector.<CustomInfo>;
        private var _friendList:DictionaryData;
        private var _cmFriendList:DictionaryData;
        private var _blackList:DictionaryData;
        private var _clubPlays:DictionaryData;
        private var _tempList:DictionaryData;
        private var _mailTempList:DictionaryData;
        private var _myAcademyPlayers:DictionaryData;
        private var _sameCityList:Array;
        private var _self:SelfInfo;
        public var SelfConsortia:ClubInfo = new ClubInfo();
        private var _account:AccountInfo;
        private var _first:Boolean = false;
        private var _propertyAdditions:DictionaryData;
        private var tempStyle:Array = [];
        private var changedStyle:DictionaryData = new DictionaryData();
        private var _gamepetInfo:PetInfo;
        private var _playerState:String = "equip";
        private var _iconShineDic:Dictionary = new Dictionary();
        private var _invitedFriendList:DictionaryData;
        private var _invitedAwardStep:int;
        public var _inviterID:uint;

        public function PlayerManager()
        {
            this._self = new SelfInfo();
            this._clubPlays = new DictionaryData();
            this._tempList = new DictionaryData();
            this._mailTempList = new DictionaryData();
        }

        public static function get Instance():PlayerManager
        {
            if (_instance == null)
            {
                _instance = new (PlayerManager)();
            };
            return (_instance);
        }

        public static function readLuckyPropertyName(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case PlayerPropertyType.Exp:
                    return (LanguageMgr.GetTranslation("exp"));
                case PlayerPropertyType.Offer:
                    return (LanguageMgr.GetTranslation("offer"));
                case PlayerPropertyType.Attack:
                    return (LanguageMgr.GetTranslation("attack"));
                case PlayerPropertyType.Agility:
                    return (LanguageMgr.GetTranslation("agility"));
                case PlayerPropertyType.Damage:
                    return (LanguageMgr.GetTranslation("damage"));
                case PlayerPropertyType.Defence:
                    return (LanguageMgr.GetTranslation("defence"));
                case PlayerPropertyType.Luck:
                    return (LanguageMgr.GetTranslation("luck"));
                case PlayerPropertyType.MaxHp:
                    return (LanguageMgr.GetTranslation("MaxHp"));
                case PlayerPropertyType.Recovery:
                    return (LanguageMgr.GetTranslation("recovery"));
                default:
                    return ("");
            };
        }


        public function get Self():SelfInfo
        {
            return (this._self);
        }

        public function get isLeadOfConsortia():Boolean
        {
            if (this.Self.consortiaInfo.ChairmanID == this.Self.ID)
            {
                return (true);
            };
            return (false);
        }

        public function setup(_arg_1:AccountInfo):void
        {
            this._account = _arg_1;
            this.customList = new Vector.<CustomInfo>();
            this._friendList = new DictionaryData();
            this._blackList = new DictionaryData();
            this._invitedFriendList = new DictionaryData();
            this.initEvents();
        }

        public function get Account():AccountInfo
        {
            return (this._account);
        }

        public function set Account(_arg_1:AccountInfo):void
        {
            this._account = _arg_1;
        }

        public function getDressEquipPlace(_arg_1:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_2:Array = EquipType.CategeryIdToPlace(_arg_1.CategoryID);
            if (EquipType.isRingEquipment(_arg_1))
            {
                _local_3 = 6;
            }
            else
            {
                if (_local_2.length == 1)
                {
                    _local_3 = _local_2[0];
                }
                else
                {
                    _local_4 = 0;
                    _local_5 = 0;
                    while (_local_5 < _local_2.length)
                    {
                        if (PlayerManager.Instance.Self.Bag.getItemAt(_local_2[_local_5]) == null)
                        {
                            _local_3 = _local_2[_local_5];
                            break;
                        };
                        _local_4++;
                        if (_local_4 == _local_2.length)
                        {
                            _local_3 = _local_2[0];
                        };
                        _local_5++;
                    };
                };
            };
            return (_local_3);
        }

        public function getEquipPlace(_arg_1:InventoryItemInfo):int
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            if (EquipType.isWeddingRing(_arg_1))
            {
                return (6);
            };
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            var _local_3:Array = EquipType.getTemplateTypeToPlace(_local_2.TemplateType);
            if (_local_3.length == 1)
            {
                _local_4 = _local_3[0];
            }
            else
            {
                _local_5 = 0;
                _local_6 = 0;
                while (_local_6 < _local_3.length)
                {
                    if (PlayerManager.Instance.Self.Bag.getItemAt(_local_3[_local_6]) == null)
                    {
                        _local_4 = _local_3[_local_6];
                        break;
                    };
                    _local_5++;
                    if (_local_5 == _local_3.length)
                    {
                        _local_4 = _local_3[0];
                    };
                    _local_6++;
                };
            };
            return (_local_4);
        }

        private function __updateInventorySlot(evt:CrazyTankSocketEvent):void
        {
            var i:int;
            var slot:int;
            var isUpdate:Boolean;
            var item:InventoryItemInfo;
            var sign:Boolean;
            var pkg:PackageIn = (evt.pkg as PackageIn);
            var bagType:int = pkg.readInt();
            var len:int = pkg.readInt();
            var bag:BagInfo = this._self.getBag(bagType);
            bag.beginChanges();
            try
            {
                i = 0;
                while (i < len)
                {
                    slot = pkg.readInt();
                    isUpdate = pkg.readBoolean();
                    if (isUpdate)
                    {
                        item = bag.getItemAt(slot);
                        if (item == null)
                        {
                            item = new InventoryItemInfo();
                            item.Place = slot;
                        };
                        item.UserID = pkg.readInt();
                        item.ItemID = pkg.readInt();
                        item.Count = pkg.readInt();
                        item.Place = pkg.readInt();
                        item.TemplateID = pkg.readInt();
                        ItemManager.fill(item);
                        item.AttackCompose = pkg.readInt();
                        item.DefendCompose = pkg.readInt();
                        item.AgilityCompose = pkg.readInt();
                        item.LuckCompose = pkg.readInt();
                        item.StrengthenLevel = pkg.readInt();
                        item.StrengthenExp = pkg.readInt();
                        item.IsBinds = pkg.readBoolean();
                        item.IsJudge = pkg.readBoolean();
                        item.BeginDate = pkg.readDateString();
                        item.ValidDate = pkg.readInt();
                        item.Color = pkg.readUTF();
                        item.Skin = pkg.readUTF();
                        item.IsUsed = pkg.readBoolean();
                        item.Hole1 = pkg.readInt();
                        item.Hole2 = pkg.readInt();
                        item.Hole3 = pkg.readInt();
                        item.Hole4 = pkg.readInt();
                        item.Hole5 = pkg.readInt();
                        item.Hole6 = pkg.readInt();
                        item.Pic = pkg.readUTF();
                        item.RefineryLevel = pkg.readInt();
                        item.DiscolorValidDate = pkg.readDateString();
                        item.StrengthenTimes = pkg.readInt();
                        item.beadIsLock = pkg.readByte();
                        item.beadLevel = pkg.readInt();
                        item.Hole6Level = pkg.readByte();
                        item.beadExp = pkg.readInt();
                        item.isGold = pkg.readBoolean();
                        if (item.isGold)
                        {
                            item.goldValidDate = pkg.readInt();
                            item.goldBeginTime = pkg.readDateString();
                        };
                        bag.addItem(item);
                        if ((((item.Place == 20) && (bagType == 0)) && (item.UserID == this.Self.ID)))
                        {
                            this._self.DeputyWeaponID = item.TemplateID;
                        };
                        if ((((PathManager.solveExternalInterfaceEnabel()) && (bagType == BagInfo.STOREBAG)) && (item.StrengthenLevel >= 7)))
                        {
                            ExternalInterfaceManager.sendToAgent(3, this.Self.ID, this.Self.NickName, ServerManager.Instance.zoneName, item.StrengthenLevel);
                        };
                        if (StateManager.currentStateType == StateType.AUCTION)
                        {
                        };
                    }
                    else
                    {
                        bag.removeItemAt(slot);
                    };
                    i = (i + 1);
                };
            }
            finally
            {
                bag.commiteChanges();
            };
        }

        private function __itemEquip(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:InventoryItemInfo;
            var _local_12:uint;
            var _local_13:InventoryItemInfo;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:PetInfo;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_3:PackageIn = _arg_1.pkg;
            _local_3.deCompress();
            var _local_4:int = _local_3.readInt();
            var _local_5:int = _local_3.readInt();
            var _local_6:String = _local_3.readUTF();
            var _local_7:PlayerInfo = this.findPlayer(_local_4, _local_5, _local_6);
            _local_7.ID = _local_4;
            if (_local_7 != null)
            {
                _local_7.beginChanges();
                _local_7.Attack = _local_3.readInt();
                _local_7.Defence = _local_3.readInt();
                _local_7.Agility = _local_3.readInt();
                _local_7.Luck = _local_3.readInt();
                _local_7.Damage = _local_3.readInt();
                _local_7.Guard = _local_3.readInt();
                _local_7.hp = _local_3.readInt();
                _local_7.Energy = _local_3.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_4))))
                {
                    _local_7.Colors = _local_3.readUTF();
                    _local_7.Skin = _local_3.readUTF();
                }
                else
                {
                    _local_3.readUTF();
                    _local_3.readUTF();
                    _local_7.Colors = this.changedStyle[_local_4]["Colors"];
                    _local_7.Skin = this.changedStyle[_local_4]["Skin"];
                };
                _local_7.GP = _local_3.readInt();
                _local_7.Grade = _local_3.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_4))))
                {
                    _local_7.Hide = _local_3.readInt();
                }
                else
                {
                    _local_3.readInt();
                    _local_7.Hide = this.changedStyle[_local_4]["Hide"];
                };
                _local_7.Repute = _local_3.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_4))))
                {
                    _local_7.Sex = _local_3.readBoolean();
                    _local_7.Style = _local_3.readUTF();
                }
                else
                {
                    _local_3.readBoolean();
                    _local_3.readUTF();
                    _local_7.Sex = this.changedStyle[_local_4]["Sex"];
                    _local_7.Style = this.changedStyle[_local_4]["Style"];
                };
                _local_7.Offer = _local_3.readInt();
                _local_7.NickName = _local_6;
                _local_7.VIPtype = _local_3.readByte();
                _local_7.VIPLevel = _local_3.readInt();
                _local_7.isFightVip = _local_3.readBoolean();
                _local_7.fightToolBoxSkillNum = _local_3.readInt();
                _local_7.WinCount = _local_3.readInt();
                _local_7.TotalCount = _local_3.readInt();
                _local_7.EscapeCount = _local_3.readInt();
                _local_7.ConsortiaID = _local_3.readInt();
                _local_7.ConsortiaName = _local_3.readUTF();
                _local_7.RichesOffer = _local_3.readInt();
                _local_7.RichesRob = _local_3.readInt();
                _local_7.IsMarried = _local_3.readBoolean();
                _local_7.SpouseID = _local_3.readInt();
                _local_7.SpouseName = _local_3.readUTF();
                _local_7.DutyName = _local_3.readUTF();
                _local_7.FightPower = _local_3.readInt();
                _local_7.apprenticeshipState = _local_3.readInt();
                _local_7.masterID = _local_3.readInt();
                _local_7.setMasterOrApprentices(_local_3.readUTF());
                _local_7.graduatesCount = _local_3.readInt();
                _local_7.honourOfMaster = _local_3.readUTF();
                _local_7.AchievementPoint = _local_3.readInt();
                _local_7.honor = _local_3.readUTF();
                _local_7.LastLoginDate = _local_3.readDate();
                _local_7.Fatigue = _local_3.readInt();
                _local_7.DailyLeagueFirst = _local_3.readBoolean();
                _local_7.DailyLeagueLastScore = _local_3.readInt();
                _local_7.totemId = _local_3.readInt();
                _local_7.runeLevel = _local_3.readInt();
                _local_8 = _local_3.readInt();
                _local_7.Bag.beginChanges();
                if ((!(_local_7 is SelfInfo)))
                {
                    _local_7.Bag.clearnAll();
                };
                _local_2 = 0;
                while (_local_2 < _local_8)
                {
                    _local_11 = new InventoryItemInfo();
                    _local_11.BagType = _local_3.readByte();
                    _local_11.UserID = _local_3.readInt();
                    _local_11.ItemID = _local_3.readInt();
                    _local_11.Count = _local_3.readInt();
                    _local_11.Place = _local_3.readInt();
                    _local_11.TemplateID = _local_3.readInt();
                    _local_11.AttackCompose = _local_3.readInt();
                    _local_11.DefendCompose = _local_3.readInt();
                    _local_11.AgilityCompose = _local_3.readInt();
                    _local_11.LuckCompose = _local_3.readInt();
                    _local_11.StrengthenLevel = _local_3.readInt();
                    _local_11.IsBinds = _local_3.readBoolean();
                    _local_11.IsJudge = _local_3.readBoolean();
                    _local_11.BeginDate = _local_3.readDateString();
                    _local_11.ValidDate = _local_3.readInt();
                    _local_11.Color = _local_3.readUTF();
                    _local_11.Skin = _local_3.readUTF();
                    _local_11.IsUsed = _local_3.readBoolean();
                    ItemManager.fill(_local_11);
                    _local_11.Hole1 = _local_3.readInt();
                    _local_11.Hole2 = _local_3.readInt();
                    _local_11.Hole3 = _local_3.readInt();
                    _local_11.Hole4 = _local_3.readInt();
                    _local_11.Hole5 = _local_3.readInt();
                    _local_11.Hole6 = _local_3.readInt();
                    _local_11.Pic = _local_3.readUTF();
                    _local_11.RefineryLevel = _local_3.readInt();
                    _local_11.DiscolorValidDate = _local_3.readDateString();
                    _local_11.Hole5Level = _local_3.readByte();
                    _local_11.Hole5Exp = _local_3.readInt();
                    _local_11.Hole6Level = _local_3.readByte();
                    _local_11.Hole6Exp = _local_3.readInt();
                    _local_11.isGold = _local_3.readBoolean();
                    if (_local_11.isGold)
                    {
                        _local_11.goldValidDate = _local_3.readInt();
                        _local_11.goldBeginTime = _local_3.readDateString();
                    };
                    _local_7.Bag.addItem(_local_11);
                    _local_2++;
                };
                _local_7.Bag.commiteChanges();
                _local_9 = _local_3.readInt();
                if (_local_9 != 0)
                {
                    _local_7.BeadBag.beginChanges();
                    _local_7.BeadBag.clearnAll();
                    _local_12 = 0;
                    while (_local_12 < _local_9)
                    {
                        _local_13 = new InventoryItemInfo();
                        _local_13.BagType = _local_3.readByte();
                        _local_13.UserID = _local_3.readLong();
                        _local_13.ItemID = _local_3.readLong();
                        _local_13.Count = _local_3.readInt();
                        _local_13.Place = _local_3.readInt();
                        _local_13.TemplateID = _local_3.readInt();
                        _local_13.AttackCompose = _local_3.readInt();
                        _local_13.DefendCompose = _local_3.readInt();
                        _local_13.AgilityCompose = _local_3.readInt();
                        _local_13.LuckCompose = _local_3.readInt();
                        _local_13.StrengthenExp = _local_3.readInt();
                        _local_13.IsBinds = _local_3.readBoolean();
                        _local_13.IsJudge = _local_3.readBoolean();
                        _local_13.BeginDate = _local_3.readDateString();
                        _local_13.ValidDate = _local_3.readInt();
                        _local_13.Color = _local_3.readUTF();
                        _local_13.Skin = _local_3.readUTF();
                        _local_13.IsUsed = _local_3.readBoolean();
                        ItemManager.fill(_local_13);
                        _local_13.Pic = _local_3.readUTF();
                        _local_13.RefineryLevel = _local_3.readInt();
                        _local_3.readDateString();
                        _local_13.beadIsLock = _local_3.readByte();
                        _local_13.beadLevel = _local_3.readInt();
                        _local_13.Hole6Level = _local_3.readByte();
                        _local_13.beadExp = _local_3.readInt();
                        _local_7.BeadBag.addItem(_local_13);
                        _local_12++;
                    };
                    _local_7.BeadBag.commiteChanges();
                };
                _local_7.pets.clear();
                _local_10 = _local_3.readInt();
                _local_2 = 0;
                while (_local_2 < _local_10)
                {
                    _local_14 = _local_3.readInt();
                    _local_15 = _local_3.readInt();
                    _local_16 = _local_3.readInt();
                    _local_17 = PetInfoManager.instance.getPetInfoByTemplateID(_local_16);
                    _local_17.Place = _local_14;
                    _local_17.ID = _local_15;
                    _local_17.Name = _local_3.readUTF();
                    _local_17.UserID = _local_3.readInt();
                    _local_17.Attack = _local_3.readInt();
                    _local_17.Defence = _local_3.readInt();
                    _local_17.Luck = _local_3.readInt();
                    _local_17.Agility = _local_3.readInt();
                    _local_17.Blood = _local_3.readInt();
                    _local_17.Bless = _local_3.readInt();
                    _local_17.OrderNumber = _local_3.readInt();
                    _local_17.MagicLevel = _local_3.readInt();
                    _local_17.Level = _local_3.readInt();
                    _local_17.GP = _local_3.readInt();
                    _local_17.MaxGP = _local_3.readInt();
                    if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                    {
                        _local_17.clearSkills();
                    };
                    _local_18 = _local_3.readInt();
                    _local_19 = 0;
                    while (_local_19 < _local_18)
                    {
                        _local_20 = _local_3.readInt();
                        _local_21 = _local_3.readInt();
                        _local_17.addSkill(_local_20, _local_21);
                        _local_19++;
                    };
                    if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                    {
                        _local_7.pets.add(_local_17.Place, _local_17);
                    };
                    _local_2++;
                };
                _local_7.MilitaryRankTotalScores = _local_3.readInt();
                _local_7.commitChanges();
            };
        }

        private function __onsItemEquip(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            var _local_5:PlayerInfo = this.findPlayer(_local_3);
            if (_local_5 != null)
            {
                _local_5.beginChanges();
                _local_5.Agility = _local_2.readInt();
                _local_5.Attack = _local_2.readInt();
                _local_5.Crit = _local_2.readInt();
                _local_5.Stormdamage = _local_2.readInt();
                _local_5.Uprisingstrike = _local_2.readInt();
                _local_5.Uprisinginjury = _local_2.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_3))))
                {
                    _local_5.Colors = _local_2.readUTF();
                    _local_5.Skin = _local_2.readUTF();
                }
                else
                {
                    _local_2.readUTF();
                    _local_2.readUTF();
                    _local_5.Colors = this.changedStyle[_local_3]["Colors"];
                    _local_5.Skin = this.changedStyle[_local_3]["Skin"];
                };
                _local_5.Defence = _local_2.readInt();
                _local_5.GP = _local_2.readInt();
                _local_5.Grade = _local_2.readInt();
                _local_5.Luck = _local_2.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_3))))
                {
                    _local_5.Hide = _local_2.readInt();
                }
                else
                {
                    _local_2.readInt();
                    _local_5.Hide = this.changedStyle[_local_3]["Hide"];
                };
                _local_5.Repute = _local_2.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_3))))
                {
                    _local_5.Sex = _local_2.readBoolean();
                    _local_5.Style = _local_2.readUTF();
                }
                else
                {
                    _local_2.readBoolean();
                    _local_2.readUTF();
                    _local_5.Sex = this.changedStyle[_local_3]["Sex"];
                    _local_5.Style = this.changedStyle[_local_3]["Style"];
                };
                _local_5.Offer = _local_2.readInt();
                _local_5.NickName = _local_4;
                _local_5.VIPtype = _local_2.readByte();
                _local_5.VIPLevel = _local_2.readInt();
                _local_5.WinCount = _local_2.readInt();
                _local_5.TotalCount = _local_2.readInt();
                _local_5.EscapeCount = _local_2.readInt();
                _local_5.ConsortiaID = _local_2.readInt();
                _local_5.ConsortiaName = _local_2.readUTF();
                _local_5.RichesOffer = _local_2.readInt();
                _local_5.RichesRob = _local_2.readInt();
                _local_5.IsMarried = _local_2.readBoolean();
                _local_5.SpouseID = _local_2.readInt();
                _local_5.SpouseName = _local_2.readUTF();
                _local_5.DutyName = _local_2.readUTF();
                _local_6 = _local_2.readInt();
                _local_5.FightPower = _local_2.readInt();
                _local_5.apprenticeshipState = _local_2.readInt();
                _local_5.masterID = _local_2.readInt();
                _local_5.setMasterOrApprentices(_local_2.readUTF());
                _local_5.graduatesCount = _local_2.readInt();
                _local_5.honourOfMaster = _local_2.readUTF();
                _local_5.AchievementPoint = _local_2.readInt();
                _local_5.honor = _local_2.readUTF();
                _local_5.LastLoginDate = _local_2.readDate();
                _local_5.commitChanges();
                _local_5.Bag.beginChanges();
                _local_5.Bag.commiteChanges();
                _local_5.commitChanges();
            };
            super.dispatchEvent(new CityWideEvent(CityWideEvent.ONS_PLAYERINFO, _local_5));
        }

        private function __bagLockedHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:Boolean = _arg_1.pkg.readBoolean();
            var _local_5:Boolean = _arg_1.pkg.readBoolean();
            var _local_6:String = _arg_1.pkg.readUTF();
            var _local_7:int = _arg_1.pkg.readInt();
            var _local_8:String = _arg_1.pkg.readUTF();
            var _local_9:String = _arg_1.pkg.readUTF();
            if (_local_4)
            {
                switch (_local_3)
                {
                    case 1:
                        this._self.bagPwdState = true;
                        this._self.bagLocked = true;
                        this._self.onReceiveTypes(BagEvent.CHANGEPSW);
                        BagLockedController.PWD = BagLockedController.TEMP_PWD;
                        MessageTipManager.getInstance().show(_local_6);
                        break;
                    case 2:
                        this._self.bagPwdState = true;
                        this._self.bagLocked = false;
                        if ((!(ServerManager.AUTO_UNLOCK)))
                        {
                            if (_local_6 != "")
                            {
                                MessageTipManager.getInstance().show(_local_6);
                            };
                            ServerManager.AUTO_UNLOCK = false;
                        };
                        BagLockedController.PWD = BagLockedController.TEMP_PWD;
                        this._self.onReceiveTypes(BagEvent.CLEAR);
                        break;
                    case 3:
                        this._self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
                        BagLockedController.PWD = BagLockedController.TEMP_PWD;
                        MessageTipManager.getInstance().show(_local_6);
                        break;
                    case 4:
                        this._self.bagPwdState = false;
                        this._self.bagLocked = false;
                        this._self.onReceiveTypes(BagEvent.AFTERDEL);
                        MessageTipManager.getInstance().show(_local_6);
                        break;
                    case 5:
                        this._self.bagPwdState = true;
                        this._self.bagLocked = true;
                        MessageTipManager.getInstance().show(_local_6);
                        break;
                    case 6:
                        break;
                };
            }
            else
            {
                MessageTipManager.getInstance().show(_local_6);
            };
        }

        private function __friendAdd(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:FriendListPlayer;
            var _local_5:PlayerInfo;
            var _local_6:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                _local_4 = new FriendListPlayer();
                _local_4.beginChanges();
                _local_4.ID = _local_2.readInt();
                _local_4.NickName = _local_2.readUTF();
                _local_4.VIPtype = _local_2.readByte();
                _local_4.VIPLevel = _local_2.readInt();
                _local_4.Sex = _local_2.readBoolean();
                _local_5 = this.findPlayer(_local_4.ID);
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_4.ID))))
                {
                    _local_4.Style = _local_2.readUTF();
                    _local_4.Colors = _local_2.readUTF();
                    _local_4.Skin = _local_2.readUTF();
                }
                else
                {
                    _local_2.readUTF();
                    _local_2.readUTF();
                    _local_2.readUTF();
                    _local_4.Style = _local_5.Style;
                    _local_4.Colors = _local_5.Colors;
                    _local_4.Skin = _local_5.Skin;
                };
                _local_4.playerState = new PlayerState(_local_2.readInt());
                _local_4.Grade = _local_2.readInt();
                if ((!(PlayerManager.Instance.isChangeStyleTemp(_local_4.ID))))
                {
                    _local_4.Hide = _local_2.readInt();
                }
                else
                {
                    _local_2.readInt();
                    _local_4.Hide = _local_5.Hide;
                };
                _local_4.ConsortiaName = _local_2.readUTF();
                _local_4.TotalCount = _local_2.readInt();
                _local_4.EscapeCount = _local_2.readInt();
                _local_4.WinCount = _local_2.readInt();
                _local_4.Offer = _local_2.readInt();
                _local_4.Repute = _local_2.readInt();
                _local_4.Relation = _local_2.readInt();
                _local_4.LoginName = _local_2.readUTF();
                _local_6 = _local_2.readInt();
                _local_4.FightPower = _local_2.readInt();
                _local_4.apprenticeshipState = _local_2.readInt();
                _local_4.masterID = _local_2.readInt();
                _local_4.setMasterOrApprentices(_local_2.readUTF());
                _local_4.graduatesCount = _local_2.readInt();
                _local_4.honourOfMaster = _local_2.readUTF();
                _local_4.AchievementPoint = _local_2.readInt();
                _local_4.honor = _local_2.readUTF();
                _local_4.IsMarried = _local_2.readBoolean();
                _local_4.isOld = _local_2.readBoolean();
                _local_4.commitChanges();
                if (_local_4.Relation != 1)
                {
                    this.addFriend(_local_4);
                    if (PathInfo.isUserAddFriend)
                    {
                        new AddCommunityFriend(_local_4.LoginName, _local_4.NickName);
                    };
                }
                else
                {
                    this.addBlackList(_local_4);
                };
                dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND, _local_4));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.playerManager.addFriend.isRefused"));
            };
        }

        public function addFriend(_arg_1:PlayerInfo):void
        {
            if (((!(this.blackList)) && (!(this.friendList))))
            {
                return;
            };
            this.blackList.remove(_arg_1.ID);
            this.friendList.add(_arg_1.ID, _arg_1);
        }

        public function addBlackList(_arg_1:FriendListPlayer):void
        {
            if (((!(this.blackList)) && (!(this.friendList))))
            {
                return;
            };
            this.friendList.remove(_arg_1.ID);
            this.blackList.add(_arg_1.ID, _arg_1);
        }

        public function removeFriend(_arg_1:int):void
        {
            if (((!(this.blackList)) && (!(this.friendList))))
            {
                return;
            };
            this.friendList.remove(_arg_1);
            this.blackList.remove(_arg_1);
        }

        private function __friendRemove(_arg_1:CrazyTankSocketEvent):void
        {
            this.removeFriend(_arg_1.pkg.clientId);
        }

        private function __playerState(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:int;
            var _local_10:int;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId != this._self.ID)
            {
                _local_3 = _local_2.clientId;
                _local_4 = _local_2.readInt();
                _local_5 = _local_2.readByte();
                _local_6 = _local_2.readInt();
                _local_7 = _local_2.readBoolean();
                _local_8 = false;
                _local_9 = 0;
                _local_10 = 0;
                if (DiamondManager.instance.isInTencent)
                {
                    _local_8 = _local_2.readBoolean();
                    _local_9 = _local_2.readByte();
                    _local_10 = _local_2.readByte();
                };
                this.playerStateChange(_local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
                if (_local_3 == this.Self.SpouseID)
                {
                    this.spouseStateChange(_local_4);
                };
                ConsortionModelControl.Instance.model.consortiaPlayerStateChange(_local_3, _local_4);
            };
        }

        private function spouseStateChange(_arg_1:int):void
        {
            var _local_2:String;
            if (_arg_1 == PlayerState.ONLINE)
            {
                _local_2 = ((this.Self.Sex) ? LanguageMgr.GetTranslation("ddt.manager.playerManager.wifeOnline", this.Self.SpouseName) : LanguageMgr.GetTranslation("ddt.manager.playerManager.hushandOnline", this.Self.SpouseName));
                ChatManager.Instance.sysChatYellow(_local_2);
            };
        }

        private function masterStateChange(_arg_1:int, _arg_2:int):void
        {
            var _local_3:String;
            if (((_arg_1 == PlayerState.ONLINE) && (!(_arg_2 == this.Self.SpouseID))))
            {
                if (_arg_2 == this.Self.masterID)
                {
                    _local_3 = LanguageMgr.GetTranslation("ddt.manager.playerManager.masterState", this.Self.getMasterOrApprentices()[_arg_2]);
                }
                else
                {
                    if (this.Self.getMasterOrApprentices()[_arg_2])
                    {
                        _local_3 = LanguageMgr.GetTranslation("ddt.manager.playerManager.ApprenticeState", this.Self.getMasterOrApprentices()[_arg_2]);
                    }
                    else
                    {
                        return;
                    };
                };
                ChatManager.Instance.sysChatYellow(_local_3);
            };
        }

        public function playerStateChange(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean, _arg_7:int, _arg_8:int):void
        {
            var _local_10:String;
            var _local_11:PlayerInfo;
            var _local_9:PlayerInfo = this.friendList[_arg_1];
            if (_local_9)
            {
                if ((((!(_local_9.playerState.StateID == _arg_2)) || (!(_local_9.VIPtype == _arg_3))) || (!(_local_9.isSameCity == _arg_5))))
                {
                    _local_9.VIPtype = _arg_3;
                    _local_9.VIPLevel = _arg_4;
                    _local_9.isSameCity = _arg_5;
                    _local_9.isYellowVip = _arg_6;
                    _local_9.MemberDiamondLevel = _arg_7;
                    _local_9.Level3366 = _arg_8;
                    _local_10 = "";
                    if (_local_9.playerState.StateID != _arg_2)
                    {
                        _local_9.playerState = new PlayerState(_arg_2);
                        this.friendList.add(_arg_1, _local_9);
                        if (_arg_1 == this.Self.SpouseID)
                        {
                            return;
                        };
                        if (((_arg_1 == this.Self.masterID) || (this.Self.getMasterOrApprentices()[_arg_1])))
                        {
                            this.masterStateChange(_arg_2, _arg_1);
                            return;
                        };
                        if (((_arg_2 == PlayerState.ONLINE) && (SharedManager.Instance.showOL)))
                        {
                            _local_10 = ((((LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend") + "[") + _local_9.NickName) + "]") + LanguageMgr.GetTranslation("tank.manager.PlayerManger.friendOnline"));
                            ChatManager.Instance.sysChatYellow(_local_10);
                            return;
                        };
                        return;
                    };
                };
                this.friendList.add(_arg_1, _local_9);
            }
            else
            {
                if (this.myAcademyPlayers)
                {
                    _local_11 = this.myAcademyPlayers[_arg_1];
                    if (_local_11)
                    {
                        if (((!(_local_11.playerState.StateID == _arg_2)) || (!(_local_11.IsVIP == _arg_3))))
                        {
                            _local_11.VIPtype = _arg_3;
                            _local_11.VIPLevel = _arg_4;
                            _local_11.playerState = new PlayerState(_arg_2);
                            this.myAcademyPlayers.add(_arg_1, _local_11);
                        };
                    };
                };
            };
        }

        private function initEvents():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS, this.__updateInventorySlot);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP, this.__itemEquip);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONS_EQUIP, this.__onsItemEquip);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED, this.__bagLockedHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO, this.__updatePrivateInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO, this.__updatePlayerInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TEMP_STYLE, this.__readTempStyle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE, this.__checkCodePopup);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN, this.__buffObtain);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE, this.__buffUpdate);
            this.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfPopChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD, this.__friendAdd);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE, this.__friendRemove);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE, this.__playerState);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_IS_OPENED, this.__upVipInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER, this.__updateUerGuild);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE, this.__chatFilteringFriendsShare);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAME_CITY_FRIEND, this.__sameCity);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS, this.__roomListPass);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PET, this.__updatePet);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_ONEKEYFINISH, this.__updateOneKeyFinish);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY, this.__updatePlayerProperty);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPEN_BAG_CELL, this.__onOpenBagCell);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_TOOL_BOX, this.__updateFightVip);
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__updateDataByMin);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FATIGUE, this.__updateFatigue);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_ENERGY, this.__updateMission);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_FATIGUE, this.__buyFatigueHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_STATUS, this.__updateConsotionStatus);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_EXPERIENCE, this.__updateExperience);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_REWARD, this.__closeFriendReward);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_CHANGE, this.__closeFriendChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_ADD, this.__invitedFriendAdd);
            addEventListener(BagEvent.UPDATE_BAG_CELL, this.__updateBagCell);
        }

        private function __updateDataByMin(_arg_1:TimeEvents):void
        {
            var _local_2:Date = TimeManager.Instance.Now();
            if (((this._self.IsVIP) && (_local_2.getTime() > (this._self.VIPExpireDay.getTime() + 60000))))
            {
                SocketManager.Instance.out.sendVipOverdue(this._self.ID);
            };
            if (((this._self.isFightVip) && (_local_2.getTime() > (this._self.fightVipStartTime.getTime() + ((this._self.fightVipValidDate * 60) * 1000)))))
            {
                SocketManager.Instance.out.sendfightVip(2);
            };
        }

        private function __updateFightVip(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._self.beginChanges();
            this._self.isFightVip = _local_2.readBoolean();
            this._self.fightToolBoxSkillNum = _local_2.readInt();
            this._self.fightVipStartTime = _local_2.readDate();
            this._self.fightVipValidDate = _local_2.readInt();
            this._self.commitChanges();
            dispatchEvent(new Event(UPDATE_FIGHT_VIP));
        }

        private function __onOpenBagCell(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Dictionary = new Dictionary();
            var _local_3:PackageIn = _arg_1.pkg;
            var _local_4:int = _local_3.readInt();
            var _local_5:Date = _local_3.readDate();
            _local_2["bagIndex"] = _local_4;
            _local_2["lastTime"] = _local_5;
            dispatchEvent(new BagEvent(BagEvent.UPDATE_BAG_CELL, _local_2));
        }

        public function get First():Boolean
        {
            return (this._first);
        }

        public function set First(_arg_1:Boolean):void
        {
            this._first = _arg_1;
        }

        private function __updateBagCell(_arg_1:BagEvent):void
        {
            var _local_2:Dictionary;
            var _local_3:BagCellInfo;
            if ((!(this.First)))
            {
                _local_2 = _arg_1.changedSlots;
                PlayerManager.Instance.Self.bagCellUpdateIndex = _local_2.bagIndex;
                PlayerManager.Instance.Self.bagCellUpdateTime = _local_2.lastTime;
                _local_3 = ItemManager.Instance.getBagCellByPlace((PlayerManager.Instance.Self.bagCellUpdateIndex - 30));
                PlayerManager.Instance.Self.getStratTime((_local_3.NeedTime * 60));
                this.First = true;
            };
        }

        protected function __updatePlayerProperty(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:String;
            var _local_8:PlayerInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Array = ["Attack", "Defence", "Agility", "Luck", "HP"];
            var _local_4:DictionaryData = new DictionaryData();
            var _local_5:DictionaryData;
            var _local_6:int = -1;
            _local_6 = _local_2.readInt();
            for each (_local_7 in _local_3)
            {
                _local_5 = (_local_4[_local_7] = new DictionaryData());
                _local_2.readInt();
                if (_local_7 != "HP")
                {
                    _local_5["fashion"] = _local_2.readInt();
                };
                _local_5["Equip"] = _local_2.readInt();
                _local_5["Embed"] = _local_2.readInt();
                _local_5["Bead"] = _local_2.readInt();
                _local_5["Pet"] = _local_2.readInt();
            };
            _local_4["Damage"] = new DictionaryData();
            _local_2.readInt();
            _local_4["Damage"]["Equip"] = _local_2.readInt();
            _local_4["Damage"]["Embed"] = _local_2.readInt();
            _local_4["Damage"]["Bead"] = _local_2.readInt();
            _local_4["Damage"]["attack"] = _local_2.readInt();
            _local_4["Armor"] = new DictionaryData();
            _local_2.readInt();
            _local_4["Armor"]["Equip"] = _local_2.readInt();
            _local_4["Armor"]["Embed"] = _local_2.readInt();
            _local_4["Armor"]["Bead"] = _local_2.readInt();
            _local_4["Armor"]["defence"] = _local_2.readInt();
            _local_4["Energy"] = new DictionaryData();
            _local_2.readInt();
            _local_4["Energy"]["Equip"] = _local_2.readInt();
            _local_4["Energy"]["Embed"] = _local_2.readInt();
            _local_8 = this.findPlayer(_local_6);
            _local_8.runeLevel = _local_2.readInt();
            TotemManager.instance.updatePropertyAddtion(_local_8.totemId, _local_4);
            _local_8.propertyAddition = _local_4;
            dispatchEvent(new Event(UPDATE_PLAYER_PROPERTY));
        }

        public function get propertyAdditions():DictionaryData
        {
            return (this._propertyAdditions);
        }

        private function __roomListPass(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:PassInputFrame = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.passInputFrame");
            LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            _local_3.ID = _local_2;
        }

        private function __sameCity(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:int = _arg_1.pkg.readInt();
            while (_local_3 < _local_2)
            {
                _local_4 = _arg_1.pkg.readInt();
                this.findPlayer(_local_4, this.Self.ZoneID).isSameCity = true;
                if ((!(this._sameCityList)))
                {
                    this._sameCityList = new Array();
                };
                this._sameCityList.push(_local_4);
                _local_3++;
            };
            this.initSameCity();
        }

        private function initSameCity():void
        {
            if ((!(this._sameCityList)))
            {
                this._sameCityList = new Array();
            };
            var _local_1:int;
            while (_local_1 < this._sameCityList.length)
            {
                this.findPlayer(this._sameCityList[_local_1]).isSameCity = true;
                _local_1++;
            };
            this._friendList[this._self.ZoneID].dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE));
        }

        private function __chatFilteringFriendsShare(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:CMFriendInfo;
            if ((!(this._cmFriendList)))
            {
                return;
            };
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            var _local_5:Boolean;
            for each (_local_6 in this._cmFriendList)
            {
                if (_local_6.UserId == _local_3)
                {
                    _local_5 = true;
                };
            };
            if (_local_5)
            {
                ChatManager.Instance.sysChatYellow(_local_4);
            };
        }

        private function __updateUerGuild(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_2:ByteArray = new ByteArray();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _arg_1.pkg.readByte();
                _local_2.writeByte(_local_5);
                _local_4++;
            };
            this._self.weaklessGuildProgress = _local_2;
        }

        private function __sysNotice(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            var _local_5:int = _local_2.readByte();
            var _local_6:int = _local_2.readInt();
            var _local_7:int = _local_2.readInt();
            var _local_8:int = _local_2.readInt();
            var _local_9:String = _local_2.readUTF();
            var _local_10:ChatData = new ChatData();
            _local_10.type = 1;
            _local_10.msg = _local_4;
            _local_10.channel = _local_3;
        }

        private function __upVipInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._self.beginChanges();
            this._self.VIPtype = _local_2.readByte();
            this._self.VIPLevel = _local_2.readInt();
            this._self.VIPExp = _local_2.readInt();
            this._self.VIPExpireDay = _local_2.readDate();
            this._self.LastDate = _local_2.readDate();
            this._self.VIPNextLevelDaysNeeded = _local_2.readInt();
            this._self.openVipType = _local_2.readBoolean();
            this._self.commitChanges();
            dispatchEvent(new Event(VIP_STATE_CHANGE));
        }

        public function setupFriendList(_arg_1:FriendListAnalyzer):void
        {
            this.customList = _arg_1.customList;
            this.friendList = _arg_1.friendlist;
            this.blackList = _arg_1.blackList;
            this.initSameCity();
        }

        public function checkHasGroupName(_arg_1:String):Boolean
        {
            var _local_2:int;
            while (_local_2 < this.customList.length)
            {
                if (this.customList[_local_2].Name == _arg_1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addFirend.repet"), 0, true);
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        private function romoveAcademyPlayers():void
        {
            var _local_1:FriendListPlayer;
            for each (_local_1 in this._myAcademyPlayers)
            {
                this.friendList.remove(_local_1.ID);
            };
        }

        public function setupRecentContacts(_arg_1:RecentContactsAnalyze):void
        {
            this.recentContacts = _arg_1.recentContacts;
        }

        public function set friendList(_arg_1:DictionaryData):void
        {
            this._friendList[this._self.ZoneID] = _arg_1;
            IMController.Instance.isLoadComplete = true;
            dispatchEvent(new Event(FRIENDLIST_COMPLETE));
        }

        public function get friendList():DictionaryData
        {
            if (this._friendList[this._self.ZoneID] == null)
            {
                this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
            };
            return (this._friendList[this._self.ZoneID]);
        }

        public function getFriendForCustom(_arg_1:int):DictionaryData
        {
            var _local_3:FriendListPlayer;
            var _local_2:DictionaryData = new DictionaryData();
            if (this._friendList[this._self.ZoneID] == null)
            {
                this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
            };
            for each (_local_3 in this._friendList[this._self.ZoneID])
            {
                if (_local_3.Relation == _arg_1)
                {
                    _local_2.add(_local_3.ID, _local_3);
                };
            };
            return (_local_2);
        }

        public function deleteCustomGroup(_arg_1:int):void
        {
            var _local_2:FriendListPlayer;
            for each (_local_2 in this._friendList[this._self.ZoneID])
            {
                if (_local_2.Relation == _arg_1)
                {
                    _local_2.Relation = 0;
                };
            };
        }

        public function get myAcademyPlayers():DictionaryData
        {
            return (this._myAcademyPlayers);
        }

        public function get recentContacts():DictionaryData
        {
            if ((!(this._recentContacts)))
            {
                this._recentContacts = new DictionaryData();
            };
            return (this._recentContacts);
        }

        public function set recentContacts(_arg_1:DictionaryData):void
        {
            this._recentContacts = _arg_1;
            dispatchEvent(new Event(RECENT_CONTAST_COMPLETE));
        }

        public function get onlineRecentContactList():Array
        {
            var _local_2:FriendListPlayer;
            var _local_1:Array = [];
            for each (_local_2 in this.recentContacts)
            {
                if (((!(_local_2.playerState.StateID == PlayerState.OFFLINE)) || ((this.findPlayer(_local_2.ID)) && (!(this.findPlayer(_local_2.ID).playerState.StateID == PlayerState.OFFLINE)))))
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function get offlineRecentContactList():Array
        {
            var _local_2:FriendListPlayer;
            var _local_1:Array = [];
            for each (_local_2 in this.recentContacts)
            {
                if (_local_2.playerState.StateID == PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function getByNameFriend(_arg_1:String):FriendListPlayer
        {
            var _local_2:FriendListPlayer;
            for each (_local_2 in this.recentContacts)
            {
                if (_local_2.NickName == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function deleteRecentContact(_arg_1:int):void
        {
            this.recentContacts.remove(_arg_1);
        }

        public function get onlineFriendList():Array
        {
            var _local_2:FriendListPlayer;
            var _local_1:Array = [];
            for each (_local_2 in this.friendList)
            {
                if (_local_2.playerState.StateID != PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function getOnlineFriendForCustom(_arg_1:int):Array
        {
            var _local_3:FriendListPlayer;
            var _local_2:Array = [];
            for each (_local_3 in this.friendList)
            {
                if (((!(_local_3.playerState.StateID == PlayerState.OFFLINE)) && (_local_3.Relation == _arg_1)))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function get offlineFriendList():Array
        {
            var _local_2:FriendListPlayer;
            var _local_1:Array = [];
            for each (_local_2 in this.friendList)
            {
                if (_local_2.playerState.StateID == PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function getOfflineFriendForCustom(_arg_1:int):Array
        {
            var _local_3:FriendListPlayer;
            var _local_2:Array = [];
            for each (_local_3 in this.friendList)
            {
                if (((_local_3.playerState.StateID == PlayerState.OFFLINE) && (_local_3.Relation == _arg_1)))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function get onlineMyAcademyPlayers():Array
        {
            var _local_2:PlayerInfo;
            var _local_1:Array = [];
            for each (_local_2 in this._myAcademyPlayers)
            {
                if (_local_2.playerState.StateID != PlayerState.OFFLINE)
                {
                    _local_1.push((_local_2 as FriendListPlayer));
                };
            };
            return (_local_1);
        }

        public function get offlineMyAcademyPlayers():Array
        {
            var _local_2:PlayerInfo;
            var _local_1:Array = [];
            for each (_local_2 in this._myAcademyPlayers)
            {
                if (_local_2.playerState.StateID == PlayerState.OFFLINE)
                {
                    _local_1.push((_local_2 as FriendListPlayer));
                };
            };
            return (_local_1);
        }

        public function set blackList(_arg_1:DictionaryData):void
        {
            this._blackList[this._self.ZoneID] = _arg_1;
        }

        public function get blackList():DictionaryData
        {
            if (this._blackList[this._self.ZoneID] == null)
            {
                this._blackList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
            };
            return (this._blackList[this._self.ZoneID]);
        }

        public function get CMFriendList():DictionaryData
        {
            return (this._cmFriendList);
        }

        public function set CMFriendList(_arg_1:DictionaryData):void
        {
            this._cmFriendList = _arg_1;
        }

        public function get PlayCMFriendList():Array
        {
            if (this._cmFriendList)
            {
                return (this._cmFriendList.filter("IsExist", true));
            };
            return ([]);
        }

        public function get UnPlayCMFriendList():Array
        {
            if (this._cmFriendList)
            {
                return (this._cmFriendList.filter("IsExist", false));
            };
            return ([]);
        }

        private function __updatePrivateInfo(_arg_1:CrazyTankSocketEvent):void
        {
            this._self.beginChanges();
            this._self.Money = _arg_1.pkg.readInt();
            this._self.DDTMoney = _arg_1.pkg.readInt();
            this._self.Gold = _arg_1.pkg.readInt();
            this._self.totemScores = _arg_1.pkg.readInt();
            this._self.beadScore = _arg_1.pkg.readInt();
            this._self.damageScores = _arg_1.pkg.readInt();
            this._self.armyExploit = _arg_1.pkg.readInt();
            this._self.matchMedal = _arg_1.pkg.readInt();
            this._self.MilitaryRankTotalScores = _arg_1.pkg.readInt();
            this._self.fatigueCount = _arg_1.pkg.readByte();
            this._self.commitChanges();
        }

        public function get hasTempStyle():Boolean
        {
            return (this.tempStyle.length > 0);
        }

        public function isChangeStyleTemp(_arg_1:int):Boolean
        {
            return ((this.changedStyle.hasOwnProperty(_arg_1)) && (!(this.changedStyle[_arg_1] == null)));
        }

        public function setStyleTemply(_arg_1:Object):void
        {
            var _local_2:PlayerInfo = this.findPlayer(_arg_1.ID);
            if (_local_2)
            {
                this.storeTempStyle(_local_2);
                _local_2.beginChanges();
                _local_2.Sex = _arg_1.Sex;
                _local_2.Hide = _arg_1.Hide;
                _local_2.Style = _arg_1.Style;
                _local_2.Colors = _arg_1.Colors;
                _local_2.Skin = _arg_1.Skin;
                _local_2.commitChanges();
            };
        }

        private function storeTempStyle(_arg_1:PlayerInfo):void
        {
            var _local_2:Object = new Object();
            _local_2.Style = _arg_1.getPrivateStyle();
            _local_2.Hide = _arg_1.Hide;
            _local_2.Sex = _arg_1.Sex;
            _local_2.Skin = _arg_1.Skin;
            _local_2.Colors = _arg_1.Colors;
            _local_2.ID = _arg_1.ID;
            this.tempStyle.push(_local_2);
        }

        public function readAllTempStyleEvent():void
        {
            var _local_2:PlayerInfo;
            var _local_1:int;
            while (_local_1 < this.tempStyle.length)
            {
                _local_2 = this.findPlayer(this.tempStyle[_local_1].ID);
                if (_local_2)
                {
                    _local_2.beginChanges();
                    _local_2.Sex = this.tempStyle[_local_1].Sex;
                    _local_2.Hide = this.tempStyle[_local_1].Hide;
                    _local_2.Style = this.tempStyle[_local_1].Style;
                    _local_2.Colors = this.tempStyle[_local_1].Colors;
                    _local_2.Skin = this.tempStyle[_local_1].Skin;
                    _local_2.commitChanges();
                };
                _local_1++;
            };
            this.tempStyle = [];
            this.changedStyle.clear();
        }

        private function __readTempStyle(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:Object;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = new Object();
                _local_5.Style = _local_2.readUTF();
                _local_5.Hide = _local_2.readInt();
                _local_5.Sex = _local_2.readBoolean();
                _local_5.Skin = _local_2.readUTF();
                _local_5.Colors = _local_2.readUTF();
                _local_5.ID = _local_2.readInt();
                this.setStyleTemply(_local_5);
                this.changedStyle.add(_local_5.ID, _local_5);
                _local_4++;
            };
        }

        private function __updatePlayerInfo(evt:CrazyTankSocketEvent):void
        {
            var pkg:PackageIn;
            var style:String;
            var arm:String;
            var offHand:String;
            var hasPet:Boolean;
            var place:int;
            var ID:int;
            var templateID:int;
            var p:PetInfo;
            var skillCount:int;
            var k:int;
            var skillPlace:int;
            var skillid:int;
            if (PlayerManager.Instance.Self.isBeadUpdate)
            {
                return;
            };
            var info:PlayerInfo = this.findPlayer(evt.pkg.clientId);
            if (info)
            {
                info.beginChanges();
                try
                {
                    pkg = evt.pkg;
                    info.GP = pkg.readInt();
                    info.magicSoul = pkg.readInt();
                    info.Offer = pkg.readInt();
                    info.RichesOffer = pkg.readInt();
                    info.RichesRob = pkg.readInt();
                    info.WinCount = pkg.readInt();
                    info.TotalCount = pkg.readInt();
                    info.EscapeCount = pkg.readInt();
                    info.Attack = pkg.readInt();
                    info.Defence = pkg.readInt();
                    info.Agility = pkg.readInt();
                    info.Luck = pkg.readInt();
                    info.Damage = pkg.readInt();
                    info.Guard = pkg.readInt();
                    info.hp = pkg.readInt();
                    info.Energy = pkg.readInt();
                    if ((!(this.isChangeStyleTemp(info.ID))))
                    {
                        info.Hide = pkg.readInt();
                    }
                    else
                    {
                        pkg.readInt();
                    };
                    style = pkg.readUTF();
                    if (style == "")
                    {
                        style = info.Style;
                    };
                    if ((!(this.isChangeStyleTemp(info.ID))))
                    {
                        info.Style = style;
                    };
                    arm = style.split(",")[6].split("|")[0];
                    offHand = style.split(",")[10].split("|")[0];
                    if (((arm == "-1") || (arm == "0")))
                    {
                        info.WeaponID = -1;
                    }
                    else
                    {
                        info.WeaponID = int(arm);
                    };
                    if ((!(this.isChangeStyleTemp(info.ID))))
                    {
                        info.Colors = pkg.readUTF();
                        info.Skin = pkg.readUTF();
                    }
                    else
                    {
                        pkg.readUTF();
                        pkg.readUTF();
                    };
                    info.IsShowConsortia = pkg.readBoolean();
                    info.ConsortiaID = pkg.readInt();
                    info.ConsortiaName = pkg.readUTF();
                    info.PvePermission = pkg.readUTF();
                    info.fightLibMission = pkg.readUTF();
                    info.FightPower = pkg.readInt();
                    info.apprenticeshipState = pkg.readInt();
                    info.masterID = pkg.readInt();
                    info.setMasterOrApprentices(pkg.readUTF());
                    info.graduatesCount = pkg.readInt();
                    info.honourOfMaster = pkg.readUTF();
                    info.AchievementPoint = pkg.readInt();
                    info.honor = pkg.readUTF();
                    info.shopFinallyGottenTime = pkg.readDate();
                    info.UseOffer = pkg.readInt();
                    info.beforeOffer = pkg.readInt();
                    info.matchInfo.dailyScore = pkg.readInt();
                    info.matchInfo.dailyWinCount = pkg.readInt();
                    info.matchInfo.dailyGameCount = pkg.readInt();
                    info.matchInfo.weeklyScore = pkg.readInt();
                    info.matchInfo.weeklyGameCount = pkg.readInt();
                    info.MilitaryRankScores = pkg.readInt();
                    info.MilitaryRankTotalScores = pkg.readInt();
                    info.FightCount = pkg.readInt();
                    hasPet = pkg.readBoolean();
                    if ((!(info.isSelf)))
                    {
                        if (hasPet)
                        {
                            place = pkg.readInt();
                            ID = pkg.readInt();
                            templateID = pkg.readInt();
                            p = PetInfoManager.instance.getPetInfoByTemplateID(templateID);
                            p.Place = place;
                            p.ID = ID;
                            p.Name = pkg.readUTF();
                            p.UserID = pkg.readInt();
                            p.Attack = pkg.readInt();
                            p.Defence = pkg.readInt();
                            p.Luck = pkg.readInt();
                            p.Agility = pkg.readInt();
                            p.Blood = pkg.readInt();
                            p.Bless = pkg.readInt();
                            p.OrderNumber = pkg.readInt();
                            p.MagicLevel = pkg.readInt();
                            p.Level = pkg.readInt();
                            p.GP = pkg.readInt();
                            p.MaxGP = pkg.readInt();
                            if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                            {
                                p.clearSkills();
                            };
                            skillCount = pkg.readInt();
                            k = 0;
                            while (k < skillCount)
                            {
                                skillPlace = pkg.readInt();
                                skillid = pkg.readInt();
                                p.addSkill(skillPlace, skillid);
                                k = (k + 1);
                            };
                            if (((!(RoomManager.Instance.current)) || (!(RoomManager.Instance.current.type == RoomInfo.CHANGE_DUNGEON))))
                            {
                                info.addPets(p);
                            };
                        }
                        else
                        {
                            info.pets.remove(0);
                        };
                    };
                }
                finally
                {
                    info.commitChanges();
                };
            };
            if ((((StateManager.currentStateType == StateType.MATCH_ROOM) || (StateManager.currentStateType == StateType.DUNGEON_ROOM)) || (StateManager.currentStateType == StateType.CHALLENGE_ROOM)))
            {
                dispatchEvent(new Event(UPDATE_ROOMPLAYER));
            };
        }

        public function set gamePetInfo(_arg_1:PetInfo):void
        {
            this._gamepetInfo = _arg_1;
        }

        public function get gamePetInfo():PetInfo
        {
            return (this._gamepetInfo);
        }

        public function getDeputyWeaponIcon(_arg_1:ItemTemplateInfo, _arg_2:int=0):DisplayObject
        {
            var _local_3:BagCell;
            if (_arg_1)
            {
                _local_3 = new BagCell(0, _arg_1);
                if (_arg_2 == 0)
                {
                    return (_local_3.getContent());
                };
                if (_arg_2 == 1)
                {
                    return (_local_3.getSmallContent());
                };
            };
            return (null);
        }

        public function __checkCodePopup(e:CrazyTankSocketEvent):void
        {
            var readComplete:Function;
            var msg:String;
            var checkCodeData:CheckCodeData;
            var ba:ByteArray;
            var bitmapReader:BitmapReader;
            readComplete = function (_arg_1:Event):void
            {
                checkCodeData.pic = bitmapReader.bitmap;
                CheckCodeFrame.Instance.data = checkCodeData;
            };
            var checkCodeState:int = e.pkg.readByte();
            var backType:Boolean = e.pkg.readBoolean();
            if (checkCodeState == 1)
            {
                SoundManager.instance.play("058");
            }
            else
            {
                if (checkCodeState == 2)
                {
                    SoundManager.instance.play("057");
                };
            };
            if (backType)
            {
                CheckCodeFrame.Instance.time = 20;
                msg = e.pkg.readUTF();
                CheckCodeFrame.Instance.tip = msg;
                checkCodeData = new CheckCodeData();
                ba = new ByteArray();
                e.pkg.readBytes(ba, 0, e.pkg.bytesAvailable);
                bitmapReader = new BitmapReader();
                bitmapReader.addEventListener(Event.COMPLETE, readComplete);
                bitmapReader.readByteArray(ba);
                CheckCodeFrame.Instance.isShowed = false;
            }
            else
            {
                CheckCodeFrame.Instance.close();
                return;
            };
            CheckCodeFrame.Instance.show();
        }

        private function __buffObtain(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Date;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:BuffInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId != this._self.ID)
            {
                return;
            };
            this._self.clearBuff();
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.readInt();
                _local_6 = _local_2.readBoolean();
                _local_7 = _local_2.readDate();
                _local_8 = _local_2.readInt();
                _local_9 = _local_2.readInt();
                _local_10 = _local_2.readInt();
                _local_11 = new BuffInfo(_local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
                this._self.addBuff(_local_11);
                _local_4++;
            };
            _arg_1.stopImmediatePropagation();
        }

        private function __buffUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Date;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:BuffInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.clientId != this._self.ID)
            {
                return;
            };
            var _local_3:int = _local_2.readInt();
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.readInt();
                _local_6 = _local_2.readBoolean();
                _local_7 = _local_2.readDate();
                _local_8 = _local_2.readInt();
                _local_9 = _local_2.readInt();
                _local_10 = _local_2.readInt();
                _local_11 = new BuffInfo(_local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
                if (_local_6)
                {
                    this._self.addBuff(_local_11);
                }
                else
                {
                    this._self.buffInfo.remove(_local_11.Type);
                };
                _local_4++;
            };
            _arg_1.stopImmediatePropagation();
        }

        public function findPlayerByNickName(_arg_1:PlayerInfo, _arg_2:String):PlayerInfo
        {
            var _local_3:PlayerInfo;
            if (_arg_2)
            {
                if (this._tempList[this._self.ZoneID] == null)
                {
                    this._tempList[this._self.ZoneID] = new DictionaryData();
                };
                if (this._tempList[this._self.ZoneID][_arg_2] != null)
                {
                    return (this._tempList[this._self.ZoneID][_arg_2] as PlayerInfo);
                };
                for each (_local_3 in this._tempList[this._self.ZoneID])
                {
                    if (_local_3.NickName == _arg_2)
                    {
                        return (_local_3);
                    };
                };
                _arg_1.NickName = _arg_2;
                this._tempList[this._self.ZoneID][_arg_2] = _arg_1;
                return (_arg_1);
            };
            return (_arg_1);
        }

        public function findPlayer(_arg_1:int, _arg_2:int=-1, _arg_3:String=""):PlayerInfo
        {
            var _local_4:PlayerInfo;
            var _local_5:PlayerInfo;
            var _local_6:PlayerInfo;
            var _local_7:PlayerInfo;
            if (((_arg_2 == -1) || (_arg_2 == this._self.ZoneID)))
            {
                if (this._friendList[this._self.ZoneID] == null)
                {
                    this._friendList[this._self.ZoneID] = new DictionaryData();
                };
                if (this._clubPlays[this._self.ZoneID] == null)
                {
                    this._clubPlays[this._self.ZoneID] = new DictionaryData();
                };
                if (this._tempList[this._self.ZoneID] == null)
                {
                    this._tempList[this._self.ZoneID] = new DictionaryData();
                };
                if (this._myAcademyPlayers == null)
                {
                    this._myAcademyPlayers = new DictionaryData();
                };
                if (_arg_1 == this._self.ID)
                {
                    return (this._self);
                };
                if (this._friendList[this._self.ZoneID][_arg_1])
                {
                    return (this._friendList[this._self.ZoneID][_arg_1]);
                };
                if (this._clubPlays[this._self.ZoneID][_arg_1])
                {
                    return (this._clubPlays[this._self.ZoneID][_arg_1]);
                };
                if (this._tempList[this._self.ZoneID][_arg_3])
                {
                    return (this._tempList[this._self.ZoneID][_arg_3]);
                };
                if (this._myAcademyPlayers[_arg_1])
                {
                    return (this._myAcademyPlayers[_arg_1]);
                };
                if (this._tempList[this._self.ZoneID][_arg_1])
                {
                    if (this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][_arg_1].NickName])
                    {
                        for each (_local_4 in this._tempList[this._self.ZoneID])
                        {
                            if (_local_4.NickName == this._tempList[this._self.ZoneID][_arg_1].NickName)
                            {
                                return (_local_4);
                            };
                        };
                    };
                    return (this._tempList[this._self.ZoneID][_arg_1]);
                };
                for each (_local_5 in this._tempList[this._self.ZoneID])
                {
                    if (_local_5.ID == _arg_1)
                    {
                        this._tempList[this._self.ZoneID][_arg_1] = _local_5;
                        return (_local_5);
                    };
                };
                _local_6 = new PlayerInfo();
                _local_6.ID = _arg_1;
                _local_6.ZoneID = this._self.ZoneID;
                this._tempList[this._self.ZoneID][_arg_1] = _local_6;
                return (_local_6);
            };
            if (((this._friendList[_arg_2]) && (this._friendList[_arg_2][_arg_1])))
            {
                return (this._friendList[_arg_2][_arg_1]);
            };
            if (((this._clubPlays[_arg_2]) && (this._clubPlays[_arg_2][_arg_1])))
            {
                return (this._clubPlays[_arg_2][_arg_1]);
            };
            if (((this._tempList[_arg_2]) && (this._tempList[_arg_2][_arg_1])))
            {
                return (this._tempList[_arg_2][_arg_1]);
            };
            _local_7 = new PlayerInfo();
            _local_7.ID = _arg_1;
            _local_7.ZoneID = _arg_2;
            if (this._tempList[_arg_2] == null)
            {
                this._tempList[_arg_2] = new DictionaryData();
            };
            this._tempList[_arg_2][_arg_1] = _local_7;
            return (_local_7);
        }

        public function hasInMailTempList(_arg_1:int):Boolean
        {
            if (this._mailTempList[this._self.ZoneID] == null)
            {
                this._mailTempList[this._self.ZoneID] = new DictionaryData();
            };
            if (this._mailTempList[this._self.ZoneID][_arg_1])
            {
                return (true);
            };
            return (false);
        }

        public function set mailTempList(_arg_1:DictionaryData):void
        {
            if (this._mailTempList == null)
            {
                this._mailTempList = new DictionaryData();
            };
            if (this._mailTempList[this._self.ZoneID] == null)
            {
                this._mailTempList[this._self.ZoneID] = new DictionaryData();
            };
            this._mailTempList[this._self.ZoneID] = _arg_1;
        }

        public function hasInFriendList(_arg_1:int):Boolean
        {
            if (this._friendList[this._self.ZoneID] == null)
            {
                this._friendList[this._self.ZoneID] = new DictionaryData();
            };
            if (this._friendList[this._self.ZoneID][_arg_1])
            {
                return (true);
            };
            return (false);
        }

        public function hasInClubPlays(_arg_1:int):Boolean
        {
            if (this._clubPlays[this._self.ZoneID] == null)
            {
                this._clubPlays[this._self.ZoneID] = new DictionaryData();
            };
            if (this._clubPlays[this._self.ZoneID][_arg_1])
            {
                return (true);
            };
            return (false);
        }

        private function __selfPopChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["TotalCount"])
            {
                switch (PlayerManager.Instance.Self.TotalCount)
                {
                    case 1:
                        StatisticManager.Instance().startAction("gameOver1", "yes");
                        break;
                    case 3:
                        StatisticManager.Instance().startAction("gameOver3", "yes");
                        break;
                    case 5:
                        StatisticManager.Instance().startAction("gameOver5", "yes");
                        break;
                    case 10:
                        StatisticManager.Instance().startAction("gameOver10", "yes");
                        break;
                };
            };
            if (_arg_1.changedProperties["Grade"])
            {
                TaskManager.instance.requestCanAcceptTask();
            };
        }

        private function __updatePet(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:int;
            var _local_8:Boolean;
            var _local_9:int;
            var _local_10:int;
            var _local_11:PetInfo;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:PlayerInfo = this.findPlayer(_local_3, -1);
            _local_4.ID = _local_3;
            _local_4.beginChanges();
            var _local_5:int = _local_2.readInt();
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_2.readInt();
                _local_8 = _local_2.readBoolean();
                if (_local_8)
                {
                    _local_9 = _local_2.readInt();
                    _local_10 = _local_2.readInt();
                    _local_11 = PetInfoManager.instance.getPetInfoByTemplateID(_local_10);
                    _local_11.ID = _local_9;
                    _local_11.Place = _local_7;
                    _local_11.Name = _local_2.readUTF();
                    _local_11.UserID = _local_2.readInt();
                    _local_11.Attack = _local_2.readInt();
                    _local_11.Defence = _local_2.readInt();
                    _local_11.Luck = _local_2.readInt();
                    _local_11.Agility = _local_2.readInt();
                    _local_11.Blood = _local_2.readInt();
                    _local_11.Bless = _local_2.readInt();
                    _local_11.OrderNumber = _local_2.readInt();
                    _local_11.MagicLevel = _local_2.readInt();
                    _local_11.Level = _local_2.readInt();
                    _local_11.GP = _local_2.readInt();
                    _local_11.MaxGP = _local_2.readInt();
                    _local_11.clearSkills();
                    _local_12 = _local_2.readInt();
                    _local_13 = 0;
                    while (_local_13 < _local_12)
                    {
                        _local_14 = _local_2.readInt();
                        _local_15 = _local_2.readInt();
                        _local_11.addSkill(_local_14, _local_15);
                        _local_13++;
                    };
                    _local_4.pets.add(_local_11.Place, _local_11);
                    PetInfoManager.instance.checkPetCanMagic(_local_11);
                }
                else
                {
                    _local_4.pets.remove(_local_7);
                };
                _local_6++;
            };
            _local_4.commitChanges();
        }

        public function set playerstate(_arg_1:String):void
        {
            this._playerState = _arg_1;
            dispatchEvent(new Event(CHAGE_STATE));
        }

        public function get playerstate():String
        {
            return (this._playerState);
        }

        public function changeState(_arg_1:String):void
        {
            this.playerstate = _arg_1;
        }

        private function __updateOneKeyFinish(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._self.uesedFinishTime = _local_2.readInt();
        }

        private function __updateFatigue(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._self.beginChanges();
            this._self.Fatigue = _local_2.readInt();
            this._self.FatigueupDateTimer = _local_2.readDate();
            this._self.NeedFatigue = _local_2.readInt();
            this._self.commitChanges();
            dispatchEvent(new Event(UPDATE_FATIUE));
        }

        private function __updateMission(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._self.beginChanges();
            this._self.PveInfoID = _local_2.readInt();
            this._self.HardLevel = _local_2.readInt();
            this._self.MissionOrder = _local_2.readInt();
            this._self.MissionID = _local_2.readInt();
            this._self.NeedFatigue = _local_2.readInt();
            this._self.commitChanges();
        }

        private function __buyFatigueHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:String;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            switch (_local_3)
            {
                case 0:
                    _local_4 = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo1");
                    break;
                case 1:
                    _local_4 = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo2");
                    break;
                case 2:
                    _local_4 = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo3");
                    break;
                case 3:
                    LeavePageManager.showFillFrame();
                    break;
            };
            if (_local_4)
            {
                MessageTipManager.getInstance().show(_local_4);
            };
            dispatchEvent(new Event(BUY_FATIUE));
        }

        private function __updateConsotionStatus(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            PlayerManager.Instance.Self.consortionStatus = _local_2;
        }

        private function __updateExperience(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            PlayerManager.Instance.Self.consortiaInfo.Experience = _local_2;
        }

        public function checkExpedition():Boolean
        {
            return (this._self.expeditionCurrent.IsOnExpedition);
        }

        public function geticonShine(_arg_1:String):Boolean
        {
            if (this._iconShineDic[_arg_1] == null)
            {
                this._iconShineDic[_arg_1] = true;
            };
            return (this._iconShineDic[_arg_1]);
        }

        public function setIconShine(_arg_1:String, _arg_2:Boolean):void
        {
            this._iconShineDic[_arg_1] = _arg_2;
        }

        public function setupInvitedFriendList(_arg_1:InvitedFriendListAnalyzer):void
        {
            this.invitedFriendList = _arg_1.friendlist;
            this._invitedAwardStep = _arg_1.invitedAwardStep;
            this._inviterID = _arg_1.InviterID;
        }

        public function set invitedFriendList(_arg_1:DictionaryData):void
        {
            this._invitedFriendList[this._self.ZoneID] = _arg_1;
        }

        public function get invitedAwardStep():int
        {
            return (this._invitedAwardStep);
        }

        public function get invitedFriendList():DictionaryData
        {
            if (this._invitedFriendList[this._self.ZoneID] == null)
            {
                this._invitedFriendList[this._self.ZoneID] = new DictionaryData();
            };
            return (this._invitedFriendList[this._self.ZoneID]);
        }

        public function get inviter():InvitedFirendListPlayer
        {
            if ((!(this._inviterID)))
            {
                return (null);
            };
            return (this.invitedFriendList[this._inviterID]);
        }

        public function get CloseFriendsIMList():Array
        {
            var _local_3:InvitedFirendListPlayer;
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            for each (_local_3 in this.invitedFriendList)
            {
                if (_local_3.playerState.StateID != PlayerState.OFFLINE)
                {
                    _local_1.push(_local_3);
                }
                else
                {
                    _local_2.push(_local_3);
                };
            };
            _local_1 = _local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            _local_2 = _local_2.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            return (_local_1.concat(_local_2));
        }

        public function get CloseFriendsIMListOnline():Array
        {
            var _local_2:InvitedFirendListPlayer;
            var _local_1:Array = new Array();
            for each (_local_2 in this.invitedFriendList)
            {
                if (_local_2.playerState.StateID != PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING)));
        }

        public function get CloseFriendsManagerList():Array
        {
            var _local_3:InvitedFirendListPlayer;
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            for each (_local_3 in this.invitedFriendList)
            {
                if (!((_local_3.Grade < 8) || (_local_3.UserID == this._inviterID)))
                {
                    if (_local_3.playerState.StateID != PlayerState.OFFLINE)
                    {
                        _local_1.push(_local_3);
                    }
                    else
                    {
                        _local_2.push(_local_3);
                    };
                };
            };
            _local_1 = _local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            _local_2 = _local_2.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            return (_local_1.concat(_local_2));
        }

        public function get CloseFriendsLevelRewardList():Array
        {
            var _local_3:InvitedFirendListPlayer;
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            for each (_local_3 in this.invitedFriendList)
            {
                if (!((_local_3.Grade < 8) || (_local_3.UserID == this._inviterID)))
                {
                    if (_local_3.awardStep <= 5)
                    {
                        if (_local_3.playerState.StateID != PlayerState.OFFLINE)
                        {
                            _local_1.push(_local_3);
                        }
                        else
                        {
                            _local_2.push(_local_3);
                        };
                    };
                };
            };
            _local_1 = _local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            _local_2 = _local_2.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            return (_local_1.concat(_local_2));
        }

        private function __closeFriendReward(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:Number = _local_2.readLong();
            if ((!(_local_3)))
            {
                return;
            };
            if (_local_4 == 0)
            {
                this._invitedAwardStep = _local_5;
            }
            else
            {
                if (_local_4 == 1)
                {
                    (this.invitedFriendList[_local_6] as InvitedFirendListPlayer).awardStep = _local_5;
                };
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function __closeFriendChange(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Number = _local_2.readLong();
            var _local_5:int = _local_2.readInt();
            var _local_6:InvitedFirendListPlayer = (this.invitedFriendList[_local_4] as InvitedFirendListPlayer);
            if (_local_3 == 1)
            {
                _local_6.Grade = _local_5;
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function __invitedFriendAdd(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:InvitedFirendListPlayer = new InvitedFirendListPlayer();
            _local_3.UserID = _local_2.readLong();
            _local_3.awardStep = _local_2.readInt();
            _local_3.NickName = _local_2.readUTF();
            _local_3.IsVIP = _local_2.readBoolean();
            _local_3.VIPLevel = _local_2.readInt();
            _local_3.UserName = _local_2.readUTF();
            _local_3.Style = _local_2.readUTF();
            _local_3.SexByInt = _local_2.readInt();
            _local_3.Colors = _local_2.readUTF();
            _local_3.Grade = _local_2.readInt();
            _local_3.Hide = _local_2.readInt();
            _local_3.ConsortiaName = _local_2.readUTF();
            _local_3.TotalCount = _local_2.readInt();
            _local_3.EscapeCount = _local_2.readInt();
            _local_3.WinCount = _local_2.readInt();
            _local_3.Offer = _local_2.readInt();
            _local_3.Repute = _local_2.readInt();
            _local_3.playerState = new PlayerState(_local_2.readInt());
            _local_3.Nimbus = _local_2.readInt();
            _local_3.DutyName = _local_2.readUTF();
            _local_3.AchievementPoint = _local_2.readInt();
            _local_2.readUTF();
            _local_3.FightPower = _local_2.readInt();
            _local_3.apprenticeshipState = _local_2.readInt();
            this.invitedFriendList[_local_3.UserID] = _local_3;
        }


    }
}//package ddt.manager

