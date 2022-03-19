// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ColorChangeBagListView

package changeColor.view
{
    import bagAndInfo.bag.BagListView;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import flash.utils.Dictionary;
    import flash.events.MouseEvent;
    import ddt.events.CellEvent;
    import ddt.events.BagEvent;
    import ddt.data.BagInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.EquipType;
    import bagAndInfo.cell.BagCell;
    import changeColor.ChangeColorCellEvent;

    public class ColorChangeBagListView extends BagListView 
    {

        private var _list:SimpleTileList;
        private var panel:ScrollPanel;

        public function ColorChangeBagListView()
        {
            super(0, 7);
        }

        override protected function createCells():void
        {
            var _local_2:ChangeColorBagCell;
            this.panel = ComponentFactory.Instance.creat("ddtchangeColor.changeColorBagView.BagEquipScrollPanel");
            addChild(this.panel);
            this.panel.hScrollProxy = ScrollPanel.OFF;
            this.panel.vScrollProxy = ScrollPanel.ON;
            this._list = new SimpleTileList(7);
            this._list.vSpace = 5;
            this._list.hSpace = 0;
            this.panel.setView(this._list);
            this.panel.invalidateViewport();
            _cells = new Dictionary();
            var _local_1:int;
            while (_local_1 < 175)
            {
                _local_2 = new ChangeColorBagCell(_local_1);
                _local_2.bagType = _bagType;
                _local_2.addEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_2.addEventListener(CellEvent.LOCK_CHANGED, __cellChanged);
                _cells[_local_2.place] = _local_2;
                this._list.addChild(_local_2);
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
                _bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoodsII);
            };
            _bagdata = _arg_1;
            var _local_2:int;
            for (_local_3 in _bagdata.items)
            {
                _cells[_local_2++].info = _bagdata.items[_local_3];
            };
            _bagdata.addEventListener(BagEvent.UPDATE, this.__updateGoodsII);
        }

        private function __updateGoodsII(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_4 = PlayerManager.Instance.Self.Bag.getItemAt(_local_3.Place);
                if (!((!(_local_4)) || (_local_4.Place <= BagInfo.PERSONAL_EQUIP_COUNT)))
                {
                    if (((((EquipType.isEditable(_local_4)) || (_local_4.CategoryID == EquipType.FACE)) && (_local_4.getRemainDate() > 0)) && (!(_local_4.TemplateID == EquipType.CHANGE_COLOR_SHELL))))
                    {
                        this.updateItem(_local_4);
                    }
                    else
                    {
                        this.removeBagItem(_local_3);
                    };
                };
            };
        }

        public function updateItem(_arg_1:InventoryItemInfo):void
        {
            var _local_2:int;
            while (_local_2 < 175)
            {
                if (((_cells[_local_2].itemInfo) && (_cells[_local_2].itemInfo.Place == _arg_1.Place)))
                {
                    _cells[_local_2].info = _arg_1;
                    return;
                };
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < 175)
            {
                if (_cells[_local_3].itemInfo == null)
                {
                    _cells[_local_3].info = _arg_1;
                    return;
                };
                _local_3++;
            };
        }

        public function removeBagItem(_arg_1:InventoryItemInfo):void
        {
            var _local_2:int;
            while (_local_2 < 175)
            {
                if (((_cells[_local_2].itemInfo) && (_cells[_local_2].itemInfo.Place == _arg_1.Place)))
                {
                    _cells[_local_2].info = null;
                    return;
                };
                _local_2++;
            };
        }

        private function __cellClick(_arg_1:MouseEvent):void
        {
            if ((((_arg_1.currentTarget as BagCell).locked == false) && (!((_arg_1.currentTarget as BagCell).info == null))))
            {
                dispatchEvent(new ChangeColorCellEvent(ChangeColorCellEvent.CLICK, (_arg_1.currentTarget as BagCell), true));
            };
        }

        override public function dispose():void
        {
            var _local_1:String;
            if (_bagdata != null)
            {
                _bagdata.removeEventListener(BagEvent.UPDATE, this.__updateGoodsII);
                _bagdata = null;
            };
            for (_local_1 in _cells)
            {
                _cells[_local_1].removeEventListener(MouseEvent.CLICK, this.__cellClick);
                _cells[_local_1].removeEventListener(CellEvent.LOCK_CHANGED, __cellChanged);
                _cells[_local_1].dispose();
                _cells[_local_1] = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package changeColor.view

