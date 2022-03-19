// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.BossBoxManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import ddt.view.bossbox.SmallBoxButton;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import ddt.data.box.BoxGoodsTempInfo;
    import flash.utils.Dictionary;
    import ddt.data.EquipType;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import ddt.data.analyze.UserBoxInfoAnalyzer;
    import ddt.data.analyze.BoxTempInfoAnalyzer;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.geom.Point;
    import flash.events.TimerEvent;
    import ddt.events.PlayerPropertyEvent;
    import road7th.comm.PackageIn;
    import ddt.data.box.TimeBoxInfo;
    import ddt.data.box.GradeBoxInfo;
    import ddt.view.bossbox.AwardsView;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.bossbox.BossBoxView;
    import ddt.view.bossbox.TimeBoxEvent;
    import __AS3__.vec.*;

    public class BossBoxManager extends EventDispatcher 
    {

        public static const GradeBox:int = 1;
        public static const FightLibAwardBox:int = 3;
        public static const SignAward:int = 4;
        private static var _instance:BossBoxManager;
        public static const LOADUSERBOXINFO_COMPLETE:String = "loadUserBoxInfo_complete";
        public static var DataLoaded:Boolean = false;

        private var _time:Timer;
        private var _delayBox:int = 1;
        private var _startDelayTime:Boolean = true;
        private var _isShowGradeBox:Boolean;
        private var _isBoxShowedNow:Boolean = false;
        private var _boxShowArray:Array;
        private var _delaySumTime:int = 0;
        private var _isTimeBoxOver:Boolean = false;
        private var _boxButtonShowType:int = SmallBoxButton.showTypeWait;
        private var _currentGrade:int;
        private var _selectedBoxID:String = null;
        public var timeBoxList:DictionaryData;
        public var gradeBoxList:DictionaryData;
        public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
        public var timeBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
        public var boxTemplateID:Dictionary;
        public var inventoryItemList:DictionaryData;
        public var boxTempIDList:DictionaryData;
        public var beadTempInfoList:DictionaryData;
        public var exploitTemplateIDs:Dictionary;
        private var _isGet:int;
        private var _needTimer:int;
        public var _receieGrade:int;
        public var _needGetBoxTime:int;

        public function BossBoxManager()
        {
            this.setup();
        }

        public static function get instance():BossBoxManager
        {
            if (_instance == null)
            {
                _instance = new (BossBoxManager)();
            };
            return (_instance);
        }


        private function init():void
        {
            this._boxShowArray = new Array();
            this.initExploitTemplateIDs();
        }

        private function initExploitTemplateIDs():void
        {
            this.exploitTemplateIDs = new Dictionary();
            this.exploitTemplateIDs[EquipType.OFFER_PACK_I] = new Vector.<BoxGoodsTempInfo>();
            this.exploitTemplateIDs[EquipType.OFFER_PACK_II] = new Vector.<BoxGoodsTempInfo>();
            this.exploitTemplateIDs[EquipType.OFFER_PACK_III] = new Vector.<BoxGoodsTempInfo>();
            this.exploitTemplateIDs[EquipType.OFFER_PACK_IV] = new Vector.<BoxGoodsTempInfo>();
            this.exploitTemplateIDs[EquipType.OFFER_PACK_V] = new Vector.<BoxGoodsTempInfo>();
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_TIME_BOX, this._getTimeBox);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_TIME_BOX, this._resetTimeBox);
        }

        public function setup():void
        {
            this.init();
            this.initEvent();
        }

        public function setupBoxInfo(_arg_1:UserBoxInfoAnalyzer):void
        {
            this.timeBoxList = _arg_1.timeBoxList;
            this.gradeBoxList = _arg_1.gradeBoxList;
            this.boxTemplateID = _arg_1.boxTemplateID;
            DataLoaded = true;
            dispatchEvent(new Event(BossBoxManager.LOADUSERBOXINFO_COMPLETE));
        }

        public function setupBoxTempInfo(_arg_1:BoxTempInfoAnalyzer):void
        {
            this.inventoryItemList = _arg_1.inventoryItemList;
            this.boxTempIDList = _arg_1.caddyTempIDList;
            this.beadTempInfoList = _arg_1.beadTempInfoList;
            this.caddyBoxGoodsInfo = _arg_1.caddyBoxGoodsInfo;
            this.timeBoxGoodsInfo = _arg_1.timeBoxGoodsInfo;
        }

        public function dropGoodsTemplateId():Array
        {
            var _local_3:int;
            var _local_1:Array = new Array();
            var _local_2:int;
            while (_local_2 < this.timeBoxGoodsInfo.length)
            {
                if (this.timeBoxGoodsInfo[_local_2].ID == this.timeBoxList[this._delayBox].TemplateID)
                {
                    _local_3 = this.timeBoxGoodsInfo[_local_2].TemplateId;
                    _local_1.push(_local_3);
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function dropGoods():void
        {
            var _local_4:ItemTemplateInfo;
            var _local_5:Point;
            var _local_1:Array = new Array();
            var _local_2:Array = this.dropGoodsTemplateId();
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = ItemManager.Instance.getTemplateById(_local_2[_local_3]);
                _local_1.push(_local_4);
                _local_3++;
            };
            if (_local_1.length > 0)
            {
                _local_5 = new Point(64, 230);
                DropGoodsManager.play(_local_1, _local_5);
            };
        }

        public function startDelayTime():void
        {
            this.resetTime();
        }

        private function resetTime():void
        {
            if (this.timeBoxList == null)
            {
                return;
            };
            if ((((this.timeBoxList[this._delayBox]) && (this.startDelayTimeB)) && (this.timeBoxList[this._delayBox].Level >= this.currentGrade)))
            {
                if (this._time)
                {
                    this._time.stop();
                    this._time.removeEventListener(TimerEvent.TIMER, this._timeOne);
                    this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
                    this._time = null;
                };
                if (this._time == null)
                {
                    this.delaySumTime = ((this.timeBoxList[this._delayBox].Condition - this._needTimer) * 60);
                    this._time = new Timer(1000, this.delaySumTime);
                    this._time.start();
                    this._time.addEventListener(TimerEvent.TIMER, this._timeOne);
                    this._time.addEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
                };
                this.boxButtonShowType = SmallBoxButton.showTypeWait;
            };
        }

        public function startGradeChangeEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this._updateGradeII);
        }

        private function _updateGradeII(_arg_1:PlayerPropertyEvent):void
        {
            if (PlayerManager.Instance.Self.Grade > this.currentGrade)
            {
                if (((this.timeBoxList[1]) && (PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)))
                {
                    this.boxButtonShowType = SmallBoxButton.showTypeHide;
                };
            };
        }

        private function _checkeGradeForBox(_arg_1:int, _arg_2:int):Boolean
        {
            this.currentGrade = PlayerManager.Instance.Self.Grade;
            return (this._findGetedBoxGrade(_arg_1, _arg_2));
        }

        public function showSignAward(_arg_1:int, _arg_2:Array):void
        {
            this._showBox(SignAward, _arg_1, _arg_2);
        }

        public function showFightLibAwardBox(_arg_1:int, _arg_2:int, _arg_3:Array):void
        {
            if ((!(StateManager.isInFight)))
            {
                this.isShowGradeBox = false;
                this._showBox(FightLibAwardBox, 1, _arg_3, _arg_1, _arg_2);
            }
            else
            {
                this.isShowGradeBox = true;
            };
        }

        public function showBoxOfGrade():void
        {
            if ((!(StateManager.isInFight)))
            {
                this.isShowGradeBox = false;
                this.showGradeBox();
            }
            else
            {
                this.isShowGradeBox = true;
            };
        }

        private function removeEvent():void
        {
            this._time.removeEventListener(TimerEvent.TIMER, this._timeOne);
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_TIME_BOX, this._getTimeBox);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_TIME_BOX, this._resetTimeBox);
        }

        private function _getTimeBox(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            this._needTimer = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            if (_local_3 == 1)
            {
                this._isGet = 0;
                this._isBoxShowedNow = false;
                this._selectedBoxID = null;
                this.dropGoods();
                this._findBoxIdByTime_II(_local_5);
                this._showOtherBox();
            };
        }

        private function _resetTimeBox(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._needTimer = _local_2.readInt();
            this._isGet = _local_2.readInt();
            this.needGetBoxTime = this._isGet;
            this.receiebox = _local_2.readInt();
        }

        private function _findBoxIdByTime_II(_arg_1:int):void
        {
            var _local_2:TimeBoxInfo;
            var _local_3:TimeBoxInfo;
            for each (_local_3 in this.timeBoxList)
            {
                if (((_local_3.Condition > _arg_1) && (_local_3.Type == 0)))
                {
                    if (_local_2 == null)
                    {
                        _local_2 = _local_3;
                    };
                    if (_local_3.Condition < _local_2.Condition)
                    {
                        _local_2 = _local_3;
                    };
                };
            };
            if (_local_2)
            {
                this._delayBox = _local_2.ID;
                if (this._isGet > 0)
                {
                    return;
                };
                this.delaySumTime = ((this.timeBoxList[this._delayBox].Condition - this._needTimer) * 60);
                if (this._time)
                {
                    this._time.stop();
                    this._time.removeEventListener(TimerEvent.TIMER, this._timeOne);
                    this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
                    this._time = null;
                };
                this._time = new Timer(1000, this.delaySumTime);
                this._time.start();
                this._time.addEventListener(TimerEvent.TIMER, this._timeOne);
                this._time.addEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
                this.startDelayTimeB = true;
                this.boxButtonShowType = SmallBoxButton.showTypeWait;
            }
            else
            {
                this.startDelayTimeB = false;
                this._isTimeBoxOver = true;
                this.boxButtonShowType = SmallBoxButton.showTypeHide;
            };
        }

        private function _findGetedBoxByTime(_arg_1:int):void
        {
            var _local_2:TimeBoxInfo;
            for each (_local_2 in this.timeBoxList)
            {
                if (_arg_1 == _local_2.Condition)
                {
                    this._delayBox = _local_2.ID;
                    if (this.timeBoxList[this._delayBox])
                    {
                        this.startDelayTimeB = true;
                    }
                    else
                    {
                        this.startDelayTimeB = false;
                    };
                    return;
                };
            };
        }

        private function _findGetedBoxGrade(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_4:GradeBoxInfo;
            var _local_3:Boolean;
            for each (_local_4 in this.gradeBoxList)
            {
                if (PlayerManager.Instance.Self.Sex)
                {
                    if ((((_local_4.Level > _arg_1) && (_local_4.Level <= _arg_2)) && (_local_4.Condition)))
                    {
                        if (this._boxShowArray.indexOf((_local_4.ID + ",grade")) == -1)
                        {
                            this._boxShowArray.push((_local_4.ID + ",grade"));
                        };
                        _local_3 = true;
                    };
                }
                else
                {
                    if ((((_local_4.Level > _arg_1) && (_local_4.Level <= _arg_2)) && (!(_local_4.Condition))))
                    {
                        if (this._boxShowArray.indexOf((_local_4.ID + ",grade")) == -1)
                        {
                            this._boxShowArray.push((_local_4.ID + ",grade"));
                        };
                        _local_3 = true;
                    };
                };
            };
            return (_local_3);
        }

        private function _showOtherBox():void
        {
            var _local_1:int;
            while (_local_1 < this._boxShowArray.length)
            {
                if (String(this._boxShowArray[_local_1]).indexOf("grade") > 0)
                {
                    this.showGradeBox();
                    return;
                };
                _local_1++;
            };
        }

        private function _timeOver(_arg_1:TimerEvent):void
        {
            this._time.stop();
            this._time.removeEventListener(TimerEvent.TIMER, this._timeOne);
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timeOver);
            this._time = null;
            if (this.timeBoxList[this._delayBox])
            {
                this._boxShowArray.push((this._delayBox + ",time"));
                this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
                SocketManager.Instance.out.sendGetTimeBox(0, this.timeBoxList[this._delayBox].Condition);
            };
        }

        private function _timeOne(_arg_1:TimerEvent):void
        {
            this.delaySumTime--;
        }

        private function _getShowBoxID(_arg_1:String):int
        {
            var _local_3:int;
            var _local_2:int;
            while (_local_2 < this._boxShowArray.length)
            {
                if (String(this._boxShowArray[_local_2]).indexOf(_arg_1) > 0)
                {
                    _local_3 = String(this._boxShowArray[_local_2]).split(",")[0];
                    this._selectedBoxID = this._boxShowArray.splice(_local_2, 1);
                    return (_local_3);
                };
                _local_2++;
            };
            return (0);
        }

        public function getBoxTemplateIDById():int
        {
            return (this.timeBoxList[this._delayBox].TemplateID);
        }

        public function showTimeBox():void
        {
            var _local_1:int;
            var _local_2:AwardsView;
            if ((!(this._isBoxShowedNow)))
            {
                _local_1 = this._getShowBoxID("time");
                if (_local_1 != 0)
                {
                    this._showBox(0, _local_1, this.inventoryItemList[this.timeBoxList[_local_1].TemplateID]);
                }
                else
                {
                    _local_2 = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
                    _local_2.boxType = 0;
                    _local_2.goodsList = this.inventoryItemList[this.timeBoxList[this._delayBox].TemplateID];
                    _local_2.setCheck();
                    LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                };
            };
        }

        public function showGradeBox():void
        {
        }

        public function _showBox(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int=-1, _arg_5:int=-1):void
        {
            this._isBoxShowedNow = true;
            LayerManager.Instance.addToLayer(new BossBoxView(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5), LayerManager.GAME_DYNAMIC_LAYER);
        }

        public function showOtherGradeBox():void
        {
            this._isBoxShowedNow = false;
            this._showOtherBox();
        }

        public function isShowBoxButton():Boolean
        {
            if (((this.timeBoxList == null) || (PlayerManager.Instance.Self.Grade < 8)))
            {
                return (false);
            };
            if (((PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level) || (this._isTimeBoxOver)))
            {
                return (false);
            };
            return (true);
        }

        public function deleteBoxButton():void
        {
            this.stopShowTimeBox(this._delayBox);
        }

        public function stopShowTimeBox(_arg_1:int):void
        {
            if (((this._isBoxShowedNow) && (!(this._selectedBoxID == null))))
            {
                this._boxShowArray.push(this._selectedBoxID);
            };
            this._isBoxShowedNow = false;
        }

        public function set receieGrade(_arg_1:int):void
        {
            this._receieGrade = _arg_1;
            if (this._findGetedBoxGrade(this._receieGrade, PlayerManager.Instance.Self.Grade))
            {
                this.isShowGradeBox = true;
            };
        }

        public function set needGetBoxTime(_arg_1:int):void
        {
            this._needGetBoxTime = _arg_1;
            if (this._needGetBoxTime > 0)
            {
                this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
            };
        }

        public function set receiebox(_arg_1:int):void
        {
            this._findBoxIdByTime_II(_arg_1);
        }

        public function set isShowGradeBox(_arg_1:Boolean):void
        {
            this._isShowGradeBox = _arg_1;
        }

        public function get isShowGradeBox():Boolean
        {
            return (this._isShowGradeBox);
        }

        public function set currentGrade(_arg_1:int):void
        {
            var _local_2:TimeBoxInfo;
            this._currentGrade = _arg_1;
            for each (_local_2 in this.timeBoxList)
            {
                if (this._currentGrade > _local_2.Level)
                {
                };
            };
        }

        public function get currentGrade():int
        {
            return (this._currentGrade);
        }

        public function set boxButtonShowType(_arg_1:int):void
        {
            this._boxButtonShowType = _arg_1;
            var _local_2:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE);
            _local_2.boxButtonShowType = this._boxButtonShowType;
            dispatchEvent(_local_2);
        }

        public function get boxButtonShowType():int
        {
            return (this._boxButtonShowType);
        }

        public function set delaySumTime(_arg_1:int):void
        {
            this._delaySumTime = _arg_1;
            var _local_2:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATETIMECOUNT);
            _local_2.delaySumTime = this._delaySumTime;
            dispatchEvent(_local_2);
        }

        public function isHaveBox():Boolean
        {
            if (this.timeBoxList[this._delayBox])
            {
                return (true);
            };
            return (false);
        }

        public function get delaySumTime():int
        {
            return (this._delaySumTime);
        }

        public function set startDelayTimeB(_arg_1:Boolean):void
        {
            this._startDelayTime = _arg_1;
        }

        public function get startDelayTimeB():Boolean
        {
            return (this._startDelayTime);
        }


    }
}//package ddt.manager

