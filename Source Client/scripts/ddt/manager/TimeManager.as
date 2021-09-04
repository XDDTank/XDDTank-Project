package ddt.manager
{
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.utils.StringUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.TimeEvents;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TimeManager
   {
      
      public static const DAY_TICKS:Number = 1000 * 24 * 60 * 60;
      
      public static const HOUR_TICKS:Number = 1000 * 60 * 60;
      
      public static const Minute_TICKS:Number = 1000 * 60;
      
      public static const Second_TICKS:Number = 1000;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var CHANGE:String = "change";
      
      private static var _instance:TimeManager;
       
      
      private var _serverDate:Date;
      
      private var _serverTick:int;
      
      private var _enterFightTime:Number;
      
      private var _gameTimer:Timer;
      
      private var _validateCount:int = 0;
      
      private var _validateTime:Date;
      
      private var _startGameTime:Date;
      
      private var _currentTime:Date;
      
      private var _totalGameTime:int;
      
      private var _enthrallTime:int;
      
      private var _gameCount:Number;
      
      private var _secondsCount:int;
      
      private var _minutesCount:int;
      
      private var _hoursCount:int;
      
      public function TimeManager()
      {
         super();
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.removeEventListener(param1,param2);
      }
      
      public static function get Instance() : TimeManager
      {
         if(_instance == null)
         {
            _instance = new TimeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._serverDate = new Date();
         this._serverTick = getTimer();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE,this.__update);
         addEventListener(TimeEvents.MINUTES,this.__timeValidate);
      }
      
      private function __timeValidate(param1:Event) : void
      {
         SocketManager.Instance.out.sendTimeValidate(++this._validateCount,this._validateTime);
      }
      
      private function __update(param1:CrazyTankSocketEvent) : void
      {
         this._serverTick = getTimer();
         this._serverDate = param1.pkg.readDate();
         this._validateTime = this._serverDate;
         this._validateCount = 0;
         this.startGameTimer();
         var _loc2_:Date = this.Now();
         LoadInterfaceManager.SyncDesktopTimer(_loc2_.hours * 3600 + _loc2_.minutes * 60 + _loc2_.seconds + "");
      }
      
      public function Now() : Date
      {
         return new Date(this._serverDate.getTime() + getTimer() - this._serverTick);
      }
      
      public function get serverDate() : Date
      {
         return this._serverDate;
      }
      
      public function get currentDay() : Number
      {
         return this.Now().getDay();
      }
      
      public function TimeSpanToNow(param1:Date) : Date
      {
         return new Date(Math.abs(this._serverDate.getTime() + getTimer() - this._serverTick - param1.time));
      }
      
      public function TotalDaysToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / DAY_TICKS;
      }
      
      public function TotalHoursToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / HOUR_TICKS;
      }
      
      public function TotalMinuteToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Minute_TICKS;
      }
      
      public function TotalSecondToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Second_TICKS;
      }
      
      public function TotalDaysToNow2(param1:Date) : Number
      {
         var _loc2_:Date = this.Now();
         _loc2_.setHours(0,0,0,0);
         var _loc3_:Date = new Date(param1.time);
         _loc3_.setHours(0,0,0,0);
         return (_loc2_.time - _loc3_.time) / DAY_TICKS;
      }
      
      public function formatTimeToString1(param1:Number, param2:Boolean = true) : String
      {
         var _loc6_:String = null;
         var _loc3_:Number = param1 / HOUR_TICKS;
         var _loc4_:Number = (param1 - HOUR_TICKS * int(_loc3_)) / Minute_TICKS;
         var _loc5_:Number = (param1 - HOUR_TICKS * int(_loc3_) - int(_loc4_) * Minute_TICKS) / Second_TICKS;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         if(param2)
         {
            _loc6_ = StringUtils.padLeft(String(int(_loc3_)),"0",2) + ":";
            _loc6_ += StringUtils.padLeft(String(int(_loc4_)),"0",2) + ":";
         }
         else
         {
            _loc6_ = StringUtils.padLeft(String(int(_loc4_)),"0",2) + ":";
         }
         return _loc6_ + StringUtils.padLeft(String(int(_loc5_)),"0",2);
      }
      
      public function formatTimeToString2(param1:Number) : String
      {
         var _loc8_:String = null;
         var _loc2_:Number = param1 / DAY_TICKS;
         var _loc3_:int = DAY_TICKS * int(_loc2_);
         var _loc4_:Number = (param1 - _loc3_) / HOUR_TICKS;
         var _loc5_:int = HOUR_TICKS * int(_loc4_);
         var _loc6_:Number = (param1 - _loc3_ - _loc5_) / Minute_TICKS;
         var _loc7_:Number = (param1 - _loc3_ - _loc5_ - int(_loc6_) * Minute_TICKS) / Second_TICKS;
         if(int(_loc2_) > 0)
         {
            _loc8_ = LanguageMgr.GetTranslation("ddt.timeFormat.dayAgo",int(_loc2_));
         }
         else if(int(_loc4_) > 0)
         {
            _loc8_ = LanguageMgr.GetTranslation("ddt.timeFormat.hourAgo",int(_loc4_));
         }
         else if(int(_loc6_) > 0)
         {
            _loc8_ = LanguageMgr.GetTranslation("ddt.timeFormat.minuteAgo",int(_loc6_));
         }
         else if(int(_loc7_) > 0)
         {
            _loc8_ = LanguageMgr.GetTranslation("ddt.timeFormat.secondAgo",int(_loc7_));
         }
         else
         {
            _loc8_ = LanguageMgr.GetTranslation("ddt.timeFormat.secondAgo",1);
         }
         return _loc8_;
      }
      
      public function getHour(param1:Number) : int
      {
         var _loc2_:Number = param1 / HOUR_TICKS;
         return int(_loc2_);
      }
      
      public function getMinute(param1:Number) : int
      {
         return Number((param1 - HOUR_TICKS * this.getHour(param1)) / Minute_TICKS);
      }
      
      public function getSecond(param1:Number) : int
      {
         return Number((param1 - HOUR_TICKS * this.getHour(param1) - this.getMinute(param1) * Minute_TICKS) / Second_TICKS);
      }
      
      public function set totalGameTime(param1:int) : void
      {
         this._totalGameTime = param1;
         _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
      }
      
      public function get totalGameTime() : int
      {
         return this._totalGameTime;
      }
      
      public function get enthrallTime() : int
      {
         return this._enthrallTime;
      }
      
      public function set enthrallTime(param1:int) : void
      {
         this._enthrallTime = param1;
      }
      
      public function get enterFightTime() : Number
      {
         return this._enterFightTime;
      }
      
      public function set enterFightTime(param1:Number) : void
      {
         this._enterFightTime = param1;
      }
      
      public function set secondsCount(param1:int) : void
      {
         if(param1 == 1)
         {
            param1 = 0;
            _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.SECONDS));
         }
         this._secondsCount = param1;
      }
      
      public function set minutesCount(param1:int) : void
      {
         if(param1 == 60)
         {
            param1 = 0;
            _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.MINUTES));
         }
         this._minutesCount = param1;
      }
      
      public function set hoursCount(param1:int) : void
      {
         if(param1 == 60 * 60)
         {
            param1 = 0;
            _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.HOURS));
         }
         this._hoursCount = param1;
      }
      
      private function startGameTimer() : void
      {
         if(this._gameTimer)
         {
            this._gameTimer.stop();
            this._gameTimer.removeEventListener(TimerEvent.TIMER,this.__gameTimerTick);
            this._gameTimer = null;
         }
         this._secondsCount = 0;
         this._minutesCount = 0;
         this._hoursCount = 0;
         this._gameTimer = new Timer(1000,0);
         this._gameTimer.addEventListener(TimerEvent.TIMER,this.__gameTimerTick);
         this._gameTimer.start();
      }
      
      private function __gameTimerTick(param1:TimerEvent) : void
      {
         this.secondsCount = this._secondsCount + 1;
         this.minutesCount = this._minutesCount + 1;
         this.hoursCount = this._hoursCount + 1;
      }
      
      private function __gameTimerCompelte(param1:TimerEvent) : void
      {
         this._gameTimer.stop();
         this._gameTimer.removeEventListener(TimerEvent.TIMER,this.__gameTimerTick);
         this._gameTimer = null;
      }
   }
}
