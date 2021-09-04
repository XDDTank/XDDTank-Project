package changeColor.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import changeColor.ChangeColorCellEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ColorChangeBagListView extends BagListView
   {
       
      
      private var _list:SimpleTileList;
      
      private var panel:ScrollPanel;
      
      public function ColorChangeBagListView()
      {
         super(0,7);
      }
      
      override protected function createCells() : void
      {
         var _loc2_:ChangeColorBagCell = null;
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
         var _loc1_:int = 0;
         while(_loc1_ < 175)
         {
            _loc2_ = new ChangeColorBagCell(_loc1_);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            this._list.addChild(_loc2_);
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
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
         }
         _bagdata = param1;
         var _loc2_:int = 0;
         for(_loc3_ in _bagdata.items)
         {
            _cells[_loc2_++].info = _bagdata.items[_loc3_];
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoodsII);
      }
      
      private function __updateGoodsII(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = PlayerManager.Instance.Self.Bag.getItemAt(_loc3_.Place);
            if(!(!_loc4_ || _loc4_.Place <= BagInfo.PERSONAL_EQUIP_COUNT))
            {
               if((EquipType.isEditable(_loc4_) || _loc4_.CategoryID == EquipType.FACE) && _loc4_.getRemainDate() > 0 && _loc4_.TemplateID != EquipType.CHANGE_COLOR_SHELL)
               {
                  this.updateItem(_loc4_);
               }
               else
               {
                  this.removeBagItem(_loc3_);
               }
            }
         }
      }
      
      public function updateItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 175)
         {
            if(_cells[_loc2_].itemInfo && _cells[_loc2_].itemInfo.Place == param1.Place)
            {
               _cells[_loc2_].info = param1;
               return;
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 175)
         {
            if(_cells[_loc3_].itemInfo == null)
            {
               _cells[_loc3_].info = param1;
               return;
            }
            _loc3_++;
         }
      }
      
      public function removeBagItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 175)
         {
            if(_cells[_loc2_].itemInfo && _cells[_loc2_].itemInfo.Place == param1.Place)
            {
               _cells[_loc2_].info = null;
               return;
            }
            _loc2_++;
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         if((param1.currentTarget as BagCell).locked == false && (param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new ChangeColorCellEvent(ChangeColorCellEvent.CLICK,param1.currentTarget as BagCell,true));
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
            _bagdata = null;
         }
         for(_loc1_ in _cells)
         {
            _cells[_loc1_].removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _cells[_loc1_].removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc1_].dispose();
            _cells[_loc1_] = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
