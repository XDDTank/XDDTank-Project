// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.model.WorldBossInfo

package worldboss.model
{
    import flash.events.EventDispatcher;
    import worldboss.player.PlayerVO;
    import flash.geom.Point;
    import flash.events.Event;
    import ddt.manager.TimeManager;

    public class WorldBossInfo extends EventDispatcher 
    {

        private var _total_Blood:Number;
        private var _current_Blood:Number;
        private var _isLiving:Boolean;
        private var _begin_time:Date;
        private var _fight_time:int;
        private var _end_time:Date;
        private var _fightOver:Boolean;
        private var _room_close:Boolean;
        private var _currentState:int = 0;
        private var _ticketID:int;
        private var _need_ticket_count:int;
        private var _cutValue:Number;
        private var _name:String;
        private var _timeCD:int;
        private var _reviveMoney:int;
        private var _reFightMoney:int;
        private var _addInjureBuffMoney:int;
        private var _addInjureValue:int;
        private var _myPlayerVO:PlayerVO;
        private var _playerDefaultPos:Point;
        private var _buffArray:Array = new Array();


        public function set total_Blood(_arg_1:Number):void
        {
            this._total_Blood = _arg_1;
        }

        public function get total_Blood():Number
        {
            return (this._total_Blood);
        }

        public function set current_Blood(_arg_1:Number):void
        {
            if (this._current_Blood == _arg_1)
            {
                this._cutValue = -1;
                return;
            };
            this._cutValue = (this._current_Blood - _arg_1);
            this._current_Blood = _arg_1;
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get current_Blood():Number
        {
            return (this._current_Blood);
        }

        public function set isLiving(_arg_1:Boolean):void
        {
            this._isLiving = _arg_1;
            if ((!(this._isLiving)))
            {
                this.current_Blood = 0;
            };
        }

        public function get isLiving():Boolean
        {
            return (this._isLiving);
        }

        public function get begin_time():Date
        {
            return (this._begin_time);
        }

        public function set begin_time(_arg_1:Date):void
        {
            this._begin_time = _arg_1;
        }

        public function get end_time():Date
        {
            return (this._end_time);
        }

        public function set end_time(_arg_1:Date):void
        {
            this._end_time = _arg_1;
        }

        public function get fight_time():int
        {
            return (this._fight_time);
        }

        public function set fight_time(_arg_1:int):void
        {
            this._fight_time = _arg_1;
        }

        public function getLeftTime():int
        {
            var _local_1:Number = TimeManager.Instance.TotalSecondToNow(this.begin_time);
            if (((_local_1 > 0) && (_local_1 < (this.fight_time * 60))))
            {
                return ((this.fight_time * 60) - _local_1);
            };
            return (0);
        }

        public function get fightOver():Boolean
        {
            return (this._fightOver);
        }

        public function set fightOver(_arg_1:Boolean):void
        {
            this._fightOver = _arg_1;
        }

        public function get roomClose():Boolean
        {
            return (this._room_close);
        }

        public function set roomClose(_arg_1:Boolean):void
        {
            this._room_close = _arg_1;
        }

        public function get currentState():int
        {
            return (this._currentState);
        }

        public function set currentState(_arg_1:int):void
        {
            this._currentState = _arg_1;
        }

        public function set ticketID(_arg_1:int):void
        {
            this._ticketID = _arg_1;
        }

        public function get ticketID():int
        {
            return (this._ticketID);
        }

        public function set need_ticket_count(_arg_1:int):void
        {
            this._need_ticket_count = _arg_1;
        }

        public function get need_ticket_count():int
        {
            return (this._need_ticket_count);
        }

        public function get cutValue():Number
        {
            return (this._cutValue);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set timeCD(_arg_1:int):void
        {
            this._timeCD = _arg_1;
        }

        public function get timeCD():int
        {
            return (this._timeCD);
        }

        public function set reviveMoney(_arg_1:int):void
        {
            this._reviveMoney = _arg_1;
        }

        public function get reviveMoney():int
        {
            return (this._reviveMoney);
        }

        public function get buffArray():Array
        {
            return (this._buffArray);
        }

        public function getbuffInfoByID(_arg_1:int):WorldBossBuffInfo
        {
            var _local_2:int;
            while (_local_2 < this._buffArray.length)
            {
                if (_arg_1 == (this._buffArray[_local_2] as WorldBossBuffInfo).ID)
                {
                    return (this._buffArray[_local_2]);
                };
                _local_2++;
            };
            return (new WorldBossBuffInfo());
        }

        public function set myPlayerVO(_arg_1:PlayerVO):void
        {
            this._myPlayerVO = _arg_1;
        }

        public function get myPlayerVO():PlayerVO
        {
            return (this._myPlayerVO);
        }

        public function set playerDefaultPos(_arg_1:Point):void
        {
            this._playerDefaultPos = _arg_1;
        }

        public function get playerDefaultPos():Point
        {
            return (this._playerDefaultPos);
        }

        public function get reFightMoney():int
        {
            return (this._reFightMoney);
        }

        public function set reFightMoney(_arg_1:int):void
        {
            this._reFightMoney = _arg_1;
        }

        public function get addInjureBuffMoney():int
        {
            return (this._addInjureBuffMoney);
        }

        public function set addInjureBuffMoney(_arg_1:int):void
        {
            this._addInjureBuffMoney = _arg_1;
        }

        public function get addInjureValue():int
        {
            return (this._addInjureValue);
        }

        public function set addInjureValue(_arg_1:int):void
        {
            this._addInjureValue = _arg_1;
        }


    }
}//package worldboss.model

