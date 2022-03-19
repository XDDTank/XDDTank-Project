// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.SetsShopView

package shop.view
{
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;

    public class SetsShopView extends ShopCheckOutView 
    {

        private var _allCheckBox:SelectedCheckButton;
        private var _setsPrice:int = 99;
        private var _selectedAll:Boolean = true;
        private var _totalPrice:int;


        public function initialize(_arg_1:Array):void
        {
            this.init();
            this.initEvent();
            setList(_arg_1);
            _commodityPricesText2.text = "0";
            _purchaseConfirmationBtn.visible = true;
            _commodityNumberTip.htmlText = LanguageMgr.GetTranslation("shop.setsshopview.commodity");
            PositionUtils.setPos(_commodityNumberTip, "ddt.setsShopView.pos");
            _commodityNumberText.visible = false;
            this._allCheckBox.selected = true;
            this._allCheckBox.dispatchEvent(new Event(Event.SELECT));
        }

        override protected function drawFrame():void
        {
            _frame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.setsShopView");
            _frame.titleText = LanguageMgr.GetTranslation("shop.SetsTitle");
            addChild(_frame);
        }

        override protected function init():void
        {
            super.init();
            this._allCheckBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.SetsShopView.SetsShopALLCheckBox");
            this._allCheckBox.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont1");
            _frame.addToContent(this._allCheckBox);
            this.fixPos();
        }

        private function fixPos():void
        {
            _commodityNumberTip.y = (_commodityNumberTip.y + 8);
            _commodityNumberText.y = (_commodityNumberText.y + 8);
            _innerBg1.y = (_innerBg1.y + 18);
            _commodityPricesText1.y = (_commodityPricesText1.y + 18);
            _commodityPricesText2.y = (_commodityPricesText2.y + 18);
            _purchaseConfirmationBtn.y = (_purchaseConfirmationBtn.y + 18);
            _giftsBtn.y = (_giftsBtn.y + 18);
            _saveImageBtn.y = (_saveImageBtn.y + 18);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            this._allCheckBox.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._allCheckBox.addEventListener(Event.SELECT, this.__allSelected);
        }

        protected function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            this._allCheckBox.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._allCheckBox.removeEventListener(Event.SELECT, this.__allSelected);
        }

        private function __allSelected(_arg_1:Event):void
        {
            var _local_2:SetsShopItem;
            var _local_3:int;
            var _local_4:int;
            if (this._allCheckBox.selected)
            {
                _local_3 = 0;
                while (_local_3 < _cartList.numChildren)
                {
                    _local_2 = (_cartList.getChildAt(_local_3) as SetsShopItem);
                    if (_local_2)
                    {
                        _local_2.selected = true;
                    };
                    _local_3++;
                };
            }
            else
            {
                _local_4 = 0;
                while (_local_4 < _cartList.numChildren)
                {
                    _local_2 = (_cartList.getChildAt(_local_4) as SetsShopItem);
                    if (_local_2)
                    {
                        _local_2.selected = false;
                    };
                    _local_4++;
                };
            };
            this.updateTxt();
        }

        override protected function addItemEvent(_arg_1:ShopCartItem):void
        {
            super.addItemEvent(_arg_1);
            _arg_1.addEventListener(Event.SELECT, this.__itemSelectedChanged);
        }

        private function __itemSelectedChanged(_arg_1:Event):void
        {
            this.updateTxt();
        }

        override protected function removeItemEvent(_arg_1:ShopCartItem):void
        {
            super.removeItemEvent(_arg_1);
            _arg_1.removeEventListener(Event.SELECT, this.__itemSelectedChanged);
        }

        override protected function createShopItem():ShopCartItem
        {
            return (new SetsShopItem());
        }

        override protected function updateTxt():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_4:SetsShopItem;
            this._totalPrice = 0;
            var _local_3:int;
            while (_local_3 < _cartList.numChildren)
            {
                _local_4 = (_cartList.getChildAt(_local_3) as SetsShopItem);
                if (_local_4)
                {
                    _local_2++;
                    if (_local_4.selected)
                    {
                        this._totalPrice = (this._totalPrice + _local_4.shopItemInfo.AValue1);
                        _local_1++;
                    };
                };
                _local_3++;
            };
            _commodityNumberText.text = _local_1.toString();
            if (((_local_2 > 0) && (_local_1 >= _local_2)))
            {
                _commodityPricesText1.text = this._setsPrice.toString();
                this._totalPrice = this._setsPrice;
            }
            else
            {
                if (_local_2 > 0)
                {
                    _commodityPricesText1.text = this._totalPrice.toString();
                };
            };
            _commodityNumberText.text = String(_local_1);
            if (_local_1 > 0)
            {
                _purchaseConfirmationBtn.enable = true;
            }
            else
            {
                _purchaseConfirmationBtn.enable = false;
            };
        }

        override protected function __purchaseConfirmationBtnClick(_arg_1:MouseEvent=null):void
        {
            var _local_2:SetsShopItem;
            var _local_5:BaseAlerFrame;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.totalMoney < this._totalPrice)
            {
                _local_5 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                _local_5.moveEnable = false;
                _local_5.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                return;
            };
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _cartList.numChildren)
            {
                _local_2 = (_cartList.getChildAt(_local_4) as SetsShopItem);
                if (((_local_2) && (_local_2.selected)))
                {
                    _local_3.push(_local_2.shopItemInfo.GoodsID);
                };
                _local_4++;
            };
            SocketManager.Instance.out.sendUseCard(-1, -1, _local_3, 1);
            ObjectUtils.disposeObject(this);
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
        }


    }
}//package shop.view

