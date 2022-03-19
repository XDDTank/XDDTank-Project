// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopRechargeEquipView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.goods.ItemPrice;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.LeavePageManager;
    import flash.events.Event;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ShopManager;
    import ddt.events.PlayerPropertyEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopRechargeEquipView extends Sprite implements Disposeable 
    {

        private var price:ItemPrice;
        private var _bg:Image;
        private var _frame:BaseAlerFrame;
        private var _chargeBtn:TextButton;
        private var _itemContainer:VBox;
        private var _scrollPanel:ScrollPanel;
        private var _equipList:Array;
        private var _costMoneyTxt:FilterFrameText;
        private var _costGiftTxt:FilterFrameText;
        private var _playerMoneyTxt:FilterFrameText;
        private var _playerGiftTxt:FilterFrameText;
        private var _currentCountTxt:FilterFrameText;
        private var _affirmContinuBt:BaseButton;
        private var theDifferenceOfmoneyValuAndDDTMoney:int;
        private var _needToPayPanelBg:Bitmap;
        private var _haveOwnPanelBg:Bitmap;
        private var _amountOfItemTipText:FilterFrameText;

        public function ShopRechargeEquipView()
        {
            this.init();
        }

        private function init():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrame");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewFrameBg");
            this._needToPayPanelBg = ComponentFactory.Instance.creatBitmap("ddtshop.RechargeView.NeedToPayPanelBg");
            this._haveOwnPanelBg = ComponentFactory.Instance.creatBitmap("ddtshop.RechargeView.HaveOwnPanelBg");
            this._amountOfItemTipText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.AmountOfItemTipText");
            this._amountOfItemTipText.text = LanguageMgr.GetTranslation("shop.RechargeView.AmountOfItemTipText");
            this._chargeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeBtn");
            this._chargeBtn.text = LanguageMgr.GetTranslation("shop.RechargeView.RechargeBtnText");
            this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewItemList");
            this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemContainer");
            this._costMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftTicketNumberText");
            this._costGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.LeftGiftNumberText");
            this._playerMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightTicketNumberText");
            this._playerGiftTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RightGiftNumberText");
            this._currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeViewCurrentCount");
            this._affirmContinuBt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.RechargeConfirmationBtn");
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.continuation.contiuationTitle"), LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu"), LanguageMgr.GetTranslation("cancel"), false, false);
            this._frame.info = _local_1;
            this._equipList = PlayerManager.Instance.Self.OvertimeListByBody;
            this._scrollPanel.vScrollProxy = ScrollPanel.ON;
            this._scrollPanel.setView(this._itemContainer);
            this._itemContainer.spacing = 5;
            this._itemContainer.strictSize = 80;
            this._scrollPanel.invalidateViewport();
            this._frame.moveEnable = false;
            this._frame.addToContent(this._bg);
            this._frame.addToContent(this._needToPayPanelBg);
            this._frame.addToContent(this._haveOwnPanelBg);
            this._frame.addToContent(this._amountOfItemTipText);
            this._frame.addToContent(this._chargeBtn);
            this._frame.addToContent(this._scrollPanel);
            this._frame.addToContent(this._costMoneyTxt);
            this._frame.addToContent(this._costGiftTxt);
            this._frame.addToContent(this._playerMoneyTxt);
            this._frame.addToContent(this._playerGiftTxt);
            this._frame.addToContent(this._currentCountTxt);
            this._frame.addToContent(this._affirmContinuBt);
            this.setList();
            this.__onPlayerPropertyChange();
            this._chargeBtn.addEventListener(MouseEvent.CLICK, this.__onChargeClick);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._affirmContinuBt.addEventListener(MouseEvent.CLICK, this._clickContinuBt);
            addChild(this._frame);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                    }
                    else
                    {
                        this.payAll();
                    };
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    InventoryItemInfo.startTimer();
                    this.dispose();
            };
        }

        private function _clickContinuBt(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
            }
            else
            {
                this.payAll();
            };
        }

        private function __onChargeClick(_arg_1:Event):void
        {
            LeavePageManager.leaveToFillPath();
        }

        private function payAll():void
        {
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:ShopCarItemInfo;
            var _local_7:ShopRechargeEquipViewItem;
            var _local_8:int;
            var _local_9:uint;
            var _local_10:ShopRechargeEquipViewItem;
            var _local_11:Boolean;
            var _local_1:Array = this.shopInfoList;
            var _local_2:Array = this.shopInfoListWithOutDelete;
            if (_local_2.length > 0)
            {
                _local_3 = new Array();
                _local_4 = new Array();
                _local_5 = new Array();
                for each (_local_6 in _local_2)
                {
                    _local_9 = _local_1.indexOf(_local_6);
                    _local_10 = (this._itemContainer.getChildAt(_local_9) as ShopRechargeEquipViewItem);
                    _local_4.push(_local_10.info);
                    _local_5.push(_local_10);
                };
                for each (_local_7 in _local_5)
                {
                    this._itemContainer.removeChild(_local_7);
                };
                this._scrollPanel.invalidateViewport();
                _local_8 = 0;
                while (_local_8 < _local_2.length)
                {
                    _local_11 = (_local_4[_local_8].Place <= 30);
                    _local_3.push([_local_4[_local_8].BagType, _local_4[_local_8].Place, _local_2[_local_8].GoodsID, _local_2[_local_8].currentBuyType, _local_11]);
                    _local_8++;
                };
                this.updateTxt();
                SocketManager.Instance.out.sendGoodsContinue(_local_3);
                if (this._itemContainer.numChildren <= 0)
                {
                    this.dispose();
                }
                else
                {
                    if (this.shopInfoListWithOutDelete.length > 0)
                    {
                        this.showAlert();
                    };
                };
            }
            else
            {
                if (this.shopInfoListWithOutDelete.length != 0)
                {
                    this.showAlert();
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.continuation.contiuationFailed"));
                };
            };
        }

        private function setList():void
        {
            var i:InventoryItemInfo;
            var item:ShopRechargeEquipViewItem;
            this._equipList.sort(function (_arg_1:InventoryItemInfo, _arg_2:InventoryItemInfo):Number
            {
                var _local_3:Array = [7, 5, 1, 17, 8, 9, 14, 6, 13, 15, 3, 4, 2];
                var _local_4:uint = _local_3.indexOf(_arg_1.CategoryID);
                var _local_5:uint = _local_3.indexOf(_arg_2.CategoryID);
                if (_local_4 < _local_5)
                {
                    return (-1);
                };
                if (_local_4 == _local_5)
                {
                    return (0);
                };
                return (1);
            });
            for each (i in this._equipList)
            {
                if (ShopManager.Instance.canAddPrice(i.TemplateID))
                {
                    item = new ShopRechargeEquipViewItem();
                    item.itemInfo = i;
                    item.setColor(i.Color);
                    item.addEventListener(ShopCartItem.DELETE_ITEM, this.__onItemDelete);
                    item.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__onItemChange);
                    this._itemContainer.addChild(item);
                };
            };
            this._scrollPanel.invalidateViewport();
            this.updateTxt();
        }

        private function __onItemDelete(_arg_1:Event):void
        {
            var _local_2:ShopRechargeEquipViewItem = (_arg_1.currentTarget as ShopRechargeEquipViewItem);
            _local_2.removeEventListener(ShopCartItem.DELETE_ITEM, this.__onItemDelete);
            _local_2.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__onItemChange);
            this._itemContainer.removeChild(_local_2);
            this.updateTxt();
            this._scrollPanel.invalidateViewport();
        }

        private function __onItemChange(_arg_1:Event):void
        {
            this.updateTxt();
        }

        private function get shopInfoListWithOutDelete():Array
        {
            var _local_3:ShopRechargeEquipViewItem;
            var _local_1:Array = new Array();
            var _local_2:uint;
            while (_local_2 < this._itemContainer.numChildren)
            {
                _local_3 = (this._itemContainer.getChildAt(_local_2) as ShopRechargeEquipViewItem);
                if (((_local_3) && (!(_local_3.isDelete))))
                {
                    _local_1.push(_local_3.shopItemInfo);
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function get shopInfoList():Array
        {
            var _local_3:ShopRechargeEquipViewItem;
            var _local_1:Array = new Array();
            var _local_2:uint;
            while (_local_2 < this._itemContainer.numChildren)
            {
                _local_3 = (this._itemContainer.getChildAt(_local_2) as ShopRechargeEquipViewItem);
                _local_1.push(_local_3.shopItemInfo);
                _local_2++;
            };
            return (_local_1);
        }

        private function updateTxt():void
        {
            var _local_3:ShopCarItemInfo;
            var _local_1:Array = this.shopInfoListWithOutDelete;
            var _local_2:uint = _local_1.length;
            this._currentCountTxt.text = String(_local_2);
            if (_local_2 == 0)
            {
                this._affirmContinuBt.enable = false;
            }
            else
            {
                this._affirmContinuBt.enable = true;
            };
            this._frame.submitButtonEnable = ((_local_2 <= 0) ? false : true);
            this.price = new ItemPrice(null, null, null);
            for each (_local_3 in _local_1)
            {
                this.price.addItemPrice(_local_3.getCurrentPrice());
            };
            this.theDifferenceOfmoneyValuAndDDTMoney = (this.price.moneyValue - PlayerManager.Instance.Self.DDTMoney);
            if (this.theDifferenceOfmoneyValuAndDDTMoney >= 0)
            {
                this._costMoneyTxt.text = String(this.theDifferenceOfmoneyValuAndDDTMoney);
                this._costGiftTxt.text = String(PlayerManager.Instance.Self.DDTMoney);
            }
            else
            {
                this._costMoneyTxt.text = String(0);
                this._costGiftTxt.text = String(this.price.moneyValue);
            };
            this.updataTextColor();
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPlayerPropertyChange, false, 0, true);
        }

        private function __onPlayerPropertyChange(_arg_1:Event=null):void
        {
            this._playerMoneyTxt.text = String(PlayerManager.Instance.Self.Money);
            this._playerGiftTxt.text = String(PlayerManager.Instance.Self.DDTMoney);
            this.updataTextColor();
        }

        private function updataTextColor():void
        {
            if (this.price)
            {
                if (this.price.moneyValue > PlayerManager.Instance.Self.Money)
                {
                    this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
                }
                else
                {
                    this._costMoneyTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
                };
                if (this.price.ddtMoneyValue > PlayerManager.Instance.Self.DDTMoney)
                {
                    this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.DigitWarningTF"));
                }
                else
                {
                    this._costGiftTxt.setTextFormat(ComponentFactory.Instance.model.getSet("ddtshop.RechargeView.NumberTextTF"));
                };
            };
        }

        private function showAlert():void
        {
            var _local_1:BaseAlerFrame;
            if (this.price.moneyValue > PlayerManager.Instance.Self.totalMoney)
            {
                _local_1 = LeavePageManager.showFillFrame();
            }
            else
            {
                if (this.price.ddtMoneyValue > PlayerManager.Instance.Self.DDTMoney)
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"), LanguageMgr.GetTranslation("ok"), "", true, false, false, LayerManager.ALPHA_BLOCKGOUND);
                };
            };
        }

        public function dispose():void
        {
            InventoryItemInfo.startTimer();
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__onPlayerPropertyChange);
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._chargeBtn.removeEventListener(MouseEvent.CLICK, this.__onChargeClick);
            this._affirmContinuBt.removeEventListener(MouseEvent.CLICK, this._clickContinuBt);
            this._frame.dispose();
            this._frame = null;
            this.price = null;
            this._bg = null;
            ObjectUtils.disposeObject(this._amountOfItemTipText);
            this._amountOfItemTipText = null;
            ObjectUtils.disposeObject(this._needToPayPanelBg);
            this._needToPayPanelBg = null;
            ObjectUtils.disposeObject(this._haveOwnPanelBg);
            this._haveOwnPanelBg = null;
            this._chargeBtn = null;
            this._itemContainer = null;
            this._scrollPanel = null;
            this._equipList = null;
            this._costMoneyTxt = null;
            this._costGiftTxt = null;
            this._playerMoneyTxt = null;
            this._playerGiftTxt = null;
            this._currentCountTxt = null;
            this._affirmContinuBt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

