// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.command.QuickBuyFrame

package ddt.command
{
    import com.pickgliss.ui.controls.Frame;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.data.EquipType;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.ShortcutBuyEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;

    public class QuickBuyFrame extends Frame 
    {

        public static const ACTIVITY:int = 10;

        public var canDispose:Boolean;
        private var _view:QuickBuyFrameView;
        private var _shopItemInfo:ShopItemInfo;
        private var _submitButton:TextButton;
        private var _unitPrice:Number;
        private var _priceType:int = 0;
        private var _buyFrom:int;

        public function QuickBuyFrame()
        {
            this.canDispose = true;
            this.initView();
            this.initEvents();
        }

        public function get priceType():int
        {
            return (this._priceType);
        }

        public function set priceType(_arg_1:int):void
        {
            this._priceType = _arg_1;
            this._view.priceType = _arg_1;
        }

        private function initView():void
        {
            this._view = new QuickBuyFrameView();
            addToContent(this._view);
            this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
            this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
            this._view.addChild(this._submitButton);
            escEnable = true;
            enterEnable = true;
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._submitButton.addEventListener(MouseEvent.CLICK, this.doPay);
            this._view.addEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
            addEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function removeEvnets():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this.doPay);
            };
            if (this._view)
            {
                this._view.removeEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
            };
            removeEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function _numberClose(_arg_1:Event):void
        {
            this.cancelMoney();
            ObjectUtils.disposeObject(this);
        }

        private function _numberEnter(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            this.doPay(null);
        }

        public function setTitleText(_arg_1:String):void
        {
            titleText = _arg_1;
        }

        public function set itemID(_arg_1:int):void
        {
            this._view.ItemID = _arg_1;
            this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID);
            this.perPrice();
        }

        public function setItemID(_arg_1:int, _arg_2:Boolean=false):void
        {
            this._view.ItemID = _arg_1;
            this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID, _arg_2);
            this.perPrice();
        }

        public function set stoneNumber(_arg_1:int):void
        {
            this._view.stoneNumber = _arg_1;
        }

        public function set maxLimit(_arg_1:int):void
        {
            this._view.maxLimit = _arg_1;
        }

        private function perPrice():void
        {
            if (this._buyFrom != ACTIVITY)
            {
                this._unitPrice = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view.ItemID).getItemPrice(1).moneyValue;
            };
        }

        public function set unitPrice(_arg_1:int):void
        {
            this._unitPrice = _arg_1;
            this._view.price = _arg_1;
        }

        private function doPay(_arg_1:Event):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:Array;
            var _local_9:int;
            SoundManager.instance.play("008");
            if ((((!(this._buyFrom == ACTIVITY)) && (!(ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID).isValid))) && (!(this._view._itemID == EquipType.BOGU_COIN))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.quickDate"));
            };
            if (this.getSlefMoney() < (this._view.stoneNumber * this._unitPrice))
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.moveEnable = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
                this.dispose();
                return;
            };
            if (this._view.ItemID == EquipType.GOLD_BOX)
            {
                SocketManager.Instance.out.sendQuickBuyGoldBox(this._view.stoneNumber);
            }
            else
            {
                if (this._view.ItemID == EquipType.BOGU_COIN)
                {
                    SocketManager.Instance.out.sendQuickBuyBoguCoin(this._view.stoneNumber);
                }
                else
                {
                    if (this._buyFrom != ACTIVITY)
                    {
                        _local_3 = [];
                        _local_4 = [];
                        _local_5 = [];
                        _local_6 = [];
                        _local_7 = [];
                        _local_8 = [];
                        _local_9 = 0;
                        while (_local_9 < this._view.stoneNumber)
                        {
                            _local_3.push(this._shopItemInfo.GoodsID);
                            _local_4.push(1);
                            _local_5.push("");
                            _local_6.push(false);
                            _local_7.push("");
                            _local_8.push(-1);
                            _local_9++;
                        };
                        SocketManager.Instance.out.sendBuyGoods(_local_3, _local_4, _local_5, _local_8, _local_6, _local_7, this._buyFrom);
                    };
                };
            };
            dispatchEvent(new ShortcutBuyEvent(this._view._itemID, this._view.stoneNumber));
            this.dispose();
        }

        public function getSlefMoney():int
        {
            if (this.priceType == 0)
            {
                return (PlayerManager.Instance.Self.totalMoney);
            };
            if (this.priceType == 1)
            {
                return (PlayerManager.Instance.Self.Money);
            };
            if (this.priceType == 2)
            {
                return (PlayerManager.Instance.Self.totalMoney);
            };
            return (0);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.cancelMoney();
                ObjectUtils.disposeObject(this);
            }
            else
            {
                if (_arg_1.responseCode == FrameEvent.ENTER_CLICK)
                {
                    this.doPay(null);
                };
            };
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this.doMoney();
            }
            else
            {
                this.cancelMoney();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function doMoney():void
        {
            LeavePageManager.leaveToFillPath();
            dispatchEvent(new ShortcutBuyEvent(0, 0, false, false, ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK));
        }

        private function cancelMoney():void
        {
            dispatchEvent(new ShortcutBuyEvent(0, 0, false, false, ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL));
        }

        public function set buyFrom(_arg_1:int):void
        {
            this._buyFrom = _arg_1;
            this._view.buyFrom = this._buyFrom;
        }

        public function get buyFrom():int
        {
            return (this._buyFrom);
        }

        override public function dispose():void
        {
            this.removeEvnets();
            this.canDispose = false;
            super.dispose();
            this._view = null;
            this._shopItemInfo = null;
            if (this._submitButton)
            {
                ObjectUtils.disposeObject(this._submitButton);
            };
            this._submitButton = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.command

