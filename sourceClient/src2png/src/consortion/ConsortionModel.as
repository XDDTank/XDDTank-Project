// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.ConsortionModel

package consortion
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import ddt.data.ConsortiaInfo;
    import consortion.data.ConsortiaApplyInfo;
    import consortion.data.ConsortiaInventData;
    import ddt.data.ConsortiaEventInfo;
    import consortion.data.ConsortiaAssetLevelOffer;
    import consortion.data.ConsortiaDutyInfo;
    import consortion.data.ConsortionPollInfo;
    import consortion.data.ConsortionSkillInfo;
    import consortion.data.ConsortionNewSkillInfo;
    import consortion.data.ConsortionProbabilityInfo;
    import consortion.data.ConsortiaLevelInfo;
    import flash.events.IEventDispatcher;
    import consortion.event.ConsortionEvent;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.data.player.PlayerState;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import consortion.transportSence.TransportCarInfo;
    import consortion.transportSence.TransportCar;
    import ddt.data.BuffInfo;
    import ddt.manager.TimeManager;
    import ddt.manager.ServerConfigManager;
    import __AS3__.vec.*;

    public class ConsortionModel extends EventDispatcher 
    {

        public static const CONSORTION_MAX_LEVEL:int = 10;
        public static const SHOP_MAX_LEVEL:int = 10;
        public static const STORE_MAX_LEVEL:int = 10;
        public static const BANK_MAX_LEVEL:int = 10;
        public static const SKILL_MAX_LEVEL:int = 10;
        public static const LEVEL:int = 0;
        public static const SHOP:int = 1;
        public static const SKILL:int = 2;
        public static const TASKLEVELI:int = 11;
        public static const TASKLEVELII:int = 12;
        public static const TASKLEVELIII:int = 13;
        public static const TASKLEVELIV:int = 14;
        public static const CONSORTION_TASK:int = 1;
        public static const CONSORTION_CONVOY:int = 2;
        public static const MONSTER_REFLASH:int = 3;
        public static const CONSORTION_SENCE:int = 0;
        public static const CONSORTION_TRANSPORT:int = 1;
        public static const CONSORTION_SKILL:int = 1;
        public static const PERSONAL_SKILL:int = 2;
        public static const CLUB:String = "consortiaClub";
        public static const SELF_CONSORTIA:String = "selfConsortia";
        public static const ConsortionListEachPageNum:int = 6;
        public static var TaskRewardSontribution1:int;
        public static var TaskRewardExp1:int;
        public static var TaskRewardSontribution2:int;
        public static var TaskRewardExp2:int;
        public static var TaskRewardSontribution3:int;
        public static var TaskRewardExp3:int;
        public static var TaskRewardSontribution4:int;
        public static var TaskRewardExp4:int;
        public static var REMAIN_CONVOY_TIME:int = 0;
        public static var REMAIN_GUARD_TIME:int = 0;
        public static var REMAIN_HIJACK_TIME:int = 0;
        public static var TASK_CAN_ACCEPT_TIME:int = 86400000;

        public var systemDate:String;
        private var _memberList:DictionaryData;
        private var _consortionList:Vector.<ConsortiaInfo>;
        public var consortionsListTotalCount:int;
        private var _readyApplyList:Vector.<ConsortiaInfo>;
        private var _myApplyList:Vector.<ConsortiaApplyInfo>;
        public var applyListTotalCount:int;
        private var _inventList:Vector.<ConsortiaInventData>;
        public var inventListTotalCount:int;
        private var _eventList:Vector.<ConsortiaEventInfo>;
        private var _useConditionList:Vector.<ConsortiaAssetLevelOffer>;
        private var _dutyList:Vector.<ConsortiaDutyInfo>;
        private var _pollList:Vector.<ConsortionPollInfo>;
        private var _skillInfoList:Vector.<ConsortionSkillInfo>;
        private var _newSkillInfo:Vector.<ConsortionNewSkillInfo>;
        private var _probabiliInfo:Vector.<ConsortionProbabilityInfo>;
        private var _levelUpData:Vector.<ConsortiaLevelInfo>;
        private var _currentTaskLevel:int = 11;
        private var _remainPublishTime:int;
        private var _lastPublishDate:Date;
        private var _canAcceptTask:Boolean;
        private var _isMaster:Boolean;
        private var _receivedQuestCount:int;
        private var _consortiaQuestCount:int;
        private var _shinePlay:Boolean = false;

        public function ConsortionModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function get memberList():DictionaryData
        {
            if (this._memberList == null)
            {
                this._memberList = new DictionaryData();
            };
            return (this._memberList);
        }

        public function set memberList(_arg_1:DictionaryData):void
        {
            if (this._memberList == _arg_1)
            {
                return;
            };
            this._memberList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBERLIST_COMPLETE));
        }

        public function addMember(_arg_1:ConsortiaPlayerInfo):void
        {
            this._memberList.add(_arg_1.ID, _arg_1);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_ADD, _arg_1));
        }

        public function removeMember(_arg_1:ConsortiaPlayerInfo):void
        {
            this._memberList.remove(_arg_1.ID);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_REMOVE, _arg_1));
        }

        public function updataMember(_arg_1:ConsortiaPlayerInfo):void
        {
            this._memberList.add(_arg_1.ID, _arg_1);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.MEMBER_UPDATA, _arg_1));
        }

        public function get onlineConsortiaMemberList():Array
        {
            var _local_2:ConsortiaPlayerInfo;
            var _local_1:Array = [];
            for each (_local_2 in this.memberList)
            {
                if (_local_2.playerState.StateID != PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function getConsortiaMemberInfo(_arg_1:int):ConsortiaPlayerInfo
        {
            var _local_2:ConsortiaPlayerInfo;
            for each (_local_2 in this.memberList)
            {
                if (_local_2.ID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function get offlineConsortiaMemberList():Array
        {
            var _local_2:ConsortiaPlayerInfo;
            var _local_1:Array = [];
            for each (_local_2 in this.memberList)
            {
                if (_local_2.playerState.StateID == PlayerState.OFFLINE)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function get ViceChairmanConsortiaMemberList():Vector.<ConsortiaPlayerInfo>
        {
            var _local_2:ConsortiaPlayerInfo;
            var _local_1:Vector.<ConsortiaPlayerInfo> = new Vector.<ConsortiaPlayerInfo>();
            for each (_local_2 in this.memberList)
            {
                if (_local_2.DutyLevel == 2)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function consortiaPlayerStateChange(_arg_1:int, _arg_2:int):void
        {
            var _local_4:PlayerState;
            var _local_3:ConsortiaPlayerInfo = this.getConsortiaMemberInfo(_arg_1);
            if (_local_3 == null)
            {
                return;
            };
            if (_local_3)
            {
                _local_4 = new PlayerState(_arg_2);
                _local_3.playerState = _local_4;
                this.updataMember(_local_3);
            };
        }

        public function set consortionList(_arg_1:Vector.<ConsortiaInfo>):void
        {
            if (this._consortionList == _arg_1)
            {
                return;
            };
            this._consortionList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
        }

        public function get consortionList():Vector.<ConsortiaInfo>
        {
            return (this._consortionList);
        }

        public function set readyApplyList(_arg_1:Vector.<ConsortiaInfo>):void
        {
            if (this._readyApplyList == _arg_1)
            {
                return;
            };
            this._readyApplyList = _arg_1;
        }

        public function get readyApplyList():Vector.<ConsortiaInfo>
        {
            return (this._readyApplyList);
        }

        public function set myApplyList(_arg_1:Vector.<ConsortiaApplyInfo>):void
        {
            var _local_2:Vector.<ConsortiaInfo>;
            var _local_3:int;
            var _local_4:ConsortiaInfo;
            if (this._myApplyList == _arg_1)
            {
                return;
            };
            this._myApplyList = _arg_1;
            if (this.consortionList)
            {
                _local_2 = new Vector.<ConsortiaInfo>();
                while (_local_3 < _arg_1.length)
                {
                    _local_4 = this.getConosrionByID(_arg_1[_local_3].ConsortiaID);
                    _local_2.push(_local_4);
                    _local_3++;
                };
                this.readyApplyList = _local_2;
            };
            dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
        }

        public function get myApplyList():Vector.<ConsortiaApplyInfo>
        {
            return (this._myApplyList);
        }

        public function getapplyListWithPage(_arg_1:int, _arg_2:int=10):Vector.<ConsortiaApplyInfo>
        {
            _arg_1 = ((_arg_1 < 0) ? 1 : ((_arg_1 > Math.ceil((this._myApplyList.length / _arg_2))) ? int(Math.ceil((this._myApplyList.length / _arg_2))) : _arg_1));
            return (this.myApplyList.slice(((_arg_1 - 1) * _arg_2), (_arg_1 * _arg_2)));
        }

        public function getconsrotionListWithPage(_arg_1:int, _arg_2:int=10):Vector.<ConsortiaInfo>
        {
            _arg_1 = ((_arg_1 < 0) ? 1 : ((_arg_1 > Math.ceil((this._consortionList.length / _arg_2))) ? int(Math.ceil((this._consortionList.length / _arg_2))) : _arg_1));
            return (this._consortionList.slice(((_arg_1 - 1) * _arg_2), (_arg_1 * _arg_2)));
        }

        public function getreadApplyconsrotionListWithPage(_arg_1:int, _arg_2:int=10):Vector.<ConsortiaInfo>
        {
            _arg_1 = ((_arg_1 < 0) ? 1 : ((_arg_1 > Math.ceil((this._readyApplyList.length / _arg_2))) ? int(Math.ceil((this._readyApplyList.length / _arg_2))) : _arg_1));
            return (this._readyApplyList.slice(((_arg_1 - 1) * _arg_2), (_arg_1 * _arg_2)));
        }

        public function deleteOneApplyRecord(_arg_1:int):void
        {
            var _local_2:int = this.myApplyList.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (this.myApplyList[_local_3].ID == _arg_1)
                {
                    if (this.readyApplyList)
                    {
                        this.readyApplyList.splice(_local_3, 1);
                    };
                    this.myApplyList.splice(_local_3, 1);
                    dispatchEvent(new ConsortionEvent(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE));
                    return;
                };
                _local_3++;
            };
        }

        public function deleteOneConsortion(_arg_1:int):void
        {
            if (this.consortionList == null)
            {
                return;
            };
            var _local_2:int = this.consortionList.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (this.consortionList[_local_3].ConsortiaID == _arg_1)
                {
                    this.consortionList.splice(_local_3, 1);
                    dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTIONLIST_IS_CHANGE));
                    return;
                };
                _local_3++;
            };
        }

        public function set inventList(_arg_1:Vector.<ConsortiaInventData>):void
        {
            if (this._inventList == _arg_1)
            {
                return;
            };
            this._inventList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.INVENT_LIST_IS_CHANGE));
        }

        public function get inventList():Vector.<ConsortiaInventData>
        {
            return (this._inventList);
        }

        public function get eventList():Vector.<ConsortiaEventInfo>
        {
            return (this._eventList);
        }

        public function set eventList(_arg_1:Vector.<ConsortiaEventInfo>):void
        {
            if (this._eventList == _arg_1)
            {
                return;
            };
            this._eventList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.EVENT_LIST_CHANGE));
        }

        public function get useConditionList():Vector.<ConsortiaAssetLevelOffer>
        {
            return (this._useConditionList);
        }

        public function set useConditionList(_arg_1:Vector.<ConsortiaAssetLevelOffer>):void
        {
            if (this._useConditionList == _arg_1)
            {
                return;
            };
            this._useConditionList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.USE_CONDITION_CHANGE));
        }

        public function get dutyList():Vector.<ConsortiaDutyInfo>
        {
            return (this._dutyList);
        }

        public function set dutyList(_arg_1:Vector.<ConsortiaDutyInfo>):void
        {
            if (this._dutyList == _arg_1)
            {
                return;
            };
            this._dutyList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.DUTY_LIST_CHANGE));
        }

        public function changeDutyListName(_arg_1:int, _arg_2:String):void
        {
            var _local_3:int;
            while (_local_3 < this._dutyList.length)
            {
                if (this._dutyList[_local_3].DutyID == _arg_1)
                {
                    this._dutyList[_local_3].DutyName = _arg_2;
                    return;
                };
                _local_3++;
            };
        }

        public function get pollList():Vector.<ConsortionPollInfo>
        {
            return (this._pollList);
        }

        public function set pollList(_arg_1:Vector.<ConsortionPollInfo>):void
        {
            if (this._pollList == _arg_1)
            {
                return;
            };
            this._pollList = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.POLL_LIST_CHANGE));
        }

        public function get skillInfoList():Vector.<ConsortionSkillInfo>
        {
            return (this._skillInfoList);
        }

        public function set skillInfoList(_arg_1:Vector.<ConsortionSkillInfo>):void
        {
            if (this._skillInfoList == _arg_1)
            {
                return;
            };
            this._skillInfoList = _arg_1;
        }

        public function get newSkillInfoList():Vector.<ConsortionNewSkillInfo>
        {
            return (this._newSkillInfo);
        }

        public function set newSkillInfoList(_arg_1:Vector.<ConsortionNewSkillInfo>):void
        {
            if (this._newSkillInfo == _arg_1)
            {
                return;
            };
            this._newSkillInfo = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_LIST_CHANGE));
        }

        public function set proBabiliInfoList(_arg_1:Vector.<ConsortionProbabilityInfo>):void
        {
            if (this._probabiliInfo == _arg_1)
            {
                return;
            };
            this._probabiliInfo = _arg_1;
        }

        public function get proBabiliInfoList():Vector.<ConsortionProbabilityInfo>
        {
            return (this._probabiliInfo);
        }

        public function getskillInfoWithTypeAndLevel(_arg_1:int):Vector.<ConsortionNewSkillInfo>
        {
            var _local_2:Vector.<ConsortionNewSkillInfo> = new Vector.<ConsortionNewSkillInfo>();
            var _local_3:int = this.newSkillInfoList.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if (this.newSkillInfoList[_local_4].BuildLevel == _arg_1)
                {
                    _local_2.push(this.newSkillInfoList[_local_4]);
                };
                _local_4++;
            };
            return (_local_2);
        }

        public function getSkillInfoByID(_arg_1:int):ConsortionSkillInfo
        {
            var _local_2:ConsortionSkillInfo;
            var _local_3:int;
            while (_local_3 < this.skillInfoList.length)
            {
                if (this.skillInfoList[_local_3].id == _arg_1)
                {
                    _local_2 = this.skillInfoList[_local_3];
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function updateSkillInfo(_arg_1:int, _arg_2:Boolean, _arg_3:Date, _arg_4:int):void
        {
            var _local_5:int = this.skillInfoList.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                if (this.skillInfoList[_local_6].id == _arg_1)
                {
                    this.skillInfoList[_local_6].isOpen = _arg_2;
                    this.skillInfoList[_local_6].beginDate = _arg_3;
                    this.skillInfoList[_local_6].validDate = _arg_4;
                    return;
                };
                _local_6++;
            };
        }

        public function hasSomeGroupSkill(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int = this.skillInfoList.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if ((((this.skillInfoList[_local_4].group == _arg_1) && (this.skillInfoList[_local_4].isOpen)) && (!(this.skillInfoList[_local_4].id == _arg_2))))
                {
                    return (true);
                };
                _local_4++;
            };
            return (false);
        }

        public function set levelUpData(_arg_1:Vector.<ConsortiaLevelInfo>):void
        {
            if (this._levelUpData == _arg_1)
            {
                return;
            };
            this._levelUpData = _arg_1;
            dispatchEvent(new ConsortionEvent(ConsortionEvent.LEVEL_UP_RULE_CHANGE));
        }

        public function get levelUpData():Vector.<ConsortiaLevelInfo>
        {
            return (this._levelUpData);
        }

        public function getLevelData(_arg_1:int):ConsortiaLevelInfo
        {
            if (this.levelUpData == null)
            {
                return (null);
            };
            var _local_2:uint;
            while (_local_2 < this.levelUpData.length)
            {
                if (this.levelUpData[_local_2]["Level"] == _arg_1)
                {
                    return (this.levelUpData[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function getQuestType(_arg_1:int):String
        {
            var _local_2:String = LanguageMgr.GetTranslation("consortion.ConsortionTask.level1");
            if (_arg_1 == 11)
            {
                return (LanguageMgr.GetTranslation("consortion.ConsortionTask.level1"));
            };
            if (_arg_1 == 12)
            {
                return (LanguageMgr.GetTranslation("consortion.ConsortionTask.level2"));
            };
            if (_arg_1 == 13)
            {
                return (LanguageMgr.GetTranslation("consortion.ConsortionTask.level3"));
            };
            if (_arg_1 == 14)
            {
                return (LanguageMgr.GetTranslation("consortion.ConsortionTask.level4"));
            };
            return (_local_2);
        }

        public function getLevelString(_arg_1:int, _arg_2:int):Vector.<String>
        {
            var _local_3:Vector.<String> = new Vector.<String>(4);
            switch (_arg_1)
            {
                case LEVEL:
                    if (_arg_2 >= CONSORTION_MAX_LEVEL)
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.explainTxt");
                        _local_3[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                    }
                    else
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.upgradeI");
                        _local_3[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel", (_arg_2 + 1));
                        _local_3[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevelI", (_arg_2 + 1));
                        if (this.getLevelData((_arg_2 + 1)))
                        {
                            _local_3[3] = ((this.getLevelData((_arg_2 + 1)).StoreRiches + LanguageMgr.GetTranslation("consortia.Money")) + this.checkRiches(this.getLevelData((_arg_2 + 1)).StoreRiches));
                        };
                    };
                    break;
                case SHOP:
                    if (_arg_2 >= SHOP_MAX_LEVEL)
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel");
                        _local_3[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                    }
                    else
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE.explainTxt");
                        _local_3[1] = ((LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText") + (_arg_2 + 1)) + LanguageMgr.GetTranslation("grade"));
                        _local_3[2] = ((LanguageMgr.GetTranslation("consortia.upgrade") + (_arg_2 + 1)) + LanguageMgr.GetTranslation("grade"));
                        if (this.getLevelData((_arg_2 + 1)))
                        {
                            _local_3[3] = ((this.getLevelData((_arg_2 + 1)).ShopRiches + LanguageMgr.GetTranslation("consortia.Money")) + this.checkRiches(this.getLevelData((_arg_2 + 1)).ShopRiches));
                        };
                    };
                    break;
                case SKILL:
                    if (_arg_2 >= SKILL_MAX_LEVEL)
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill");
                        _local_3[1] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[2] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                        _local_3[3] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                    }
                    else
                    {
                        _local_3[0] = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill.explainTxt");
                        _local_3[1] = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.skill", (_arg_2 + 1));
                        _local_3[2] = ((LanguageMgr.GetTranslation("consortia.upgrade") + (_arg_2 + 1)) + LanguageMgr.GetTranslation("grade"));
                        if (this.getLevelData((_arg_2 + 1)))
                        {
                            _local_3[3] = ((this.getLevelData((_arg_2 + 1)).SmithRiches + LanguageMgr.GetTranslation("consortia.Money")) + this.checkRiches(this.getLevelData((_arg_2 + 1)).SmithRiches));
                        };
                    };
                    break;
            };
            return (_local_3);
        }

        public function getTaskLevelString(_arg_1:int):Vector.<String>
        {
            var _local_2:int = this.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Count;
            var _local_3:Vector.<String> = new Vector.<String>(2);
            switch (_arg_1)
            {
                case TASKLEVELI:
                    _local_3[0] = String(((ConsortionModel.TaskRewardSontribution1 * _local_2) * 5));
                    _local_3[1] = String(((ConsortionModel.TaskRewardExp1 * _local_2) * 5));
                    _local_3[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELI));
                    break;
                case TASKLEVELII:
                    _local_3[0] = String(((ConsortionModel.TaskRewardSontribution2 * _local_2) * 5));
                    _local_3[1] = String(((ConsortionModel.TaskRewardExp2 * _local_2) * 5));
                    _local_3[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELII));
                    break;
                case TASKLEVELIII:
                    _local_3[0] = String(((ConsortionModel.TaskRewardSontribution3 * _local_2) * 5));
                    _local_3[1] = String(((ConsortionModel.TaskRewardExp3 * _local_2) * 5));
                    _local_3[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELIII));
                    break;
                case TASKLEVELIV:
                    _local_3[0] = String(((ConsortionModel.TaskRewardSontribution4 * _local_2) * 5));
                    _local_3[1] = String(((ConsortionModel.TaskRewardExp4 * _local_2) * 5));
                    _local_3[2] = String(this.getConsortionLevelByTaskLevel(TASKLEVELIV));
                    break;
            };
            return (_local_3);
        }

        private function getConsortionLevelByTaskLevel(_arg_1:int):int
        {
            var _local_3:ConsortiaLevelInfo;
            var _local_2:uint;
            while (_local_2 < CONSORTION_MAX_LEVEL)
            {
                _local_3 = this.getLevelData((_local_2 + 1));
                if (_local_3.QuestLevel == _arg_1)
                {
                    return (_local_3.Level);
                };
                _local_2++;
            };
            return (1);
        }

        public function getCarCostString(_arg_1:int):Vector.<String>
        {
            var _local_3:TransportCarInfo;
            var _local_2:Vector.<String> = new Vector.<String>(2);
            switch (_arg_1)
            {
                case TransportCar.CARI:
                    _local_3 = new TransportCarInfo(TransportCar.CARI);
                    _local_3.ownerLevel = PlayerManager.Instance.Self.Grade;
                    _local_2[0] = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.normalCarName.text");
                    _local_2[1] = "";
                    _local_2[2] = "";
                    _local_2[3] = (LanguageMgr.GetTranslation("consortion.ConsortionComfirm.summomCost.gold.txt") + ":");
                    _local_2[4] = String(_local_3.cost);
                    break;
                case TransportCar.CARII:
                    _local_3 = new TransportCarInfo(TransportCar.CARII);
                    _local_3.ownerLevel = PlayerManager.Instance.Self.Grade;
                    _local_2[0] = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.highClassCarName.text");
                    _local_2[1] = "";
                    _local_2[2] = "";
                    _local_2[3] = (LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple") + ":");
                    _local_2[4] = String(_local_3.cost);
                    break;
            };
            var _local_4:int = int(_local_3.rewardContribution);
            var _local_5:int = int(_local_3.rewardGold);
            if (this.isRewardPlusTime)
            {
                _local_4 = int((_local_4 * 1.5));
                _local_5 = int((_local_5 * 1.5));
            };
            _local_2[1] = String(_local_4);
            _local_2[2] = String(_local_5);
            return (_local_2);
        }

        public function getCarInfoTip(_arg_1:TransportCarInfo):Vector.<String>
        {
            var _local_2:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_HIJACK_COUNT];
            var _local_3:int;
            if (_local_2)
            {
                _local_3 = _local_2.Value;
            };
            var _local_4:Vector.<String> = new Vector.<String>(8);
            _local_4[0] = String(_arg_1.ownerName);
            _local_4[1] = ("Lv." + String(_arg_1.ownerLevel));
            _local_4[2] = ((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.consortion.txt") + ":") + _arg_1.consortionName);
            _local_4[3] = ((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.guarderName.txt") + ":") + _arg_1.nickName);
            _local_4[4] = ((((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.hijackTimes.txt") + ":") + _arg_1.hijackTimes) + "/") + (TransportCarInfo.MAX_HIJACKED_TIMES + _local_3));
            _local_4[5] = String(_arg_1.startDate.valueOf());
            _local_4[6] = String(_arg_1.speed);
            _local_4[7] = ((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.remainTime.txt") + ":") + _arg_1.guarderName);
            var _local_5:Number = 1;
            var _local_6:int = (PlayerManager.Instance.Self.Grade - _arg_1.ownerLevel);
            if (_local_6 > 0)
            {
                if (_local_6 >= 9)
                {
                    _local_5 = 0.1;
                }
                else
                {
                    _local_5 = (1 - (_local_6 / 10));
                };
            };
            var _local_7:int = int(int((((_arg_1.rewardGold * _arg_1.hijackPercent) / 100) * _local_5)));
            if (_local_7 < 1)
            {
                _local_7 = 1;
            };
            var _local_8:int = int(int((((_arg_1.rewardContribution * _arg_1.hijackPercent) / 100) * _local_5)));
            if (_local_8 < 1)
            {
                _local_8 = 1;
            };
            if (this.isRewardPlusTime)
            {
                _local_7 = int((_local_7 * 1.5));
                _local_8 = int((_local_8 * 1.5));
            };
            _local_4[8] = ((_local_7 + " ") + LanguageMgr.GetTranslation("consortion.skillFrame.richesText1"));
            _local_4[9] = ((_local_8 + " ") + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text"));
            return (_local_4);
        }

        private function get isRewardPlusTime():Boolean
        {
            var _local_1:Date = TimeManager.Instance.Now();
            var _local_2:Number = _local_1.getHours();
            var _local_3:Number = _local_1.getMinutes();
            if (_local_2 == 17)
            {
                if (_local_3 >= 30)
                {
                    return (true);
                };
            };
            if (_local_2 == 18)
            {
                return (true);
            };
            return (false);
        }

        public function getTaskCost(_arg_1:int):uint
        {
            var _local_2:uint;
            switch (_arg_1)
            {
                case TASKLEVELI:
                    _local_2 = ServerConfigManager.instance.getConsortiaTaskCost()[0];
                    break;
                case TASKLEVELII:
                    _local_2 = ServerConfigManager.instance.getConsortiaTaskCost()[1];
                    break;
                case TASKLEVELIII:
                    _local_2 = ServerConfigManager.instance.getConsortiaTaskCost()[2];
                    break;
                case TASKLEVELIV:
                    _local_2 = ServerConfigManager.instance.getConsortiaTaskCost()[3];
                    break;
            };
            return (_local_2);
        }

        public function checkConsortiaRichesForUpGrade(_arg_1:int):Boolean
        {
            var _local_2:int = PlayerManager.Instance.Self.consortiaInfo.Riches;
            switch (_arg_1)
            {
                case 0:
                    if (PlayerManager.Instance.Self.consortiaInfo.StoreLevel < CONSORTION_MAX_LEVEL)
                    {
                        if (_local_2 < this.getLevelData((PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1)).StoreRiches)
                        {
                            return (false);
                        };
                    };
                    break;
                case 1:
                    if (PlayerManager.Instance.Self.consortiaInfo.ShopLevel < SHOP_MAX_LEVEL)
                    {
                        if (_local_2 < this.getLevelData((PlayerManager.Instance.Self.consortiaInfo.ShopLevel + 1)).ShopRiches)
                        {
                            return (false);
                        };
                    };
                    break;
                case 2:
                    if (PlayerManager.Instance.Self.consortiaInfo.SmithLevel < SKILL_MAX_LEVEL)
                    {
                        if (_local_2 < this.getLevelData((PlayerManager.Instance.Self.consortiaInfo.SmithLevel + 1)).SmithRiches)
                        {
                            return (false);
                        };
                    };
                    break;
            };
            return (true);
        }

        private function checkRiches(_arg_1:int):String
        {
            var _local_2:String = "";
            if (PlayerManager.Instance.Self.consortiaInfo.Riches < _arg_1)
            {
                _local_2 = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
            };
            return (_local_2);
        }

        private function checkGold(_arg_1:int):String
        {
            var _local_2:String = "";
            if (PlayerManager.Instance.Self.Gold < _arg_1)
            {
                _local_2 = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.condition");
            };
            return (_local_2);
        }

        public function get currentTaskLevel():int
        {
            return (this._currentTaskLevel);
        }

        public function set currentTaskLevel(_arg_1:int):void
        {
            this._currentTaskLevel = _arg_1;
        }

        public function get remainPublishTime():int
        {
            return (this._remainPublishTime);
        }

        public function set remainPublishTime(_arg_1:int):void
        {
            this._remainPublishTime = _arg_1;
        }

        public function get lastPublishDate():Date
        {
            return (this._lastPublishDate);
        }

        public function set lastPublishDate(_arg_1:Date):void
        {
            this._lastPublishDate = _arg_1;
        }

        public function get canAcceptTask():Boolean
        {
            return (this._canAcceptTask);
        }

        public function set canAcceptTask(_arg_1:Boolean):void
        {
            this._canAcceptTask = _arg_1;
        }

        public function get isMaster():Boolean
        {
            return (this._isMaster);
        }

        public function set isMaster(_arg_1:Boolean):void
        {
            this._isMaster = _arg_1;
        }

        public function get receivedQuestCount():int
        {
            return (this._receivedQuestCount);
        }

        public function set receivedQuestCount(_arg_1:int):void
        {
            this._receivedQuestCount = _arg_1;
        }

        public function get consortiaQuestCount():int
        {
            return (this._consortiaQuestCount);
        }

        public function set consortiaQuestCount(_arg_1:int):void
        {
            this._consortiaQuestCount = _arg_1;
        }

        public function getConosrionByID(_arg_1:int):ConsortiaInfo
        {
            var _local_2:ConsortiaInfo;
            var _local_3:int;
            while (_local_3 < this.consortionList.length)
            {
                if (this.consortionList[_local_3].ConsortiaID == _arg_1)
                {
                    _local_2 = this.consortionList[_local_3];
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function getisLearnByBuffId(_arg_1:int):Boolean
        {
            var _local_2:Boolean;
            var _local_3:DictionaryData = PlayerManager.Instance.Self.isLearnSkill;
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                if (_local_3[_local_4] == _arg_1.toString())
                {
                    _local_2 = true;
                };
                _local_4++;
            };
            return (_local_2);
        }

        public function getInfoByBuffId(_arg_1:int):ConsortionNewSkillInfo
        {
            var _local_2:ConsortionNewSkillInfo;
            var _local_3:int;
            while (_local_3 < this.newSkillInfoList.length)
            {
                if (this.newSkillInfoList[_local_3].BuffID == _arg_1)
                {
                    _local_2 = this.newSkillInfoList[_local_3];
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function getInfoByType(_arg_1:int):ConsortionNewSkillInfo
        {
            var _local_2:ConsortionNewSkillInfo;
            var _local_3:int;
            while (_local_3 < this.newSkillInfoList.length)
            {
                if (this.newSkillInfoList[_local_3].BuffType == _arg_1)
                {
                    _local_2 = this.newSkillInfoList[_local_3];
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function getInfoByTypeAndData(_arg_1:int, _arg_2:int):ConsortionNewSkillInfo
        {
            var _local_3:ConsortionNewSkillInfo;
            var _local_4:int;
            while (_local_4 < this.newSkillInfoList.length)
            {
                if (this.newSkillInfoList[_local_4].BuffType == _arg_1)
                {
                    if (int(this.newSkillInfoList[_local_4].BuffValue) == _arg_2)
                    {
                        _local_3 = this.newSkillInfoList[_local_4];
                    };
                };
                _local_4++;
            };
            return (_local_3);
        }

        public function getisUpgradeByBuffId(_arg_1:int):Boolean
        {
            var _local_2:Boolean = true;
            var _local_3:ConsortionNewSkillInfo = this.getInfoByBuffId(_arg_1);
            var _local_4:ConsortionNewSkillInfo = this.getInfoByBuffId((_arg_1 - 1));
            if (_local_3.BuildLevel > PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
            {
                return (false);
            };
            if (_local_3.NeedLevel > PlayerManager.Instance.Self.Grade)
            {
                return (false);
            };
            if (_local_3.NeedDevote > PlayerManager.Instance.Self.RichesOffer)
            {
                return (false);
            };
            if ((!(this.getisLearnByBuffId(_arg_1))))
            {
                return (false);
            };
            return (_local_2);
        }

        public function getisUpgradeByType(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:Boolean;
            var _local_4:ConsortionNewSkillInfo = this.getInfoByBuffId(_arg_2);
            switch (_arg_1)
            {
                case 0:
                    if (_local_4.BuildLevel > PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
                    {
                        return (true);
                    };
                    break;
                case 1:
                    if (_local_4.NeedLevel > PlayerManager.Instance.Self.Grade)
                    {
                        return (true);
                    };
                    break;
                case 2:
                    if (_local_4.NeedDevote > PlayerManager.Instance.Self.RichesOffer)
                    {
                        return (true);
                    };
                    break;
                case 3:
                    if (((!(_arg_2 == 1)) && (!(this.getisLearnByBuffId((_arg_2 - 1))))))
                    {
                        return (true);
                    };
                    break;
            };
            return (_local_3);
        }

        public function set shinePlay(_arg_1:Boolean):void
        {
            this._shinePlay = _arg_1;
        }

        public function get shinePlay():Boolean
        {
            return (this._shinePlay);
        }


    }
}//package consortion

