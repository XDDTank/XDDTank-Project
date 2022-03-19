// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.manager.ShopGiftsManager

package shop.manager
{
    import com.pickgliss.ui.controls.Frame;
    import shop.view.ShopCartItem;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.NumberSelecter;
    import shop.view.ShopPresentClearingFrame;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import ddt.utils.PositionUtils;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.LeavePageManager;

    public class ShopGiftsManager 
    {

        private static var _instance:ShopGiftsManager;

        private var _frame:Frame;
        private var _shopCartItem:ShopCartItem;
        private var _titleTxt:FilterFrameText;
        private var _commodityPricesText1:FilterFrameText;
        private var _commodityPricesText2:FilterFrameText;
        private var _giftsBtn:BaseButton;
        private var _numberSelecter:NumberSelecter;
        private var _goodsID:int;
        private var _isDiscountType:Boolean = true;
        private var _shopPresentClearingFrame:ShopPresentClearingFrame;


        public static function get Instance():ShopGiftsManager
        {
            if (_instance == null)
            {
                _instance = new (ShopGiftsManager)();
            };
            return (_instance);
        }


        public function buy(_arg_1:int, _arg_2:Boolean=false):void
        {
            if (this._frame)
            {
                return;
            };
            this._goodsID = _arg_1;
            this._isDiscountType = _arg_2;
            this.initView();
            this.addEvent();
            LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function initView():void
        {
            var _local_4:ShopCarItemInfo;
            this._frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("shop.view.present");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
            this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
            this._frame.addToContent(this._titleTxt);
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CheckOutViewBg");
            this._frame.addToContent(_local_1);
            this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GiftManager.GiftBtn");
            this._frame.addToContent(this._giftsBtn);
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("ddtshop.TotalMoneyPanel2");
            PositionUtils.setPos(_local_2, "ddtshop.CheckOutViewBgPos");
            this._frame.addToContent(_local_2);
            var _local_3:ShopItemInfo;
            _local_3 = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
            _local_4 = new ShopCarItemInfo(_local_3.GoodsID, _local_3.TemplateID);
            ObjectUtils.copyProperties(_local_4, _local_3);
            this._shopCartItem = new ShopCartItem();
            PositionUtils.setPos(this._shopCartItem, "ddtshop.shopCartItemPos");
            this._shopCartItem.closeBtn.visible = false;
            this._shopCartItem.shopItemInfo = _local_4;
            this._shopCartItem.setColor(_local_4.Color);
            this._frame.addToContent(this._shopCartItem);
            var _local_5:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PurchaseAmount");
            PositionUtils.setPos(_local_5, "ddtshop.PurchaseAmountTextImgPos");
            this._frame.addToContent(_local_5);
            this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
            this._frame.addToContent(this._numberSelecter);
            this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            PositionUtils.setPos(this._commodityPricesText1, "ddtshop.commodityPricesText1Pos");
            this._commodityPricesText1.text = "0";
            this._frame.addToContent(this._commodityPricesText1);
            this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.CommodityPricesText");
            PositionUtils.setPos(this._commodityPricesText2, "ddtshop.commodityPricesText2Pos");
            this._commodityPricesText2.text = "0";
            this._frame.addToContent(this._commodityPricesText2);
            this.updateCommodityPrices();
        }

        private function addEvent():void
        {
            this._giftsBtn.addEventListener(MouseEvent.CLICK, this.__giftsBtnClick);
            this._numberSelecter.addEventListener(Event.CHANGE, this.__numberSelecterChange);
            this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__shopCartItemChange);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT, this.onPresent);
        }

        private function removeEvent():void
        {
            this._giftsBtn.removeEventListener(MouseEvent.CLICK, this.__giftsBtnClick);
            this._numberSelecter.removeEventListener(Event.CHANGE, this.__numberSelecterChange);
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__shopCartItemChange);
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT, this.onPresent);
        }

        private function updateCommodityPrices():void
        {
            this._commodityPricesText1.text = String((this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue));
            this._commodityPricesText2.text = String(0);
        }

        protected function __giftsBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
            this._shopPresentClearingFrame.show();
            this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK, this.__presentBtnClick);
            this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                StageReferance.stage.focus = this._frame;
            };
        }

        protected function __presentBtnClick(_arg_1:MouseEvent):void
        {
            var _local_11:ShopCarItemInfo;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._shopPresentClearingFrame.nameInput.text == "")
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
                return;
            };
            if (FilterWordManager.IsNullorEmpty(this._shopPresentClearingFrame.nameInput.text))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
                return;
            };
            var _local_2:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
            if (((this._shopCartItem.shopItemInfo) && (!(this._shopCartItem.shopItemInfo.isValid))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.timeOver"));
                this.dispose();
                return;
            };
            if (PlayerManager.Instance.Self.Money < _local_2)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            this._shopPresentClearingFrame.presentBtn.enable = false;
            var _local_3:Array = new Array();
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Array = new Array();
            var _local_8:Array = new Array();
            var _local_9:int;
            while (_local_9 < this._numberSelecter.currentValue)
            {
                _local_11 = this._shopCartItem.shopItemInfo;
                _local_3.push(_local_11.GoodsID);
                _local_4.push(_local_11.currentBuyType);
                _local_5.push(_local_11.Color);
                _local_6.push("");
                _local_7.push("");
                _local_8.push(_local_11.isDiscount);
                _local_9++;
            };
            var _local_10:String = FilterWordManager.filterWrod(this._shopPresentClearingFrame.textArea.text);
            SocketManager.Instance.out.sendPresentGoods(_local_3, _local_4, _local_5, _local_8, _local_10, this._shopPresentClearingFrame.nameInput.text);
        }

        protected function onPresent(_arg_1:CrazyTankSocketEvent):void
        {
            this._shopPresentClearingFrame.presentBtn.enable = true;
            this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK, this.__presentBtnClick);
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            this.dispose();
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
                    this.dispose();
                    return;
            };
        }

        private function dispose():void
        {
            this.removeEvent();
            if (this._shopPresentClearingFrame)
            {
                ObjectUtils.disposeObject(this._shopPresentClearingFrame);
            };
            this._shopPresentClearingFrame = null;
            if (this._titleTxt)
            {
                ObjectUtils.disposeObject(this._titleTxt);
            };
            this._titleTxt = null;
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
            if (this._giftsBtn)
            {
                ObjectUtils.disposeObject(this._giftsBtn);
            };
            this._giftsBtn = null;
            if (this._numberSelecter)
            {
                ObjectUtils.disposeObject(this._numberSelecter);
            };
            this._numberSelecter = null;
            if (this._frame)
            {
                ObjectUtils.disposeObject(this._frame);
            };
            this._frame = null;
        }


    }
}//package shop.manager

