package ddt.manager
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BagLockedController;
   import cityWide.CityWideEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.ConsortionModelControl;
   import ddt.data.AccountInfo;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.CMFriendInfo;
   import ddt.data.CheckCodeData;
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.InvitedFriendListAnalyzer;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.club.ClubInfo;
   import ddt.data.goods.BagCellInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.InvitedFirendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerPropertyType;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TimeEvents;
   import ddt.states.StateType;
   import ddt.view.CheckCodeFrame;
   import ddt.view.chat.ChatData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import im.AddCommunityFriend;
   import im.IMController;
   import im.IMEvent;
   import im.info.CustomInfo;
   import pet.date.PetInfo;
   import platformapi.tencent.DiamondManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.BitmapReader;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.PassInputFrame;
   import totem.TotemManager;
   
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
      
      public var SelfConsortia:ClubInfo;
      
      private var _account:AccountInfo;
      
      private var _first:Boolean = false;
      
      private var _propertyAdditions:DictionaryData;
      
      private var tempStyle:Array;
      
      private var changedStyle:DictionaryData;
      
      private var _gamepetInfo:PetInfo;
      
      private var _playerState:String = "equip";
      
      private var _iconShineDic:Dictionary;
      
      private var _invitedFriendList:DictionaryData;
      
      private var _invitedAwardStep:int;
      
      public var _inviterID:uint;
      
      public function PlayerManager()
      {
         this.SelfConsortia = new ClubInfo();
         this.tempStyle = [];
         this.changedStyle = new DictionaryData();
         this._iconShineDic = new Dictionary();
         super();
         this._self = new SelfInfo();
         this._clubPlays = new DictionaryData();
         this._tempList = new DictionaryData();
         this._mailTempList = new DictionaryData();
      }
      
      public static function get Instance() : PlayerManager
      {
         if(_instance == null)
         {
            _instance = new PlayerManager();
         }
         return _instance;
      }
      
      public static function readLuckyPropertyName(param1:int) : String
      {
         switch(param1)
         {
            case PlayerPropertyType.Exp:
               return LanguageMgr.GetTranslation("exp");
            case PlayerPropertyType.Offer:
               return LanguageMgr.GetTranslation("offer");
            case PlayerPropertyType.Attack:
               return LanguageMgr.GetTranslation("attack");
            case PlayerPropertyType.Agility:
               return LanguageMgr.GetTranslation("agility");
            case PlayerPropertyType.Damage:
               return LanguageMgr.GetTranslation("damage");
            case PlayerPropertyType.Defence:
               return LanguageMgr.GetTranslation("defence");
            case PlayerPropertyType.Luck:
               return LanguageMgr.GetTranslation("luck");
            case PlayerPropertyType.MaxHp:
               return LanguageMgr.GetTranslation("MaxHp");
            case PlayerPropertyType.Recovery:
               return LanguageMgr.GetTranslation("recovery");
            default:
               return "";
         }
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function get isLeadOfConsortia() : Boolean
      {
         if(this.Self.consortiaInfo.ChairmanID == this.Self.ID)
         {
            return true;
         }
         return false;
      }
      
      public function setup(param1:AccountInfo) : void
      {
         this._account = param1;
         this.customList = new Vector.<CustomInfo>();
         this._friendList = new DictionaryData();
         this._blackList = new DictionaryData();
         this._invitedFriendList = new DictionaryData();
         this.initEvents();
      }
      
      public function get Account() : AccountInfo
      {
         return this._account;
      }
      
      public function set Account(param1:AccountInfo) : void
      {
         this._account = param1;
      }
      
      public function getDressEquipPlace(param1:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = EquipType.CategeryIdToPlace(param1.CategoryID);
         if(EquipType.isRingEquipment(param1))
         {
            _loc3_ = 6;
         }
         else if(_loc2_.length == 1)
         {
            _loc3_ = _loc2_[0];
         }
         else
         {
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(PlayerManager.Instance.Self.Bag.getItemAt(_loc2_[_loc5_]) == null)
               {
                  _loc3_ = _loc2_[_loc5_];
                  break;
               }
               _loc4_++;
               if(_loc4_ == _loc2_.length)
               {
                  _loc3_ = _loc2_[0];
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public function getEquipPlace(param1:InventoryItemInfo) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(EquipType.isWeddingRing(param1))
         {
            return 6;
         }
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         var _loc3_:Array = EquipType.getTemplateTypeToPlace(_loc2_.TemplateType);
         if(_loc3_.length == 1)
         {
            _loc4_ = _loc3_[0];
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               if(PlayerManager.Instance.Self.Bag.getItemAt(_loc3_[_loc6_]) == null)
               {
                  _loc4_ = _loc3_[_loc6_];
                  break;
               }
               _loc5_++;
               if(_loc5_ == _loc3_.length)
               {
                  _loc4_ = _loc3_[0];
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      private function __updateInventorySlot(param1:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var slot:int = 0;
         var isUpdate:Boolean = false;
         var item:InventoryItemInfo = null;
         var evt:CrazyTankSocketEvent = param1;
         var sign:Boolean = false;
         var pkg:PackageIn = evt.pkg as PackageIn;
         var bagType:int = pkg.readInt();
         var len:int = pkg.readInt();
         var bag:BagInfo = this._self.getBag(bagType);
         bag.beginChanges();
         try
         {
            i = 0;
            while(i < len)
            {
               slot = pkg.readInt();
               isUpdate = pkg.readBoolean();
               if(isUpdate)
               {
                  item = bag.getItemAt(slot);
                  if(item == null)
                  {
                     item = new InventoryItemInfo();
                     item.Place = slot;
                  }
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
                  if(item.isGold)
                  {
                     item.goldValidDate = pkg.readInt();
                     item.goldBeginTime = pkg.readDateString();
                  }
                  bag.addItem(item);
                  if(item.Place == 20 && bagType == 0 && item.UserID == this.Self.ID)
                  {
                     this._self.DeputyWeaponID = item.TemplateID;
                  }
                  if(PathManager.solveExternalInterfaceEnabel() && bagType == BagInfo.STOREBAG && item.StrengthenLevel >= 7)
                  {
                     ExternalInterfaceManager.sendToAgent(3,this.Self.ID,this.Self.NickName,ServerManager.Instance.zoneName,item.StrengthenLevel);
                  }
                  if(StateManager.currentStateType == StateType.AUCTION)
                  {
                  }
               }
               else
               {
                  bag.removeItemAt(slot);
               }
               i++;
            }
         }
         finally
         {
            bag.commiteChanges();
         }
      }
      
      private function __itemEquip(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:InventoryItemInfo = null;
         var _loc12_:uint = 0;
         var _loc13_:InventoryItemInfo = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:PetInfo = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         _loc3_.deCompress();
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:String = _loc3_.readUTF();
         var _loc7_:PlayerInfo = this.findPlayer(_loc4_,_loc5_,_loc6_);
         _loc7_.ID = _loc4_;
         if(_loc7_ != null)
         {
            _loc7_.beginChanges();
            _loc7_.Attack = _loc3_.readInt();
            _loc7_.Defence = _loc3_.readInt();
            _loc7_.Agility = _loc3_.readInt();
            _loc7_.Luck = _loc3_.readInt();
            _loc7_.Damage = _loc3_.readInt();
            _loc7_.Guard = _loc3_.readInt();
            _loc7_.hp = _loc3_.readInt();
            _loc7_.Energy = _loc3_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_))
            {
               _loc7_.Colors = _loc3_.readUTF();
               _loc7_.Skin = _loc3_.readUTF();
            }
            else
            {
               _loc3_.readUTF();
               _loc3_.readUTF();
               _loc7_.Colors = this.changedStyle[_loc4_]["Colors"];
               _loc7_.Skin = this.changedStyle[_loc4_]["Skin"];
            }
            _loc7_.GP = _loc3_.readInt();
            _loc7_.Grade = _loc3_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_))
            {
               _loc7_.Hide = _loc3_.readInt();
            }
            else
            {
               _loc3_.readInt();
               _loc7_.Hide = this.changedStyle[_loc4_]["Hide"];
            }
            _loc7_.Repute = _loc3_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_))
            {
               _loc7_.Sex = _loc3_.readBoolean();
               _loc7_.Style = _loc3_.readUTF();
            }
            else
            {
               _loc3_.readBoolean();
               _loc3_.readUTF();
               _loc7_.Sex = this.changedStyle[_loc4_]["Sex"];
               _loc7_.Style = this.changedStyle[_loc4_]["Style"];
            }
            _loc7_.Offer = _loc3_.readInt();
            _loc7_.NickName = _loc6_;
            _loc7_.VIPtype = _loc3_.readByte();
            _loc7_.VIPLevel = _loc3_.readInt();
            _loc7_.isFightVip = _loc3_.readBoolean();
            _loc7_.fightToolBoxSkillNum = _loc3_.readInt();
            _loc7_.WinCount = _loc3_.readInt();
            _loc7_.TotalCount = _loc3_.readInt();
            _loc7_.EscapeCount = _loc3_.readInt();
            _loc7_.ConsortiaID = _loc3_.readInt();
            _loc7_.ConsortiaName = _loc3_.readUTF();
            _loc7_.RichesOffer = _loc3_.readInt();
            _loc7_.RichesRob = _loc3_.readInt();
            _loc7_.IsMarried = _loc3_.readBoolean();
            _loc7_.SpouseID = _loc3_.readInt();
            _loc7_.SpouseName = _loc3_.readUTF();
            _loc7_.DutyName = _loc3_.readUTF();
            _loc7_.FightPower = _loc3_.readInt();
            _loc7_.apprenticeshipState = _loc3_.readInt();
            _loc7_.masterID = _loc3_.readInt();
            _loc7_.setMasterOrApprentices(_loc3_.readUTF());
            _loc7_.graduatesCount = _loc3_.readInt();
            _loc7_.honourOfMaster = _loc3_.readUTF();
            _loc7_.AchievementPoint = _loc3_.readInt();
            _loc7_.honor = _loc3_.readUTF();
            _loc7_.LastLoginDate = _loc3_.readDate();
            _loc7_.Fatigue = _loc3_.readInt();
            _loc7_.DailyLeagueFirst = _loc3_.readBoolean();
            _loc7_.DailyLeagueLastScore = _loc3_.readInt();
            _loc7_.totemId = _loc3_.readInt();
            _loc7_.runeLevel = _loc3_.readInt();
            _loc8_ = _loc3_.readInt();
            _loc7_.Bag.beginChanges();
            if(!(_loc7_ is SelfInfo))
            {
               _loc7_.Bag.clearnAll();
            }
            _loc2_ = 0;
            while(_loc2_ < _loc8_)
            {
               _loc11_ = new InventoryItemInfo();
               _loc11_.BagType = _loc3_.readByte();
               _loc11_.UserID = _loc3_.readInt();
               _loc11_.ItemID = _loc3_.readInt();
               _loc11_.Count = _loc3_.readInt();
               _loc11_.Place = _loc3_.readInt();
               _loc11_.TemplateID = _loc3_.readInt();
               _loc11_.AttackCompose = _loc3_.readInt();
               _loc11_.DefendCompose = _loc3_.readInt();
               _loc11_.AgilityCompose = _loc3_.readInt();
               _loc11_.LuckCompose = _loc3_.readInt();
               _loc11_.StrengthenLevel = _loc3_.readInt();
               _loc11_.IsBinds = _loc3_.readBoolean();
               _loc11_.IsJudge = _loc3_.readBoolean();
               _loc11_.BeginDate = _loc3_.readDateString();
               _loc11_.ValidDate = _loc3_.readInt();
               _loc11_.Color = _loc3_.readUTF();
               _loc11_.Skin = _loc3_.readUTF();
               _loc11_.IsUsed = _loc3_.readBoolean();
               ItemManager.fill(_loc11_);
               _loc11_.Hole1 = _loc3_.readInt();
               _loc11_.Hole2 = _loc3_.readInt();
               _loc11_.Hole3 = _loc3_.readInt();
               _loc11_.Hole4 = _loc3_.readInt();
               _loc11_.Hole5 = _loc3_.readInt();
               _loc11_.Hole6 = _loc3_.readInt();
               _loc11_.Pic = _loc3_.readUTF();
               _loc11_.RefineryLevel = _loc3_.readInt();
               _loc11_.DiscolorValidDate = _loc3_.readDateString();
               _loc11_.Hole5Level = _loc3_.readByte();
               _loc11_.Hole5Exp = _loc3_.readInt();
               _loc11_.Hole6Level = _loc3_.readByte();
               _loc11_.Hole6Exp = _loc3_.readInt();
               _loc11_.isGold = _loc3_.readBoolean();
               if(_loc11_.isGold)
               {
                  _loc11_.goldValidDate = _loc3_.readInt();
                  _loc11_.goldBeginTime = _loc3_.readDateString();
               }
               _loc7_.Bag.addItem(_loc11_);
               _loc2_++;
            }
            _loc7_.Bag.commiteChanges();
            _loc9_ = _loc3_.readInt();
            if(_loc9_ != 0)
            {
               _loc7_.BeadBag.beginChanges();
               _loc7_.BeadBag.clearnAll();
               _loc12_ = 0;
               while(_loc12_ < _loc9_)
               {
                  _loc13_ = new InventoryItemInfo();
                  _loc13_.BagType = _loc3_.readByte();
                  _loc13_.UserID = _loc3_.readLong();
                  _loc13_.ItemID = _loc3_.readLong();
                  _loc13_.Count = _loc3_.readInt();
                  _loc13_.Place = _loc3_.readInt();
                  _loc13_.TemplateID = _loc3_.readInt();
                  _loc13_.AttackCompose = _loc3_.readInt();
                  _loc13_.DefendCompose = _loc3_.readInt();
                  _loc13_.AgilityCompose = _loc3_.readInt();
                  _loc13_.LuckCompose = _loc3_.readInt();
                  _loc13_.StrengthenExp = _loc3_.readInt();
                  _loc13_.IsBinds = _loc3_.readBoolean();
                  _loc13_.IsJudge = _loc3_.readBoolean();
                  _loc13_.BeginDate = _loc3_.readDateString();
                  _loc13_.ValidDate = _loc3_.readInt();
                  _loc13_.Color = _loc3_.readUTF();
                  _loc13_.Skin = _loc3_.readUTF();
                  _loc13_.IsUsed = _loc3_.readBoolean();
                  ItemManager.fill(_loc13_);
                  _loc13_.Pic = _loc3_.readUTF();
                  _loc13_.RefineryLevel = _loc3_.readInt();
                  _loc3_.readDateString();
                  _loc13_.beadIsLock = _loc3_.readByte();
                  _loc13_.beadLevel = _loc3_.readInt();
                  _loc13_.Hole6Level = _loc3_.readByte();
                  _loc13_.beadExp = _loc3_.readInt();
                  _loc7_.BeadBag.addItem(_loc13_);
                  _loc12_++;
               }
               _loc7_.BeadBag.commiteChanges();
            }
            _loc7_.pets.clear();
            _loc10_ = _loc3_.readInt();
            _loc2_ = 0;
            while(_loc2_ < _loc10_)
            {
               _loc14_ = _loc3_.readInt();
               _loc15_ = _loc3_.readInt();
               _loc16_ = _loc3_.readInt();
               _loc17_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc16_);
               _loc17_.Place = _loc14_;
               _loc17_.ID = _loc15_;
               _loc17_.Name = _loc3_.readUTF();
               _loc17_.UserID = _loc3_.readInt();
               _loc17_.Attack = _loc3_.readInt();
               _loc17_.Defence = _loc3_.readInt();
               _loc17_.Luck = _loc3_.readInt();
               _loc17_.Agility = _loc3_.readInt();
               _loc17_.Blood = _loc3_.readInt();
               _loc17_.Bless = _loc3_.readInt();
               _loc17_.OrderNumber = _loc3_.readInt();
               _loc17_.MagicLevel = _loc3_.readInt();
               _loc17_.Level = _loc3_.readInt();
               _loc17_.GP = _loc3_.readInt();
               _loc17_.MaxGP = _loc3_.readInt();
               if(!RoomManager.Instance.current || RoomManager.Instance.current.type != RoomInfo.CHANGE_DUNGEON)
               {
                  _loc17_.clearSkills();
               }
               _loc18_ = _loc3_.readInt();
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc20_ = _loc3_.readInt();
                  _loc21_ = _loc3_.readInt();
                  _loc17_.addSkill(_loc20_,_loc21_);
                  _loc19_++;
               }
               if(!RoomManager.Instance.current || RoomManager.Instance.current.type != RoomInfo.CHANGE_DUNGEON)
               {
                  _loc7_.pets.add(_loc17_.Place,_loc17_);
               }
               _loc2_++;
            }
            _loc7_.MilitaryRankTotalScores = _loc3_.readInt();
            _loc7_.commitChanges();
         }
      }
      
      private function __onsItemEquip(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_);
         if(_loc5_ != null)
         {
            _loc5_.beginChanges();
            _loc5_.Agility = _loc2_.readInt();
            _loc5_.Attack = _loc2_.readInt();
            _loc5_.Crit = _loc2_.readInt();
            _loc5_.Stormdamage = _loc2_.readInt();
            _loc5_.Uprisingstrike = _loc2_.readInt();
            _loc5_.Uprisinginjury = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Colors = _loc2_.readUTF();
               _loc5_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc5_.Colors = this.changedStyle[_loc3_]["Colors"];
               _loc5_.Skin = this.changedStyle[_loc3_]["Skin"];
            }
            _loc5_.Defence = _loc2_.readInt();
            _loc5_.GP = _loc2_.readInt();
            _loc5_.Grade = _loc2_.readInt();
            _loc5_.Luck = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc5_.Hide = this.changedStyle[_loc3_]["Hide"];
            }
            _loc5_.Repute = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Sex = _loc2_.readBoolean();
               _loc5_.Style = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readBoolean();
               _loc2_.readUTF();
               _loc5_.Sex = this.changedStyle[_loc3_]["Sex"];
               _loc5_.Style = this.changedStyle[_loc3_]["Style"];
            }
            _loc5_.Offer = _loc2_.readInt();
            _loc5_.NickName = _loc4_;
            _loc5_.VIPtype = _loc2_.readByte();
            _loc5_.VIPLevel = _loc2_.readInt();
            _loc5_.WinCount = _loc2_.readInt();
            _loc5_.TotalCount = _loc2_.readInt();
            _loc5_.EscapeCount = _loc2_.readInt();
            _loc5_.ConsortiaID = _loc2_.readInt();
            _loc5_.ConsortiaName = _loc2_.readUTF();
            _loc5_.RichesOffer = _loc2_.readInt();
            _loc5_.RichesRob = _loc2_.readInt();
            _loc5_.IsMarried = _loc2_.readBoolean();
            _loc5_.SpouseID = _loc2_.readInt();
            _loc5_.SpouseName = _loc2_.readUTF();
            _loc5_.DutyName = _loc2_.readUTF();
            _loc6_ = _loc2_.readInt();
            _loc5_.FightPower = _loc2_.readInt();
            _loc5_.apprenticeshipState = _loc2_.readInt();
            _loc5_.masterID = _loc2_.readInt();
            _loc5_.setMasterOrApprentices(_loc2_.readUTF());
            _loc5_.graduatesCount = _loc2_.readInt();
            _loc5_.honourOfMaster = _loc2_.readUTF();
            _loc5_.AchievementPoint = _loc2_.readInt();
            _loc5_.honor = _loc2_.readUTF();
            _loc5_.LastLoginDate = _loc2_.readDate();
            _loc5_.commitChanges();
            _loc5_.Bag.beginChanges();
            _loc5_.Bag.commiteChanges();
            _loc5_.commitChanges();
         }
         super.dispatchEvent(new CityWideEvent(CityWideEvent.ONS_PLAYERINFO,_loc5_));
      }
      
      private function __bagLockedHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:int = param1.pkg.readInt();
         var _loc8_:String = param1.pkg.readUTF();
         var _loc9_:String = param1.pkg.readUTF();
         if(_loc4_)
         {
            switch(_loc3_)
            {
               case 1:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  this._self.onReceiveTypes(BagEvent.CHANGEPSW);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 2:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = false;
                  if(!ServerManager.AUTO_UNLOCK)
                  {
                     if(_loc6_ != "")
                     {
                        MessageTipManager.getInstance().show(_loc6_);
                     }
                     ServerManager.AUTO_UNLOCK = false;
                  }
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  this._self.onReceiveTypes(BagEvent.CLEAR);
                  break;
               case 3:
                  this._self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 4:
                  this._self.bagPwdState = false;
                  this._self.bagLocked = false;
                  this._self.onReceiveTypes(BagEvent.AFTERDEL);
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 5:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 6:
            }
         }
         else
         {
            MessageTipManager.getInstance().show(_loc6_);
         }
      }
      
      private function __friendAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:FriendListPlayer = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = new FriendListPlayer();
            _loc4_.beginChanges();
            _loc4_.ID = _loc2_.readInt();
            _loc4_.NickName = _loc2_.readUTF();
            _loc4_.VIPtype = _loc2_.readByte();
            _loc4_.VIPLevel = _loc2_.readInt();
            _loc4_.Sex = _loc2_.readBoolean();
            _loc5_ = this.findPlayer(_loc4_.ID);
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_.ID))
            {
               _loc4_.Style = _loc2_.readUTF();
               _loc4_.Colors = _loc2_.readUTF();
               _loc4_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc4_.Style = _loc5_.Style;
               _loc4_.Colors = _loc5_.Colors;
               _loc4_.Skin = _loc5_.Skin;
            }
            _loc4_.playerState = new PlayerState(_loc2_.readInt());
            _loc4_.Grade = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc4_.ID))
            {
               _loc4_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc4_.Hide = _loc5_.Hide;
            }
            _loc4_.ConsortiaName = _loc2_.readUTF();
            _loc4_.TotalCount = _loc2_.readInt();
            _loc4_.EscapeCount = _loc2_.readInt();
            _loc4_.WinCount = _loc2_.readInt();
            _loc4_.Offer = _loc2_.readInt();
            _loc4_.Repute = _loc2_.readInt();
            _loc4_.Relation = _loc2_.readInt();
            _loc4_.LoginName = _loc2_.readUTF();
            _loc6_ = _loc2_.readInt();
            _loc4_.FightPower = _loc2_.readInt();
            _loc4_.apprenticeshipState = _loc2_.readInt();
            _loc4_.masterID = _loc2_.readInt();
            _loc4_.setMasterOrApprentices(_loc2_.readUTF());
            _loc4_.graduatesCount = _loc2_.readInt();
            _loc4_.honourOfMaster = _loc2_.readUTF();
            _loc4_.AchievementPoint = _loc2_.readInt();
            _loc4_.honor = _loc2_.readUTF();
            _loc4_.IsMarried = _loc2_.readBoolean();
            _loc4_.isOld = _loc2_.readBoolean();
            _loc4_.commitChanges();
            if(_loc4_.Relation != 1)
            {
               this.addFriend(_loc4_);
               if(PathInfo.isUserAddFriend)
               {
                  new AddCommunityFriend(_loc4_.LoginName,_loc4_.NickName);
               }
            }
            else
            {
               this.addBlackList(_loc4_);
            }
            dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND,_loc4_));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.playerManager.addFriend.isRefused"));
         }
      }
      
      public function addFriend(param1:PlayerInfo) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.blackList.remove(param1.ID);
         this.friendList.add(param1.ID,param1);
      }
      
      public function addBlackList(param1:FriendListPlayer) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1.ID);
         this.blackList.add(param1.ID,param1);
      }
      
      public function removeFriend(param1:int) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1);
         this.blackList.remove(param1);
      }
      
      private function __friendRemove(param1:CrazyTankSocketEvent) : void
      {
         this.removeFriend(param1.pkg.clientId);
      }
      
      private function __playerState(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            _loc3_ = _loc2_.clientId;
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readByte();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readBoolean();
            _loc8_ = false;
            _loc9_ = 0;
            _loc10_ = 0;
            if(DiamondManager.instance.isInTencent)
            {
               _loc8_ = _loc2_.readBoolean();
               _loc9_ = _loc2_.readByte();
               _loc10_ = _loc2_.readByte();
            }
            this.playerStateChange(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
            if(_loc3_ == this.Self.SpouseID)
            {
               this.spouseStateChange(_loc4_);
            }
            ConsortionModelControl.Instance.model.consortiaPlayerStateChange(_loc3_,_loc4_);
         }
      }
      
      private function spouseStateChange(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 == PlayerState.ONLINE)
         {
            _loc2_ = !!this.Self.Sex ? LanguageMgr.GetTranslation("ddt.manager.playerManager.wifeOnline",this.Self.SpouseName) : LanguageMgr.GetTranslation("ddt.manager.playerManager.hushandOnline",this.Self.SpouseName);
            ChatManager.Instance.sysChatYellow(_loc2_);
         }
      }
      
      private function masterStateChange(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         if(param1 == PlayerState.ONLINE && param2 != this.Self.SpouseID)
         {
            if(param2 == this.Self.masterID)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.masterState",this.Self.getMasterOrApprentices()[param2]);
            }
            else
            {
               if(!this.Self.getMasterOrApprentices()[param2])
               {
                  return;
               }
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.ApprenticeState",this.Self.getMasterOrApprentices()[param2]);
            }
            ChatManager.Instance.sysChatYellow(_loc3_);
         }
      }
      
      public function playerStateChange(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:int, param8:int) : void
      {
         var _loc10_:String = null;
         var _loc11_:PlayerInfo = null;
         var _loc9_:PlayerInfo = this.friendList[param1];
         if(_loc9_)
         {
            if(_loc9_.playerState.StateID != param2 || _loc9_.VIPtype != param3 || _loc9_.isSameCity != param5)
            {
               _loc9_.VIPtype = param3;
               _loc9_.VIPLevel = param4;
               _loc9_.isSameCity = param5;
               _loc9_.isYellowVip = param6;
               _loc9_.MemberDiamondLevel = param7;
               _loc9_.Level3366 = param8;
               _loc10_ = "";
               if(_loc9_.playerState.StateID != param2)
               {
                  _loc9_.playerState = new PlayerState(param2);
                  this.friendList.add(param1,_loc9_);
                  if(param1 == this.Self.SpouseID)
                  {
                     return;
                  }
                  if(param1 == this.Self.masterID || this.Self.getMasterOrApprentices()[param1])
                  {
                     this.masterStateChange(param2,param1);
                     return;
                  }
                  if(param2 == PlayerState.ONLINE && SharedManager.Instance.showOL)
                  {
                     _loc10_ = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend") + "[" + _loc9_.NickName + "]" + LanguageMgr.GetTranslation("tank.manager.PlayerManger.friendOnline");
                     ChatManager.Instance.sysChatYellow(_loc10_);
                     return;
                  }
                  return;
               }
            }
            this.friendList.add(param1,_loc9_);
         }
         else if(this.myAcademyPlayers)
         {
            _loc11_ = this.myAcademyPlayers[param1];
            if(_loc11_)
            {
               if(_loc11_.playerState.StateID != param2 || _loc11_.IsVIP != param3)
               {
                  _loc11_.VIPtype = param3;
                  _loc11_.VIPLevel = param4;
                  _loc11_.playerState = new PlayerState(param2);
                  this.myAcademyPlayers.add(param1,_loc11_);
               }
            }
         }
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS,this.__updateInventorySlot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP,this.__itemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONS_EQUIP,this.__onsItemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED,this.__bagLockedHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePrivateInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,this.__updatePlayerInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TEMP_STYLE,this.__readTempStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE,this.__checkCodePopup);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         this.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPopChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD,this.__friendAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE,this.__friendRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE,this.__playerState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_IS_OPENED,this.__upVipInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER,this.__updateUerGuild);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,this.__chatFilteringFriendsShare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAME_CITY_FRIEND,this.__sameCity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PET,this.__updatePet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_ONEKEYFINISH,this.__updateOneKeyFinish);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY,this.__updatePlayerProperty);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPEN_BAG_CELL,this.__onOpenBagCell);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_TOOL_BOX,this.__updateFightVip);
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__updateDataByMin);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FATIGUE,this.__updateFatigue);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_ENERGY,this.__updateMission);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_FATIGUE,this.__buyFatigueHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_STATUS,this.__updateConsotionStatus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_EXPERIENCE,this.__updateExperience);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_REWARD,this.__closeFriendReward);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_CHANGE,this.__closeFriendChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOSE_FRIEND_ADD,this.__invitedFriendAdd);
         addEventListener(BagEvent.UPDATE_BAG_CELL,this.__updateBagCell);
      }
      
      private function __updateDataByMin(param1:TimeEvents) : void
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         if(this._self.IsVIP && _loc2_.getTime() > this._self.VIPExpireDay.getTime() + 60000)
         {
            SocketManager.Instance.out.sendVipOverdue(this._self.ID);
         }
         if(this._self.isFightVip && _loc2_.getTime() > this._self.fightVipStartTime.getTime() + this._self.fightVipValidDate * 60 * 1000)
         {
            SocketManager.Instance.out.sendfightVip(2);
         }
      }
      
      private function __updateFightVip(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.beginChanges();
         this._self.isFightVip = _loc2_.readBoolean();
         this._self.fightToolBoxSkillNum = _loc2_.readInt();
         this._self.fightVipStartTime = _loc2_.readDate();
         this._self.fightVipValidDate = _loc2_.readInt();
         this._self.commitChanges();
         dispatchEvent(new Event(UPDATE_FIGHT_VIP));
      }
      
      private function __onOpenBagCell(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:Date = _loc3_.readDate();
         _loc2_["bagIndex"] = _loc4_;
         _loc2_["lastTime"] = _loc5_;
         dispatchEvent(new BagEvent(BagEvent.UPDATE_BAG_CELL,_loc2_));
      }
      
      public function get First() : Boolean
      {
         return this._first;
      }
      
      public function set First(param1:Boolean) : void
      {
         this._first = param1;
      }
      
      private function __updateBagCell(param1:BagEvent) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:BagCellInfo = null;
         if(!this.First)
         {
            _loc2_ = param1.changedSlots;
            PlayerManager.Instance.Self.bagCellUpdateIndex = _loc2_.bagIndex;
            PlayerManager.Instance.Self.bagCellUpdateTime = _loc2_.lastTime;
            _loc3_ = ItemManager.Instance.getBagCellByPlace(PlayerManager.Instance.Self.bagCellUpdateIndex - 30);
            PlayerManager.Instance.Self.getStratTime(_loc3_.NeedTime * 60);
            this.First = true;
         }
      }
      
      protected function __updatePlayerProperty(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:String = null;
         var _loc8_:PlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = ["Attack","Defence","Agility","Luck","HP"];
         var _loc4_:DictionaryData = new DictionaryData();
         var _loc5_:DictionaryData = null;
         var _loc6_:int = -1;
         _loc6_ = _loc2_.readInt();
         for each(_loc7_ in _loc3_)
         {
            _loc5_ = _loc4_[_loc7_] = new DictionaryData();
            _loc2_.readInt();
            if(_loc7_ != "HP")
            {
               _loc5_["fashion"] = _loc2_.readInt();
            }
            _loc5_["Equip"] = _loc2_.readInt();
            _loc5_["Embed"] = _loc2_.readInt();
            _loc5_["Bead"] = _loc2_.readInt();
            _loc5_["Pet"] = _loc2_.readInt();
         }
         _loc4_["Damage"] = new DictionaryData();
         _loc2_.readInt();
         _loc4_["Damage"]["Equip"] = _loc2_.readInt();
         _loc4_["Damage"]["Embed"] = _loc2_.readInt();
         _loc4_["Damage"]["Bead"] = _loc2_.readInt();
         _loc4_["Damage"]["attack"] = _loc2_.readInt();
         _loc4_["Armor"] = new DictionaryData();
         _loc2_.readInt();
         _loc4_["Armor"]["Equip"] = _loc2_.readInt();
         _loc4_["Armor"]["Embed"] = _loc2_.readInt();
         _loc4_["Armor"]["Bead"] = _loc2_.readInt();
         _loc4_["Armor"]["defence"] = _loc2_.readInt();
         _loc4_["Energy"] = new DictionaryData();
         _loc2_.readInt();
         _loc4_["Energy"]["Equip"] = _loc2_.readInt();
         _loc4_["Energy"]["Embed"] = _loc2_.readInt();
         _loc8_ = this.findPlayer(_loc6_);
         _loc8_.runeLevel = _loc2_.readInt();
         TotemManager.instance.updatePropertyAddtion(_loc8_.totemId,_loc4_);
         _loc8_.propertyAddition = _loc4_;
         dispatchEvent(new Event(UPDATE_PLAYER_PROPERTY));
      }
      
      public function get propertyAdditions() : DictionaryData
      {
         return this._propertyAdditions;
      }
      
      private function __roomListPass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PassInputFrame = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.passInputFrame");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.ID = _loc2_;
      }
      
      private function __sameCity(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = param1.pkg.readInt();
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.pkg.readInt();
            this.findPlayer(_loc4_,this.Self.ZoneID).isSameCity = true;
            if(!this._sameCityList)
            {
               this._sameCityList = new Array();
            }
            this._sameCityList.push(_loc4_);
            _loc3_++;
         }
         this.initSameCity();
      }
      
      private function initSameCity() : void
      {
         if(!this._sameCityList)
         {
            this._sameCityList = new Array();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._sameCityList.length)
         {
            this.findPlayer(this._sameCityList[_loc1_]).isSameCity = true;
            _loc1_++;
         }
         this._friendList[this._self.ZoneID].dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE));
      }
      
      private function __chatFilteringFriendsShare(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:CMFriendInfo = null;
         if(!this._cmFriendList)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:Boolean = false;
         for each(_loc6_ in this._cmFriendList)
         {
            if(_loc6_.UserId == _loc3_)
            {
               _loc5_ = true;
            }
         }
         if(_loc5_)
         {
            ChatManager.Instance.sysChatYellow(_loc4_);
         }
      }
      
      private function __updateUerGuild(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.pkg.readByte();
            _loc2_.writeByte(_loc5_);
            _loc4_++;
         }
         this._self.weaklessGuildProgress = _loc2_;
      }
      
      private function __sysNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         var _loc9_:String = _loc2_.readUTF();
         var _loc10_:ChatData = new ChatData();
         _loc10_.type = 1;
         _loc10_.msg = _loc4_;
         _loc10_.channel = _loc3_;
      }
      
      private function __upVipInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.beginChanges();
         this._self.VIPtype = _loc2_.readByte();
         this._self.VIPLevel = _loc2_.readInt();
         this._self.VIPExp = _loc2_.readInt();
         this._self.VIPExpireDay = _loc2_.readDate();
         this._self.LastDate = _loc2_.readDate();
         this._self.VIPNextLevelDaysNeeded = _loc2_.readInt();
         this._self.openVipType = _loc2_.readBoolean();
         this._self.commitChanges();
         dispatchEvent(new Event(VIP_STATE_CHANGE));
      }
      
      public function setupFriendList(param1:FriendListAnalyzer) : void
      {
         this.customList = param1.customList;
         this.friendList = param1.friendlist;
         this.blackList = param1.blackList;
         this.initSameCity();
      }
      
      public function checkHasGroupName(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.customList.length)
         {
            if(this.customList[_loc2_].Name == param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addFirend.repet"),0,true);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function romoveAcademyPlayers() : void
      {
         var _loc1_:FriendListPlayer = null;
         for each(_loc1_ in this._myAcademyPlayers)
         {
            this.friendList.remove(_loc1_.ID);
         }
      }
      
      public function setupRecentContacts(param1:RecentContactsAnalyze) : void
      {
         this.recentContacts = param1.recentContacts;
      }
      
      public function set friendList(param1:DictionaryData) : void
      {
         this._friendList[this._self.ZoneID] = param1;
         IMController.Instance.isLoadComplete = true;
         dispatchEvent(new Event(FRIENDLIST_COMPLETE));
      }
      
      public function get friendList() : DictionaryData
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._friendList[this._self.ZoneID];
      }
      
      public function getFriendForCustom(param1:int) : DictionaryData
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:DictionaryData = new DictionaryData();
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         for each(_loc3_ in this._friendList[this._self.ZoneID])
         {
            if(_loc3_.Relation == param1)
            {
               _loc2_.add(_loc3_.ID,_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function deleteCustomGroup(param1:int) : void
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this._friendList[this._self.ZoneID])
         {
            if(_loc2_.Relation == param1)
            {
               _loc2_.Relation = 0;
            }
         }
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function get recentContacts() : DictionaryData
      {
         if(!this._recentContacts)
         {
            this._recentContacts = new DictionaryData();
         }
         return this._recentContacts;
      }
      
      public function set recentContacts(param1:DictionaryData) : void
      {
         this._recentContacts = param1;
         dispatchEvent(new Event(RECENT_CONTAST_COMPLETE));
      }
      
      public function get onlineRecentContactList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE || this.findPlayer(_loc2_.ID) && this.findPlayer(_loc2_.ID).playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get offlineRecentContactList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getByNameFriend(param1:String) : FriendListPlayer
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.NickName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function deleteRecentContact(param1:int) : void
      {
         this.recentContacts.remove(param1);
      }
      
      public function get onlineFriendList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getOnlineFriendForCustom(param1:int) : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.friendList)
         {
            if(_loc3_.playerState.StateID != PlayerState.OFFLINE && _loc3_.Relation == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get offlineFriendList() : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getOfflineFriendForCustom(param1:int) : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.friendList)
         {
            if(_loc3_.playerState.StateID == PlayerState.OFFLINE && _loc3_.Relation == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function get onlineMyAcademyPlayers() : Array
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._myAcademyPlayers)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_ as FriendListPlayer);
            }
         }
         return _loc1_;
      }
      
      public function get offlineMyAcademyPlayers() : Array
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._myAcademyPlayers)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_ as FriendListPlayer);
            }
         }
         return _loc1_;
      }
      
      public function set blackList(param1:DictionaryData) : void
      {
         this._blackList[this._self.ZoneID] = param1;
      }
      
      public function get blackList() : DictionaryData
      {
         if(this._blackList[this._self.ZoneID] == null)
         {
            this._blackList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._blackList[this._self.ZoneID];
      }
      
      public function get CMFriendList() : DictionaryData
      {
         return this._cmFriendList;
      }
      
      public function set CMFriendList(param1:DictionaryData) : void
      {
         this._cmFriendList = param1;
      }
      
      public function get PlayCMFriendList() : Array
      {
         if(this._cmFriendList)
         {
            return this._cmFriendList.filter("IsExist",true);
         }
         return [];
      }
      
      public function get UnPlayCMFriendList() : Array
      {
         if(this._cmFriendList)
         {
            return this._cmFriendList.filter("IsExist",false);
         }
         return [];
      }
      
      private function __updatePrivateInfo(param1:CrazyTankSocketEvent) : void
      {
         this._self.beginChanges();
         this._self.Money = param1.pkg.readInt();
         this._self.DDTMoney = param1.pkg.readInt();
         this._self.Gold = param1.pkg.readInt();
         this._self.totemScores = param1.pkg.readInt();
         this._self.beadScore = param1.pkg.readInt();
         this._self.damageScores = param1.pkg.readInt();
         this._self.armyExploit = param1.pkg.readInt();
         this._self.matchMedal = param1.pkg.readInt();
         this._self.MilitaryRankTotalScores = param1.pkg.readInt();
         this._self.fatigueCount = param1.pkg.readByte();
         this._self.commitChanges();
      }
      
      public function get hasTempStyle() : Boolean
      {
         return this.tempStyle.length > 0;
      }
      
      public function isChangeStyleTemp(param1:int) : Boolean
      {
         return this.changedStyle.hasOwnProperty(param1) && this.changedStyle[param1] != null;
      }
      
      public function setStyleTemply(param1:Object) : void
      {
         var _loc2_:PlayerInfo = this.findPlayer(param1.ID);
         if(_loc2_)
         {
            this.storeTempStyle(_loc2_);
            _loc2_.beginChanges();
            _loc2_.Sex = param1.Sex;
            _loc2_.Hide = param1.Hide;
            _loc2_.Style = param1.Style;
            _loc2_.Colors = param1.Colors;
            _loc2_.Skin = param1.Skin;
            _loc2_.commitChanges();
         }
      }
      
      private function storeTempStyle(param1:PlayerInfo) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.Style = param1.getPrivateStyle();
         _loc2_.Hide = param1.Hide;
         _loc2_.Sex = param1.Sex;
         _loc2_.Skin = param1.Skin;
         _loc2_.Colors = param1.Colors;
         _loc2_.ID = param1.ID;
         this.tempStyle.push(_loc2_);
      }
      
      public function readAllTempStyleEvent() : void
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tempStyle.length)
         {
            _loc2_ = this.findPlayer(this.tempStyle[_loc1_].ID);
            if(_loc2_)
            {
               _loc2_.beginChanges();
               _loc2_.Sex = this.tempStyle[_loc1_].Sex;
               _loc2_.Hide = this.tempStyle[_loc1_].Hide;
               _loc2_.Style = this.tempStyle[_loc1_].Style;
               _loc2_.Colors = this.tempStyle[_loc1_].Colors;
               _loc2_.Skin = this.tempStyle[_loc1_].Skin;
               _loc2_.commitChanges();
            }
            _loc1_++;
         }
         this.tempStyle = [];
         this.changedStyle.clear();
      }
      
      private function __readTempStyle(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Object();
            _loc5_.Style = _loc2_.readUTF();
            _loc5_.Hide = _loc2_.readInt();
            _loc5_.Sex = _loc2_.readBoolean();
            _loc5_.Skin = _loc2_.readUTF();
            _loc5_.Colors = _loc2_.readUTF();
            _loc5_.ID = _loc2_.readInt();
            this.setStyleTemply(_loc5_);
            this.changedStyle.add(_loc5_.ID,_loc5_);
            _loc4_++;
         }
      }
      
      private function __updatePlayerInfo(param1:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var style:String = null;
         var arm:String = null;
         var offHand:String = null;
         var hasPet:Boolean = false;
         var place:int = 0;
         var ID:int = 0;
         var templateID:int = 0;
         var p:PetInfo = null;
         var skillCount:int = 0;
         var k:int = 0;
         var skillPlace:int = 0;
         var skillid:int = 0;
         var evt:CrazyTankSocketEvent = param1;
         if(PlayerManager.Instance.Self.isBeadUpdate)
         {
            return;
         }
         var info:PlayerInfo = this.findPlayer(evt.pkg.clientId);
         if(info)
         {
            addr732:
            §§push(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM);
         }
         else
         {
            §§goto(addr732);
         }
         §§goto(addr732);
      }
      
      public function set gamePetInfo(param1:PetInfo) : void
      {
         this._gamepetInfo = param1;
      }
      
      public function get gamePetInfo() : PetInfo
      {
         return this._gamepetInfo;
      }
      
      public function getDeputyWeaponIcon(param1:ItemTemplateInfo, param2:int = 0) : DisplayObject
      {
         var _loc3_:BagCell = null;
         if(param1)
         {
            _loc3_ = new BagCell(0,param1);
            if(param2 == 0)
            {
               return _loc3_.getContent();
            }
            if(param2 == 1)
            {
               return _loc3_.getSmallContent();
            }
         }
         return null;
      }
      
      public function __checkCodePopup(param1:CrazyTankSocketEvent) : void
      {
         var readComplete:Function = null;
         var msg:String = null;
         var checkCodeData:CheckCodeData = null;
         var ba:ByteArray = null;
         var bitmapReader:BitmapReader = null;
         var e:CrazyTankSocketEvent = param1;
         readComplete = function(param1:Event):void
         {
            checkCodeData.pic = bitmapReader.bitmap;
            CheckCodeFrame.Instance.data = checkCodeData;
         };
         var checkCodeState:int = e.pkg.readByte();
         var backType:Boolean = e.pkg.readBoolean();
         if(checkCodeState == 1)
         {
            SoundManager.instance.play("058");
         }
         else if(checkCodeState == 2)
         {
            SoundManager.instance.play("057");
         }
         if(backType)
         {
            CheckCodeFrame.Instance.time = 20;
            msg = e.pkg.readUTF();
            CheckCodeFrame.Instance.tip = msg;
            checkCodeData = new CheckCodeData();
            ba = new ByteArray();
            e.pkg.readBytes(ba,0,e.pkg.bytesAvailable);
            bitmapReader = new BitmapReader();
            bitmapReader.addEventListener(Event.COMPLETE,readComplete);
            bitmapReader.readByteArray(ba);
            CheckCodeFrame.Instance.isShowed = false;
            CheckCodeFrame.Instance.show();
            return;
         }
         CheckCodeFrame.Instance.close();
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            return;
         }
         this._self.clearBuff();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc2_.readDate();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
            this._self.addBuff(_loc11_);
            _loc4_++;
         }
         param1.stopImmediatePropagation();
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId != this._self.ID)
         {
            return;
         }
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc2_.readDate();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = new BuffInfo(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
            if(_loc6_)
            {
               this._self.addBuff(_loc11_);
            }
            else
            {
               this._self.buffInfo.remove(_loc11_.Type);
            }
            _loc4_++;
         }
         param1.stopImmediatePropagation();
      }
      
      public function findPlayerByNickName(param1:PlayerInfo, param2:String) : PlayerInfo
      {
         var _loc3_:PlayerInfo = null;
         if(param2)
         {
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID][param2] != null)
            {
               return this._tempList[this._self.ZoneID][param2] as PlayerInfo;
            }
            for each(_loc3_ in this._tempList[this._self.ZoneID])
            {
               if(_loc3_.NickName == param2)
               {
                  return _loc3_;
               }
            }
            param1.NickName = param2;
            this._tempList[this._self.ZoneID][param2] = param1;
            return param1;
         }
         return param1;
      }
      
      public function findPlayer(param1:int, param2:int = -1, param3:String = "") : PlayerInfo
      {
         var _loc4_:PlayerInfo = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:PlayerInfo = null;
         var _loc7_:PlayerInfo = null;
         if(param2 == -1 || param2 == this._self.ZoneID)
         {
            if(this._friendList[this._self.ZoneID] == null)
            {
               this._friendList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._clubPlays[this._self.ZoneID] == null)
            {
               this._clubPlays[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._myAcademyPlayers == null)
            {
               this._myAcademyPlayers = new DictionaryData();
            }
            if(param1 == this._self.ID)
            {
               return this._self;
            }
            if(this._friendList[this._self.ZoneID][param1])
            {
               return this._friendList[this._self.ZoneID][param1];
            }
            if(this._clubPlays[this._self.ZoneID][param1])
            {
               return this._clubPlays[this._self.ZoneID][param1];
            }
            if(this._tempList[this._self.ZoneID][param3])
            {
               return this._tempList[this._self.ZoneID][param3];
            }
            if(this._myAcademyPlayers[param1])
            {
               return this._myAcademyPlayers[param1];
            }
            if(this._tempList[this._self.ZoneID][param1])
            {
               if(this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][param1].NickName])
               {
                  for each(_loc4_ in this._tempList[this._self.ZoneID])
                  {
                     if(_loc4_.NickName == this._tempList[this._self.ZoneID][param1].NickName)
                     {
                        return _loc4_;
                     }
                  }
               }
               return this._tempList[this._self.ZoneID][param1];
            }
            for each(_loc5_ in this._tempList[this._self.ZoneID])
            {
               if(_loc5_.ID == param1)
               {
                  this._tempList[this._self.ZoneID][param1] = _loc5_;
                  return _loc5_;
               }
            }
            _loc6_ = new PlayerInfo();
            _loc6_.ID = param1;
            _loc6_.ZoneID = this._self.ZoneID;
            this._tempList[this._self.ZoneID][param1] = _loc6_;
            return _loc6_;
         }
         if(this._friendList[param2] && this._friendList[param2][param1])
         {
            return this._friendList[param2][param1];
         }
         if(this._clubPlays[param2] && this._clubPlays[param2][param1])
         {
            return this._clubPlays[param2][param1];
         }
         if(this._tempList[param2] && this._tempList[param2][param1])
         {
            return this._tempList[param2][param1];
         }
         _loc7_ = new PlayerInfo();
         _loc7_.ID = param1;
         _loc7_.ZoneID = param2;
         if(this._tempList[param2] == null)
         {
            this._tempList[param2] = new DictionaryData();
         }
         this._tempList[param2][param1] = _loc7_;
         return _loc7_;
      }
      
      public function hasInMailTempList(param1:int) : Boolean
      {
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      public function set mailTempList(param1:DictionaryData) : void
      {
         if(this._mailTempList == null)
         {
            this._mailTempList = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         this._mailTempList[this._self.ZoneID] = param1;
      }
      
      public function hasInFriendList(param1:int) : Boolean
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[this._self.ZoneID] = new DictionaryData();
         }
         if(this._friendList[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      public function hasInClubPlays(param1:int) : Boolean
      {
         if(this._clubPlays[this._self.ZoneID] == null)
         {
            this._clubPlays[this._self.ZoneID] = new DictionaryData();
         }
         if(this._clubPlays[this._self.ZoneID][param1])
         {
            return true;
         }
         return false;
      }
      
      private function __selfPopChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["TotalCount"])
         {
            switch(PlayerManager.Instance.Self.TotalCount)
            {
               case 1:
                  StatisticManager.Instance().startAction("gameOver1","yes");
                  break;
               case 3:
                  StatisticManager.Instance().startAction("gameOver3","yes");
                  break;
               case 5:
                  StatisticManager.Instance().startAction("gameOver5","yes");
                  break;
               case 10:
                  StatisticManager.Instance().startAction("gameOver10","yes");
            }
         }
         if(param1.changedProperties["Grade"])
         {
            TaskManager.instance.requestCanAcceptTask();
         }
      }
      
      private function __updatePet(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:PetInfo = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:PlayerInfo = this.findPlayer(_loc3_,-1);
         _loc4_.ID = _loc3_;
         _loc4_.beginChanges();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc2_.readInt();
            _loc8_ = _loc2_.readBoolean();
            if(_loc8_)
            {
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc11_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc10_);
               _loc11_.ID = _loc9_;
               _loc11_.Place = _loc7_;
               _loc11_.Name = _loc2_.readUTF();
               _loc11_.UserID = _loc2_.readInt();
               _loc11_.Attack = _loc2_.readInt();
               _loc11_.Defence = _loc2_.readInt();
               _loc11_.Luck = _loc2_.readInt();
               _loc11_.Agility = _loc2_.readInt();
               _loc11_.Blood = _loc2_.readInt();
               _loc11_.Bless = _loc2_.readInt();
               _loc11_.OrderNumber = _loc2_.readInt();
               _loc11_.MagicLevel = _loc2_.readInt();
               _loc11_.Level = _loc2_.readInt();
               _loc11_.GP = _loc2_.readInt();
               _loc11_.MaxGP = _loc2_.readInt();
               _loc11_.clearSkills();
               _loc12_ = _loc2_.readInt();
               _loc13_ = 0;
               while(_loc13_ < _loc12_)
               {
                  _loc14_ = _loc2_.readInt();
                  _loc15_ = _loc2_.readInt();
                  _loc11_.addSkill(_loc14_,_loc15_);
                  _loc13_++;
               }
               _loc4_.pets.add(_loc11_.Place,_loc11_);
               PetInfoManager.instance.checkPetCanMagic(_loc11_);
            }
            else
            {
               _loc4_.pets.remove(_loc7_);
            }
            _loc6_++;
         }
         _loc4_.commitChanges();
      }
      
      public function set playerstate(param1:String) : void
      {
         this._playerState = param1;
         dispatchEvent(new Event(CHAGE_STATE));
      }
      
      public function get playerstate() : String
      {
         return this._playerState;
      }
      
      public function changeState(param1:String) : void
      {
         this.playerstate = param1;
      }
      
      private function __updateOneKeyFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.uesedFinishTime = _loc2_.readInt();
      }
      
      private function __updateFatigue(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.beginChanges();
         this._self.Fatigue = _loc2_.readInt();
         this._self.FatigueupDateTimer = _loc2_.readDate();
         this._self.NeedFatigue = _loc2_.readInt();
         this._self.commitChanges();
         dispatchEvent(new Event(UPDATE_FATIUE));
      }
      
      private function __updateMission(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.beginChanges();
         this._self.PveInfoID = _loc2_.readInt();
         this._self.HardLevel = _loc2_.readInt();
         this._self.MissionOrder = _loc2_.readInt();
         this._self.MissionID = _loc2_.readInt();
         this._self.NeedFatigue = _loc2_.readInt();
         this._self.commitChanges();
      }
      
      private function __buyFatigueHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case 0:
               _loc4_ = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo1");
               break;
            case 1:
               _loc4_ = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo2");
               break;
            case 2:
               _loc4_ = LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo3");
               break;
            case 3:
               LeavePageManager.showFillFrame();
         }
         if(_loc4_)
         {
            MessageTipManager.getInstance().show(_loc4_);
         }
         dispatchEvent(new Event(BUY_FATIUE));
      }
      
      private function __updateConsotionStatus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         PlayerManager.Instance.Self.consortionStatus = _loc2_;
      }
      
      private function __updateExperience(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         PlayerManager.Instance.Self.consortiaInfo.Experience = _loc2_;
      }
      
      public function checkExpedition() : Boolean
      {
         return this._self.expeditionCurrent.IsOnExpedition;
      }
      
      public function geticonShine(param1:String) : Boolean
      {
         if(this._iconShineDic[param1] == null)
         {
            this._iconShineDic[param1] = true;
         }
         return this._iconShineDic[param1];
      }
      
      public function setIconShine(param1:String, param2:Boolean) : void
      {
         this._iconShineDic[param1] = param2;
      }
      
      public function setupInvitedFriendList(param1:InvitedFriendListAnalyzer) : void
      {
         this.invitedFriendList = param1.friendlist;
         this._invitedAwardStep = param1.invitedAwardStep;
         this._inviterID = param1.InviterID;
      }
      
      public function set invitedFriendList(param1:DictionaryData) : void
      {
         this._invitedFriendList[this._self.ZoneID] = param1;
      }
      
      public function get invitedAwardStep() : int
      {
         return this._invitedAwardStep;
      }
      
      public function get invitedFriendList() : DictionaryData
      {
         if(this._invitedFriendList[this._self.ZoneID] == null)
         {
            this._invitedFriendList[this._self.ZoneID] = new DictionaryData();
         }
         return this._invitedFriendList[this._self.ZoneID];
      }
      
      public function get inviter() : InvitedFirendListPlayer
      {
         if(!this._inviterID)
         {
            return null;
         }
         return this.invitedFriendList[this._inviterID];
      }
      
      public function get CloseFriendsIMList() : Array
      {
         var _loc3_:InvitedFirendListPlayer = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.invitedFriendList)
         {
            if(_loc3_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc3_);
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc1_ = _loc1_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         _loc2_ = _loc2_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         return _loc1_.concat(_loc2_);
      }
      
      public function get CloseFriendsIMListOnline() : Array
      {
         var _loc2_:InvitedFirendListPlayer = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.invitedFriendList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
      }
      
      public function get CloseFriendsManagerList() : Array
      {
         var _loc3_:InvitedFirendListPlayer = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.invitedFriendList)
         {
            if(!(_loc3_.Grade < 8 || _loc3_.UserID == this._inviterID))
            {
               if(_loc3_.playerState.StateID != PlayerState.OFFLINE)
               {
                  _loc1_.push(_loc3_);
               }
               else
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         _loc1_ = _loc1_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         _loc2_ = _loc2_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         return _loc1_.concat(_loc2_);
      }
      
      public function get CloseFriendsLevelRewardList() : Array
      {
         var _loc3_:InvitedFirendListPlayer = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.invitedFriendList)
         {
            if(!(_loc3_.Grade < 8 || _loc3_.UserID == this._inviterID))
            {
               if(_loc3_.awardStep <= 5)
               {
                  if(_loc3_.playerState.StateID != PlayerState.OFFLINE)
                  {
                     _loc1_.push(_loc3_);
                  }
                  else
                  {
                     _loc2_.push(_loc3_);
                  }
               }
            }
         }
         _loc1_ = _loc1_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         _loc2_ = _loc2_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         return _loc1_.concat(_loc2_);
      }
      
      private function __closeFriendReward(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Number = _loc2_.readLong();
         if(!_loc3_)
         {
            return;
         }
         if(_loc4_ == 0)
         {
            this._invitedAwardStep = _loc5_;
         }
         else if(_loc4_ == 1)
         {
            (this.invitedFriendList[_loc6_] as InvitedFirendListPlayer).awardStep = _loc5_;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __closeFriendChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Number = _loc2_.readLong();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:InvitedFirendListPlayer = this.invitedFriendList[_loc4_] as InvitedFirendListPlayer;
         if(_loc3_ == 1)
         {
            _loc6_.Grade = _loc5_;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __invitedFriendAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:InvitedFirendListPlayer = new InvitedFirendListPlayer();
         _loc3_.UserID = _loc2_.readLong();
         _loc3_.awardStep = _loc2_.readInt();
         _loc3_.NickName = _loc2_.readUTF();
         _loc3_.IsVIP = _loc2_.readBoolean();
         _loc3_.VIPLevel = _loc2_.readInt();
         _loc3_.UserName = _loc2_.readUTF();
         _loc3_.Style = _loc2_.readUTF();
         _loc3_.SexByInt = _loc2_.readInt();
         _loc3_.Colors = _loc2_.readUTF();
         _loc3_.Grade = _loc2_.readInt();
         _loc3_.Hide = _loc2_.readInt();
         _loc3_.ConsortiaName = _loc2_.readUTF();
         _loc3_.TotalCount = _loc2_.readInt();
         _loc3_.EscapeCount = _loc2_.readInt();
         _loc3_.WinCount = _loc2_.readInt();
         _loc3_.Offer = _loc2_.readInt();
         _loc3_.Repute = _loc2_.readInt();
         _loc3_.playerState = new PlayerState(_loc2_.readInt());
         _loc3_.Nimbus = _loc2_.readInt();
         _loc3_.DutyName = _loc2_.readUTF();
         _loc3_.AchievementPoint = _loc2_.readInt();
         _loc2_.readUTF();
         _loc3_.FightPower = _loc2_.readInt();
         _loc3_.apprenticeshipState = _loc2_.readInt();
         this.invitedFriendList[_loc3_.UserID] = _loc3_;
      }
   }
}
