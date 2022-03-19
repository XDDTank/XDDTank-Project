// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.BeadManager

package bead
{
    import flash.events.EventDispatcher;
    import bead.model.BeadConfig;
    import ddt.data.BagInfo;
    import __AS3__.vec.Vector;
    import bead.view.BeadCombineConfirmFrame;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import ddt.data.ShopType;
    import ddt.data.analyze.BeadDataAnalyzer;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import bead.events.BeadEvent;
    import ddt.manager.SocketManager;
    import bead.view.BeadOpenCellTipPanel;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.data.VipConfigInfo;
    import __AS3__.vec.*;

    public class BeadManager extends EventDispatcher 
    {

        public static const BEAD_OPEN_GUIDE_EVNET:String = "bead_open_guide_event";
        public static const BEAD_COMBINE_CONFIRM_RETURN_EVENT:String = "bead_combine_confirm_return_event";
        private static var _instance:BeadManager;

        public var doWhatHandle:int = -1;
        public var beadConfig:BeadConfig;
        private var _list:Object;
        private var _scoreShopItemList:Array;
        private var _func:Function;
        private var _funcParams:Array;
        private var _beadBag:BagInfo;
        private var _isCanGuide:Boolean = false;
        private var _curLevel:int = 100;
        private var _curPlace:int = -1;
        public var guildeStepI:Boolean;
        private var _combineLowList:Array;
        private var _combineConfirmReFuc:Function;
        public var _confirmFrameList:Vector.<BeadCombineConfirmFrame>;
        public var _combinePlaceList:Array;
        public var _isCombineOneKey:Boolean;
        public var comineCount:int;
        private var _goldAlertFrame:BaseAlerFrame;


        public static function get instance():BeadManager
        {
            if (_instance == null)
            {
                _instance = new (BeadManager)();
            };
            return (_instance);
        }


        public function get beadBag():BagInfo
        {
            return (this._beadBag);
        }

        public function get curPlace():int
        {
            return (this._curPlace);
        }

        public function preJudgeLevelUp(_arg_1:int, _arg_2:int):void
        {
            this._curPlace = _arg_1;
            this._curLevel = _arg_2;
        }

        public function recordCombineOnekey():void
        {
            this.preJudgeLevelUp(12, (this._beadBag.items[12] as InventoryItemInfo).beadLevel);
        }

        public function doJudgeLevelUp():Boolean
        {
            if (((this.doWhatHandle == 1) || (this.doWhatHandle == 2)))
            {
                if ((((!(this._curPlace == -1)) && (!(this._curPlace == 100))) && (!(this._curLevel == -1))))
                {
                    if ((this._beadBag.items[this._curPlace] as InventoryItemInfo).beadLevel > this._curLevel)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function get isCanGuide():Boolean
        {
            return (this._isCanGuide);
        }

        public function get list():Object
        {
            return (this._list);
        }

        public function get scoreShopItemList():Array
        {
            return (this._scoreShopItemList);
        }

        public function calExpLimit(_arg_1:InventoryItemInfo):Array
        {
            var _local_2:Object = BeadManager.instance.list;
            if ((!(_local_2)))
            {
                return ([0, 0]);
            };
            _arg_1.beadLevel = ((_arg_1.beadLevel == 0) ? 1 : _arg_1.beadLevel);
            var _local_3:int = ((_arg_1.beadLevel == 30) ? 29 : _arg_1.beadLevel);
            var _local_4:int = int(_local_2[_arg_1.Property2][_local_3.toString()].Exp);
            var _local_5:int = int(_local_2[_arg_1.Property2][(_local_3 + 1).toString()].Exp);
            if (_arg_1.beadLevel == 30)
            {
                return ([(_local_5 - _local_4), (_local_5 - _local_4)]);
            };
            return ([(_arg_1.beadExp - _local_4), (_local_5 - _local_4)]);
        }

        public function loadBeadModule(_arg_1:Function=null, _arg_2:Array=null):void
        {
            this._func = _arg_1;
            this._funcParams = _arg_2;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTBEAD);
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
        }

        private function onUimoduleLoadProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTBEAD)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function loadCompleteHandler(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTBEAD)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.loadCompleteHandler);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.onUimoduleLoadProgress);
                if (null != this._func)
                {
                    this._func.apply(null, this._funcParams);
                };
                this._func = null;
                this._funcParams = null;
            };
        }

        public function setup():void
        {
            this._beadBag = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
            this._beadBag.addEventListener(BagEvent.UPDATE, this.bagUpdateHandler, false, 0, true);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onChange);
            this.setupBeadScoreShop();
        }

        private function setupBeadScoreShop():void
        {
            var _local_4:ShopItemInfo;
            var _local_5:Object;
            var _local_1:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.BEAD_GOODS_TYPE);
            this._scoreShopItemList = [];
            if (_local_1 == null)
            {
                return;
            };
            var _local_2:int = _local_1.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = ShopManager.Instance.getShopItemByGoodsID(_local_1[_local_3].GoodsID);
                _local_5 = {};
                _local_5.id = _local_4.TemplateID;
                _local_5.score = _local_4.AValue1;
                _local_5.pos = (_local_3 + 1);
                this._scoreShopItemList.push(_local_5);
                _local_3++;
            };
        }

        private function bagUpdateHandler(_arg_1:BagEvent):void
        {
            if (this.getBeadTempBagBeadCount() >= 1)
            {
                this._isCanGuide = true;
            };
        }

        private function getBeadTempBagBeadCount():int
        {
            var _local_1:int;
            var _local_2:int = 13;
            while (_local_2 <= 27)
            {
                if (this._beadBag.items[_local_2])
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function getConfigData(_arg_1:BeadDataAnalyzer):void
        {
            this._list = _arg_1.list;
            this.beadConfig = _arg_1.beadConfig;
        }

        public function getBeadColorName(_arg_1:InventoryItemInfo, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:String=""):String
        {
            var _local_5:String;
            var _local_6:String;
            if (_arg_3)
            {
                _local_5 = this.getBeadNameColor2(_arg_1);
            }
            else
            {
                _local_5 = this.getBeadNameColor(_arg_1);
            };
            if (_arg_2)
            {
                _local_6 = LanguageMgr.GetTranslation("beadSystem.bead.nameLevel", _arg_1.Name, _arg_1.beadLevel, _arg_4);
            }
            else
            {
                _local_6 = _arg_1.Name;
            };
            if (_arg_3)
            {
                _local_6 = LanguageMgr.GetTranslation("beadSystem.bead.name.bold.html", _local_6);
            };
            return (LanguageMgr.GetTranslation("beadSystem.bead.name.color.html", _local_5, _local_6));
        }

        public function getBeadNameColor(_arg_1:InventoryItemInfo):String
        {
            var _local_2:int = int(_arg_1.Property2);
            var _local_3:String = "#fffcd1";
            switch (_local_2)
            {
                case 0:
                    _local_3 = "#ffff01";
                    break;
                case 1:
                case 2:
                    _local_3 = "#C4E5FF";
                    break;
                case 3:
                case 4:
                    _local_3 = "#2CFD2C";
                    break;
                case 5:
                case 6:
                    _local_3 = "#00FCFF";
                    break;
                case 7:
                case 8:
                    _local_3 = "#CC55F1";
                    break;
                case 9:
                case 10:
                    _local_3 = "#DC2DCA";
                    break;
                default:
                    _local_3 = "#fffcd1";
            };
            return (_local_3);
        }

        public function getBeadNameColor2(_arg_1:InventoryItemInfo):String
        {
            var _local_2:int = int(_arg_1.Property2);
            var _local_3:String = "#fffcd1";
            switch (_local_2)
            {
                case 0:
                    _local_3 = "#ff8400";
                    break;
                case 1:
                case 2:
                    _local_3 = "#7aa7bc";
                    break;
                case 3:
                case 4:
                    _local_3 = "#36d51c";
                    break;
                case 5:
                case 6:
                    _local_3 = "#3e98dd";
                    break;
                case 7:
                case 8:
                    _local_3 = "#CC55F1";
                    break;
                case 9:
                case 10:
                    _local_3 = "#DC2DCA";
                    break;
                default:
                    _local_3 = "#7aa7bc";
            };
            return (_local_3);
        }

        public function getDescriptionStr(_arg_1:InventoryItemInfo):String
        {
            var _local_2:String = this.getBeadNameColor(_arg_1);
            var _local_3:int = int(_arg_1.Property3);
            var _local_4:int = this.calVaule(_arg_1);
            var _local_5:Array = LanguageMgr.GetTranslation("beadSystem.bead.nameStr").split(",");
            return (LanguageMgr.GetTranslation("beadSystem.bead.desc.tip", _local_2, _local_5[_local_3], _local_4));
        }

        public function getNextDescriptionStr(_arg_1:InventoryItemInfo):String
        {
            var _local_2:InventoryItemInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(_local_2, _arg_1);
            _local_2.beadLevel = (_arg_1.beadLevel + 1);
            var _local_3:String = this.getBeadNameColor(_local_2);
            var _local_4:int = int(_local_2.Property3);
            var _local_5:int = this.calVaule(_local_2);
            var _local_6:Array = LanguageMgr.GetTranslation("beadSystem.bead.nameStr").split(",");
            return (LanguageMgr.GetTranslation("beadSystem.bead.desc.tip", _local_3, _local_6[_local_4], _local_5));
        }

        public function calVaule(_arg_1:InventoryItemInfo):int
        {
            var _local_2:Object;
            var _local_3:int;
            var _local_4:int;
            if (int(_arg_1.Property2) == 0)
            {
                return (int(_arg_1.Property5));
            };
            if (this.list)
            {
                _arg_1.beadLevel = ((_arg_1.beadLevel == 0) ? 1 : _arg_1.beadLevel);
                _local_2 = this.list[_arg_1.Property2][_arg_1.beadLevel.toString()];
                _local_3 = int(_arg_1.Property3);
                _local_4 = 0;
                switch (_local_3)
                {
                    case 1:
                        _local_4 = _local_2.Attack;
                        break;
                    case 2:
                        _local_4 = _local_2.Defence;
                        break;
                    case 3:
                        _local_4 = _local_2.Agility;
                        break;
                    case 4:
                        _local_4 = _local_2.Lucky;
                        break;
                    case 5:
                        _local_4 = _local_2.RootBone;
                        break;
                    default:
                        _local_4 = 0;
                };
                return (_local_4);
            };
            return (0);
        }

        public function combineConfirm(_arg_1:int, _arg_2:Function):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:InventoryItemInfo;
            var _local_7:int;
            var _local_8:BeadCombineConfirmFrame;
            this.comineCount = 0;
            if (_arg_1 == -1)
            {
                _local_3 = 13;
                _local_4 = 27;
                this._isCombineOneKey = true;
            }
            else
            {
                _local_3 = _arg_1;
                _local_4 = _arg_1;
                this._isCombineOneKey = false;
            };
            this._combineConfirmReFuc = _arg_2;
            this._confirmFrameList = new Vector.<BeadCombineConfirmFrame>();
            this._combinePlaceList = [];
            this._combineLowList = [];
            if (this._isCombineOneKey)
            {
                _local_5 = _local_4;
                while (_local_5 >= _local_3)
                {
                    _local_6 = (this._beadBag.items[_local_5] as InventoryItemInfo);
                    if (((_local_6) && (_local_6.beadIsLock == 0)))
                    {
                        if (((int(_local_6.Property2) >= 5) || (_local_6.beadLevel >= 15)))
                        {
                            _local_7 = BeadManager.instance.list[_local_6.Property2][_local_6.beadLevel.toString()].SellScore;
                            _local_8 = ComponentFactory.Instance.creatCustomObject("beadCombineConfirmFrame");
                            _local_8.show(LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.tip", this.getBeadColorName(_local_6, true, true), this.calRequireExp(_local_6), ((_local_7 < 0) ? 0 : _local_7)), _local_5);
                            _local_8.addEventListener(BEAD_COMBINE_CONFIRM_RETURN_EVENT, this.combineConfirmReturnHandler);
                            this._confirmFrameList.push(_local_8);
                            dispatchEvent(new BeadEvent(BeadEvent.SHOW_ConfirmFrme));
                        }
                        else
                        {
                            if (_local_6.beadLevel != 20)
                            {
                                this._combinePlaceList.push(_local_5);
                            };
                        };
                    };
                    _local_5--;
                };
            };
            if (((this._confirmFrameList.length == 0) && (!(this._combineConfirmReFuc == null))))
            {
                this.comineCount = 1;
                this._combineConfirmReFuc.apply();
                this._combineConfirmReFuc = null;
            };
        }

        private function combineConfirmReturnHandler(_arg_1:Event):void
        {
            var _local_3:int;
            var _local_2:BeadCombineConfirmFrame = (_arg_1.currentTarget as BeadCombineConfirmFrame);
            _local_2.removeEventListener(BEAD_COMBINE_CONFIRM_RETURN_EVENT, this.combineConfirmReturnHandler);
            if ((!(this._isCombineOneKey)))
            {
                if (_local_2.isYes)
                {
                    if (this._combineConfirmReFuc != null)
                    {
                        this._combineConfirmReFuc.apply();
                        this._combineConfirmReFuc = null;
                    };
                };
            }
            else
            {
                if (_local_2.isYes)
                {
                    this._combinePlaceList.push(_local_2.place);
                }
                else
                {
                    dispatchEvent(new BeadEvent(BeadEvent.BEAD_LOCK, _local_2.place));
                };
                this._confirmFrameList.pop();
                if (this._confirmFrameList.length <= 0)
                {
                    _local_3 = 0;
                    while (_local_3 < this._combinePlaceList.length)
                    {
                        SocketManager.Instance.out.sendBeadCombine(12, this._combinePlaceList[_local_3], 0);
                        _local_3++;
                    };
                    if (((!(this._combineConfirmReFuc == null)) && (!(this._combinePlaceList.length == 0))))
                    {
                        this._combineConfirmReFuc.apply();
                        this.comineCount = this._combinePlaceList.length;
                        this._combineConfirmReFuc = null;
                    };
                };
            };
        }

        private function __onChange(_arg_1:PlayerPropertyEvent):void
        {
            if ((((_arg_1.changedProperties["Grade"]) && (PlayerManager.Instance.Self.onLevelUp)) && ((PlayerManager.Instance.Self.Grade % 10) == 0)))
            {
                this.showBeadOpenCellTipPanel();
            };
        }

        public function showBeadOpenCellTipPanel():void
        {
            var _local_1:BeadOpenCellTipPanel = ComponentFactory.Instance.creatCustomObject("bead.openBeadCellTipPanel");
            _local_1.show();
        }

        public function buyGoldFrame():void
        {
            if (this._goldAlertFrame == null)
            {
                this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                this._goldAlertFrame.moveEnable = false;
                this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            };
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            this._goldAlertFrame.dispose();
            this._goldAlertFrame = null;
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.openGoldFrame();
            };
        }

        public function openGoldFrame():void
        {
            var _local_1:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _local_1.itemID = EquipType.GOLD_BOX;
            _local_1.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function canVIPOpen(_arg_1:int):Boolean
        {
            var _local_2:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_arg_1);
            var _local_3:int = int(_local_2[("Level" + PlayerManager.Instance.Self.VIPLevel)]);
            return ((_local_3 > 0) ? true : false);
        }

        public function needVIPLevel(_arg_1:int):int
        {
            var _local_2:int;
            var _local_4:int;
            var _local_3:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_arg_1);
            _local_2 = 1;
            while (_local_2 < 10)
            {
                _local_4 = int(_local_3[("Level" + _local_2)]);
                if (_local_4 > 0) break;
                _local_2++;
            };
            return (_local_2);
        }

        public function calRequireExp(_arg_1:InventoryItemInfo):int
        {
            return (_arg_1.beadExp + int(_arg_1.Property4));
        }


    }
}//package bead

