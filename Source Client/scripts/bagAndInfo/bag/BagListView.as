package bagAndInfo.bag
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.LockBagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BagListView extends SimpleTileList
   {
       
      
      private var _allBagData:BagInfo;
      
      protected var _bagdata:BagInfo;
      
      protected var _bagType:int;
      
      protected var _cells:Dictionary;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellVec:Array;
      
      private var _isSetFoodData:Boolean;
      
      public function BagListView(param1:int, param2:int = 8)
      {
         this._bagType = param1;
         super(param2);
         _hSpace = 1;
         _vSpace = 5;
         this._cellVec = new Array();
         this.createCells();
      }
      
      protected function createCells() : void
      {
         var _loc2_:LockBagCell = null;
         this._cells = new Dictionary();
         this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = 31;
         while(_loc1_ < 87)
         {
            _loc2_ = LockBagCell(CellFactory.instance.createLockBagCell(_loc1_));
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.bagType = this._bagType;
            _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            this._cells[_loc2_.place] = _loc2_;
            this._cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as LockBagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      protected function __cellChanged(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as LockBagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      public function _cellOverEff(param1:MouseEvent) : void
      {
         LockBagCell(param1.currentTarget).onParentMouseOver(this._cellMouseOverBg);
      }
      
      public function _cellOutEff(param1:MouseEvent) : void
      {
         LockBagCell(param1.currentTarget).onParentMouseOut();
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param2 == null)
         {
            if(this._cells[String(param1)])
            {
               this._cells[String(param1)].info = null;
            }
            return;
         }
         if(param2.Count == 0)
         {
            this._cells[String(param1)].info = null;
         }
         else
         {
            this._cells[String(param1)].info = param2;
         }
      }
      
      protected function clearDataCells() : void
      {
         var _loc1_:LockBagCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = null;
         }
      }
      
      public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:EquipmentTemplateInfo = null;
         this._isSetFoodData = false;
         if(this._bagdata == param1 && SavePointManager.Instance.savePoints[64])
         {
            return;
         }
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         this.clearDataCells();
         this._bagdata = param1;
         for(_loc2_ in this._bagdata.items)
         {
            if(this._cells[_loc2_] != null)
            {
               this._bagdata.items[_loc2_].isMoveSpace = true;
               this._cells[_loc2_].info = this._bagdata.items[_loc2_];
               if(SavePointManager.Instance.isInSavePoint(33))
               {
                  if(int(_loc2_) > BagInfo.PERSONAL_EQUIP_COUNT)
                  {
                     if(this._cells[_loc2_].info.CategoryID == EquipType.EQUIP)
                     {
                        _loc3_ = ItemManager.Instance.getEquipTemplateById(this._cells[_loc2_].info.TemplateID);
                        if(this._cells[_loc2_] is LockBagCell)
                        {
                           if(_loc3_.TemplateType == 5)
                           {
                              this._cells[_loc2_].light = true;
                           }
                           else
                           {
                              this._cells[_loc2_].locked = true;
                           }
                        }
                        NewHandContainer.Instance.showArrow(ArrowType.CLICK_TO_EQUIP,135,"trainer.ClickToEquipArrowPos","asset.trainer.clickToEquip","trainer.ClickToEquipTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                     }
                     else if(this._cells[_loc2_] is LockBagCell)
                     {
                        this._cells[_loc2_].locked = true;
                     }
                  }
               }
            }
         }
         this._bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      protected function __updateFoodGoods(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:* = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc8_:InventoryItemInfo = null;
         if(!this._bagdata)
         {
            return;
         }
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = -1;
            _loc5_ = null;
            for(_loc6_ in this._bagdata.items)
            {
               _loc7_ = this._bagdata.items[_loc6_] as InventoryItemInfo;
               if(_loc3_.ItemID == _loc7_.ItemID)
               {
                  _loc5_ = _loc3_;
                  _loc4_ = int(_loc6_);
                  break;
               }
            }
            if(_loc4_ != -1)
            {
               _loc8_ = this._bagdata.getItemAt(_loc4_);
               if(_loc8_)
               {
                  _loc8_.Count = _loc5_.Count;
                  if(this._cells[String(_loc4_)].info)
                  {
                     this.setCellInfo(_loc4_,null);
                  }
                  else
                  {
                     this.setCellInfo(_loc4_,_loc8_);
                  }
               }
               else
               {
                  this.setCellInfo(_loc4_,null);
               }
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         if(this._isSetFoodData)
         {
            this.__updateFoodGoods(param1);
         }
         else
         {
            _loc2_ = param1.changedSlots;
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = this._bagdata.getItemAt(_loc3_.Place);
               if(_loc4_)
               {
                  this.setCellInfo(_loc4_.Place,_loc4_);
               }
               else
               {
                  this.setCellInfo(_loc3_.Place,null);
               }
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      public function unlockAllCells() : void
      {
         var _loc1_:LockBagCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.locked = false;
            if(_loc1_.isLighting)
            {
               _loc1_.light = false;
            }
         }
      }
      
      public function weaponShowLight() : void
      {
         var _loc1_:* = null;
         var _loc2_:EquipmentTemplateInfo = null;
         for(_loc1_ in this._bagdata.items)
         {
            if(int(_loc1_) > BagInfo.PERSONAL_EQUIP_COUNT)
            {
               if(this._cells[_loc1_] != null)
               {
                  if(this._cells[_loc1_].info.CategoryID == EquipType.EQUIP)
                  {
                     _loc2_ = ItemManager.Instance.getEquipTemplateById(this._cells[_loc1_].info.TemplateID);
                     if(this._cells[_loc1_] is LockBagCell)
                     {
                        if(_loc2_.TemplateType == 5)
                        {
                           this._cells[_loc1_].light = true;
                        }
                        else
                        {
                           this._cells[_loc1_].locked = true;
                        }
                     }
                  }
                  else if(this._cells[_loc1_] is LockBagCell)
                  {
                     this._cells[_loc1_].locked = true;
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:LockBagCell = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
            this._bagdata = null;
         }
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.removeEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            _loc1_.dispose();
         }
         this._cells = null;
         this._cellVec = null;
         if(this._cellMouseOverBg)
         {
            if(this._cellMouseOverBg.parent)
            {
               this._cellMouseOverBg.parent.removeChild(this._cellMouseOverBg);
            }
            this._cellMouseOverBg.bitmapData.dispose();
         }
         this._cellMouseOverBg = null;
         super.dispose();
      }
   }
}
