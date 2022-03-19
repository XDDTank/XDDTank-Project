// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.BasePlayer

package ddt.data.player
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import ddt.manager.PathManager;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.sendToURL;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.Experience;
    import ddt.manager.StateManager;
    import ddt.events.PlayerPropertyEvent;

    [Event(name="propertychange", type="ddt.events.PlayerPropertyEvent")]
    [Event(name="gold_change", type="tank.data.player.PlayerPropertyEvent")]
    public class BasePlayer extends EventDispatcher 
    {

        public static const BADGE_ID:String = "badgeid";
        public static const JUNIOR_VIP:int = 1;
        public static const SENIOR_VIP:int = 2;

        private var _zoneID:int;
        private var _ID:Number;
        public var LoginName:String;
        protected var _nick:String;
        public var Sex:Boolean;
        public var WinCount:int;
        public var EscapeCount:int;
        private var _totalCount:int = 0;
        private var _repute:int;
        private var _grade:int;
        private var _IsUpGrade:Boolean;
        public var isUpGradeInGame:Boolean = false;
        private var _fightPower:int;
        private var _matchInfo:MatchInfo;
        private var _leagueFirst:Boolean;
        private var _lasetWeekScore:Number;
        private var _CardSoul:int;
        private var _gP:int;
        private var _magicSoul:int;
        private var _offer:int;
        private var _sign:Boolean;
        private var _state:PlayerState;
        private var _VIPtype:int = 0;
        public var VIPLevel:int = 1;
        public var VIPExp:int;
        private var _isFightVip:Boolean;
        private var _fightVipLevel:int = 1;
        private var _fightToolBoxSkillNum:int;
        private var _honor:String = "";
        private var _achievementPoint:int;
        private var _isMarried:Boolean;
        public var SpouseID:int;
        private var _spouseName:String;
        public var ConsortiaID:int = 0;
        public var ConsortiaName:String;
        public var DutyLevel:int;
        private var _dutyName:String;
        private var _right:int;
        private var _RichesRob:int;
        private var _RichesOffer:int;
        private var _UseOffer:int;
        private var _beforeOffer:int;
        private var _badgeID:int = 0;
        private var _apprenticeshipState:int;
        public var LastLoginDate:Date;
        protected var _changeCount:int = 0;
        protected var _changedPropeties:Dictionary = new Dictionary();
        protected var _lastValue:Dictionary = new Dictionary();
        protected var _isOld:Boolean = false;


        public function set ZoneID(_arg_1:int):void
        {
            this._zoneID = _arg_1;
        }

        public function get ZoneID():int
        {
            return (this._zoneID);
        }

        public function get ID():Number
        {
            return (this._ID);
        }

        public function set ID(_arg_1:Number):void
        {
            this._ID = _arg_1;
        }

        public function set NickName(_arg_1:String):void
        {
            this._nick = _arg_1;
        }

        public function get NickName():String
        {
            return (this._nick);
        }

        public function get SexByInt():int
        {
            if (this.Sex)
            {
                return (1);
            };
            return (2);
        }

        public function set SexByInt(_arg_1:int):void
        {
        }

        public function get TotalCount():int
        {
            return (this._totalCount);
        }

        public function set TotalCount(_arg_1:int):void
        {
            if (((this._totalCount == _arg_1) || (_arg_1 <= 0)))
            {
                return;
            };
            if (((this._totalCount == (_arg_1 - 1)) || (this._totalCount == (_arg_1 - 2))))
            {
                this.onPropertiesChanged("TotalCount");
            };
            this._totalCount = _arg_1;
        }

        public function get Repute():int
        {
            return (this._repute);
        }

        public function set Repute(_arg_1:int):void
        {
            if (((this._repute == _arg_1) || (_arg_1 <= 0)))
            {
                return;
            };
            this._repute = _arg_1;
            this.onPropertiesChanged("Repute");
        }

        public function get Grade():int
        {
            return (this._grade);
        }

        public function set Grade(_arg_1:int):void
        {
            if (((this._grade == _arg_1) || (_arg_1 <= 0)))
            {
                return;
            };
            if (((!(this._grade == 0)) && (this._grade < _arg_1)))
            {
                this.IsUpGrade = true;
            };
            this._grade = _arg_1;
            this.onPropertiesChanged("Grade");
        }

        public function get IsUpGrade():Boolean
        {
            return (this._IsUpGrade);
        }

        public function set IsUpGrade(_arg_1:Boolean):void
        {
            this._IsUpGrade = _arg_1;
            this.noticeGrade();
        }

        private function noticeGrade():void
        {
            if ((!(this.IsUpGrade)))
            {
                return;
            };
            var _local_1:String = PathManager.solveGradeNotificationPath(this.Grade);
            if (_local_1 == null)
            {
                return;
            };
            var _local_2:URLRequest = new URLRequest(_local_1);
            var _local_3:URLVariables = new URLVariables();
            _local_3["grade"] = this.Grade;
            _local_2.data = _local_3;
            sendToURL(_local_2);
        }

        public function get FightPower():int
        {
            return (this._fightPower);
        }

        public function get matchInfo():MatchInfo
        {
            if (this._matchInfo == null)
            {
                this._matchInfo = new MatchInfo();
            };
            return (this._matchInfo);
        }

        public function set matchInfo(_arg_1:MatchInfo):void
        {
            if (this._matchInfo == _arg_1)
            {
                return;
            };
            ObjectUtils.copyProperties(this.matchInfo, _arg_1);
            this.onPropertiesChanged("matchInfo");
        }

        public function get DailyLeagueFirst():Boolean
        {
            return (this._leagueFirst);
        }

        public function set DailyLeagueFirst(_arg_1:Boolean):void
        {
            if (this._leagueFirst == _arg_1)
            {
                return;
            };
            this._leagueFirst = _arg_1;
            this.onPropertiesChanged("DailyLeagueFirst");
        }

        public function get DailyLeagueLastScore():Number
        {
            return (this._lasetWeekScore);
        }

        public function set DailyLeagueLastScore(_arg_1:Number):void
        {
            if (this._lasetWeekScore == _arg_1)
            {
                return;
            };
            this._lasetWeekScore = _arg_1;
            this.onPropertiesChanged("DailyLeagueLastScore");
        }

        public function set FightPower(_arg_1:int):void
        {
            if (this._fightPower == _arg_1)
            {
                return;
            };
            this._fightPower = _arg_1;
            this.onPropertiesChanged("FightPower");
        }

        public function get CardSoul():int
        {
            return (this._CardSoul);
        }

        public function set CardSoul(_arg_1:int):void
        {
            this._CardSoul = _arg_1;
            this.onPropertiesChanged("CardSoul");
            this.updateProperties();
        }

        public function get GP():int
        {
            return (this._gP);
        }

        public function set GP(_arg_1:int):void
        {
            if (this._gP == _arg_1)
            {
                return;
            };
            this._gP = _arg_1;
            this.Grade = Experience.getGrade(this._gP);
            this.onPropertiesChanged("GP");
        }

        public function get magicSoul():int
        {
            return (this._magicSoul);
        }

        public function set magicSoul(_arg_1:int):void
        {
            this._magicSoul = _arg_1;
        }

        public function get Offer():int
        {
            return (this._offer);
        }

        public function set Offer(_arg_1:int):void
        {
            if (this._offer == _arg_1)
            {
                return;
            };
            this._offer = _arg_1;
            this.onPropertiesChanged("Offer");
        }

        public function get Sign():Boolean
        {
            return (this._sign);
        }

        public function set Sign(_arg_1:Boolean):void
        {
            if (this._sign == _arg_1)
            {
                return;
            };
            this._sign = _arg_1;
            this.onPropertiesChanged("Sign");
        }

        public function get playerState():PlayerState
        {
            if (this._state == null)
            {
                this._state = new PlayerState(PlayerState.ONLINE);
            };
            return (this._state);
        }

        public function set playerState(_arg_1:PlayerState):void
        {
            if (this._state == _arg_1)
            {
                return;
            };
            if ((((this._state == null) || (this._state.StateID == PlayerState.ONLINE)) || ((!(this._state.StateID == _arg_1.StateID)) && (this._state.Priority <= _arg_1.Priority))))
            {
                this._state = _arg_1;
                this.onPropertiesChanged("State");
            };
        }

        public function get IsVIP():Boolean
        {
            return (this._VIPtype >= 1);
        }

        public function set IsVIP(_arg_1:Boolean):void
        {
            this._VIPtype = int(_arg_1);
        }

        public function set VIPtype(_arg_1:int):void
        {
            if (this._VIPtype == _arg_1)
            {
                return;
            };
            this._VIPtype = _arg_1;
            this.onPropertiesChanged("isVip");
        }

        public function get VIPtype():int
        {
            return (this._VIPtype);
        }

        public function get isFightVip():Boolean
        {
            return (this._isFightVip);
        }

        public function set isFightVip(_arg_1:Boolean):void
        {
            this._isFightVip = _arg_1;
        }

        public function get fightVipLevel():int
        {
            return (this._fightVipLevel);
        }

        public function set fightVipLevel(_arg_1:int):void
        {
            this._fightVipLevel = _arg_1;
        }

        public function get fightToolBoxSkillNum():int
        {
            return (1);
        }

        public function set fightToolBoxSkillNum(_arg_1:int):void
        {
            this._fightToolBoxSkillNum = _arg_1;
        }

        public function get honor():String
        {
            return (this._honor);
        }

        public function set honor(_arg_1:String):void
        {
            if (this._honor == _arg_1)
            {
                return;
            };
            this._honor = _arg_1;
            this.onPropertiesChanged("honor");
        }

        public function get AchievementPoint():int
        {
            return (this._achievementPoint);
        }

        public function set AchievementPoint(_arg_1:int):void
        {
            this._achievementPoint = _arg_1;
        }

        public function set SpouseName(_arg_1:String):void
        {
            if (this._spouseName == _arg_1)
            {
                return;
            };
            this._spouseName = _arg_1;
            this.onPropertiesChanged("SpouseName");
        }

        public function get SpouseName():String
        {
            return (this._spouseName);
        }

        public function set IsMarried(_arg_1:Boolean):void
        {
            if (((_arg_1) && (!(this._isMarried))))
            {
            };
            this._isMarried = _arg_1;
            this.onPropertiesChanged("IsMarried");
        }

        public function get IsMarried():Boolean
        {
            return (this._isMarried);
        }

        public function hasConsortion():Boolean
        {
            return (!(this.ConsortiaID == 0));
        }

        public function get DutyName():String
        {
            return (this._dutyName);
        }

        public function set DutyName(_arg_1:String):void
        {
            if (this._dutyName == _arg_1)
            {
                return;
            };
            this._dutyName = _arg_1;
            this.onPropertiesChanged("dutyName");
        }

        public function get Right():int
        {
            return (this._right);
        }

        public function set Right(_arg_1:int):void
        {
            if (this._right == _arg_1)
            {
                return;
            };
            this._right = _arg_1;
            this.onPropertiesChanged("Right");
        }

        public function get RichesRob():int
        {
            return (this._RichesRob);
        }

        public function set RichesRob(_arg_1:int):void
        {
            if (this._RichesRob == _arg_1)
            {
                return;
            };
            this._RichesRob = _arg_1;
            this.onPropertiesChanged("RichesRob");
        }

        public function get RichesOffer():int
        {
            return (this._RichesOffer);
        }

        public function set RichesOffer(_arg_1:int):void
        {
            if (this._RichesOffer == _arg_1)
            {
                return;
            };
            this._RichesOffer = _arg_1;
            this.onPropertiesChanged("RichesOffer");
        }

        public function get UseOffer():int
        {
            return (this._UseOffer);
        }

        public function set UseOffer(_arg_1:int):void
        {
            if (this._UseOffer == _arg_1)
            {
                return;
            };
            this._UseOffer = _arg_1;
            this.onPropertiesChanged("UseOffer");
        }

        public function get Riches():int
        {
            return (this.RichesOffer + this.RichesRob);
        }

        public function set Riches(_arg_1:int):void
        {
            this.RichesOffer = _arg_1;
        }

        public function get badgeID():int
        {
            return (this._badgeID);
        }

        public function set badgeID(_arg_1:int):void
        {
            if (this._badgeID == _arg_1)
            {
                return;
            };
            this._badgeID = _arg_1;
            this.onPropertiesChanged(BADGE_ID);
        }

        public function set apprenticeshipState(_arg_1:int):void
        {
            this._apprenticeshipState = _arg_1;
        }

        public function get apprenticeshipState():int
        {
            return (this._apprenticeshipState);
        }

        public function beginChanges():void
        {
            this._changeCount++;
        }

        public function commitChanges():void
        {
            this._changeCount--;
            if (this._changeCount <= 0)
            {
                this._changeCount = 0;
                this.updateProperties();
            };
        }

        protected function onPropertiesChanged(_arg_1:String=null):void
        {
            if (_arg_1 != null)
            {
                this._changedPropeties[_arg_1] = true;
            };
            if (this._changeCount <= 0)
            {
                this._changeCount = 0;
                this.updateProperties();
            };
        }

        public function get isOld():Boolean
        {
            return (this._isOld);
        }

        public function set isOld(_arg_1:Boolean):void
        {
            this._isOld = _arg_1;
        }

        public function updateProperties():void
        {
            var _local_1:Dictionary = this._changedPropeties;
            if (((StateManager.isInFight) && (this._changedPropeties["Style"])))
            {
                this._changedPropeties["Style"] = false;
            };
            var _local_2:Dictionary = this._lastValue;
            this._changedPropeties = new Dictionary();
            this._lastValue = new Dictionary();
            dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE, _local_1, _local_2));
        }

        public function get beforeOffer():int
        {
            return (this._beforeOffer);
        }

        public function set beforeOffer(_arg_1:int):void
        {
            if (this._beforeOffer == _arg_1)
            {
                return;
            };
            this._beforeOffer = _arg_1;
            this.onPropertiesChanged("BeforeOffer");
        }


    }
}//package ddt.data.player

