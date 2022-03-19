// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopPlayerCell

package shop.view
{
    import bagAndInfo.cell.BaseCell;
    import ddt.data.goods.ShopCarItemInfo;
    import com.pickgliss.ui.image.MovieImage;
    import flash.display.DisplayObject;
    import shop.ShopEvent;
    import ddt.data.EquipType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopPlayerCell extends BaseCell 
    {

        private var _shopItemInfo:ShopCarItemInfo;
        private var _light:MovieImage;

        public function ShopPlayerCell(_arg_1:DisplayObject)
        {
            super(_arg_1);
        }

        public function set shopItemInfo(_arg_1:ShopCarItemInfo):void
        {
            if (_arg_1 == null)
            {
                super.info = null;
            }
            else
            {
                super.info = _arg_1.TemplateInfo;
            };
            this._shopItemInfo = _arg_1;
            locked = false;
            if ((_arg_1 is ShopCarItemInfo))
            {
                setColor(ShopCarItemInfo(_arg_1).Color);
            };
            dispatchEvent(new ShopEvent(ShopEvent.ITEMINFO_CHANGE, null, null));
        }

        public function get shopItemInfo():ShopCarItemInfo
        {
            return (this._shopItemInfo);
        }

        public function setSkinColor(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:String;
            if (((this.shopItemInfo) && (EquipType.hasSkin(this.shopItemInfo.CategoryID))))
            {
                _local_2 = this.shopItemInfo.Color.split("|");
                _local_3 = "";
                if (_local_2.length > 2)
                {
                    _local_3 = ((((_local_2[0] + "|") + _arg_1) + "|") + _local_2[2]);
                }
                else
                {
                    _local_3 = ((((_local_2[0] + "|") + _arg_1) + "|") + _local_2[1]);
                };
                this.shopItemInfo.Color = _local_3;
                setColor(_local_3);
            };
        }

        override protected function createChildren():void
        {
            super.createChildren();
            if (this._light == null)
            {
                this._light = ComponentFactory.Instance.creatComponentByStylename("ddtshop.shopPlayerCell.RightItemLightMc");
            };
            addChild(this._light);
            this._light.visible = (this._light.mouseChildren = (this._light.mouseEnabled = false));
        }

        public function showLight():void
        {
            this._light.visible = true;
        }

        public function hideLight():void
        {
            this._light.visible = false;
        }

        override public function dispose():void
        {
            if (locked)
            {
                if (((!(_info == null)) && (_info is InventoryItemInfo)))
                {
                    PlayerManager.Instance.Self.Bag.unlockItem((_info as InventoryItemInfo));
                };
                locked = false;
            };
            this._shopItemInfo = null;
            if (this._light)
            {
                ObjectUtils.disposeObject(this._light);
            };
            this._light = null;
            super.dispose();
        }


    }
}//package shop.view

