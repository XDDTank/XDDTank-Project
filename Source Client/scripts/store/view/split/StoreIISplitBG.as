package store.view.split
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.SpliteListInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
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
   
   public class StoreIISplitBG extends Sprite implements IStoreViewBG
   {
      
      private static var CELL_COUNT:int = 4;
       
      
      private var _area:StoreDragInArea;
      
      private var _bg:Image;
      
      private var _splitTitle:Bitmap;
      
      private var _splitBtn:BaseButton;
      
      private var _neededGoldTipText:FilterFrameText;
      
      private var _gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _mainCell:SplitItemCell;
      
      private var _mainCellPos:Point;
      
      private var _cells:Array;
      
      private var _mainCellArray:Array;
      
      private var _pointArray:Vector.<Point>;
      
      private var _spliteInfo:SpliteListInfo;
      
      public function StoreIISplitBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIISplitBG.SplitBg");
         addChild(this._bg);
         this._splitTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.SplitBtn");
         addChild(this._splitTitle);
         this._splitBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIISplitBG.SplitBtn");
         addChild(this._splitBtn);
         this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
         this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
         addChild(this._neededGoldTipText);
         this._gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
         addChild(this._gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
         addChild(this._goldIcon);
         PositionUtils.setPos(this._neededGoldTipText,"asset.ddtstore.splitMoneyPos1");
         PositionUtils.setPos(this._gold_txt,"asset.ddtstore.splitMoneyPos2");
         PositionUtils.setPos(this._goldIcon,"asset.ddtstore.splitMoneyPos3");
         this._cells = [];
         this._mainCellArray = new Array();
         this.getCellsPoint();
         this.intItems();
         this._area = new StoreDragInArea(this._mainCellArray);
         addChildAt(this._area,0);
         this.hide();
      }
      
      private function intItems() : void
      {
         var _loc2_:SplitMaterialCell = null;
         this._mainCell = new SplitItemCell(0);
         this._mainCellPos = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIISplitBG.SplitMainpoint");
         PositionUtils.setPos(this._mainCell,this._mainCellPos);
         addChild(this._mainCell);
         this._mainCellArray.push(this._mainCell);
         var _loc1_:int = 0;
         while(_loc1_ < CELL_COUNT)
         {
            _loc2_ = new SplitMaterialCell();
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
            _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIISplitBG.Splitpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this._splitBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
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
         this._spliteInfo = ItemManager.Instance.getSpliteInfoByID(_loc3_.TemplateID);
         if(this._spliteInfo)
         {
            SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,BagInfo.STOREBAG,_loc2_,_loc3_.Count,true);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.cannotSplit"));
         }
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:int = int(param1[0]);
         var _loc3_:InventoryItemInfo = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
         if(_loc3_)
         {
            this._spliteInfo = ItemManager.Instance.getSpliteInfoByID(_loc3_.TemplateID);
            this._mainCell.info = _loc3_;
         }
         else
         {
            this._mainCell.info = null;
         }
         this.updateData();
      }
      
      public function updateData() : void
      {
         this.clearCellsInfo();
         if(this._mainCell.info && this._spliteInfo)
         {
            this._gold_txt.text = this._spliteInfo.NeedGold.toString();
            if(this._spliteInfo.Material1ID != 0)
            {
               this._cells[0].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material1ID);
               this._cells[0].count = this._spliteInfo.SplitCount1;
            }
            if(this._spliteInfo.Material2ID != 0)
            {
               this._cells[1].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material2ID);
               this._cells[1].count = this._spliteInfo.SplitCount2;
            }
            if(this._spliteInfo.Material3ID != 0)
            {
               this._cells[2].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material3ID);
               this._cells[2].count = this._spliteInfo.SplitCount3;
            }
            if(this._spliteInfo.Material4ID != 0)
            {
               this._cells[3].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material4ID);
               this._cells[3].count = this._spliteInfo.SplitCount4;
            }
         }
      }
      
      private function clearCellsInfo() : void
      {
         var _loc1_:SplitMaterialCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = null;
            _loc1_.count = 0;
         }
         this._gold_txt.text = "0";
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function show() : void
      {
         this.visible = true;
         this._mainCell.info = null;
         this.updateData();
      }
      
      private function removeEvent() : void
      {
         this._splitBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_SPLITE,this.__spliteResponse);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._splitTitle)
         {
            ObjectUtils.disposeObject(this._splitTitle);
         }
         this._splitTitle = null;
         if(this._splitBtn)
         {
            ObjectUtils.disposeObject(this._splitBtn);
         }
         this._splitBtn = null;
         if(this._area)
         {
            this._area.dispose();
         }
         this._area = null;
         if(this._goldIcon)
         {
            ObjectUtils.disposeObject(this._goldIcon);
         }
         this._goldIcon = null;
         if(this._neededGoldTipText)
         {
            ObjectUtils.disposeObject(this._neededGoldTipText);
         }
         this._neededGoldTipText = null;
         if(this._gold_txt)
         {
            ObjectUtils.disposeObject(this._gold_txt);
         }
         this._gold_txt = null;
         while(this._cells.length > 0)
         {
            ObjectUtils.disposeObject(this._cells.shift());
         }
         this._cells = null;
         while(this._mainCellArray.length > 0)
         {
            ObjectUtils.disposeObject(this._mainCellArray.shift());
         }
         this._mainCellArray = null;
         this._pointArray.length = 0;
         this._pointArray = null;
         this._spliteInfo = null;
         this._mainCell = null;
         this._mainCellPos = null;
      }
      
      public function openHelp() : void
      {
      }
   }
}
