package ddt.data.goods
{
   import ddt.events.GoodsEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import road7th.utils.DateUtils;
   
   public class InventoryItemInfo extends ItemTemplateInfo
   {
      
      private static var _isTimerStarted:Boolean = false;
      
      private static var _temp_Instances:Array = new Array();
       
      
      private var _checkTimeOutTimer:Timer;
      
      private var _checkColorValidTimer:Timer;
      
      public var ItemID:Number;
      
      public var UserID:Number;
      
      public var IsBinds:Boolean;
      
      public var isDeleted:Boolean;
      
      public var BagType:int;
      
      public var type:int;
      
      public var isInvalid:Boolean;
      
      public var lock:Boolean = false;
      
      public var Color:String;
      
      public var Skin:String;
      
      public var isMoveSpace:Boolean = true;
      
      private var _isUsed:Boolean;
      
      public var BeginDate:String;
      
      protected var _ValidDate:Number;
      
      private var _DiscolorValidDate:String;
      
      private var atLeastOnHour:Boolean;
      
      private var _count:int = 1;
      
      public var _StrengthenLevel:int;
      
      public var _StrengthenExp:int;
      
      private var _isGold:Boolean;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var Boold:int;
      
      public var Bless:int;
      
      private var _goldValidDate:int;
      
      private var _goldBeginTime:String;
      
      public var IsJudge:Boolean;
      
      public var Place:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var lockType:int;
      
      public var Hole1:int = -1;
      
      public var Hole2:int = -1;
      
      public var Hole3:int = -1;
      
      public var Hole4:int = -1;
      
      public var Hole5:int = -1;
      
      public var Hole6:int = -1;
      
      public var Hole5Level:int;
      
      public var Hole5Exp:int = 0;
      
      public var Hole6Level:int;
      
      public var Hole6Exp:int = 0;
      
      public var beadExp:int;
      
      public var beadLevel:int = 1;
      
      public var beadIsLock:int;
      
      public function InventoryItemInfo()
      {
         super();
         if(!_isTimerStarted)
         {
            _temp_Instances.push(this);
         }
      }
      
      public static function startTimer() : void
      {
         var _loc1_:InventoryItemInfo = null;
         if(!_isTimerStarted)
         {
            _isTimerStarted = true;
            for each(_loc1_ in _temp_Instances)
            {
               _loc1_.updateRemainDate();
            }
            _temp_Instances = null;
         }
      }
      
      public function get IsUsed() : Boolean
      {
         return this._isUsed;
      }
      
      public function set IsUsed(param1:Boolean) : void
      {
         isBeadLocked = param1;
         if(this._isUsed == param1)
         {
            return;
         }
         this._isUsed = param1;
         if(this._isUsed && _isTimerStarted)
         {
            this.updateRemainDate();
         }
      }
      
      public function set ValidDate(param1:Number) : void
      {
         this._ValidDate = param1;
      }
      
      public function get ValidDate() : Number
      {
         return this._ValidDate;
      }
      
      public function getRemainDate() : Number
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(this.ValidDate == 0)
         {
            return int.MAX_VALUE;
         }
         if(!this._isUsed)
         {
            return this.ValidDate;
         }
         _loc1_ = DateUtils.getDateByStr(this.BeginDate);
         _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? Number(0) : Number(_loc2_);
         return this.ValidDate - _loc2_;
      }
      
      public function getRemainSecond() : int
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(this.ValidDate == 0)
         {
            return int.MAX_VALUE;
         }
         if(!this._isUsed)
         {
            return this.ValidDate * 60 * 60 * 24;
         }
         _loc1_ = DateUtils.getDateByStr(this.BeginDate);
         _loc2_ = TimeManager.Instance.TotalSecondToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? Number(0) : Number(_loc2_);
         return this.ValidDate * 60 * 60 * 24 - _loc2_;
      }
      
      public function getColorValidDate() : Number
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         if(!this._isUsed)
         {
            return int.MAX_VALUE;
         }
         _loc1_ = DateUtils.getDateByStr(this.DiscolorValidDate);
         return Number(TimeManager.Instance.TotalDaysToNow(_loc1_) * -1);
      }
      
      public function set DiscolorValidDate(param1:String) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         this._DiscolorValidDate = param1;
         if(RefineryLevel >= 3 && this._isUsed)
         {
            _loc2_ = DateUtils.getDateByStr(this.DiscolorValidDate);
            _loc3_ = _loc2_.time - TimeManager.Instance.Now().time;
            if(_loc3_ <= 0)
            {
               SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
            }
            else
            {
               this.updateDiscolorValidDate();
            }
         }
      }
      
      public function get DiscolorValidDate() : String
      {
         return this._DiscolorValidDate;
      }
      
      private function updateDiscolorValidDate() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this.DiscolorValidDate);
         var _loc2_:Number = _loc1_.time - TimeManager.Instance.Now().time;
         if(this._checkColorValidTimer != null)
         {
            this._checkColorValidTimer.stop();
            this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
            this._checkColorValidTimer = null;
         }
         this._checkColorValidTimer = new Timer(_loc2_,1);
         this._checkColorValidTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete,false,0,true);
         this._checkColorValidTimer.start();
      }
      
      private function updateRemainDate() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         if(this.ValidDate != 0 && this._isUsed)
         {
            _loc1_ = DateUtils.getDateByStr(this.BeginDate);
            _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_);
            _loc3_ = this.ValidDate - _loc2_;
            if(_loc3_ > 0)
            {
               if(this._checkTimeOutTimer != null)
               {
                  this._checkTimeOutTimer.stop();
                  this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
                  this._checkTimeOutTimer = null;
               }
               this.atLeastOnHour = _loc3_ * 24 > 1;
               _loc4_ = !!this.atLeastOnHour ? uint(_loc3_ * TimeManager.DAY_TICKS - 1 * 60 * 60 * 1000) : uint(_loc3_ * TimeManager.DAY_TICKS);
               this._checkTimeOutTimer = new Timer(_loc4_,1);
               this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete,false,0,true);
               this._checkTimeOutTimer.start();
            }
            else
            {
               SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            }
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._checkTimeOutTimer.stop();
         if(!this.IsBinds)
         {
            return;
         }
         if(this.atLeastOnHour)
         {
            this._checkTimeOutTimer.delay = 10000 + 1 * 60 * 60 * 1000;
         }
         else
         {
            this._checkTimeOutTimer.delay = 10000;
         }
         this._checkTimeOutTimer.reset();
         this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut,false,0,true);
         this._checkTimeOutTimer.start();
      }
      
      private function _timerColorComplete(param1:TimerEvent) : void
      {
         this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.stop();
         SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
      }
      
      private function __sendGoodsTimeOut(param1:TimerEvent) : void
      {
         if(!StateManager.isInFight)
         {
            SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
            this._checkTimeOutTimer.stop();
         }
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(param1:int) : void
      {
         if(this._count == param1)
         {
            return;
         }
         this._count = param1;
         dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE,"Count",this._count));
      }
      
      public function clone() : InventoryItemInfo
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         return _loc1_.readObject();
      }
      
      public function set StrengthenLevel(param1:int) : void
      {
         this._StrengthenLevel = param1;
      }
      
      public function get StrengthenLevel() : int
      {
         return this._StrengthenLevel;
      }
      
      public function set StrengthenExp(param1:int) : void
      {
         this._StrengthenExp = param1;
      }
      
      public function get StrengthenExp() : int
      {
         return this._StrengthenExp;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(param1:Boolean) : void
      {
         this._isGold = param1;
      }
      
      public function get goldValidDate() : int
      {
         return this._goldValidDate;
      }
      
      public function set goldValidDate(param1:int) : void
      {
         this._goldValidDate = param1;
      }
      
      public function get goldBeginTime() : String
      {
         return this._goldBeginTime;
      }
      
      public function set goldBeginTime(param1:String) : void
      {
         this._goldBeginTime = param1;
      }
      
      public function getGoldRemainDate() : Number
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._goldBeginTime);
         var _loc2_:Number = TimeManager.Instance.TotalDaysToNow(_loc1_);
         _loc2_ = _loc2_ < 0 ? Number(0) : Number(_loc2_);
         return this.goldValidDate - _loc2_;
      }
   }
}
