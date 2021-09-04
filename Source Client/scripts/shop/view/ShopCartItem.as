package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class ShopCartItem extends Sprite implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
       
      
      protected var _bg:Scale9CornerImage;
      
      protected var _itemCellBg:Scale9CornerImage;
      
      protected var _verticalLine:ScaleBitmapImage;
      
      protected var _cartItemGroup:SelectedButtonGroup;
      
      protected var _cartItemSelectVBox:VBox;
      
      protected var _closeBtn:BaseButton;
      
      protected var _itemName:FilterFrameText;
      
      protected var _cell:ShopPlayerCell;
      
      protected var _shopItemInfo:ShopCarItemInfo;
      
      protected var _blueTF:TextFormat;
      
      protected var _yellowTF:TextFormat;
      
      private var _items:Vector.<SelectedCheckButton>;
      
      public function ShopCartItem()
      {
         super();
         this.drawBackground();
         this.drawNameField();
         this.drawCellField();
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemCloseBtn");
         this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemSelectVBox");
         this._cartItemGroup = new SelectedButtonGroup();
         addChild(this._closeBtn);
         addChild(this._cartItemSelectVBox);
         this.initListener();
      }
      
      public function get closeBtn() : BaseButton
      {
         return this._closeBtn;
      }
      
      protected function drawBackground() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
         this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemCellBg");
         this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
         addChild(this._bg);
         addChild(this._verticalLine);
         addChild(this._itemCellBg);
      }
      
      protected function drawNameField() : void
      {
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemName");
         addChild(this._itemName);
      }
      
      protected function drawCellField() : void
      {
         this._cell = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
         PositionUtils.setPos(this._cell,"ddtshop.CartItemCellPoint");
         addChild(this._cell);
      }
      
      protected function initListener() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeClick);
      }
      
      protected function removeEvent() : void
      {
         if(this._cartItemGroup)
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         if(this._closeBtn)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeClick);
         }
      }
      
      protected function __closeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(DELETE_ITEM));
      }
      
      protected function __cartItemGroupChange(param1:Event) : void
      {
         this._shopItemInfo.currentBuyType = this._cartItemGroup.selectIndex + 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function set shopItemInfo(param1:ShopCarItemInfo) : void
      {
         if(this._shopItemInfo != param1)
         {
            this._cell.info = param1.TemplateInfo;
            this._shopItemInfo = param1;
            if(param1 == null)
            {
               this._itemName.text = "";
            }
            else
            {
               this._itemName.text = String(param1.TemplateInfo.Name);
               if(this._itemName.text.length > 6)
               {
                  this._itemName.text = this._itemName.text.substr(0,6) + ".";
               }
               this.cartItemSelectVBoxInit();
            }
         }
      }
      
      protected function cartItemSelectVBoxInit() : void
      {
         var _loc2_:SelectedCheckButton = null;
         var _loc3_:String = null;
         this.clearitem();
         this._cartItemGroup = new SelectedButtonGroup();
         this._cartItemGroup.addEventListener(Event.CHANGE,this.__cartItemGroupChange);
         this._items = new Vector.<SelectedCheckButton>();
         var _loc1_:int = 1;
         while(_loc1_ < 4)
         {
            if(this._shopItemInfo.getItemPrice(_loc1_).IsValid)
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemSelectBtn");
               _loc3_ = this._shopItemInfo.getTimeToString(_loc1_) != LanguageMgr.GetTranslation("ddt.shop.buyTime1") ? this._shopItemInfo.getTimeToString(_loc1_) : LanguageMgr.GetTranslation("ddt.shop.buyTime2");
               _loc2_.text = this._shopItemInfo.getItemPrice(_loc1_).toString() + "/" + _loc3_;
               this._cartItemSelectVBox.addChild(_loc2_);
               _loc2_.addEventListener(MouseEvent.CLICK,this.__soundPlay);
               this._items.push(_loc2_);
               this._cartItemGroup.addSelectItem(_loc2_);
            }
            _loc1_++;
         }
         this._cartItemGroup.selectIndex = this._shopItemInfo.currentBuyType - 1 < 1 ? int(0) : int(this._shopItemInfo.currentBuyType - 1);
         if(this._cartItemSelectVBox.numChildren == 2)
         {
            this._cartItemSelectVBox.y = 18;
         }
         else if(this._cartItemSelectVBox.numChildren == 1)
         {
            this._cartItemSelectVBox.y = 33;
         }
      }
      
      private function clearitem() : void
      {
         var _loc1_:int = 0;
         if(this._cartItemGroup)
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               if(this._items[_loc1_])
               {
                  ObjectUtils.disposeObject(this._items[_loc1_]);
                  this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__soundPlay);
               }
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         if(this._cartItemSelectVBox)
         {
            this._cartItemSelectVBox.disposeAllChildren();
         }
      }
      
      protected function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function get TemplateID() : int
      {
         if(this._cell.info == null)
         {
            return -1;
         }
         return this._cell.info.TemplateID;
      }
      
      public function setColor(param1:*) : void
      {
         this._cell.setColor(param1);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearitem();
         ObjectUtils.disposeAllChildren(this);
         this._cartItemSelectVBox = null;
         this._cartItemGroup = null;
         this._bg = null;
         this._itemCellBg = null;
         this._verticalLine = null;
         this._closeBtn = null;
         this._itemName = null;
         this._cell = null;
         this._shopItemInfo = null;
         this._blueTF = null;
         this._yellowTF = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
