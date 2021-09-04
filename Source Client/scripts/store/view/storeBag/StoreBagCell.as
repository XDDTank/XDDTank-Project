package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import store.StoreController;
   import store.events.StoreDargEvent;
   import store.events.StoreIIEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class StoreBagCell extends BagCell
   {
       
      
      private var _light:Boolean;
      
      public function StoreBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Sprite = null)
      {
         super(param1,param2,param3,Boolean(param4) ? param4 : ComponentFactory.Instance.creatComponentByStylename("core.ddtStore.bagCellBgAsset"));
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         super.info = param1;
         if(info == null)
         {
            _loc2_ = null;
            this.initeuipQualityBg(0);
         }
         if(info != null)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
         }
         if(_loc2_ != null && info.Property8 == "0")
         {
            this.initeuipQualityBg(_loc2_.QualityID);
         }
         updateCount();
      }
      
      private function initeuipQualityBg(param1:int) : void
      {
         if(_euipQualityBg == null)
         {
            _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            _euipQualityBg.width = 45;
            _euipQualityBg.height = 45;
         }
         if(param1 == 0)
         {
            _euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(!this.checkBagType(_loc2_))
         {
            return;
         }
         SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,bagType,this.getPlace(_loc2_),1);
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,true))
            {
               locked = true;
               dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.START_DARG,true));
            }
            if(StoreController.instance.transform)
            {
               StoreController.instance.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT,StoreController.instance.transform,false));
            }
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
            BaglockedManager.Instance.show();
            dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
            return;
         }
         if(param1.action == DragEffect.MOVE && param1.target == null)
         {
            locked = false;
            sellItem();
         }
         else if(param1.action == DragEffect.SPLIT && param1.target == null)
         {
            locked = false;
         }
         else
         {
            super.dragStop(param1);
         }
         if(this.info)
         {
            if(SavePointManager.Instance.isInSavePoint(67) && !TaskManager.instance.isNewHandTaskCompleted(28))
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            }
         }
         if(StoreController.instance.isShine)
         {
            StoreController.instance.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT,StoreController.instance.transform,true));
         }
         dispatchEvent(new StoreDargEvent(this.info,StoreDargEvent.STOP_DARG,true));
      }
      
      private function getPlace(param1:InventoryItemInfo) : int
      {
         return -1;
      }
      
      private function checkBagType(param1:InventoryItemInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.BagType == bagType)
         {
            return false;
         }
         if(bagType == BagInfo.EQUIPBAG)
         {
            return true;
         }
         return false;
      }
      
      public function set light(param1:Boolean) : void
      {
         this._light = param1;
         if(param1)
         {
            this.showEffect();
         }
         else
         {
            this.hideEffect();
         }
      }
      
      public function get light() : Boolean
      {
         return this._light;
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3,
               "inner":true
            }
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
      }
      
      override public function dispose() : void
      {
         TweenMax.killChildTweensOf(this.parent,false);
         this.filters = null;
         super.dispose();
      }
   }
}
