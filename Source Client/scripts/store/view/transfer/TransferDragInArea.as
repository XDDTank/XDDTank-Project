package store.view.transfer
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class TransferDragInArea extends Sprite implements IAcceptDrag
   {
      
      public static const RECTWIDTH:int = 345;
      
      public static const RECTHEIGHT:int = 360;
       
      
      private var _cells:Vector.<TransferItemCell>;
      
      public function TransferDragInArea(param1:Vector.<TransferItemCell>)
      {
         super();
         this._cells = param1;
         graphics.beginFill(255,0);
         graphics.drawRect(0,0,RECTWIDTH,RECTHEIGHT);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:EquipmentTemplateInfo = null;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc6_:EquipmentTemplateInfo = null;
         var _loc7_:EquipmentTemplateInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            _loc3_ = false;
            if(this._cells[0].info == null)
            {
               if(this._cells[1].info)
               {
                  _loc4_ = ItemManager.Instance.getEquipTemplateById(param1.data.TemplateID);
                  _loc5_ = ItemManager.Instance.getEquipTemplateById(this._cells[1].info.TemplateID);
                  if(_loc4_.TemplateType != _loc5_.TemplateType)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                     DragManager.acceptDrag(this);
                     return;
                  }
               }
               this._cells[0].dragDrop(param1);
            }
            else if(this._cells[1].info == null)
            {
               if(this._cells[0])
               {
                  _loc6_ = ItemManager.Instance.getEquipTemplateById(param1.data.TemplateID);
                  _loc7_ = ItemManager.Instance.getEquipTemplateById(this._cells[0].info.TemplateID);
                  if(_loc7_.TemplateType != _loc6_.TemplateType)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                     DragManager.acceptDrag(this);
                     return;
                  }
               }
               this._cells[1].dragDrop(param1);
            }
            else
            {
               _loc3_ = true;
            }
            if(param1.target == null)
            {
               if(!_loc3_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.info"));
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      public function dispose() : void
      {
         this._cells = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
