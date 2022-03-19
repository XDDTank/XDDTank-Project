// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.CalendarManager

package calendar
{
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import com.pickgliss.ui.controls.Frame;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.manager.PlayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.ComponentEvent;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.getTimer;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.CalendarSignAnalyze;
    import com.pickgliss.loader.LoaderEvent;
    import mainbutton.MainButtnController;
    import ddt.manager.MessageTipManager;
    import ddt.data.DaylyGiveInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.utils.DatetimeHelper;
    import com.pickgliss.ui.AlertManager;
    import ddt.data.analyze.DaylyGiveAnalyzer;

    public class CalendarManager 
    {

        private static var _ins:CalendarManager;

        private var _localVisible:Boolean = false;
        private var _model:CalendarModel;
        private var _today:Date;
        private var _signCount:int;
        private var _dayLogDic:Dictionary = new Dictionary();
        private var _timer:Timer;
        private var _startTime:int;
        private var _localMarkDate:Date = new Date();
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


        public static function getInstance():CalendarManager
        {
            if (_ins == null)
            {
                _ins = new (CalendarManager)();
            };
            return (_ins);
        }


        public function initialize():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_LUCKYNUM, this.__userLuckyNum);
        }

        public function requestLuckyNum():void
        {
            if (this._responseLuckyNum)
            {
                SocketManager.Instance.out.sendUserLuckyNum(-1, false);
                this._responseLuckyNum = false;
            };
        }

        private function __userLuckyNum(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._luckyNum = _local_2.readInt();
            var _local_3:String = _local_2.readUTF();
            if (this._model)
            {
                this._model.luckyNum = this._luckyNum;
                this._model.myLuckyNum = this._myLuckyNum;
            };
            this._responseLuckyNum = true;
        }

        public function open(_arg_1:int):void
        {
            var _local_2:Date;
            this._currentModel = _arg_1;
            if ((((this._initialized) && (!(this._localVisible))) && (this._today)))
            {
                this._localVisible = true;
                this._model = new CalendarModel(this._today, this._signCount, this._dayLogDic, this._signAwards, this._signAwardCounts);
                this._model.luckyNum = this._luckyNum;
                this._model.myLuckyNum = this._myLuckyNum;
                _local_2 = new Date();
                if ((_local_2.time - this._today.time) > CalendarModel.MS_of_Day)
                {
                    SocketManager.Instance.out.sendErrorMsg(("打开签到的时候，客户端时间与服务器时间间隔超过一天。by" + PlayerManager.Instance.Self.NickName));
                };
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CALENDAR);
            };
        }

        public function get luckyNum():int
        {
            return (this._luckyNum);
        }

        private function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        public function qqOpen(_arg_1:int):void
        {
            this._isQQopen = true;
            this._activeID = _arg_1;
            if (((this._initialized) && (!(this._localVisible))))
            {
                this.open(2);
            }
            else
            {
                if (this._frame != null)
                {
                    this._isQQopen = false;
                };
            };
        }

        public function close():void
        {
            this._localVisible = false;
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            ObjectUtils.disposeObject(this._model);
            this._model = null;
            if (this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__mark);
                this._timer = null;
            };
            if (this._frame)
            {
                ObjectUtils.disposeObject(this._frame);
                this._frame = null;
            };
        }

        private function __moduleIOError(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
            this.close();
        }

        private function __loadingClose(_arg_1:Event):void
        {
            this.close();
        }

        private function __moduleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_CALENDAR)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleSmallLoading.Instance.hide();
                if (this._localVisible)
                {
                    if (this._currentModel == CalendarModel.Calendar)
                    {
                        this._frame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.SignFrameStyle", [this._model]);
                        this._frame.titleText = LanguageMgr.GetTranslation("tank.calendar.signTitle");
                    };
                    this._frame.addEventListener(ComponentEvent.DISPOSE, this.__frameDispose);
                    MainToolBar.Instance.signEffectEnable = false;
                    LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
                    if (this._timer == null)
                    {
                        this._timer = new Timer(1000);
                        this._timer.addEventListener(TimerEvent.TIMER, this.__mark);
                        this._timer.start();
                    };
                };
                if (this._isQQopen)
                {
                    this._isQQopen = false;
                };
            };
        }

        private function __frameDispose(_arg_1:ComponentEvent):void
        {
            this._localVisible = false;
            _arg_1.currentTarget.removeEventListener(ComponentEvent.DISPOSE, this.__frameDispose);
            ObjectUtils.disposeObject(this._model);
            this._model = null;
            if (this._timer)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__mark);
                this._timer = null;
            };
        }

        private function __mark(_arg_1:TimerEvent):void
        {
            var _local_2:Date;
            if (((this._localVisible) && (this._model)))
            {
                _local_2 = this._model.today;
                this._localMarkDate.time = ((_local_2.time + getTimer()) - this._startTime);
                if ((((this._localMarkDate.fullYear > _local_2.fullYear) || (this._localMarkDate.month > _local_2.month)) || (this._localMarkDate.date > _local_2.date)))
                {
                    this.localToNextDay(this._model, this._localMarkDate);
                };
            };
        }

        public function request():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["rnd"] = Math.random();
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("DailyLogList.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.analyzer = new CalendarSignAnalyze(this.calendarSignComplete);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.addEventListener(LoaderEvent.COMPLETE, this.__complete);
            LoadResourceManager.instance.startLoad(_local_2);
            return (_local_2);
        }

        private function __complete(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__complete);
        }

        private function calendarSignComplete(_arg_1:CalendarSignAnalyze):void
        {
            var _local_6:int;
            var _local_2:Date = new Date();
            this._startTime = getTimer();
            this._signCount = 0;
            var _local_3:Array = new Array();
            var _local_4:int = CalendarModel.getMonthMaxDay(this._today.month, this._today.fullYear);
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                if (((_local_5 < _local_3.length) && (_local_3[_local_5] == "true")))
                {
                    _local_6 = (_local_5 + 1);
                    this._signCount++;
                    this._dayLogDic[String((_local_5 + 1))] = "True";
                    if (_local_6 == int(_local_2.date))
                    {
                        PlayerManager.Instance.Self.Sign = true;
                        MainButtnController.instance.dispatchEvent(new Event(MainButtnController.CLOSESIGN));
                    };
                }
                else
                {
                    this._dayLogDic[String((_local_5 + 1))] = "False";
                };
                _local_5++;
            };
            if (((this._model) && (this._localVisible)))
            {
                this._model.today = this._today;
                this._model.signCount = this._signCount;
                this._model.dayLog = this._dayLogDic;
            };
        }

        private function localToNextDay(_arg_1:CalendarModel, _arg_2:Date):void
        {
            var _local_3:int;
            var _local_4:int;
            if (_arg_2.date == 1)
            {
                _local_3 = CalendarModel.getMonthMaxDay(_arg_2.month, _arg_2.fullYear);
                _local_4 = 1;
                while (_local_4 <= _local_3)
                {
                    this._model.dayLog[String(_local_4)] = "False";
                    _local_4++;
                };
                this._model.signCount = 0;
            };
            this._model.today = _arg_2;
        }

        public function sign(_arg_1:Date):Boolean
        {
            var _local_3:Date;
            var _local_4:int;
            var _local_5:int;
            var _local_2:Boolean;
            if (((this._localVisible) && (this._model)))
            {
                _local_3 = this._model.today;
                if (((((_arg_1.fullYear == _local_3.fullYear) && (_arg_1.month == _local_3.month)) && (_arg_1.date == _local_3.date)) && (!(this._model.hasSigned(_arg_1)))))
                {
                    this._model.dayLog[_arg_1.date.toString()] = "True";
                    this._model.signCount++;
                    this._signCount = this._model.signCount;
                    _local_2 = true;
                    _local_4 = this._model.awardCounts.length;
                    _local_5 = 0;
                    while (_local_5 < _local_4)
                    {
                        if (this._model.signCount == this._model.awardCounts[_local_5])
                        {
                            this.receive(this._model.awardCounts[_local_5], this._model.awards);
                            return (_local_2);
                        };
                        _local_5++;
                    };
                };
            };
            return (_local_2);
        }

        private function hasSameWeek(_arg_1:Date, _arg_2:Date):Boolean
        {
            if (Math.abs((_arg_2.time - _arg_1.time)) > (CalendarModel.MS_of_Day * 7))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.OutWeek"));
                return (false);
            };
            return (true);
        }

        private function getWeekCount(_arg_1:Date):int
        {
            var _local_2:Date = new Date();
            _local_2.setFullYear(_arg_1.fullYear, 1, 1);
            var _local_3:int = int(((_arg_1.time - _local_2.time) / CalendarModel.MS_of_Day));
            return (_local_3 / 7);
        }

        public function receive(_arg_1:int, _arg_2:Array):void
        {
            var _local_4:DaylyGiveInfo;
            var _local_3:Array = [];
            for each (_local_4 in _arg_2)
            {
                if (_local_4.AwardDays == _arg_1)
                {
                    _local_3.push(_local_4);
                };
            };
            this.showAwardInfo(_local_3);
        }

        public function showAwardInfo(_arg_1:Array):void
        {
            var _local_2:ItemTemplateInfo;
            var _local_4:DaylyGiveInfo;
            var _local_3:String = "";
            for each (_local_4 in _arg_1)
            {
                _local_2 = ItemManager.Instance.getTemplateById(_local_4.TemplateID);
                if (_local_2)
                {
                    _local_3 = (_local_3 + (((_local_2.Name + "X") + _local_4.Count) + " "));
                };
            };
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.signedAwards", _local_3));
        }

        public function reciveDayAward():void
        {
            var _local_2:Date;
            var _local_1:Date = (PlayerManager.Instance.Self.systemDate as Date);
            if ((!(this._dailyAwardState)))
            {
                _local_2 = new Date();
                _local_2.setTime((_local_2.getTime() + DatetimeHelper.millisecondsPerDay));
                AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("tank.calendar.DailyAward", (_local_2.month + 1), _local_2.date), LanguageMgr.GetTranslation("ok"), "", true, false, false, LayerManager.ALPHA_BLOCKGOUND);
            }
            else
            {
                this._dailyAwardState = false;
                MainButtnController.instance.DailyAwardState = false;
                MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
            };
        }

        public function hasTodaySigned():Boolean
        {
            return (((this._dayLogDic) && (this._today)) && (this._dayLogDic[this._today.date.toString()] == "True"));
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function get isShow():Boolean
        {
            return (this._localVisible);
        }

        public function setDailyInfo(_arg_1:DaylyGiveAnalyzer):void
        {
            this._dailyInfo = _arg_1.list;
            this._signAwards = _arg_1.signAwardList;
            this._signAwardCounts = _arg_1.signAwardCounts;
            this._initialized = true;
        }

        public function setDailyAwardState(_arg_1:Boolean):void
        {
            this._dailyAwardState = _arg_1;
        }


    }
}//package calendar

