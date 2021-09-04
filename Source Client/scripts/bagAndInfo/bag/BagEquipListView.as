package bagAndInfo.bag
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.LockBagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class BagEquipListView extends BagListView
   {
       
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      private var place:int;
      
      public function BagEquipListView(param1:int, param2:int = 31, param3:int = 79, param4:int = 8)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         super(param1,param4);
      }
      
      override protected function createCells() : void
      {
         var _loc2_:LockBagCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = this._startIndex;
         while(_loc1_ < this._stopIndex)
         {
            _loc2_ = CellFactory.instance.createLockBagCell(_loc1_) as LockBagCell;
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc2_.addEventListener(InteractiveEvent.MOUSE_DOWN,this.__mouseDownHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            _loc1_++;
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as LockBagCell).info != null)
         {
            if(param1.currentTarget.isLighting)
            {
               param1.currentTarget.light = false;
            }
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      protected function __mouseDownHandler(param1:InteractiveEvent) : void
      {
         if(param1.currentTarget)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(param1.currentTarget)
         {
            if(param1.currentTarget.isLighting)
            {
               param1.currentTarget.light = false;
            }
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            dispatchEvent(new Event("unSelectAutoOpenBtn"));
            LeavePageManager.leaveToFillPath();
         }
         else
         {
            dispatchEvent(new Event("unSelectAutoOpenBtn"));
         }
         ObjectUtils.disposeObject(_loc2_);
         _loc2_ = null;
      }
      
      protected function __cellClick(param1:MouseEvent) : void
      {
      }
      
      public function fashionEquipShine() : void
      {
         var _loc1_:LockBagCell = null;
         for each(_loc1_ in _cells)
         {
            if(_loc1_ is LockBagCell)
            {
               if(EquipType.isFashionViewGoods(_loc1_.info) || EquipType.isRingEquipment(_loc1_.info))
               {
                  _loc1_.light = true;
               }
               else
               {
                  _loc1_.locked = true;
               }
            }
         }
      }
      
      public function getCellPosByPlace(param1:int) : Point
      {
         return localToGlobal(new Point(_cells[param1].x,_cells[param1].y));
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param1 >= this._startIndex && param1 < this._stopIndex)
         {
            if(param2 == null)
            {
               _cells[String(param1)].info = null;
               return;
            }
            if(param2.Count == 0)
            {
               _cells[String(param1)].info = null;
            }
            else
            {
               _cells[String(param1)].info = param2;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:LockBagCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc1_.removeEventListener(InteractiveEvent.MOUSE_DOWN,this.__mouseDownHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            _loc1_.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         }
         _cellMouseOverBg = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
