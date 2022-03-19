// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.SelfInfo

package ddt.data.player
{
    import flash.utils.Timer;
    import road7th.data.DictionaryData;
    import ddt.data.BagInfo;
    import flash.utils.ByteArray;
    import ddt.data.ConsortiaInfo;
    import SingleDungeon.expedition.ExpeditionInfo;
    import ddt.data.goods.InventoryItemInfo;
    import flash.events.TimerEvent;
    import ddt.manager.SocketManager;
    import ddt.events.BagEvent;
    import flash.utils.Dictionary;
    import ddt.utils.GoodUtils;
    import ddt.manager.SharedManager;
    import ddt.data.BuffInfo;
    import ddt.manager.PVEMapPermissionManager;
    import ddt.data.EquipType;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.view.goods.AddPricePanel;
    import ddt.manager.PlayerManager;
    import bagAndInfo.info.PlayerViewState;
    import ddt.view.chat.ChatData;
    import ddt.view.buff.BuffControl;
    import ddt.manager.TimeManager;
    import ddt.view.chat.ChatInputView;
    import ddt.manager.ChatManager;
    import ddt.manager.PathManager;
    import ddt.manager.ExternalInterfaceManager;
    import ddt.manager.ServerManager;
    import com.hurlant.util.Base64;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.Price;
    import store.data.ComposeCurrentInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import road7th.data.DictionaryEvent;
    import vip.VipController;
    import SingleDungeon.expedition.ExpeditionHistory;
    import com.pickgliss.loader.LoadInterfaceManager;
    import ddt.events.PlayerEvent;
    import ddt.data.VipConfigInfo;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.VipPrivilegeConfigManager;

    public class SelfInfo extends PlayerInfo 
    {

        public static const PET:String = "Pets";
        private static const buffScanTime:int = 60;

        private var timer:Timer;
        private var _count:int;
        private var saveTimer:int;
        public var CivilPlayerList:Array = new Array();
        private var _timer:Timer;
        private var _questionOne:String;
        private var _questionTwo:String;
        private var _leftTimes:int = 5;
        public var IsNovice:Boolean;
        public var rid:String;
        public var _hasPopupLeagueNotice:Boolean;
        public var baiduEnterCode:String;
        private var _marryInfoID:int;
        private var _civilIntroduction:String;
        private var _isPublishEquit:Boolean;
        private var _bagPwdState:Boolean;
        private var _bagLocked:Boolean;
        private var _shouldPassword:Boolean;
        public var IsBanChat:Boolean;
        public var _props:DictionaryData;
        private var _isFirst:int;
        private var FirstLoaded:Boolean = false;
        private var _questList:Array;
        public var PropBag:BagInfo;
        public var FightBag:BagInfo;
        public var TempBag:BagInfo;
        public var ConsortiaBag:BagInfo;
        public var CaddyBag:BagInfo;
        public var farmBag:BagInfo;
        public var vegetableBag:BagInfo;
        private var _overtimeList:Array;
        private var sendedGrade:Array = [];
        public var StoreBag:BagInfo;
        private var _weaklessGuildProgress:ByteArray;
        public var _canTakeVipReward:Boolean = false;
        public var _openVipType:Boolean;
        private var _VIPExpireDay:Object;
        public var LastDate:Object;
        public var isOldPlayerHasValidEquitAtLogin:Boolean;
        private var _vipNextLevelDaysNeeded:int;
        public var systemDate:Object;
        private var _consortiaInfo:ConsortiaInfo;
        private var _gold:Number;
        private var _money:Number = 0;
        private var _ddtMoney:Number = 0;
        private var _armyExploit:int;
        private var _matchMedal:int;
        private var _uesedFinishTime:int;
        private var _lastComposeDic:DictionaryData;
        private var _bagCellUpdateIndex:int;
        private var _bagCellUpdateTime:Date;
        private var _notFinishTime:int;
        private var _isFarmHelper:Boolean;
        private var _composeSkills:DictionaryData;
        private var _fightVipStartTime:Date;
        private var _fightVipValidDate:int;
        private var _isUseFightByVip:Boolean;
        private var _pveInfoID:int;
        private var _hardLevel:int;
        private var _missionOrder:int;
        private var _missionID:int;
        private var _expeditionCurrent:ExpeditionInfo = new ExpeditionInfo();
        private var _expeditionNumAll:int;
        private var _expeditionNumCur:int;
        private var _fbDone:Array;
        private var _getEquipInfo:InventoryItemInfo;
        private var _bagVibleType:int = 0;
        private var _moneyOfCharge:Number;
        private var _isGetNewHandPack:Boolean;
        private var _canTakeVIPPack:Boolean;
        private var _canTakeVIPYearPack:Boolean;
        private var _canTakeLevel3366Pack:Boolean;
        private var _awardLog:int;
        private var _isAward:Boolean = false;
        private var _isFristShow:Boolean = false;

        public function SelfInfo():void
        {
            this.PropBag = new BagInfo(BagInfo.PROPBAG, 48);
            this.FightBag = new BagInfo(BagInfo.FIGHTBAG, 48);
            this.TempBag = new BagInfo(BagInfo.TEMPBAG, 48);
            this.ConsortiaBag = new BagInfo(BagInfo.CONSORTIA, 100);
            this.StoreBag = new BagInfo(BagInfo.STOREBAG, 11);
            this.CaddyBag = new BagInfo(BagInfo.CADDYBAG, 99);
            this.farmBag = new BagInfo(BagInfo.FARM, 100);
            this.vegetableBag = new BagInfo(BagInfo.VEGETABLE, 100);
            _isSelf = true;
        }

        public function getStratTime(_arg_1:int):void
        {
            if (((!(this.timer == null)) && (!(_arg_1 == 0))))
            {
                return;
            };
            this._count = _arg_1;
            if (this._count != 0)
            {
                this.timer = new Timer(1000, _arg_1);
                this.timer.addEventListener(TimerEvent.TIMER, this.__startTimer);
                this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this.timer.start();
            }
            else
            {
                if (((this._count == 0) && (!(this.timer == null))))
                {
                    this.timer.removeEventListener(TimerEvent.TIMER, this.__startTimer);
                    this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                    this.timer.stop();
                    this.timer = null;
                    this._count = 0;
                }
                else
                {
                    if (((this._count == 0) && (this.timer == null)))
                    {
                        this.timer = new Timer(1000, _arg_1);
                        this.timer.addEventListener(TimerEvent.TIMER, this.__startTimer);
                        this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                        this.timer.start();
                    };
                };
            };
        }

        private function __startTimer(_arg_1:TimerEvent):void
        {
            this._count = (this._count - 1);
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.__startTimer);
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this.timer = null;
            SocketManager.Instance.out.sendOpenBagCell(0, this.bagCellUpdateIndex, this.bagCellUpdateIndex);
        }

        public function get count():int
        {
            return (this._count);
        }

        override public function set NickName(_arg_1:String):void
        {
            super.NickName = _arg_1;
        }

        public function set MarryInfoID(_arg_1:int):void
        {
            if (this._marryInfoID == _arg_1)
            {
                return;
            };
            this._marryInfoID = _arg_1;
            onPropertiesChanged("MarryInfoID");
        }

        public function get MarryInfoID():int
        {
            return (this._marryInfoID);
        }

        public function set Introduction(_arg_1:String):void
        {
            if (this._civilIntroduction == _arg_1)
            {
                return;
            };
            this._civilIntroduction = _arg_1;
            onPropertiesChanged("Introduction");
        }

        public function get Introduction():String
        {
            if (this._civilIntroduction == null)
            {
                this._civilIntroduction = "";
            };
            return (this._civilIntroduction);
        }

        public function set IsPublishEquit(_arg_1:Boolean):void
        {
            if (this._isPublishEquit == _arg_1)
            {
                return;
            };
            this._isPublishEquit = _arg_1;
            onPropertiesChanged("IsPublishEquit");
        }

        public function get IsPublishEquit():Boolean
        {
            return (this._isPublishEquit);
        }

        public function set bagPwdState(_arg_1:Boolean):void
        {
            this._bagPwdState = _arg_1;
        }

        public function get bagPwdState():Boolean
        {
            return (this._bagPwdState);
        }

        public function set bagLocked(_arg_1:Boolean):void
        {
            if (this._bagLocked == _arg_1)
            {
                return;
            };
            this._bagLocked = _arg_1;
            onPropertiesChanged("bagLocked");
        }

        public function get bagLocked():Boolean
        {
            if ((!(this._bagPwdState)))
            {
                return (false);
            };
            return (this._bagLocked);
        }

        public function get shouldPassword():Boolean
        {
            return (this._shouldPassword);
        }

        public function set shouldPassword(_arg_1:Boolean):void
        {
            this._shouldPassword = _arg_1;
        }

        public function onReceiveTypes(_arg_1:String):void
        {
            dispatchEvent(new BagEvent(_arg_1, new Dictionary()));
        }

        public function resetProps():void
        {
            this._props = new DictionaryData();
        }

        public function findOvertimeItems(_arg_1:Number=0):Array
        {
            return (this.getOverdueItems());
        }

        public function getOverdueItems():Array
        {
            var _local_1:Array = [];
            var _local_2:Array = [];
            var _local_3:Array = GoodUtils.getOverdueItemsFrom(this.PropBag.items);
            var _local_4:Array = GoodUtils.getOverdueItemsFrom(this.FightBag.items);
            var _local_5:Array = GoodUtils.getOverdueItemsFrom(Bag.items);
            var _local_6:Array = GoodUtils.getOverdueItemsFrom(this.ConsortiaBag.items);
            _local_1 = _local_1.concat(_local_3[0], _local_4[0], [], _local_5[0]);
            _local_2 = _local_2.concat(_local_3[1], _local_4[1], [], _local_5[1]);
            return ([_local_1, _local_2]);
        }

        public function set IsFirst(_arg_1:int):void
        {
            this._isFirst = _arg_1;
            if (this._isFirst == 1)
            {
                this.initIsFirst();
            };
        }

        public function get IsFirst():int
        {
            return (this._isFirst);
        }

        private function initIsFirst():void
        {
            SharedManager.Instance.isWorldBossBuyBuff = false;
            SharedManager.Instance.coolDownFightRobot = false;
            SharedManager.Instance.isRefreshPet = false;
            SharedManager.Instance.isResurrect = false;
            SharedManager.Instance.isReFight = false;
            SharedManager.Instance.save();
        }

        public function findItemCount(_arg_1:int):int
        {
            return (Bag.getItemCountByTemplateId(_arg_1));
        }

        public function loadPlayerItem():void
        {
        }

        public function loadRelatedPlayersInfo():void
        {
            if (this.FirstLoaded)
            {
                return;
            };
            this.FirstLoaded = true;
        }

        private function loadBodyThingComplete(_arg_1:DictionaryData, _arg_2:DictionaryData):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:BuffInfo;
            for each (_local_3 in _arg_1)
            {
                Bag.addItem(_local_3);
            };
            for each (_local_4 in _arg_2)
            {
                super.addBuff(_local_4);
            };
        }

        public function getPveMapPermission(_arg_1:int, _arg_2:int):Boolean
        {
            return (PVEMapPermissionManager.Instance.getPermission(_arg_1, _arg_2, PvePermission));
        }

        public function canEquip(_arg_1:InventoryItemInfo):Boolean
        {
            if ((!(EquipType.canEquip(_arg_1))))
            {
                if ((!(isNaN(_arg_1.CategoryID))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.this"));
                };
            }
            else
            {
                if (_arg_1.getRemainDate() <= 0)
                {
                    AddPricePanel.Instance.setInfo(_arg_1, true);
                    AddPricePanel.Instance.show();
                }
                else
                {
                    if (_arg_1.CategoryID == EquipType.HEALSTONE)
                    {
                        if (Grade >= int(_arg_1.Property1))
                        {
                            return (true);
                        };
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade", _arg_1.Property1));
                        return (false);
                    };
                    if (((!(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)) && ((EquipType.isFashionViewGoods(_arg_1)) || (EquipType.isRingEquipment(_arg_1)))))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.dragGoods.bad"));
                    }
                    else
                    {
                        if ((((!(PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)) && (!(EquipType.isFashionViewGoods(_arg_1)))) && (!(EquipType.isRingEquipment(_arg_1)))))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.dragGoods.bad"));
                        }
                        else
                        {
                            return (true);
                        };
                    };
                };
            };
            return (false);
        }

        override public function addBuff(_arg_1:BuffInfo):void
        {
            super.addBuff(_arg_1);
        }

        private function __refreshSelfInfo(_arg_1:TimerEvent):void
        {
            this.refreshBuff();
        }

        private function refreshBuff():void
        {
            var _local_1:BuffInfo;
            var _local_2:ChatData;
            for each (_local_1 in _buffInfo)
            {
                if ((!(BuffControl.isPayBuff(_local_1))))
                {
                    if (((_local_1.ValidDate - Math.floor(((TimeManager.Instance.Now().time - _local_1.BeginData.time) / (1000 * 60)))) - 1) == buffScanTime)
                    {
                        _local_2 = new ChatData();
                        _local_2.channel = ChatInputView.SYS_TIP;
                        _local_2.msg = LanguageMgr.GetTranslation("tank.view.buffInfo.outDate", _local_1.buffName, buffScanTime);
                        ChatManager.Instance.chat(_local_2);
                    };
                };
            };
        }

        public function achievedQuest(_arg_1:int):Boolean
        {
            if (((this._questList) && (this._questList[_arg_1])))
            {
                return (true);
            };
            return (false);
        }

        public function unlockAllBag():void
        {
            Bag.unLockAll();
            this.PropBag.unLockAll();
        }

        public function getBag(_arg_1:int):BagInfo
        {
            switch (_arg_1)
            {
                case BagInfo.EQUIPBAG:
                    return (Bag);
                case BagInfo.PROPBAG:
                    return (this.PropBag);
                case BagInfo.FIGHTBAG:
                    return (this.FightBag);
                case BagInfo.TEMPBAG:
                    return (this.TempBag);
                case BagInfo.CONSORTIA:
                    return (this.ConsortiaBag);
                case BagInfo.STOREBAG:
                    return (this.StoreBag);
                case BagInfo.CADDYBAG:
                    return (this.CaddyBag);
                case BagInfo.FARM:
                    return (this.farmBag);
                case BagInfo.VEGETABLE:
                    return (this.vegetableBag);
                case BagInfo.BEADBAG:
                    return (BeadBag);
            };
            return (null);
        }

        public function get questionOne():String
        {
            return (this._questionOne);
        }

        public function set questionOne(_arg_1:String):void
        {
            this._questionOne = _arg_1;
        }

        public function get questionTwo():String
        {
            return (this._questionTwo);
        }

        public function set questionTwo(_arg_1:String):void
        {
            this._questionTwo = _arg_1;
        }

        public function get leftTimes():int
        {
            return (this._leftTimes);
        }

        public function set leftTimes(_arg_1:int):void
        {
            this._leftTimes = _arg_1;
        }

        public function get OvertimeListByBody():Array
        {
            return (Bag.findOvertimeItemsByBody());
        }

        public function sendOverTimeListByBody():void
        {
            var _local_2:InventoryItemInfo;
            var _local_1:Array = Bag.findOvertimeItemsByBodyII();
            for each (_local_2 in _local_1)
            {
                SocketManager.Instance.out.sendItemOverDue(_local_2.BagType, _local_2.Place);
            };
        }

        override public function set Grade(_arg_1:int):void
        {
            super.Grade = _arg_1;
            if ((((IsUpGrade) && (PathManager.solveExternalInterfaceEnabel())) && (this.sendedGrade.indexOf(_arg_1) == -1)))
            {
                ExternalInterfaceManager.sendToAgent(2, ID, NickName, ServerManager.Instance.zoneName, Grade);
                this.sendedGrade.push(Grade);
            };
        }

        public function get weaklessGuildProgress():ByteArray
        {
            return (this._weaklessGuildProgress);
        }

        public function set weaklessGuildProgress(_arg_1:ByteArray):void
        {
            this._weaklessGuildProgress = _arg_1;
        }

        public function set weaklessGuildProgressStr(_arg_1:String):void
        {
            this.weaklessGuildProgress = Base64.decodeToByteArray(_arg_1);
        }

        public function get canTakeVipReward():Boolean
        {
            return (this._canTakeVipReward);
        }

        public function set canTakeVipReward(_arg_1:Boolean):void
        {
            if (this._canTakeVipReward == _arg_1)
            {
                return;
            };
            this._canTakeVipReward = _arg_1;
            onPropertiesChanged("canTakeVipReward");
        }

        public function set openVipType(_arg_1:Boolean):void
        {
            this._openVipType = _arg_1;
        }

        public function get openVipType():Boolean
        {
            return (this._openVipType);
        }

        public function get VIPExpireDay():Object
        {
            return (this._VIPExpireDay);
        }

        public function set VIPExpireDay(_arg_1:Object):void
        {
            if (this._VIPExpireDay == _arg_1)
            {
                return;
            };
            this._VIPExpireDay = _arg_1;
            onPropertiesChanged("VipExpireDay");
        }

        public function set VIPNextLevelDaysNeeded(_arg_1:int):void
        {
            if (this._vipNextLevelDaysNeeded == _arg_1)
            {
                return;
            };
            this._vipNextLevelDaysNeeded = _arg_1;
            onPropertiesChanged("VIPNextLevelDaysNeeded");
        }

        public function get VIPNextLevelDaysNeeded():int
        {
            return (this._vipNextLevelDaysNeeded);
        }

        public function get VIPLeftDays():int
        {
            return (int((this.VipLeftHours / 24)));
        }

        public function get VipLeftHours():int
        {
            return (int(((this.VIPExpireDay.valueOf() - this.systemDate.valueOf()) / 3600000)));
        }

        public function get isSameDay():Boolean
        {
            if ((((this.LastDate.fullYear == this.systemDate.fullYear) && (this.LastDate.month == this.systemDate.month)) && (this.LastDate.date == this.systemDate.date)))
            {
                return (true);
            };
            return (false);
        }

        public function set consortiaInfo(_arg_1:ConsortiaInfo):void
        {
            if (this._consortiaInfo == _arg_1)
            {
                return;
            };
            this.consortiaInfo.beginChanges();
            ObjectUtils.copyProperties(this.consortiaInfo, _arg_1);
            this.consortiaInfo.commitChanges();
            onPropertiesChanged("consortiaInfo");
        }

        public function get consortiaInfo():ConsortiaInfo
        {
            if (this._consortiaInfo == null)
            {
                this._consortiaInfo = new ConsortiaInfo();
            };
            return (this._consortiaInfo);
        }

        public function get Gold():Number
        {
            return (this._gold);
        }

        public function set Gold(_arg_1:Number):void
        {
            if (this._gold == _arg_1)
            {
                return;
            };
            this._gold = _arg_1;
            onPropertiesChanged(PlayerInfo.GOLD);
        }

        public function get totalMoney():Number
        {
            return (this.Money + this.DDTMoney);
        }

        public function get Money():Number
        {
            return (this._money);
        }

        public function set Money(_arg_1:Number):void
        {
            if (this._money == _arg_1)
            {
                return;
            };
            this._money = _arg_1;
            onPropertiesChanged(PlayerInfo.MONEY);
        }

        public function get DDTMoney():Number
        {
            return (this._ddtMoney);
        }

        public function set DDTMoney(_arg_1:Number):void
        {
            if (this._ddtMoney == _arg_1)
            {
                return;
            };
            this._ddtMoney = _arg_1;
            onPropertiesChanged(PlayerInfo.DDT_MONEY);
        }

        public function get armyExploit():int
        {
            return (this._armyExploit);
        }

        public function set armyExploit(_arg_1:int):void
        {
            this._armyExploit = _arg_1;
        }

        public function get matchMedal():int
        {
            return (this._matchMedal);
        }

        public function set matchMedal(_arg_1:int):void
        {
            this._matchMedal = _arg_1;
        }

        public function getMoneyByType(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case Price.MONEY:
                    return (this.Money);
                case Price.DDT_MONEY:
                    return (this.DDTMoney);
                case Price.GOLD:
                    return (this.Gold);
                case Price.ARMY_EXPLOIT:
                    return (this.armyExploit);
                case Price.MATCH_MEDAL:
                    return (this.matchMedal);
            };
            return (0);
        }

        public function set uesedFinishTime(_arg_1:int):void
        {
            this._uesedFinishTime = _arg_1;
        }

        public function get uesedFinishTime():int
        {
            return (this._uesedFinishTime);
        }

        public function get lastComposeDic():DictionaryData
        {
            return (this._lastComposeDic);
        }

        public function set lastComposeDic(_arg_1:DictionaryData):void
        {
            var _local_2:ComposeCurrentInfo;
            var _local_3:Number;
            var _local_4:Number;
            this._lastComposeDic = _arg_1;
            for each (_local_2 in this._lastComposeDic)
            {
                if (_local_2.templeteID != 0)
                {
                    _local_3 = this.systemDate.getTime();
                    _local_4 = (_local_2.lastComposeTime.getTime() + (_local_2.composeNeedTime * 1000));
                    _local_2.remainTime = ((_local_4 - _local_3) / 1000);
                };
            };
        }

        public function getCurComposeInfoByType(_arg_1:int):ComposeCurrentInfo
        {
            var _local_2:ComposeCurrentInfo;
            var _local_3:ItemTemplateInfo;
            var _local_4:EquipmentTemplateInfo;
            for each (_local_2 in this._lastComposeDic)
            {
                _local_3 = ItemManager.Instance.getTemplateById(_local_2.templeteID);
                if (_local_3.CategoryID == EquipType.EQUIP)
                {
                    _local_4 = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
                    if (_arg_1 == 400)
                    {
                        if (_local_4.TemplateType > 6)
                        {
                            return (_local_2);
                        };
                    }
                    else
                    {
                        if (((_local_4.TemplateType <= 6) && (_local_3.CategoryID == _arg_1)))
                        {
                            return (_local_2);
                        };
                    };
                }
                else
                {
                    if (_local_3.CategoryID == _arg_1)
                    {
                        return (_local_2);
                    };
                };
            };
            return (null);
        }

        public function set bagCellUpdateIndex(_arg_1:int):void
        {
            this._bagCellUpdateIndex = _arg_1;
        }

        public function get bagCellUpdateIndex():int
        {
            return (this._bagCellUpdateIndex);
        }

        public function set bagCellUpdateTime(_arg_1:Date):void
        {
            this._bagCellUpdateTime = _arg_1;
        }

        public function get bagCellUpdateTime():Date
        {
            return (this._bagCellUpdateTime);
        }

        public function set notFinishTime(_arg_1:int):void
        {
            this._notFinishTime = _arg_1;
        }

        public function get notFinishTime():int
        {
            return (this._notFinishTime);
        }

        public function get isFarmHelper():Boolean
        {
            return (this._isFarmHelper);
        }

        public function set isFarmHelper(_arg_1:Boolean):void
        {
            this._isFarmHelper = _arg_1;
        }

        public function get composeSkills():DictionaryData
        {
            return (this._composeSkills);
        }

        public function set composeSkills(_arg_1:DictionaryData):void
        {
            this._composeSkills = _arg_1;
        }

        override public function get pets():DictionaryData
        {
            if (_pets == null)
            {
                _pets = new DictionaryData();
                _pets.addEventListener("add", this.__petsDataChanged);
                _pets.addEventListener("update", this.__petsDataChanged);
                _pets.addEventListener("remove", this.__petsDataChanged);
            };
            return (_pets);
        }

        protected function __petsDataChanged(_arg_1:DictionaryEvent):void
        {
            onPropertiesChanged(PET);
        }

        public function get fightVipStartTime():Date
        {
            return (this._fightVipStartTime);
        }

        public function set fightVipStartTime(_arg_1:Date):void
        {
            this._fightVipStartTime = _arg_1;
        }

        public function get fightVipValidDate():int
        {
            return (this._fightVipValidDate);
        }

        public function set fightVipValidDate(_arg_1:int):void
        {
            this._fightVipValidDate = _arg_1;
        }

        public function get isUseFightByVip():Boolean
        {
            if (VipController.instance.getPrivilegeByIndex(9))
            {
                return (true);
            };
            return (false);
        }

        public function get isRunQuicklyByVip():Boolean
        {
            if (VipController.instance.getPrivilegeByIndex(8))
            {
                return (true);
            };
            return (false);
        }

        public function get PveInfoID():int
        {
            return (this._pveInfoID);
        }

        public function set PveInfoID(_arg_1:int):void
        {
            this._pveInfoID = _arg_1;
        }

        public function get HardLevel():int
        {
            return (this._hardLevel);
        }

        public function set HardLevel(_arg_1:int):void
        {
            this._hardLevel = _arg_1;
        }

        public function get MissionOrder():int
        {
            return (this._missionOrder);
        }

        public function set MissionOrder(_arg_1:int):void
        {
            this._missionOrder = _arg_1;
        }

        public function get MissionID():int
        {
            return (this._missionID);
        }

        public function set MissionID(_arg_1:int):void
        {
            this._missionID = _arg_1;
        }

        public function get expeditionCurrent():ExpeditionInfo
        {
            return (this._expeditionCurrent);
        }

        public function set expeditionCurrent(_arg_1:ExpeditionInfo):void
        {
            this._expeditionCurrent = _arg_1;
        }

        public function get expeditionNumAll():int
        {
            return (this._expeditionNumAll);
        }

        public function set expeditionNumAll(_arg_1:int):void
        {
            this._expeditionNumAll = _arg_1;
        }

        public function get expeditionNumCur():int
        {
            return (this._expeditionNumCur);
        }

        public function set expeditionNumCur(_arg_1:int):void
        {
            this._expeditionNumCur = _arg_1;
        }

        public function get expeditionNumLast():int
        {
            return ((this._expeditionNumAll - this._expeditionNumCur) + 1);
        }

        public function getfbDoneByScenceID(_arg_1:int):Boolean
        {
            return (ExpeditionHistory.instance.get(_arg_1));
        }

        public function set fbDoneByString(_arg_1:String):void
        {
            ExpeditionHistory.instance.sets(_arg_1);
        }

        public function set EquipInfo(_arg_1:InventoryItemInfo):void
        {
            this._getEquipInfo = _arg_1;
        }

        public function get EquipInfo():InventoryItemInfo
        {
            return (this._getEquipInfo);
        }

        public function set bagVibleType(_arg_1:int):void
        {
            this._bagVibleType = _arg_1;
        }

        public function get bagVibleType():int
        {
            return (this._bagVibleType);
        }

        public function getStrengthCompleteCount(_arg_1:int):int
        {
            var _local_6:InventoryItemInfo;
            var _local_2:uint = 6;
            var _local_3:int;
            var _local_4:DictionaryData = new DictionaryData();
            var _local_5:int = 1;
            while (_local_5 <= _local_2)
            {
                _local_4 = this.Bag.findItemsByTemplateType(_local_5);
                for each (_local_6 in _local_4)
                {
                    if (_local_6.StrengthenLevel >= _arg_1)
                    {
                        _local_3++;
                        break;
                    };
                };
                _local_5++;
            };
            return ((_local_3 < _local_2) ? 0 : _arg_1);
        }

        public function getEmbedRuneCount(_arg_1:int):int
        {
            var _local_3:InventoryItemInfo;
            var _local_4:int;
            var _local_5:ItemTemplateInfo;
            var _local_2:int;
            for each (_local_3 in Bag.items)
            {
                _local_4 = 1;
                while (_local_4 <= 4)
                {
                    if (_local_3[("Hole" + _local_4)])
                    {
                        _local_5 = ItemManager.Instance.getTemplateById(_local_3[("Hole" + _local_4)]);
                        if (((_local_5) && (int(_local_5.Property1) >= _arg_1)))
                        {
                            _local_2++;
                        };
                    };
                    _local_4++;
                };
            };
            return (_local_2);
        }

        override public function set Fatigue(_arg_1:int):void
        {
            super.Fatigue = _arg_1;
            LoadInterfaceManager.setFatigue(String(_arg_1));
        }

        public function get moneyOfCharge():Number
        {
            return (this._moneyOfCharge);
        }

        public function set moneyOfCharge(_arg_1:Number):void
        {
            this._moneyOfCharge = _arg_1;
            dispatchEvent(new PlayerEvent(PlayerEvent.MONEY_CHARGE));
        }

        public function get isGetNewHandPack():Boolean
        {
            return (this._isGetNewHandPack);
        }

        public function set isGetNewHandPack(_arg_1:Boolean):void
        {
            this._isGetNewHandPack = _arg_1;
            onPropertiesChanged("isGetNewHandPack");
        }

        public function get canTakeVIPPack():Boolean
        {
            return (this._canTakeVIPPack);
        }

        public function set canTakeVIPPack(_arg_1:Boolean):void
        {
            this._canTakeVIPPack = _arg_1;
        }

        public function get canTakeVIPYearPack():Boolean
        {
            return (this._canTakeVIPYearPack);
        }

        public function set canTakeVIPYearPack(_arg_1:Boolean):void
        {
            this._canTakeVIPYearPack = _arg_1;
        }

        public function get canTakeLevel3366Pack():Boolean
        {
            return (this._canTakeLevel3366Pack);
        }

        public function set canTakeLevel3366Pack(_arg_1:Boolean):void
        {
            this._canTakeLevel3366Pack = _arg_1;
        }

        public function getBuyFatigueMoney():int
        {
            var _local_2:VipConfigInfo;
            var _local_3:int;
            var _local_1:Array = ServerConfigManager.instance.getBuyFatigueCostMoney(IsVIP);
            if (IsVIP)
            {
                _local_2 = VipPrivilegeConfigManager.Instance.getById(4);
                _local_3 = _local_2[("Level" + VIPLevel)];
                if (fatigueCount < _local_3)
                {
                    return (_local_1[fatigueCount]);
                };
                return (0);
            };
            if (fatigueCount < 1)
            {
                return (_local_1[0]);
            };
            return (0);
        }

        public function get getRestBuyFatigueCount():int
        {
            var _local_1:int;
            var _local_2:VipConfigInfo;
            var _local_3:int;
            if (IsVIP)
            {
                _local_2 = VipPrivilegeConfigManager.Instance.getById(4);
                _local_3 = _local_2[("Level" + VIPLevel)];
                _local_1 = (_local_3 - fatigueCount);
            }
            else
            {
                _local_1 = (1 - fatigueCount);
            };
            return ((_local_1 < 0) ? 0 : _local_1);
        }

        public function get awardLog():int
        {
            return (this._awardLog);
        }

        public function set awardLog(_arg_1:int):void
        {
            this._awardLog = _arg_1;
        }

        public function get isAward():Boolean
        {
            return (this._isAward);
        }

        public function set isAward(_arg_1:Boolean):void
        {
            this._isAward = _arg_1;
        }

        public function get isFristShow():Boolean
        {
            return (this._isFristShow);
        }

        public function set isFristShow(_arg_1:Boolean):void
        {
            this._isFristShow = _arg_1;
        }


    }
}//package ddt.data.player

class DateGeter 
{

    public static var date:Date;


}


