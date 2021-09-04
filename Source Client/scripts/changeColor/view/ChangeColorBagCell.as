package changeColor.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ChangeColorBagCell extends BagCell
   {
       
      
      public function ChangeColorBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Sprite = null)
      {
         super(param1,param2,param3,Boolean(param4) ? param4 : ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset"));
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(locked)
            {
               if(_loc2_ == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}
