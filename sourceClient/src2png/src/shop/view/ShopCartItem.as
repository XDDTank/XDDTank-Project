// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopCartItem

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.ShopCarItemInfo;
    import flash.text.TextFormat;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.ItemTemplateInfo;
    import __AS3__.vec.*;

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

        public function get closeBtn():BaseButton
        {
            return (this._closeBtn);
        }

        protected function drawBackground():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
            this._itemCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemCellBg");
            this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
            addChild(this._bg);
            addChild(this._verticalLine);
            addChild(this._itemCellBg);
        }

        protected function drawNameField():void
        {
            this._itemName = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemName");
            addChild(this._itemName);
        }

        protected function drawCellField():void
        {
            this._cell = (CellFactory.instance.createShopCartItemCell() as ShopPlayerCell);
            PositionUtils.setPos(this._cell, "ddtshop.CartItemCellPoint");
            addChild(this._cell);
        }

        protected function initListener():void
        {
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__closeClick);
        }

        protected function removeEvent():void
        {
            if (this._cartItemGroup)
            {
                this._cartItemGroup.removeEventListener(Event.CHANGE, this.__cartItemGroupChange);
                this._cartItemGroup = null;
            };
            if (this._closeBtn)
            {
                this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeClick);
            };
        }

        protected function __closeClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(DELETE_ITEM));
        }

        protected function __cartItemGroupChange(_arg_1:Event):void
        {
            this._shopItemInfo.currentBuyType = (this._cartItemGroup.selectIndex + 1);
            dispatchEvent(new Event(CONDITION_CHANGE));
        }

        public function set shopItemInfo(_arg_1:ShopCarItemInfo):void
        {
            if (this._shopItemInfo != _arg_1)
            {
                this._cell.info = _arg_1.TemplateInfo;
                this._shopItemInfo = _arg_1;
                if (_arg_1 == null)
                {
                    this._itemName.text = "";
                }
                else
                {
                    this._itemName.text = String(_arg_1.TemplateInfo.Name);
                    if (this._itemName.text.length > 6)
                    {
                        this._itemName.text = (this._itemName.text.substr(0, 6) + ".");
                    };
                    this.cartItemSelectVBoxInit();
                };
            };
        }

        protected function cartItemSelectVBoxInit():void
        {
            var _local_2:SelectedCheckButton;
            var _local_3:String;
            this.clearitem();
            this._cartItemGroup = new SelectedButtonGroup();
            this._cartItemGroup.addEventListener(Event.CHANGE, this.__cartItemGroupChange);
            this._items = new Vector.<SelectedCheckButton>();
            var _local_1:int = 1;
            while (_local_1 < 4)
            {
                if (!(!(this._shopItemInfo.getItemPrice(_local_1).IsValid)))
                {
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemSelectBtn");
                    _local_3 = ((!(this._shopItemInfo.getTimeToString(_local_1) == LanguageMgr.GetTranslation("ddt.shop.buyTime1"))) ? this._shopItemInfo.getTimeToString(_local_1) : LanguageMgr.GetTranslation("ddt.shop.buyTime2"));
                    _local_2.text = ((this._shopItemInfo.getItemPrice(_local_1).toString() + "/") + _local_3);
                    this._cartItemSelectVBox.addChild(_local_2);
                    _local_2.addEventListener(MouseEvent.CLICK, this.__soundPlay);
                    this._items.push(_local_2);
                    this._cartItemGroup.addSelectItem(_local_2);
                };
                _local_1++;
            };
            this._cartItemGroup.selectIndex = (((this._shopItemInfo.currentBuyType - 1) < 1) ? 0 : (this._shopItemInfo.currentBuyType - 1));
            if (this._cartItemSelectVBox.numChildren == 2)
            {
                this._cartItemSelectVBox.y = 18;
            }
            else
            {
                if (this._cartItemSelectVBox.numChildren == 1)
                {
                    this._cartItemSelectVBox.y = 33;
                };
            };
        }

        private function clearitem():void
        {
            var _local_1:int;
            if (this._cartItemGroup)
            {
                this._cartItemGroup.removeEventListener(Event.CHANGE, this.__cartItemGroupChange);
                this._cartItemGroup = null;
            };
            if (this._items)
            {
                _local_1 = 0;
                while (_local_1 < this._items.length)
                {
                    if (this._items[_local_1])
                    {
                        ObjectUtils.disposeObject(this._items[_local_1]);
                        this._items[_local_1].removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                    };
                    this._items[_local_1] = null;
                    _local_1++;
                };
            };
            if (this._cartItemSelectVBox)
            {
                this._cartItemSelectVBox.disposeAllChildren();
            };
        }

        protected function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        public function get shopItemInfo():ShopCarItemInfo
        {
            return (this._shopItemInfo);
        }

        public function get info():ItemTemplateInfo
        {
            return (this._cell.info);
        }

        public function get TemplateID():int
        {
            if (this._cell.info == null)
            {
                return (-1);
            };
            return (this._cell.info.TemplateID);
        }

        public function setColor(_arg_1:*):void
        {
            this._cell.setColor(_arg_1);
        }

        public function dispose():void
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
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

