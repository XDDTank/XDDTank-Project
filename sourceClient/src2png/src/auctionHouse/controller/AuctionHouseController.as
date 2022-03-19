// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.controller.AuctionHouseController

package auctionHouse.controller
{
    import ddt.states.BaseStateView;
    import auctionHouse.model.AuctionHouseModel;
    import auctionHouse.view.AuctionHouseFrame;
    import auctionHouse.view.AuctionRightView;
    import com.pickgliss.ui.ComponentFactory;
    import auctionHouse.event.AuctionHouseEvent;
    import auctionHouse.AuctionState;
    import ddt.manager.ItemManager;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PlayerManager;
    import ddt.view.MainToolBar;
    import ddt.states.StateType;
    import ddt.data.goods.CateCoryInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.utils.MD5;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import auctionHouse.analyze.AuctionAnalyzer;
    import com.pickgliss.loader.LoaderEvent;
    import auctionHouse.view.SimpleLoading;
    import __AS3__.vec.Vector;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.data.goods.InventoryItemInfo;

    public class AuctionHouseController extends BaseStateView 
    {

        private static var _instance:AuctionHouseController;

        private var _model:AuctionHouseModel;
        private var _view:AuctionHouseFrame;
        private var _rightView:AuctionRightView;


        public static function get Instance():AuctionHouseController
        {
            if (_instance == null)
            {
                _instance = new (AuctionHouseController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.initAuctionHouse();
        }

        private function initAuctionHouse():void
        {
            this._model = new AuctionHouseModel();
            this._view = ComponentFactory.Instance.creatCustomObject("ddtAuctionHouseFrame", [this, this._model]);
            this._view.show();
            this._view.addEventListener(AuctionHouseEvent.CLOSE_FRAME, this.__close);
            AuctionState.CURRENTSTATE = "browse";
            this._model.category = ItemManager.Instance.categorys;
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_REFRESH, this.__updateAuction);
        }

        private function __close(_arg_1:AuctionHouseEvent):void
        {
            this.dispose();
            PlayerManager.Instance.Self.unlockAllBag();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH, this.__updateAuction);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
        }

        public function set model(_arg_1:AuctionHouseModel):void
        {
            this._model = _arg_1;
        }

        public function get model():AuctionHouseModel
        {
            return (this._model);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            super.leaving(_arg_1);
            this.dispose();
            MainToolBar.Instance.hide();
            PlayerManager.Instance.Self.unlockAllBag();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH, this.__updateAuction);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.AUCTION);
        }

        public function setState(_arg_1:String):void
        {
            this._model.state = _arg_1;
            AuctionState.CURRENTSTATE = _arg_1;
        }

        public function browseTypeChange(_arg_1:CateCoryInfo, _arg_2:int=-1):void
        {
            var _local_3:CateCoryInfo;
            if (_arg_1 == null)
            {
                _local_3 = this._model.getCatecoryById(_arg_2);
            }
            else
            {
                _local_3 = _arg_1;
            };
            this._model.currentBrowseGoodInfo = _local_3;
        }

        public function browseTypeChangeNull():void
        {
            this._model.currentBrowseGoodInfo = null;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._view)
            {
                this._view.dispose();
            };
            this._view = null;
            if (this._model)
            {
                this._model.dispose();
            };
            this._model = null;
            if (this._rightView)
            {
                ObjectUtils.disposeObject(this._rightView);
            };
            this._rightView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function searchAuctionList(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:uint=0, _arg_8:String="false", _arg_9:String=""):void
        {
            if (AuctionHouseModel.searchType == 1)
            {
                _arg_2 = "";
            };
            this.startLoadAuctionInfo(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
            (this._view as AuctionHouseFrame).forbidChangeState();
        }

        private function startLoadAuctionInfo(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:uint=0, _arg_8:String="false", _arg_9:String=""):void
        {
            var _local_10:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_10["page"] = _arg_1;
            _local_10["name"] = _arg_2;
            _local_10["type"] = _arg_3;
            _local_10["pay"] = _arg_4;
            _local_10["userID"] = _arg_5;
            _local_10["buyID"] = _arg_6;
            _local_10["order"] = _arg_7;
            _local_10["sort"] = _arg_8;
            _local_10["Auctions"] = _arg_9;
            _local_10["selfid"] = PlayerManager.Instance.Self.ID;
            _local_10["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
            _local_10["rnd"] = Math.random();
            var _local_11:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AuctionPageList.ashx"), BaseLoader.REQUEST_LOADER, _local_10);
            _local_11.loadErrorMessage = LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseListError");
            _local_11.analyzer = new AuctionAnalyzer(this.__searchResult);
            LoadResourceManager.instance.startLoad(_local_11);
            _local_11.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            mouseChildren = false;
            mouseEnabled = false;
            if (AuctionHouseModel._dimBooble == false)
            {
                SimpleLoading.instance.show();
            };
        }

        private function __searchResult(_arg_1:AuctionAnalyzer):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:Array;
            var _local_6:int;
            mouseChildren = true;
            mouseEnabled = true;
            if ((!(this._view)))
            {
                return;
            };
            SimpleLoading.instance.hide();
            var _local_2:Vector.<AuctionGoodsInfo> = _arg_1.list;
            if (this._model.state == AuctionState.SELL)
            {
                this._model.clearMyAuction();
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    this._model.addMyAuction(_local_2[_local_3]);
                    _local_3++;
                };
                this._model.sellTotal = _arg_1.total;
            }
            else
            {
                if (this._model.state == AuctionState.BROWSE)
                {
                    this._model.clearBrowseAuctionData();
                    if (((_local_2.length == 0) && (!(AuctionHouseModel.searchType == 3))))
                    {
                        if (AuctionHouseModel._dimBooble == false)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.controller.AuctionHouseController"));
                        };
                    };
                    _local_4 = 0;
                    while (_local_4 < _local_2.length)
                    {
                        this._model.addBrowseAuctionData(_local_2[_local_4]);
                        _local_4++;
                    };
                    this._model.browseTotal = _arg_1.total;
                }
                else
                {
                    if (this._model.state == AuctionState.BUY)
                    {
                        _local_5 = new Array();
                        this._model.clearBuyAuctionData();
                        _local_6 = 0;
                        while (_local_6 < _local_2.length)
                        {
                            this._model.addBuyAuctionData(_local_2[_local_6]);
                            _local_5.push(_local_2[_local_6].AuctionID);
                            _local_6++;
                        };
                        this._model.buyTotal = _arg_1.total;
                        SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = _local_5;
                        SharedManager.Instance.save();
                    };
                };
            };
            (this._view as AuctionHouseFrame).allowChangeState();
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function __updateAuction(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:Boolean;
            var _local_5:InventoryItemInfo;
            _arg_1.pkg.deCompress();
            var _local_2:AuctionGoodsInfo = new AuctionGoodsInfo();
            _local_2.AuctionID = _arg_1.pkg.readInt();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            if (_local_3)
            {
                _local_2.AuctioneerID = _arg_1.pkg.readInt();
                _local_2.AuctioneerName = _arg_1.pkg.readUTF();
                _local_2.beginDateObj = _arg_1.pkg.readDate();
                _local_2.BuyerID = _arg_1.pkg.readInt();
                _local_2.BuyerName = _arg_1.pkg.readUTF();
                _local_2.ItemID = _arg_1.pkg.readInt();
                _local_2.Mouthful = _arg_1.pkg.readInt();
                _local_2.PayType = _arg_1.pkg.readInt();
                _local_2.Price = _arg_1.pkg.readInt();
                _local_2.Rise = _arg_1.pkg.readInt();
                _local_2.ValidDate = _arg_1.pkg.readInt();
                _local_4 = _arg_1.pkg.readBoolean();
                if (_local_4)
                {
                    _local_5 = new InventoryItemInfo();
                    _local_5.Count = _arg_1.pkg.readInt();
                    _local_5.TemplateID = _arg_1.pkg.readInt();
                    _local_5.AttackCompose = _arg_1.pkg.readInt();
                    _local_5.DefendCompose = _arg_1.pkg.readInt();
                    _local_5.AgilityCompose = _arg_1.pkg.readInt();
                    _local_5.LuckCompose = _arg_1.pkg.readInt();
                    _local_5.StrengthenLevel = _arg_1.pkg.readInt();
                    _local_5.IsBinds = _arg_1.pkg.readBoolean();
                    _local_5.IsJudge = _arg_1.pkg.readBoolean();
                    _local_5.BeginDate = _arg_1.pkg.readDateString();
                    _local_5.ValidDate = _arg_1.pkg.readInt();
                    _local_5.Color = _arg_1.pkg.readUTF();
                    _local_5.Skin = _arg_1.pkg.readUTF();
                    _local_5.IsUsed = _arg_1.pkg.readBoolean();
                    _local_5.Hole1 = _arg_1.pkg.readInt();
                    _local_5.Hole2 = _arg_1.pkg.readInt();
                    _local_5.Hole3 = _arg_1.pkg.readInt();
                    _local_5.Hole4 = _arg_1.pkg.readInt();
                    _local_5.Hole5 = _arg_1.pkg.readInt();
                    _local_5.Hole6 = _arg_1.pkg.readInt();
                    _local_5.Pic = _arg_1.pkg.readUTF();
                    _local_5.RefineryLevel = _arg_1.pkg.readInt();
                    _local_5.DiscolorValidDate = _arg_1.pkg.readDateString();
                    _local_5.Hole5Level = _arg_1.pkg.readByte();
                    _local_5.Hole5Exp = _arg_1.pkg.readInt();
                    _local_5.Hole6Level = _arg_1.pkg.readByte();
                    _local_5.Hole6Exp = _arg_1.pkg.readInt();
                    ItemManager.fill(_local_5);
                    _local_2.BagItemInfo = _local_5;
                    this._model.sellTotal = (this._model.sellTotal + 1);
                };
                this._model.addMyAuction(_local_2);
            }
            else
            {
                this._model.removeMyAuction(_local_2);
            };
        }

        public function visibleHelp(_arg_1:AuctionRightView, _arg_2:int):void
        {
            this._rightView = _arg_1;
        }


    }
}//package auctionHouse.controller

