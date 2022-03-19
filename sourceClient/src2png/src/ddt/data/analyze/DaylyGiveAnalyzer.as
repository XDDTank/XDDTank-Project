// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.DaylyGiveAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import road7th.data.DictionaryData;
    import ddt.data.DaylyGiveInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.DailyAwardType;
    import platformapi.tencent.DiamondManager;

    public class DaylyGiveAnalyzer extends DataAnalyzer 
    {

        public var list:Array;
        public var signAwardList:Array;
        public var signAwardCounts:Array;
        public var userAwardLog:int;
        public var awardLen:int;
        private var _xml:XML;
        private var _awardDic:Dictionary;
        public var memberDimondAwardList:DictionaryData;
        public var yearMemberDimondAwardList:DictionaryData;
        public var memberDimondNewHandAwardList:DictionaryData;
        public var bluememberDimondAwardList:DictionaryData;
        public var blueyearMemberDimondAwardList:DictionaryData;
        public var bluememberDimondNewHandAwardList:DictionaryData;
        public var memberQPlusAwardList:DictionaryData;
        public var memberQPlusYearAwardList:DictionaryData;
        public var memberQPlusNewHandAwardList:DictionaryData;
        public var bunAwardList:DictionaryData;
        private var _receiveDic:Array;

        public function DaylyGiveAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XMLList;
            var _local_3:int;
            var _local_4:DaylyGiveInfo;
            var _local_5:DaylyGiveInfo;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:Array;
            var _local_9:Array;
            var _local_10:Array;
            var _local_11:Array;
            this._xml = new XML(_arg_1);
            this.list = new Array();
            this.signAwardList = new Array();
            this._awardDic = new Dictionary(true);
            this.signAwardCounts = new Array();
            this.memberDimondAwardList = new DictionaryData();
            this.yearMemberDimondAwardList = new DictionaryData();
            this.memberDimondNewHandAwardList = new DictionaryData();
            this.bluememberDimondAwardList = new DictionaryData();
            this.blueyearMemberDimondAwardList = new DictionaryData();
            this.bluememberDimondNewHandAwardList = new DictionaryData();
            this.memberQPlusAwardList = new DictionaryData();
            this.memberQPlusYearAwardList = new DictionaryData();
            this.memberQPlusNewHandAwardList = new DictionaryData();
            this.bunAwardList = new DictionaryData();
            this._receiveDic = new Array();
            if (this._xml.@value == "true")
            {
                _local_2 = this._xml..Item;
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_5 = new DaylyGiveInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_2[_local_3]);
                    this._receiveDic.push(_local_5);
                    if (_local_2[_local_3].@GetWay == DailyAwardType.Normal)
                    {
                        _local_4 = new DaylyGiveInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                        this.list.push(_local_4);
                    }
                    else
                    {
                        if (_local_2[_local_3].@GetWay == DailyAwardType.Sign)
                        {
                            _local_4 = new DaylyGiveInfo();
                            ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                            this.signAwardList.push(_local_4);
                            if ((!(this._awardDic[String(_local_2[_local_3].@NeedLevel)])))
                            {
                                this._awardDic[String(_local_2[_local_3].@NeedLevel)] = true;
                                this.signAwardCounts.push(_local_2[_local_3].@NeedLevel);
                            };
                        }
                        else
                        {
                            if (_local_2[_local_3].@GetWay == DailyAwardType.MemberDimondAward)
                            {
                                _local_4 = new DaylyGiveInfo();
                                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                if (this.memberDimondAwardList[_local_4.NeedLevel])
                                {
                                    (this.memberDimondAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                }
                                else
                                {
                                    _local_6 = new Array();
                                    _local_6.push(_local_4);
                                    this.memberDimondAwardList.add(_local_4.NeedLevel, _local_6);
                                };
                            }
                            else
                            {
                                if (_local_2[_local_3].@GetWay == DailyAwardType.YearMemberDimondAward)
                                {
                                    _local_4 = new DaylyGiveInfo();
                                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                    if (this.yearMemberDimondAwardList[_local_4.NeedLevel])
                                    {
                                        (this.yearMemberDimondAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                    }
                                    else
                                    {
                                        _local_7 = new Array();
                                        _local_7.push(_local_4);
                                        this.yearMemberDimondAwardList.add(_local_4.NeedLevel, _local_7);
                                    };
                                }
                                else
                                {
                                    if (_local_2[_local_3].@GetWay == DailyAwardType.MemberDimondNewHandAward)
                                    {
                                        _local_4 = new DaylyGiveInfo();
                                        ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                        this.memberDimondNewHandAwardList.add(_local_4.ID, _local_4);
                                    }
                                    else
                                    {
                                        if (_local_2[_local_3].@GetWay == DailyAwardType.BlueMemberDimondAward)
                                        {
                                            _local_4 = new DaylyGiveInfo();
                                            ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                            if (this.bluememberDimondAwardList[_local_4.NeedLevel])
                                            {
                                                (this.bluememberDimondAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                            }
                                            else
                                            {
                                                _local_8 = new Array();
                                                _local_8.push(_local_4);
                                                this.bluememberDimondAwardList.add(_local_4.NeedLevel, _local_8);
                                            };
                                        }
                                        else
                                        {
                                            if (_local_2[_local_3].@GetWay == DailyAwardType.BlueYearMemberDimondAward)
                                            {
                                                _local_4 = new DaylyGiveInfo();
                                                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                if (this.blueyearMemberDimondAwardList[_local_4.NeedLevel])
                                                {
                                                    (this.blueyearMemberDimondAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                                }
                                                else
                                                {
                                                    _local_9 = new Array();
                                                    _local_9.push(_local_4);
                                                    this.blueyearMemberDimondAwardList.add(_local_4.NeedLevel, _local_9);
                                                };
                                            }
                                            else
                                            {
                                                if (_local_2[_local_3].@GetWay == DailyAwardType.BlueMemberDimondNewHandAward)
                                                {
                                                    _local_4 = new DaylyGiveInfo();
                                                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                    this.bluememberDimondNewHandAwardList.add(_local_4.ID, _local_4);
                                                }
                                                else
                                                {
                                                    if (_local_2[_local_3].@GetWay == DailyAwardType.memberQPlusAward)
                                                    {
                                                        _local_4 = new DaylyGiveInfo();
                                                        ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                        if (this.memberQPlusAwardList[_local_4.NeedLevel])
                                                        {
                                                            (this.memberQPlusAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                                        }
                                                        else
                                                        {
                                                            _local_10 = new Array();
                                                            _local_10.push(_local_4);
                                                            this.memberQPlusAwardList.add(_local_4.NeedLevel, _local_10);
                                                        };
                                                    }
                                                    else
                                                    {
                                                        if (_local_2[_local_3].@GetWay == DailyAwardType.memberQPlusYearAward)
                                                        {
                                                            _local_4 = new DaylyGiveInfo();
                                                            ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                            if (this.memberQPlusYearAwardList[_local_4.NeedLevel])
                                                            {
                                                                (this.memberQPlusYearAwardList[_local_4.NeedLevel] as Array).push(_local_4);
                                                            }
                                                            else
                                                            {
                                                                _local_11 = new Array();
                                                                _local_11.push(_local_4);
                                                                this.memberQPlusYearAwardList.add(_local_4.NeedLevel, _local_11);
                                                            };
                                                        }
                                                        else
                                                        {
                                                            if (_local_2[_local_3].@GetWay == DailyAwardType.memberQPlusNewHandAward)
                                                            {
                                                                _local_4 = new DaylyGiveInfo();
                                                                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                                this.memberQPlusNewHandAwardList.add(_local_4.ID, _local_4);
                                                            }
                                                            else
                                                            {
                                                                if (_local_2[_local_3].@GetWay == DailyAwardType.BunAward)
                                                                {
                                                                    _local_4 = new DaylyGiveInfo();
                                                                    ObjectUtils.copyPorpertiesByXML(_local_4, _local_2[_local_3]);
                                                                    this.bunAwardList.add(_local_4.NeedLevel, _local_4);
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    _local_3++;
                };
                DiamondManager.instance.model.setList(this.memberDimondAwardList, this.yearMemberDimondAwardList, this.memberDimondNewHandAwardList, this.bluememberDimondAwardList, this.blueyearMemberDimondAwardList, this.bluememberDimondNewHandAwardList, this.memberQPlusAwardList, this.memberQPlusYearAwardList, this.memberQPlusNewHandAwardList, this.bunAwardList);
                onAnalyzeComplete();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        public function get awardList():Array
        {
            return (this._receiveDic);
        }


    }
}//package ddt.data.analyze

