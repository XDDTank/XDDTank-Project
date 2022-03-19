// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionBagView

package auctionHouse.view
{
    import bagAndInfo.bag.BagView;
    import ddt.data.BagInfo;
    import ddt.data.goods.InventoryItemInfo;
    import flash.utils.Dictionary;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import bagAndInfo.cell.BaseCell;
    import ddt.manager.SoundManager;
    import ddt.events.CellEvent;

    public class AuctionBagView extends BagView 
    {

        private var _unbindBag:BagInfo;

        public function AuctionBagView()
        {
            removeChild(_settingLockBtn);
        }

        override protected function initBagList():void
        {
            _equiplist = new AuctionBagEquipListView(0);
            _equiplist1 = new AuctionBagEquipListView(0, 79, 127);
            _equiplist2 = new AuctionBagEquipListView(0, 127, 175);
            _equiplist.x = (_equiplist1.x = (_equiplist2.x = 12));
            _equiplist.y = (_equiplist1.y = (_equiplist2.y = 50));
            _equiplist.width = (_equiplist1.width = (_equiplist2.width = 330));
            _equiplist.height = (_equiplist1.height = (_equiplist2.width = 320));
            _equiplist1.visible = (_equiplist2.visible = false);
            _currentList = _equiplist;
            addChild(_equiplist);
            addChild(_equiplist1);
            addChild(_equiplist2);
        }

        override protected function updateBagList():void
        {
            if (_info)
            {
                this.currentPage = _currentPage;
            }
            else
            {
                _equiplist.setData(null);
            };
        }

        override protected function __updateGoods(_arg_1:BagEvent):void
        {
            var _local_3:Object;
            var _local_4:int;
            var _local_5:InventoryItemInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for (_local_3 in _local_2)
            {
                _local_4 = this.findItemPlaceByPlace(int(_local_3));
                if (this._unbindBag.items[_local_4])
                {
                    _local_5 = PlayerManager.Instance.Self.Bag.items[_local_3];
                    _equiplist.setCellInfo(_local_4, _local_5);
                    if (_equiplist1)
                    {
                        _equiplist1.setCellInfo(_local_4, _local_5);
                    };
                    if (_equiplist2)
                    {
                        _equiplist2.setCellInfo(_local_4, _local_5);
                    };
                };
            };
        }

        private function findItemPlaceByPlace(_arg_1:int):int
        {
            var _local_2:Object;
            for (_local_2 in this._unbindBag.items)
            {
                if (this._unbindBag.items[_local_2].Place == _arg_1)
                {
                    return (int(_local_2));
                };
            };
            return (-1);
        }

        private function getUnbindList(_arg_1:BagInfo):BagInfo
        {
            var _local_4:InventoryItemInfo;
            var _local_2:BagInfo = new BagInfo(BagInfo.UNBIND, BagInfo.MAXPROPCOUNT);
            var _local_3:int = 30;
            for each (_local_4 in _arg_1.items)
            {
                if (!_local_4.IsBinds)
                {
                    var _local_7:* = ++_local_3;
                    _local_2.items[_local_7] = _local_4;
                };
            };
            return (_local_2);
        }

        override protected function set_breakBtn_enable():void
        {
            if (_breakBtn)
            {
                _breakBtn.enable = false;
                _breakBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_sellBtn)
            {
                _sellBtn.enable = false;
                _sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_sortBagBtn)
            {
                _sortBagBtn.enable = false;
                _sortBagBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_continueBtn)
            {
                _continueBtn.enable = false;
                _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_allClassBtn)
            {
                _allClassBtn.enable = false;
                _allClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_equipClassBtn)
            {
                _equipClassBtn.enable = false;
                _equipClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_fashionClassBtn)
            {
                _fashionClassBtn.enable = false;
                _fashionClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_propClassBtn)
            {
                _propClassBtn.enable = false;
                _propClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            if (_questClassBtn)
            {
                _questClassBtn.enable = false;
                _questClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        override protected function adjustEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP, __openPreviewListFrame);
        }

        override protected function __cellOpen(_arg_1:Event):void
        {
        }

        override protected function __cellEquipClick(_arg_1:CellEvent):void
        {
            var _local_2:BaseCell;
            var _local_3:InventoryItemInfo;
            if ((!(_sellBtn.isActive)))
            {
                _arg_1.stopImmediatePropagation();
                _local_2 = (_arg_1.data as BaseCell);
                if (_local_2)
                {
                    _local_3 = (_local_2.info as InventoryItemInfo);
                };
                if (_local_3 == null)
                {
                    return;
                };
                if ((!(_local_2.locked)))
                {
                    SoundManager.instance.play("008");
                    _local_2.dragStart();
                };
            };
        }

        override public function set currentPage(_arg_1:int):void
        {
            _currentPage = _arg_1;
            this._unbindBag = this.getUnbindList(_info.Bag);
            switch (_currentPage)
            {
                case 1:
                    _equiplist.setData(this._unbindBag);
                    return;
                case 2:
                    _equiplist1.setData(this._unbindBag);
                    return;
                case 3:
                    _equiplist2.setData(this._unbindBag);
                    return;
            };
        }

        override public function setBagType(_arg_1:int):void
        {
            super.setBagType(_arg_1);
            _sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (_settedLockBtn)
            {
                _settedLockBtn.visible = false;
            };
            if (_settingLockBtn)
            {
                _settingLockBtn.visible = false;
            };
        }


    }
}//package auctionHouse.view

