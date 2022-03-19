// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionBagEquipListView

package auctionHouse.view
{
    import bagAndInfo.bag.BagEquipListView;
    import bagAndInfo.cell.AuctionBagCell;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.events.CellEvent;
    import ddt.events.BagEvent;
    import ddt.data.BagInfo;
    import ddt.data.goods.InventoryItemInfo;
    import flash.events.Event;

    public class AuctionBagEquipListView extends BagEquipListView 
    {

        public function AuctionBagEquipListView(_arg_1:int, _arg_2:int=31, _arg_3:int=79)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override protected function createCells():void
        {
            var _local_2:AuctionBagCell;
            _cells = new Dictionary();
            _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            var _local_1:int = _startIndex;
            while (_local_1 < _stopIndex)
            {
                _local_2 = (CellFactory.instance.createAuctionBagCell(_local_1) as AuctionBagCell);
                _local_2.mouseOverEffBoolean = false;
                addChild(_local_2);
                _local_2.addEventListener(InteractiveEvent.CLICK, __clickHandler);
                _local_2.addEventListener(InteractiveEvent.DOUBLE_CLICK, __doubleClickHandler);
                _local_2.addEventListener(InteractiveEvent.MOUSE_DOWN, __mouseDownHandler);
                DoubleClickManager.Instance.enableDoubleClick(_local_2);
                _local_2.bagType = _bagType;
                _local_2.addEventListener(CellEvent.LOCK_CHANGED, __cellChanged);
                _cells[_local_2.place] = _local_2;
                _cellVec.push(_local_2);
                _local_1++;
            };
        }

        override public function setData(_arg_1:BagInfo):void
        {
            var _local_3:String;
            if (_bagdata == _arg_1)
            {
                return;
            };
            if (_bagdata != null)
            {
                _bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
            };
            _bagdata = _arg_1;
            clearDataCells();
            var _local_2:Array = new Array();
            for (_local_3 in _bagdata.items)
            {
                if (((!(_cells[_local_3] == null)) && (_bagdata.items[_local_3].IsBinds == false)))
                {
                    _cells[_local_3].info = _bagdata.items[_local_3];
                    _local_2.push(_cells[_local_3]);
                };
            };
            _bagdata.addEventListener(BagEvent.UPDATE, this.__updateGoods);
            this._cellsSort(_local_2);
        }

        override protected function __updateGoods(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_4 = _bagdata.getItemAt(_local_3.Place);
                if (((_local_4) && (_local_4.IsBinds == false)))
                {
                    setCellInfo(_local_4.Place, _local_4);
                }
                else
                {
                    setCellInfo(_local_3.Place, null);
                };
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        private function _cellsSort(_arg_1:Array):void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:AuctionBagCell;
            if (_arg_1.length <= 0)
            {
                return;
            };
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = _arg_1[_local_2].x;
                _local_4 = _arg_1[_local_2].y;
                _local_5 = _cellVec.indexOf(_arg_1[_local_2]);
                _local_6 = _cellVec[_local_2];
                _arg_1[_local_2].x = _local_6.x;
                _arg_1[_local_2].y = _local_6.y;
                _local_6.x = _local_3;
                _local_6.y = _local_4;
                _cellVec[_local_2] = _arg_1[_local_2];
                _cellVec[_local_5] = _local_6;
                _local_2++;
            };
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package auctionHouse.view

