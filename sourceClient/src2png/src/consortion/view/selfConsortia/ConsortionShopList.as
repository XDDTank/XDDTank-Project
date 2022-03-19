// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionShopList

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;

    public class ConsortionShopList extends Sprite implements Disposeable 
    {

        private var _shopId:int;
        private var _items:Array;
        private var _list:VBox;
        private var _panel:ScrollPanel;

        public function ConsortionShopList()
        {
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._items = new Array();
            this._list = ComponentFactory.Instance.creat("consortion.shop.list");
            this._panel = ComponentFactory.Instance.creat("consortion.shop.panel");
            this._panel.setView(this._list);
            addChild(this._panel);
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._panel = null;
            this._list = null;
            this._items = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function list(_arg_1:Vector.<ShopItemInfo>, _arg_2:int, _arg_3:int, _arg_4:Boolean=false):void
        {
            var _local_6:ConsortionShopItem;
            var _local_7:int;
            var _local_8:int;
            var _local_9:ConsortionShopItem;
            this._shopId = (_arg_2 + 10);
            var _local_5:int;
            while (_local_5 < _arg_1.length)
            {
                _local_6 = new ConsortionShopItem();
                this._list.addChild(_local_6);
                _local_6.shopItemInfo = _arg_1[_local_5];
                this._items.push(_local_6);
                _local_5++;
            };
            if (_arg_1.length < 6)
            {
                _local_7 = (6 - _arg_1.length);
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    _local_9 = new ConsortionShopItem();
                    this._list.addChild(_local_9);
                    this._items.push(_local_9);
                    _local_8++;
                };
            };
        }

        private function clearList():void
        {
            var _local_1:int;
            if (((this._items) && (this._list)))
            {
                _local_1 = 0;
                while (_local_1 < this._items.length)
                {
                    this._items[_local_1].dispose();
                    _local_1++;
                };
                this._list.disposeAllChildren();
            };
            this._items = new Array();
        }


    }
}//package consortion.view.selfConsortia

