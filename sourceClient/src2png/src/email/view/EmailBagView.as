// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmailBagView

package email.view
{
    import bagAndInfo.bag.BagView;
    import auctionHouse.view.AuctionBagEquipListView;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import bagAndInfo.cell.BagCell;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SoundManager;
    import ddt.events.CellEvent;

    public class EmailBagView extends BagView 
    {


        override protected function initBagList():void
        {
            _equiplist = new AuctionBagEquipListView(0);
            _equiplist1 = new AuctionBagEquipListView(0, 79, 127);
            _equiplist2 = new AuctionBagEquipListView(0, 127, 175);
            _equiplist.x = (_equiplist1.x = (_equiplist1.x = 14));
            _equiplist.y = (_equiplist1.y = (_equiplist1.y = 54));
            _equiplist.width = (_equiplist1.width = (_equiplist2.width = 330));
            _equiplist.height = (_equiplist1.height = (_equiplist2.width = 320));
            _equiplist1.visible = (_equiplist2.visible = false);
            _currentList = _equiplist;
            addChild(_equiplist);
            addChild(_equiplist1);
            addChild(_equiplist2);
        }

        override protected function adjustEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP, __openPreviewListFrame);
        }

        override protected function __cellClick(_arg_1:CellEvent):void
        {
            var _local_2:BagCell;
            var _local_3:InventoryItemInfo;
            if ((!(_sellBtn.isActive)))
            {
                _arg_1.stopImmediatePropagation();
                _local_2 = (_arg_1.data as BagCell);
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

        override public function setBagType(_arg_1:int):void
        {
            super.setBagType(_arg_1);
            if (((_arg_1 == BagView.EQUIP) || (_arg_1 == BagView.PROP)))
            {
                super.switchbagViewBtn = false;
            };
        }


    }
}//package email.view

