// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.PetBagListView

package bagAndInfo.bag
{
    import ddt.data.BagInfo;
    import bagAndInfo.cell.BaseCell;
    import ddt.events.BagEvent;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import road7th.data.DictionaryData;

    public class PetBagListView extends BagListView 
    {

        private var _allBagData:BagInfo;

        public function PetBagListView(_arg_1:int, _arg_2:int=8)
        {
            super(_arg_1, _arg_2);
        }

        override public function setData(_arg_1:BagInfo):void
        {
            var _local_3:BaseCell;
            var _local_4:int;
            if (_bagdata == _arg_1)
            {
                return;
            };
            if (_bagdata != null)
            {
                _bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
            };
            _bagdata = _arg_1;
            this._allBagData = _arg_1;
            _bagdata.addEventListener(BagEvent.UPDATE, this.__updateGoods);
            this.sortItems();
            var _local_2:int;
            for each (_local_3 in _cellVec)
            {
                if (_local_2 < 56)
                {
                    addChild(_local_3);
                    if (PlayerManager.Instance.Self.bagCellUpdateIndex != -1)
                    {
                        _local_4 = ((PlayerManager.Instance.Self.bagCellUpdateIndex - 1) - 30);
                    };
                    if (_local_2 <= (_local_4 - 1))
                    {
                        _local_3.filters = ComponentFactory.Instance.creatFilters("lightFilter");
                        _local_3.mouseChildren = true;
                        _local_3.mouseEnabled = true;
                    }
                    else
                    {
                        _local_3.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                        _local_3.mouseChildren = false;
                        _local_3.mouseEnabled = false;
                    };
                };
                _local_2++;
            };
        }

        private function sortItems():void
        {
            var _local_1:Array;
            var _local_3:String;
            var _local_4:InventoryItemInfo;
            _local_1 = new Array();
            var _local_2:int;
            for (_local_3 in _bagdata.items)
            {
                _local_4 = _bagdata.items[_local_3];
                if (((!(_cells[_local_2] == null)) && (_local_4)))
                {
                    if (((_local_4.CategoryID == BagInfo.FOOD) || (_local_4.CategoryID == BagInfo.FOOD_OLD)))
                    {
                        BaseCell(_cells[_local_2]).info = _local_4;
                        _local_1.push(_cells[_local_2]);
                        _local_2++;
                    };
                };
            };
            this._cellsSort(_local_1);
        }

        override protected function __updateGoods(_arg_1:BagEvent):void
        {
            var _local_3:int;
            var _local_4:InventoryItemInfo;
            var _local_5:InventoryItemInfo;
            if ((!(_bagdata)))
            {
                return;
            };
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_4 in _local_2)
            {
                _local_5 = _bagdata.getItemAt(_local_4.Place);
                if (((_local_5) && (_local_5.CategoryID == BagInfo.FOOD)))
                {
                    setCellInfo(_local_3, _local_5);
                    _local_3++;
                }
                else
                {
                    setCellInfo(_local_3, null);
                };
            };
            this.sortItems();
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function updateFoodBagList():void
        {
            var _local_5:InventoryItemInfo;
            var _local_1:BagInfo = new BagInfo(BagInfo.PROPBAG, 56);
            var _local_2:DictionaryData = new DictionaryData();
            var _local_3:int;
            var _local_4:int;
            while (_local_4 < 56)
            {
                _local_5 = this._allBagData.items[_local_4.toString()];
                if (_cells[_local_4] != null)
                {
                    if (((_local_5) && (_local_5.CategoryID == BagInfo.FOOD)))
                    {
                        _local_5.isMoveSpace = false;
                        _cells[_local_3].info = _local_5;
                        _local_2.add(_local_3, _local_5);
                        _local_3++;
                    };
                };
                _local_4++;
            };
            _local_1.items = _local_2;
            _bagdata = _local_1;
        }

        private function getItemIndex(_arg_1:InventoryItemInfo):int
        {
            var _local_3:String;
            var _local_4:InventoryItemInfo;
            var _local_2:int = -1;
            for (_local_3 in _bagdata.items)
            {
                _local_4 = (_bagdata.items[_local_3] as InventoryItemInfo);
                if (_arg_1.Place == _local_4.Place)
                {
                    _local_2 = int(_local_3);
                    break;
                };
            };
            return (_local_2);
        }

        private function _cellsSort(_arg_1:Array):void
        {
            var _local_2:int;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:BaseCell;
            if (_arg_1.length <= 0)
            {
                return;
            };
            _local_2 = 0;
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
            this._allBagData = null;
        }


    }
}//package bagAndInfo.bag

