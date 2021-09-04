package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class ShopRechargeEquipViewItem extends ShopCartItem implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
       
      
      private var _moneyRadioBtn:SelectedCheckButton;
      
      private var _giftRadioBtn:SelectedCheckButton;
      
      private var _isDelete:Boolean = false;
      
      private var _radioGroup:SelectedButtonGroup;
      
      private var _shopItems:Array;
      
      private var fileterArr:Array;
      
      public function ShopRechargeEquipViewItem()
      {
         this.fileterArr = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         super();
         this.init();
      }
      
      private function init() : void
      {
         PositionUtils.setPos(_closeBtn,"ddtshop.RechargeViewCloseBtnPos");
         PositionUtils.setPos(_cartItemSelectVBox,"ddtshop.RechargeViewSelectVBoxPos");
      }
      
      override protected function drawBackground() : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
         _itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
         _verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RechargeView.VerticalLine");
         addChild(_bg);
         addChild(_verticalLine);
         addChild(_itemCellBg);
      }
      
      private function initEventListener() : void
      {
         this._moneyRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._giftRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         _cell.info = param1;
         this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(param1.TemplateID);
         _shopItemInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._shopItems.length)
         {
            if(this._shopItems[_loc2_].getItemPrice(1).IsMoneyType)
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_loc2_]);
               break;
            }
            _loc2_++;
         }
         if(_shopItemInfo == null)
         {
            _shopItemInfo = this.fillToShopCarInfo(this._shopItems[0]);
         }
         this.cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         _itemName.text = param1.Name;
      }
      
      override protected function cartItemSelectVBoxInit() : void
      {
         super.cartItemSelectVBoxInit();
         if(_cartItemSelectVBox.numChildren == 2)
         {
            _cartItemSelectVBox.y = 18;
         }
         else if(_cartItemSelectVBox.numChildren == 1)
         {
            _cartItemSelectVBox.y = 21;
         }
      }
      
      private function __selectRadioBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.currentTarget == this._moneyRadioBtn)
         {
            this.updateCurrentShopItem(Price.MONEY);
         }
         this.cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function get currentShopItem() : ShopCarItemInfo
      {
         return _shopItemInfo;
      }
      
      public function get isDelete() : Boolean
      {
         return this._isDelete;
      }
      
      private function updateCurrentShopItem(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._shopItems.length)
         {
            if(this._shopItems[_loc2_].getItemPrice(1).PriceType == param1)
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_loc2_]);
               break;
            }
            _loc2_++;
         }
      }
      
      override protected function __closeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._isDelete = true;
         dispatchEvent(new Event(DELETE_ITEM));
      }
      
      private function fillToShopCarInfo(param1:ShopItemInfo) : ShopCarItemInfo
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ShopCarItemInfo = new ShopCarItemInfo(param1.GoodsID,param1.TemplateID,_cell.info.CategoryID);
         ObjectUtils.copyProperties(_loc2_,param1);
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._shopItems = null;
      }
   }
}
