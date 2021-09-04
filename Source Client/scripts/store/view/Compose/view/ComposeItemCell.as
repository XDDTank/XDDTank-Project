package store.view.Compose.view
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import store.StoreCell;
   
   public class ComposeItemCell extends StoreCell
   {
       
      
      public function ComposeItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
         setContentSize(68,68);
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:InventoryItemInfo = null;
         if(param1)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(param1.TemplateID);
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = _loc2_.TemplateID;
            ItemManager.fill(_loc3_);
            _loc3_.IsBinds = true;
            super.info = _loc3_;
            _tbxCount.visible = false;
         }
         else
         {
            super.info = param1;
         }
      }
      
      override public function seteuipQualityBg(param1:int) : void
      {
         if(_euipQualityBg == null)
         {
            _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            _euipQualityBg.width = 68;
            _euipQualityBg.height = 68;
            _euipQualityBg.x = -3;
            _euipQualityBg.y = -3;
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
      
      override protected function initEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
         addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
      }
      
      override public function dragStart() : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
