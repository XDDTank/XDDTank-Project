// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopRechargeEquipViewItem

package shop.view
{
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import flash.filters.ColorMatrixFilter;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.ShopManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SoundManager;
    import ddt.data.goods.Price;
    import flash.events.Event;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.ShopItemInfo;

    public class ShopRechargeEquipViewItem extends ShopCartItem implements Disposeable 
    {

        public static const DELETE_ITEM:String = "deleteitem";
        public static const CONDITION_CHANGE:String = "conditionchange";

        private var _moneyRadioBtn:SelectedCheckButton;
        private var _giftRadioBtn:SelectedCheckButton;
        private var _isDelete:Boolean = false;
        private var _radioGroup:SelectedButtonGroup;
        private var _shopItems:Array;
        private var fileterArr:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];

        public function ShopRechargeEquipViewItem()
        {
            this.init();
        }

        private function init():void
        {
            PositionUtils.setPos(_closeBtn, "ddtshop.RechargeViewCloseBtnPos");
            PositionUtils.setPos(_cartItemSelectVBox, "ddtshop.RechargeViewSelectVBoxPos");
        }

        override protected function drawBackground():void
        {
            _bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
            _itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
            _verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.VerticalLine");
            addChild(_bg);
            addChild(_verticalLine);
            addChild(_itemCellBg);
        }

        private function initEventListener():void
        {
            this._moneyRadioBtn.addEventListener(MouseEvent.CLICK, this.__selectRadioBtn);
            this._giftRadioBtn.addEventListener(MouseEvent.CLICK, this.__selectRadioBtn);
        }

        public function set itemInfo(_arg_1:InventoryItemInfo):void
        {
            _cell.info = _arg_1;
            this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(_arg_1.TemplateID);
            _shopItemInfo = null;
            var _local_2:int;
            while (_local_2 < this._shopItems.length)
            {
                if (this._shopItems[_local_2].getItemPrice(1).IsMoneyType)
                {
                    _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_local_2]);
                    break;
                };
                _local_2++;
            };
            if (_shopItemInfo == null)
            {
                _shopItemInfo = this.fillToShopCarInfo(this._shopItems[0]);
            };
            this.cartItemSelectVBoxInit();
            _cartItemGroup.selectIndex = (_cartItemSelectVBox.numChildren - 1);
            _itemName.text = _arg_1.Name;
        }

        override protected function cartItemSelectVBoxInit():void
        {
            super.cartItemSelectVBoxInit();
            if (_cartItemSelectVBox.numChildren == 2)
            {
                _cartItemSelectVBox.y = 18;
            }
            else
            {
                if (_cartItemSelectVBox.numChildren == 1)
                {
                    _cartItemSelectVBox.y = 21;
                };
            };
        }

        private function __selectRadioBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.currentTarget == this._moneyRadioBtn)
            {
                this.updateCurrentShopItem(Price.MONEY);
            };
            this.cartItemSelectVBoxInit();
            _cartItemGroup.selectIndex = (_cartItemSelectVBox.numChildren - 1);
            dispatchEvent(new Event(CONDITION_CHANGE));
        }

        public function get currentShopItem():ShopCarItemInfo
        {
            return (_shopItemInfo);
        }

        public function get isDelete():Boolean
        {
            return (this._isDelete);
        }

        private function updateCurrentShopItem(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this._shopItems.length)
            {
                if (this._shopItems[_local_2].getItemPrice(1).PriceType == _arg_1)
                {
                    _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_local_2]);
                    return;
                };
                _local_2++;
            };
        }

        override protected function __closeClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._isDelete = true;
            dispatchEvent(new Event(DELETE_ITEM));
        }

        private function fillToShopCarInfo(_arg_1:ShopItemInfo):ShopCarItemInfo
        {
            if ((!(_arg_1)))
            {
                return (null);
            };
            var _local_2:ShopCarItemInfo = new ShopCarItemInfo(_arg_1.GoodsID, _arg_1.TemplateID, _cell.info.CategoryID);
            ObjectUtils.copyProperties(_local_2, _arg_1);
            return (_local_2);
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            this._shopItems = null;
        }


    }
}//package shop.view

