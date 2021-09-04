package store.view.resolve
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.SpliteListInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.IStoreViewBG;
   import store.StoreDragInArea;
   
   public class StoreIIResolveBG extends Sprite implements IStoreViewBG
   {
      
      private static var CELL_COUNT:int = 4;
       
      
      private var _area:StoreDragInArea;
      
      private var _bg:Image;
      
      private var _resolveTitle:Bitmap;
      
      private var _resolveBtn:BaseButton;
      
      private var _mainCell:ResolveItemCell;
      
      private var _mainCellPos:Point;
      
      private var _cells:Array;
      
      private var _pointArray:Vector.<Point>;
      
      private var _spliteInfo:SpliteListInfo;
      
      public function StoreIIResolveBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIResolveBG.ResolveBg");
         addChild(this._bg);
         this._resolveTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.FusionTitle");
         addChild(this._resolveTitle);
         this._resolveBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIResolveBG.ResolveBtn");
         addChild(this._resolveBtn);
         this._cells = [];
         this.getCellsPoint();
         this.intItems();
         this._area = new StoreDragInArea(this._cells);
         addChildAt(this._area,0);
         this.hide();
      }
      
      private function intItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BaseCell = null;
         this._mainCell = new ResolveItemCell(0);
         this._mainCellPos = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIResolveBG.ResolveMainpoint");
         PositionUtils.setPos(this._mainCell,this._mainCellPos);
         addChild(this._mainCell);
         _loc1_ = 0;
         while(_loc1_ < CELL_COUNT)
         {
            _loc2_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.ddtstore.materialCellBg"));
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < CELL_COUNT)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIResolveBG.Resolvepoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._resolveBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_SPLITE,this.__spliteResponse);
      }
      
      private function __spliteResponse(param1:CrazyTankSocketEvent) : void
      {
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this._mainCell.info)
         {
            _loc2_ = 2;
            SocketManager.Instance.out.sendItemSplite(this._mainCell.info.TemplateID,_loc2_);
         }
      }
      
      public function setCell(param1:BagCell) : void
      {
         var _loc2_:int = 0;
         var _loc3_:InventoryItemInfo = param1.info as InventoryItemInfo;
         SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,BagInfo.STOREBAG,_loc2_,_loc3_.Count,true);
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:int = int(param1[0]);
         var _loc3_:ItemTemplateInfo = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
         this._spliteInfo = ItemManager.Instance.getSpliteInfoByID(400200);
         if(this._spliteInfo)
         {
            this._mainCell.info = _loc3_;
            this.updateData();
         }
         else
         {
            MessageTipManager.getInstance().show("此物品不能分解！");
            this.updateData();
         }
      }
      
      public function updateData() : void
      {
         this.clearCellsInfo();
         if(this._mainCell.info && this._spliteInfo)
         {
            if(this._spliteInfo.Material1ID != 0)
            {
               this._cells[0].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material1ID);
            }
            if(this._spliteInfo.Material2ID != 0)
            {
               this._cells[1].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material2ID);
            }
            if(this._spliteInfo.Material3ID != 0)
            {
               this._cells[2].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material3ID);
            }
            if(this._spliteInfo.Material4ID != 0)
            {
               this._cells[3].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material4ID);
            }
         }
      }
      
      private function clearCellsInfo() : void
      {
         var _loc1_:BaseCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = null;
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function removeView() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._resolveTitle)
         {
            ObjectUtils.disposeObject(this._resolveTitle);
         }
         this._resolveTitle = null;
         if(this._resolveBtn)
         {
            ObjectUtils.disposeObject(this._resolveBtn);
         }
         this._resolveBtn = null;
         if(this._area)
         {
            this._area.dispose();
         }
         this._area = null;
      }
      
      private function removeEvent() : void
      {
         this._resolveBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_SPLITE,this.__spliteResponse);
      }
      
      public function dispose() : void
      {
         this._pointArray = null;
         this.removeEvent();
      }
      
      public function openHelp() : void
      {
      }
   }
}
