// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionSellView

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import auctionHouse.controller.AuctionHouseController;
    import auctionHouse.model.AuctionHouseModel;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import auctionHouse.AuctionState;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import auctionHouse.event.AuctionHouseEvent;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;

    [Event(name="nextPage", type="auctionHouse.event.AuctionHouseEvent")]
    [Event(name="prePage", type="auctionHouse.event.AuctionHouseEvent")]
    public class AuctionSellView extends Sprite implements Disposeable 
    {

        private var _right:AuctionRightView;
        private var _left:AuctionSellLeftView;
        private var _controller:AuctionHouseController;
        private var _model:AuctionHouseModel;
        private var _cancelBid_btn:BaseButton;
        private var _btClickLock:Boolean;

        public function AuctionSellView(_arg_1:AuctionHouseController, _arg_2:AuctionHouseModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._right = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionRightView");
            this._right.setup(AuctionState.SELL);
            addChild(this._right);
            this._left = ComponentFactory.Instance.creatCustomObject("auctionHouse.view.AuctionSellLeftView");
            addChildAt(this._left, 1);
            this._cancelBid_btn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.CancelBid_btn");
            addChild(this._cancelBid_btn);
        }

        private function addEvent():void
        {
            this._cancelBid_btn.addEventListener(MouseEvent.CLICK, this.__cancel);
            addEventListener(Event.REMOVED_FROM_STAGE, this.__removeStage);
            this._right.prePage_btn.addEventListener(MouseEvent.CLICK, this.__pre);
            this._right.nextPage_btn.addEventListener(MouseEvent.CLICK, this.__next);
            this._right.addEventListener(AuctionHouseEvent.SORT_CHANGE, this.sortChange);
            this._right.addEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectStrip);
            this.addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
        }

        private function removeEvent():void
        {
            this._right.removeEventListener(AuctionHouseEvent.SORT_CHANGE, this.sortChange);
            this._cancelBid_btn.removeEventListener(MouseEvent.CLICK, this.__cancel);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.__removeStage);
            this._right.prePage_btn.removeEventListener(MouseEvent.CLICK, this.__pre);
            this._right.nextPage_btn.removeEventListener(MouseEvent.CLICK, this.__next);
            this._right.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectStrip);
            this.removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
        }

        private function __addToStage(_arg_1:Event):void
        {
            this._cancelBid_btn.enable = false;
            this._left.addStage();
        }

        internal function clearLeft():void
        {
            this._left.clear();
        }

        internal function clearList():void
        {
            this._right.clearList();
        }

        internal function hideReady():void
        {
            this._left.hideReady();
            this._right.hideReady();
        }

        internal function addAuction(_arg_1:AuctionGoodsInfo):void
        {
            this._right.addAuction(_arg_1);
        }

        internal function setPage(_arg_1:int, _arg_2:int):void
        {
            this._right.setPage(_arg_1, _arg_2);
        }

        internal function updateList(_arg_1:AuctionGoodsInfo):void
        {
            this._right.updateAuction(_arg_1);
        }

        private function __cancel(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("043");
            this._btClickLock = true;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._cancelBid_btn.enable = false;
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.cancel"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this._response);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._response);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.__cancelOk();
                    break;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.__cannelNo();
                    break;
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function __cancelOk():void
        {
            if (this._btClickLock)
            {
                this._btClickLock = false;
            }
            else
            {
                return;
            };
            if (this._right.getSelectInfo())
            {
                if (this._right.getSelectInfo().BuyerName != "")
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Price"));
                    return;
                };
                SocketManager.Instance.out.auctionCancelSell(this._right.getSelectInfo().AuctionID);
                this._controller.model.sellTotal = (this._controller.model.sellTotal - 1);
                this._right.clearSelectStrip();
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
            };
            SoundManager.instance.play("008");
            this._cancelBid_btn.enable = false;
        }

        private function __cannelNo():void
        {
            SoundManager.instance.play("008");
            this._cancelBid_btn.enable = true;
        }

        private function __removeStage(_arg_1:Event):void
        {
            this._left.clear();
        }

        private function __next(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            this._cancelBid_btn.enable = false;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
        }

        private function __pre(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("047");
            this._cancelBid_btn.enable = false;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
        }

        private function sortChange(_arg_1:AuctionHouseEvent):void
        {
            this._cancelBid_btn.enable = false;
            this._model.sellCurrent = 1;
            this._controller.searchAuctionList(1, "", -1, -1, PlayerManager.Instance.Self.ID, -1, this._right.sortCondition, this._right.sortBy.toString());
        }

        internal function searchByCurCondition(_arg_1:int, _arg_2:int=-1):void
        {
            this._controller.searchAuctionList(_arg_1, "", -1, -1, _arg_2, -1, this._right.sortCondition, this._right.sortBy.toString());
        }

        private function __selectStrip(_arg_1:AuctionHouseEvent):void
        {
            if (this._right.getSelectInfo())
            {
                if (this._right.getSelectInfo().BuyerName != "")
                {
                    this._cancelBid_btn.enable = false;
                }
                else
                {
                    this._cancelBid_btn.enable = true;
                };
            };
        }

        public function get this_left():AuctionSellLeftView
        {
            return (this._left);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._right)
            {
                ObjectUtils.disposeObject(this._right);
            };
            this._right = null;
            if (this._left)
            {
                ObjectUtils.disposeObject(this._left);
            };
            this._left = null;
            if (this._cancelBid_btn)
            {
                ObjectUtils.disposeObject(this._cancelBid_btn);
            };
            this._cancelBid_btn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

