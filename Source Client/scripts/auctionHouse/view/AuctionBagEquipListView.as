package auctionHouse.view
{
   import bagAndInfo.bag.BagEquipListView;
   import bagAndInfo.cell.AuctionBagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class AuctionBagEquipListView extends BagEquipListView
   {
       
      
      public function AuctionBagEquipListView(param1:int, param2:int = 31, param3:int = 79)
      {
         super(param1,param2,param3);
      }
      
      override protected function createCells() : void
      {
         var _loc2_:AuctionBagCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = _startIndex;
         while(_loc1_ < _stopIndex)
         {
            _loc2_ = CellFactory.instance.createAuctionBagCell(_loc1_) as AuctionBagCell;
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            _loc2_.addEventListener(InteractiveEvent.MOUSE_DOWN,__mouseDownHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            _cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc3_:* = null;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         _bagdata = param1;
         clearDataCells();
         var _loc2_:Array = new Array();
         for(_loc3_ in _bagdata.items)
         {
            if(_cells[_loc3_] != null && _bagdata.items[_loc3_].IsBinds == false)
            {
               _cells[_loc3_].info = _bagdata.items[_loc3_];
               _loc2_.push(_cells[_loc3_]);
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         this._cellsSort(_loc2_);
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _bagdata.getItemAt(_loc3_.Place);
            if(_loc4_ && _loc4_.IsBinds == false)
            {
               setCellInfo(_loc4_.Place,_loc4_);
            }
            else
            {
               setCellInfo(_loc3_.Place,null);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function _cellsSort(param1:Array) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:AuctionBagCell = null;
         if(param1.length <= 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_].x;
            _loc4_ = param1[_loc2_].y;
            _loc5_ = _cellVec.indexOf(param1[_loc2_]);
            _loc6_ = _cellVec[_loc2_];
            param1[_loc2_].x = _loc6_.x;
            param1[_loc2_].y = _loc6_.y;
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _cellVec[_loc2_] = param1[_loc2_];
            _cellVec[_loc5_] = _loc6_;
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
