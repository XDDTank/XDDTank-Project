// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopItemCell

package shop.view
{
    import bagAndInfo.cell.BaseCell;
    import ddt.data.goods.ShopCarItemInfo;
    import flash.display.DisplayObject;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.utils.PositionUtils;
    import flash.display.Sprite;
    import ddt.data.goods.ShopItemInfo;

    public class ShopItemCell extends BaseCell 
    {

        private var _shopItemInfo:ShopCarItemInfo;
        protected var _cellSize:uint = 60;

        public function ShopItemCell(_arg_1:DisplayObject, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Boolean=true)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function get shopItemInfo():ShopCarItemInfo
        {
            return (this._shopItemInfo);
        }

        public function set shopItemInfo(_arg_1:ShopCarItemInfo):void
        {
            this._shopItemInfo = _arg_1;
        }

        public function set cellSize(_arg_1:uint):void
        {
            this._cellSize = _arg_1;
            this.updateSize(_pic);
        }

        override protected function updateSize(_arg_1:Sprite):void
        {
            var _local_2:Number;
            PositionUtils.setPos(_arg_1, "ddtshop.ItemCellStartPos");
            if (((((_arg_1.height >= this._cellSize) && (this._cellSize >= _arg_1.width)) || ((_arg_1.height >= _arg_1.width) && (_arg_1.width >= this._cellSize))) || ((this._cellSize >= _arg_1.height) && (_arg_1.height >= _arg_1.width))))
            {
                _local_2 = (_arg_1.height / this._cellSize);
            }
            else
            {
                _local_2 = (_arg_1.width / this._cellSize);
            };
            _arg_1.height = (_arg_1.height / _local_2);
            _arg_1.width = (_arg_1.width / _local_2);
            _arg_1.x = (_arg_1.x + ((this._cellSize - _arg_1.width) / 2));
            _arg_1.y = (_arg_1.y + ((this._cellSize - _arg_1.height) / 2));
        }

        override protected function updateSizeII(_arg_1:Sprite):void
        {
            _arg_1.width = (_arg_1.height = 70);
            PositionUtils.setPos(_arg_1, "ddtshop.ItemCellStartPos");
        }

        override protected function createLoading():void
        {
            super.createLoading();
            this.updateSize(_loadingasset);
        }

        public function set tipInfo(_arg_1:ShopItemInfo):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            tipData = _arg_1;
        }

        override public function dispose():void
        {
            this._shopItemInfo = null;
            super.dispose();
        }


    }
}//package shop.view

