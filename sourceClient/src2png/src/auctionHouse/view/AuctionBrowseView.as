// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionBrowseView

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import auctionHouse.controller.AuctionHouseController;
    import auctionHouse.model.AuctionHouseModel;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.ComponentFactory;
    import auctionHouse.AuctionState;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import auctionHouse.event.AuctionHouseEvent;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import __AS3__.vec.Vector;
    import ddt.data.goods.CateCoryInfo;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.MessageTipManager;
    import im.IMController;
    import ddt.manager.SharedManager;

    public class AuctionBrowseView extends Sprite implements Disposeable 
    {

        private var _controller:AuctionHouseController;
        private var _model:AuctionHouseModel;
        private var _list:BrowseLeftMenuView;
        private var _bidMoney:BidMoneyView;
        private var _bid_btn:BaseButton;
        private var _mouthful_btn:BaseButton;
        private var _bid_btnR:TextButton;
        private var _mouthfulAndbid:Image;
        private var _mouthful_btnR:TextButton;
        private var _btClickLock:Boolean;
        private var _isSearch:Boolean;
        private var _right:AuctionRightView;
        private var _isUpdating:Boolean;

        public function AuctionBrowseView(_arg_1:AuctionHouseController, _arg_2:AuctionHouseModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
            this._right.setup(AuctionState.BROWSE);
            addChild(this._right);
            this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
            addChild(this._bid_btn);
            this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
            addChild(this._mouthful_btn);
            this._bid_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Bid_btnR");
            this._bid_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.bid");
            this._mouthful_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Mouthful_btnR");
            this._mouthful_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
            this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
            this._list = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BrowseLeftMenuView");
            addChild(this._list);
            this.initialiseBtn();
            this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
            this._mouthfulAndbid.addChild(this._bid_btnR);
            this._mouthfulAndbid.addChild(this._mouthful_btnR);
            addChild(this._mouthfulAndbid);
            this._bid_btnR.enable = false;
            this._mouthful_btnR.enable = false;
            this._mouthfulAndbid.visible = false;
        }

        private function initialiseBtn():void
        {
            this._mouthful_btn.enable = false;
            this._bid_btn.enable = false;
            this._bidMoney.cannotBid();
        }

        private function addEvent():void
        {
            this._right.prePage_btn.addEventListener(MouseEvent.CLICK, this.__pre);
            this._right.nextPage_btn.addEventListener(MouseEvent.CLICK, this.__next);
            this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectRightStrip);
            this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE, this.sortChange);
            this._list.addEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectLeftStrip);
            this._bid_btn.addEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btn.addEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._bid_btnR.addEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btnR.addEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT, this._mouthfulAndbidOver);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_UPDATE, this.__updateAuction);
        }

        private function removeEvent():void
        {
            this._right.prePage_btn.removeEventListener(MouseEvent.CLICK, this.__pre);
            this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK, this.__next);
            this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE, this.sortChange);
            this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectRightStrip);
            this._list.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectLeftStrip);
            this._bid_btn.removeEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btn.removeEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._bid_btnR.removeEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btnR.removeEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT, this._mouthfulAndbidOver);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_UPDATE, this.__updateAuction);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._response);
            ObjectUtils.disposeObject(_arg_1.target);
        }

        internal function addAuction(_arg_1:AuctionGoodsInfo):void
        {
            if (AuctionHouseModel._dimBooble != true)
            {
                this._right.addAuction(_arg_1);
            };
        }

        internal function updateAuction(_arg_1:AuctionGoodsInfo):void
        {
            this._right.updateAuction(_arg_1);
            this.__selectRightStrip(null);
        }

        internal function removeAuction():void
        {
            this.__searchCondition(null);
        }

        internal function hideReady():void
        {
            this._right.hideReady();
        }

        internal function clearList():void
        {
            if (AuctionHouseModel._dimBooble == true)
            {
                this._list.setFocusName();
                return;
            };
            this._right.clearList();
            this.__selectRightStrip(null);
        }

        internal function setCategory(_arg_1:Vector.<CateCoryInfo>):void
        {
            this._list.setCategory(_arg_1);
        }

        internal function setPage(_arg_1:int, _arg_2:int):void
        {
            this._right.setPage(_arg_1, _arg_2);
        }

        internal function setSelectType(_arg_1:CateCoryInfo):void
        {
            this.initialiseBtn();
            this._list.setSelectType(_arg_1);
        }

        internal function getLeftInfo():CateCoryInfo
        {
            return (this._list.getInfo());
        }

        internal function setTextEmpty():void
        {
            this._list.searchText = "";
        }

        internal function getPayType():int
        {
            return (-1);
        }

        internal function searchByCurCondition(_arg_1:int, _arg_2:int=-1):void
        {
            if (_arg_2 != -1)
            {
                this._controller.searchAuctionList(_arg_1, "", this._list.getType(), -1, _arg_2, -1, this._right.sortCondition, this._right.sortBy.toString());
                return;
            };
            if (this._isSearch)
            {
                this._controller.searchAuctionList(_arg_1, this._list.searchText, this._list.getType(), this.getPayType(), _arg_2, -1, this._right.sortCondition, this._right.sortBy.toString());
            }
            else
            {
                this._controller.searchAuctionList(_arg_1, this._list.searchText, this._list.getType(), -1, _arg_2, -1, this._right.sortCondition, this._right.sortBy.toString());
            };
            this._bidMoney.cannotBid();
        }

        private function getBidPrice():int
        {
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1)
            {
                return ((_local_1.BuyerName == "") ? _local_1.Price : (_local_1.Price + _local_1.Rise));
            };
            return (0);
        }

        private function getPrice():int
        {
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            return ((_local_1) ? _local_1.Price : 0);
        }

        private function getMouthful():int
        {
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            return ((_local_1) ? _local_1.Mouthful : 0);
        }

        private function __searchCondition(_arg_1:MouseEvent):void
        {
            this._isSearch = true;
            if ((this._list.getInfo() == null))
            {
                this._controller.browseTypeChangeNull();
            }
            else
            {
                this._controller.browseTypeChange(this._list.getInfo());
            };
        }

        private function keyEnterHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.__searchCondition(null);
            };
        }

        private function __next(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
            this._bid_btn.enable = false;
            this._mouthful_btn.enable = false;
        }

        private function __pre(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
            this._bid_btn.enable = false;
            this._mouthful_btn.enable = false;
        }

        private function __selectLeftStrip(_arg_1:AuctionHouseEvent):void
        {
            this._isSearch = false;
            this._controller.browseTypeChange(this._list.getInfo());
        }

        private function __selectRightStrip(_arg_1:AuctionHouseEvent):void
        {
            this._mouthfulAndbid.x = (this.globalToLocal(new Point(mouseX, mouseY)).x - 10);
            this._mouthfulAndbid.y = (this.globalToLocal(new Point(mouseX, mouseY)).y - 10);
            if (this._mouthfulAndbid.x > (stage.stageWidth - this._mouthfulAndbid.width))
            {
                this._mouthfulAndbid.x = ((this._mouthfulAndbid.x - this._mouthfulAndbid.width) + 20);
            };
            this._bid_btnR.enable = false;
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._mouthful_btnR.enable = false;
            this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this.setChildIndex(this._mouthfulAndbid, (this.numChildren - 1));
            if (this._isUpdating)
            {
                return;
            };
            var _local_2:AuctionGoodsInfo = this._right.getSelectInfo();
            if (((_local_2 == null) || (_local_2.AuctioneerID == PlayerManager.Instance.Self.ID)))
            {
                this.initialiseBtn();
                return;
            };
            if (_local_2.BuyerID == PlayerManager.Instance.Self.ID)
            {
                this.initialiseBtn();
                this._mouthfulAndbid.visible = true;
                this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_2.Mouthful == 0) ? false : true));
                this._mouthful_btnR.filters = ((_local_2.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
                return;
            };
            if (((_arg_1) && (_arg_1.currentTarget == this._right)))
            {
                this._mouthfulAndbid.visible = true;
            };
            this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_2.Mouthful == 0) ? false : true));
            this._mouthful_btnR.filters = ((_local_2.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
            if ((_local_2.PayType == 0))
            {
                this._bidMoney.canGoldBid(this.getBidPrice());
            }
            else
            {
                this._bidMoney.canMoneyBid(this.getBidPrice());
            };
            if (_arg_1)
            {
                this._bid_btnR.enable = (this._bid_btn.enable = true);
                this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
        }

        private function init_FUL_BID_btnStatue():void
        {
            this._bid_btnR.enable = false;
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._mouthful_btnR.enable = false;
            this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (this._isUpdating)
            {
                return;
            };
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (((_local_1 == null) || (_local_1.AuctioneerID == PlayerManager.Instance.Self.ID)))
            {
                this.initialiseBtn();
                return;
            };
            if (_local_1.BuyerID == PlayerManager.Instance.Self.ID)
            {
                this.initialiseBtn();
                this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_1.Mouthful == 0) ? false : true));
                this._mouthful_btnR.filters = ((_local_1.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
                return;
            };
            this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_1.Mouthful == 0) ? false : true));
            this._mouthful_btnR.filters = ((_local_1.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
            this._bid_btn.enable = true;
            if ((_local_1.PayType == 0))
            {
                this._bidMoney.canGoldBid(this.getBidPrice());
            }
            else
            {
                this._bidMoney.canMoneyBid(this.getBidPrice());
            };
        }

        private function __bid(event:MouseEvent):void
        {
            var alert1:AuctionInputFrame;
            var _bidKeyUp:Function;
            var _responseII:Function;
            SoundManager.instance.play("047");
            this._btClickLock = true;
            if ((this._right.getSelectInfo().PayType == 0))
            {
                this._bidMoney.canGoldBid(this.getBidPrice());
            }
            else
            {
                this._bidMoney.canMoneyBid(this.getBidPrice());
            };
            if (this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
                LeavePageManager.showFillFrame();
            }
            else
            {
                _bidKeyUp = function (_arg_1:Event):void
                {
                    SoundManager.instance.play("008");
                    __bidOk();
                    alert1.removeEventListener(FrameEvent.RESPONSE, _responseII);
                    _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP, _bidKeyUp);
                    ObjectUtils.disposeObject(alert1);
                    _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
                    _isUpdating = false;
                };
                _responseII = function (_arg_1:FrameEvent):void
                {
                    SoundManager.instance.play("008");
                    _checkResponse(_arg_1.responseCode, __bidOk, __cancel);
                    var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
                    _local_2.removeEventListener(FrameEvent.RESPONSE, _responseII);
                    _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP, _bidKeyUp);
                    ObjectUtils.disposeObject(_arg_1.target);
                    _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
                    _isUpdating = false;
                };
                this.checkPlayerMoney();
                this._bid_btn.enable = false;
                this._mouthfulAndbid.visible = false;
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    this._mouthful_btnR.enable = false;
                    this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    this._bid_btn.enable = true;
                    BaglockedManager.Instance.show();
                    return;
                };
                alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
                LayerManager.Instance.addToLayer(alert1, 1, alert1.info.frameCenter, LayerManager.BLCAK_BLOCKGOUND);
                alert1.addToContent(this._bidMoney);
                this._bidMoney.money.setFocus();
                alert1.moveEnable = false;
                alert1.addEventListener(FrameEvent.RESPONSE, _responseII);
                this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP, _bidKeyUp);
            };
        }

        private function _checkResponse(_arg_1:int, _arg_2:Function=null, _arg_3:Function=null, _arg_4:Function=null):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    (_arg_2());
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    (_arg_3());
                    return;
            };
        }

        private function _cancelFun():void
        {
        }

        private function __mouthFull(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            SoundManager.instance.play("047");
            this._btClickLock = true;
            this._mouthfulAndbid.visible = false;
            if (this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
                LeavePageManager.showFillFrame();
            }
            else
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    this._mouthful_btnR.enable = false;
                    this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    BaglockedManager.Instance.show();
                    return;
                };
                this._mouthful_btn.enable = false;
                this._bid_btn.enable = false;
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.moveEnable = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this._responseIV);
            };
        }

        private function _mouthfulAndbidOver(_arg_1:MouseEvent):void
        {
            this._mouthfulAndbid.visible = false;
            this._bid_btnR.enable = false;
            this._mouthful_btnR.enable = false;
        }

        private function _responseIV(_arg_1:FrameEvent):void
        {
            this._checkResponse(_arg_1.responseCode, this.__mouthFullOk, this.__cancel);
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._responseIV);
            ObjectUtils.disposeObject(_arg_1.target);
            this._isUpdating = false;
        }

        private function __bidOk():void
        {
            this._isUpdating = true;
            if (this._btClickLock)
            {
                this._btClickLock = false;
            }
            else
            {
                return;
            };
            if (this.getBidPrice() > this._bidMoney.getData())
            {
                MessageTipManager.getInstance().show(((LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.Auction2") + String(this.getBidPrice())) + LanguageMgr.GetTranslation("shop.RechargeView.TicketText")));
                this._bid_btn.enable = true;
                return;
            };
            if (this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
                this._bid_btn.enable = true;
                LeavePageManager.showFillFrame();
                return;
            };
            if (((!(this.getMouthful() == 0)) && (this._bidMoney.getData() >= this.getMouthful())))
            {
                this._btClickLock = true;
                this._mouthful_btn.enable = false;
                this._bid_btn.enable = false;
                this.__mouthFullOk();
                return;
            };
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1)
            {
                SocketManager.Instance.out.auctionBid(_local_1.AuctionID, this._bidMoney.getData());
                IMController.Instance.saveRecentContactsID(_local_1.AuctioneerID);
                _local_1 = null;
            };
        }

        private function __cancel():void
        {
            this.init_FUL_BID_btnStatue();
        }

        private function checkPlayerMoney():void
        {
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            this._bid_btn.enable = false;
            this._mouthful_btn.enable = false;
            if (_local_1 == null)
            {
                return;
            };
            if (((!(_local_1.Mouthful == 0)) && (this.getMouthful() <= PlayerManager.Instance.Self.Money)))
            {
                this._mouthful_btn.enable = true;
            };
        }

        private function __mouthFullOk():void
        {
            if (this._btClickLock)
            {
                this._btClickLock = false;
            }
            else
            {
                return;
            };
            if (this.getMouthful() > PlayerManager.Instance.Self.Money)
            {
                this._bid_btn.enable = true;
                MessageTipManager.getInstance().show(((LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.Your") + String(this.getMouthful())) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple")));
                return;
            };
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if ((((_local_1) && (_local_1.AuctionID)) && (_local_1.Mouthful)))
            {
                SocketManager.Instance.out.auctionBid(_local_1.AuctionID, _local_1.Mouthful);
                IMController.Instance.saveRecentContactsID(_local_1.AuctioneerID);
                this._right.clearSelectStrip();
                this._right.setSelectEmpty();
                this._bidMoney.cannotBid();
                this.searchByCurCondition(this._model.browseCurrent);
            };
        }

        private function __updateAuction(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                _local_3 = _arg_1.pkg.readInt();
                if (SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
                {
                    SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
                };
                SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].push(_local_3);
                SharedManager.Instance.save();
            };
            this._isUpdating = false;
        }

        private function __addToStage(_arg_1:Event):void
        {
            this.initialiseBtn();
            this._bidMoney.cannotBid();
            this._right.addStageInit();
        }

        private function sortChange(_arg_1:AuctionHouseEvent):void
        {
            this.__searchCondition(null);
        }

        public function get Right():AuctionRightView
        {
            return (this._right);
        }

        public function dispose():void
        {
            this.removeEvent();
            this._controller = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            if (this._bidMoney)
            {
                ObjectUtils.disposeObject(this._bidMoney);
            };
            this._bidMoney = null;
            if (this._bid_btn)
            {
                ObjectUtils.disposeObject(this._bid_btn);
            };
            this._bid_btn = null;
            if (this._mouthful_btn)
            {
                ObjectUtils.disposeObject(this._mouthful_btn);
            };
            this._mouthful_btn = null;
            if (this._bid_btnR)
            {
                ObjectUtils.disposeObject(this._bid_btnR);
            };
            this._bid_btnR = null;
            if (this._mouthful_btnR)
            {
                ObjectUtils.disposeObject(this._mouthful_btnR);
            };
            this._mouthful_btnR = null;
            if (this._mouthfulAndbid)
            {
                ObjectUtils.disposeObject(this._mouthfulAndbid);
            };
            this._mouthfulAndbid = null;
            if (this._right)
            {
                ObjectUtils.disposeObject(this._right);
            };
            this._right = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

