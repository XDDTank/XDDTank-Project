// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.goods.AddPricePanel

package ddt.view.goods
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.ComboBox;
    import ddt.data.goods.InventoryItemInfo;
    import flash.text.TextFormat;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.image.Image;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.ShopManager;
    import ddt.data.goods.Price;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.SocketManager;

    public class AddPricePanel extends Frame 
    {

        private static var _instance:AddPricePanel;

        private var _infoLabel:FilterFrameText;
        private var _payButton:TextButton;
        private var _cancelButton:TextButton;
        private var _leftLabel:Bitmap;
        private var _payComBox:ComboBox;
        private var _isDress:Boolean;
        private var _info:InventoryItemInfo;
        private var _blueTF:TextFormat;
        private var _yellowTF:TextFormat;
        private var _grayFilter:ColorMatrixFilter;
        private var _currentAlert:BaseAlerFrame;
        private var _currentPayType:int;
        protected var _cartItemGroup:SelectedButtonGroup;
        protected var _cartItemSelectVBox:VBox;
        private var _textI:FilterFrameText;
        private var _textImg:Image;
        private var _shopItems:Array;
        private var _currentShopItem:ShopCarItemInfo;

        public function AddPricePanel()
        {
            if (_instance != null)
            {
                return;
            };
            this.configUI();
        }

        public static function get Instance():AddPricePanel
        {
            if (_instance == null)
            {
                _instance = ComponentFactory.Instance.creatCustomObject("reNewPricePanel");
            };
            return (_instance);
        }


        private function configUI():void
        {
            this._textImg = ComponentFactory.Instance.creat("reNew.TipsTextBg");
            addToContent(this._textImg);
            this._grayFilter = ComponentFactory.Instance.model.getSet("grayFilter");
            this._blueTF = ComponentFactory.Instance.model.getSet("bagAndInfo.AddPrice.BlueTF");
            this._yellowTF = ComponentFactory.Instance.model.getSet("bagAndInfo.AddPrice.YellowTF");
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._textI = ComponentFactory.Instance.creat("renew.TextI");
            addToContent(this._textI);
            this._textI.text = LanguageMgr.GetTranslation("ddt.bagandinfo.renew.txtI");
            PositionUtils.setPos(this._textI, "renew.txtPos1");
            this._payButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.AddPrice.PayButton");
            this._payButton.text = LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu");
            addToContent(this._payButton);
            this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.AddPrice.CancelButton");
            this._cancelButton.text = LanguageMgr.GetTranslation("cancel");
            addToContent(this._cancelButton);
            this._cartItemGroup = new SelectedButtonGroup();
            this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("renew.CartItemSelectVBox");
            addToContent(this._cartItemSelectVBox);
        }

        public function setInfo(_arg_1:InventoryItemInfo, _arg_2:Boolean):void
        {
            this._info = _arg_1;
            this._isDress = _arg_2;
            this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(this._info.TemplateID);
            this._currentShopItem = null;
            var _local_3:int;
            while (_local_3 < this._shopItems.length)
            {
                if (this._shopItems[_local_3].getItemPrice(1).IsMoneyType)
                {
                    this._currentShopItem = this.fillToShopCarInfo(this._shopItems[_local_3]);
                    this._currentPayType = Price.MONEY;
                    break;
                };
                _local_3++;
            };
            if (this._currentShopItem == null)
            {
                this._currentShopItem = this.fillToShopCarInfo(this._shopItems[0]);
            };
            this.cartItemSelectVBoxInit();
        }

        protected function cartItemSelectVBoxInit():void
        {
            var _local_2:SelectedCheckButton;
            var _local_3:String;
            if (this._cartItemGroup)
            {
                this._cartItemGroup.removeEventListener(Event.CHANGE, this.__cartItemGroupChange);
                this._cartItemGroup = null;
            };
            this._cartItemGroup = new SelectedButtonGroup();
            this._cartItemGroup.addEventListener(Event.CHANGE, this.__cartItemGroupChange);
            this._cartItemSelectVBox.disposeAllChildren();
            var _local_1:int = 1;
            while (_local_1 < 4)
            {
                if (!(!(this._currentShopItem.getItemPrice(_local_1).IsValid)))
                {
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("reNewSelectBtn");
                    _local_3 = ((!(this._currentShopItem.getTimeToString(_local_1) == LanguageMgr.GetTranslation("ddt.shop.buyTime1"))) ? this._currentShopItem.getTimeToString(_local_1) : LanguageMgr.GetTranslation("ddt.shop.buyTime2"));
                    _local_2.text = ((this._currentShopItem.getItemPrice(_local_1).toStringI() + "/") + _local_3);
                    this._cartItemSelectVBox.addChild(_local_2);
                    this._cartItemGroup.addSelectItem(_local_2);
                };
                _local_1++;
            };
            this._cartItemGroup.selectIndex = (this._cartItemSelectVBox.numChildren - 1);
        }

        protected function __cartItemGroupChange(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this._currentShopItem.currentBuyType = (this._cartItemGroup.selectIndex + 1);
        }

        private function fillToShopCarInfo(_arg_1:ShopItemInfo):ShopCarItemInfo
        {
            if ((!(_arg_1)))
            {
                return (null);
            };
            var _local_2:ShopCarItemInfo = new ShopCarItemInfo(_arg_1.GoodsID, _arg_1.TemplateID, this._info.CategoryID);
            ObjectUtils.copyProperties(_local_2, _arg_1);
            return (_local_2);
        }

        public function show():void
        {
            this.addEvent();
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function updateCurrentShopItem(_arg_1:int):void
        {
            this._currentPayType = _arg_1;
            var _local_2:int;
            while (_local_2 < this._shopItems.length)
            {
                if (this._shopItems[_local_2].getItemPrice(1).PriceType == _arg_1)
                {
                    this._currentShopItem = this.fillToShopCarInfo(this._shopItems[_local_2]);
                    return;
                };
                _local_2++;
            };
        }

        private function addEvent():void
        {
            this._cancelButton.addEventListener(MouseEvent.CLICK, this.__onCancelClick);
            this._payButton.addEventListener(MouseEvent.CLICK, this.__onPay);
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.close();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.__onPay(null);
                    return;
            };
        }

        private function removeEvent():void
        {
            this._cancelButton.removeEventListener(MouseEvent.CLICK, this.__onCancelClick);
            this._payButton.addEventListener(MouseEvent.CLICK, this.__onPay);
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    if (this._currentAlert == _local_2)
                    {
                        this._currentAlert = null;
                    };
                    _local_2.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (this._currentAlert == _local_2)
                    {
                        this._currentAlert = null;
                    };
                    LeavePageManager.leaveToFillPath();
                    _local_2.dispose();
            };
        }

        private function __onPay(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:Number;
            SoundManager.instance.play("008");
            _local_3 = (this._currentShopItem.getItemPrice((this._cartItemGroup.selectIndex + 1)).moneyValue - PlayerManager.Instance.Self.DDTMoney);
            if (_local_3 >= 0)
            {
                if (_local_3 > PlayerManager.Instance.Self.Money)
                {
                    this._currentAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                    this._currentAlert.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
                }
                else
                {
                    this.close();
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_2.addEventListener(FrameEvent.RESPONSE, this.__onPayResponse);
                };
            }
            else
            {
                this.close();
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__onPayResponse);
            };
        }

        private function __onPayResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onPayResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.doPay();
            };
        }

        private function __onCancelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.close();
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.close();
            super.__onCloseClick(_arg_1);
        }

        private function doPay():void
        {
            var _local_1:Array;
            if (this._info)
            {
                _local_1 = [];
                _local_1.push([this._info.BagType, this._info.Place, this._currentShopItem.GoodsID, (this._cartItemGroup.selectIndex + 1), this._isDress]);
                SocketManager.Instance.out.sendGoodsContinue(_local_1);
                this.close();
            };
        }

        public function close():void
        {
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.goods

