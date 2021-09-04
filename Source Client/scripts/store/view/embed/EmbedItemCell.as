package store.view.embed
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   import store.events.EmbedEvent;
   
   public class EmbedItemCell extends StoreCell
   {
       
      
      public function EmbedItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
         setContentSize(68,68);
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
      }
      
      override public function seteuipQualityBg(param1:int) : void
      {
         super.seteuipQualityBg(param1);
         _euipQualityBg.x = -3;
         _euipQualityBg.y = -3;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
         dispatchEvent(new EmbedEvent(EmbedEvent.MOVE,_loc2_));
      }
      
      override public function get shinerPos() : Point
      {
         return _shinerPos;
      }
      
      override public function set shinerPos(param1:Point) : void
      {
         _shinerPos = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
