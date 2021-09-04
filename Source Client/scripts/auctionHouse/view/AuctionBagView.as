package auctionHouse.view
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class AuctionBagView extends BagView
   {
       
      
      private var _unbindBag:BagInfo;
      
      public function AuctionBagView()
      {
         super();
         removeChild(_settingLockBtn);
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0);
         _equiplist1 = new AuctionBagEquipListView(0,79,127);
         _equiplist2 = new AuctionBagEquipListView(0,127,175);
         _equiplist.x = _equiplist1.x = _equiplist2.x = 12;
         _equiplist.y = _equiplist1.y = _equiplist2.y = 50;
         _equiplist.width = _equiplist1.width = _equiplist2.width = 330;
         _equiplist.height = _equiplist1.height = _equiplist2.width = 320;
         _equiplist1.visible = _equiplist2.visible = false;
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_equiplist1);
         addChild(_equiplist2);
      }
      
      override protected function updateBagList() : void
      {
         if(_info)
         {
            this.currentPage = _currentPage;
         }
         else
         {
            _equiplist.setData(null);
         }
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = this.findItemPlaceByPlace(int(_loc3_));
            if(this._unbindBag.items[_loc4_])
            {
               _loc5_ = PlayerManager.Instance.Self.Bag.items[_loc3_];
               _equiplist.setCellInfo(_loc4_,_loc5_);
               if(_equiplist1)
               {
                  _equiplist1.setCellInfo(_loc4_,_loc5_);
               }
               if(_equiplist2)
               {
                  _equiplist2.setCellInfo(_loc4_,_loc5_);
               }
            }
         }
      }
      
      private function findItemPlaceByPlace(param1:int) : int
      {
         var _loc2_:* = null;
         for(_loc2_ in this._unbindBag.items)
         {
            if(this._unbindBag.items[_loc2_].Place == param1)
            {
               return int(_loc2_);
            }
         }
         return -1;
      }
      
      private function getUnbindList(param1:BagInfo) : BagInfo
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:BagInfo = new BagInfo(BagInfo.UNBIND,BagInfo.MAXPROPCOUNT);
         var _loc3_:int = 30;
         for each(_loc4_ in param1.items)
         {
            if(!_loc4_.IsBinds)
            {
               var _loc7_:* = ++_loc3_;
               _loc2_.items[_loc7_] = _loc4_;
            }
         }
         return _loc2_;
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(_breakBtn)
         {
            _breakBtn.enable = false;
            _breakBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_sellBtn)
         {
            _sellBtn.enable = false;
            _sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_sortBagBtn)
         {
            _sortBagBtn.enable = false;
            _sortBagBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_continueBtn)
         {
            _continueBtn.enable = false;
            _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_allClassBtn)
         {
            _allClassBtn.enable = false;
            _allClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_equipClassBtn)
         {
            _equipClassBtn.enable = false;
            _equipClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_fashionClassBtn)
         {
            _fashionClassBtn.enable = false;
            _fashionClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_propClassBtn)
         {
            _propClassBtn.enable = false;
            _propClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(_questClassBtn)
         {
            _questClassBtn.enable = false;
            _questClassBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      override protected function adjustEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP,__openPreviewListFrame);
      }
      
      override protected function __cellOpen(param1:Event) : void
      {
      }
      
      override protected function __cellEquipClick(param1:CellEvent) : void
      {
         var _loc2_:BaseCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BaseCell;
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
      
      override public function set currentPage(param1:int) : void
      {
         _currentPage = param1;
         this._unbindBag = this.getUnbindList(_info.Bag);
         switch(_currentPage)
         {
            case 1:
               _equiplist.setData(this._unbindBag);
               break;
            case 2:
               _equiplist1.setData(this._unbindBag);
               break;
            case 3:
               _equiplist2.setData(this._unbindBag);
         }
      }
      
      override public function setBagType(param1:int) : void
      {
         super.setBagType(param1);
         _sellBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         _continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(_settedLockBtn)
         {
            _settedLockBtn.visible = false;
         }
         if(_settingLockBtn)
         {
            _settingLockBtn.visible = false;
         }
      }
   }
}
