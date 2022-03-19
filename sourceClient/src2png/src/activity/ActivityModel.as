// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.ActivityModel

package activity
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import road7th.data.DictionaryData;
    import activity.data.ConditionRecord;
    import activity.data.ActivityGiftbagRecord;
    import activity.data.ActivityTuanInfo;

    public class ActivityModel extends EventDispatcher 
    {

        private var _eventActives:Array;
        private var _activeExchange:Array;
        private var _activityInfoArr:Array;
        private var _activityConditionArr:Array;
        private var _activityGiftbagArr:Array;
        private var _activityRewards:Array;
        private var _nowState:Dictionary = new Dictionary();
        private var _condtionRecords:DictionaryData = new DictionaryData();
        private var _log:Dictionary = new Dictionary();
        private var _giftbagRecordDic:DictionaryData = new DictionaryData();
        private var _tuanInfoDic:DictionaryData = new DictionaryData();
        private var _showID:String = "";


        public function get eventActives():Array
        {
            return (this._eventActives);
        }

        public function set eventActives(_arg_1:Array):void
        {
            this._eventActives = _arg_1;
        }

        public function get activeExchange():Array
        {
            return (this._activeExchange);
        }

        public function set activeExchange(_arg_1:Array):void
        {
            this._activeExchange = _arg_1;
        }

        public function get activityInfoArr():Array
        {
            return (this._activityInfoArr);
        }

        public function set activityInfoArr(_arg_1:Array):void
        {
            this._activityInfoArr = _arg_1;
            dispatchEvent(new ActivityEvent(ActivityEvent.ACTIVITY_UPDATE));
        }

        public function get activityConditionArr():Array
        {
            return (this._activityConditionArr);
        }

        public function set activityConditionArr(_arg_1:Array):void
        {
            this._activityConditionArr = _arg_1;
        }

        public function get activityGiftbagArr():Array
        {
            return (this._activityGiftbagArr);
        }

        public function set activityGiftbagArr(_arg_1:Array):void
        {
            this._activityGiftbagArr = _arg_1;
        }

        public function get activityRewards():Array
        {
            return (this._activityRewards);
        }

        public function set activityRewards(_arg_1:Array):void
        {
            this._activityRewards = _arg_1;
        }

        public function getState(_arg_1:String):int
        {
            if ((!(this._nowState[_arg_1])))
            {
                this._nowState[_arg_1] = 0;
            };
            return (this._nowState[_arg_1]);
        }

        public function addNowState(_arg_1:String, _arg_2:int):void
        {
            this._nowState[_arg_1] = _arg_2;
        }

        public function addcondtionRecords(_arg_1:String, _arg_2:String):void
        {
            var _local_4:Array;
            var _local_5:ConditionRecord;
            var _local_7:String;
            _arg_2 = ((_arg_2 == null) ? "" : _arg_2);
            var _local_3:Array = _arg_2.split(",");
            var _local_6:Array = new Array();
            for each (_local_7 in _local_3)
            {
                _local_4 = _local_7.split("|");
                _local_5 = new ConditionRecord(_local_4[0], _local_4[1], _local_4[2]);
                _local_6.push(_local_5);
            };
            this._condtionRecords.add(_arg_1, _local_6);
        }

        public function getConditionRecord(_arg_1:String, _arg_2:int):ConditionRecord
        {
            var _local_4:ConditionRecord;
            var _local_3:Array = this._condtionRecords[_arg_1];
            for each (_local_4 in _local_3)
            {
                if (_local_4.conditionIndex == _arg_2)
                {
                    return (_local_4);
                };
            };
            return (null);
        }

        public function getLog(_arg_1:String):int
        {
            if ((!(this._log[_arg_1])))
            {
                this._log[_arg_1] = 0;
            };
            return (this._log[_arg_1]);
        }

        public function addLog(_arg_1:String, _arg_2:int):void
        {
            this._log[_arg_1] = _arg_2;
        }

        public function addGiftbagRecord(_arg_1:String, _arg_2:DictionaryData):void
        {
            this._giftbagRecordDic.add(_arg_1, _arg_2);
        }

        public function getGiftbagRecordByID(_arg_1:String, _arg_2:int):ActivityGiftbagRecord
        {
            var _local_3:ActivityGiftbagRecord;
            if (((this._giftbagRecordDic[_arg_1] == null) || (this._giftbagRecordDic[_arg_1][_arg_2] == null)))
            {
                _local_3 = new ActivityGiftbagRecord();
                _local_3.index = _arg_2;
                _local_3.value = 0;
                return (_local_3);
            };
            return (this._giftbagRecordDic[_arg_1][_arg_2]);
        }

        public function addTuanInfo(_arg_1:String, _arg_2:ActivityTuanInfo):void
        {
            this._tuanInfoDic.add(_arg_1, _arg_2);
        }

        public function getTuanInfoByID(_arg_1:String):ActivityTuanInfo
        {
            return (this._tuanInfoDic[_arg_1]);
        }

        public function get showID():String
        {
            return (this._showID);
        }

        public function set showID(_arg_1:String):void
        {
            this._showID = _arg_1;
        }


    }
}//package activity

