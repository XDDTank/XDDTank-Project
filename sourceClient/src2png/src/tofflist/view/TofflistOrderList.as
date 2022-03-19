// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistOrderList

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import tofflist.TofflistEvent;
    import tofflist.TofflistModel;
    import flash.geom.Point;
    import ddt.data.player.PlayerInfo;
    import __AS3__.vec.*;

    public class TofflistOrderList extends Sprite implements Disposeable 
    {

        private var _currenItem:TofflistOrderItem;
        private var _items:Vector.<TofflistOrderItem>;
        private var _list:VBox;

        public function TofflistOrderList()
        {
            this.init();
            this.addEvent();
        }

        public function dispose():void
        {
            this.clearList();
            this._items = null;
            ObjectUtils.disposeObject(this._currenItem);
            this._currenItem = null;
            ObjectUtils.disposeObject(this._list);
            this._list = null;
        }

        public function items(_arg_1:Array, _arg_2:int=1):void
        {
            var _local_5:TofflistOrderItem;
            var _local_6:TofflistOrderItem;
            this.clearList();
            if (((!(_arg_1)) || (_arg_1.length == 0)))
            {
                return;
            };
            var _local_3:int = ((_arg_1.length > (_arg_2 * 8)) ? (_arg_2 * 8) : _arg_1.length);
            var _local_4:int = ((_arg_2 - 1) * 8);
            while (_local_4 < _local_3)
            {
                _local_5 = ComponentFactory.Instance.creatCustomObject("tofflist.orderItem");
                _local_5.index = (_local_4 + 1);
                _local_5.info = _arg_1[_local_4];
                this._list.addChild(_local_5);
                this._items.push(_local_5);
                _local_5.addEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT, this.__itemChange);
                _local_4++;
            };
            if ((this._list.getChildAt(0) is TofflistOrderItem))
            {
                _local_6 = (this._list.getChildAt(0) as TofflistOrderItem);
                _local_6.isSelect = true;
            }
            else
            {
                TofflistModel.currentText = "";
                TofflistModel.currentIndex = 0;
                TofflistModel.currentPlayerInfo = null;
            };
        }

        public function showHline(_arg_1:Vector.<Point>):void
        {
            var _local_2:TofflistOrderItem;
            for each (_local_2 in this._items)
            {
                _local_2.showHLine(_arg_1);
            };
        }

        private function __itemChange(_arg_1:TofflistEvent):void
        {
            if (this._currenItem)
            {
                this._currenItem.isSelect = false;
            };
            this._currenItem = (_arg_1.data as TofflistOrderItem);
            TofflistModel.currentConsortiaInfo = this._currenItem.consortiaInfo;
            TofflistModel.currentText = this._currenItem.currentText;
            TofflistModel.currentIndex = this._currenItem.index;
            TofflistModel.currentPlayerInfo = (this._currenItem.info as PlayerInfo);
        }

        private function addEvent():void
        {
        }

        public function clearList():void
        {
            var _local_2:TofflistOrderItem;
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                _local_2 = (this._items[_local_1] as TofflistOrderItem);
                _local_2.removeEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT, this.__itemChange);
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
                _local_1++;
            };
            this._items = new Vector.<TofflistOrderItem>();
            this._currenItem = null;
            TofflistModel.currentText = "";
            TofflistModel.currentIndex = 0;
            TofflistModel.currentPlayerInfo = null;
        }

        private function init():void
        {
            this._list = ComponentFactory.Instance.creatComponentByStylename("tofflist.orderlist.vboxContainer");
            addChild(this._list);
            this._items = new Vector.<TofflistOrderItem>();
        }


    }
}//package tofflist.view

