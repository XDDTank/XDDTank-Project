// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.BuyMultiGoodsView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import shop.manager.ShopBuyManager;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.ShopManager;
    import ddt.manager.LeavePageManager;
    import ddt.data.EquipType;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class BuyMultiGoodsView extends Sprite implements Disposeable 
    {

        private var _bg:Image;
        private var _commodityNumberTip:FilterFrameText;
        private var _commodityNumberText:FilterFrameText;
        private var _commodityPricesText1:FilterFrameText;
        private var _commodityPricesText2:FilterFrameText;
        private var _purchaseConfirmationBtn:BaseButton;
        private var _buyArray:Vector.<ShopCarItemInfo>;
        private var _cartList:VBox;
        private var _cartScroll:ScrollPanel;
        private var _frame:Frame;
        private var _innerBg1:Bitmap;
        private var _innerBg:Bitmap;
        private var _extraTextButton:BaseButton;
        public var dressing:Boolean = false;

        public function BuyMultiGoodsView()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
            addChild(this._frame);
            this._cartList = new VBox();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewBg");
            this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
            this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemList");
            this._extraTextButton = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
            this._cartScroll.setView(this._cartList);
            this._cartScroll.vScrollProxy = ScrollPanel.ON;
            this._cartList.spacing = 5;
            this._cartList.strictSize = 80;
            this._cartList.isReverAdd = true;
            this._frame.addToContent(this._bg);
            this._innerBg1 = ComponentFactory.Instance.creatBitmap("ddtshop.RechargeView.NeedToPayPanelBg");
            this._innerBg1.y = 400;
            this._frame.addToContent(this._innerBg1);
            this._commodityNumberTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberTipText");
            this._commodityNumberTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityNumberTip");
            this._frame.addToContent(this._commodityNumberTip);
            this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberText");
            this._frame.addToContent(this._commodityNumberText);
            this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1");
            this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2");
            this._commodityPricesText1.y = (this._commodityPricesText2.y = 436);
            this._frame.addToContent(this._commodityPricesText1);
            this._frame.addToContent(this._commodityPricesText2);
            this._frame.addToContent(this._cartScroll);
            this._frame.addToContent(this._purchaseConfirmationBtn);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND, true);
        }

        protected function updateTxt():void
        {
            var _local_2:int;
            var _local_1:Array = ShopBuyManager.calcPrices(this._buyArray);
            this._commodityNumberText.text = String(this._buyArray.length);
            _local_2 = (_local_1[ShopCheckOutView.MONEY] - PlayerManager.Instance.Self.DDTMoney);
            if (_local_2 >= 0)
            {
                this._commodityPricesText1.text = String(_local_2);
                this._commodityPricesText2.text = String(PlayerManager.Instance.Self.DDTMoney);
            }
            else
            {
                this._commodityPricesText1.text = String(0);
                this._commodityPricesText2.text = String(_local_1[ShopCheckOutView.MONEY]);
            };
        }

        private function initEvents():void
        {
            this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK, this.__buyAvatar);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function removeEvents():void
        {
            this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK, this.__buyAvatar);
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.playButtonSound();
                    this.dispose();
            };
        }

        private function __buyAvatar(_arg_1:MouseEvent):void
        {
            var _local_3:ShopCarItemInfo;
            var _local_4:Array;
            var _local_14:ShopCartItem;
            var _local_15:ShopCarItemInfo;
            var _local_16:ShopCarItemInfo;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:Array = [];
            for each (_local_3 in this._buyArray)
            {
                _local_2.push(_local_3);
            };
            _local_4 = ShopManager.Instance.buyIt(_local_2);
            if (_local_4.length == 0)
            {
                for each (_local_15 in this._buyArray)
                {
                    if (((_local_15.getCurrentPrice().moneyValue > 0) && (PlayerManager.Instance.Self.totalMoney < _local_15.getCurrentPrice().moneyValue)))
                    {
                        LeavePageManager.showFillFrame();
                        return;
                    };
                };
            }
            else
            {
                if (_local_4.length < this._buyArray.length)
                {
                };
            };
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Array = new Array();
            var _local_8:Array = new Array();
            var _local_9:Array = new Array();
            var _local_10:Array = [];
            var _local_11:int;
            while (_local_11 < _local_4.length)
            {
                _local_16 = _local_4[_local_11];
                _local_5.push(_local_16.GoodsID);
                _local_6.push(_local_16.currentBuyType);
                _local_7.push(_local_16.Color);
                _local_9.push(_local_16.place);
                if (_local_16.CategoryID == EquipType.FACE)
                {
                    _local_10.push(_local_16.skin);
                }
                else
                {
                    _local_10.push("");
                };
                _local_8.push(this.dressing);
                _local_11++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_5, _local_6, _local_7, _local_9, _local_8, _local_10);
            var _local_12:Array = [];
            var _local_13:int = (this._cartList.numChildren - 1);
            while (_local_13 >= 0)
            {
                _local_12.push(this._cartList.getChildAt(_local_13));
                _local_13--;
            };
            for each (_local_14 in _local_12)
            {
                if (_local_4.indexOf(_local_14.shopItemInfo) > -1)
                {
                    _local_14.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                    _local_14.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
                    this._cartList.removeChild(_local_14);
                    this._buyArray.splice(this._buyArray.indexOf(_local_14.shopItemInfo), 1);
                    _local_14.dispose();
                };
            };
            if (this._cartList.numChildren == 0)
            {
                this.dispose();
            }
            else
            {
                this.updateTxt();
            };
        }

        public function setGoods(_arg_1:Vector.<ShopCarItemInfo>):void
        {
            var _local_2:ShopCarItemInfo;
            var _local_3:ShopCartItem;
            var _local_4:ShopCartItem;
            while (this._cartList.numChildren > 0)
            {
                _local_3 = (this._cartList.getChildAt((this._cartList.numChildren - 1)) as ShopCartItem);
                _local_3.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                _local_3.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
                this._cartList.removeChild(_local_3);
                _local_3.dispose();
            };
            this._buyArray = _arg_1;
            for each (_local_2 in this._buyArray)
            {
                _local_4 = new ShopCartItem();
                _local_4.shopItemInfo = _local_2;
                _local_4.setColor(_local_2.Color);
                this._cartList.addChild(_local_4);
                _local_4.addEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                _local_4.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
            };
            this._cartScroll.invalidateViewport();
            this.updateTxt();
        }

        private function __conditionChange(_arg_1:Event):void
        {
            this.updateTxt();
        }

        private function __deleteItem(_arg_1:Event):void
        {
            var _local_2:ShopCartItem = (_arg_1.currentTarget as ShopCartItem);
            var _local_3:ShopCarItemInfo = _local_2.shopItemInfo;
            _local_2.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
            _local_2.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
            this._cartList.removeChild(_local_2);
            var _local_4:int = this._buyArray.indexOf(_local_3);
            this._buyArray.splice(_local_4, 1);
            this.updateTxt();
            this._cartScroll.invalidateViewport();
            if (this._buyArray.length < 1)
            {
                this.dispose();
            };
        }

        public function dispose():void
        {
            var _local_1:ShopCartItem;
            this.removeEvents();
            while (this._cartList.numChildren > 0)
            {
                _local_1 = (this._cartList.getChildAt((this._cartList.numChildren - 1)) as ShopCartItem);
                _local_1.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                _local_1.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
                this._cartList.removeChild(_local_1);
                _local_1.dispose();
            };
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._commodityNumberTip);
            this._commodityNumberTip = null;
            ObjectUtils.disposeObject(this._commodityNumberText);
            this._commodityNumberText = null;
            ObjectUtils.disposeObject(this._commodityPricesText1);
            this._commodityPricesText1 = null;
            ObjectUtils.disposeObject(this._commodityPricesText2);
            this._commodityPricesText2 = null;
            ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
            this._purchaseConfirmationBtn = null;
            this._buyArray = null;
            ObjectUtils.disposeObject(this._cartList);
            this._cartList = null;
            ObjectUtils.disposeObject(this._cartScroll);
            this._cartScroll = null;
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
            ObjectUtils.disposeObject(this._bg);
            this._innerBg1 = null;
            ObjectUtils.disposeObject(this._innerBg1);
            this._innerBg = null;
            ObjectUtils.disposeObject(this._extraTextButton);
            this._extraTextButton = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

