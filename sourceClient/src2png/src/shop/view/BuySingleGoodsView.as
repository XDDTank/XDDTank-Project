// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.BuySingleGoodsView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.NumberSelecter;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import ddt.utils.PositionUtils;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LeavePageManager;
    import shop.ShopEvent;

    public class BuySingleGoodsView extends Sprite implements Disposeable 
    {

        public static const SHOP_CANNOT_FIND:String = "shopCannotfind";

        private var _frame:Frame;
        private var _shopCartItem:ShopCartItem;
        private var _commodityPricesText1:FilterFrameText;
        private var _commodityPricesText2:FilterFrameText;
        private var _purchaseConfirmationBtn:BaseButton;
        private var _numberSelecter:NumberSelecter;
        private var _goodsID:int;
        private var _isDisCount:Boolean = false;

        public function BuySingleGoodsView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
            this._frame.addToContent(_local_1);
            this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.SingleGoodView.PurchaseBtn");
            this._frame.addToContent(this._purchaseConfirmationBtn);
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("ddtshop.TotalMoneyPanel2");
            PositionUtils.setPos(_local_2, "ddtshop.CheckOutViewBgPos");
            this._frame.addToContent(_local_2);
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
            PositionUtils.setPos(_local_3, "ddtshop.PurchaseAmountTextImgPos");
            this._frame.addToContent(_local_3);
            this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
            this._frame.addToContent(this._numberSelecter);
            this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            this._commodityPricesText1.text = "0";
            PositionUtils.setPos(this._commodityPricesText1, "ddtshop.commodityPricesText1Pos");
            this._frame.addToContent(this._commodityPricesText1);
            this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            this._commodityPricesText2.text = "0";
            PositionUtils.setPos(this._commodityPricesText2, "ddtshop.commodityPricesText2Pos");
            this._frame.addToContent(this._commodityPricesText2);
            addChild(this._frame);
            this.showGuilde();
        }

        public function set isDisCount(_arg_1:Boolean):void
        {
            this._isDisCount = _arg_1;
        }

        public function set goodsID(_arg_1:int):void
        {
            var _local_2:ShopItemInfo;
            if (this._shopCartItem)
            {
                this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__shopCartItemChange);
                this._shopCartItem.dispose();
            };
            this._goodsID = _arg_1;
            _local_2 = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
            if ((!(_local_2)))
            {
                _local_2 = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
            };
            var _local_3:ShopCarItemInfo = new ShopCarItemInfo(_local_2.GoodsID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            this._shopCartItem = new ShopCartItem();
            PositionUtils.setPos(this._shopCartItem, "ddtshop.shopCartItemPos");
            this._shopCartItem.closeBtn.visible = false;
            this._shopCartItem.shopItemInfo = _local_3;
            this._shopCartItem.setColor(_local_3.Color);
            this._frame.addToContent(this._shopCartItem);
            this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__shopCartItemChange);
            this.updateCommodityPrices();
        }

        private function showGuilde():void
        {
            if (((SavePointManager.Instance.isInSavePoint(15)) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                NewHandContainer.Instance.showArrow(ArrowType.SHOP_SINGLE_GOODS, 90, "trainer.shopSingleGoodsArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            };
        }

        private function addEvent():void
        {
            this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._numberSelecter.addEventListener(Event.CHANGE, this.__numberSelecterChange);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS, this.onBuyedGoods);
        }

        private function removeEvent():void
        {
            this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._numberSelecter.removeEventListener(Event.CHANGE, this.__numberSelecterChange);
            if (this._shopCartItem)
            {
                this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__shopCartItemChange);
            };
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS, this.onBuyedGoods);
        }

        private function updateCommodityPrices():void
        {
            var _local_1:int;
            _local_1 = ((this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue) - PlayerManager.Instance.Self.DDTMoney);
            if (_local_1 >= 0)
            {
                this._commodityPricesText1.text = String(_local_1);
                this._commodityPricesText2.text = String(PlayerManager.Instance.Self.DDTMoney);
            }
            else
            {
                this._commodityPricesText1.text = String(0);
                this._commodityPricesText2.text = String((this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue));
            };
        }

        protected function __purchaseConfirmationBtnClick(_arg_1:MouseEvent):void
        {
            var _local_11:ShopCarItemInfo;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((this._shopCartItem.shopItemInfo) && (!(this._shopCartItem.shopItemInfo.isValid))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
                this.dispose();
                return;
            };
            var _local_2:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
            var _local_3:int = (_local_2 - PlayerManager.Instance.Self.DDTMoney);
            if (((PlayerManager.Instance.Self.Money < _local_3) && (!(_local_2 == 0))))
            {
                LeavePageManager.showFillFrame();
                return;
            };
            this._purchaseConfirmationBtn.enable = false;
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Array = new Array();
            var _local_8:Array = new Array();
            var _local_9:Array = [];
            var _local_10:int;
            while (_local_10 < this._numberSelecter.currentValue)
            {
                _local_11 = this._shopCartItem.shopItemInfo;
                _local_4.push(_local_11.GoodsID);
                _local_5.push(_local_11.currentBuyType);
                _local_6.push("");
                _local_7.push("");
                _local_8.push("");
                _local_9.push(_local_11.isDiscount);
                _local_10++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_4, _local_5, _local_6, _local_8, _local_7, null, 0, _local_9);
            this.dispose();
        }

        protected function onBuyedGoods(_arg_1:CrazyTankSocketEvent):void
        {
            this._purchaseConfirmationBtn.enable = true;
            _arg_1.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
            var _local_2:int = _arg_1.pkg.readInt();
        }

        protected function __numberSelecterChange(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.updateCommodityPrices();
        }

        protected function __shopCartItemChange(_arg_1:Event):void
        {
            this.updateCommodityPrices();
        }

        protected function __framePesponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    ShopManager.Instance.dispatchEvent(new ShopEvent(ShopEvent.SHOW_WEAK_GUILDE));
                    this.dispose();
                    return;
            };
        }

        public function dispose():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_SINGLE_GOODS);
            this.removeEvent();
            if (this._frame)
            {
                ObjectUtils.disposeObject(this._frame);
            };
            this._frame = null;
            if (this._shopCartItem)
            {
                ObjectUtils.disposeObject(this._shopCartItem);
            };
            this._shopCartItem = null;
            if (this._commodityPricesText1)
            {
                ObjectUtils.disposeObject(this._commodityPricesText1);
            };
            this._commodityPricesText1 = null;
            if (this._commodityPricesText2)
            {
                ObjectUtils.disposeObject(this._commodityPricesText2);
            };
            this._commodityPricesText2 = null;
            if (this._purchaseConfirmationBtn)
            {
                ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
            };
            this._purchaseConfirmationBtn = null;
            if (this._numberSelecter)
            {
                ObjectUtils.disposeObject(this._numberSelecter);
            };
            this._numberSelecter = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

