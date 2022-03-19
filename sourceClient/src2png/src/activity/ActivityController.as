// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.ActivityController

package activity
{
    import activity.view.ActivityFrame;
    import activity.view.ActivityFirstRechargeView;
    import activity.data.ActivityInfo;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import activity.data.ConditionRecord;
    import activity.data.ActivityGiftbagInfo;
    import activity.data.ActivityConditionInfo;
    import ddt.data.player.SelfInfo;
    import road7th.data.DictionaryData;
    import activity.view.ActivityConditionType;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.TimeManager;
    import activity.data.ActivityChildTypes;
    import activity.data.ActivityTypes;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.events.UIModuleEvent;
    import activity.analyze.ActiveExchangeAnalyzer;
    import activity.analyze.ActivityConditionAnalyzer;
    import activity.analyze.ActivityInfoAnalyzer;
    import activity.analyze.ActivityGiftbagAnalyzer;
    import activity.analyze.ActivityRewardAnalyzer;
    import activity.data.ActivityRewardInfo;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.data.UIModuleTypes;
    import flash.utils.ByteArray;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.data.AccountInfo;
    import ddt.utils.CrytoUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.MessageTipManager;
    import activity.data.ActivityGiftbagRecord;
    import activity.data.ActivityTuanInfo;
    import road7th.comm.PackageIn;

    public class ActivityController 
    {

        private static var _instance:ActivityController;

        private var _model:ActivityModel;
        private var _frame:ActivityFrame;
        private var _firstRechargeView:ActivityFirstRechargeView;
        private var _complete:Boolean = false;
        private var _completeFun:Function;
        private var _reciveActive:ActivityInfo;

        public function ActivityController()
        {
            this._model = new ActivityModel();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_lOG, this.__activeLogUpdate);
        }

        public static function get instance():ActivityController
        {
            if ((!(_instance)))
            {
                _instance = new (ActivityController)();
            };
            return (_instance);
        }


        public function checkCondition(_arg_1:ActivityInfo):Boolean
        {
            var _local_3:Array;
            var _local_5:ConditionRecord;
            var _local_6:ActivityGiftbagInfo;
            var _local_7:ActivityConditionInfo;
            var _local_8:int;
            var _local_9:int;
            var _local_10:SelfInfo;
            var _local_2:Array = ActivityController.instance.getAcitivityGiftBagByActID(_arg_1.ActivityId);
            var _local_4:DictionaryData = new DictionaryData();
            for each (_local_6 in _local_2)
            {
                _local_3 = ActivityController.instance.getActivityConditionByGiftbagID(_local_6.GiftbagId);
                for each (_local_7 in _local_3)
                {
                    _local_5 = ActivityController.instance.model.getConditionRecord(_arg_1.ActivityId, _local_7.ConditionIndex);
                    if (((((_local_7.Remain2 == ActivityConditionType.FREEDOM) || (_local_7.Remain2 == ActivityConditionType.SPORTS)) || (_local_7.Remain2 == ActivityConditionType.CHALLENGE)) || (_local_7.Remain2 == ActivityConditionType.GUILD)))
                    {
                        if (((!(_local_5)) || (_local_5.record < int(_local_7.ConditionValue))))
                        {
                            return (false);
                        };
                    }
                    else
                    {
                        if (_local_7.Remain2 == ActivityConditionType.NPC)
                        {
                            if (((!(_local_5)) || (!(_local_5.record == int(_local_7.ConditionValue)))))
                            {
                                return (false);
                            };
                        }
                        else
                        {
                            if (_local_7.Remain2 == ActivityConditionType.COLLECTITEM)
                            {
                                _local_8 = _local_7.Remain1;
                                _local_9 = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_local_8);
                                if (_local_9 < int(_local_7.ConditionValue))
                                {
                                    return (false);
                                };
                            }
                            else
                            {
                                if (_local_7.Remain2 == ActivityConditionType.USEITEM)
                                {
                                    if (((!(_local_5)) || (_local_5.record < int(_local_7.ConditionValue))))
                                    {
                                        return (false);
                                    };
                                }
                                else
                                {
                                    if (_local_7.Remain2 == ActivityConditionType.NUMBER)
                                    {
                                        if (_local_7.Remain1 == -2)
                                        {
                                            if (PlayerManager.Instance.Self.Grade < int(_local_7.ConditionValue))
                                            {
                                                return (false);
                                            };
                                        }
                                        else
                                        {
                                            if (_local_7.Remain1 == -1)
                                            {
                                                if (((!(_local_5)) || (_local_5.record < int(_local_7.ConditionValue))))
                                                {
                                                    return (false);
                                                };
                                            };
                                        };
                                    }
                                    else
                                    {
                                        if ((((_local_7.Remain2 == ActivityConditionType.MINGRADELIMIT) || (_local_7.Remain2 == ActivityConditionType.MAXGRADELIMIT)) || (_local_7.Remain2 == ActivityConditionType.RELATIONLIMIT)))
                                        {
                                            _local_10 = PlayerManager.Instance.Self;
                                            if (((_local_7.Remain2 == ActivityConditionType.MINGRADELIMIT) && (_local_10.Grade < int(_local_7.ConditionValue))))
                                            {
                                                return (false);
                                            };
                                            if (((_local_7.Remain2 == ActivityConditionType.MAXGRADELIMIT) && (_local_10.Grade > int(_local_7.ConditionValue))))
                                            {
                                                return (false);
                                            };
                                            if (_local_7.Remain2 == ActivityConditionType.RELATIONLIMIT)
                                            {
                                                switch (_local_7.ConditionValue)
                                                {
                                                    case 1:
                                                        if ((!(PlayerManager.Instance.Self.IsMarried)))
                                                        {
                                                            return (false);
                                                        };
                                                        break;
                                                    case 2:
                                                        if (PlayerManager.Instance.Self.ConsortiaID == 0)
                                                        {
                                                            return (false);
                                                        };
                                                        break;
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
            return (true);
        }

        public function checkShowCondition(_arg_1:ActivityInfo):Boolean
        {
            var _local_3:Array;
            var _local_5:ActivityGiftbagInfo;
            var _local_6:ActivityConditionInfo;
            var _local_7:SelfInfo;
            var _local_2:Array = ActivityController.instance.getAcitivityGiftBagByActID(_arg_1.ActivityId);
            var _local_4:DictionaryData = new DictionaryData();
            for each (_local_5 in _local_2)
            {
                _local_3 = ActivityController.instance.getActivityConditionByGiftbagID(_local_5.GiftbagId);
                for each (_local_6 in _local_3)
                {
                    _local_7 = PlayerManager.Instance.Self;
                    if (((_local_6.Remain2 == ActivityConditionType.MINGRADELIMIT) && (_local_7.Grade < int(_local_6.ConditionValue))))
                    {
                        return (false);
                    };
                    if (((_local_6.Remain2 == ActivityConditionType.MAXGRADELIMIT) && (_local_7.Grade > int(_local_6.ConditionValue))))
                    {
                        return (false);
                    };
                    if (_local_6.Remain2 == ActivityConditionType.RELATIONLIMIT)
                    {
                        switch (int(_local_6.ConditionValue))
                        {
                            case 1:
                                if ((!(PlayerManager.Instance.Self.IsMarried)))
                                {
                                    return (false);
                                };
                                break;
                            case 2:
                                if (PlayerManager.Instance.Self.ConsortiaID == 0)
                                {
                                    return (false);
                                };
                                break;
                        };
                    };
                };
            };
            return (true);
        }

        public function checkFinish(_arg_1:ActivityInfo):Boolean
        {
            if (_arg_1.GetWay == 0)
            {
                return (false);
            };
            return ((!(_arg_1.receiveNum == 0)) && (_arg_1.receiveNum >= _arg_1.GetWay));
        }

        public function get model():ActivityModel
        {
            return (this._model);
        }

        public function sendAskForActiviLog(_arg_1:ActivityInfo):void
        {
            SocketManager.Instance.out.sendAskForActiviLog(_arg_1.ActivityId, _arg_1.ActivityType, _arg_1.ActivityChildType);
        }

        public function setData(_arg_1:ActivityInfo):void
        {
            if (this._frame)
            {
                this._frame.setData(_arg_1);
            };
        }

        private function updateData(_arg_1:ActivityInfo=null):void
        {
            if (((this._frame) && (this._frame.parent)))
            {
                this._frame.updateData(_arg_1);
            };
        }

        public function showFrame():void
        {
            if (this._complete)
            {
                if ((!(this._frame)))
                {
                    this._frame = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFrame");
                };
                this._frame.show();
            }
            else
            {
                this._completeFun = this.showFrame;
                this.loadUI();
            };
        }

        public function hideFrame():void
        {
            this.model.showID = "";
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
        }

        public function isInValidOpenDate(_arg_1:ActivityInfo):Boolean
        {
            var _local_2:Date = TimeManager.Instance.Now();
            var _local_3:Date = _arg_1.beginDate;
            var _local_4:Date = _arg_1.endDate;
            if (((_local_2.getTime() >= _local_3.getTime()) && (_local_2.getTime() <= _local_4.getTime())))
            {
                return (true);
            };
            return (false);
        }

        public function isInValidShowDate(_arg_1:ActivityInfo):Boolean
        {
            var _local_2:Date = TimeManager.Instance.Now();
            var _local_3:Date = _arg_1.beginShowDate;
            var _local_4:Date = _arg_1.endShowDate;
            if (((_local_2.getTime() >= _local_3.getTime()) && (_local_2.getTime() <= _local_4.getTime())))
            {
                return (true);
            };
            return (false);
        }

        public function getActivityAward(_arg_1:ActivityInfo, _arg_2:Object=null):void
        {
            SocketManager.Instance.out.sendGetActivityAward(_arg_1.ActivityId, _arg_1.ActivityType, _arg_2);
        }

        public function checkFirstCharge(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CHARGE) && (_arg_1.ActivityChildType == ActivityChildTypes.OPEN_FIRST_ONCE)))
            {
                return (true);
            };
            return (false);
        }

        public function checkHasFirstCharge():ActivityInfo
        {
            var _local_1:ActivityInfo;
            for each (_local_1 in this._model.activityInfoArr)
            {
                if (((this.checkFirstCharge(_local_1)) && (this.isInValidShowDate(_local_1))))
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public function checkHasOpenActivity():Boolean
        {
            var _local_1:ActivityInfo;
            for each (_local_1 in this._model.activityInfoArr)
            {
                if (((this.checkOpenActivity(_local_1)) && (this.isInValidShowDate(_local_1))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function checkOpenActivity(_arg_1:ActivityInfo):Boolean
        {
            if (this.checkTotalMoeny(_arg_1))
            {
                return (true);
            };
            if (this.checkOpenConsortiaLevel(_arg_1))
            {
                return (true);
            };
            if (this.checkOpenLove(_arg_1))
            {
                return (true);
            };
            if (((this.checkOpenLevel(_arg_1)) || (this.checkOpenFight(_arg_1))))
            {
                return (true);
            };
            return (false);
        }

        public function checkTotalMoeny(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CHARGE) && (_arg_1.ActivityChildType == ActivityChildTypes.OPEN_COMMON_ONCE)))
            {
                return (true);
            };
            return (false);
        }

        public function checkOpenConsortiaLevel(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CONSORTIA) && (_arg_1.ActivityChildType == ActivityChildTypes.CONSORTIA_LEVEL)))
            {
                return (true);
            };
            return (false);
        }

        public function checkOpenLove(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.MARRIED) && (_arg_1.ActivityChildType == ActivityChildTypes.WEDDING_OPEN)))
            {
                return (true);
            };
            return (false);
        }

        public function checkOpenLevel(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CELEB) && (_arg_1.ActivityChildType == ActivityChildTypes.LEVEL)))
            {
                return (true);
            };
            return (false);
        }

        public function checkOpenFight(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CELEB) && (_arg_1.ActivityChildType == ActivityChildTypes.POWER)))
            {
                return (true);
            };
            return (false);
        }

        public function checkMouthActivity(_arg_1:ActivityInfo):Boolean
        {
            if (_arg_1.ActivityType == ActivityTypes.MONTH)
            {
                return (true);
            };
            return (false);
        }

        public function showFirstRechargeView():void
        {
            if (this._complete)
            {
                if ((!(this._firstRechargeView)))
                {
                    this._firstRechargeView = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityFirstRechargeView");
                };
                this._firstRechargeView.show();
            }
            else
            {
                this._completeFun = this.showFirstRechargeView;
                this.loadUI();
            };
        }

        private function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        public function setActivityExchange(_arg_1:ActiveExchangeAnalyzer):void
        {
            this._model.activeExchange = _arg_1.list;
        }

        public function setActivityCondition(_arg_1:ActivityConditionAnalyzer):void
        {
            this._model.activityConditionArr = _arg_1.list;
        }

        public function setActivityInfo(_arg_1:ActivityInfoAnalyzer):void
        {
            this._model.activityInfoArr = _arg_1.list;
        }

        public function setActivityGiftbag(_arg_1:ActivityGiftbagAnalyzer):void
        {
            this._model.activityGiftbagArr = _arg_1.list;
        }

        public function setActivityReward(_arg_1:ActivityRewardAnalyzer):void
        {
            this._model.activityRewards = _arg_1.list;
        }

        public function getActivityInfoByID(_arg_1:String):ActivityInfo
        {
            var _local_2:ActivityInfo;
            for each (_local_2 in this._model.activityInfoArr)
            {
                if (_local_2.ActivityId == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getActivityConditionByGiftbagID(_arg_1:String):Array
        {
            var _local_3:ActivityConditionInfo;
            var _local_2:Array = new Array();
            for each (_local_3 in this._model.activityConditionArr)
            {
                if (_local_3.GiftbagId == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function getAcitivityGiftBagByActID(_arg_1:String):Array
        {
            var _local_3:ActivityGiftbagInfo;
            var _local_4:Array;
            var _local_5:ActivityGiftbagInfo;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_2:Array = new Array();
            for each (_local_3 in this._model.activityGiftbagArr)
            {
                if (_local_3.ActivityId == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            _local_4 = new Array();
            _local_6 = 0;
            _local_7 = 0;
            while (_local_7 < _local_2.length)
            {
                _local_8 = _local_7;
                while (_local_8 < _local_2.length)
                {
                    if (_local_2[_local_8].GiftbagOrder < _local_2[_local_7].GiftbagOrder)
                    {
                        _local_5 = _local_2[_local_7];
                        _local_2[_local_7] = _local_2[_local_8];
                        _local_2[_local_8] = _local_5;
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_local_2);
        }

        public function getRewardsByGiftbagID(_arg_1:String):DictionaryData
        {
            var _local_3:ActivityRewardInfo;
            var _local_2:DictionaryData = new DictionaryData();
            for each (_local_3 in this._model.activityRewards)
            {
                if (_local_3.GiftbagId == _arg_1)
                {
                    _local_2.add(_local_3.TemplateId, _local_3);
                };
            };
            return (_local_2);
        }

        public function getFirstRechargeAcitivty():String
        {
            var _local_1:String;
            var _local_2:ActivityInfo;
            for each (_local_2 in this._model.activityInfoArr)
            {
                if (((_local_2.ActivityType == ActivityTypes.CHARGE) && (_local_2.ActivityChildType == ActivityChildTypes.OPEN_FIRST_ONCE)))
                {
                    _local_1 = _local_2.ActivityId;
                };
            };
            return (_local_1);
        }

        private function loadUI():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__loadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ACTIVITY);
        }

        private function __moduleIOError(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.ACTIVITY)
            {
                this._complete = true;
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleSmallLoading.Instance.hide();
            };
        }

        private function __moduleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.ACTIVITY)
            {
                this._complete = true;
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
                UIModuleSmallLoading.Instance.hide();
                this._completeFun();
            };
        }

        private function __loadingClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__loadingClose);
            UIModuleSmallLoading.Instance.hide();
        }

        public function reciveActivityAward(_arg_1:ActivityInfo, _arg_2:String):BaseLoader
        {
            this._reciveActive = _arg_1;
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeUTFBytes(_arg_2);
            var _local_4:URLVariables = RequestVairableCreater.creatWidthKey(true);
            var _local_5:AccountInfo = PlayerManager.Instance.Account;
            var _local_6:String = CrytoUtils.rsaEncry4(_local_5.Key, _local_3);
            _local_4["activeKey"] = encodeURIComponent(_local_6);
            _local_4["activityId"] = this._reciveActive.ActivityId;
            var _local_7:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ReleseActive.ashx"), BaseLoader.REQUEST_LOADER, _local_4);
            _local_7.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_7.addEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete, false, 99);
            LoadResourceManager.instance.startLoad(_local_7, true);
            return (_local_7);
        }

        private function __activityLoadComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete);
            var _local_3:XML = XML(_arg_1.loader.content);
            if (String(_local_3.@value) == "True")
            {
                if (this._reciveActive)
                {
                    if (this._reciveActive.GetWay != 0)
                    {
                        this._reciveActive.receiveNum = _local_3.@receiveNum;
                        this.setData(this._reciveActive);
                    };
                };
            };
            if (String(_local_3.@message).length > 0)
            {
                MessageTipManager.getInstance().show(_local_3.@message);
            };
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete);
        }

        private function __activeLogUpdate(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_10:int;
            var _local_11:ActivityGiftbagRecord;
            var _local_12:DictionaryData;
            var _local_13:int;
            var _local_14:Boolean;
            var _local_15:int;
            var _local_16:ActivityGiftbagRecord;
            var _local_17:DictionaryData;
            var _local_18:int;
            var _local_19:String;
            var _local_20:ActivityTuanInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:String = _local_2.readUTF();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_9:ActivityInfo = this.getActivityInfoByID(_local_3);
            if (((this.checkOpenActivity(_local_9)) || (this.checkFirstCharge(_local_9))))
            {
                if (_local_2.readBoolean())
                {
                    _local_6 = _local_2.readInt();
                    _local_7 = _local_2.readInt();
                    _local_8 = _local_2.readInt();
                    this.model.addLog(_local_3, _local_7);
                    this.model.addNowState(_local_3, _local_8);
                    if (((this.checkFirstCharge(_local_9)) || (this.checkTotalMoeny(_local_9))))
                    {
                        PlayerManager.Instance.Self.moneyOfCharge = _local_8;
                    };
                };
            }
            else
            {
                if (_local_4 == ActivityTypes.CHARGE)
                {
                    if ((((_local_5 == ActivityChildTypes.FISRT) || (_local_5 == ActivityChildTypes.ONLY_ONE_TIME)) || (this.checkChargeReward(_local_9))))
                    {
                        if (_local_2.readBoolean())
                        {
                            _local_6 = _local_2.readInt();
                            _local_7 = _local_2.readInt();
                            _local_8 = _local_2.readInt();
                            this.model.addLog(_local_3, _local_7);
                            this.model.addNowState(_local_3, _local_8);
                            PlayerManager.Instance.Self.moneyOfCharge = _local_8;
                            _local_10 = _local_2.readInt();
                            _local_12 = new DictionaryData();
                            _local_13 = 0;
                            while (_local_13 < _local_10)
                            {
                                _local_11 = new ActivityGiftbagRecord();
                                _local_11.index = _local_2.readInt();
                                _local_11.value = _local_2.readInt();
                                _local_12.add(_local_11.index, _local_11);
                                _local_13++;
                            };
                            this.model.addGiftbagRecord(_local_3, _local_12);
                        };
                    };
                }
                else
                {
                    if (_local_4 == ActivityTypes.CONVERT)
                    {
                        _local_2.readBoolean();
                        _local_6 = _local_2.readInt();
                    }
                    else
                    {
                        if (_local_4 == ActivityTypes.COST)
                        {
                            _local_14 = _local_2.readBoolean();
                            if (_local_5 != ActivityChildTypes.TIMES)
                            {
                                if (_local_14)
                                {
                                    _local_7 = _local_2.readInt();
                                    _local_8 = _local_2.readInt();
                                    this.model.addLog(_local_3, _local_7);
                                    this.model.addNowState(_local_3, _local_8);
                                };
                            }
                            else
                            {
                                if (_local_5 == ActivityChildTypes.TIMES)
                                {
                                    if (_local_14)
                                    {
                                        _local_7 = _local_2.readInt();
                                    };
                                };
                            };
                            if (_local_14)
                            {
                                _local_15 = _local_2.readInt();
                                _local_17 = new DictionaryData();
                                _local_18 = 0;
                                while (_local_18 < _local_15)
                                {
                                    _local_16 = new ActivityGiftbagRecord();
                                    _local_16.index = _local_2.readInt();
                                    _local_16.value = _local_2.readInt();
                                    _local_17.add(_local_16.index, _local_16);
                                    _local_18++;
                                };
                                this.model.addGiftbagRecord(_local_3, _local_17);
                            };
                        }
                        else
                        {
                            if (this.checkMouthActivity(_local_9))
                            {
                                if (_local_2.readBoolean())
                                {
                                    _local_6 = _local_2.readInt();
                                    _local_19 = _local_2.readUTF();
                                };
                                this.model.addcondtionRecords(_local_3, _local_19);
                            }
                            else
                            {
                                if (this.checkTuan(_local_9))
                                {
                                    _local_20 = new ActivityTuanInfo();
                                    if (_local_2.readBoolean())
                                    {
                                        _local_20.activityID = _local_3;
                                        _local_20.alreadyMoney = _local_2.readInt();
                                        _local_20.alreadyCount = _local_2.readInt();
                                        _local_20.allCount = _local_2.readInt();
                                        this.model.addTuanInfo(_local_3, _local_20);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _local_9.receiveNum = _local_6;
            this.updateData(_local_9);
        }

        public function checkCostReward(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.COST) && ((_arg_1.ActivityChildType == ActivityChildTypes.COST_REWARD_TOTAL) || (_arg_1.ActivityChildType == ActivityChildTypes.COST_REWARD_ONCE))))
            {
                return (true);
            };
            return (false);
        }

        public function checkChargeReward(_arg_1:ActivityInfo):Boolean
        {
            if (((_arg_1.ActivityType == ActivityTypes.CHARGE) && ((_arg_1.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_TOTAL) || (_arg_1.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE))))
            {
                return (true);
            };
            return (false);
        }

        public function checkTuan(_arg_1:ActivityInfo):Boolean
        {
            if (_arg_1.ActivityType == ActivityTypes.TUAN)
            {
                return (true);
            };
            return (false);
        }

        public function sendBuyItem(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            SocketManager.Instance.out.sendBuyItemInActivity(_arg_1, _arg_2, _arg_3, _arg_4);
        }


    }
}//package activity

