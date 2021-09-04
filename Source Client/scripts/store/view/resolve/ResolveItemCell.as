package store.view.resolve
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   import store.view.StoneCellFrame;
   
   public class ResolveItemCell extends StoreCell
   {
      
      public static const CONTENTSIZE:int = 77;
      
      public static const PICPOS:int = 25;
       
      
      private var _cellBg:StoneCellFrame;
      
      public function ResolveItemCell(param1:int)
      {
         this._cellBg = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIResolveBG.EquipmentCell");
         this._cellBg.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         super(this._cellBg,param1);
         setContentSize(CONTENTSIZE,CONTENTSIZE);
         PicPos = new Point(PICPOS,PICPOS);
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = _contentWidth - 18;
            param1.height = _contentHeight - 18;
            if(_picPos != null)
            {
               param1.x = _picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               param1.y = _picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - _contentHeight) / 2;
            }
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,_loc2_.Count,true);
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._cellBg)
         {
            ObjectUtils.disposeObject(this._cellBg);
         }
         this._cellBg = null;
      }
   }
}
