// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopCheckOutView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import shop.ShopController;
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import shop.ShopModel;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.MessageTipManager;
    import ddt.data.goods.ShopCarItemInfo;
    import flash.events.Event;
    import ddt.manager.ShopManager;
    import shop.ShopEvent;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopCheckOutView extends Sprite implements Disposeable 
    {

        public static const COUNT:uint = 3;
        public static const DDT_MONEY:uint = 1;
        public static const LACK:uint = 1;
        public static const MEDAL:uint = 2;
        public static const MONEY:uint = 0;
        public static const PLAYER:uint = 0;
        public static const PRESENT:int = 2;
        public static const PURCHASE:int = 1;
        public static const SAVE:int = 3;

        protected var _commodityNumberText:FilterFrameText;
        protected var _commodityNumberTip:FilterFrameText;
        protected var _commodityPricesText1:FilterFrameText;
        protected var _commodityPricesText2:FilterFrameText;
        private var _commodityPricesText1Bg:Scale9CornerImage;
        private var _commodityPricesText2Bg:Scale9CornerImage;
        private var _commodityPricesText3Bg:Scale9CornerImage;
        protected var _purchaseConfirmationBtn:BaseButton;
        protected var _giftsBtn:BaseButton;
        protected var _saveImageBtn:BaseButton;
        private var _buyArray:Array = new Array();
        protected var _cartList:VBox;
        private var _cartScroll:ScrollPanel;
        private var _controller:ShopController;
        protected var _frame:Frame;
        private var _giveArray:Array = new Array();
        protected var _innerBg1:Bitmap;
        private var _innerBg:Image;
        private var _model:ShopModel;
        private var _tempList:Array;
        private var _type:int;
        private var _isDisposed:Boolean;
        protected var _list:Array;
        private var theDifferenceOfmoneyValuAndDDTMoney:int;
        private var _shopPresentClearingFrame:ShopPresentClearingFrame;


        protected function drawFrame():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
            addChild(this._frame);
        }

        protected function drawItemCountField():void
        {
            this._innerBg1 = ComponentFactory.Instance.creatBitmap("ddtshop.TotalMoneyPanel2");
            PositionUtils.setPos(this._innerBg1, "ddtshop.shopCheckOutViewInnerBg.pos");
            this._frame.addToContent(this._innerBg1);
            this._commodityNumberTip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberTipText");
            this._commodityNumberTip.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityNumberTip");
            this._frame.addToContent(this._commodityNumberTip);
            this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityNumberText");
            this._frame.addToContent(this._commodityNumberText);
            this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText1");
            this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2");
            this._frame.addToContent(this._commodityPricesText1);
            this._frame.addToContent(this._commodityPricesText2);
        }

        protected function drawPayListField():void
        {
            this._innerBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewBg");
            this._frame.addToContent(this._innerBg);
        }

        protected function init():void
        {
            this._cartList = new VBox();
            this.drawFrame();
            this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PurchaseBtn");
            this._purchaseConfirmationBtn.visible = false;
            PositionUtils.setPos(this._purchaseConfirmationBtn, "ddtshop.shopCheckOutViewPurchBtnPos");
            this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GiftsBtn");
            this._giftsBtn.visible = false;
            this._saveImageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SaveImageBtn");
            this._saveImageBtn.visible = false;
            this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CheckOutViewItemList");
            this._cartScroll.setView(this._cartList);
            this._cartScroll.vScrollProxy = ScrollPanel.ON;
            this._cartList.spacing = 5;
            this._cartList.strictSize = 80;
            this._cartList.isReverAdd = true;
            this.drawItemCountField();
            this.drawPayListField();
            this._frame.addToContent(this._cartScroll);
            this._frame.addToContent(this._purchaseConfirmationBtn);
            this._frame.addToContent(this._giftsBtn);
            this._frame.addToContent(this._saveImageBtn);
            this.setList(this._tempList);
            this.updateTxt();
            if (this._type == SAVE)
            {
                this._saveImageBtn.visible = true;
            }
            else
            {
                if (this._type == PURCHASE)
                {
                    this._purchaseConfirmationBtn.visible = true;
                }
                else
                {
                    if (this._type == PRESENT)
                    {
                        this._giftsBtn.visible = true;
                    };
                };
            };
            if (((SavePointManager.Instance.isInSavePoint(15)) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                NewHandContainer.Instance.showArrow(ArrowType.SHOP_CHECK_OUT, 0, "trainer.buyCheckoutArrowPos", "", "", this);
            };
        }

        protected function initEvent():void
        {
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS, this.onBuyedGoods);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT, this.onPresent);
            this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._saveImageBtn.addEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._giftsBtn.addEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
        }

        protected function __purchaseConfirmationBtnClick(_arg_1:MouseEvent=null):void
        {
            SoundManager.instance.play("008");
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_CHECK_OUT);
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._type == SAVE)
            {
                if (((this._model.canBuyLeastOneGood(this._model.currentTempList)) || (PlayerManager.Instance.Self.Money >= this.theDifferenceOfmoneyValuAndDDTMoney)))
                {
                    this.saveFigureCheckOut();
                    this._model.clearCurrentTempList(((this._model.fittingSex) ? 1 : 2));
                }
                else
                {
                    if (this._model.currentTempList.some(this.isMoneyGoods))
                    {
                        LeavePageManager.showFillFrame();
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
                    };
                };
            }
            else
            {
                if (this._type == PURCHASE)
                {
                    if (((this._model.canBuyLeastOneGood(this._model.allItems)) || (PlayerManager.Instance.Self.totalMoney >= (this.theDifferenceOfmoneyValuAndDDTMoney + PlayerManager.Instance.Self.DDTMoney))))
                    {
                        this.shopCarCheckOut();
                    }
                    else
                    {
                        if (this._model.allItems.some(this.isMoneyGoods))
                        {
                            LeavePageManager.showFillFrame();
                        }
                        else
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
                        };
                    };
                    return;
                };
                if (this._type == PRESENT)
                {
                    this.presentCheckOut();
                };
            };
        }

        protected function addItemEvent(_arg_1:ShopCartItem):void
        {
            _arg_1.addEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
            _arg_1.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
        }

        protected function removeItemEvent(_arg_1:ShopCartItem):void
        {
            _arg_1.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
            _arg_1.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
        }

        public function setList(_arg_1:Array):void
        {
            var _local_2:ShopCarItemInfo;
            var _local_3:ShopCartItem;
            var _local_4:ShopCartItem;
            while (this._cartList.numChildren > 0)
            {
                _local_3 = (this._cartList.getChildAt((this._cartList.numChildren - 1)) as ShopCartItem);
                this.removeItemEvent(_local_3);
                this._cartList.removeChild(_local_3);
                _local_3.dispose();
                _local_3 = null;
            };
            this._list = _arg_1;
            for each (_local_2 in _arg_1)
            {
                _local_4 = this.createShopItem();
                _local_4.shopItemInfo = _local_2;
                _local_4.setColor(_local_2.Color);
                this._cartList.addChild(_local_4);
                this.addItemEvent(_local_4);
            };
            this._cartScroll.invalidateViewport();
            this.updateTxt();
        }

        protected function createShopItem():ShopCartItem
        {
            return (new ShopCartItem());
        }

        public function setup(_arg_1:ShopController, _arg_2:ShopModel, _arg_3:Array, _arg_4:int):void
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this._tempList = _arg_3;
            this._type = _arg_4;
            this._isDisposed = false;
            this.visible = true;
            this.init();
            this.initEvent();
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
            _local_2.dispose();
            if (this._type == SAVE)
            {
                this._controller.removeTempEquip(_local_3);
                this.updateTxt();
                this._cartScroll.invalidateViewport();
                if (this._model.currentTempList.length == 0)
                {
                    ShopManager.Instance.dispatchEvent(new ShopEvent(ShopEvent.SHOW_WEAK_GUILDE));
                    this.dispose();
                };
            };
            if (this._type == PURCHASE)
            {
                this._controller.removeFromCar(_local_3);
                this.updateTxt();
                this._cartScroll.invalidateViewport();
                if (this._model.allItems.length == 0)
                {
                    ShopManager.Instance.dispatchEvent(new ShopEvent(ShopEvent.SHOW_WEAK_GUILDE));
                    this.dispose();
                };
            };
            if (this._type == PRESENT)
            {
                this._controller.removeFromCar(_local_3);
                this._tempList.splice(this._tempList.indexOf(_local_3), 1);
                this.updateTxt();
                this._cartScroll.invalidateViewport();
                if (this._tempList.length == 0)
                {
                    this.dispose();
                };
            };
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    ShopManager.Instance.dispatchEvent(new ShopEvent(ShopEvent.SHOW_WEAK_GUILDE));
                    this.dispose();
                    return;
            };
        }

        public function get extraButton():BaseButton
        {
            return (null);
        }

        protected function removeEvent():void
        {
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS, this.onBuyedGoods);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT, this.onPresent);
            this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._saveImageBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
            this._giftsBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseConfirmationBtnClick);
        }

        private function __dispatchFrameEvent(_arg_1:MouseEvent):void
        {
            this._frame.dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
        }

        private function isMoneyGoods(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
        {
            if ((_arg_1 is ShopItemInfo))
            {
                return (ShopItemInfo(_arg_1).getItemPrice(1).IsMoneyType);
            };
            return (false);
        }

        private function notPresentGoods():Array
        {
            var _local_2:ShopCarItemInfo;
            var _local_1:Array = [];
            for each (_local_2 in this._tempList)
            {
                if (this._giveArray.indexOf(_local_2) == -1)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        private function onBuyedGoods(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:ShopCarItemInfo;
            var _local_5:int;
            _arg_1.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean;
            if (_local_2 != 0)
            {
                if (this._type == SAVE)
                {
                    this._model.clearCurrentTempList(((this._model.fittingSex) ? 1 : 2));
                }
                else
                {
                    if (this._type == PURCHASE)
                    {
                        this._model.clearAllitems();
                    };
                };
            }
            else
            {
                if (this._type == SAVE)
                {
                    this._model.clearCurrentTempList(((this._model.fittingSex) ? 1 : 2));
                    for each (_local_4 in this._model.currentLeftList)
                    {
                        this._model.addTempEquip(_local_4);
                    };
                    this.setList(this._model.currentTempList);
                    if (this._model.currentTempList.length < 1)
                    {
                        _local_3 = true;
                    };
                }
                else
                {
                    if (this._type == PURCHASE)
                    {
                        _local_5 = 0;
                        while (_local_5 < this._buyArray.length)
                        {
                            this._model.removeFromShoppingCar((this._buyArray[_local_5] as ShopCarItemInfo));
                            _local_5++;
                        };
                        this.setList(this._model.allItems);
                        if (this._model.allItems.length < 1)
                        {
                            _local_3 = true;
                        };
                    };
                };
            };
            if (_local_2 != 0)
            {
                this.dispose();
            }
            else
            {
                if (_local_3)
                {
                    this.dispose();
                };
            };
        }

        private function onPresent(_arg_1:CrazyTankSocketEvent):void
        {
            this._shopPresentClearingFrame.presentBtn.enable = true;
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
            this.visible = true;
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:int;
            while (_local_3 < this._giveArray.length)
            {
                this._model.removeFromShoppingCar((this._giveArray[_local_3] as ShopCarItemInfo));
                this._tempList.splice(this._tempList.indexOf((this._giveArray[_local_3] as ShopCarItemInfo)), 1);
                _local_3++;
            };
            if (this._tempList.length == 0)
            {
                this.dispose();
                return;
            };
            if (this._tempList.length > 0)
            {
                this.setList(this.notPresentGoods());
                return;
            };
        }

        private function presentCheckOut():void
        {
            this._giveArray = ShopManager.Instance.giveGift(this._model.allItems, this._model.Self);
            if (this._giveArray.length > 0)
            {
                this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
                this._shopPresentClearingFrame.show();
                this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK, this.__presentBtnClick);
                this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE, this.__shopPresentClearingFrameResponseHandler);
                this.visible = false;
            }
            else
            {
                LeavePageManager.showFillFrame();
            };
        }

        private function __shopPresentClearingFrameResponseHandler(_arg_1:FrameEvent):void
        {
            this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE, this.__shopPresentClearingFrameResponseHandler);
            if ((((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)) || (_arg_1.responseCode == FrameEvent.CANCEL_CLICK)))
            {
                StageReferance.stage.focus = this._frame;
                this.visible = true;
            };
        }

        protected function __presentBtnClick(_arg_1:MouseEvent):void
        {
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
            var _local_2:int = this.price()[MONEY];
            if (PlayerManager.Instance.Self.Money < _local_2)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            this._shopPresentClearingFrame.presentBtn.enable = false;
            this._controller.presentItems(this._tempList, this._shopPresentClearingFrame.textArea.text, this._shopPresentClearingFrame.nameInput.text);
        }

        private function saveFigureCheckOut():void
        {
            this._buyArray = ShopManager.Instance.buyIt(this._model.currentTempList);
            this._controller.buyItems(this._model.currentTempList, true, this._model.currentModel.Skin);
        }

        private function shopCarCheckOut():void
        {
            var _local_1:ShopCarItemInfo;
            this._buyArray = ShopManager.Instance.buyIt(this._model.allItems);
            this._controller.buyItems(this._model.allItems, false);
            for each (_local_1 in this._buyArray)
            {
                if (_local_1.TemplateID == 11025)
                {
                    SavePointManager.Instance.setSavePoint(15);
                    break;
                };
            };
        }

        public function price():Array
        {
            var _local_1:Array = ((this._type == SAVE) ? this._model.currentTempList : this._model.allItems);
            if (this._type == PRESENT)
            {
                _local_1 = this._tempList;
            };
            return (this._model.calcPrices(_local_1));
        }

        protected function updateTxt():void
        {
            var _local_1:Array = ((this._type == SAVE) ? this._model.currentTempList : this._model.allItems);
            if (this._type == PRESENT)
            {
                _local_1 = this._tempList;
            };
            var _local_2:Array = this.price();
            this._commodityNumberText.text = String(_local_1.length);
            this.theDifferenceOfmoneyValuAndDDTMoney = (_local_2[MONEY] - PlayerManager.Instance.Self.DDTMoney);
            if (this._type == PRESENT)
            {
                this._commodityPricesText2.text = String(0);
                this._commodityPricesText1.text = String(_local_2[MONEY]);
            }
            else
            {
                if (this.theDifferenceOfmoneyValuAndDDTMoney >= 0)
                {
                    this._commodityPricesText1.text = String(this.theDifferenceOfmoneyValuAndDDTMoney);
                    this._commodityPricesText2.text = String(PlayerManager.Instance.Self.DDTMoney);
                }
                else
                {
                    this._commodityPricesText1.text = String(0);
                    this._commodityPricesText2.text = String(_local_2[MONEY]);
                };
            };
        }

        public function dispose():void
        {
            var _local_1:ShopCartItem;
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_CHECK_OUT);
            if (this._shopPresentClearingFrame)
            {
                if (this._shopPresentClearingFrame.presentBtn)
                {
                    this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK, this.__presentBtnClick);
                };
                this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE, this.__shopPresentClearingFrameResponseHandler);
                this._shopPresentClearingFrame.dispose();
                this._shopPresentClearingFrame = null;
            };
            if ((!(this._isDisposed)))
            {
                this.removeEvent();
                ObjectUtils.disposeAllChildren(this);
                while (this._cartList.numChildren > 0)
                {
                    _local_1 = (this._cartList.getChildAt((this._cartList.numChildren - 1)) as ShopCartItem);
                    this.removeItemEvent(_local_1);
                    this._cartList.removeChild(_local_1);
                    _local_1.dispose();
                    _local_1 = null;
                };
                this._buyArray = null;
                this._cartList = null;
                this._cartScroll = null;
                this._controller = null;
                this._giveArray = null;
                this._innerBg = null;
                this._frame = null;
                this._commodityNumberText = null;
                this._commodityPricesText1 = null;
                this._commodityNumberTip = null;
                this._commodityPricesText2 = null;
                this._commodityPricesText1Bg = null;
                this._commodityPricesText2Bg = null;
                this._commodityPricesText3Bg = null;
                this._purchaseConfirmationBtn = null;
                this._giftsBtn = null;
                this._saveImageBtn = null;
                this._innerBg1 = null;
                this._innerBg = null;
                this._model = null;
                if (parent)
                {
                    parent.removeChild(this);
                };
                this._isDisposed = true;
            };
        }


    }
}//package shop.view

