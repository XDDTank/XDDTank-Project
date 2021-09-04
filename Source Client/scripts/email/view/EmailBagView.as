package email.view
{
   import auctionHouse.view.AuctionBagEquipListView;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   
   public class EmailBagView extends BagView
   {
       
      
      public function EmailBagView()
      {
         super();
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0);
         _equiplist1 = new AuctionBagEquipListView(0,79,127);
         _equiplist2 = new AuctionBagEquipListView(0,127,175);
         _equiplist.x = _equiplist1.x = _equiplist1.x = 14;
         _equiplist.y = _equiplist1.y = _equiplist1.y = 54;
         _equiplist.width = _equiplist1.width = _equiplist2.width = 330;
         _equiplist.height = _equiplist1.height = _equiplist2.width = 320;
         _equiplist1.visible = _equiplist2.visible = false;
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_equiplist1);
         addChild(_equiplist2);
      }
      
      override protected function adjustEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP,__openPreviewListFrame);
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(_loc2_)
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               _loc2_.dragStart();
            }
         }
      }
      
      override public function setBagType(param1:int) : void
      {
         super.setBagType(param1);
         if(param1 == BagView.EQUIP || param1 == BagView.PROP)
         {
            super.switchbagViewBtn = false;
         }
      }
   }
}
