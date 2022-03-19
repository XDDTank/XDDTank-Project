// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.goods.InventoryItemInfo

package ddt.data.goods
{
    import flash.utils.Timer;
    import road7th.utils.DateUtils;
    import ddt.manager.TimeManager;
    import ddt.manager.SocketManager;
    import flash.events.TimerEvent;
    import ddt.manager.StateManager;
    import ddt.events.GoodsEvent;
    import flash.utils.ByteArray;

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
            if ((!(_isTimerStarted)))
            {
                _temp_Instances.push(this);
            };
        }

        public static function startTimer():void
        {
            var _local_1:InventoryItemInfo;
            if ((!(_isTimerStarted)))
            {
                _isTimerStarted = true;
                for each (_local_1 in _temp_Instances)
                {
                    _local_1.updateRemainDate();
                };
                _temp_Instances = null;
            };
        }


        public function get IsUsed():Boolean
        {
            return (this._isUsed);
        }

        public function set IsUsed(_arg_1:Boolean):void
        {
            isBeadLocked = _arg_1;
            if (this._isUsed == _arg_1)
            {
                return;
            };
            this._isUsed = _arg_1;
            if (((this._isUsed) && (_isTimerStarted)))
            {
                this.updateRemainDate();
            };
        }

        public function set ValidDate(_arg_1:Number):void
        {
            this._ValidDate = _arg_1;
        }

        public function get ValidDate():Number
        {
            return (this._ValidDate);
        }

        public function getRemainDate():Number
        {
            var _local_1:Date;
            var _local_2:Number;
            if (this.ValidDate == 0)
            {
                return (int.MAX_VALUE);
            };
            if ((!(this._isUsed)))
            {
                return (this.ValidDate);
            };
            _local_1 = DateUtils.getDateByStr(this.BeginDate);
            _local_2 = TimeManager.Instance.TotalDaysToNow(_local_1);
            _local_2 = ((_local_2 < 0) ? 0 : _local_2);
            return (this.ValidDate - _local_2);
        }

        public function getRemainSecond():int
        {
            var _local_1:Date;
            var _local_2:Number;
            if (this.ValidDate == 0)
            {
                return (int.MAX_VALUE);
            };
            if ((!(this._isUsed)))
            {
                return (((this.ValidDate * 60) * 60) * 24);
            };
            _local_1 = DateUtils.getDateByStr(this.BeginDate);
            _local_2 = TimeManager.Instance.TotalSecondToNow(_local_1);
            _local_2 = ((_local_2 < 0) ? 0 : _local_2);
            return ((((this.ValidDate * 60) * 60) * 24) - _local_2);
        }

        public function getColorValidDate():Number
        {
            var _local_1:Date;
            var _local_2:Number;
            if ((!(this._isUsed)))
            {
                return (int.MAX_VALUE);
            };
            _local_1 = DateUtils.getDateByStr(this.DiscolorValidDate);
            return (TimeManager.Instance.TotalDaysToNow(_local_1) * -1);
        }

        public function set DiscolorValidDate(_arg_1:String):void
        {
            var _local_2:Date;
            var _local_3:Number;
            this._DiscolorValidDate = _arg_1;
            if (((RefineryLevel >= 3) && (this._isUsed)))
            {
                _local_2 = DateUtils.getDateByStr(this.DiscolorValidDate);
                _local_3 = (_local_2.time - TimeManager.Instance.Now().time);
                if (_local_3 <= 0)
                {
                    SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType, this.Place);
                }
                else
                {
                    this.updateDiscolorValidDate();
                };
            };
        }

        public function get DiscolorValidDate():String
        {
            return (this._DiscolorValidDate);
        }

        private function updateDiscolorValidDate():void
        {
            var _local_1:Date = DateUtils.getDateByStr(this.DiscolorValidDate);
            var _local_2:Number = (_local_1.time - TimeManager.Instance.Now().time);
            if (this._checkColorValidTimer != null)
            {
                this._checkColorValidTimer.stop();
                this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timerColorComplete);
                this._checkColorValidTimer = null;
            };
            this._checkColorValidTimer = new Timer(_local_2, 1);
            this._checkColorValidTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this._timerColorComplete, false, 0, true);
            this._checkColorValidTimer.start();
        }

        private function updateRemainDate():void
        {
            var _local_1:Date;
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:uint;
            if (((!(this.ValidDate == 0)) && (this._isUsed)))
            {
                _local_1 = DateUtils.getDateByStr(this.BeginDate);
                _local_2 = TimeManager.Instance.TotalDaysToNow(_local_1);
                _local_3 = (this.ValidDate - _local_2);
                if (_local_3 > 0)
                {
                    if (this._checkTimeOutTimer != null)
                    {
                        this._checkTimeOutTimer.stop();
                        this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                        this._checkTimeOutTimer = null;
                    };
                    this.atLeastOnHour = ((_local_3 * 24) > 1);
                    _local_4 = ((this.atLeastOnHour) ? ((_local_3 * TimeManager.DAY_TICKS) - (((1 * 60) * 60) * 1000)) : (_local_3 * TimeManager.DAY_TICKS));
                    this._checkTimeOutTimer = new Timer(_local_4, 1);
                    this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete, false, 0, true);
                    this._checkTimeOutTimer.start();
                }
                else
                {
                    SocketManager.Instance.out.sendItemOverDue(this.BagType, this.Place);
                };
            };
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this._checkTimeOutTimer.stop();
            if ((!(this.IsBinds)))
            {
                return;
            };
            if (this.atLeastOnHour)
            {
                this._checkTimeOutTimer.delay = (10000 + (((1 * 60) * 60) * 1000));
            }
            else
            {
                this._checkTimeOutTimer.delay = 10000;
            };
            this._checkTimeOutTimer.reset();
            this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER, this.__sendGoodsTimeOut, false, 0, true);
            this._checkTimeOutTimer.start();
        }

        private function _timerColorComplete(_arg_1:TimerEvent):void
        {
            this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timerColorComplete);
            this._checkColorValidTimer.stop();
            SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType, this.Place);
        }

        private function __sendGoodsTimeOut(_arg_1:TimerEvent):void
        {
            if ((!(StateManager.isInFight)))
            {
                SocketManager.Instance.out.sendItemOverDue(this.BagType, this.Place);
                this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER, this.__sendGoodsTimeOut);
                this._checkTimeOutTimer.stop();
            };
        }

        public function get Count():int
        {
            return (this._count);
        }

        public function set Count(_arg_1:int):void
        {
            if (this._count == _arg_1)
            {
                return;
            };
            this._count = _arg_1;
            dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE, "Count", this._count));
        }

        public function clone():InventoryItemInfo
        {
            var _local_1:ByteArray = new ByteArray();
            _local_1.writeObject(this);
            return (_local_1.readObject());
        }

        public function set StrengthenLevel(_arg_1:int):void
        {
            this._StrengthenLevel = _arg_1;
        }

        public function get StrengthenLevel():int
        {
            return (this._StrengthenLevel);
        }

        public function set StrengthenExp(_arg_1:int):void
        {
            this._StrengthenExp = _arg_1;
        }

        public function get StrengthenExp():int
        {
            return (this._StrengthenExp);
        }

        public function get isGold():Boolean
        {
            return (this._isGold);
        }

        public function set isGold(_arg_1:Boolean):void
        {
            this._isGold = _arg_1;
        }

        public function get goldValidDate():int
        {
            return (this._goldValidDate);
        }

        public function set goldValidDate(_arg_1:int):void
        {
            this._goldValidDate = _arg_1;
        }

        public function get goldBeginTime():String
        {
            return (this._goldBeginTime);
        }

        public function set goldBeginTime(_arg_1:String):void
        {
            this._goldBeginTime = _arg_1;
        }

        public function getGoldRemainDate():Number
        {
            var _local_1:Date = DateUtils.getDateByStr(this._goldBeginTime);
            var _local_2:Number = TimeManager.Instance.TotalDaysToNow(_local_1);
            _local_2 = ((_local_2 < 0) ? 0 : _local_2);
            return (this.goldValidDate - _local_2);
        }


    }
}//package ddt.data.goods

