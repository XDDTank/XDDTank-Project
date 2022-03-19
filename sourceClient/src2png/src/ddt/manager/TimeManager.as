// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.TimeManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.TimeEvents;
    import flash.events.Event;
    import com.pickgliss.loader.LoadInterfaceManager;
    import com.pickgliss.utils.StringUtils;
    import flash.events.TimerEvent;

    public class TimeManager 
    {

        public static const DAY_TICKS:Number = (((1000 * 24) * 60) * 60);//86400000
        public static const HOUR_TICKS:Number = ((1000 * 60) * 60);//3600000
        public static const Minute_TICKS:Number = (1000 * 60);//60000
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


        public static function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            _dispatcher.addEventListener(_arg_1, _arg_2);
        }

        public static function removeEventListener(_arg_1:String, _arg_2:Function):void
        {
            _dispatcher.removeEventListener(_arg_1, _arg_2);
        }

        public static function get Instance():TimeManager
        {
            if (_instance == null)
            {
                _instance = new (TimeManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._serverDate = new Date();
            this._serverTick = getTimer();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE, this.__update);
            addEventListener(TimeEvents.MINUTES, this.__timeValidate);
        }

        private function __timeValidate(_arg_1:Event):void
        {
            SocketManager.Instance.out.sendTimeValidate(++this._validateCount, this._validateTime);
        }

        private function __update(_arg_1:CrazyTankSocketEvent):void
        {
            this._serverTick = getTimer();
            this._serverDate = _arg_1.pkg.readDate();
            this._validateTime = this._serverDate;
            this._validateCount = 0;
            this.startGameTimer();
            var _local_2:Date = this.Now();
            LoadInterfaceManager.SyncDesktopTimer(((((_local_2.hours * 3600) + (_local_2.minutes * 60)) + _local_2.seconds) + ""));
        }

        public function Now():Date
        {
            return (new Date(((this._serverDate.getTime() + getTimer()) - this._serverTick)));
        }

        public function get serverDate():Date
        {
            return (this._serverDate);
        }

        public function get currentDay():Number
        {
            return (this.Now().getDay());
        }

        public function TimeSpanToNow(_arg_1:Date):Date
        {
            return (new Date(Math.abs((((this._serverDate.getTime() + getTimer()) - this._serverTick) - _arg_1.time))));
        }

        public function TotalDaysToNow(_arg_1:Date):Number
        {
            return ((((this._serverDate.getTime() + getTimer()) - this._serverTick) - _arg_1.time) / DAY_TICKS);
        }

        public function TotalHoursToNow(_arg_1:Date):Number
        {
            return ((((this._serverDate.getTime() + getTimer()) - this._serverTick) - _arg_1.time) / HOUR_TICKS);
        }

        public function TotalMinuteToNow(_arg_1:Date):Number
        {
            return ((((this._serverDate.getTime() + getTimer()) - this._serverTick) - _arg_1.time) / Minute_TICKS);
        }

        public function TotalSecondToNow(_arg_1:Date):Number
        {
            return ((((this._serverDate.getTime() + getTimer()) - this._serverTick) - _arg_1.time) / Second_TICKS);
        }

        public function TotalDaysToNow2(_arg_1:Date):Number
        {
            var _local_2:Date = this.Now();
            _local_2.setHours(0, 0, 0, 0);
            var _local_3:Date = new Date(_arg_1.time);
            _local_3.setHours(0, 0, 0, 0);
            return ((_local_2.time - _local_3.time) / DAY_TICKS);
        }

        public function formatTimeToString1(_arg_1:Number, _arg_2:Boolean=true):String
        {
            var _local_6:String;
            var _local_3:Number = (_arg_1 / HOUR_TICKS);
            var _local_4:Number = ((_arg_1 - (HOUR_TICKS * int(_local_3))) / Minute_TICKS);
            var _local_5:Number = (((_arg_1 - (HOUR_TICKS * int(_local_3))) - (int(_local_4) * Minute_TICKS)) / Second_TICKS);
            if (_local_3 < 0)
            {
                _local_3 = 0;
            };
            if (_local_4 < 0)
            {
                _local_4 = 0;
            };
            if (_local_5 < 0)
            {
                _local_5 = 0;
            };
            if (_arg_2)
            {
                _local_6 = (StringUtils.padLeft(String(int(_local_3)), "0", 2) + ":");
                _local_6 = (_local_6 + (StringUtils.padLeft(String(int(_local_4)), "0", 2) + ":"));
            }
            else
            {
                _local_6 = (StringUtils.padLeft(String(int(_local_4)), "0", 2) + ":");
            };
            return (_local_6 + StringUtils.padLeft(String(int(_local_5)), "0", 2));
        }

        public function formatTimeToString2(_arg_1:Number):String
        {
            var _local_8:String;
            var _local_2:Number = (_arg_1 / DAY_TICKS);
            var _local_3:int = (DAY_TICKS * int(_local_2));
            var _local_4:Number = ((_arg_1 - _local_3) / HOUR_TICKS);
            var _local_5:int = (HOUR_TICKS * int(_local_4));
            var _local_6:Number = (((_arg_1 - _local_3) - _local_5) / Minute_TICKS);
            var _local_7:Number = ((((_arg_1 - _local_3) - _local_5) - (int(_local_6) * Minute_TICKS)) / Second_TICKS);
            if (int(_local_2) > 0)
            {
                _local_8 = LanguageMgr.GetTranslation("ddt.timeFormat.dayAgo", int(_local_2));
            }
            else
            {
                if (int(_local_4) > 0)
                {
                    _local_8 = LanguageMgr.GetTranslation("ddt.timeFormat.hourAgo", int(_local_4));
                }
                else
                {
                    if (int(_local_6) > 0)
                    {
                        _local_8 = LanguageMgr.GetTranslation("ddt.timeFormat.minuteAgo", int(_local_6));
                    }
                    else
                    {
                        if (int(_local_7) > 0)
                        {
                            _local_8 = LanguageMgr.GetTranslation("ddt.timeFormat.secondAgo", int(_local_7));
                        }
                        else
                        {
                            _local_8 = LanguageMgr.GetTranslation("ddt.timeFormat.secondAgo", 1);
                        };
                    };
                };
            };
            return (_local_8);
        }

        public function getHour(_arg_1:Number):int
        {
            var _local_2:Number = (_arg_1 / HOUR_TICKS);
            return (int(_local_2));
        }

        public function getMinute(_arg_1:Number):int
        {
            return ((_arg_1 - (HOUR_TICKS * this.getHour(_arg_1))) / Minute_TICKS);
        }

        public function getSecond(_arg_1:Number):int
        {
            return (((_arg_1 - (HOUR_TICKS * this.getHour(_arg_1))) - (this.getMinute(_arg_1) * Minute_TICKS)) / Second_TICKS);
        }

        public function set totalGameTime(_arg_1:int):void
        {
            this._totalGameTime = _arg_1;
            _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
        }

        public function get totalGameTime():int
        {
            return (this._totalGameTime);
        }

        public function get enthrallTime():int
        {
            return (this._enthrallTime);
        }

        public function set enthrallTime(_arg_1:int):void
        {
            this._enthrallTime = _arg_1;
        }

        public function get enterFightTime():Number
        {
            return (this._enterFightTime);
        }

        public function set enterFightTime(_arg_1:Number):void
        {
            this._enterFightTime = _arg_1;
        }

        public function set secondsCount(_arg_1:int):void
        {
            if (_arg_1 == 1)
            {
                _arg_1 = 0;
                _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.SECONDS));
            };
            this._secondsCount = _arg_1;
        }

        public function set minutesCount(_arg_1:int):void
        {
            if (_arg_1 == 60)
            {
                _arg_1 = 0;
                _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.MINUTES));
            };
            this._minutesCount = _arg_1;
        }

        public function set hoursCount(_arg_1:int):void
        {
            if (_arg_1 == (60 * 60))
            {
                _arg_1 = 0;
                _dispatcher.dispatchEvent(new TimeEvents(TimeEvents.HOURS));
            };
            this._hoursCount = _arg_1;
        }

        private function startGameTimer():void
        {
            if (this._gameTimer)
            {
                this._gameTimer.stop();
                this._gameTimer.removeEventListener(TimerEvent.TIMER, this.__gameTimerTick);
                this._gameTimer = null;
            };
            this._secondsCount = 0;
            this._minutesCount = 0;
            this._hoursCount = 0;
            this._gameTimer = new Timer(1000, 0);
            this._gameTimer.addEventListener(TimerEvent.TIMER, this.__gameTimerTick);
            this._gameTimer.start();
        }

        private function __gameTimerTick(_arg_1:TimerEvent):void
        {
            this.secondsCount = (this._secondsCount + 1);
            this.minutesCount = (this._minutesCount + 1);
            this.hoursCount = (this._hoursCount + 1);
        }

        private function __gameTimerCompelte(_arg_1:TimerEvent):void
        {
            this._gameTimer.stop();
            this._gameTimer.removeEventListener(TimerEvent.TIMER, this.__gameTimerTick);
            this._gameTimer = null;
        }


    }
}//package ddt.manager

