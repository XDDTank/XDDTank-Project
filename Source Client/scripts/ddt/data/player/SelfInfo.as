package ddt.data.player
{
   import SingleDungeon.expedition.ExpeditionHistory;
   import SingleDungeon.expedition.ExpeditionInfo;
   import bagAndInfo.info.PlayerViewState;
   import com.hurlant.util.Base64;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.EquipType;
   import ddt.data.VipConfigInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.events.BagEvent;
   import ddt.events.PlayerEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PVEMapPermissionManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.utils.GoodUtils;
   import ddt.view.buff.BuffControl;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import ddt.view.goods.AddPricePanel;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.data.ComposeCurrentInfo;
   import vip.VipController;
   
   public class SelfInfo extends PlayerInfo
   {
      
      public static const PET:String = "Pets";
      
      private static const buffScanTime:int = 60;
       
      
      private var timer:Timer;
      
      private var _count:int;
      
      private var saveTimer:int;
      
      public var CivilPlayerList:Array;
      
      private var _timer:Timer;
      
      private var _questionOne:String;
      
      private var _questionTwo:String;
      
      private var _leftTimes:int = 5;
      
      public var IsNovice:Boolean;
      
      public var rid:String;
      
      public var _hasPopupLeagueNotice:Boolean;
      
      public var baiduEnterCode:String;
      
      private var _marryInfoID:int;
      
      private var _civilIntroduction:String;
      
      private var _isPublishEquit:Boolean;
      
      private var _bagPwdState:Boolean;
      
      private var _bagLocked:Boolean;
      
      private var _shouldPassword:Boolean;
      
      public var IsBanChat:Boolean;
      
      public var _props:DictionaryData;
      
      private var _isFirst:int;
      
      private var FirstLoaded:Boolean = false;
      
      private var _questList:Array;
      
      public var PropBag:BagInfo;
      
      public var FightBag:BagInfo;
      
      public var TempBag:BagInfo;
      
      public var ConsortiaBag:BagInfo;
      
      public var CaddyBag:BagInfo;
      
      public var farmBag:BagInfo;
      
      public var vegetableBag:BagInfo;
      
      private var _overtimeList:Array;
      
      private var sendedGrade:Array;
      
      public var StoreBag:BagInfo;
      
      private var _weaklessGuildProgress:ByteArray;
      
      public var _canTakeVipReward:Boolean = false;
      
      public var _openVipType:Boolean;
      
      private var _VIPExpireDay:Object;
      
      public var LastDate:Object;
      
      public var isOldPlayerHasValidEquitAtLogin:Boolean;
      
      private var _vipNextLevelDaysNeeded:int;
      
      public var systemDate:Object;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      private var _gold:Number;
      
      private var _money:Number = 0;
      
      private var _ddtMoney:Number = 0;
      
      private var _armyExploit:int;
      
      private var _matchMedal:int;
      
      private var _uesedFinishTime:int;
      
      private var _lastComposeDic:DictionaryData;
      
      private var _bagCellUpdateIndex:int;
      
      private var _bagCellUpdateTime:Date;
      
      private var _notFinishTime:int;
      
      private var _isFarmHelper:Boolean;
      
      private var _composeSkills:DictionaryData;
      
      private var _fightVipStartTime:Date;
      
      private var _fightVipValidDate:int;
      
      private var _isUseFightByVip:Boolean;
      
      private var _pveInfoID:int;
      
      private var _hardLevel:int;
      
      private var _missionOrder:int;
      
      private var _missionID:int;
      
      private var _expeditionCurrent:ExpeditionInfo;
      
      private var _expeditionNumAll:int;
      
      private var _expeditionNumCur:int;
      
      private var _fbDone:Array;
      
      private var _getEquipInfo:InventoryItemInfo;
      
      private var _bagVibleType:int = 0;
      
      private var _moneyOfCharge:Number;
      
      private var _isGetNewHandPack:Boolean;
      
      private var _canTakeVIPPack:Boolean;
      
      private var _canTakeVIPYearPack:Boolean;
      
      private var _canTakeLevel3366Pack:Boolean;
      
      private var _awardLog:int;
      
      private var _isAward:Boolean = false;
      
      private var _isFristShow:Boolean = false;
      
      public function SelfInfo()
      {
         this.CivilPlayerList = new Array();
         this.sendedGrade = [];
         this._expeditionCurrent = new ExpeditionInfo();
         super();
         this.PropBag = new BagInfo(BagInfo.PROPBAG,48);
         this.FightBag = new BagInfo(BagInfo.FIGHTBAG,48);
         this.TempBag = new BagInfo(BagInfo.TEMPBAG,48);
         this.ConsortiaBag = new BagInfo(BagInfo.CONSORTIA,100);
         this.StoreBag = new BagInfo(BagInfo.STOREBAG,11);
         this.CaddyBag = new BagInfo(BagInfo.CADDYBAG,99);
         this.farmBag = new BagInfo(BagInfo.FARM,100);
         this.vegetableBag = new BagInfo(BagInfo.VEGETABLE,100);
         _isSelf = true;
      }
      
      public function getStratTime(param1:int) : void
      {
         if(this.timer != null && param1 != 0)
         {
            return;
         }
         this._count = param1;
         if(this._count != 0)
         {
            this.timer = new Timer(1000,param1);
            this.timer.addEventListener(TimerEvent.TIMER,this.__startTimer);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this.timer.start();
         }
         else if(this._count == 0 && this.timer != null)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.__startTimer);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this.timer.stop();
            this.timer = null;
            this._count = 0;
         }
         else if(this._count == 0 && this.timer == null)
         {
            this.timer = new Timer(1000,param1);
            this.timer.addEventListener(TimerEvent.TIMER,this.__startTimer);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this.timer.start();
         }
      }
      
      private function __startTimer(param1:TimerEvent) : void
      {
         this._count -= 1;
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.__startTimer);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this.timer = null;
         SocketManager.Instance.out.sendOpenBagCell(0,this.bagCellUpdateIndex,this.bagCellUpdateIndex);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      override public function set NickName(param1:String) : void
      {
         super.NickName = param1;
      }
      
      public function set MarryInfoID(param1:int) : void
      {
         if(this._marryInfoID == param1)
         {
            return;
         }
         this._marryInfoID = param1;
         onPropertiesChanged("MarryInfoID");
      }
      
      public function get MarryInfoID() : int
      {
         return this._marryInfoID;
      }
      
      public function set Introduction(param1:String) : void
      {
         if(this._civilIntroduction == param1)
         {
            return;
         }
         this._civilIntroduction = param1;
         onPropertiesChanged("Introduction");
      }
      
      public function get Introduction() : String
      {
         if(this._civilIntroduction == null)
         {
            this._civilIntroduction = "";
         }
         return this._civilIntroduction;
      }
      
      public function set IsPublishEquit(param1:Boolean) : void
      {
         if(this._isPublishEquit == param1)
         {
            return;
         }
         this._isPublishEquit = param1;
         onPropertiesChanged("IsPublishEquit");
      }
      
      public function get IsPublishEquit() : Boolean
      {
         return this._isPublishEquit;
      }
      
      public function set bagPwdState(param1:Boolean) : void
      {
         this._bagPwdState = param1;
      }
      
      public function get bagPwdState() : Boolean
      {
         return this._bagPwdState;
      }
      
      public function set bagLocked(param1:Boolean) : void
      {
         if(this._bagLocked == param1)
         {
            return;
         }
         this._bagLocked = param1;
         onPropertiesChanged("bagLocked");
      }
      
      public function get bagLocked() : Boolean
      {
         if(!this._bagPwdState)
         {
            return false;
         }
         return this._bagLocked;
      }
      
      public function get shouldPassword() : Boolean
      {
         return this._shouldPassword;
      }
      
      public function set shouldPassword(param1:Boolean) : void
      {
         this._shouldPassword = param1;
      }
      
      public function onReceiveTypes(param1:String) : void
      {
         dispatchEvent(new BagEvent(param1,new Dictionary()));
      }
      
      public function resetProps() : void
      {
         this._props = new DictionaryData();
      }
      
      public function findOvertimeItems(param1:Number = 0) : Array
      {
         return this.getOverdueItems();
      }
      
      public function getOverdueItems() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = GoodUtils.getOverdueItemsFrom(this.PropBag.items);
         var _loc4_:Array = GoodUtils.getOverdueItemsFrom(this.FightBag.items);
         var _loc5_:Array = GoodUtils.getOverdueItemsFrom(Bag.items);
         var _loc6_:Array = GoodUtils.getOverdueItemsFrom(this.ConsortiaBag.items);
         _loc1_ = _loc1_.concat(_loc3_[0],_loc4_[0],[],_loc5_[0]);
         _loc2_ = _loc2_.concat(_loc3_[1],_loc4_[1],[],_loc5_[1]);
         return [_loc1_,_loc2_];
      }
      
      public function set IsFirst(param1:int) : void
      {
         this._isFirst = param1;
         if(this._isFirst == 1)
         {
            this.initIsFirst();
         }
      }
      
      public function get IsFirst() : int
      {
         return this._isFirst;
      }
      
      private function initIsFirst() : void
      {
         SharedManager.Instance.isWorldBossBuyBuff = false;
         SharedManager.Instance.coolDownFightRobot = false;
         SharedManager.Instance.isRefreshPet = false;
         SharedManager.Instance.isResurrect = false;
         SharedManager.Instance.isReFight = false;
         SharedManager.Instance.save();
      }
      
      public function findItemCount(param1:int) : int
      {
         return Bag.getItemCountByTemplateId(param1);
      }
      
      public function loadPlayerItem() : void
      {
      }
      
      public function loadRelatedPlayersInfo() : void
      {
         if(this.FirstLoaded)
         {
            return;
         }
         this.FirstLoaded = true;
      }
      
      private function loadBodyThingComplete(param1:DictionaryData, param2:DictionaryData) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BuffInfo = null;
         for each(_loc3_ in param1)
         {
            Bag.addItem(_loc3_);
         }
         for each(_loc4_ in param2)
         {
            super.addBuff(_loc4_);
         }
      }
      
      public function getPveMapPermission(param1:int, param2:int) : Boolean
      {
         return PVEMapPermissionManager.Instance.getPermission(param1,param2,PvePermission);
      }
      
      public function canEquip(param1:InventoryItemInfo) : Boolean
      {
         if(!EquipType.canEquip(param1))
         {
            if(!isNaN(param1.CategoryID))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.this"));
            }
         }
         else if(param1.getRemainDate() <= 0)
         {
            AddPricePanel.Instance.setInfo(param1,true);
            AddPricePanel.Instance.show();
         }
         else
         {
            if(param1.CategoryID == EquipType.HEALSTONE)
            {
               if(Grade >= int(param1.Property1))
               {
                  return true;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",param1.Property1));
               return false;
            }
            if(PlayerManager.Instance.playerstate != PlayerViewState.FASHION && (EquipType.isFashionViewGoods(param1) || EquipType.isRingEquipment(param1)))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.dragGoods.bad"));
            }
            else
            {
               if(!(PlayerManager.Instance.playerstate != PlayerViewState.EQUIP && !EquipType.isFashionViewGoods(param1) && !EquipType.isRingEquipment(param1)))
               {
                  return true;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.dragGoods.bad"));
            }
         }
         return false;
      }
      
      override public function addBuff(param1:BuffInfo) : void
      {
         super.addBuff(param1);
      }
      
      private function __refreshSelfInfo(param1:TimerEvent) : void
      {
         this.refreshBuff();
      }
      
      private function refreshBuff() : void
      {
         var _loc1_:BuffInfo = null;
         var _loc2_:ChatData = null;
         for each(_loc1_ in _buffInfo)
         {
            if(!BuffControl.isPayBuff(_loc1_))
            {
               if(_loc1_.ValidDate - Math.floor((TimeManager.Instance.Now().time - _loc1_.BeginData.time) / (1000 * 60)) - 1 == buffScanTime)
               {
                  _loc2_ = new ChatData();
                  _loc2_.channel = ChatInputView.SYS_TIP;
                  _loc2_.msg = LanguageMgr.GetTranslation("tank.view.buffInfo.outDate",_loc1_.buffName,buffScanTime);
                  ChatManager.Instance.chat(_loc2_);
               }
            }
         }
      }
      
      public function achievedQuest(param1:int) : Boolean
      {
         if(this._questList && this._questList[param1])
         {
            return true;
         }
         return false;
      }
      
      public function unlockAllBag() : void
      {
         Bag.unLockAll();
         this.PropBag.unLockAll();
      }
      
      public function getBag(param1:int) : BagInfo
      {
         switch(param1)
         {
            case BagInfo.EQUIPBAG:
               return Bag;
            case BagInfo.PROPBAG:
               return this.PropBag;
            case BagInfo.FIGHTBAG:
               return this.FightBag;
            case BagInfo.TEMPBAG:
               return this.TempBag;
            case BagInfo.CONSORTIA:
               return this.ConsortiaBag;
            case BagInfo.STOREBAG:
               return this.StoreBag;
            case BagInfo.CADDYBAG:
               return this.CaddyBag;
            case BagInfo.FARM:
               return this.farmBag;
            case BagInfo.VEGETABLE:
               return this.vegetableBag;
            case BagInfo.BEADBAG:
               return BeadBag;
            default:
               return null;
         }
      }
      
      public function get questionOne() : String
      {
         return this._questionOne;
      }
      
      public function set questionOne(param1:String) : void
      {
         this._questionOne = param1;
      }
      
      public function get questionTwo() : String
      {
         return this._questionTwo;
      }
      
      public function set questionTwo(param1:String) : void
      {
         this._questionTwo = param1;
      }
      
      public function get leftTimes() : int
      {
         return this._leftTimes;
      }
      
      public function set leftTimes(param1:int) : void
      {
         this._leftTimes = param1;
      }
      
      public function get OvertimeListByBody() : Array
      {
         return Bag.findOvertimeItemsByBody();
      }
      
      public function sendOverTimeListByBody() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc1_:Array = Bag.findOvertimeItemsByBodyII();
         for each(_loc2_ in _loc1_)
         {
            SocketManager.Instance.out.sendItemOverDue(_loc2_.BagType,_loc2_.Place);
         }
      }
      
      override public function set Grade(param1:int) : void
      {
         super.Grade = param1;
         if(IsUpGrade && PathManager.solveExternalInterfaceEnabel() && this.sendedGrade.indexOf(param1) == -1)
         {
            ExternalInterfaceManager.sendToAgent(2,ID,NickName,ServerManager.Instance.zoneName,Grade);
            this.sendedGrade.push(Grade);
         }
      }
      
      public function get weaklessGuildProgress() : ByteArray
      {
         return this._weaklessGuildProgress;
      }
      
      public function set weaklessGuildProgress(param1:ByteArray) : void
      {
         this._weaklessGuildProgress = param1;
      }
      
      public function set weaklessGuildProgressStr(param1:String) : void
      {
         this.weaklessGuildProgress = Base64.decodeToByteArray(param1);
      }
      
      public function get canTakeVipReward() : Boolean
      {
         return this._canTakeVipReward;
      }
      
      public function set canTakeVipReward(param1:Boolean) : void
      {
         if(this._canTakeVipReward == param1)
         {
            return;
         }
         this._canTakeVipReward = param1;
         onPropertiesChanged("canTakeVipReward");
      }
      
      public function set openVipType(param1:Boolean) : void
      {
         this._openVipType = param1;
      }
      
      public function get openVipType() : Boolean
      {
         return this._openVipType;
      }
      
      public function get VIPExpireDay() : Object
      {
         return this._VIPExpireDay;
      }
      
      public function set VIPExpireDay(param1:Object) : void
      {
         if(this._VIPExpireDay == param1)
         {
            return;
         }
         this._VIPExpireDay = param1;
         onPropertiesChanged("VipExpireDay");
      }
      
      public function set VIPNextLevelDaysNeeded(param1:int) : void
      {
         if(this._vipNextLevelDaysNeeded == param1)
         {
            return;
         }
         this._vipNextLevelDaysNeeded = param1;
         onPropertiesChanged("VIPNextLevelDaysNeeded");
      }
      
      public function get VIPNextLevelDaysNeeded() : int
      {
         return this._vipNextLevelDaysNeeded;
      }
      
      public function get VIPLeftDays() : int
      {
         return int(this.VipLeftHours / 24);
      }
      
      public function get VipLeftHours() : int
      {
         return int((this.VIPExpireDay.valueOf() - this.systemDate.valueOf()) / 3600000);
      }
      
      public function get isSameDay() : Boolean
      {
         if(this.LastDate.fullYear == this.systemDate.fullYear && this.LastDate.month == this.systemDate.month && this.LastDate.date == this.systemDate.date)
         {
            return true;
         }
         return false;
      }
      
      public function set consortiaInfo(param1:ConsortiaInfo) : void
      {
         if(this._consortiaInfo == param1)
         {
            return;
         }
         this.consortiaInfo.beginChanges();
         ObjectUtils.copyProperties(this.consortiaInfo,param1);
         this.consortiaInfo.commitChanges();
         onPropertiesChanged("consortiaInfo");
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         if(this._consortiaInfo == null)
         {
            this._consortiaInfo = new ConsortiaInfo();
         }
         return this._consortiaInfo;
      }
      
      public function get Gold() : Number
      {
         return this._gold;
      }
      
      public function set Gold(param1:Number) : void
      {
         if(this._gold == param1)
         {
            return;
         }
         this._gold = param1;
         onPropertiesChanged(PlayerInfo.GOLD);
      }
      
      public function get totalMoney() : Number
      {
         return this.Money + this.DDTMoney;
      }
      
      public function get Money() : Number
      {
         return this._money;
      }
      
      public function set Money(param1:Number) : void
      {
         if(this._money == param1)
         {
            return;
         }
         this._money = param1;
         onPropertiesChanged(PlayerInfo.MONEY);
      }
      
      public function get DDTMoney() : Number
      {
         return this._ddtMoney;
      }
      
      public function set DDTMoney(param1:Number) : void
      {
         if(this._ddtMoney == param1)
         {
            return;
         }
         this._ddtMoney = param1;
         onPropertiesChanged(PlayerInfo.DDT_MONEY);
      }
      
      public function get armyExploit() : int
      {
         return this._armyExploit;
      }
      
      public function set armyExploit(param1:int) : void
      {
         this._armyExploit = param1;
      }
      
      public function get matchMedal() : int
      {
         return this._matchMedal;
      }
      
      public function set matchMedal(param1:int) : void
      {
         this._matchMedal = param1;
      }
      
      public function getMoneyByType(param1:int) : int
      {
         switch(param1)
         {
            case Price.MONEY:
               return this.Money;
            case Price.DDT_MONEY:
               return this.DDTMoney;
            case Price.GOLD:
               return this.Gold;
            case Price.ARMY_EXPLOIT:
               return this.armyExploit;
            case Price.MATCH_MEDAL:
               return this.matchMedal;
            default:
               return 0;
         }
      }
      
      public function set uesedFinishTime(param1:int) : void
      {
         this._uesedFinishTime = param1;
      }
      
      public function get uesedFinishTime() : int
      {
         return this._uesedFinishTime;
      }
      
      public function get lastComposeDic() : DictionaryData
      {
         return this._lastComposeDic;
      }
      
      public function set lastComposeDic(param1:DictionaryData) : void
      {
         var _loc2_:ComposeCurrentInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         this._lastComposeDic = param1;
         for each(_loc2_ in this._lastComposeDic)
         {
            if(_loc2_.templeteID != 0)
            {
               _loc3_ = this.systemDate.getTime();
               _loc4_ = _loc2_.lastComposeTime.getTime() + _loc2_.composeNeedTime * 1000;
               _loc2_.remainTime = (_loc4_ - _loc3_) / 1000;
            }
         }
      }
      
      public function getCurComposeInfoByType(param1:int) : ComposeCurrentInfo
      {
         var _loc2_:ComposeCurrentInfo = null;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:EquipmentTemplateInfo = null;
         for each(_loc2_ in this._lastComposeDic)
         {
            _loc3_ = ItemManager.Instance.getTemplateById(_loc2_.templeteID);
            if(_loc3_.CategoryID == EquipType.EQUIP)
            {
               _loc4_ = ItemManager.Instance.getEquipTemplateById(_loc3_.TemplateID);
               if(param1 == 400)
               {
                  if(_loc4_.TemplateType > 6)
                  {
                     return _loc2_;
                  }
               }
               else if(_loc4_.TemplateType <= 6 && _loc3_.CategoryID == param1)
               {
                  return _loc2_;
               }
            }
            else if(_loc3_.CategoryID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set bagCellUpdateIndex(param1:int) : void
      {
         this._bagCellUpdateIndex = param1;
      }
      
      public function get bagCellUpdateIndex() : int
      {
         return this._bagCellUpdateIndex;
      }
      
      public function set bagCellUpdateTime(param1:Date) : void
      {
         this._bagCellUpdateTime = param1;
      }
      
      public function get bagCellUpdateTime() : Date
      {
         return this._bagCellUpdateTime;
      }
      
      public function set notFinishTime(param1:int) : void
      {
         this._notFinishTime = param1;
      }
      
      public function get notFinishTime() : int
      {
         return this._notFinishTime;
      }
      
      public function get isFarmHelper() : Boolean
      {
         return this._isFarmHelper;
      }
      
      public function set isFarmHelper(param1:Boolean) : void
      {
         this._isFarmHelper = param1;
      }
      
      public function get composeSkills() : DictionaryData
      {
         return this._composeSkills;
      }
      
      public function set composeSkills(param1:DictionaryData) : void
      {
         this._composeSkills = param1;
      }
      
      override public function get pets() : DictionaryData
      {
         if(_pets == null)
         {
            _pets = new DictionaryData();
            _pets.addEventListener("add",this.__petsDataChanged);
            _pets.addEventListener("update",this.__petsDataChanged);
            _pets.addEventListener("remove",this.__petsDataChanged);
         }
         return _pets;
      }
      
      protected function __petsDataChanged(param1:DictionaryEvent) : void
      {
         onPropertiesChanged(PET);
      }
      
      public function get fightVipStartTime() : Date
      {
         return this._fightVipStartTime;
      }
      
      public function set fightVipStartTime(param1:Date) : void
      {
         this._fightVipStartTime = param1;
      }
      
      public function get fightVipValidDate() : int
      {
         return this._fightVipValidDate;
      }
      
      public function set fightVipValidDate(param1:int) : void
      {
         this._fightVipValidDate = param1;
      }
      
      public function get isUseFightByVip() : Boolean
      {
         if(VipController.instance.getPrivilegeByIndex(9))
         {
            return true;
         }
         return false;
      }
      
      public function get isRunQuicklyByVip() : Boolean
      {
         if(VipController.instance.getPrivilegeByIndex(8))
         {
            return true;
         }
         return false;
      }
      
      public function get PveInfoID() : int
      {
         return this._pveInfoID;
      }
      
      public function set PveInfoID(param1:int) : void
      {
         this._pveInfoID = param1;
      }
      
      public function get HardLevel() : int
      {
         return this._hardLevel;
      }
      
      public function set HardLevel(param1:int) : void
      {
         this._hardLevel = param1;
      }
      
      public function get MissionOrder() : int
      {
         return this._missionOrder;
      }
      
      public function set MissionOrder(param1:int) : void
      {
         this._missionOrder = param1;
      }
      
      public function get MissionID() : int
      {
         return this._missionID;
      }
      
      public function set MissionID(param1:int) : void
      {
         this._missionID = param1;
      }
      
      public function get expeditionCurrent() : ExpeditionInfo
      {
         return this._expeditionCurrent;
      }
      
      public function set expeditionCurrent(param1:ExpeditionInfo) : void
      {
         this._expeditionCurrent = param1;
      }
      
      public function get expeditionNumAll() : int
      {
         return this._expeditionNumAll;
      }
      
      public function set expeditionNumAll(param1:int) : void
      {
         this._expeditionNumAll = param1;
      }
      
      public function get expeditionNumCur() : int
      {
         return this._expeditionNumCur;
      }
      
      public function set expeditionNumCur(param1:int) : void
      {
         this._expeditionNumCur = param1;
      }
      
      public function get expeditionNumLast() : int
      {
         return this._expeditionNumAll - this._expeditionNumCur + 1;
      }
      
      public function getfbDoneByScenceID(param1:int) : Boolean
      {
         return ExpeditionHistory.instance.get(param1);
      }
      
      public function set fbDoneByString(param1:String) : void
      {
         ExpeditionHistory.instance.sets(param1);
      }
      
      public function set EquipInfo(param1:InventoryItemInfo) : void
      {
         this._getEquipInfo = param1;
      }
      
      public function get EquipInfo() : InventoryItemInfo
      {
         return this._getEquipInfo;
      }
      
      public function set bagVibleType(param1:int) : void
      {
         this._bagVibleType = param1;
      }
      
      public function get bagVibleType() : int
      {
         return this._bagVibleType;
      }
      
      public function getStrengthCompleteCount(param1:int) : int
      {
         var _loc6_:InventoryItemInfo = null;
         var _loc2_:uint = 6;
         var _loc3_:int = 0;
         var _loc4_:DictionaryData = new DictionaryData();
         var _loc5_:int = 1;
         while(_loc5_ <= _loc2_)
         {
            _loc4_ = this.Bag.findItemsByTemplateType(_loc5_);
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.StrengthenLevel >= param1)
               {
                  _loc3_++;
                  break;
               }
            }
            _loc5_++;
         }
         return _loc3_ < _loc2_ ? int(0) : int(param1);
      }
      
      public function getEmbedRuneCount(param1:int) : int
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc2_:int = 0;
         for each(_loc3_ in Bag.items)
         {
            _loc4_ = 1;
            while(_loc4_ <= 4)
            {
               if(_loc3_["Hole" + _loc4_])
               {
                  _loc5_ = ItemManager.Instance.getTemplateById(_loc3_["Hole" + _loc4_]);
                  if(_loc5_ && int(_loc5_.Property1) >= param1)
                  {
                     _loc2_++;
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      override public function set Fatigue(param1:int) : void
      {
         super.Fatigue = param1;
         LoadInterfaceManager.setFatigue(String(param1));
      }
      
      public function get moneyOfCharge() : Number
      {
         return this._moneyOfCharge;
      }
      
      public function set moneyOfCharge(param1:Number) : void
      {
         this._moneyOfCharge = param1;
         dispatchEvent(new PlayerEvent(PlayerEvent.MONEY_CHARGE));
      }
      
      public function get isGetNewHandPack() : Boolean
      {
         return this._isGetNewHandPack;
      }
      
      public function set isGetNewHandPack(param1:Boolean) : void
      {
         this._isGetNewHandPack = param1;
         onPropertiesChanged("isGetNewHandPack");
      }
      
      public function get canTakeVIPPack() : Boolean
      {
         return this._canTakeVIPPack;
      }
      
      public function set canTakeVIPPack(param1:Boolean) : void
      {
         this._canTakeVIPPack = param1;
      }
      
      public function get canTakeVIPYearPack() : Boolean
      {
         return this._canTakeVIPYearPack;
      }
      
      public function set canTakeVIPYearPack(param1:Boolean) : void
      {
         this._canTakeVIPYearPack = param1;
      }
      
      public function get canTakeLevel3366Pack() : Boolean
      {
         return this._canTakeLevel3366Pack;
      }
      
      public function set canTakeLevel3366Pack(param1:Boolean) : void
      {
         this._canTakeLevel3366Pack = param1;
      }
      
      public function getBuyFatigueMoney() : int
      {
         var _loc2_:VipConfigInfo = null;
         var _loc3_:int = 0;
         var _loc1_:Array = ServerConfigManager.instance.getBuyFatigueCostMoney(IsVIP);
         if(IsVIP)
         {
            _loc2_ = VipPrivilegeConfigManager.Instance.getById(4);
            _loc3_ = _loc2_["Level" + VIPLevel];
            if(fatigueCount < _loc3_)
            {
               return _loc1_[fatigueCount];
            }
            return 0;
         }
         if(fatigueCount < 1)
         {
            return _loc1_[0];
         }
         return 0;
      }
      
      public function get getRestBuyFatigueCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:VipConfigInfo = null;
         var _loc3_:int = 0;
         if(IsVIP)
         {
            _loc2_ = VipPrivilegeConfigManager.Instance.getById(4);
            _loc3_ = _loc2_["Level" + VIPLevel];
            _loc1_ = _loc3_ - fatigueCount;
         }
         else
         {
            _loc1_ = 1 - fatigueCount;
         }
         return _loc1_ < 0 ? int(0) : int(_loc1_);
      }
      
      public function get awardLog() : int
      {
         return this._awardLog;
      }
      
      public function set awardLog(param1:int) : void
      {
         this._awardLog = param1;
      }
      
      public function get isAward() : Boolean
      {
         return this._isAward;
      }
      
      public function set isAward(param1:Boolean) : void
      {
         this._isAward = param1;
      }
      
      public function get isFristShow() : Boolean
      {
         return this._isFristShow;
      }
      
      public function set isFristShow(param1:Boolean) : void
      {
         this._isFristShow = param1;
      }
   }
}

class DateGeter
{
   
   public static var date:Date;
    
   
   function DateGeter()
   {
      super();
   }
}
