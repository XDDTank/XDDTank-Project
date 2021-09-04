package calendar
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.CalendarSignAnalyze;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.DatetimeHelper;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mainbutton.MainButtnController;
   import road7th.comm.PackageIn;
   
   public class CalendarManager
   {
      
      private static var _ins:CalendarManager;
       
      
      private var _localVisible:Boolean = false;
      
      private var _model:CalendarModel;
      
      private var _today:Date;
      
      private var _signCount:int;
      
      private var _dayLogDic:Dictionary;
      
      private var _timer:Timer;
      
      private var _startTime:int;
      
      private var _localMarkDate:Date;
      
      private var _frame:Frame;
      
      private var _luckyNum:int = -1;
      
      private var _myLuckyNum:int = -1;
      
      private var _initialized:Boolean = false;
      
      private var _responseLuckyNum:Boolean = true;
      
      private var _currentModel:int;
      
      private var _isQQopen:Boolean = false;
      
      private var _activeID:int;
      
      private var _dailyInfo:Array;
      
      private var _signAwards:Array;
      
      private var _signAwardCounts:Array;
      
      private var _dailyAwardState:Boolean = true;
      
      public function CalendarManager()
      {
         this._dayLogDic = new Dictionary();
         this._localMarkDate = new Date();
         super();
      }
      
      public static function getInstance() : CalendarManager
      {
         if(_ins == null)
         {
            _ins = new CalendarManager();
         }
         return _ins;
      }
      
      public function initialize() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_LUCKYNUM,this.__userLuckyNum);
      }
      
      public function requestLuckyNum() : void
      {
         if(this._responseLuckyNum)
         {
            SocketManager.Instance.out.sendUserLuckyNum(-1,false);
            this._responseLuckyNum = false;
         }
      }
      
      private function __userLuckyNum(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._luckyNum = _loc2_.readInt();
         var _loc3_:String = _loc2_.readUTF();
         if(this._model)
         {
            this._model.luckyNum = this._luckyNum;
            this._model.myLuckyNum = this._myLuckyNum;
         }
         this._responseLuckyNum = true;
      }
      
      public function open(param1:int) : void
      {
         var _loc2_:Date = null;
         this._currentModel = param1;
         if(this._initialized && !this._localVisible && this._today)
         {
            this._localVisible = true;
            this._model = new CalendarModel(this._today,this._signCount,this._dayLogDic,this._signAwards,this._signAwardCounts);
            this._model.luckyNum = this._luckyNum;
            this._model.myLuckyNum = this._myLuckyNum;
            _loc2_ = new Date();
            if(_loc2_.time - this._today.time > CalendarModel.MS_of_Day)
            {
               SocketManager.Instance.out.sendErrorMsg("打开签到的时候，客户端时间与服务器时间间隔超过一天。by" + PlayerManager.Instance.Self.NickName);
            }
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CALENDAR);
         }
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      public function qqOpen(param1:int) : void
      {
         this._isQQopen = true;
         this._activeID = param1;
         if(this._initialized && !this._localVisible)
         {
            this.open(2);
         }
         else if(this._frame != null)
         {
            this._isQQopen = false;
         }
      }
      
      public function close() : void
      {
         this._localVisible = false;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleSmallLoading.Instance.hide();
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer = null;
         }
         if(this._frame)
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      private function __moduleIOError(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleSmallLoading.Instance.hide();
         this.close();
      }
      
      private function __loadingClose(param1:Event) : void
      {
         this.close();
      }
      
      private function __moduleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CALENDAR)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            if(this._localVisible)
            {
               if(this._currentModel == CalendarModel.Calendar)
               {
                  this._frame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.SignFrameStyle",[this._model]);
                  this._frame.titleText = LanguageMgr.GetTranslation("tank.calendar.signTitle");
               }
               this._frame.addEventListener(ComponentEvent.DISPOSE,this.__frameDispose);
               MainToolBar.Instance.signEffectEnable = false;
               LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               if(this._timer == null)
               {
                  this._timer = new Timer(1000);
                  this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
                  this._timer.start();
               }
            }
            if(this._isQQopen)
            {
               this._isQQopen = false;
            }
         }
      }
      
      private function __frameDispose(param1:ComponentEvent) : void
      {
         this._localVisible = false;
         param1.currentTarget.removeEventListener(ComponentEvent.DISPOSE,this.__frameDispose);
         ObjectUtils.disposeObject(this._model);
         this._model = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer = null;
         }
      }
      
      private function __mark(param1:TimerEvent) : void
      {
         var _loc2_:Date = null;
         if(this._localVisible && this._model)
         {
            _loc2_ = this._model.today;
            this._localMarkDate.time = _loc2_.time + getTimer() - this._startTime;
            if(this._localMarkDate.fullYear > _loc2_.fullYear || this._localMarkDate.month > _loc2_.month || this._localMarkDate.date > _loc2_.date)
            {
               this.localToNextDay(this._model,this._localMarkDate);
            }
         }
      }
      
      public function request() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLogList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.analyzer = new CalendarSignAnalyze(this.calendarSignComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.instance.startLoad(_loc2_);
         return _loc2_;
      }
      
      private function __complete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
      }
      
      private function calendarSignComplete(param1:CalendarSignAnalyze) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Date = new Date();
         this._startTime = getTimer();
         this._signCount = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = CalendarModel.getMonthMaxDay(this._today.month,this._today.fullYear);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc5_ < _loc3_.length && _loc3_[_loc5_] == "true")
            {
               _loc6_ = _loc5_ + 1;
               ++this._signCount;
               this._dayLogDic[String(_loc5_ + 1)] = "True";
               if(_loc6_ == int(_loc2_.date))
               {
                  PlayerManager.Instance.Self.Sign = true;
                  MainButtnController.instance.dispatchEvent(new Event(MainButtnController.CLOSESIGN));
               }
            }
            else
            {
               this._dayLogDic[String(_loc5_ + 1)] = "False";
            }
            _loc5_++;
         }
         if(this._model && this._localVisible)
         {
            this._model.today = this._today;
            this._model.signCount = this._signCount;
            this._model.dayLog = this._dayLogDic;
         }
      }
      
      private function localToNextDay(param1:CalendarModel, param2:Date) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2.date == 1)
         {
            _loc3_ = CalendarModel.getMonthMaxDay(param2.month,param2.fullYear);
            _loc4_ = 1;
            while(_loc4_ <= _loc3_)
            {
               this._model.dayLog[String(_loc4_)] = "False";
               _loc4_++;
            }
            this._model.signCount = 0;
         }
         this._model.today = param2;
      }
      
      public function sign(param1:Date) : Boolean
      {
         var _loc3_:Date = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         if(this._localVisible && this._model)
         {
            _loc3_ = this._model.today;
            if(param1.fullYear == _loc3_.fullYear && param1.month == _loc3_.month && param1.date == _loc3_.date && !this._model.hasSigned(param1))
            {
               this._model.dayLog[param1.date.toString()] = "True";
               ++this._model.signCount;
               this._signCount = this._model.signCount;
               _loc2_ = true;
               _loc4_ = this._model.awardCounts.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(this._model.signCount == this._model.awardCounts[_loc5_])
                  {
                     this.receive(this._model.awardCounts[_loc5_],this._model.awards);
                     return _loc2_;
                  }
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      private function hasSameWeek(param1:Date, param2:Date) : Boolean
      {
         if(Math.abs(param2.time - param1.time) > CalendarModel.MS_of_Day * 7)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.OutWeek"));
            return false;
         }
         return true;
      }
      
      private function getWeekCount(param1:Date) : int
      {
         var _loc2_:Date = new Date();
         _loc2_.setFullYear(param1.fullYear,1,1);
         var _loc3_:int = (param1.time - _loc2_.time) / CalendarModel.MS_of_Day;
         return _loc3_ / 7;
      }
      
      public function receive(param1:int, param2:Array) : void
      {
         var _loc4_:DaylyGiveInfo = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            if(_loc4_.AwardDays == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         this.showAwardInfo(_loc3_);
      }
      
      public function showAwardInfo(param1:Array) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc4_:DaylyGiveInfo = null;
         var _loc3_:String = "";
         for each(_loc4_ in param1)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
            if(_loc2_)
            {
               _loc3_ += _loc2_.Name + "X" + _loc4_.Count + " ";
            }
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signedAwards",_loc3_));
      }
      
      public function reciveDayAward() : void
      {
         var _loc2_:Date = null;
         var _loc1_:Date = PlayerManager.Instance.Self.systemDate as Date;
         if(!this._dailyAwardState)
         {
            _loc2_ = new Date();
            _loc2_.setTime(_loc2_.getTime() + DatetimeHelper.millisecondsPerDay);
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.calendar.DailyAward",_loc2_.month + 1,_loc2_.date),LanguageMgr.GetTranslation("ok"),"",true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         }
         else
         {
            this._dailyAwardState = false;
            MainButtnController.instance.DailyAwardState = false;
            MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
         }
      }
      
      public function hasTodaySigned() : Boolean
      {
         return this._dayLogDic && this._today && this._dayLogDic[this._today.date.toString()] == "True";
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function get isShow() : Boolean
      {
         return this._localVisible;
      }
      
      public function setDailyInfo(param1:DaylyGiveAnalyzer) : void
      {
         this._dailyInfo = param1.list;
         this._signAwards = param1.signAwardList;
         this._signAwardCounts = param1.signAwardCounts;
         this._initialized = true;
      }
      
      public function setDailyAwardState(param1:Boolean) : void
      {
         this._dailyAwardState = param1;
      }
   }
}
