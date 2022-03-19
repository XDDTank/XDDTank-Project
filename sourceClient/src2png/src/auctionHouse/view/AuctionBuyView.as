// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionBuyView

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import auctionHouse.event.AuctionHouseEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import ddt.manager.LeavePageManager;
    import im.IMController;
    import ddt.manager.SharedManager;

    public class AuctionBuyView extends Sprite implements Disposeable 
    {

        private var _bidMoney:BidMoneyView;
        private var _right:AuctionBuyRightView;
        private var _bid_btn:BaseButton;
        private var _mouthful_btn:BaseButton;
        private var _bid_btnR:TextButton;
        private var _mouthfulAndbid:Image;
        private var _mouthful_btnR:TextButton;
        private var _btClickLock:Boolean;

        public function AuctionBuyView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionBuyRightView");
            addChild(this._right);
            this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.Bid_btn");
            addChild(this._bid_btn);
            this._mouthful_btn = ComponentFactory.Instance.creat("auctionHouse.Mouthful_btn");
            addChild(this._mouthful_btn);
            this._bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
            this._bidMoney.cannotBid();
            this._bid_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Bid_btnR");
            this._bid_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.bid");
            this._mouthful_btnR = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.Mouthful_btnR");
            this._mouthful_btnR.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
            this.initialiseBtn();
            this._mouthfulAndbid = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.core.commonTipBg");
            this._mouthfulAndbid.addChild(this._bid_btnR);
            this._mouthfulAndbid.addChild(this._mouthful_btnR);
            addChild(this._mouthfulAndbid);
            this._mouthfulAndbid.visible = false;
            this._bid_btnR.enable = (this._bid_btn.enable = false);
        }

        private function addEvent():void
        {
            this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectRightStrip);
            this._bid_btn.addEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btn.addEventListener(MouseEvent.CLICK, this.__mouthFull);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            this._bid_btnR.addEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btnR.addEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._mouthfulAndbid.addEventListener(MouseEvent.ROLL_OUT, this._mouthfulAndbidOver);
        }

        private function __nextPage(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
        }

        private function __prePage(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
        }

        private function removeEvent():void
        {
            this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectRightStrip);
            this._bid_btn.removeEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btn.removeEventListener(MouseEvent.CLICK, this.__mouthFull);
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            this._bid_btnR.removeEventListener(MouseEvent.CLICK, this.__bid);
            this._mouthful_btnR.removeEventListener(MouseEvent.CLICK, this.__mouthFull);
            this._mouthfulAndbid.removeEventListener(MouseEvent.ROLL_OUT, this._mouthfulAndbidOver);
        }

        private function getBidPrice():int
        {
            var _local_2:int;
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1.BuyerName == "")
            {
                _local_2 = _local_1.Price;
            }
            else
            {
                _local_2 = (_local_1.Price + _local_1.Rise);
            };
            return (_local_2);
        }

        internal function hide():void
        {
        }

        private function initialiseBtn():void
        {
            this._mouthful_btn.enable = false;
            this._bid_btn.enable = false;
            this._mouthful_btnR.enable = false;
            this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bid_btnR.enable = false;
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bidMoney.cannotBid();
        }

        internal function addAuction(_arg_1:AuctionGoodsInfo):void
        {
            this._right.addAuction(_arg_1);
        }

        internal function removeAuction():void
        {
            this._bidMoney.cannotBid();
        }

        internal function updateAuction(_arg_1:AuctionGoodsInfo):void
        {
            this._right.updateAuction(_arg_1);
            this.__selectRightStrip(null);
        }

        internal function clearList():void
        {
            this._right.clearList();
        }

        private function _mouthfulAndbidOver(_arg_1:MouseEvent):void
        {
            this._mouthfulAndbid.visible = false;
        }

        private function __selectRightStrip(_arg_1:AuctionHouseEvent):void
        {
            this._mouthfulAndbid.x = (this.globalToLocal(new Point(mouseX, mouseY)).x - 10);
            this._mouthfulAndbid.y = (this.globalToLocal(new Point(mouseX, mouseY)).y - 10);
            if (this._mouthfulAndbid.x > (stage.stageWidth - this._mouthfulAndbid.width))
            {
                this._mouthfulAndbid.x = ((this._mouthfulAndbid.x - this._mouthfulAndbid.width) + 20);
            };
            this.setChildIndex(this._mouthfulAndbid, (this.numChildren - 1));
            if (_arg_1)
            {
                this._mouthfulAndbid.visible = true;
            };
            var _local_2:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_2)
            {
                if (_local_2.AuctioneerID == PlayerManager.Instance.Self.ID)
                {
                    this.initialiseBtn();
                    return;
                };
                this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_2.Mouthful == 0) ? false : true));
                this._mouthful_btnR.filters = ((_local_2.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
                this._bid_btnR.enable = (this._bid_btn.enable = ((_local_2.BuyerID == PlayerManager.Instance.Self.ID) ? false : true));
                this._bid_btnR.filters = ((_local_2.BuyerID == PlayerManager.Instance.Self.ID) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
                if (_local_2.BuyerID != PlayerManager.Instance.Self.ID)
                {
                    this._bidMoney.canMoneyBid((_local_2.Price + _local_2.Rise));
                }
                else
                {
                    this._bidMoney.cannotBid();
                };
            };
        }

        private function __bid(event:MouseEvent):void
        {
            var alert1:AuctionInputFrame;
            var _bidKeyUp:Function;
            var _responseII:Function;
            var alert:BaseAlerFrame;
            _bidKeyUp = function (_arg_1:Event):void
            {
                SoundManager.instance.play("008");
                __bidII();
                alert1.removeEventListener(FrameEvent.RESPONSE, private::_responseII);
                _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP, _bidKeyUp);
                ObjectUtils.disposeObject(alert1);
                _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
            };
            _responseII = function (_arg_1:FrameEvent):void
            {
                SoundManager.instance.play("008");
                _checkResponse(_arg_1.responseCode, __bidII, __cannel);
                var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
                _local_2.removeEventListener(FrameEvent.RESPONSE, internal::_responseII);
                _bidMoney.removeEventListener(_bidMoney.MONEY_KEY_UP, _bidKeyUp);
                ObjectUtils.disposeObject(_arg_1.target);
                _bidMoney = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.BidMoneyView");
            };
            SoundManager.instance.play("047");
            this._btClickLock = true;
            this._mouthfulAndbid.visible = false;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                this.__selectRightStrip(null);
                return;
            };
            if (this._bidMoney.getData() > PlayerManager.Instance.Self.Money)
            {
                alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                alert.addEventListener(FrameEvent.RESPONSE, this._responseI);
                return;
            };
            this._bid_btnR.enable = (this._bid_btn.enable = false);
            alert1 = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.AuctionInputFrame");
            LayerManager.Instance.addToLayer(alert1, 1, alert1.info.frameCenter, LayerManager.BLCAK_BLOCKGOUND);
            alert1.addToContent(this._bidMoney);
            this._bidMoney.money.setFocus();
            alert1.moveEnable = false;
            alert1.addEventListener(FrameEvent.RESPONSE, _responseII);
            this._bidMoney.addEventListener(this._bidMoney.MONEY_KEY_UP, _bidKeyUp);
        }

        private function __bidII():void
        {
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
                MessageTipManager.getInstance().show((((LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.price") + String(this._bidMoney.getData())) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBuyView.less")) + String(this.getBidPrice())));
                return;
            };
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1)
            {
                SocketManager.Instance.out.auctionBid(_local_1.AuctionID, this._bidMoney.getData());
            };
        }

        private function __mouthFull(_arg_1:MouseEvent):void
        {
            var _local_4:BaseAlerFrame;
            SoundManager.instance.play("047");
            this._mouthfulAndbid.visible = false;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._mouthful_btn.enable = (this._mouthful_btnR.enable = false);
            this._bid_btn.enable = (this._bid_btnR.enable = false);
            this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._btClickLock = true;
            var _local_2:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_2.Mouthful > PlayerManager.Instance.Self.Money)
            {
                _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_4.addEventListener(FrameEvent.RESPONSE, this._responseI);
                return;
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.buy"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_3.moveEnable = false;
            _local_3.addEventListener(FrameEvent.RESPONSE, this._responseII);
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._checkResponse(_arg_1.responseCode, LeavePageManager.leaveToFillPath, this._cancelFun);
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._responseI);
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._checkResponse(_arg_1.responseCode, this.__callMouthFull, this.__cannel);
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._responseII);
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function __callMouthFull():void
        {
            var _local_2:int;
            if (this._btClickLock)
            {
                this._btClickLock = false;
            }
            else
            {
                return;
            };
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1)
            {
                SocketManager.Instance.out.auctionBid(_local_1.AuctionID, _local_1.Mouthful);
                IMController.Instance.saveRecentContactsID(_local_1.AuctioneerID);
                if (SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
                {
                    SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
                };
                _local_2 = 0;
                while (_local_2 < SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].length)
                {
                    if (SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID][_local_2] == _local_1.AuctionID)
                    {
                        SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].splice(_local_2, 1);
                    };
                    _local_2++;
                };
                SharedManager.Instance.save();
                this._bidMoney.cannotBid();
                this._right.clearSelectStrip();
            };
        }

        private function __cannel():void
        {
            var _local_1:AuctionGoodsInfo = this._right.getSelectInfo();
            if (_local_1)
            {
                this._mouthful_btnR.enable = (this._mouthful_btn.enable = ((_local_1.Mouthful == 0) ? false : true));
                this._mouthful_btnR.filters = ((_local_1.Mouthful == 0) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
                this._bid_btnR.enable = (this._bid_btn.enable = ((_local_1.BuyerID == PlayerManager.Instance.Self.ID) ? false : true));
                this._bid_btnR.filters = ((_local_1.BuyerID == PlayerManager.Instance.Self.ID) ? ComponentFactory.Instance.creatFilters("grayFilter") : ComponentFactory.Instance.creatFilters("lightFilter"));
            }
            else
            {
                this._mouthful_btnR.enable = (this._mouthful_btn.enable = false);
                this._bid_btnR.enable = (this._bid_btn.enable = false);
                this._mouthful_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this._bid_btnR.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        private function _cancelFun():void
        {
        }

        private function __addToStage(_arg_1:Event):void
        {
            this.initialiseBtn();
            this._bidMoney.cannotBid();
        }

        private function _checkResponse(_arg_1:int, _arg_2:Function=null, _arg_3:Function=null, _arg_4:Function=null):void
        {
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

        public function dispose():void
        {
            this.removeEvent();
            if (this._right)
            {
                ObjectUtils.disposeObject(this._right);
            };
            this._right = null;
            if (this._mouthful_btn)
            {
                ObjectUtils.disposeObject(this._mouthful_btn);
            };
            this._mouthful_btn = null;
            if (this._bid_btn)
            {
                ObjectUtils.disposeObject(this._bid_btn);
            };
            this._bid_btn = null;
            if (this._bidMoney)
            {
                ObjectUtils.disposeObject(this._bidMoney);
            };
            this._bidMoney = null;
            if (parent)
            {
                parent.removeChild(this);
            };
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
        }


    }
}//package auctionHouse.view

